Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E16C33427A
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 17:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhCJQIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 11:08:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:58312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229828AbhCJQIJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 11:08:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F05964F9B;
        Wed, 10 Mar 2021 16:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615392489;
        bh=W9QFz2IngeXO7ltVdPjVaScd2MeENkbZimzotwHMljQ=;
        h=Subject:To:From:Date:From;
        b=pXFU25nTPF6D52vqYaB/Dqdyp4BfiQrBLWhPjifTUa6/d7rZ87+oWoDYYaMF0VAIn
         Py86dSXBC7NWqMAJ6HGTyw0xF04vgLxm3VeWBxvsiDLsyMxtYDGkeX+nky+Th6KrCv
         R7RoEHRlINnNA7WYa3vb4bindqXnAWTn3/RGJIPQ=
Subject: patch "misc/pvpanic: Export module FDT device table" added to char-misc-linus
To:     shile.zhang@linux.alibaba.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 10 Mar 2021 17:08:07 +0100
Message-ID: <161539248714163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    misc/pvpanic: Export module FDT device table

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 65527a51c66f4edfa28602643d7dd4fa366eb826 Mon Sep 17 00:00:00 2001
From: Shile Zhang <shile.zhang@linux.alibaba.com>
Date: Thu, 18 Feb 2021 20:31:16 +0800
Subject: misc/pvpanic: Export module FDT device table

Export the module FDT device table to ensure the FDT compatible strings
are listed in the module alias. This help the pvpanic driver can be
loaded on boot automatically not only the ACPI device, but also the FDT
device.

Fixes: 46f934c9a12fc ("misc/pvpanic: add support to get pvpanic device info FDT")
Signed-off-by: Shile Zhang <shile.zhang@linux.alibaba.com>
Link: https://lore.kernel.org/r/20210218123116.207751-1-shile.zhang@linux.alibaba.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/pvpanic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/pvpanic.c b/drivers/misc/pvpanic.c
index 9f350e05ef68..f1655f5ca016 100644
--- a/drivers/misc/pvpanic.c
+++ b/drivers/misc/pvpanic.c
@@ -140,6 +140,7 @@ static const struct of_device_id pvpanic_mmio_match[] = {
 	{ .compatible = "qemu,pvpanic-mmio", },
 	{}
 };
+MODULE_DEVICE_TABLE(of, pvpanic_mmio_match);
 
 static const struct acpi_device_id pvpanic_device_ids[] = {
 	{ "QEMU0001", 0 },
-- 
2.30.2


