Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5AA1BA7BA
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 17:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgD0PSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 11:18:25 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:39965 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726539AbgD0PSY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 11:18:24 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 21025194022C;
        Mon, 27 Apr 2020 11:18:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 27 Apr 2020 11:18:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=jJlhqs
        U7F+B4MrTy0dIa8L1RyEYSMHYpqvZoPrTcRak=; b=qUqnnv4wEChbLR/9TRofHK
        LZmgjS9nWQCL/4benhfAsMzXQWhrWgYokAHgdTz5htMHqWRdaKVHT3wZkRjqSE/p
        dXTHzetWuExX+bjbR2krEfqcft840w8ssHO/6X7zAx+afb6y3tsuv9/e44n6onr3
        ky6AjuJlDVkFN0IhH65K/iNFdKRjhANsH745J258eMGzS7iUuAyf2GqRYL7TjX0K
        18mLtOWygmDPZdwmqCSaxrxmW/9DdRr7sfiV/WmH/cuoDbvO4CoPjLzLq7DCXfQq
        wIP5Fj4KJne/0lqNQ5YnwZThyAPnK0HsOfBx0hBaPUMLIVq3bzcaIMhAj8XvZ1jA
        ==
X-ME-Sender: <xms:vvemXjxuBUVuClLB9FMazRAp9eBFA9DfCrpQ0M5aHJTQuNTn_AQqBA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdekhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:vvemXpvoGj6ByCWue92hSZwE3aAIg4hNKE6m6riTUkQZDH6hcOOp7w>
    <xmx:vvemXkfTwHalHklIz1YKI6EaOI3yug05eKnqpVeJgm7D8AaUlEEVJA>
    <xmx:vvemXhF0mte8FiQKQhptKLuaVJaNPoErVE-eAKa2M70Nyh2HiNQRTg>
    <xmx:v_emXghTRINFtcJ7ENoAvUMXoaJBiFc_JTlbsGIKG_VAv4b3l2ut8g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 675A43280063;
        Mon, 27 Apr 2020 11:18:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tpm: ibmvtpm: retry on H_CLOSED in tpm_ibmvtpm_send()" failed to apply to 4.4-stable tree
To:     gcwilson@linux.ibm.com, jarkko.sakkinen@linux.intel.com,
        phaml@us.ibm.com, stefanb@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Apr 2020 17:18:20 +0200
Message-ID: <1588000700181236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From eba5cf3dcb844c82f54d4a857e124824e252206d Mon Sep 17 00:00:00 2001
From: George Wilson <gcwilson@linux.ibm.com>
Date: Thu, 19 Mar 2020 23:27:58 -0400
Subject: [PATCH] tpm: ibmvtpm: retry on H_CLOSED in tpm_ibmvtpm_send()

tpm_ibmvtpm_send() can fail during PowerVM Live Partition Mobility resume
with an H_CLOSED return from ibmvtpm_send_crq().  The PAPR says, 'The
"partner partition suspended" transport event disables the associated CRQ
such that any H_SEND_CRQ hcall() to the associated CRQ returns H_Closed
until the CRQ has been explicitly enabled using the H_ENABLE_CRQ hcall.'
This patch adds a check in tpm_ibmvtpm_send() for an H_CLOSED return from
ibmvtpm_send_crq() and in that case calls tpm_ibmvtpm_resume() and
retries the ibmvtpm_send_crq() once.

Cc: stable@vger.kernel.org # 3.7.x
Fixes: 132f76294744 ("drivers/char/tpm: Add new device driver to support IBM vTPM")
Reported-by: Linh Pham <phaml@us.ibm.com>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: George Wilson <gcwilson@linux.ibm.com>
Tested-by: Linh Pham <phaml@us.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 1a49db9e108e..09fe45246b8c 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (C) 2012 IBM Corporation
+ * Copyright (C) 2012-2020 IBM Corporation
  *
  * Author: Ashley Lai <ashleydlai@gmail.com>
  *
@@ -134,6 +134,64 @@ static int tpm_ibmvtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	return len;
 }
 
