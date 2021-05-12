Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B8337BC78
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 14:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhELM0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 08:26:45 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:43559 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231956AbhELM0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 08:26:44 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id B4A47116E;
        Wed, 12 May 2021 08:25:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 12 May 2021 08:25:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=QCkspa
        Fps7AImydLym0yBT4pp/k85Wtjmt/7ZKamCzs=; b=Jz/lHCsHe6kpKyY7yn84da
        h9vCNAk80bLA5SljKJWuxc5IEaS/IZ1TdiN49b/MjEqoPfsFWGh5yUYbfKx8V0hH
        wXBvvs2M/s7fIbmY+4kb8SZO0AohTqSn07T6QCTJ3P4qLEy1MtsKKXe1PQMt1BvI
        MTnBOqCkHGL03SoVSHVz4B4sBzTteP8Gj3ZVumOtfXqenBR6qrhNtR56x5ARI3/G
        4ESYRtl0VXMnO78pZu2NL6Eb1PXXd6Zhmr4F5A5qzf4PdMo+xuOWVjHbcV2ioOkh
        ny29OAJKLoqVEONPp4KUlDh7OzabYnRUk83/3s4yRCe2P4RYrMVpVL6yp16yfJpg
        ==
X-ME-Sender: <xms:P8mbYOEv9m7k2kgK-WURGnMaC7bmz3yAd642Urhq4lsj6hcAko07Fg>
    <xme:P8mbYPWkOPf85KWSHngSrbYAhOHDeedQVRScHTX1dwWdUv_YS-uSfPBSw9tqeBsa9
    HGXU7_TCzCfsQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:P8mbYIKyjqaWCYPMcZAw0h-k-j3lH00udqUGzLcNeUHwl8Fxq5yqSA>
    <xmx:P8mbYIE53q8EHnet8wn8Z5mXp3BNfD4_gS1c3RlX5LuCodZSMNGdoQ>
    <xmx:P8mbYEUmeKa6-k6js2OuozjUHrdZkA-BfCU-Mibd8pQVEpe_H3iuTQ>
    <xmx:QMmbYNfdWswbA1I83MRozKXgyxH4NJGdkLeD7WzUfo5qeXa769RDijy4zRY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 08:25:35 -0400 (EDT)
Subject: FAILED: patch "[PATCH] serial: stm32: fix tx_empty condition" failed to apply to 4.9-stable tree
To:     erwan.leray@foss.st.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 14:25:33 +0200
Message-ID: <1620822333134199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 3db1d52466dc11dca4e47ef12a6e6e97f846af62 Mon Sep 17 00:00:00 2001
From: Erwan Le Ray <erwan.leray@foss.st.com>
Date: Thu, 4 Mar 2021 17:23:07 +0100
Subject: [PATCH] serial: stm32: fix tx_empty condition

In "tx_empty", we should poll TC bit in both DMA and PIO modes (instead of
TXE) to check transmission data register has been transmitted independently
of the FIFO mode. TC indicates that both transmit register and shift
register are empty. When shift register is empty, tx_empty should return
TIOCSER_TEMT instead of TC value.

Cleans the USART_CR_TC TCCF register define (transmission complete clear
flag) as it is duplicate of USART_ICR_TCCF.

Fixes: 48a6092fb41f ("serial: stm32-usart: Add STM32 USART Driver")
Signed-off-by: Erwan Le Ray <erwan.leray@foss.st.com>
Link: https://lore.kernel.org/r/20210304162308.8984-13-erwan.leray@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index d205fce1950a..99dfa884cbef 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -515,7 +515,10 @@ static unsigned int stm32_usart_tx_empty(struct uart_port *port)
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 
-	return readl_relaxed(port->membase + ofs->isr) & USART_SR_TXE;
+	if (readl_relaxed(port->membase + ofs->isr) & USART_SR_TC)
+		return TIOCSER_TEMT;
+
+	return 0;
 }
 
 static void stm32_usart_set_mctrl(struct uart_port *port, unsigned int mctrl)
diff --git a/drivers/tty/serial/stm32-usart.h b/drivers/tty/serial/stm32-usart.h
index cb4f327c46db..94b568aa46bb 100644
--- a/drivers/tty/serial/stm32-usart.h
+++ b/drivers/tty/serial/stm32-usart.h
@@ -127,9 +127,6 @@ struct stm32_usart_info stm32h7_info = {
 /* Dummy bits */
 #define USART_SR_DUMMY_RX	BIT(16)
 
-/* USART_ICR (F7) */
-#define USART_CR_TC		BIT(6)
-
 /* USART_DR */
 #define USART_DR_MASK		GENMASK(8, 0)
 

