Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDDD22A4A56
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbgKCPti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:49:38 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:51557 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726312AbgKCPth (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 10:49:37 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id EDA97D47;
        Tue,  3 Nov 2020 10:49:36 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 10:49:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=awNNOu
        G+b2rYnPEEdGf09Z/Hy708j/1A+a3C3ka6DNI=; b=Rfi8Ed+A/UCcjjFN1z3Axf
        Lt50utCMrOHMm4U/GhmfGEy+cUnokixrIva+8uqB9YxVeq6D3djZ5Wl+Ol1IgGGo
        2lQs1tphKnAsACY5GFPBB9TwL4+f2GbArfYhzzFVBHOblet9aZKvDsmvSHtx2+fh
        L6a56ES+AuBEptEDYGEzeD9ssaPYgcQW6hg6pP/CBld9j9KMZm7zU/frPcgKUw0U
        2QkFScNxNUV6Zf5u5FedrMyXXmNa5qdKKZ8Ky1V1y9Zkz5TC3TAgs7lSlEi8/V34
        RFh2BeC18jIUn4QR82MJ6ygK4tHN4yIp6GiaZNGjD9yV34tQP2WJKDYUmQGnz7oQ
        ==
X-ME-Sender: <xms:EHyhX0armCqG4IhfhGZh5L8a8yQ6DNRstIF-Dx5JOlpZ4k-eyMG3Tw>
    <xme:EHyhX_bsXy0dm-bsxogUs9ATOvoU7mhefrbngd-bTAWBier0xUGqzimwZ4quqhUqc
    uYWL02XJEfnMw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:EHyhX-9A5T6OoQrOx06hqV7-Bl_514WHfvrXdnJUhdPWM5gTvWqQng>
    <xmx:EHyhX-rLKiMyAS7Pe3qD9hfwwZJ0KzxrEkGbOgoyuapAMFdNFUd7MA>
    <xmx:EHyhX_rSaJAw3UMuPH_ZqsNChzDxEEqTtAtX0tSXbw_ZQVJ6vKdECQ>
    <xmx:EHyhX4CqUwcgLlq0hWThMcfjF6wcGFT2KR5OfoEVMz9vPq40yKDRgumBqkM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D75733064680;
        Tue,  3 Nov 2020 10:49:35 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amdgpu: correct the cu and rb info for sienna cichlid" failed to apply to 5.9-stable tree
To:     Likun.Gao@amd.com, Hawking.Zhang@amd.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 16:50:29 +0100
Message-ID: <160441862922036@kroah.com>
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

From 687e79c0feb4243b141b1e9a20adba3c0ec66f7f Mon Sep 17 00:00:00 2001
From: Likun Gao <Likun.Gao@amd.com>
Date: Thu, 22 Oct 2020 00:50:07 +0800
Subject: [PATCH] drm/amdgpu: correct the cu and rb info for sienna cichlid

Skip disabled sa to correct the cu_info and active_rbs for sienna cichlid.

Signed-off-by: Likun Gao <Likun.Gao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.9.x

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 1c98b248a7fb..56fdbe626d30 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -4582,12 +4582,17 @@ static void gfx_v10_0_setup_rb(struct amdgpu_device *adev)
 	int i, j;
 	u32 data;
 	u32 active_rbs = 0;
+	u32 bitmap;
 	u32 rb_bitmap_width_per_sh = adev->gfx.config.max_backends_per_se /
 					adev->gfx.config.max_sh_per_se;
 
 	mutex_lock(&adev->grbm_idx_mutex);
 	for (i = 0; i < adev->gfx.config.max_shader_engines; i++) {
 		for (j = 0; j < adev->gfx.config.max_sh_per_se; j++) {
+			bitmap = i * adev->gfx.config.max_sh_per_se + j;
+			if ((adev->asic_type == CHIP_SIENNA_CICHLID) &&
+			    ((gfx_v10_3_get_disabled_sa(adev) >> bitmap) & 1))
+				continue;
 			gfx_v10_0_select_se_sh(adev, i, j, 0xffffffff);
 			data = gfx_v10_0_get_rb_active_bitmap(adev);
 			active_rbs |= data << ((i * adev->gfx.config.max_sh_per_se + j) *
@@ -8812,6 +8817,10 @@ static int gfx_v10_0_get_cu_info(struct amdgpu_device *adev,
 	mutex_lock(&adev->grbm_idx_mutex);
 	for (i = 0; i < adev->gfx.config.max_shader_engines; i++) {
 		for (j = 0; j < adev->gfx.config.max_sh_per_se; j++) {
+			bitmap = i * adev->gfx.config.max_sh_per_se + j;
+			if ((adev->asic_type == CHIP_SIENNA_CICHLID) &&
+			    ((gfx_v10_3_get_disabled_sa(adev) >> bitmap) & 1))
+				continue;
 			mask = 1;
 			ao_bitmap = 0;
 			counter = 0;

