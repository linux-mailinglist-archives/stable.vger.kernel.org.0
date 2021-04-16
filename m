Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2C636194E
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 07:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237350AbhDPF2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 01:28:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237117AbhDPF2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 01:28:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD06261029;
        Fri, 16 Apr 2021 05:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618550892;
        bh=ZNVEiUNY3G1HKZ+8cY4mTLdrkV9IlRGrExyKHUm/VH8=;
        h=Subject:To:From:Date:From;
        b=jXEI88U+kkHvrRunpFrefE0Uwxi3bm0S2i6PvVmW56Z4PM/eY60aVutF58abKg7ED
         Lcma3kts6drcNAEpd3nEPlh6rdHq8kuzev9TR/neH0cZj16Dvte5kftlLeXJJpOoKx
         SqdD+1zQMl2qQwSfsv5l2QcZK9w9tDVmfjeaiOSU=
Subject: patch "intel_th: pci: Add Rocket Lake CPU support" added to char-misc-next
To:     alexander.shishkin@linux.intel.com,
        andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 16 Apr 2021 07:27:53 +0200
Message-ID: <1618550873228164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    intel_th: pci: Add Rocket Lake CPU support

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 9f7f2a5e01ab4ee56b6d9c0572536fe5fd56e376 Mon Sep 17 00:00:00 2001
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Date: Wed, 14 Apr 2021 20:12:50 +0300
Subject: intel_th: pci: Add Rocket Lake CPU support

This adds support for the Trace Hub in Rocket Lake CPUs.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable <stable@vger.kernel.org> # v4.14+
Link: https://lore.kernel.org/r/20210414171251.14672-7-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hwtracing/intel_th/pci.c b/drivers/hwtracing/intel_th/pci.c
index 759994055cb4..a756c995fc7a 100644
--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -278,6 +278,11 @@ static const struct pci_device_id intel_th_pci_id_table[] = {
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
+	{
+		/* Rocket Lake CPU */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4c19),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
 	{ 0 },
 };
 
-- 
2.31.1


