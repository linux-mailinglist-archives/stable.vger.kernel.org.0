Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885C134B786
	for <lists+stable@lfdr.de>; Sat, 27 Mar 2021 15:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhC0OTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Mar 2021 10:19:12 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:34189 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229582AbhC0OSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Mar 2021 10:18:55 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 15CE91529;
        Sat, 27 Mar 2021 10:18:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 27 Mar 2021 10:18:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=B6hPY2
        A++mtMsXsDNDL53bNegxEoPj/ZpzbY7hznt30=; b=San6GHfyy8S0z6JMiEBa/L
        P+sKKSip8NIhLLpppgaal0dKM9J4VcQRetgH+5OwUe1yBtOCIsqfQYLuUrr3iVpc
        SIDVyNYSBEPKAA2ysE7NmVS6X70qgixFMffcdzW9tyY9cNn/H5DuOZwaucDFduFM
        g0RmDHWuqbj2WBzrvdBXIDDYBg+TwSB54NJV1wzh8yQt1NWToHOKjUIo5kC5C2Mf
        yV9ts7bZyNW0Y2OKcU4z+SI/NLhpGcBKY9iy/EMTViq4/dZsWLue2kLUnGSbepWl
        WMJ7n0XftyV6AbBu9qRApmRYjk9mZcpucIJ8A74nVeyu0iD7PE6V6UARrtVTYytw
        ==
X-ME-Sender: <xms:yT5fYOivobcxw-9dNlV1JDcQGMWQC6vBH5TzoJVFW5vq_lqxqvNx3Q>
    <xme:yT5fYO_WNzblw5IOgs0jn3_EfOK1aky2JYCCqbD57F-8YByyZAvt6eqbeSGXpwF8o
    Ib5Mjrgci6EsA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehgedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:yT5fYC8zWkgWZ9Qkr-igFiO3qmhDWATrrEGOqRC2zkYl5wLl2WGGvA>
    <xmx:yT5fYPDxYou2KjegHBZxA6PgS3e1F9lZLJ_rhGlrtlcMPnZr8Nw1Lg>
    <xmx:yT5fYKysvXZE0IQC1jFHMuD8py3ogNkxuy5XOnsTGbyjZU73LxZtUQ>
    <xmx:yT5fYKtxXftvtSUA8VUNPtl0_gOdHqBy9LpAYBZ7tb7oSqlSYpZJolUXl70>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4BB5F108005F;
        Sat, 27 Mar 2021 10:18:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amdgpu: fix the hibernation suspend with s0ix" failed to apply to 5.10-stable tree
To:     Prike.Liang@amd.com, alexander.deucher@amd.com, ray.huang@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 27 Mar 2021 15:18:47 +0100
Message-ID: <161685472714864@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From 9aa26019c1a60013ea866d460de6392acb1712ee Mon Sep 17 00:00:00 2001
From: Prike Liang <Prike.Liang@amd.com>
Date: Tue, 9 Mar 2021 09:34:00 +0800
Subject: [PATCH] drm/amdgpu: fix the hibernation suspend with s0ix

During system hibernation suspend still need un-gate gfx CG/PG firstly to handle HW
status check before HW resource destory.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 6447cd6ca5a8..7ecc6e4b8456 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2678,7 +2678,7 @@ static int amdgpu_device_ip_suspend_phase1(struct amdgpu_device *adev)
 {
 	int i, r;
 
-	if (adev->in_poweroff_reboot_com ||
+	if (adev->in_poweroff_reboot_com || adev->in_hibernate ||
 	    !amdgpu_acpi_is_s0ix_supported(adev) || amdgpu_in_reset(adev)) {
 		amdgpu_device_set_pg_state(adev, AMD_PG_STATE_UNGATE);
 		amdgpu_device_set_cg_state(adev, AMD_CG_STATE_UNGATE);
@@ -3742,7 +3742,11 @@ int amdgpu_device_suspend(struct drm_device *dev, bool fbcon)
 
 	amdgpu_fence_driver_suspend(adev);
 
-	if (adev->in_poweroff_reboot_com ||
+	/*
+	 * TODO: Need figure out the each GNB IP idle off dependency and then
+	 * improve the AMDGPU suspend/resume sequence for system-wide Sx entry/exit.
+	 */
+	if (adev->in_poweroff_reboot_com || adev->in_hibernate ||
 	    !amdgpu_acpi_is_s0ix_supported(adev) || amdgpu_in_reset(adev))
 		r = amdgpu_device_ip_suspend_phase2(adev);
 	else

