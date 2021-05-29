Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44BB394CED
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhE2P2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:28:38 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:35333 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229693AbhE2P2i (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:28:38 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8AAB619409AD;
        Sat, 29 May 2021 11:27:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sat, 29 May 2021 11:27:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Aeo6r3
        V/b4JKrJW5RPGYBmuNcy4I5ll9L/fVMqeyCUk=; b=Not0R2iRsAkvabKRC18Xic
        FBTuHjofm5wrBhBDMkbkOKnKTMVdcHOR+WGL9aNXFzx7UtvFjDA3naO5oIU6CYP7
        FC/1DKrZeCg4WMYKqOdILDkCugrRvRJWtU5ZrccXopQqYBloy1/3rNce4M9P/jzn
        TzgmqWLzc07LfZrOOr35VaAdz/LV/dLfNi6kYoymmujV/yFfOtkOG/+Ndo00gLbt
        nNk6m+9skvxwCNk9W8tC8Uij/cQ9CigBo9WPp/50ixuixqbu/GHzbKmvSuDcFCwY
        3JHoX/ahiGL8lE6z2E71YcjYvU6tjpoOvHc2LQSwVTjWeXSxrfShuGoc+x+a/cbw
        ==
X-ME-Sender: <xms:RV2yYCc6HyWzKShfZ_VaP3eZX0-46NcLHe7rmSbPV8-Hos7Fi4weeQ>
    <xme:RV2yYMPodJKcxK5NiCfouYLkH2bO3TcDHYvVH5riy2P9dfVUWsk14egRfjE6X6tkW
    MYBEBmN8MBV-A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepheeggfeuvdehjeffieehheeuvdejfefhgeevgfegvd
    euudefveegffeuvdetleeunecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:RV2yYDilCgqQagQfCQK4aBuyq6hWPV-1eZ_A5wT0hPHyIaNS8_rUjw>
    <xmx:RV2yYP8UfPv-EcAlSwTdnl9VbckttYM31QLegynfYiJVHCLr8uC1_Q>
    <xmx:RV2yYOvOCUjBKs_Tfz2uDVTBSueer9JubZxJSz0IvWU2cZxgt3QWcA>
    <xmx:RV2yYH6uifoZU2N5iKyCwOQqov3mvEArHjymN-fdo1RvRUtHik1xbw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:27:00 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amdgpu/jpeg3: add cancel_delayed_work_sync before power" failed to apply to 5.10-stable tree
To:     James.Zhu@amd.com, alexander.deucher@amd.com,
        christian.koenig@amd.com, leo.liu@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:26:59 +0200
Message-ID: <1622302019248209@kroah.com>
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

From 20ebbfd22f8115a1e4f60d3d289f66be4d47f1ec Mon Sep 17 00:00:00 2001
From: James Zhu <James.Zhu@amd.com>
Date: Wed, 19 May 2021 12:08:20 -0400
Subject: [PATCH] drm/amdgpu/jpeg3: add cancel_delayed_work_sync before power
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

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
index 94be35357f7d..bd77794315bc 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
@@ -159,9 +159,9 @@ static int jpeg_v3_0_hw_init(void *handle)
 static int jpeg_v3_0_hw_fini(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
-	struct amdgpu_ring *ring;
 
-	ring = &adev->jpeg.inst->ring_dec;
+	cancel_delayed_work_sync(&adev->vcn.idle_work);
+
 	if (adev->jpeg.cur_state != AMD_PG_STATE_GATE &&
 	      RREG32_SOC15(JPEG, 0, mmUVD_JRBC_STATUS))
 		jpeg_v3_0_set_powergating_state(adev, AMD_PG_STATE_GATE);

