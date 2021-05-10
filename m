Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF21377ECF
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhEJJAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 05:00:01 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:42085 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230049AbhEJJAB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 05:00:01 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 90DE41940BDC;
        Mon, 10 May 2021 04:58:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 10 May 2021 04:58:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=NfA1MN
        pbHNfdFQfHMGvZIkjOkpSqg0ZJhg9HCauVkYg=; b=aQfVAJ0Juv3/QHoHH+V63l
        MVqQ6VHtpVmmlMZP4PKlQFhCC3kNr6tIV+eVmHgE6DJxSxyAzlvLwnCqGH5G0cnI
        LPM6EKkUMEREDPVsDZy5NIl/xgKXf0FbEjmNd8mm17Utn8u2cGgL0y4cFo+RBWQQ
        kiRegGgewkVls2+s5diA3X2AUW70hMh9jhQFJBNXgtwJUQOazRa1VrDXXGkQMNia
        L/EaHqKzfQr9fXZdTF3A3YzxFnCa7fP1J1gnQaK3qLN9wejFvgWVWQ8YywbjHVCZ
        stRBjgUUnRkv/dj+2i7TfDnVOxde1oG2dP0QCUs1vNm56qmz9kQ45Xvln2uXcL9Q
        ==
X-ME-Sender: <xms:0PWYYFbGCVBBl6f_Bs917HD4_fbhA9FaKdh38xvJYAZfGZR0Wrs8LA>
    <xme:0PWYYMbSmI_iw9qA6YivALLiq-SKCxQOIVuXdMqyJHkksIcxueJrq-7l52ckCxI2m
    G7FtRG6gzBZVw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:0PWYYH_6V2tRkOyVmORCH8f4E0uU8vpn9sifgXx4X6qi51PiODzCHw>
    <xmx:0PWYYDouexPNMjLmuNXM_cYWbBoQ2GnTohxgMXLN-sNA72BypmUXIQ>
    <xmx:0PWYYAqPthxrsKwMwI4URGFaf6PKFWJ1qMwgj6nJThrBOobOnVWetQ>
    <xmx:0PWYYH2znLUoa0NJIE4XBTByHuUp9Hf9881pO8rVRN3DQ9lEF8yyAQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:58:56 -0400 (EDT)
Subject: FAILED: patch "[PATCH] thermal/drivers/cpufreq_cooling: Fix slab OOB issue" failed to apply to 4.19-stable tree
To:     brian-sy.yang@mediatek.com, daniel.lezcano@linaro.org,
        lukasz.luba@arm.com, michael.kao@mediatek.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:58:45 +0200
Message-ID: <162063712545146@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

