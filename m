Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051FB327C45
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbhCAKfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:35:13 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:33197 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234586AbhCAKeB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:34:01 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 5E9D01940753;
        Mon,  1 Mar 2021 05:32:53 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 05:32:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=LvTmfb
        ys/8VGHBpgm5fWHE38gFQgb9tDAwWASHhzNtw=; b=r1OE3iNJE9U2p/oqMPOAtX
        pfH03ai1zkqNjJBeglRA4b0jkQusCzeNnJ0BD1sJm6r88Q5CuSfc+Izu/YkHry/5
        mYJycRuso/aDYlH8TfbRXWo39n7bDBVyWFczAHTS7E2ArUjcpZsI6VGhQiopWl8a
        ts1NUFpcEiZqZYAIwzTOmjN7MS+j0r3P18xJnuS6FdGVAlJRDcg0Rr8wX40eJxkh
        Qei4TH/cYE6rhhFjJE6t4td7NUy9RlTJdrTlvZYrqSlIxQaOOxfbtrzje+Fu+j0R
        EZiblkqf9eGZVDwRSW53qCxR2xbjWFBJtUal/9BisH5FN39u2hTjJcGDHDW1v+GQ
        ==
X-ME-Sender: <xms:1cI8YP05-ndbQcZRnRm5HqX0YId_s8cieQd4ntiNFlK6aHM6fVb3OA>
    <xme:1cI8YOEa1gjcS0ZNB7fZJGRtg86fefQ8qAIBpjnVx4CPPuFI1MsdoKeBlpNYkstYK
    gLtNXRQMCNCCA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdduhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:1cI8YP7vG_w3tFcyUPlpr7E6ws5M82V5ZjllHNuCQem4Ruc14aTZow>
    <xmx:1cI8YE3Pjji4xuek-F59IvU0AlH6kzg9V4a2tAJH43onxrHKIUKabg>
    <xmx:1cI8YCE2TYCFS-r_k_BLnaVUgV9ZDFQo6rr4vAXoQGCqkqQJaj5xvA>
    <xmx:1cI8YEOXoeGaCMrFFaoz8wHVtkyBMOEAKG0w_GsEVRSopKLeFhR4eg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EEE961080057;
        Mon,  1 Mar 2021 05:32:52 -0500 (EST)
Subject: FAILED: patch "[PATCH] drivers: soc: atmel: add null entry at the end of" failed to apply to 5.10-stable tree
To:     claudiu.beznea@microchip.com, arnd@arndb.de,
        nicolas.ferre@microchip.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:32:42 +0100
Message-ID: <161459476232242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
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

