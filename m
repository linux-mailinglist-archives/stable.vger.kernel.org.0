Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04FBA327C40
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbhCAKe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:34:26 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:55241 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234575AbhCAKdj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:33:39 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9ED331940745;
        Mon,  1 Mar 2021 05:32:51 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 05:32:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=yeP+AE
        eaFTjEUm3ezkg4PgnmXm7EnaGWJpEGppFqX6E=; b=kGJQjXSKXa2kblmkB54uGC
        /p6J5I/rjwyhiM2a9bB3CZArogpia7/PKsYl7Q8g70xszaR1lx4AFHzfK/j51LE6
        jIGoDX5yFyTHljr2n1pMtxK1Sr7Wm9Bew5bo6YXREhu1MIEljdPRAnE4+ZkJqBlP
        qyOfMPXpQBoIhbqGaH3Lf4LFwZkJTwaYtk9VZS6m+xC+PphxErIhxNUb/iiBYJra
        6ozcw+m326aDSMPY8fIFYr0db3v/Q5IOiftqZwL81A43k4UNJpdiUQfEqdIKDhqs
        /oj4bvdLaUNEc+Dd8nL8l3A3BlYjoMDn/wQkBZwJuY7RKl43cUOIHwH9IxiMzoKg
        ==
X-ME-Sender: <xms:08I8YGPt9_8wRSONxX1cACCa78rphLQuibpydTCffgFiKiewDsNaAg>
    <xme:08I8YE8hEbWQuY8uq7Kb01D8jzEMYxWfme6QrcQq9P7_Ys43PlIgW9XEIcZlS8za5
    258iK1A5I_NKw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdduhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:08I8YNSAbKo3iB3pW3mI1cerbwp0XQh-H_J3Ig3iUyB4HM4hejNcCA>
    <xmx:08I8YGu-ROzpOw_AWY1_0CzRfXSBAOzyGONufNEArUbqnISrryTY9A>
    <xmx:08I8YOf5QO1wz53TdHEB7sQ-ZakWKq2adr1DZcVEpsNLlwC7ZKubWg>
    <xmx:08I8YCEM7zywZyeIajimFpaR5SyXLFLMl4bi1dKxkSCRsWLI-zX-JQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3151E1080057;
        Mon,  1 Mar 2021 05:32:51 -0500 (EST)
Subject: FAILED: patch "[PATCH] drivers: soc: atmel: add null entry at the end of" failed to apply to 4.19-stable tree
To:     claudiu.beznea@microchip.com, arnd@arndb.de,
        nicolas.ferre@microchip.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:32:41 +0100
Message-ID: <161459476118180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From 975435132ecfef8de2118668c9f4f95086a0aae5 Mon Sep 17 00:00:00 2001
From: Claudiu Beznea <claudiu.beznea@microchip.com>
Date: Fri, 22 Jan 2021 14:21:34 +0200
Subject: [PATCH] drivers: soc: atmel: add null entry at the end of
 at91_soc_allowed_list[]

of_match_node() calls __of_match_node() which loops though the entries of
matches array. It stops when condition:
(matches->name[0] || matches->type[0] || matches->compatible[0]) is
false. Thus, add a null entry at the end of at91_soc_allowed_list[]
array.

Fixes: caab13b49604 ("drivers: soc: atmel: Avoid calling at91_soc_init on non AT91 SoCs")
Cc: stable@vger.kernel.org #4.12+
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>

diff --git a/drivers/soc/atmel/soc.c b/drivers/soc/atmel/soc.c
index 728d461ad6d6..698d21f50516 100644
--- a/drivers/soc/atmel/soc.c
+++ b/drivers/soc/atmel/soc.c
@@ -275,7 +275,8 @@ static const struct of_device_id at91_soc_allowed_list[] __initconst = {
 	{ .compatible = "atmel,at91rm9200", },
 	{ .compatible = "atmel,at91sam9", },
 	{ .compatible = "atmel,sama5", },
-	{ .compatible = "atmel,samv7", }
+	{ .compatible = "atmel,samv7", },
+	{ }
 };
 
 static int __init atmel_soc_device_init(void)

