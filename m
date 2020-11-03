Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14BB22A4A18
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgKCPmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:42:46 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:34429 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726690AbgKCPmq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 10:42:46 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id AA9F4D9C;
        Tue,  3 Nov 2020 10:42:45 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 10:42:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=/xE8Gg
        GcScsMP23JcOpyWYajFx3lZW5ZsDzuIaikYyA=; b=DDyyOgrzkEnjPHbAriiLJh
        /K8mlsFTBbMA+WCr6nV/ndk1/mDGu/7mlaETnjEShU/ZRa2k+Nll5HU76XL3Nt6G
        l1niFbm8bJFaKSFhkAXekrzXMusswl3IG83fk3S3p+Cuzk4q6PYN+2zlvVHbMXfV
        +nPYDHEAZIaVIML3U6qc96fsL+piILWJvWQYLA/MWwjxsJmUgqw+H7VW8S/kJlFt
        WGe3KeXey7BZiREquqzxELoHA2mjQcCAuQW6s3W5K+ucpoWm1TNlto4OMRA5/DRc
        aXKJzzYjSmisZJ1MToVk80p5XUN5ckVoxyY8X5Ezq7wnDXZpAGCE1GBORJGLj5KA
        ==
X-ME-Sender: <xms:dXqhXzRIEF9Jk2yN3I8NPC75oK3I5rZA-n5TN3_CAH5d9jwuzpcfZw>
    <xme:dXqhX0ySswqVqcFzp-NpHP_N_yQT5vry2q-HKD8hjs-q2coGHwTyYry59qmUHcvnB
    SlEyYxZ6g80Zg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgjeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:dXqhX43qVaF5YVf2nACM7oIHXGRmz5zRyzYBB0ohvqmP2ZbSIOhDRQ>
    <xmx:dXqhXzD4Lqdi3NlTsbZnh2l9JLZ0diC28VAAbnvQ0CPdTTsQ-fkmgw>
    <xmx:dXqhX8iQfgo8EtN03EqR7k6WVNg-RHQBTvMuDFcXOKdD2p80lRIIfw>
    <xmx:dXqhX0Lsbso63ht4m-RphJBEFyzVwwnYgkHWpJS-lQKQCz-L7owXCBsay60>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9ECF3306467D;
        Tue,  3 Nov 2020 10:42:44 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amd/pm: increase mclk switch threshold to 200 us" failed to apply to 5.9-stable tree
To:     evan.quan@amd.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 16:43:38 +0100
Message-ID: <1604418218168119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 83da6eea3af669ee0b1f1bc05ffd6150af984994 Mon Sep 17 00:00:00 2001
From: Evan Quan <evan.quan@amd.com>
Date: Wed, 2 Sep 2020 16:10:10 +0800
Subject: [PATCH] drm/amd/pm: increase mclk switch threshold to 200 us

To avoid underflow seen on Polaris10 with some 3440x1440
144Hz displays. As the threshold of 190 us cuts too close
to minVBlankTime of 192 us.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
index 3bf8be4d107b..1e8919b0acdb 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -2883,7 +2883,7 @@ static int smu7_vblank_too_short(struct pp_hwmgr *hwmgr,
 		if (hwmgr->is_kicker)
 			switch_limit_us = data->is_memory_gddr5 ? 450 : 150;
 		else
-			switch_limit_us = data->is_memory_gddr5 ? 190 : 150;
+			switch_limit_us = data->is_memory_gddr5 ? 200 : 150;
 		break;
 	case CHIP_VEGAM:
 		switch_limit_us = 30;

