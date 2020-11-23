Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1002C0222
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 10:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgKWJSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 04:18:54 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:46405 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725287AbgKWJSy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 04:18:54 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 23C96F93;
        Mon, 23 Nov 2020 04:18:53 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 23 Nov 2020 04:18:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Di8KaP
        3MRrajRNQ8UPzMr0cGCNlzxn0uhUHKeBNKpUA=; b=bk4LDik55dah6AClpPfzap
        HZPodoCuo+gMsz2UglsT3FVMzTCZeAEGAcVATMcTA8jbn2DeKfygmjcIAlMK5hUm
        zRUsNs3Q24A9DrR6XgThQxcKakbQiae3mh2Ofn74WzXZEsj9ht+nDFXZvXxz6GVE
        6vfTPFclEx/hTC6IjGQkVnT8pXrxjMTAGkG0z0XX36KFq5ecNKMbGdN+hFCl0OxO
        Y7C/hZweKrmRkxm9OT2bbcReSzerTDp21wMqwLjIy+g30Z1ltUHw3z8t4qFXDJiP
        5+SzXnq1URQ9FrIHFC1fk3BGaA5H5E0jovkm4Xz37/q1vdLUEKfUMMpXZabrfekg
        ==
X-ME-Sender: <xms:e367X7QNw31dXxAqNTwEtoSci8ILE9lsQglCpvpWHJb6MUSIy5vr1A>
    <xme:e367X8ypQszi4i5ko6EL8zGa_CN5J8g3_ax75mndc4cAKZ6UEP42hGI5Tqjc0vTiu
    -GZhpcRW-zhqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudegiedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:e367Xw3sX0SNUG758JFj0_dCHgs1GzLGbux-XBL_40QgoYPutcE9yA>
    <xmx:e367X7CbynFoYOxoeP6oHC2Y1XpeShsX4O0sj9oxJPMK2rfV9CjhRA>
    <xmx:e367X0guqN37srUgnjneYEVcICYeJsIxT0JvmRoBRDFBugChg3T29A>
    <xmx:fH67XwZtl23ZOxX-AcgEFT3pmk_C32TcbGTq7YvOHh7Z5hcnROwFSSecDk0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2A798328005D;
        Mon, 23 Nov 2020 04:18:51 -0500 (EST)
Subject: FAILED: patch "[PATCH] regulator: avoid resolve_supply() infinite recursion" failed to apply to 4.9-stable tree
To:     mirq-linux@rere.qmqm.pl, a.fatoum@pengutronix.de,
        broonie@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Nov 2020 10:20:02 +0100
Message-ID: <160612320295192@kroah.com>
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

From 4b639e254d3d4f15ee4ff2b890a447204cfbeea9 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Date: Fri, 13 Nov 2020 01:20:28 +0100
Subject: [PATCH] regulator: avoid resolve_supply() infinite recursion
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When a regulator's name equals its supply's name the
regulator_resolve_supply() recurses indefinitely. Add a check
so that debugging the problem is easier. The "fixed" commit
just exposed the problem.

Fixes: aea6cb99703e ("regulator: resolve supply after creating regulator")
Cc: stable@vger.kernel.org
Reported-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de> # stpmic1
Link: https://lore.kernel.org/r/c6171057cfc0896f950c4d8cb82df0f9f1b89ad9.1605226675.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 84dd0aea97c5..d3b96efa20fd 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1841,6 +1841,12 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
 		}
 	}
 
+	if (r == rdev) {
+		dev_err(dev, "Supply for %s (%s) resolved to itself\n",
+			rdev->desc->name, rdev->supply_name);
+		return -EINVAL;
+	}
+
 	/*
 	 * If the supply's parent device is not the same as the
 	 * regulator's parent device, then ensure the parent device

