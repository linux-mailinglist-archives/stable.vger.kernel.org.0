Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621EA377ED2
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhEJJA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 05:00:26 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:53287 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230049AbhEJJAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 05:00:25 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1D7AC1940BAA;
        Mon, 10 May 2021 04:59:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 10 May 2021 04:59:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=XJxHBt
        r2lv51lMaamau7E+iT8U8xmJ8Rs9KMVxVwA9k=; b=sUxpJfpSpevO7iIy5JfWvm
        +uWrfUvwuq+de0X5zU1stbUH1bxY+D58wRWjiRVqT0UgtTpin8za1Rtq5Zu4jNYv
        Qg9IreedTeMAUYWofh5t2Vjfi5NGADp15Y/z4K13jIBqBSBhir4Pqcy+N5eEBBpx
        08JjX6vlC4k0JpdlTDS00epWr6UTgyr07yGoTJNIEiarOGhHQ82t973YUpXoApdv
        1aFbbtUU5/CG77xVkO+jfFm/YMEsEMWVsGmbDF485V+bnR56xX7mnhYbKmaKOJ/b
        CMVHrRZ8U2clafntku54MPChTG7X4c8cPuMlqAjvpLhCF8CBpuoK8NtIEQFV21JA
        ==
X-ME-Sender: <xms:6fWYYMMujtyrULjm2SfJ4UHistZL9ttr1xKSjXCtMXCm9P7KE1AJ8w>
    <xme:6fWYYC83RySRsmzJ_i3G6Cca3xyjRlgkF1aZl9GTgkTd31bOobsMQSR1cFyL0vIZu
    D_6QBfEN1QlmQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:6fWYYDQRmwa2CWaNLblR-3w77TpYeEUNQKetDE9ZcGnrAV-8nq6tHQ>
    <xmx:6fWYYEt3TlqaxoXh3zFFjCMxTaLbtzLLCxO3_IfvnOzXyZ-3h2gGow>
    <xmx:6fWYYEfx_TEhal9d32znhVNzIHG7vqkxx1Hvqz_goelhrPLmcXMNUg>
    <xmx:6fWYYMmgfRrkkTRr7cQ7Uw3JBA-woYFZI3_76ODqjC1Iywblry5F_Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:59:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] thermal/core/fair share: Lock the thermal zone while looping" failed to apply to 4.9-stable tree
To:     lukasz.luba@arm.com, daniel.lezcano@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:59:09 +0200
Message-ID: <1620637149191139@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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
 

