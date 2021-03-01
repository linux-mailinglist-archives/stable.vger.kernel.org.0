Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44474327C3E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234522AbhCAKdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:33:39 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:58725 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234567AbhCAKdc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:33:32 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 4BCF81940669;
        Mon,  1 Mar 2021 05:32:44 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 05:32:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=x4xNMJ
        fAhie/WWwHtbCh8oNAvQRFpKlXYE+hVIHw8AA=; b=Hsf8b5zm7bXFo7W0g2tFG9
        HNZr8NtbTkZvG09um7U0ywD7ymWSfk+FVpDwFzOUTAYGzNJ187wMsB6eobkFLeGT
        lRN/NsjhpIZRk8xb58A6spH0dK++89ZfsbGH2hAaHvOv9EZlxzkotU0RoQq0nlOW
        vnnODOu4PzDaaXUtCWwr5+0GWo2j2FAlgmtwRDTT5W9UmTJYgg+It0uDxowFrFez
        uTacQhXh8nVieZEUQAvtFZHtz8OV+TomV2YJIzB6QeEcvpl/inmcN4esHolUyHsg
        BVLMVC5OTfb8G8JcOm7q1oZUl+zJ6b1lDzmbfb2RzyeRSuMBr3HPyTAX0JmT9YJA
        ==
X-ME-Sender: <xms:y8I8YGdUZ9INn-6aCX4gECLFqRIn_UNPn6p2H9ZbFCQq7DJWUD6nfA>
    <xme:y8I8YAOWvdT9SQf75ZzEurzhAm0Ep3meRBNSWzuEAOc-BsG2laoXMnLiFjYwKr-8U
    T2GlyTVqDAjog>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdduhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:y8I8YHjpo8VSNPwO8hMm29ErAInAaPojbiSRiGN9pRqy8eWkGDkxIg>
    <xmx:y8I8YD-kD_qvEHgM9Szkt1VmS9cfAqTECwIkhxTYwNMLm3_WY0bdtw>
    <xmx:y8I8YCtNkc63xIfApk5qxFnBDpIWsqymP5xSZe7us6EefLyfgVFQ5w>
    <xmx:zMI8YHVYeey_4A0jmQOpQARkBChbDNifkwDnCbVgjmps52qEve0HmA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 73B69108005C;
        Mon,  1 Mar 2021 05:32:43 -0500 (EST)
Subject: FAILED: patch "[PATCH] drivers: soc: atmel: add null entry at the end of" failed to apply to 4.14-stable tree
To:     claudiu.beznea@microchip.com, arnd@arndb.de,
        nicolas.ferre@microchip.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:32:41 +0100
Message-ID: <161459476197245@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

