Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE97249FA1
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 15:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgHSNXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 09:23:48 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:48243 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728473AbgHSNXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 09:23:43 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 89F30C3C;
        Wed, 19 Aug 2020 09:23:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 09:23:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=GGxP2P
        qbCfStbJ1M6ThDuVhp1nXiBqerAhH5KQ1vr18=; b=iYUr9oOg+sTuKDAzX7gczo
        Fdv598qXBVeP3OWh50IdgICYvbvHzi0HhmXDE71dsgySDB/GuRpadYTrzqEJBErV
        1ntZtOW4U912AHzvIoEtA/bMc9IuTbfgMMgKgLqiNtJNRxfC/Hz0NLZPXTCXggIc
        2mzXrr0vVaMSlaTt4pYnMZkC8L3nKzt9pHmicOTV/VATfZiZPPDce3jgzgIxqF9Q
        jL/R8Fb3ndOIPuDHi/QZBR+cy+oRkfbe81ZyIlOI/cZ3iBdyy7ZvX8LnEvbLHqxk
        r6C8Bt+lVG2nqP7Ytsnbh1KDXj11s580RD3Gu89GPLcpiCGWP3ajH4AZSLq5d4Jw
        ==
X-ME-Sender: <xms:2Cc9XxCqPOwKyVFfCm6JECtSXpKodFSLsV1vn3K91X1tALLku_ctjw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:2Cc9X_jkVAV5R8qSc2yzKqUdWC8wl9MErHaPc-FlUP3vb7_IAhzecQ>
    <xmx:2Cc9X8ml3KYcsuADLy5SdgKQzKNOz3Y18CSJOSW-OUKcCGzSMoV5DQ>
    <xmx:2Cc9X7yYFLF3VG55eNTV7ab3MjcQgXobgkkL2TYvBGECMWko19Rdgg>
    <xmx:2Cc9X0ff7UuUnQvwvOYnZ8FSPFj1k8iDezPuxxudpOZ5ouS1W0qqeqtkBs4>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id AFABC30600B1;
        Wed, 19 Aug 2020 09:23:35 -0400 (EDT)
Subject: FAILED: patch "[PATCH] libnvdimm: Validate command family indices" failed to apply to 4.14-stable tree
To:     dan.j.williams@intel.com, dave.jiang@intel.com,
        ira.weiny@intel.com, lenb@kernel.org, rjw@rjwysocki.net,
        stable@vger.kernel.org, vishal.l.verma@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 15:23:56 +0200
Message-ID: <159784343621726@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 92fe2aa859f52ce6aa595ca97fec110dc7100e63 Mon Sep 17 00:00:00 2001
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 20 Jul 2020 15:07:30 -0700
Subject: [PATCH] libnvdimm: Validate command family indices

The ND_CMD_CALL format allows for a general passthrough of passlisted
commands targeting a given command set. However there is no validation
of the family index relative to what the bus supports.

- Update the NFIT bus implementation (the only one that supports
  ND_CMD_CALL passthrough) to also passlist the valid set of command
  family indices.

- Update the generic __nd_ioctl() path to validate that field on behalf
  of all implementations.

