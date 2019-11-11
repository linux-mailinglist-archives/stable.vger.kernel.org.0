Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69CD4F77E0
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 16:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfKKPjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 10:39:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:33228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbfKKPjQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 10:39:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23D3021D7F;
        Mon, 11 Nov 2019 15:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573486754;
        bh=MymmY1+gfk692mOtGYy433eCbh6whe/ZMj94E0h8M/8=;
        h=Subject:To:From:Date:From;
        b=Z1+YjTSvwpyrhhWhd/uRiJd6XnrhV5Fj3uT/+fshh85M362eEpAxF8yc3lTUoIr4q
         6S5UVNjHlii4IMoMoPV/zCwOub2q4w63PSSCiZLEtqaE0DdLUMtyMnzefGIcnoSDL7
         Kug9NI3K0taHOtH9Z+8gl607HoVC1qMlrDWFxrmM=
Subject: patch "staging: rtl8723bs: Add 024c:0525 to the list of SDIO device-ids" added to staging-testing
To:     hdegoede@redhat.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, youling257@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Nov 2019 16:38:54 +0100
Message-ID: <1573486734231234@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: rtl8723bs: Add 024c:0525 to the list of SDIO device-ids

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 3d5f1eedbfd22ceea94b39989d6021b1958181f4 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Mon, 11 Nov 2019 12:38:45 +0100
Subject: staging: rtl8723bs: Add 024c:0525 to the list of SDIO device-ids

Add 024c:0525 to the list of SDIO device-ids, based on a patch found
in the Android X86 kernels. According to that patch this device id is
used on the Alcatel Plus 10 device.

Reported-and-tested-by: youling257 <youling257@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191111113846.24940-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
index 12f683e2e0e2..c48d2df97285 100644
--- a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
+++ b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
@@ -18,6 +18,7 @@
 static const struct sdio_device_id sdio_ids[] =
 {
 	{ SDIO_DEVICE(0x024c, 0x0523), },
+	{ SDIO_DEVICE(0x024c, 0x0525), },
 	{ SDIO_DEVICE(0x024c, 0x0623), },
 	{ SDIO_DEVICE(0x024c, 0x0626), },
 	{ SDIO_DEVICE(0x024c, 0xb723), },
-- 
2.24.0


