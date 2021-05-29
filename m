Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343A0394CEF
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhE2P3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:29:45 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:51981 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229693AbhE2P3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:29:44 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id DFD521940DAD;
        Sat, 29 May 2021 11:28:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sat, 29 May 2021 11:28:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=h9Yu0C
        xQDtMqc1Zg3Pj86xVbdbxIDx7ZIj7jL6yt1Lc=; b=k29Y7uPlsst7KZ/x7zJuee
        EHmgdrmFOiO6MmgoE1w1YcngIFLY+dz2w+xrMM0e7JXrpEfFS+KSXc6i1gcX3HIn
        KACa2+fTdgd8a0XF+zhxRR6mqL3TPWLDWFoX/buFqmbjLLgCufi7fEvL7M/CYMPz
        v74BwvMSLiZmc16mZRfWppWkiCY25Wnr4X+wsGenIjVr+/81rVvroBJ5VAsFYA6A
        ODzS4fa8KHSTZIxuFSzKJRWKC6Z4Um9KRCBjauL+cxdHya3dLWcekrMT7QVNnnsa
        zyWLR+9NeiNgOHONaglmHYx+hQFzG8dpc6eedGuuGimXY4LwE/uTPtaew1E8bxCg
        ==
X-ME-Sender: <xms:h12yYK6nE8PQZ2dtyyfBuyDew0X7HsQF6140Qn94r_6CqBND9ZYw6Q>
    <xme:h12yYD7VYnhyDYmYm3MQxf7j1zZFmhnBTnfuaFRaf8GusLa50l9Bv2gK4ohq1AMDq
    a_34tb6uBByxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepheeggfeuvdehjeffieehheeuvdejfefhgeevgfegvd
    euudefveegffeuvdetleeunecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:h12yYJfXMl4oy0joMbEltRUwVMSvdYpKlmWmkfdLwAi6B1lf2iwyIw>
    <xmx:h12yYHLhbr-pPK-F5yuS98w5vmwDqHUVRefvOpPUo703o4UfoeWE5w>
    <xmx:h12yYOItHg6kGfUs3FIaldsEEBDifRkI4OefZhVp5GKXJwH9yoZdEw>
    <xmx:h12yYFVV2EzaDUBMC4haOoiWOyrObH3tlCKYvViD9CKPgJNHhsrQjQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:28:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amdgpu/jpeg3: add cancel_delayed_work_sync before power" failed to apply to 5.12-stable tree
To:     James.Zhu@amd.com, alexander.deucher@amd.com,
        christian.koenig@amd.com, leo.liu@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:28:05 +0200
Message-ID: <1622302085149129@kroah.com>
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

