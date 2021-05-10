Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834C3377ED1
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhEJJAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 05:00:25 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:48869 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230049AbhEJJAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 05:00:24 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 64C2A1940BDC;
        Mon, 10 May 2021 04:59:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 10 May 2021 04:59:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=469Fye
        Nqy2KxHKvWLvx3dZueDI8vsn195YzdeuQCo6Y=; b=IphlFiBTxxVomlOOnnM+P+
        KK/JJJyTSquaQUJh5JjbKzY+rXz62QrDIAk8FiBBPzH8sRDHnjJEPnusX5H658yv
        NWY221sycQi+7GX8NSMk0UhuU9G/Z/bpH7EXjqSnrKHoGtmT+5VJcmohlUu+FGGr
        n6/rCOcGPFSdfBiLxdY1Hy8dwYpX0pxCVlI9dS8SDp1DXVukrnq7PItXO3NK6lY8
        prT9/UBxaeoRaZVA1vUidCZJsu2THIa0teBp3Eso5xk9TlxDeeM04HlUlhLwEGmt
        ahapyXnejwbmTuELKMFZ7ZhyhSn7JTPS1Bx9xSJaJqsufGP7cTCW+gKqdo/F0Osg
        ==
X-ME-Sender: <xms:5vWYYJacccceBbFGKyvP5KjKKFJ82rwkVngJrOV5LrULJomaflRGUg>
    <xme:5vWYYAaMTLQtK7WrCH1E8HaC3igampL4zfRH9-JL2LQTYqxI5Dut_K-WP6MQ5jvNy
    STnXfvEVqHvgQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedguddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:5vWYYL9aTcshedRM29zMy1xXDiV2q2s5dHsIEprsMB6V4K4GQAKSrA>
    <xmx:5vWYYHqpbp5VCcouaDsg0Gjk-BsZem3LZ4J40ILeNdK-G3Ii09F4zg>
    <xmx:5vWYYEqJHSbWPvCIM_QL0A4YBUbRUFg5fss7ivpM_dqVkb2xqiLQXA>
    <xmx:5_WYYLRwPSc83H1AiTA34IywZJO8rOtinD4GLEcmRjj7eQB_fvVd_A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:59:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] thermal/core/fair share: Lock the thermal zone while looping" failed to apply to 4.14-stable tree
To:     lukasz.luba@arm.com, daniel.lezcano@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:59:09 +0200
Message-ID: <162063714997134@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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
 

