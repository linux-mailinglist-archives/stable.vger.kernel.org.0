Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D1A216DD6
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 15:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgGGNg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 09:36:29 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:59241 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727936AbgGGNg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 09:36:29 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id C3A831942974;
        Tue,  7 Jul 2020 09:36:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 07 Jul 2020 09:36:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=GWu+a1
        ozUVBEY2MOIpqd94u7UyOaznyW7JZYFXQUoNU=; b=DOXYDSIaaruBJg7WWva6Hh
        mZ0Efwm53wO10Iu7Qs+1TGItixnO3U85U6kPRmO8XVZAVaqKroT3woODXXmd+Kr8
        rCBYW5HkOwvaJdabHWk47NRMPnjrM7F3M82DlPlkdj1XwhZDm0iAORNvmosxmFTo
        pxJaN3eKWk4+r02YV8DlAX6fuRO0PPIyZMgiaJjNM0RbN1TB1WE7vFberBeLd9S/
        D6D/d2qthFaJJzotNTEacBV2hgcqOyA4L8F1/fZTHAHt6/t2OFsOtdMnyaRSSP0G
        1/R0L4083d7nhlrMeTvNT/5UUs0xl1cSmjcOQ2U/SgKWjJYti3e+QyMg0E5K4n4w
        ==
X-ME-Sender: <xms:WnoEX1_c9GNmvtsYZrS22aFefIgKADRDoiDMOipssi1Ttc_FsZpm7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:WnoEX5tKyV6u-8mds7s2c7rzwycBd5cHyXPR65bsnuLNRrd7Jqsyng>
    <xmx:WnoEXzBeAF2kP064z7POMWmJBDIsnTivAR2q79t8H5fGr750AiAIuQ>
    <xmx:WnoEX5em6qaLgXhnFL5MAhgXfZaxPT1jmddwbdxhVzLm6SuFQWp32Q>
    <xmx:W3oEX81N4Tk31G374aecgVsdt43J3mNennwfjUL1ASk6NuRZC7eJgA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C0AC33060067;
        Tue,  7 Jul 2020 09:36:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] thermal/drivers/cpufreq_cooling: Fix wrong frequency" failed to apply to 5.4-stable tree
To:     finley.xiao@rock-chips.com, amit.kucheria@linaro.org,
        daniel.lezcano@linaro.org, stable@vger.kernel.org,
        viresh.kumar@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Jul 2020 15:36:24 +0200
Message-ID: <159412898413424@kroah.com>
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

From 371a3bc79c11b707d7a1b7a2c938dc3cc042fffb Mon Sep 17 00:00:00 2001
From: Finley Xiao <finley.xiao@rock-chips.com>
Date: Fri, 19 Jun 2020 17:08:25 +0800
Subject: [PATCH] thermal/drivers/cpufreq_cooling: Fix wrong frequency
 converted from power

The function cpu_power_to_freq is used to find a frequency and set the
cooling device to consume at most the power to be converted. For example,
if the power to be converted is 80mW, and the em table is as follow.
struct em_cap_state table[] = {
	/* KHz     mW */
	{ 1008000, 36, 0 },
	{ 1200000, 49, 0 },
	{ 1296000, 59, 0 },
	{ 1416000, 72, 0 },
	{ 1512000, 86, 0 },
};
The target frequency should be 1416000KHz, not 1512000KHz.

Fixes: 349d39dc5739 ("thermal: cpu_cooling: merge frequency and power tables")
Cc: <stable@vger.kernel.org> # v4.13+
Signed-off-by: Finley Xiao <finley.xiao@rock-chips.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20200619090825.32747-1-finley.xiao@rock-chips.com

diff --git a/drivers/thermal/cpufreq_cooling.c b/drivers/thermal/cpufreq_cooling.c
index 9e124020519f..6c0e1b053126 100644
--- a/drivers/thermal/cpufreq_cooling.c
+++ b/drivers/thermal/cpufreq_cooling.c
@@ -123,12 +123,12 @@ static u32 cpu_power_to_freq(struct cpufreq_cooling_device *cpufreq_cdev,
 {
 	int i;
 
-	for (i = cpufreq_cdev->max_level - 1; i >= 0; i--) {
-		if (power > cpufreq_cdev->em->table[i].power)
+	for (i = cpufreq_cdev->max_level; i >= 0; i--) {
+		if (power >= cpufreq_cdev->em->table[i].power)
 			break;
 	}
 
-	return cpufreq_cdev->em->table[i + 1].frequency;
+	return cpufreq_cdev->em->table[i].frequency;
 }
 
 /**

