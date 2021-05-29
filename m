Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B4F394CEB
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhE2P2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:28:23 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:57835 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229693AbhE2P2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:28:23 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 5C95419409D0;
        Sat, 29 May 2021 11:26:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 29 May 2021 11:26:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+3dFVD
        P9m0XF5T3CBSXuHzUlG1yJknzUkBvjWV9ug58=; b=wGSTcSXf850E+YPK0m8CN3
        0B/7eU0y5ZVVVC9c2hrsJF1AFDhznp5Iv1zIjWrqTueA5j3B/bTiJOTBhdyRvzvJ
        VnZBb89sGM/Rzd4oFyoHPSQG8K6BgSkBpk0WPM5nhINRnnXpkg1N/dxFfmFFTgoo
        RJfGiRsY6kZeywaRIgk25HQUHhmmKXTaKF/pPWnXu9HCe9028cDjPSqo8G9bJEEd
        PndQAXG+wDsNCybfEyDFWRDASO06L9bq5QBb9onQU5wyR1gDr33AzVTlDShvpcEl
        rrBhG+JPEeXuC/jyrotRjjnwMUKN7sQljqdoR1mA/nIBnaHb21oWmdn9MpYxxKKg
        ==
X-ME-Sender: <xms:Nl2yYNs2J9O4Iy4910Z7eZjRgTWnxMHwva-ozK0zj6KJ1Fx8xvfuIw>
    <xme:Nl2yYGc51eY10cBRaSnr521j79aE2yjiKSwQSkdoQhgESfoq6H6zUfaZ_EkJxZsEl
    f4C6si5zYA7Vw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepheeggfeuvdehjeffieehheeuvdejfefhgeevgfegvd
    euudefveegffeuvdetleeunecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:Nl2yYAxTsA7RVlc10g8kCO2bIYNSlu5qVTDm0wI0gffq-15JEnwsNQ>
    <xmx:Nl2yYEOQo-f94MX2SSJ7WznbR9tyTpWpV_ZHXgGSaApVu43iOsJp5Q>
    <xmx:Nl2yYN9iSOiXYYU4o3wfAbvcQbj74iPHKVbklFyXpAj5pdmhc3RMsQ>
    <xmx:Nl2yYPJMw24st_rRJ2ZJkS2SrOOq1K-3Nsipreh-K-bZB98TDk4iLw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:26:45 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amdgpu/jpeg2.5: add cancel_delayed_work_sync before power" failed to apply to 5.10-stable tree
To:     James.Zhu@amd.com, alexander.deucher@amd.com,
        christian.koenig@amd.com, leo.liu@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:26:43 +0200
Message-ID: <162230200332177@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 23f10a571da5eaa63b7845d16e2f49837e841ab9 Mon Sep 17 00:00:00 2001
From: James Zhu <James.Zhu@amd.com>
Date: Wed, 19 May 2021 12:04:38 -0400
Subject: [PATCH] drm/amdgpu/jpeg2.5: add cancel_delayed_work_sync before power
 gate
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add cancel_delayed_work_sync before set power gating state
to avoid race condition issue when power gating.

Signed-off-by: James Zhu <James.Zhu@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
index 938ef4ce5b76..46096ad7f0d9 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
@@ -187,14 +187,14 @@ static int jpeg_v2_5_hw_init(void *handle)
 static int jpeg_v2_5_hw_fini(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
-	struct amdgpu_ring *ring;
 	int i;
 
+	cancel_delayed_work_sync(&adev->vcn.idle_work);
+
 	for (i = 0; i < adev->jpeg.num_jpeg_inst; ++i) {
 		if (adev->jpeg.harvest_config & (1 << i))
 			continue;
 
-		ring = &adev->jpeg.inst[i].ring_dec;
 		if (adev->jpeg.cur_state != AMD_PG_STATE_GATE &&
 		      RREG32_SOC15(JPEG, i, mmUVD_JRBC_STATUS))
 			jpeg_v2_5_set_powergating_state(adev, AMD_PG_STATE_GATE);

