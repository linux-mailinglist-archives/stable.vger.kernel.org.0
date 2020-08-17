Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08152463EB
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 12:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgHQKEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 06:04:00 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:40019 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726366AbgHQKD7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 06:03:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 95CB91941E61;
        Mon, 17 Aug 2020 06:03:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 17 Aug 2020 06:03:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+1diWd
        Ku2e7nXMHc66Dkizf5EpqGxCcNz3PrRHCnsQU=; b=qt261ez6c0IiBvqRto8JDH
        GNb0Srnx0BT+demWY21Vp7bQ42//WyCYLdWnpdmlCvp6LaBvVcoht18KFKILTnSL
        N7HrNWNW8fu/rjSW4JKdQqkVSZsJbdYBtfKNiJM7x4d1H6Z/D//eWDZuKHOdS5HH
        yrWrmuxots4eJISgps7DtxNjS/ym3BpWPzAJzYRbC1SwaMWoOes8ZHc8XcnEjJ55
        b22fWhXcvYEXVc7klVbxG0//3J2hA9iHAekKucuy/Do/DI6SlcwDar/Ttj4TL1CT
        1UGBxQSrtolG7rtdB7JFAZZiVVa76f1NX46w33POTk+LLDpKFO8X2sQs0btKJ5uA
        ==
X-ME-Sender: <xms:DlY6X1YgScfgBaXIY9ordejkaT72aprhhKMZiVHvQDSC9YGHZSNp8w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:DlY6X8Ykbjhy-cK7fq_1sBl-NztZBAO-ysqnKtZ7DVL-bMOXpVXpYw>
    <xmx:DlY6X3_k140u1c2Wx7md4lLHSMT87IEGWQ1PnFhinilbIRRdx7dpYg>
    <xmx:DlY6XzrQLWhd0YzE-JxFVI3-6e9ppazEL-JLFqPbdMUuzrAd289sdw>
    <xmx:DlY6X3RyZ28yGkPAGkfhGoTxvzaypoCOe9oRtWVcAseMEHU0PFTfeA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 22ED23280063;
        Mon, 17 Aug 2020 06:03:58 -0400 (EDT)
Subject: FAILED: patch "[PATCH] USB: serial: cp210x: re-enable auto-RTS on open" failed to apply to 4.4-stable tree
To:     brant.merryman@silabs.com, johan@kernel.org, phu.luu@silabs.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Aug 2020 12:04:18 +0200
Message-ID: <1597658658132199@kroah.com>
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

From c7614ff9b73a1e6fb2b1b51396da132ed22fecdb Mon Sep 17 00:00:00 2001
From: Brant Merryman <brant.merryman@silabs.com>
Date: Fri, 26 Jun 2020 04:24:20 +0000
Subject: [PATCH] USB: serial: cp210x: re-enable auto-RTS on open

CP210x hardware disables auto-RTS but leaves auto-CTS when in hardware
flow control mode and UART on cp210x hardware is disabled. When
re-opening the port, if auto-CTS is enabled on the cp210x, then auto-RTS
must be re-enabled in the driver.

Signed-off-by: Brant Merryman <brant.merryman@silabs.com>
Co-developed-by: Phu Luu <phu.luu@silabs.com>
Signed-off-by: Phu Luu <phu.luu@silabs.com>
Link: https://lore.kernel.org/r/ECCF8E73-91F3-4080-BE17-1714BC8818FB@silabs.com
[ johan: fix up tags and problem description ]
Fixes: 39a66b8d22a3 ("[PATCH] USB: CP2101 Add support for flow control")
Cc: stable <stable@vger.kernel.org>     # 2.6.12
Signed-off-by: Johan Hovold <johan@kernel.org>

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index bcceb4ad8be0..a90801ef0055 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -917,6 +917,7 @@ static void cp210x_get_termios_port(struct usb_serial_port *port,
 	u32 baud;
 	u16 bits;
 	u32 ctl_hs;
+	u32 flow_repl;
 
 	cp210x_read_u32_reg(port, CP210X_GET_BAUDRATE, &baud);
 
@@ -1017,6 +1018,22 @@ static void cp210x_get_termios_port(struct usb_serial_port *port,
 	ctl_hs = le32_to_cpu(flow_ctl.ulControlHandshake);
 	if (ctl_hs & CP210X_SERIAL_CTS_HANDSHAKE) {
 		dev_dbg(dev, "%s - flow control = CRTSCTS\n", __func__);
+		/*
+		 * When the port is closed, the CP210x hardware disables
+		 * auto-RTS and RTS is deasserted but it leaves auto-CTS when
+		 * in hardware flow control mode. When re-opening the port, if
+		 * auto-CTS is enabled on the cp210x, then auto-RTS must be
+		 * re-enabled in the driver.
+		 */
+		flow_repl = le32_to_cpu(flow_ctl.ulFlowReplace);
+		flow_repl &= ~CP210X_SERIAL_RTS_MASK;
+		flow_repl |= CP210X_SERIAL_RTS_SHIFT(CP210X_SERIAL_RTS_FLOW_CTL);
+		flow_ctl.ulFlowReplace = cpu_to_le32(flow_repl);
+		cp210x_write_reg_block(port,
+				CP210X_SET_FLOW,
+				&flow_ctl,
+				sizeof(flow_ctl));
+
 		cflag |= CRTSCTS;
 	} else {
 		dev_dbg(dev, "%s - flow control = NONE\n", __func__);

