Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC6C24ED39
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 14:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgHWMdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 08:33:47 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:59483 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727843AbgHWMdq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Aug 2020 08:33:46 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 50EDD1940F2E;
        Sun, 23 Aug 2020 08:33:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 23 Aug 2020 08:33:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=vm7hKQ
        RHfrNIAXGGZhhMj8F1yKs8UY2A5l0yjwYCFr4=; b=RN6JG5qrsQdsLGAVaRM25q
        n/OrudkDy8dOdt4/1li2aiS1bxRJ+l6OadX+Iu/dBTO4Or87suEjnJtpFZhOlWah
        laG3HOKKUGHQS1s39Me43l5lENm7cgl2GF+fu5N4LNv2y2bmicVQP6xK3Bmlsvb3
        V7g9MBrSMNZTiIUF5mSGPNw1PDAqgzE2btQ0AtgCUnCpOzy5TM3whVHueYfGbrD/
        JpYWbhX2zS6EcuU2k8x9ZAnzVCWNbK94L6pc2F48pXzkKRddybajezcwUzMqISkA
        01FBAkU91nGp1eXvfjbS0k0hvS/tEL0/qsq9plTijZ28wyC6GBPs4Djryowa5z+g
        ==
X-ME-Sender: <xms:KWJCX1I4jgQbryllTfWpjCthjxCPI2p8CEiZLUsCY3ob9zaAxqeYUg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudduiedgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:KWJCXxLDtQY-vCY1X7nBSANP4_Ay8QnyGMj76o3uEhV4xRKm0VE2RQ>
    <xmx:KWJCX9uSnpBngzA6o2fEb1HlX2NeBkdpmyKVXlKzy0eQFfw8yRDUlQ>
    <xmx:KWJCX2a1PJxiR3bmdGLj33gTsANb4WsI6BSXn9ahuhUYvphfW0FaZw>
    <xmx:KWJCX0GCnYnx07omBwJsEeQbveU1UZZvlcZC5pj5eP4jQDpHa4yx6g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D4B6A30600A9;
        Sun, 23 Aug 2020 08:33:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] opp: Enable resources again if they were disabled earlier" failed to apply to 5.4-stable tree
To:     rnayak@codeaurora.org, mka@chromium.org, sbhanu@codeaurora.org,
        sboyd@kernel.org, sibis@codeaurora.org, stable@vger.kernel.org,
        viresh.kumar@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Aug 2020 14:34:05 +0200
Message-ID: <15981860458624@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From a4501bac0e553bed117b7e1b166d49731caf7260 Mon Sep 17 00:00:00 2001
From: Rajendra Nayak <rnayak@codeaurora.org>
Date: Mon, 10 Aug 2020 12:36:19 +0530
Subject: [PATCH] opp: Enable resources again if they were disabled earlier

dev_pm_opp_set_rate() can now be called with freq = 0 in order
to either drop performance or bandwidth votes or to disable
regulators on platforms which support them.

In such cases, a subsequent call to dev_pm_opp_set_rate() with
the same frequency ends up returning early because 'old_freq == freq'

Instead make it fall through and put back the dropped performance
and bandwidth votes and/or enable back the regulators.

Cc: v5.3+ <stable@vger.kernel.org> # v5.3+
Fixes: cd7ea582866f ("opp: Make dev_pm_opp_set_rate() handle freq = 0 to drop performance votes")
Reported-by: Sajida Bhanu <sbhanu@codeaurora.org>
Reviewed-by: Sibi Sankar <sibis@codeaurora.org>
Reported-by: Matthias Kaehlcke <mka@chromium.org>
Tested-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
[ Viresh: Don't skip clk_set_rate() and massaged changelog ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index bdb028c7793d..9668ea04cc80 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -934,10 +934,13 @@ int dev_pm_opp_set_rate(struct device *dev, unsigned long target_freq)
 
 	/* Return early if nothing to do */
 	if (old_freq == freq) {
-		dev_dbg(dev, "%s: old/new frequencies (%lu Hz) are same, nothing to do\n",
-			__func__, freq);
-		ret = 0;
-		goto put_opp_table;
+		if (!opp_table->required_opp_tables && !opp_table->regulators &&
+		    !opp_table->paths) {
+			dev_dbg(dev, "%s: old/new frequencies (%lu Hz) are same, nothing to do\n",
+				__func__, freq);
+			ret = 0;
+			goto put_opp_table;
+		}
 	}
 
 	/*

