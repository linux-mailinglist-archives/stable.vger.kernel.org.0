Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA012A990B
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 17:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgKFQGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 11:06:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:59642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbgKFQGK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Nov 2020 11:06:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 021E420B80;
        Fri,  6 Nov 2020 16:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604678769;
        bh=io9kfGKdodShePiUwNtXTGgS6f2sfz32i+6aF99QchY=;
        h=Subject:To:From:Date:From;
        b=MBjP+0knUucHk0BFhszG0QY8gp+PgcM0QptmonoWVxpKXOsUB9IIiskfhFQuCOucq
         h94h3QNcaUQm2ulbpv8l3Bh9ef+cNqKGDHcwgV0dDOWFR4pntuqUvGCYVs/y7+VsoV
         An2l1GO4jRnrIhrQxr6YBLfdviUePhUFXTd/UdQs=
Subject: patch "staging: rtl8723bs: Add 024c:0627 to the list of SDIO device-ids" added to staging-linus
To:     bokeefe@alum.wpi.edu, gregkh@linuxfoundation.org,
        hdegoede@redhat.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 06 Nov 2020 17:06:56 +0100
Message-ID: <160467881615597@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: rtl8723bs: Add 024c:0627 to the list of SDIO device-ids

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From aee9dccc5b64e878cf1b18207436e73f66d74157 Mon Sep 17 00:00:00 2001
From: Brian O'Keefe <bokeefe@alum.wpi.edu>
Date: Fri, 6 Nov 2020 10:10:34 -0500
Subject: staging: rtl8723bs: Add 024c:0627 to the list of SDIO device-ids

Add 024c:0627 to the list of SDIO device-ids, based on hardware found in
the wild. This hardware exists on at least some Acer SW1-011 tablets.

Signed-off-by: Brian O'Keefe <bokeefe@alum.wpi.edu>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/b9e1523f-2ba7-fb82-646a-37f095b4440e@alum.wpi.edu
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
index 79b55ec827a4..b2208e5f190a 100644
--- a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
+++ b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
@@ -20,6 +20,7 @@ static const struct sdio_device_id sdio_ids[] = {
 	{ SDIO_DEVICE(0x024c, 0x0525), },
 	{ SDIO_DEVICE(0x024c, 0x0623), },
 	{ SDIO_DEVICE(0x024c, 0x0626), },
+	{ SDIO_DEVICE(0x024c, 0x0627), },
 	{ SDIO_DEVICE(0x024c, 0xb723), },
 	{ /* end: all zeroes */				},
 };
-- 
2.29.2


