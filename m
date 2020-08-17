Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018B32463EC
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 12:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgHQKEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 06:04:33 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:54229 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726366AbgHQKEc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 06:04:32 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9C0071941E6A;
        Mon, 17 Aug 2020 06:04:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 17 Aug 2020 06:04:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=b4sM2R
        2dZ+MI/+CJWo2bIzLv9MoUKQCajRzYvtZRmC8=; b=je7BxsFgH4m3OtJRy82sD6
        eS7NQhEAjimVXSS9GBix4BqJX0FEwgSwaV/t3PloknV0OOSxw7VNvXhivTGzT7s/
        Doe7qp8xV7UxXIDdI9RLuCi+ZsVlVEGY8ntttB4BD1QjtNTs0OQNlVJi0Tfgk/p9
        O6Tyh+qGI45rR6hUZHbWFz2uGSOe3YCU0G4Ih5dKnqrQsg3iJRGbrRLw+ZA88Igh
        XLz6SgOVyO+BYxtNzAQANOBOR/9p2tNKKOQXyETwahKYL2JE84XFvcEjrM6gfTvW
        y5M88zNNCpIUEEwkCfQisnFYdweApuoPSoP1aGcTEljfBUj8913ji2oJvytDNIcQ
        ==
X-ME-Sender: <xms:L1Y6X_2jjYPnO_Ab6UKZXBZrg6UnYl6B1E2D_Un8rqIE_crYRUDS7w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:L1Y6X-E81h9oJocQ002Ykt89UNX7L2WPGpbG8twhsjyY42e9aVV4aw>
    <xmx:L1Y6X_5ptj3Mt_WKTnVq0SR1A4pJrGyNKE3gPaQslqJ9AKcLOaRxEQ>
    <xmx:L1Y6X03B8GjfllHIMKrpUbH_iqLD65cgKQDOjSHsu-YAMGOp2VHk-A>
    <xmx:L1Y6X9OIW3zfK9Q115cDlDh1f3zbvIvQMclst7FriyxCre2eFmp7Vw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1D1223280063;
        Mon, 17 Aug 2020 06:04:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] USB: serial: cp210x: enable usb generic throttle/unthrottle" failed to apply to 4.4-stable tree
To:     brant.merryman@silabs.com, johan@kernel.org, phu.luu@silabs.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Aug 2020 12:04:51 +0200
Message-ID: <159765869110835@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4387b3dbb079d482d3c2b43a703ceed4dd27ed28 Mon Sep 17 00:00:00 2001
From: Brant Merryman <brant.merryman@silabs.com>
Date: Fri, 26 Jun 2020 04:22:58 +0000
Subject: [PATCH] USB: serial: cp210x: enable usb generic throttle/unthrottle

Assign the .throttle and .unthrottle functions to be generic function
in the driver structure to prevent data loss that can otherwise occur
if the host does not enable USB throttling.

Signed-off-by: Brant Merryman <brant.merryman@silabs.com>
Co-developed-by: Phu Luu <phu.luu@silabs.com>
Signed-off-by: Phu Luu <phu.luu@silabs.com>
Link: https://lore.kernel.org/r/57401AF3-9961-461F-95E1-F8AFC2105F5E@silabs.com
[ johan: fix up tags ]
Fixes: 39a66b8d22a3 ("[PATCH] USB: CP2101 Add support for flow control")
Cc: stable <stable@vger.kernel.org>     # 2.6.12
Signed-off-by: Johan Hovold <johan@kernel.org>

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index f5143eedbc48..bcceb4ad8be0 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -272,6 +272,8 @@ static struct usb_serial_driver cp210x_device = {
 	.break_ctl		= cp210x_break_ctl,
 	.set_termios		= cp210x_set_termios,
 	.tx_empty		= cp210x_tx_empty,
+	.throttle		= usb_serial_generic_throttle,
+	.unthrottle		= usb_serial_generic_unthrottle,
 	.tiocmget		= cp210x_tiocmget,
 	.tiocmset		= cp210x_tiocmset,
 	.attach			= cp210x_attach,

