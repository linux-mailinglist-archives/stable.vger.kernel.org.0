Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2EAE3C3CB6
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 15:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbhGKNFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 09:05:31 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:50185 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231658AbhGKNFb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 09:05:31 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 0ACA51AC057C;
        Sun, 11 Jul 2021 09:02:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 11 Jul 2021 09:02:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=aUKr21
        NLCkAXgjYUexlJd0+LsCdRq9Afnzp/TGDIWFE=; b=YjaTqSTFJi4FY3ufq0JhU2
        c8Qoy4FDkrxTHXL2TpzJOo/vuSmawqdZQgevJoL/zaa0wF8RCw+tLtJLKCMEgbxL
        8OrTwPnrSUrxRAvQErSO9U7jtvJw4BYqUmNkFEvgmEX6Jvu2M+dWqLJD8DRu10wZ
        T2UPh55qTC47D4xHCjAbrhmXMvWy6VLe8fM7ZE8DnVYXM+MhMFq/6vf70sF8Ld+V
        1O7AMM1NHdBaS07Ji/VAUXoK75M9G4OwLldbwFfDD/MByGnNiXWATYjKfcRwkxA+
        TM5Ra17jHaMC3/G2cDbf3vm7U6mYgqngGOv4w9kgTbiI/Co6GdYtLuYGZeD92nTg
        ==
X-ME-Sender: <xms:8-vqYLZigoi0aitqIqnOH90CB9HkVb2Pyx09t98MooMCAW6YOPnTIA>
    <xme:8-vqYKan8V_b-bDztdvjmfxcCtTPTQ6pwMggEtJhSTg3IcePuCip1s8AKahBwVkO_
    jkUEVpbXC5WxA>
X-ME-Received: <xmr:8-vqYN_d626yDkL0ahOObREdxhibbDFtE2jXan0lzMah5UI3XxH61y1Hg9koR78IqrS8df6rz-u6nwDgvINhwPNXlg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeekjefgffetgfevgeeghedugfelheektdehtdeihfeile
    eiteevjedvgfdvleejleenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:8-vqYBo-O1QdIcIi2lZBl6Jy4bwZRmF8f-rmwfuB1RU_lgZOhnblRA>
    <xmx:8-vqYGqRQB-bcC3-WtRrAwCqPZ3H_el-5GEUmOc-eKI4y3VxUkL9gA>
    <xmx:8-vqYHTCwcvssKi3TV1UgnmfIkKNMGFRnZL8TCE4wXUSj6GBYbxwgw>
    <xmx:8-vqYLAyTuLbM9CyYQn3ahP7uUNHfS9SCmABB8DAcChVjJoJakuGOff4Jlo>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 09:02:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] serial: mvebu-uart: fix calculation of clock divisor" failed to apply to 4.19-stable tree
To:     pali@kernel.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 15:02:41 +0200
Message-ID: <16260085611907@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9078204ca5c33ba20443a8623a41a68a9995a70d Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Date: Fri, 25 Jun 2021 00:49:00 +0200
Subject: [PATCH] serial: mvebu-uart: fix calculation of clock divisor
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The clock divisor should be rounded to the closest value.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: 68a0db1d7da2 ("serial: mvebu-uart: add function to change baudrate")
Cc: stable@vger.kernel.org # 0e4cf69ede87 ("serial: mvebu-uart: clarify the baud rate derivation")
Link: https://lore.kernel.org/r/20210624224909.6350-2-pali@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/mvebu-uart.c b/drivers/tty/serial/mvebu-uart.c
index 04c41689d81c..f3ecbcf495ee 100644
--- a/drivers/tty/serial/mvebu-uart.c
+++ b/drivers/tty/serial/mvebu-uart.c
@@ -463,7 +463,7 @@ static int mvebu_uart_baud_rate_set(struct uart_port *port, unsigned int baud)
 	 * makes use of D to configure the desired baudrate.
 	 */
 	m_divisor = OSAMP_DEFAULT_DIVISOR;
-	d_divisor = DIV_ROUND_UP(port->uartclk, baud * m_divisor);
+	d_divisor = DIV_ROUND_CLOSEST(port->uartclk, baud * m_divisor);
 
 	brdv = readl(port->membase + UART_BRDV);
 	brdv &= ~BRDV_BAUD_MASK;

