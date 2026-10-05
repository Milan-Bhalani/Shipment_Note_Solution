# Shipment Note Solution

## Overview

The **Shipment Note Solution** is a Microsoft Dynamics 365 Business Central extension that introduces a basic Shipment Note management functionality and adds a Shipment Note requirement flag to Sales Orders.

The solution provides the following functionality:

* Shipment Note Setup for configuring the Shipment Note number series.
* Automatic numbering of Shipment Notes.
* Shipment Note master records with basic information.
* Shipment Note status management.
* Linking a Shipment Note to a Sales Order.
* A **Shipment Note Required** checkbox on Sales Orders.
* Validation to prevent direct status change from **Draft** to **Released**.
* Validation to prevent posting a Sales Order when **Shipment Note Required** is enabled.

> **Important:** The current implementation only checks whether the **Shipment Note Required** checkbox is enabled on the Sales Order. It does **not** validate whether a Shipment Note exists, is approved, or is released for the Sales Order before posting. Therefore, enabling the checkbox will always prevent Sales Order posting.

---

# Functionality

## 1. Shipment Note Setup

The **Shipment Note Setup** page is used to configure the number series that will be used when creating Shipment Notes.

The setup table is designed as a singleton setup table, meaning that only one setup record is maintained.

### Setup Field

| Field              | Description                                                                      |
| ------------------ | -------------------------------------------------------------------------------- |
| Shipment Note Nos. | Specifies the No. Series used to automatically assign numbers to Shipment Notes. |

The setup page automatically creates the setup record when the page is opened for the first time.

### Page

**Shipment Note Setup**

### Navigation

Open Business Central and search for:

> Shipment Note Setup

The page is available under the administration-related pages because it has an `UsageCategory` of `Administration`.

---

# Initial Setup

Before creating any Shipment Note, the Shipment Note number series must be configured.

Follow these steps:

### Step 1: Create a No. Series

1. Search for **No. Series** in Business Central.
2. Create a new No. Series for Shipment Notes.
3. Define the required number series code.
4. Configure the starting number and other No. Series settings according to your organization's requirements.

For example:

```text
Code: SHIPNOTE
Description: Shipment Note Numbers
Starting No.: SN000001
```

The exact number series configuration can be different depending on the customer's requirements.

### Step 2: Configure Shipment Note Setup

1. Search for **Shipment Note Setup**.
2. Open the setup page.
3. Select the No. Series created for Shipment Notes in the **Shipment Note Nos.** field.
4. Close the page.

The setup is now complete.

---

# Creating a Shipment Note

Once the Shipment Note Setup has been configured, users can create Shipment Notes.

When a new Shipment Note is created, the system automatically assigns the next available number from the configured Shipment Note No. Series.

### Shipment Note Fields

| Field            | Description                                                                         |
| ---------------- | ----------------------------------------------------------------------------------- |
| No.              | Unique Shipment Note number automatically generated from the configured No. Series. |
| Description      | Description of the Shipment Note.                                                   |
| Status           | Current status of the Shipment Note.                                                |
| Posting Date     | Posting date associated with the Shipment Note.                                     |
| Sales Header No. | Sales Order number related to the Shipment Note.                                    |

The **No.** field is automatically generated and cannot be manually edited from the Shipment Note page.

### Creating a Shipment Note

1. Open the **Shipment Note** page.
2. Create a new record.
3. The system checks whether Shipment Note Setup exists.
4. The system checks whether **Shipment Note Nos.** has been configured.
5. The next available number is automatically assigned.
6. Enter the required Shipment Note information.
7. Select the related Sales Order in **Sales Header No.**
8. Set the required status.

### Setup Validation

If the Shipment Note Setup has not been configured, the system displays:

> Shipment Note Setup must be configured before creating a Shipment Note.

If the setup exists but the Shipment Note No. Series is not configured, the system prevents creation because the **Shipment Note Nos.** field is mandatory through `TestField`.

---

# Shipment Note Status

Shipment Notes use the following status values:

| Status   | Description                                                      |
| -------- | ---------------------------------------------------------------- |
| Draft    | Initial status for a Shipment Note that is still being prepared. |
| Pending  | Shipment Note is pending further processing or approval.         |
| Approved | Shipment Note has been approved.                                 |
| Released | Shipment Note has been released.                                 |

The status is implemented using the `MBS Shipment Note Status` enum.

The enum is currently marked as:

```al
Extensible = false;
```

Therefore, additional status values cannot currently be added by extending the enum.

---

# Status Validation

The solution includes a validation rule that prevents a Shipment Note from being changed directly from **Draft** to **Released**.

The following transition is not allowed:

```text
Draft → Released
```

If a user attempts this direct transition, the following error is displayed:

> A Shipment Note cannot be changed directly from Draft to Released.

For example, the following status change is blocked:

```text
Draft
  ↓
Released
```

The intended workflow can instead use intermediate statuses, for example:

```text
Draft
  ↓
Pending
  ↓
Approved
  ↓
Released
```

However, the current code only explicitly blocks the **Draft → Released** transition. It does not enforce the complete workflow shown above.

For example, the current implementation does not prevent:

* Draft → Approved
* Pending → Released
* Draft → Pending
* Approved → Released

Therefore, if a strict status workflow is required, additional validation logic would need to be implemented.

---

# Sales Order Integration

The solution extends the standard Business Central **Sales Header** table with a new Boolean field:

**Shipment Note Required**

This field is available on Sales Orders.

### Field Behavior

| Value | Meaning                                |
| ----- | -------------------------------------- |
| No    | Shipment Note Required is not enabled. |
| Yes   | Shipment Note Required is enabled.     |

