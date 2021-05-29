Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34C6394CE8
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhE2P0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:26:43 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:41817 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229693AbhE2P0m (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:26:42 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8C69D1940826;
        Sat, 29 May 2021 11:25:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 29 May 2021 11:25:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Wuawfh
        8yhON5xga5y2axQEwQT8l0ZJcYo2wbO5hc+54=; b=YfyB4x9LR3fnOuTnlqe12O
        Ip35uPgYCReMna6HkCxgz8TIxN2Uptt0Ga9M/RLdMoJ72rOgHcP65DS3bZSp9+Js
        xkK4Se/8qqmifWkRPntAnwvNGuqo8pk5sSlwU7MRabOadepag4FEi5bwDRmg+T6K
        XevB9TcOyqNz5SMInZ5+ldt/K+Mr257KhqfwO4e5OwNmyQgEnm2y2Ba04fIAdtmT
        PCQb1PBAkl076hPgF3LfmAtalyEyQWMIdcIJ9PN2ATSSar8ZYcTGOrvV8Ln3fW0u
        FZukl5bWcHRTVFHhZIr9i0PhLDK/ClhlLwfW6jA1X6ih5xlZCFD0nOJitUI2QEKA
        ==
X-ME-Sender: <xms:0VyyYBg-ClD7n5198x98GjVtdkt00ws-zQkn6eNk1WEzuPmN8xpnCQ>
    <xme:0VyyYGAcPJ7x92NJxu8Hc0xfD-kdrgE-L1cnd00MgzPpolwDR5oPLw3_jtz9H1Eku
    qFFyylsNnp9Ww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepheeggfeuvdehjeffieehheeuvdejfefhgeevgfegvd
    euudefveegffeuvdetleeunecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:0VyyYBGt9sAqevkquTTsRvC-owptt_hBBL43vIQXZ2anb0MTl2i87w>
    <xmx:0VyyYGRiFFfN_DO4eWdi7eXmQbH40LchfCz1-th8uLKs8ZNCr9pEcA>
    <xmx:0VyyYOyAhwyba7RE-KgVPNY0QuJqy0kMF6hRW13DHjRyAA97i1mdWw>
    <xmx:0VyyYJ8_cbkoYHwDLF10UBIfaV7F1tqvq0QDzaz2qsBcfUBVNdHpKw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:25:05 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amdgpu/vcn3: add cancel_delayed_work_sync before power" failed to apply to 5.10-stable tree
To:     James.Zhu@amd.com, alexander.deucher@amd.com,
        christian.koenig@amd.com, leo.liu@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:24:54 +0200
Message-ID: <1622301894190162@kroah.com>
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

