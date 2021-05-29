Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6892D394CEE
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhE2P32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:29:28 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:37931 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229693AbhE2P32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:29:28 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7143C19409AD;
        Sat, 29 May 2021 11:27:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 29 May 2021 11:27:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xJAGlU
        wb/1aRtAdoJv/739LjkfE+tzHbqNVHf4JZtg0=; b=UrC3b96nZuJlt4FNjzjQjO
        wtI5mLYOInXvnu/UdRQtFAN1NXLH+gnPeCqpubEVoaroJPrs9nsk2Ubp1HrrmNav
        QpeZSeaX6JiEK0hQml+xVPyCu0jGAZswfSn5KhtjaVgBHgcJ46l1r5Mvi9aAiccB
        W1xZqR2cQH57yla7rga61TD3TW66JrmrSgmWsid2zCy4YGSuRWvhUyZMxueX0E96
        TFRUQ+ELlxIAXJPQUj7dz8q05xpSz6L3ko4CQVLV2S3NAc33VN4tbpaH6Dy/MwSi
        DAImNmBzEDENQf71oxXaZjveYflsZmtkNOwLBrNChufLr4PlpAW1cAYm/x58NZDw
        ==
X-ME-Sender: <xms:d12yYGlkWwTuI4XAlebZrSub9s_o3HBRBPK3xjgte3cjJxz2aO_OcQ>
    <xme:d12yYN0y4t0-lUPAQFpYG5eVzG4qm_ZcDcwoJLXVQZcqiGVYQ9WtgzSXqubhoHAma
    s3k18aSrIGRuw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepheeggfeuvdehjeffieehheeuvdejfefhgeevgfegvd
    euudefveegffeuvdetleeunecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:d12yYEqOHjTp0zSjprOB15Wx-nZPawjyCJTPO7BjWSybVB01rzwu-g>
    <xmx:d12yYKl99EEcFUIOd-MxaqjUB2TZbJw3RW8aKGj9fWUw2trftgOhXA>
    <xmx:d12yYE0bD2AMQkt48aWAVmEWwcddJCNEdNp-mJue1gera-OiDCqn5w>
    <xmx:d12yYCBl00VhcQG5YHutC8yblc_zS5MMMVoE-k71UHOsB7Et3P5Hag>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:27:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amdgpu/jpeg2.5: add cancel_delayed_work_sync before power" failed to apply to 5.12-stable tree
To:     James.Zhu@amd.com, alexander.deucher@amd.com,
        christian.koenig@amd.com, leo.liu@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:27:49 +0200
Message-ID: <16223020694221@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
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

