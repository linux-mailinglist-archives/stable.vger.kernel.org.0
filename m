Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E25327C44
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234535AbhCAKfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:35:06 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:40791 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234572AbhCAKds (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:33:48 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7C8081940773;
        Mon,  1 Mar 2021 05:32:57 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 01 Mar 2021 05:32:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=TaypH2
        q96SsmgChOpB1oQNY7S60nwipUhlt0Sg6fuFE=; b=XXa3GwTzdteE41Bpp/SR5n
        yi0g8Luyz7Yg6D99E4oXt25kMW/ggP1uq5EbA0YG1ft/Naz0irG+qmsFVrYSH29j
        zg5TLqFUCry7GlWXV9DA9s5RBUJzzHSNtpSEhUaM1BBVC0ex9XGpnCvevxDYUqVE
        KVmd0rnJWa5sH07Uf7c2WdnhFh2reklKUAabG5vYthehKPsWtqHNexvRbUxOMVVY
        4y5Hi4uimGOf8dN00TcJdjip3w8oHSgM1mhLq+ammHLnC3c3yHRK3vXtYMmbwc4f
        gVCFsq8u/xfNq9RDI1Y457r05pzHuDrduk+Ht1GnXrGLlaFEJV1QXdtl0BD7FxcQ
        ==
X-ME-Sender: <xms:2cI8YCWN2u2TITtCRvHeWuVtUBXDunF9slK60MNsO169J5exvH3OYA>
    <xme:2cI8YC1MHnZxLTJnW30w-z6KCbxwRmUr971188mPmTSRcZ1LjQcYe625J5EIrokQv
    53kv0jZGDqPTA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdduhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:2cI8YBbKfYSrRNvjT7DGw2GY9Hso3fOEzpEcQ5FAw2FkmgJ206GK1A>
    <xmx:2cI8YNrYZdyFR6o1hMJKS5z9WdK2tPYdsIuJBNr2vmN251ltjDbhBQ>
    <xmx:2cI8YFrQvCVeCFEae8f9oHA8a8gF5IbzW5jqvBDeABP-aq4iPdoHoQ>
    <xmx:2cI8YBlUz8UGFz6HZDYXuDk-CrTIo8vtAmCtDEWKXD17iud_w2UDtQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EC9AF1080059;
        Mon,  1 Mar 2021 05:32:56 -0500 (EST)
Subject: FAILED: patch "[PATCH] drivers: soc: atmel: add null entry at the end of" failed to apply to 5.11-stable tree
To:     claudiu.beznea@microchip.com, arnd@arndb.de,
        nicolas.ferre@microchip.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:32:43 +0100
Message-ID: <1614594763159213@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
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