The field is added to the **General** section of the standard **Sales Order** page.

Users can enable or disable this option directly from the Sales Order.

---

# Sales Order Posting Restriction

An event subscriber is implemented against the standard Business Central **Sales-Post** codeunit.

The subscriber listens to the `OnBeforePostSalesDoc` event.

Before a Sales Order is posted, the system checks the value of:

```text
Shipment Note Required
```

If the field is enabled, the posting process is stopped and the following error is displayed:

> The sales order cannot be posted because Shipment Note Required is enabled.

### Current Posting Logic

The current implementation effectively works as follows:

```text
Sales Order
    |
    v
Is "Shipment Note Required" enabled?
    |
    +---- No ----> Sales Order can continue posting
    |
    +---- Yes ---> Posting is blocked
```

## Important Functional Limitation

The current code does **not** check for an actual Shipment Note.

For example, the following scenario will still be blocked:

```text
Sales Order
Shipment Note Required = Yes
Shipment Note exists = Yes
Shipment Note Status = Released
```

The Sales Order will still be prevented from posting because the event subscriber only checks the Boolean field.

Similarly, the system does not currently verify:

* Whether a Shipment Note has been created.
* Whether the Shipment Note is linked to the Sales Order.
* Whether the linked Shipment Note is Approved.
* Whether the linked Shipment Note is Released.
* Whether multiple Shipment Notes exist for the Sales Order.

Therefore, the current functionality should be understood as a **simple posting block based on the Sales Order checkbox**, rather than a complete Shipment Note approval/release workflow.

---

# Recommended Business Process

Based on the current implementation, the basic process is:

```text
1. Configure Shipment Note No. Series
             |
             v
2. Configure Shipment Note Setup
             |
             v
3. Create Sales Order
             |
             v
4. Enable "Shipment Note Required"
             |
             v
5. Create Shipment Note
             |
             v
6. Enter Shipment Note details
             |
             v
7. Link Shipment Note to Sales Order
             |
             v
8. Manage Shipment Note Status
```

However, with the current code, the Sales Order cannot be posted once **Shipment Note Required** is enabled.

Therefore, if the intended business process is:

```text
Sales Order
    ↓
Shipment Note Required = Yes
    ↓
Create Shipment Note
    ↓
Shipment Note Approval
    ↓
Shipment Note Released
    ↓
Post Sales Order
```

then additional development is required to make the Sales Order posting validation check the related Shipment Note and its status.

---

# Technical Object List

The extension contains the following main objects:

| Object Type     | Object ID | Object Name                  | Purpose                                                  |
| --------------- | --------: | ---------------------------- | -------------------------------------------------------- |
| Table           |     50100 | MBS Shipment Note Setup      | Stores Shipment Note setup information.                  |
| Table           |     50101 | MBS Shipment Note            | Stores Shipment Note header information.                 |
| Table Extension |     50100 | MBS Sales Header Ext         | Adds Shipment Note Required to Sales Header.             |
| Page            |     50100 | MBS Shipment Note Setup      | Maintains Shipment Note setup.                           |
| Page            |     50101 | MBS Shipment Note            | Creates and maintains Shipment Notes.                    |
| Page Extension  |     50100 | MBS Sales Order Ext          | Displays Shipment Note Required on Sales Orders.         |
| Codeunit        |     50100 | MBS Shipment Note Sales Post | Prevents posting when Shipment Note Required is enabled. |
| Enum            |     50100 | MBS Shipment Note Status     | Defines Shipment Note statuses.                          |

---

# Object Dependencies

The functionality relies on standard Business Central functionality for:

* No. Series management.
* Sales Header and Sales Order.
* Sales Order posting.
* Sales-Post codeunit.
* No. Series codeunit.

The extension does not define any external application dependencies in `app.json`.

---

# User Guide

## Administrator

The administrator should perform the following setup:

1. Create a Shipment Note No. Series.
2. Open **Shipment Note Setup**.
3. Select the Shipment Note No. Series.
4. Save the setup.

This setup is required before users can create Shipment Notes.

---

## End User

A user can:

1. Create or open a Sales Order.
2. Enable **Shipment Note Required** if required.
3. Create a Shipment Note.
4. Enter the Shipment Note description.
5. Enter the Posting Date.
6. Select the related Sales Order.
7. Manage the Shipment Note status.

### Important

If **Shipment Note Required** is enabled on a Sales Order, the Sales Order cannot currently be posted.

The current solution does not automatically connect the existence or status of a Shipment Note to the Sales Order posting process.

---

# Error Messages

The solution contains the following validation messages.

### Missing Setup

```text
Shipment Note Setup must be configured before creating a Shipment Note.
```

**Cause:** Shipment Note Setup record does not exist.

**Resolution:** Open Shipment Note Setup and configure the Shipment Note No. Series.

---

### Missing No. Series

The Shipment Note creation process requires the **Shipment Note Nos.** field to be configured.

**Resolution:** Open Shipment Note Setup and select a valid No. Series.

---

### Invalid Status Transition

```text
A Shipment Note cannot be changed directly from Draft to Released.
```

**Cause:** User attempted to change a Shipment Note directly from Draft to Released.

**Resolution:** Change the Shipment Note to an intermediate status before setting it to Released.

---

### Sales Order Posting Blocked

```text
The sales order cannot be posted because Shipment Note Required is enabled.
```

**Cause:** The Sales Order has **Shipment Note Required** enabled.

**Resolution:** Currently, the checkbox must be disabled before the Sales Order can be posted. The existing implementation does not automatically validate whether a Shipment Note has been created or released.

---
