Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3BE72E36C0
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgL1LsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:48:23 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:33843 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726263AbgL1LsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:48:22 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 07F872D0;
        Mon, 28 Dec 2020 06:47:16 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:47:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ciTxRy
        icXrLpazs68glUa663XMjUjttdDm1ooaQzh+s=; b=j4mjZWW8Y2XQVpIc+yIxvc
        WbilqQfnrrfGTa3F5gx8P49XYRsXf5EgUzBakKQBfldScPF63z2T0y2YNDrY6Jy0
        ZyfxxNZozssYk6DxR459MOx/QRCgLlRXa+5y/6Tx7ZI5MPmu5IV6H9IfCSUlZWkp
        sljjdvoaZZMK5f0Es/q/c90yue0VvLzqSUMVix6DabLurCvxnUDNgZVf7VOUJwRo
        AZuouS1tENGWgKY5v04acC9KB8TETBJzxU1t9KeSHFpOhHDeQpwbc35um14vGyxF
        Ovy+hzMQJapFWPvrw9tlmAgXEZ2DXnuu2S4A+qaN7qLIfz74XOhE2xoHHNvDONqQ
        ==
X-ME-Sender: <xms:w8XpX-9vzvPDjEpArjJW8L_OLRPDNQ3FGHVXPOrGgFr3YPfrTywn3A>
    <xme:w8XpX-t-wAH_ZSTLPHdTWy_aJXMha83PcmAtMeBQwApcnM4DHAG6mRWB2gYZRF76u
    97wNweInX9Zdw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:w8XpX0CEAXP3ISsWxV8__jbUpphIXwV6yCNccjCDQHqXi6p4zXOW7A>
    <xmx:w8XpX2c7WgT7SxaEzdWpk7a_4X73GzgEylODRqAdsMpvDDO_s0BeAA>
    <xmx:w8XpXzOZAT2Mz2u3AIjTWkvqUOYAMTQYKkp6tx3IQeY5P-CdrumOsQ>
    <xmx:xMXpX52swERW14FDc5HmG-RdQ3LKXeBlfANZRcnOnjhp8tk-3Ygby-eYAv0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A7C3024005D;
        Mon, 28 Dec 2020 06:47:14 -0500 (EST)
Subject: FAILED: patch "[PATCH] thermal/drivers/cpufreq_cooling: Update cpufreq_state only if" failed to apply to 5.4-stable tree
To:     zhuguangqing@xiaomi.com, daniel.lezcano@linaro.org,
        stable@vger.kernel.org, viresh.kumar@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:48:38 +0100
Message-ID: <1609156118189209@kroah.com>
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

From 236761f19a4f373354f1dcf399b57753f1f4b871 Mon Sep 17 00:00:00 2001
From: Zhuguangqing <zhuguangqing@xiaomi.com>
Date: Fri, 6 Nov 2020 17:22:43 +0800
Subject: [PATCH] thermal/drivers/cpufreq_cooling: Update cpufreq_state only if
 state has changed

If state has not changed successfully and we updated cpufreq_state,
next time when the new state is equal to cpufreq_state (not changed
successfully last time), we will return directly and miss a
freq_qos_update_request() that should have been.

Fixes: 5130802ddbb1 ("thermal: cpu_cooling: Switch to QoS requests for freq limits")
Cc: v5.4+ <stable@vger.kernel.org> # v5.4+
Signed-off-by: Zhuguangqing <zhuguangqing@xiaomi.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20201106092243.15574-1-zhuguangqing83@gmail.com

diff --git a/drivers/thermal/cpufreq_cooling.c b/drivers/thermal/cpufreq_cooling.c
index cc2959f22f01..612f063c1cfc 100644
--- a/drivers/thermal/cpufreq_cooling.c
+++ b/drivers/thermal/cpufreq_cooling.c
@@ -438,13 +438,11 @@ static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
 	if (cpufreq_cdev->cpufreq_state == state)
 		return 0;
 
-	cpufreq_cdev->cpufreq_state = state;
-
 	frequency = get_state_freq(cpufreq_cdev, state);
 
 	ret = freq_qos_update_request(&cpufreq_cdev->qos_req, frequency);
-
 	if (ret > 0) {
+		cpufreq_cdev->cpufreq_state = state;
 		cpus = cpufreq_cdev->policy->cpus;
 		max_capacity = arch_scale_cpu_capacity(cpumask_first(cpus));
 		capacity = frequency * max_capacity;

