Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC1F613275A
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 14:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgAGNPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 08:15:11 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:55483 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727814AbgAGNPK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 08:15:10 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 259D4617;
        Tue,  7 Jan 2020 08:15:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 07 Jan 2020 08:15:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=NHUGbY
        OIzYZPekyvApoqimtgdsKPuCiJ9zAK1WLOCoM=; b=d0i40qaXXnMcYDu/sIhfvw
        kcQn78L5DDqheYbI3Ah2L5s3LTUR473IZO+ymdEjF50zLRI72LjDNmA6RiE0TRJ3
        FZfPmdO9fh5TRejHI4oo+qtRKF94qDsNR0Bm8DyAW9Nnvo8IFlPnoT5fol0DrlaY
        wp1YtrH3qk96/9hCLCTsVgs9QdSmVrUowp0JYrGbe5TtCoreFTEnwUiWzD3g58CZ
        tYsTJNFaaPYoUQ65qcpjQRZsbXSoIk6xnJsVpnf/V071IbT3K954XmEeShknrBGw
        QPPiiQyJzA2CWtFXXut/3ae+1f3e8OUTnmEkQvyKuchMSYA2j0HqOpY9M/+I+TWQ
        ==
X-ME-Sender: <xms:XYQUXvRdM8G97N8xPAcGI1bPfBpBtK0hQ4h5opbVhI_TEwjXfDy4Dg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdehgedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:XYQUXloQChsLnEviXyVHKTs68WzKSLi_awV7QsGYfSYDHxwdl6leCg>
    <xmx:XYQUXtYaPuD7RU-wuQCfx5OcgGVPaW3rfaPs0SamFwh8iXU0IdQ3Fg>
    <xmx:XYQUXgQA2XMh_gy4Q5DM47474wPugOxVYBUGH_hrALWuYxBvNHld_A>
    <xmx:XYQUXnr64fhctIoLY7q2rRcQF4kVZF2-22QozGs0WgqqJ5MAWPUiAQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 07A7D80062;
        Tue,  7 Jan 2020 08:15:08 -0500 (EST)
Subject: FAILED: patch "[PATCH] ACPI: sysfs: Change ACPI_MASKABLE_GPE_MAX to 0x100" failed to apply to 4.9-stable tree
To:     yeyunfeng@huawei.com, rafael.j.wysocki@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Jan 2020 14:15:07 +0100
Message-ID: <1578402907214109@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a7583e72a5f22470d3e6fd3b6ba912892242339f Mon Sep 17 00:00:00 2001
From: Yunfeng Ye <yeyunfeng@huawei.com>
Date: Thu, 14 Nov 2019 15:16:24 +0800
Subject: [PATCH] ACPI: sysfs: Change ACPI_MASKABLE_GPE_MAX to 0x100

The commit 0f27cff8597d ("ACPI: sysfs: Make ACPI GPE mask kernel
parameter cover all GPEs") says:
  "Use a bitmap of size 0xFF instead of a u64 for the GPE mask so 256
   GPEs can be masked"

But the masking of GPE 0xFF it not supported and the check condition
"gpe > ACPI_MASKABLE_GPE_MAX" is not valid because the type of gpe is
u8.

So modify the macro ACPI_MASKABLE_GPE_MAX to 0x100, and drop the "gpe >
ACPI_MASKABLE_GPE_MAX" check. In addition, update the docs "Format" for
acpi_mask_gpe parameter.

Fixes: 0f27cff8597d ("ACPI: sysfs: Make ACPI GPE mask kernel parameter cover all GPEs")
Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
[ rjw: Use u16 as gpe data type in acpi_gpe_apply_masked_gpes() ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 8dee8f68fe15..02724bd017cc 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -113,7 +113,7 @@
 			the GPE dispatcher.
 			This facility can be used to prevent such uncontrolled
 			GPE floodings.
-			Format: <int>
+			Format: <byte>
 
 	acpi_no_auto_serialize	[HW,ACPI]
 			Disable auto-serialization of AML methods
diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
index 75948a3f1a20..c60d2c6d31d6 100644
--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -819,14 +819,14 @@ static ssize_t counter_set(struct kobject *kobj,
  * interface:
  *   echo unmask > /sys/firmware/acpi/interrupts/gpe00
  */
-#define ACPI_MASKABLE_GPE_MAX	0xFF
+#define ACPI_MASKABLE_GPE_MAX	0x100
 static DECLARE_BITMAP(acpi_masked_gpes_map, ACPI_MASKABLE_GPE_MAX) __initdata;
 
 static int __init acpi_gpe_set_masked_gpes(char *val)
 {
 	u8 gpe;
 
-	if (kstrtou8(val, 0, &gpe) || gpe > ACPI_MASKABLE_GPE_MAX)
+	if (kstrtou8(val, 0, &gpe))
 		return -EINVAL;
 	set_bit(gpe, acpi_masked_gpes_map);
 
@@ -838,7 +838,7 @@ void __init acpi_gpe_apply_masked_gpes(void)
 {
 	acpi_handle handle;
 	acpi_status status;
-	u8 gpe;
+	u16 gpe;
 
 	for_each_set_bit(gpe, acpi_masked_gpes_map, ACPI_MASKABLE_GPE_MAX) {
 		status = acpi_get_gpe_device(gpe, &handle);

