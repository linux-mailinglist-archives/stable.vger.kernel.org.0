Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA51B1A9C5F
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408856AbgDOLem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:34:42 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42483 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408860AbgDOLek (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:34:40 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 60A6B5C01BB;
        Wed, 15 Apr 2020 07:34:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:34:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=2UgSgF
        hzKemiuY9h/ssH1ute1oFYfwZKtvmPGz+AseA=; b=UQU+rQ6K7MlqUJ1UTCfDn0
        FRIp6twDQYK2kOVLMqgyKC/wylEj0I9Pl1iqB+S/qSjZNbLtfchP7l9yg6haX9iW
        qs37Uozzjn9ZELTXsmRiQP68m9yNQmk8omoLQjfo8pf+intV133wvkws1JnuD8UM
        ws6miz7iARsWONPi7CAq5tUUPUq+Hhhpjy8L1CKSLLTKRF/DyAh6wqNgczCBaC0G
        ZTYF0scp0U80VDFImVV/tSc43vjWCstGefbTfbXIfV7r12Cf1QrycA6r1t7ruYMU
        DtBoEW6TgqMXqytFE9MY6FjloebWssHM4Z4rHc+2tk5k2ugGHZInYUXYpzgKvkTg
        ==
X-ME-Sender: <xms:T_GWXs5PECV8_4SEoxBNoDGr69PrRAt9FyS2GR5uDuaRR4267vdd2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:T_GWXjsh5uourU4tjYyMkyiCw70FreR8oqM_pzCX94pXiNuJwGV-3A>
    <xmx:T_GWXgxiu9l0LNyPFJdscV1T9LouoZOdWUHDFxAOLnCkR2opJ9Fx7g>
    <xmx:T_GWXrfMypw4EJ5y6tVVpbZsEe3V5eYDglmYopNKiF4lHvmgOz2FxQ>
    <xmx:T_GWXi_1ovsb3haAwScnz1u_i4o-5S9QgDFNDV3q1IJ6GWLPtdB-Lw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0DAC83060062;
        Wed, 15 Apr 2020 07:34:38 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amdgpu: fix gfx hang during suspend with video playback" failed to apply to 5.4-stable tree
To:     Prike.Liang@amd.com, Mengbing.Wang@amd.com,
        alexander.deucher@amd.com, ray.huang@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:34:29 +0200
Message-ID: <15869504692152@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 487eca11a321ef33bcf4ca5adb3c0c4954db1b58 Mon Sep 17 00:00:00 2001
From: Prike Liang <Prike.Liang@amd.com>
Date: Tue, 7 Apr 2020 20:21:26 +0800
Subject: [PATCH] drm/amdgpu: fix gfx hang during suspend with video playback
 (v2)

The system will be hang up during S3 suspend because of SMU is pending
for GC not respose the register CP_HQD_ACTIVE access request.This issue
root cause of accessing the GC register under enter GFX CGGPG and can
be fixed by disable GFX CGPG before perform suspend.

v2: Use disable the GFX CGPG instead of RLC safe mode guard.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Tested-by: Mengbing Wang <Mengbing.Wang@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index faa3e7102156..559dc24ef436 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2340,8 +2340,6 @@ static int amdgpu_device_ip_suspend_phase1(struct amdgpu_device *adev)
 {
 	int i, r;
 
-	amdgpu_device_set_pg_state(adev, AMD_PG_STATE_UNGATE);
-	amdgpu_device_set_cg_state(adev, AMD_CG_STATE_UNGATE);
 
 	for (i = adev->num_ip_blocks - 1; i >= 0; i--) {
 		if (!adev->ip_blocks[i].status.valid)
@@ -3356,6 +3354,9 @@ int amdgpu_device_suspend(struct drm_device *dev, bool fbcon)
 		}
 	}
 
+	amdgpu_device_set_pg_state(adev, AMD_PG_STATE_UNGATE);
+	amdgpu_device_set_cg_state(adev, AMD_CG_STATE_UNGATE);
+
 	amdgpu_amdkfd_suspend(adev, !fbcon);
 
 	amdgpu_ras_suspend(adev);

