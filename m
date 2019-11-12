Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE0AF989A
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 19:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbfKLS2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 13:28:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:52478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726718AbfKLS2D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 13:28:03 -0500
Received: from localhost (unknown [77.241.229.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A1B3206B6;
        Tue, 12 Nov 2019 18:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573583282;
        bh=PLH+5kFRG3+XcU8cocB0jnN3XKn6ZQ3vSav0PDr7oIc=;
        h=Subject:To:From:Date:From;
        b=LWb3Zhb5fzRUj2UXmRurmRUTlad2DmYuh8tdPxZpJ9BTtF+mMbPHu6yGa8qa0KShp
         2PekFToUJUG882RrW9zHwFGWN+dyG7wE0BftfYstDv+/KRwvt53+kzb70/SlvBVTd5
         TUcfOABpApTikyXZqk3+2OIi9C4dTNxIAuY7HZLE=
Subject: patch "staging: rtl8723bs: Add 024c:0525 to the list of SDIO device-ids" added to staging-next
To:     hdegoede@redhat.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, youling257@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 12 Nov 2019 19:23:52 +0100
Message-ID: <1573583032157123@kroah.com>
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
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


