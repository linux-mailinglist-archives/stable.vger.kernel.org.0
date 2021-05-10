Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD55E377ECD
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhEJI7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:59:51 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:52567 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230098AbhEJI7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 04:59:51 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id C590E1940BDE;
        Mon, 10 May 2021 04:58:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 10 May 2021 04:58:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=qkmYDw
        9KgwBshZjAyjRnqzdd6b61cw5mrsUfzTpcuSs=; b=YxsxTXW2TlYLK7S8RaoJ5O
        lwrO6/hiVrTgNfw4Mez0VRT3K0zP3M+uMp3U935TiqcDRqmjtgJorDe3xDDqvrwg
        WwamFzkQt738EpyZ4IoZb/GVL9QXNUpl/TURS6mgLVK4+24gLzn/hWdPjspjEPSu
        78EiF6BOH4eMFTkYSUJKXJej0wY48Qwf9V8ctvy2n+KTMXqeKk4RcGjnRgniehUl
        Mbr1qADm27Mrd7uSkWntcr3eEvuQPh7gLdLojACYMCn5I4YTSmC7LPIS9pYRJrTO
        T+dSI+hoCVUGM0nwr0n1PBKfid+Y0utHGUu7kJLMGMomTGxjDzwSvUh4A/I7GJrw
        ==
X-ME-Sender: <xms:xfWYYHBkKP_HZ_ebtbFfjymEkeH4lvOlYpTL_Bj_0f5aKHxEvc_NEA>
    <xme:xfWYYNh_pe2-Xakunnd5TD1MStHfwipdFEne4ZqGhQIYfu5SXJ5DU03R2BWglHVD2
    iILhyRPb-wsVA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedguddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:xfWYYCnX0wK1UODru6Os_1vkBX38Su8y3dcaX73RUsN__zVACT4erg>
    <xmx:xfWYYJzeMLStBYgFWaM3_3CBBLfMVT8AE16XgeMt3EFHXhM7D7YxNw>
    <xmx:xfWYYMS04lxlmP6xqGihTOL18gVG3uSsJ53yyFztpkqco2sonPwnzQ>
    <xmx:xvWYYHcWnmBOuUveqatPCb9CJhVeWlc4xDg8_DkVx1DzklXbyBg5Xg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:58:45 -0400 (EDT)
Subject: FAILED: patch "[PATCH] thermal/drivers/cpufreq_cooling: Fix slab OOB issue" failed to apply to 5.4-stable tree
To:     brian-sy.yang@mediatek.com, daniel.lezcano@linaro.org,
        lukasz.luba@arm.com, michael.kao@mediatek.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:58:44 +0200
Message-ID: <162063712461143@kroah.com>
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

From 34ab17cc6c2c1ac93d7e5d53bb972df9a968f085 Mon Sep 17 00:00:00 2001
From: brian-sy yang <brian-sy.yang@mediatek.com>
Date: Tue, 29 Dec 2020 13:08:31 +0800
Subject: [PATCH] thermal/drivers/cpufreq_cooling: Fix slab OOB issue

Slab OOB issue is scanned by KASAN in cpu_power_to_freq().
If power is limited below the power of OPP0 in EM table,
it will cause slab out-of-bound issue with negative array
index.

Return the lowest frequency if limited power cannot found
a suitable OPP in EM table to fix this issue.

Backtrace:
[<ffffffd02d2a37f0>] die+0x104/0x5ac
[<ffffffd02d2a5630>] bug_handler+0x64/0xd0
[<ffffffd02d288ce4>] brk_handler+0x160/0x258
[<ffffffd02d281e5c>] do_debug_exception+0x248/0x3f0
[<ffffffd02d284488>] el1_dbg+0x14/0xbc
[<ffffffd02d75d1d4>] __kasan_report+0x1dc/0x1e0
[<ffffffd02d75c2e0>] kasan_report+0x10/0x20
[<ffffffd02d75def8>] __asan_report_load8_noabort+0x18/0x28
[<ffffffd02e6fce5c>] cpufreq_power2state+0x180/0x43c
[<ffffffd02e6ead80>] power_actor_set_power+0x114/0x1d4
[<ffffffd02e6fac24>] allocate_power+0xaec/0xde0
[<ffffffd02e6f9f80>] power_allocator_throttle+0x3ec/0x5a4
[<ffffffd02e6ea888>] handle_thermal_trip+0x160/0x294
[<ffffffd02e6edd08>] thermal_zone_device_check+0xe4/0x154
[<ffffffd02d351cb4>] process_one_work+0x5e4/0xe28
[<ffffffd02d352f44>] worker_thread+0xa4c/0xfac
[<ffffffd02d360124>] kthread+0x33c/0x358
[<ffffffd02d289940>] ret_from_fork+0xc/0x18

Fixes: 371a3bc79c11b ("thermal/drivers/cpufreq_cooling: Fix wrong frequency converted from power")
Signed-off-by: brian-sy yang <brian-sy.yang@mediatek.com>
Signed-off-by: Michael Kao <michael.kao@mediatek.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Cc: stable@vger.kernel.org #v5.7
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20201229050831.19493-1-michael.kao@mediatek.com

diff --git a/drivers/thermal/cpufreq_cooling.c b/drivers/thermal/cpufreq_cooling.c
index f3d308427665..eeb4e4b76c0b 100644
--- a/drivers/thermal/cpufreq_cooling.c
+++ b/drivers/thermal/cpufreq_cooling.c
@@ -116,7 +116,7 @@ static u32 cpu_power_to_freq(struct cpufreq_cooling_device *cpufreq_cdev,
 {
 	int i;
 
-	for (i = cpufreq_cdev->max_level; i >= 0; i--) {
+	for (i = cpufreq_cdev->max_level; i > 0; i--) {
 		if (power >= cpufreq_cdev->em->table[i].power)
 			break;
 	}

