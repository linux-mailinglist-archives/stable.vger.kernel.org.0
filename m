Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4705612C327
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 16:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfL2Pqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 10:46:42 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:42293 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726230AbfL2Pqm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 10:46:42 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id A88E8442;
        Sun, 29 Dec 2019 10:46:41 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 29 Dec 2019 10:46:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=pAhtTe
        LR3FGnvsI0nAiPW8GpGi6kgV4bi7nT5nw4ufQ=; b=Xjk+b6jzLY5rTczYsqmjAQ
        4oDoN6UlGjZuO54CCuLpsGhhGkTSy/R11B+kZimmg8XbA0nzJIXxUdD4KIqcTAhG
        RzCpaMAx27U9t/4OkKGQmpeWg7lQ0YARHBv0O1tgdIOI3cyrxNcJfgkWbDIjwywJ
        Z7kas5ufWokxz+6xvJcBdldvluierzRkA+DHFJm/x/zNS8i96kp3B7asJe4l3XJo
        dJENtaKI7cXv7ocRS+AlzvoTsMT48NOLp5hdLGVbqYXtrJjTImBOAZYaiQ3tfeoX
        +7WyLOPQGNNVbasZemn7drMXVxCHqdPeUgRwgG+18y7jLKzFLqB5SuzCfDf4AmIg
        ==
X-ME-Sender: <xms:YcoIXgrBiQJe5XMOUqk4t1IN94cB_QXJZ6S3wbH2FUf5WSQvuXus_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpeeg
X-ME-Proxy: <xmx:YcoIXuSIKO1EtFsA4wxvHRRFwQhfP2VO6DL_9CMEScOIEymo3p0zVw>
    <xmx:YcoIXi0c2N3e9AvPhe1JarFNME4QuDh8m5uSisTUQQoYOTa1ql2GgQ>
    <xmx:YcoIXiArXTFKosw_0N7kqKN4W1fw0_kDQe_s8Lag6Jq9KxP-R297-g>
    <xmx:YcoIXvGoxv9SfFobBOIJ0-rKYMPbMcHRkfEsfIziM8QlcVf4j69BKg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CC10280059;
        Sun, 29 Dec 2019 10:46:40 -0500 (EST)
Subject: FAILED: patch "[PATCH] serial: sprd: Add clearing break interrupt operation" failed to apply to 4.9-stable tree
To:     yonghan.ye@unisoc.com, baolin.wang7@gmail.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Dec 2019 16:46:29 +0100
Message-ID: <15776343897073@kroah.com>
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

From abeb2e9414d7e3a0d8417bc3b13d7172513ea8a0 Mon Sep 17 00:00:00 2001
From: Yonghan Ye <yonghan.ye@unisoc.com>
Date: Wed, 4 Dec 2019 20:00:07 +0800
Subject: [PATCH] serial: sprd: Add clearing break interrupt operation

A break interrupt will be generated if the RX line was pulled low, which
means some abnomal behaviors occurred of the UART. In this case, we still
need to clear this break interrupt status, otherwise it will cause irq
storm to crash the whole system.

Fixes: b7396a38fb28 ("tty/serial: Add Spreadtrum sc9836-uart driver support")
Signed-off-by: Yonghan Ye <yonghan.ye@unisoc.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Baolin Wang <baolin.wang7@gmail.com>
Link: https://lore.kernel.org/r/925e51b73099c90158e080b8f5bed9b3b38c4548.1575460601.git.baolin.wang7@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/sprd_serial.c b/drivers/tty/serial/sprd_serial.c
index 31df23502562..f60a59d9bf27 100644
--- a/drivers/tty/serial/sprd_serial.c
+++ b/drivers/tty/serial/sprd_serial.c
@@ -679,6 +679,9 @@ static irqreturn_t sprd_handle_irq(int irq, void *dev_id)
 	if (ims & SPRD_IMSR_TIMEOUT)
 		serial_out(port, SPRD_ICLR, SPRD_ICLR_TIMEOUT);
 
+	if (ims & SPRD_IMSR_BREAK_DETECT)
+		serial_out(port, SPRD_ICLR, SPRD_IMSR_BREAK_DETECT);
+
 	if (ims & (SPRD_IMSR_RX_FIFO_FULL | SPRD_IMSR_BREAK_DETECT |
 		   SPRD_IMSR_TIMEOUT))
 		sprd_rx(port);

