Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A49D394CE7
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhE2P0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:26:40 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:49935 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229693AbhE2P0k (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:26:40 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id C480B1940C1A;
        Sat, 29 May 2021 11:25:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sat, 29 May 2021 11:25:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=M+w4zR
        6fkde5XE6Ptuv1NjKqe+GRTSROv+sZfjqkxDQ=; b=nlHw1ABUKj34sWnaExWChl
        jpUA+1BpjhoJ+9ae30ZdN+aAcYBEQEvMD8YWh7OtNfNNcYs5uMP0FVy9nirmbbdw
        Zjy8wlFAu4TeAhGNZnPG1jaS5tnv4vuPt8G/XeV+PBK7nl2U4vWq5kvr2nUnT+t9
        ZXupgerk416xRj0dGS0iXwArKRHOJl2AJhTUlgpT0Wa452j6mu608FFOsm5hU9qf
        4FqCDob7wuzlguXVur3kmnZk2+eskfGMExgbn3/qAwtGMp959hO1I3qSxNDG2WeQ
        NPKzzWu65Mdw3RxO2va43i7ZJcGrqgcZbNv8oWrIa9qUuAmASKx88cpDURx4HLcQ
        ==
X-ME-Sender: <xms:z1yyYKwu52DH7CdM3pwUX5KkJNDtPv9bCdjNuJeNmDOeLG5AfUl76g>
    <xme:z1yyYGSD42wP95C71lyKaZATPHWL5atATY-lP_w3Ox4IbVR_r1O5Ao9e2_t4s-Yoo
    Z28ZgCklfjY1A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepheeggfeuvdehjeffieehheeuvdejfefhgeevgfegvd
    euudefveegffeuvdetleeunecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:z1yyYMUhe5QnBz-T597dvJuOolfvw0bcdOJPyOlJbVPFMBLlEZfULg>
    <xmx:z1yyYAjLQxXoWjJh3ovvDgAINAEosJ9Xpk4MEDYfCSRbd4LS3gr04w>
    <xmx:z1yyYMBm6k0LPbgYUtsjCoMfx2PUFkrOrOLWoTaw3NpWmes9GJyDmQ>
    <xmx:z1yyYPOLk3c9qEVBdj82mtU4ZDVMdyIX_iSDckVXt3Km7dv7RzTKMA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:25:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amdgpu/vcn3: add cancel_delayed_work_sync before power" failed to apply to 5.4-stable tree
To:     James.Zhu@amd.com, alexander.deucher@amd.com,
        christian.koenig@amd.com, leo.liu@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:24:54 +0200
Message-ID: <1622301894201178@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From 4a62542ae064e3b645d6bbf2295a6c05136956c6 Mon Sep 17 00:00:00 2001
From: James Zhu <James.Zhu@amd.com>
Date: Mon, 17 May 2021 16:39:17 -0400
Subject: [PATCH] drm/amdgpu/vcn3: add cancel_delayed_work_sync before power
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

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
index 14470da52113..3b23de996db2 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -372,15 +372,14 @@ static int vcn_v3_0_hw_init(void *handle)
 static int vcn_v3_0_hw_fini(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
-	struct amdgpu_ring *ring;
 	int i;
 
+	cancel_delayed_work_sync(&adev->vcn.idle_work);
+
 	for (i = 0; i < adev->vcn.num_vcn_inst; ++i) {
 		if (adev->vcn.harvest_config & (1 << i))
 			continue;
 
-		ring = &adev->vcn.inst[i].ring_dec;
-
 		if (!amdgpu_sriov_vf(adev)) {
 			if ((adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG) ||
 					(adev->vcn.cur_state != AMD_PG_STATE_GATE &&

