Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA4A2D998C
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 15:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438883AbgLNOOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 09:14:54 -0500
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:40021 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2438848AbgLNOOy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 09:14:54 -0500
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailforward.nyi.internal (Postfix) with ESMTP id B6FB71942D83;
        Mon, 14 Dec 2020 09:13:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute7.internal (MEProxy); Mon, 14 Dec 2020 09:13:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=7+p4b7
        yplAE36PohSdbCPROJDoLmqNkziSuK+uSCNfU=; b=HRlJwDrXaOTBBvHUuZehjH
        rt7/wC6bsOjcM/a4x1SFuGBX6CJ+fG9ra1bd49sGxgIba5hkYrZHD+o1ds8ZmAHu
        IJLtf+NUnz5GD4f3jB326TkkH1AwUdPSb5/n3C7pXL6JBwWV3jx8XzWbyKFVQW7G
        5LxxxlqZfZTkgrSkvO/T7+iu8xf3o50bodkAwKWLpeVDzVWniIQp+8ittEcE8jyN
        XN75X+zUX7iQ8wSBymzsNgumxNqiogyH9IhaCSH2cJbT3Ab7MHDS5cRHXm3LP9nk
        2VGETa337Ujdy/OL23kxUhFvE37BYhh+8LNNxS4bw6Tm0Lk0gtxmCWCDUFd3d+lQ
        ==
X-ME-Sender: <xms:G3PXX09z_vuOH6IQeGMBIyG4vbAlrycYpDgLmllWUclqrIcxUkIpoA>
    <xme:G3PXX53P2er6lx-FPx6obFDYcCARCvSf7qFhi7ms7ErIjnMqbbffwqCxziiFc_wad
    muPDv-GItd5kw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:G3PXX5DN_D3U11mkUXT9Y5HoEySbMdYSXcLMLisdOPjp1jQ9DtzDtg>
    <xmx:G3PXX1cuTDwfI572gGIu8XX1NyJYzcGHTcEr5e5BHlvupjrQcYMJmw>
    <xmx:G3PXX24mtz8-f-1dw2pt6zESQeUPusGwcH0rUvUl6Mt6djMgKv2trQ>
    <xmx:G3PXX8NiPRVDu-TkkCz6ssJBSox6iKH-d-xmFrhMoiE_-L9BSlTkEw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 532CD108005F;
        Mon, 14 Dec 2020 09:13:47 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amd/pm: typo fix (CUSTOM -> COMPUTE)" failed to apply to 5.9-stable tree
To:     evan.quan@amd.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Dec 2020 15:14:53 +0100
Message-ID: <1607955293209118@kroah.com>
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

From c5b58c8c860db330c0b8b891b69014ee9d470dab Mon Sep 17 00:00:00 2001
From: Evan Quan <evan.quan@amd.com>
Date: Wed, 9 Dec 2020 16:34:22 +0800
Subject: [PATCH] drm/amd/pm: typo fix (CUSTOM -> COMPUTE)

The "COMPUTE" was wrongly spelled as "CUSTOM".

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.9.x

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index 895d89bea7fa..cf7c4f0e0a0b 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -217,7 +217,7 @@ static struct cmn2asic_mapping sienna_cichlid_workload_map[PP_SMC_POWER_PROFILE_
 	WORKLOAD_MAP(PP_SMC_POWER_PROFILE_POWERSAVING,		WORKLOAD_PPLIB_POWER_SAVING_BIT),
 	WORKLOAD_MAP(PP_SMC_POWER_PROFILE_VIDEO,		WORKLOAD_PPLIB_VIDEO_BIT),
 	WORKLOAD_MAP(PP_SMC_POWER_PROFILE_VR,			WORKLOAD_PPLIB_VR_BIT),
-	WORKLOAD_MAP(PP_SMC_POWER_PROFILE_COMPUTE,		WORKLOAD_PPLIB_CUSTOM_BIT),
+	WORKLOAD_MAP(PP_SMC_POWER_PROFILE_COMPUTE,		WORKLOAD_PPLIB_COMPUTE_BIT),
 	WORKLOAD_MAP(PP_SMC_POWER_PROFILE_CUSTOM,		WORKLOAD_PPLIB_CUSTOM_BIT),
 };
 

