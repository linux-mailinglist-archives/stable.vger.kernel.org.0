Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0707424ED38
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 14:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgHWMdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 08:33:05 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:59025 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727843AbgHWMdE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Aug 2020 08:33:04 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7A4161940C1A;
        Sun, 23 Aug 2020 08:33:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 23 Aug 2020 08:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=N6oLua
        fyTQC6UkHRrA5h08AwO7XQWG2U0YlikLTPcLc=; b=myunSKmVogJLiEVvzO9VbQ
        HdKJk6Pbm789eZ4P7opgfjTqsK+0UVFnLKE89dP18sMJsP8FbacbsOPsze9BBQv4
        QFpyhwW3W+FI+ZyVzxVx+TwLGOouhsaSc5DjLnhAnbkJfLnDbumV1kPBjAP7epnd
        bVPoVnozcgNfSMG2/0yktUXyOGBr0crMnGHQuF384HiFBbfK8fJ9doXE+hAq8itS
        600WLHLCi7Z5P00c0YGiLM257MwDLtYNtzDV+eN32Lr5GiUB9eHl8AZSbzDGsyE6
        oZxb3T/jWbS+IaLgzUVFCOakS7C+vLHPCoEqMVrum267cmqwRNwl5spmdJMiuyOg
        ==
X-ME-Sender: <xms:_2FCXxZydSpsh-U_gwMGpZTG7PvD8Qq6YusbYDEq74V-aSNIGVvvkg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudduiedgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:_2FCX4ZzvyDE4QMUlfsWewCmkN0ic19Pk0bEiEfkZn_p-BUf39vLkg>
    <xmx:_2FCXz_sNp6__hG0HI-EP3i5WMg59K4yXLGpP8LTMg1Qisf3ervy3Q>
    <xmx:_2FCX_qcmmbW55IsXcDmLaNOWEQxSF6kftlzhHxyE5gig1oCf1alYQ>
    <xmx:_2FCX3WINl6MMisQlDQMbCUBmzu36IqAWFtroHkYD8ihtBMDfvzY8g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DD43930600A9;
        Sun, 23 Aug 2020 08:33:02 -0400 (EDT)
Subject: FAILED: patch "[PATCH] opp: Enable resources again if they were disabled earlier" failed to apply to 5.7-stable tree
To:     rnayak@codeaurora.org, mka@chromium.org, sbhanu@codeaurora.org,
        sboyd@kernel.org, sibis@codeaurora.org, stable@vger.kernel.org,
        viresh.kumar@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Aug 2020 14:33:23 +0200
Message-ID: <159818600314448@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
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