+/**
+ * ibmvtpm_crq_send_init - Send a CRQ initialize message
+ * @ibmvtpm:	vtpm device struct
+ *
+ * Return:
+ *	0 on success.
+ *	Non-zero on failure.
+ */
+static int ibmvtpm_crq_send_init(struct ibmvtpm_dev *ibmvtpm)
+{
+	int rc;
+
+	rc = ibmvtpm_send_crq_word(ibmvtpm->vdev, INIT_CRQ_CMD);
+	if (rc != H_SUCCESS)
+		dev_err(ibmvtpm->dev,
+			"%s failed rc=%d\n", __func__, rc);
+
+	return rc;
+}
+
+/**
+ * tpm_ibmvtpm_resume - Resume from suspend
+ *
+ * @dev:	device struct
+ *
+ * Return: Always 0.
+ */
+static int tpm_ibmvtpm_resume(struct device *dev)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+	struct ibmvtpm_dev *ibmvtpm = dev_get_drvdata(&chip->dev);
+	int rc = 0;
+
+	do {
+		if (rc)
+			msleep(100);
+		rc = plpar_hcall_norets(H_ENABLE_CRQ,
+					ibmvtpm->vdev->unit_address);
+	} while (rc == H_IN_PROGRESS || rc == H_BUSY || H_IS_LONG_BUSY(rc));
+
+	if (rc) {
+		dev_err(dev, "Error enabling ibmvtpm rc=%d\n", rc);
+		return rc;
+	}
+
+	rc = vio_enable_interrupts(ibmvtpm->vdev);
+	if (rc) {
+		dev_err(dev, "Error vio_enable_interrupts rc=%d\n", rc);
+		return rc;
+	}
+
+	rc = ibmvtpm_crq_send_init(ibmvtpm);
+	if (rc)
+		dev_err(dev, "Error send_init rc=%d\n", rc);
+
+	return rc;
+}
+
 /**
  * tpm_ibmvtpm_send() - Send a TPM command
  * @chip:	tpm chip struct
@@ -147,6 +205,7 @@ static int tpm_ibmvtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 static int tpm_ibmvtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
 {
 	struct ibmvtpm_dev *ibmvtpm = dev_get_drvdata(&chip->dev);
+	bool retry = true;
 	int rc, sig;
 
 	if (!ibmvtpm->rtce_buf) {
@@ -180,18 +239,27 @@ static int tpm_ibmvtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
 	 */
 	ibmvtpm->tpm_processing_cmd = true;
 
+again:
 	rc = ibmvtpm_send_crq(ibmvtpm->vdev,
 			IBMVTPM_VALID_CMD, VTPM_TPM_COMMAND,
 			count, ibmvtpm->rtce_dma_handle);
 	if (rc != H_SUCCESS) {
+		/*
+		 * H_CLOSED can be returned after LPM resume.  Call
+		 * tpm_ibmvtpm_resume() to re-enable the CRQ then retry
+		 * ibmvtpm_send_crq() once before failing.
+		 */
+		if (rc == H_CLOSED && retry) {
+			tpm_ibmvtpm_resume(ibmvtpm->dev);
+			retry = false;
+			goto again;
+		}
 		dev_err(ibmvtpm->dev, "tpm_ibmvtpm_send failed rc=%d\n", rc);
-		rc = 0;
 		ibmvtpm->tpm_processing_cmd = false;
-	} else
-		rc = 0;
+	}
 
 	spin_unlock(&ibmvtpm->rtce_lock);
-	return rc;
+	return 0;
 }
 
 static void tpm_ibmvtpm_cancel(struct tpm_chip *chip)
@@ -269,26 +337,6 @@ static int ibmvtpm_crq_send_init_complete(struct ibmvtpm_dev *ibmvtpm)
 	return rc;
 }
 
-/**
- * ibmvtpm_crq_send_init - Send a CRQ initialize message
- * @ibmvtpm:	vtpm device struct
- *
- * Return:
- *	0 on success.
- *	Non-zero on failure.
- */
-static int ibmvtpm_crq_send_init(struct ibmvtpm_dev *ibmvtpm)
-{
-	int rc;
-
-	rc = ibmvtpm_send_crq_word(ibmvtpm->vdev, INIT_CRQ_CMD);
-	if (rc != H_SUCCESS)
-		dev_err(ibmvtpm->dev,
-			"ibmvtpm_crq_send_init failed rc=%d\n", rc);
-
-	return rc;
-}
-
 /**
  * tpm_ibmvtpm_remove - ibm vtpm remove entry point
  * @vdev:	vio device struct
@@ -401,44 +449,6 @@ static int ibmvtpm_reset_crq(struct ibmvtpm_dev *ibmvtpm)
 				  ibmvtpm->crq_dma_handle, CRQ_RES_BUF_SIZE);
 }
 
-/**
- * tpm_ibmvtpm_resume - Resume from suspend
- *
- * @dev:	device struct
- *
- * Return: Always 0.
- */
-static int tpm_ibmvtpm_resume(struct device *dev)
-{
-	struct tpm_chip *chip = dev_get_drvdata(dev);
-	struct ibmvtpm_dev *ibmvtpm = dev_get_drvdata(&chip->dev);
-	int rc = 0;
-
-	do {
-		if (rc)
-			msleep(100);
-		rc = plpar_hcall_norets(H_ENABLE_CRQ,
-					ibmvtpm->vdev->unit_address);
-	} while (rc == H_IN_PROGRESS || rc == H_BUSY || H_IS_LONG_BUSY(rc));
-
-	if (rc) {
-		dev_err(dev, "Error enabling ibmvtpm rc=%d\n", rc);
-		return rc;
-	}
-
-	rc = vio_enable_interrupts(ibmvtpm->vdev);
-	if (rc) {
-		dev_err(dev, "Error vio_enable_interrupts rc=%d\n", rc);
-		return rc;
-	}
-
-	rc = ibmvtpm_crq_send_init(ibmvtpm);
-	if (rc)
-		dev_err(dev, "Error send_init rc=%d\n", rc);
-
-	return rc;
-}
-
 static bool tpm_ibmvtpm_req_canceled(struct tpm_chip *chip, u8 status)
 {
 	return (status == 0);

