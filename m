Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8D2377ED4
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhEJJAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 05:00:30 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:35877 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230049AbhEJJA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 05:00:29 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7E6541940BE4;
        Mon, 10 May 2021 04:59:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 10 May 2021 04:59:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=hfAB3q
        nWrYq0es0yF+9HPrIQeNzetMuSUdXGAxajGp0=; b=Lkyw2GD2+A+h8ad+1t8Wlm
        PugofbdGkJRFERN2kPRC0zT3Vut2DX/qBY4HIZJq2s3kxsDqjtUv+8nh/pMOh71r
        uZg6DgH+hfGvIyQTu4BWsLHE2Gq5SncpODQGDbl/LXGkhaHKZoicFQZttlBrD6/i
        V/gRDlpDWQESdvgJyxwnp+NRI4lLIkVHgb/BygNYTvhZh738/bwnNs6kwRk/3+lC
        7EB2/c4mznloBonE/Vsa9S9KFkeXqNLY0Bu0lSjU0XzFUsSf6LU0b4ReyB12nfWb
        CrfjrD1QwS6A3/6tIR2O/kUOM9xfeM2euLkrpjSMMq3+CxqBD4XQY3NVHdlP9I8g
        ==
X-ME-Sender: <xms:7PWYYMrOyokP7SuwzYJMM0pt_4dtRjrzeVFhHQ8mcbNEvVw-jvtcTg>
    <xme:7PWYYCqkUfec5EuGs8Dvbg-JZ8jEUKTRZgQxRPEW3e1q9bKMG1difHHDR3oVfKCqc
    EW1CaLRqcasKQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:7PWYYBP6WGFOuwxB5skUCYyg_L6YLnLzP3NS0B0EHTVnzYVSaNl5QQ>
    <xmx:7PWYYD749qsrZaelm5_EjpNFMPZV8tPZhdfbZ0Ve1hsI9og3vLVgwg>
    <xmx:7PWYYL4qm_RVfa9jPUUGpKSWec5z6FPnYWebgZgl6O3tNjrSpV2LNw>
    <xmx:7PWYYIgm1umZIeyyXHE2t6eStNWsLXHw2EIACf7oExAdXsWlB6wAlw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:59:24 -0400 (EDT)
Subject: FAILED: patch "[PATCH] thermal/core/fair share: Lock the thermal zone while looping" failed to apply to 4.19-stable tree
To:     lukasz.luba@arm.com, daniel.lezcano@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:59:10 +0200
Message-ID: <162063715024633@kroah.com>
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

From fef05776eb02238dcad8d5514e666a42572c3f32 Mon Sep 17 00:00:00 2001
From: Lukasz Luba <lukasz.luba@arm.com>
Date: Thu, 22 Apr 2021 16:36:22 +0100
Subject: [PATCH] thermal/core/fair share: Lock the thermal zone while looping
 over instances

The tz->lock must be hold during the looping over the instances in that
thermal zone. This lock was missing in the governor code since the
beginning, so it's hard to point into a particular commit.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210422153624.6074-2-lukasz.luba@arm.com

diff --git a/drivers/thermal/gov_fair_share.c b/drivers/thermal/gov_fair_share.c
index aaa07180ab48..645432ce6365 100644
--- a/drivers/thermal/gov_fair_share.c
+++ b/drivers/thermal/gov_fair_share.c
@@ -82,6 +82,8 @@ static int fair_share_throttle(struct thermal_zone_device *tz, int trip)
 	int total_instance = 0;
 	int cur_trip_level = get_trip_level(tz);
 
+	mutex_lock(&tz->lock);
+
 	list_for_each_entry(instance, &tz->thermal_instances, tz_node) {
 		if (instance->trip != trip)
 			continue;
@@ -110,6 +112,8 @@ static int fair_share_throttle(struct thermal_zone_device *tz, int trip)
 		mutex_unlock(&instance->cdev->lock);
 		thermal_cdev_update(cdev);
 	}
+
+	mutex_unlock(&tz->lock);
 	return 0;
 }
 

