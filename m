Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694BE327C4A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbhCAKfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:35:38 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:52071 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234588AbhCAKeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:34:02 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 74334194073C;
        Mon,  1 Mar 2021 05:32:55 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 05:32:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=bpjUCj
        1wMFpDfutEq1reUPvm+2n/7+eAlhtZXO1vR+w=; b=jMs+3GuhEriYXRSNRqr8Rc
        8ZmoPkcU6/26vtLFupDCRCVrljB9OgE4jyNp+MjZwHBo4j4SeeU5hd4GPlTdy3p9
        4iwp2WUhuJPEsHnhy2YJmTDZSe+X0qUcOVYvYDDpmUeEe062QVP+8a8dhZtzwGvF
        Jblv/7GHKx1W3cIoRjgsq2gI9ZbWvqmu9HaP1yUFJGQPsksTlFfwpe5cDHcLTqBI
        o4WXV5lVf+caG2CYHB1yGkRGpX97kN1ZDW9aT/cN9M5ctsAdNd2nc/Wh4XVOPxKn
        66gRVPz91tHHo802izZUtNgqCxqlVk1X3j59Q+NsM/diUAL+vM5dM7CTwO15F94Q
        ==
X-ME-Sender: <xms:18I8YEL_AO-HRToE-IiBgGyg-8jJQ_JXZpcohOEnNmsjdpdwkTh3xg>
    <xme:18I8YEIXkH0orGlkugsvf7EjYIDFiZNlldhpp85jwnnVrh5lTQyjqgno3w6LeL2i-
    kpkPxm7-BTz-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdduhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:18I8YEuLd48_NtxYVPKS2E-iGgkcFPpnfeMQPHPxyEtZXFtnNBPV6Q>
    <xmx:18I8YBYdEzWjU5oSmQDJCziA91QTjgM26wwkgL8snRLwO44F2zOjmA>
    <xmx:18I8YLbq0OW01QVDbELQuZMZx9sMGCusjdEYUhbVw8wJ6k6_nk87Qg>
    <xmx:18I8YCx1DLDCsenov0qK9zJIsL3RmDZaf-Vlvw-l_lDEhYH9xN9-oA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 22849240057;
        Mon,  1 Mar 2021 05:32:55 -0500 (EST)
Subject: FAILED: patch "[PATCH] drivers: soc: atmel: add null entry at the end of" failed to apply to 5.4-stable tree
To:     claudiu.beznea@microchip.com, arnd@arndb.de,
        nicolas.ferre@microchip.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:32:42 +0100
Message-ID: <1614594762206238@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

