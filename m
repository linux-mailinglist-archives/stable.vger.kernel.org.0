Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310C4394CE6
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhE2P0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:26:34 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:54101 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229693AbhE2P0d (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:26:33 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 39A351940DAD;
        Sat, 29 May 2021 11:24:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 29 May 2021 11:24:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=EpVFK2
        y3yuyALlLyM7zeTXt3bJi8ugkXXkuBV3CHPLI=; b=qMRgjesfzuWKP54iuas0GP
        GtqTl4t05PDDj7dNx80xvZfunX8LBYqoePcR/DlfFSPYVw4igA1dPzJ+kgtOSonu
        7Js3+sbFunktglGX5Y3k2f8sCFPC5AxelesUB2u9vzl0DsXuk3XwglR5tYVWd38G
        os5hniGXI4jfXdA3cxDjNVo+Zmw/eDECpCibxSsUATjnYHnmWIogsF5HG8d86g/H
        apj9T9LClYxEBjxMmsgu1aQW5dserzDc43YGzbf0eqRypYjtdJc/Uf+r28dzvFa/
        Y4mi3q/hCLFaiLJJQYJoMSzHdd0acRHW6qhibDyguYZs/hlLQEUZrkyrS9JS+J7g
        ==
X-ME-Sender: <xms:x1yyYJvjziIWrUsIOTY2rR2eGO6Tl3-D3hLof0cAYn8pMbmo8Du5KQ>
    <xme:x1yyYCdHbjd8eF6aUMefSaKxXUG7YLOMWgLJCIvrrRsq6_OIOD8VVEvNYkfdMekCE
    ptm0FNeFfdhnQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepheeggfeuvdehjeffieehheeuvdejfefhgeevgfegvd
    euudefveegffeuvdetleeunecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:x1yyYMytNQ-64hgWAZqwc39tLxkt_RA05T9jOKTfePFdknc3zRHWuQ>
    <xmx:x1yyYAO08xjr2k5DGcx3qE5kAcGPEmC7L-9BMHpiLNBr-81TdicrUw>
    <xmx:x1yyYJ8bhlwtjBLk48tizkkRe_WIGJg2XDfqeJqqNxPHIDU4AoP2Eg>
    <xmx:yFyyYLJdN7QiRbiwlICqaCnovr2IjEnK91GqiXDBy9-fGcUxuCoJtA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:24:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amdgpu/vcn3: add cancel_delayed_work_sync before power" failed to apply to 5.12-stable tree
To:     James.Zhu@amd.com, alexander.deucher@amd.com,
        christian.koenig@amd.com, leo.liu@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:24:53 +0200
Message-ID: <162230189310849@kroah.com>
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

