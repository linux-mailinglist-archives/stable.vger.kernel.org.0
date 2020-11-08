Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6DE22AAD20
	for <lists+stable@lfdr.de>; Sun,  8 Nov 2020 20:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgKHTHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Nov 2020 14:07:36 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:55455 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727570AbgKHTHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Nov 2020 14:07:36 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 53D922E6;
        Sun,  8 Nov 2020 14:07:35 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 08 Nov 2020 14:07:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=49ZJa/
        56BHAadQ1X8ExU+DkPBTJL98ZbzgKi3eOh4ds=; b=NsQnZ3kFnYeA7poKoj799k
        cjs4/HFZ6aQoFRYgPJDBAaGNE9wle3Bm8Y/eCMvIzcGlDXdg5TUx8QqM05AzDfa8
        6d6P7JsLaVQdkk31YMtoRHvHCmtpr6gk7A6fBU0zCg7ekvbYJY2hrj5qTITUWmVD
        3zVl4XKDJEMP2lsMKUaiDGEcrtpgtgODaUUQUoTlmrSb81fXm4A7bsjTKB/fRb+q
        lkyg9jgLUIQbJPmFfxzeDleugkmatQ0tIcmwiHheVXka/KgZ9lBA9Fd8NO02pyQp
        PE/q7mg3zT4QDTrp+VssR2/RAlSOHDKMQhxJcIfGo7ppO1rX+ia6pnfp31w8D7eg
        ==
X-ME-Sender: <xms:9kGoX2MZcqC1qBwpm421WCNQIFNODDWmfvwCW8zcOK-dhmS-k1pzvg>
    <xme:9kGoX0_dnVySSCzbKSxiej57rmKC17EGIG085QiYYeuoMqCCwlyKkryayL9wOrlR-
    DDEUQ89lSKZ4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddufedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeekjefgffetgfevgeeghedugfelheektdehtdeihf
    eileeiteevjedvgfdvleejleenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:9kGoX9SMQMJB6FQUPeeLBZwZ82QxmAtnUv_f2UwvH9D46_iJO_aEwg>
    <xmx:9kGoX2vaVaS0ldpbnwVmJcjLTl6_fsyRb8FcbuEb3pNGdPDwauFj0w>
    <xmx:9kGoX-flsXutwJfc0kUNonRt8eL_jfdqIUfAKLCghtuqWPpJ97nlAQ>
    <xmx:9kGoX_oo599QBmBF1S3FlspNfpZNPFOpEEZmiYEfqbfYLBt7antv2kdJ4uc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 14FE9328005E;
        Sun,  8 Nov 2020 14:07:33 -0500 (EST)
Subject: FAILED: patch "[PATCH] regulator: defer probe when trying to get voltage from" failed to apply to 4.9-stable tree
To:     mirq-linux@rere.qmqm.pl, broonie@kernel.org,
        clabbe.montjoie@gmail.com, megous@megous.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 08 Nov 2020 20:08:36 +0100
Message-ID: <1604862516211197@kroah.com>
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