Fixes: 31eca76ba2fc ("nfit, libnvdimm: limited/whitelisted dimm command marshaling mechanism")
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 7c138a4edc03..1f72ce1a782b 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1823,6 +1823,7 @@ static void populate_shutdown_status(struct nfit_mem *nfit_mem)
 static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 		struct nfit_mem *nfit_mem, u32 device_handle)
 {
+	struct nvdimm_bus_descriptor *nd_desc = &acpi_desc->nd_desc;
 	struct acpi_device *adev, *adev_dimm;
 	struct device *dev = acpi_desc->dev;
 	unsigned long dsm_mask, label_mask;
@@ -1834,6 +1835,7 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 	/* nfit test assumes 1:1 relationship between commands and dsms */
 	nfit_mem->dsm_mask = acpi_desc->dimm_cmd_force_en;
 	nfit_mem->family = NVDIMM_FAMILY_INTEL;
+	set_bit(NVDIMM_FAMILY_INTEL, &nd_desc->dimm_family_mask);
 
 	if (dcr->valid_fields & ACPI_NFIT_CONTROL_MFG_INFO_VALID)
 		sprintf(nfit_mem->id, "%04x-%02x-%04x-%08x",
@@ -1886,10 +1888,13 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 	 * Note, that checking for function0 (bit0) tells us if any commands
 	 * are reachable through this GUID.
 	 */
+	clear_bit(NVDIMM_FAMILY_INTEL, &nd_desc->dimm_family_mask);
 	for (i = 0; i <= NVDIMM_FAMILY_MAX; i++)
-		if (acpi_check_dsm(adev_dimm->handle, to_nfit_uuid(i), 1, 1))
+		if (acpi_check_dsm(adev_dimm->handle, to_nfit_uuid(i), 1, 1)) {
+			set_bit(i, &nd_desc->dimm_family_mask);
 			if (family < 0 || i == default_dsm_family)
 				family = i;
+		}
 
 	/* limit the supported commands to those that are publicly documented */
 	nfit_mem->family = family;
@@ -2153,6 +2158,9 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
 
 	nd_desc->cmd_mask = acpi_desc->bus_cmd_force_en;
 	nd_desc->bus_dsm_mask = acpi_desc->bus_nfit_cmd_force_en;
+	set_bit(ND_CMD_CALL, &nd_desc->cmd_mask);
+	set_bit(NVDIMM_BUS_FAMILY_NFIT, &nd_desc->bus_family_mask);
+
 	adev = to_acpi_dev(acpi_desc);
 	if (!adev)
 		return;
@@ -2160,7 +2168,6 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
 	for (i = ND_CMD_ARS_CAP; i <= ND_CMD_CLEAR_ERROR; i++)
 		if (acpi_check_dsm(adev->handle, guid, 1, 1ULL << i))
 			set_bit(i, &nd_desc->cmd_mask);
-	set_bit(ND_CMD_CALL, &nd_desc->cmd_mask);
 
 	dsm_mask =
 		(1 << ND_CMD_ARS_CAP) |
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index f5525f8bb770..5c5e7ebba8dc 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -33,7 +33,6 @@
 		| ACPI_NFIT_MEM_RESTORE_FAILED | ACPI_NFIT_MEM_FLUSH_FAILED \
 		| ACPI_NFIT_MEM_NOT_ARMED | ACPI_NFIT_MEM_MAP_FAILED)
 
-#define NVDIMM_FAMILY_MAX NVDIMM_FAMILY_HYPERV
 #define NVDIMM_CMD_MAX 31
 
 #define NVDIMM_STANDARD_CMDMASK \
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 09087c38fabd..955265656b96 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -1037,9 +1037,25 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		dimm_name = "bus";
 	}
 
+	/* Validate command family support against bus declared support */
 	if (cmd == ND_CMD_CALL) {
+		unsigned long *mask;
+
 		if (copy_from_user(&pkg, p, sizeof(pkg)))
 			return -EFAULT;
+
+		if (nvdimm) {
+			if (pkg.nd_family > NVDIMM_FAMILY_MAX)
+				return -EINVAL;
+			mask = &nd_desc->dimm_family_mask;
+		} else {
+			if (pkg.nd_family > NVDIMM_BUS_FAMILY_MAX)
+				return -EINVAL;
+			mask = &nd_desc->bus_family_mask;
+		}
+
+		if (!test_bit(pkg.nd_family, mask))
+			return -EINVAL;
 	}
 
 	if (!desc ||
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 18da4059be09..bd39a2cf7972 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -78,6 +78,8 @@ struct nvdimm_bus_descriptor {
 	const struct attribute_group **attr_groups;
 	unsigned long bus_dsm_mask;
 	unsigned long cmd_mask;
+	unsigned long dimm_family_mask;
+	unsigned long bus_family_mask;
 	struct module *module;
 	char *provider_name;
 	struct device_node *of_node;
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 0e09dc5cec19..e9468b9332bd 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -245,6 +245,10 @@ struct nd_cmd_pkg {
 #define NVDIMM_FAMILY_MSFT 3
 #define NVDIMM_FAMILY_HYPERV 4
 #define NVDIMM_FAMILY_PAPR 5
+#define NVDIMM_FAMILY_MAX NVDIMM_FAMILY_PAPR
+
+#define NVDIMM_BUS_FAMILY_NFIT 0
+#define NVDIMM_BUS_FAMILY_MAX NVDIMM_BUS_FAMILY_NFIT
 
 #define ND_IOCTL_CALL			_IOWR(ND_IOCTL, ND_CMD_CALL,\
 					struct nd_cmd_pkg)

