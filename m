Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F77377ED0
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhEJJAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 05:00:15 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:60335 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230049AbhEJJAP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 05:00:15 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7ADC01940BE1;
        Mon, 10 May 2021 04:59:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 10 May 2021 04:59:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=HJOKUx
        eOsg2DhuNdLtU1to+33dTH2Yaogl9fjrHFOmI=; b=w04kaXtGT3bZHZfsoQcm8C
        EPQ5hqIaTDDToAyqvK+H2+IaYI+rcqDjjRsGfOXXyiWNnAr2Z81l62+UNSS4NNZ5
        6MDKfNxX67/gj+Dkca90nJ3mmfU2cv2//kaHkrag/O545uHy94nT+WoBIQOYIjSr
        BCiaj4ipKZKz+VnTiuap/KefI0alY9q7W4Gm5fD0juNIR14H4r5zdKe73x8548BO
        +BrgrUjJoDhVJSkqvbBGs6AB+D2k3MYw6pNVmw18SV0epHGQlmwI1m3olLtc+kNA
        4yAAkG4l0LyRPe3uqEdNuXsVXaDjx/wI3WtCTIj9W1dXx9dnVHoiMyjyGET+sfDA
        ==
X-ME-Sender: <xms:3vWYYF0_lmK99vhdgRrQ9xFNpjs0M5o1mECHffC15LathvVRZ_biig>
    <xme:3vWYYMGkmE4BvCf-lFsmB0lx7cZMYhY1lXlavT5WATGqs0XYl-2FEZzcdqtHWsxwz
    qtjJPoXchHoEg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:3vWYYF7kT9KXkLydkgR4eSNxNvLDh9TmcknT3cwv1IvvrpOKpgEtug>
    <xmx:3vWYYC0cvKKZwWQWhw8QKCew60EMywLXux9tcQYRzT3sfSQE1Y3R2g>
    <xmx:3vWYYIExKIcXwSh8qm10avhaQFbr9ZxB3orstB_laS8kLQrco4Tn5Q>
    <xmx:3vWYYDPvBUfP-3aNi593j4f4McPneootHnW5oTXZdUM6PEBnGk6b6A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:59:10 -0400 (EDT)
Subject: FAILED: patch "[PATCH] thermal/core/fair share: Lock the thermal zone while looping" failed to apply to 4.4-stable tree
To:     lukasz.luba@arm.com, daniel.lezcano@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:59:08 +0200
Message-ID: <16206371483193@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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
 

