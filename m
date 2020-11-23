Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF742C0226
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 10:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgKWJTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 04:19:08 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:36535 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726979AbgKWJTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 04:19:08 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 6563DF50;
        Mon, 23 Nov 2020 04:19:07 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 23 Nov 2020 04:19:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=HC1A+i
        AKBeU0CG2d/QwodCHnDrXxS+l+WNbaea59MLY=; b=Vq+dYQog5ogQDLZloTqz+U
        N+P2sdxMR5ZXUbFGZv22uH/58uGhY6JQaQL67RBj4CG1/+DABD3gSY1zRG3LHUTR
        DU0pNZ4O2NhbwFS9/2mk1dnj9bn9XC7RPnTbBFyXR1rH3yZZCFtJibcIJID4ZyV1
        0VBTf1go70TsqqP8DRqCMx1Zpme71u1EYbGpUR/Rt0jqdJ5sFsiAIWwp78ta9uTE
        2tbnnkMwIlYwkHjU2Rbcdk2HGijDaPnfciwZikFkgx1cukK5N8kQvXWIS6buKUvr
        OOMTo+3Gi9tKVA2XMzW0Cl/wkELopXBoAGGU1xQDYj87oi7rwWt1EQBzj7u5q/hA
        ==
X-ME-Sender: <xms:in67X0r2G2wJc1ErQM5CbBEv51mjgGIVucjac-kYHmOYFwAqHRu2Ng>
    <xme:in67X6p1XKdH3K3ct2mm6gQmfj5GoScdYBTHiPgb4JFMLrYG_aTnkJcR-zRfAIq53
    fj9lem7vGSiCQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudegiedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:in67X5MtLTACFhjANA2ST24mmk7NPyfITek5KdUnAgKwxHXM3gxzNw>
    <xmx:in67X77lldx8yIhmNxz1JvyaW9gI6Cgno8V4Rb9ohASkAtQYrnbziw>
    <xmx:in67Xz5Kp2NeLb23_sP6iUudi6NB5HUYLZL8Z1fkRvtinxX5UKMW4w>
    <xmx:i367X9Sq0NrxlJqksJ4tD6q2kvKwmokpqq8GfpgZgBqM1HgQH0eDdNiFQy8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 859BF3064AAE;
        Mon, 23 Nov 2020 04:19:06 -0500 (EST)
Subject: FAILED: patch "[PATCH] regulator: workaround self-referent regulators" failed to apply to 4.9-stable tree
To:     mirq-linux@rere.qmqm.pl, a.fatoum@pengutronix.de,
        broonie@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Nov 2020 10:20:17 +0100
Message-ID: <160612321754170@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From f5c042b23f7429e5c2ac987b01a31c69059a978b Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Date: Fri, 13 Nov 2020 01:20:28 +0100
Subject: [PATCH] regulator: workaround self-referent regulators
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Workaround regulators whose supply name happens to be the same as its
own name. This fixes boards that used to work before the early supply
resolving was removed. The error message is left in place so that
offending drivers can be detected.

Fixes: aea6cb99703e ("regulator: resolve supply after creating regulator")
Cc: stable@vger.kernel.org
Reported-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de> # stpmic1
Link: https://lore.kernel.org/r/d703acde2a93100c3c7a81059d716c50ad1b1f52.1605226675.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index d3b96efa20fd..42bbd99a36ac 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1844,7 +1844,10 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
 	if (r == rdev) {
 		dev_err(dev, "Supply for %s (%s) resolved to itself\n",
 			rdev->desc->name, rdev->supply_name);
-		return -EINVAL;
+		if (!have_full_constraints())
+			return -EINVAL;
+		r = dummy_regulator_rdev;
+		get_device(&r->dev);
 	}
 
 	/*

