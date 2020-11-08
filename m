Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF85E2AAD22
	for <lists+stable@lfdr.de>; Sun,  8 Nov 2020 20:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgKHTHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Nov 2020 14:07:46 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:59461 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727570AbgKHTHq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Nov 2020 14:07:46 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 190148EE;
        Sun,  8 Nov 2020 14:07:45 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 08 Nov 2020 14:07:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ougGoI
        cIYr9hi1k/LBjYgR8aBGTgehlYWKUloIV7DwU=; b=TGUbKih8PwtKY16i0Rqjkj
        LNS7mbooK7/mGDNx2rR/Ymjq4et3Dkl2XzujkYljtCuwY2bvcwWIbAcMcweun46u
        0zjin99aHHhjhD/DNxxWEmn9uLwlP3pqTzCMYwLB8rHUg80pU4UuiHHOKb5g16mv
        qeyWXcbR62Ny6LZdiKNpQm5tPAKTq2kWMkhvzsXkAhOpYehfE4pNL+l7xplMrrwm
        ITgTnkMonenU8HPU4AZroTcuSR9hApoYn/3mKGBy5VUNv5zJ6PmffFXPtLp9O379
        Y9gG0/xDHuKACH6Q8wEPygLjWNQdJUO0Hpl+aCcyy3rFHIg+NI1Ued9tKQfpg7VA
        ==
X-ME-Sender: <xms:AEKoX5p4dtW6E9WhCa1DgHRT2_ySLItqw7hOr1icEzHuD-gCGk6LQQ>
    <xme:AEKoX7rRuVXPKLCNnKsNcBF3gy3tHndmxyQDMOPC62ruPus8mN8ExOs5fSxqhhXOj
    oB3-LrYfLJMDw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddufedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeekjefgffetgfevgeeghedugfelheektdehtdeihf
    eileeiteevjedvgfdvleejleenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:AEKoX2PAYw2yJGLOKjdYJj0rzUvz2LDy5E8U5qzyAMqC7YiRKH53jQ>
    <xmx:AEKoX05Iecwe67xF9buGOL7olJ_g_tiNir3e-kdqTPe2C2kgwZcEow>
    <xmx:AEKoX46hxY4dVk3UWBqBSI3jzbRZxhPI1NeTkXTVAs_qMLo-5J0zbA>
    <xmx:AEKoX4ESIm9pd4cmllwUqHxd09gESz6gi0KWNH6r-k51Z_zNdWGnkzF0_G8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 41CC13280059;
        Sun,  8 Nov 2020 14:07:44 -0500 (EST)
Subject: FAILED: patch "[PATCH] regulator: defer probe when trying to get voltage from" failed to apply to 4.14-stable tree
To:     mirq-linux@rere.qmqm.pl, broonie@kernel.org,
        clabbe.montjoie@gmail.com, megous@megous.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 08 Nov 2020 20:08:37 +0100
Message-ID: <16048625179740@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From cf1ad559a20d1930aa7b47a52f54e1f8718de301 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Date: Mon, 2 Nov 2020 22:27:27 +0100
Subject: [PATCH] regulator: defer probe when trying to get voltage from
 unresolved supply
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

regulator_get_voltage_rdev() is called in regulator probe() when
applying machine constraints.  The "fixed" commit exposed the problem
that non-bypassed regulators can forward the request to its parent
(like bypassed ones) supply. Return -EPROBE_DEFER when the supply
is expected but not resolved yet.

Fixes: aea6cb99703e ("regulator: resolve supply after creating regulator")
Cc: stable@vger.kernel.org
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Reported-by: Ondřej Jirman <megous@megous.com>
Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Ondřej Jirman <megous@megous.com>
Link: https://lore.kernel.org/r/a9041d68b4d35e4a2dd71629c8a6422662acb5ee.1604351936.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index a4ffd71696da..a5ad553da8cd 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -4165,6 +4165,8 @@ int regulator_get_voltage_rdev(struct regulator_dev *rdev)
 		ret = rdev->desc->fixed_uV;
 	} else if (rdev->supply) {
 		ret = regulator_get_voltage_rdev(rdev->supply->rdev);
+	} else if (rdev->supply_name) {
+		return -EPROBE_DEFER;
 	} else {
 		return -EINVAL;
 	}

