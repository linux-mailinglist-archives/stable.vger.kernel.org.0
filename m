Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93AA6377ED3
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhEJJA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 05:00:27 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:52937 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230049AbhEJJA1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 05:00:27 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id CAE5C1940BAA;
        Mon, 10 May 2021 04:59:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 10 May 2021 04:59:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=QK85SJ
        s8qoWpDiK/czn4tTbjZssSChHdVrTuqJkqn+c=; b=QHZGJp7uatJzlMFkaiC/q3
        34ZApvBSKwhup1X7rBbBQb/zquwB8lJJNlbq6RIzBKp0goz1xfpFR+MjosfjDtvv
        RcF6dRzZh8pKSViRlWKotoIbHMqIhf9EYYPn9doEI/lc6yTtfNPM14v9IIkaUUQj
        W2JvFXQ4bnAXVPUoRJzSxmFfhEqzm3xj9I8hNa8kwk/o1Qg4KBV5o8MHKR1oIIyt
        TavWNS1L9lt27zzfhRvslcDWFjjHBhR3B4Yl9+nRW7RqDcrYZQkKi1W3DRB1EBaC
        YykyezLJVjbgQVFlyzjTaqmf2mFCpvqtsj3FHYwOOZexmdI7h09+yr8dCwPGLobw
        ==
X-ME-Sender: <xms:6vWYYC_Ruz9HuQn49prII_77p6NrHSV1RsM5OorYtxSePb_S464b4Q>
    <xme:6vWYYCtnMsKW7r15F6rhvXC0_mWn0slnaBQoFJnpOrzgyiRFTieLF6gbkFYEjQGNO
    6VDvjB1Igdz6g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:6vWYYIDnKlX1lVbJufLZkPB0MQXHCYex7KjMPnw1RMEUBMq6Y77Ing>
    <xmx:6vWYYKf9JH4seaDlBhE8ulDYjE8yVNFVkxGt2qj-L9zsjNNSL0DxeQ>
    <xmx:6vWYYHPO29W4riyXMu1Xm39G6roVpfCSKHonirshVEd0L_VB4jgytQ>
    <xmx:6vWYYJV0Hb6Ax7RTj9uy5Be_G2rEKi1hrzziPY23U9zXk3FHZBbeGQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:59:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] thermal/core/fair share: Lock the thermal zone while looping" failed to apply to 5.4-stable tree
To:     lukasz.luba@arm.com, daniel.lezcano@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:59:10 +0200
Message-ID: <16206371506718@kroah.com>
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
 

