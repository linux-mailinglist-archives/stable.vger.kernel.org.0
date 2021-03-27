Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A77E034B77A
	for <lists+stable@lfdr.de>; Sat, 27 Mar 2021 15:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbhC0OG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Mar 2021 10:06:56 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:35313 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229901AbhC0OGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Mar 2021 10:06:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 345841614;
        Sat, 27 Mar 2021 10:06:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 27 Mar 2021 10:06:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=rvy+Hc
        3cZs+l70iMjYLL/kBtIy4fLUxTUAeoeMrGT64=; b=sYbd32OWfT80vZHWBp63hn
        lk1qDmLlUnntnGyGGNBrE9nLZ+5iGRkqxy/Jq+ZlQ7tXB8elvJ+mwyUoIYDgs3Hg
        MuwR9Mu05vrZATG6e/VtXlxI/T45MosExWO5USIup0Y1dpgpXRVijNm5bKGv5RJN
        M995n33xatB5IdZl3tuNCz2fM9ntMPa1nERFADyow+lZu+gm8H3t/O40MPW+j0VM
        GiWWia+pEnXIZT0UzfdtKpKxkqv/oPEObE8i6KG/MO1jlO0YnLYL7mOMTv57rN4T
        G05cHiH+6TZWD6PU5q4EDF6133/7y4o+tm6EzvYjwoSKOG0X/+IoPY9E6gqYeeLA
        ==
X-ME-Sender: <xms:9ztfYNbSkuc8wL7YUdTwZ1PeLqrAN3eX2wrUHrSNCrgJcwp6jId0Cw>
    <xme:9ztfYEYlLrwKrCD3YLD2rwtGXsbxBFJ5oQ9PYYwaNgXzO8iQPHd4jxPjyVhBiIr-x
    sKfCYhtHutKFA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehgedgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:9ztfYP8aC520jLmEW4aznwO7fu_qEdGZ-84upPGvQnEzJH5WUZJRWg>
    <xmx:9ztfYLoE8yFUZBntcg_j3lTL8_KYnXwM4sfxULBkV5Gaac78wZj37g>
    <xmx:9ztfYIrjc67dHe6VI-v0tMa4l7AH4hk4NRgptadechDCYbI4r5IDFQ>
    <xmx:9ztfYPT4WpTEW_DCBampknD0Hs77vnVCc3jLxsl7gVJVf4Xk7isoMRLWRNY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id BC109108005C;
        Sat, 27 Mar 2021 10:06:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ACPI: scan: Use unique number for instance_no" failed to apply to 5.10-stable tree
To:     andriy.shevchenko@linux.intel.com, rafael.j.wysocki@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 27 Mar 2021 15:06:44 +0100
Message-ID: <1616854004209105@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From eb50aaf960e3bedfef79063411ffd670da94b84b Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Mon, 22 Mar 2021 18:31:00 +0200
Subject: [PATCH] ACPI: scan: Use unique number for instance_no

The decrementation of acpi_device_bus_id->instance_no
in acpi_device_del() is incorrect, because it may cause
a duplicate instance number to be allocated next time
a device with the same acpi_device_bus_id is added.

Replace above mentioned approach by using IDA framework.

While at it, define the instance range to be [0, 4096).

Fixes: e49bd2dd5a50 ("ACPI: use PNPID:instance_no as bus_id of ACPI device")
Fixes: ca9dc8d42b30 ("ACPI / scan: Fix acpi_bus_id_list bookkeeping")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: 4.10+ <stable@vger.kernel.org> # 4.10+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index e6a5d997241c..cb8f70842249 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -9,6 +9,8 @@
 #ifndef _ACPI_INTERNAL_H_
 #define _ACPI_INTERNAL_H_
 
+#include <linux/idr.h>
+
 #define PREFIX "ACPI: "
 
 int early_acpi_osi_init(void);
@@ -96,9 +98,11 @@ void acpi_scan_table_handler(u32 event, void *table, void *context);
 
 extern struct list_head acpi_bus_id_list;
 
+#define ACPI_MAX_DEVICE_INSTANCES	4096
+
 struct acpi_device_bus_id {
 	const char *bus_id;
-	unsigned int instance_no;
+	struct ida instance_ida;
 	struct list_head node;
 };
 
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index a184529d8fa4..84bb7c1929f1 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -479,9 +479,8 @@ static void acpi_device_del(struct acpi_device *device)
 	list_for_each_entry(acpi_device_bus_id, &acpi_bus_id_list, node)
 		if (!strcmp(acpi_device_bus_id->bus_id,
 			    acpi_device_hid(device))) {
-			if (acpi_device_bus_id->instance_no > 0)
-				acpi_device_bus_id->instance_no--;
-			else {
+			ida_simple_remove(&acpi_device_bus_id->instance_ida, device->pnp.instance_no);
+			if (ida_is_empty(&acpi_device_bus_id->instance_ida)) {
 				list_del(&acpi_device_bus_id->node);
 				kfree_const(acpi_device_bus_id->bus_id);
 				kfree(acpi_device_bus_id);
@@ -631,6 +630,21 @@ static struct acpi_device_bus_id *acpi_device_bus_id_match(const char *dev_id)
 	return NULL;
 }
 
+static int acpi_device_set_name(struct acpi_device *device,
+				struct acpi_device_bus_id *acpi_device_bus_id)
+{
+	struct ida *instance_ida = &acpi_device_bus_id->instance_ida;
+	int result;
+
+	result = ida_simple_get(instance_ida, 0, ACPI_MAX_DEVICE_INSTANCES, GFP_KERNEL);
+	if (result < 0)
+		return result;
+
+	device->pnp.instance_no = result;
+	dev_set_name(&device->dev, "%s:%02x", acpi_device_bus_id->bus_id, result);
+	return 0;
+}
+
 int acpi_device_add(struct acpi_device *device,
 		    void (*release)(struct device *))
 {
@@ -665,7 +679,9 @@ int acpi_device_add(struct acpi_device *device,
 
 	acpi_device_bus_id = acpi_device_bus_id_match(acpi_device_hid(device));
 	if (acpi_device_bus_id) {
-		acpi_device_bus_id->instance_no++;
+		result = acpi_device_set_name(device, acpi_device_bus_id);
+		if (result)
+			goto err_unlock;
 	} else {
 		acpi_device_bus_id = kzalloc(sizeof(*acpi_device_bus_id),
 					     GFP_KERNEL);
@@ -681,9 +697,16 @@ int acpi_device_add(struct acpi_device *device,
 			goto err_unlock;
 		}
 
+		ida_init(&acpi_device_bus_id->instance_ida);
+
+		result = acpi_device_set_name(device, acpi_device_bus_id);
+		if (result) {
+			kfree(acpi_device_bus_id);
+			goto err_unlock;
+		}
+
 		list_add_tail(&acpi_device_bus_id->node, &acpi_bus_id_list);
 	}
-	dev_set_name(&device->dev, "%s:%02x", acpi_device_bus_id->bus_id, acpi_device_bus_id->instance_no);
 
 	if (device->parent)
 		list_add_tail(&device->node, &device->parent->children);
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 02a716a0af5d..f28b097c658f 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -233,6 +233,7 @@ struct acpi_pnp_type {
 
 struct acpi_device_pnp {
 	acpi_bus_id bus_id;		/* Object name */
+	int instance_no;		/* Instance number of this object */
 	struct acpi_pnp_type type;	/* ID type */
 	acpi_bus_address bus_address;	/* _ADR */
 	char *unique_id;		/* _UID */

