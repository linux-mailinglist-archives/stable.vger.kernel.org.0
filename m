Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFABF44F353
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 14:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbhKMNVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 08:21:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:44690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230021AbhKMNVS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Nov 2021 08:21:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F3FE60551;
        Sat, 13 Nov 2021 13:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636809506;
        bh=H/BVJJzfpPM5GC67t0rIEXR3++3tv4cxX9G0DaPH8ak=;
        h=Subject:To:Cc:From:Date:From;
        b=QnADqzi68CfKaV/ATIgk7NUuxysZC+Bfh4DblXV+YsF5SMJFqKNV0fU6A5mPmrkg8
         tcf74J0GyFW3dU7J5n4y0KfAIhCNOjSSi5Wv90GaS2EMD/DXMSh9ssZ2CHgT/1qumF
         77uJiy7mtIfHdbLeM1zdIBKiSaOkGFJkb1C7/wIQ=
Subject: FAILED: patch "[PATCH] platform/x86: amd-pmc: Add alternative acpi id for PMC" failed to apply to 5.15-stable tree
To:     nakato@nakato.io, hdegoede@redhat.com, mario.limonciello@amd.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Nov 2021 14:18:24 +0100
Message-ID: <163680950412253@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 432cce21b66c49b1951d046d3ffc5d52fdad6265 Mon Sep 17 00:00:00 2001
From: Sachi King <nakato@nakato.io>
Date: Sat, 2 Oct 2021 14:18:39 +1000
Subject: [PATCH] platform/x86: amd-pmc: Add alternative acpi id for PMC
 controller

The Surface Laptop 4 AMD has used the AMD0005 to identify this
controller instead of using the appropriate ACPI ID AMDI0005.  Include
AMD0005 in the acpi id list.

Link: https://github.com/linux-surface/acpidumps/tree/master/surface_laptop_4_amd
Link: https://gist.github.com/nakato/2a1a7df1a45fe680d7a08c583e1bf863
Cc: <stable@vger.kernel.org> # 5.14+
Signed-off-by: Sachi King <nakato@nakato.io>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20211002041840.2058647-1-nakato@nakato.io
Signed-off-by: Hans de Goede <hdegoede@redhat.com>

diff --git a/drivers/platform/x86/amd-pmc.c b/drivers/platform/x86/amd-pmc.c
index 548432a2ea65..b7b6ad4629a7 100644
--- a/drivers/platform/x86/amd-pmc.c
+++ b/drivers/platform/x86/amd-pmc.c
@@ -555,6 +555,7 @@ static const struct acpi_device_id amd_pmc_acpi_ids[] = {
 	{"AMDI0006", 0},
 	{"AMDI0007", 0},
 	{"AMD0004", 0},
+	{"AMD0005", 0},
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, amd_pmc_acpi_ids);

