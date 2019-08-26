Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05CA79CBE1
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 10:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfHZItq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 04:49:46 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:48245 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726401AbfHZItq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 04:49:46 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id E27B6362;
        Mon, 26 Aug 2019 04:49:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 26 Aug 2019 04:49:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=TZVAyi
        Cw4TLo6gJELHp6jV7ZPlv+i2areJUgbEwDZuk=; b=GM9K0j8H+SVeIbpgTVR8ff
        Tx/dnOCJTt4otQASdu63xjtj6IlR7ZfBq3ocI/5x+ZOlYVgVMydpJHxTbRbwMZNG
        qvkNX+Tz6rScLk1SYfuVgERxHgCZJ/NrUEZrrvdoChmzGStcdkT7LMxvoqRoAdjO
        86plQ3NenZkIJIziWT2oPXyYU6eHUftpeEH8sNTBKXWdC7+mUFzy+FMdn3JksEAd
        wqCeRHUg8B0rAERdWqYvSu9erU1XJ2PxIyWEmHfyvKOFCVxFT0PEvJ/Kegv0TbUw
        xQErlmGQveY6cfZKdEb6QLk546QCaL+MkvANuViG86uk6skQu6LZVW08NxW8Gs0A
        ==
X-ME-Sender: <xms:J51jXe1I5ufu5xr4t0ePu2oiDud6rmCGcFd2O054Ovo2itG_XoKgMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudehgedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehgihhthhhusgdrtghomhenucfkphepkeelrddvtdehrdduvd
    ekrddvgeeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtgho
    mhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:J51jXYRA6SX73AkKneypQA1txhL2cQMEae0jawAa6Kb9_nC86wEkYg>
    <xmx:J51jXbQGVk5UNneFQY1ObljuIklnPG27XW_uK2wx1Lk00cGmwB6ELA>
    <xmx:J51jXYj8GAXgnE8SUTOBLUVlgTRy72LY1rHZxrYAAVvq_mZcAMX_zw>
    <xmx:KJ1jXZw1HaKG3ou4fEHam3BfUUeFuLrtR3SYBEh4_TKou2qxUdzOxg>
Received: from localhost (unknown [89.205.128.246])
        by mail.messagingengine.com (Postfix) with ESMTPA id EC094D60057;
        Mon, 26 Aug 2019 04:49:42 -0400 (EDT)
Subject: FAILED: patch "[PATCH] HID: logitech-hidpp: remove support for the G700 over USB" failed to apply to 5.2-stable tree
To:     benjamin.tissoires@redhat.com, lains@archlinux.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 26 Aug 2019 10:49:35 +0200
Message-ID: <1566809375118175@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a3384b8d9f63cc042711293bb97bdc92dca0391d Mon Sep 17 00:00:00 2001
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date: Tue, 13 Aug 2019 15:38:07 +0200
Subject: [PATCH] HID: logitech-hidpp: remove support for the G700 over USB
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The G700 suffers from the same issue than the G502:
when plugging it in, the driver tries to contact it but it fails.

This timeout is problematic as it introduce a delay in the boot,
and having only the mouse event node means that the hardware
macros keys can not be relayed to the userspace.

Link: https://github.com/libratbag/libratbag/issues/797
Fixes: 91cf9a98ae41 ("HID: logitech-hidpp: make .probe usbhid capable")
Cc: stable@vger.kernel.org # v5.2
Reviewed-by: Filipe Laíns <lains@archlinux.org>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 343052b117a9..0179f7ed77e5 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -3751,8 +3751,6 @@ static const struct hid_device_id hidpp_devices[] = {
 
 	{ /* Logitech G403 Wireless Gaming Mouse over USB */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC082) },
-	{ /* Logitech G700 Gaming Mouse over USB */
-	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC06B) },
 	{ /* Logitech G703 Gaming Mouse over USB */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC087) },
 	{ /* Logitech G703 Hero Gaming Mouse over USB */

