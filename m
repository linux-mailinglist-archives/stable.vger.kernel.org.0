Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 936CB510CF1
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 01:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242345AbiD0ABl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 20:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbiD0ABk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 20:01:40 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054885DA1C;
        Tue, 26 Apr 2022 16:58:31 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id C6C17320010B;
        Tue, 26 Apr 2022 19:58:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 26 Apr 2022 19:58:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1651017507; x=1651103907; bh=BtMmL7n/JRGJ14Fmmq/dwVsCTg2ZxcEpq+r
        qW3S1p3A=; b=l/pSzQk4/Td483IRhu1k7tJ1TVQ232yVN5Dup90RCvvWdiwl7qS
        tEV+CYktZmkdtNEgHzPYugpqqNegKQg5iwBqPA9yrqJgpXEbuU+dOOkxFVeZGec+
        t6AgtgVI0Z7Yj3C5bqVsTiIseTcGa+VHYrLflHO71MP45hqmhbiQMHVzf6K4Ouc2
        +XqDsFaZCxYJD5N6qIMSDlhDYzaqSeU3FONhon+UcrfH2Gy4bfXuCHRj6aGwDH70
        uTWOhqN9WVM8XKKPCAvth+KP3Mo8gl5/uXsCvikSF1/yrErqTYstKWjj6O1PL4XT
        3W5MytOZQQuvTKl6G+7eFPss6D4wq5NwEeg==
X-ME-Sender: <xms:IodoYuFw54edr7sfwoPBUMp_SSCTkN9LpUN0xKzgmvbahtbrXOxDhg>
    <xme:IodoYvVRV0IpGIAGX5uoe4gqFoMkglqDzj0sOMl-YUyRVqAHn6BKHdEEtNvaLtFYv
    xAIzBhprYRcZw>
X-ME-Received: <xmr:IodoYoJbDK65vnlGW8r5Y0eZsdBYAQF59YkN6jn3pVFmlRf0CdcidZLN4NGndrysQsdv-27d>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeggddvlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvfevufffkffogggtgfesthekredtredtjeenucfhrhhomhepofgrrhgvkhcu
    ofgrrhgtiiihkhhofihskhhiqdfikphrvggtkhhiuceomhgrrhhmrghrvghksehinhhvih
    hsihgslhgvthhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepkedvjefg
    hefhteelkeeiveeihfektdegueehhfehvedvffehtedthfdtgfeufeelnecuffhomhgrih
    hnpehfrhgvvgguvghskhhtohhprdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepmhgrrhhmrghrvghksehinhhvihhsihgslhgvthhhih
    hnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:IodoYoEuNZIZmlaEHxSQrBCIiBHGsLAU6m6q9usPLfcU-hI4ddR0pg>
    <xmx:IodoYkV3nAE6sRw6vEV4043rVz_Yye_-9GQlvJRHWdZrvfHvh8-I5w>
    <xmx:IodoYrNiSY3O0pwr97lRuhLb3H9-urESbKAEQFY8BbtTVr4qUQBxpA>
    <xmx:I4doYglaXAIgwcBt1yKP2oeeaon2j4egYHnTCG4xeyNwFd_6L2U7gQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 Apr 2022 19:58:24 -0400 (EDT)
From:   =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
To:     linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Candice Li <candice.li@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Jingwen Chen <Jingwen.Chen2@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Victor Skvortsov <victor.skvortsov@amd.com>,
        Bokun Zhang <bokun.zhang@amd.com>,
        Bernard Zhao <bernard@vivo.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
        amd-gfx@lists.freedesktop.org (open list:RADEON and AMDGPU DRM DRIVERS),
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS)
Subject: [PATCH] drm/amdgpu: do not use passthrough mode in Xen dom0
Date:   Wed, 27 Apr 2022 01:57:15 +0200
Message-Id: <20220426235718.1634359-1-marmarek@invisiblethingslab.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While technically Xen dom0 is a virtual machine too, it does have
access to most of the hardware so it doesn't need to be considered a
"passthrough". Commit b818a5d37454 ("drm/amdgpu/gmc: use PCI BARs for
APUs in passthrough") changed how FB is accessed based on passthrough
mode. This breaks amdgpu in Xen dom0 with message like this:

    [drm:dc_dmub_srv_wait_idle [amdgpu]] *ERROR* Error waiting for DMUB idle: status=3

While the reason for this failure is unclear, the passthrough mode is
not really necessary in Xen dom0 anyway. So, to unbreak booting affected
kernels, disable passthrough mode in this case.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1985
Fixes: b818a5d37454 ("drm/amdgpu/gmc: use PCI BARs for APUs in passthrough")
Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index a025f080aa6a..5e3756643da3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 
 #include <drm/drm_drv.h>
+#include <xen/xen.h>
 
 #include "amdgpu.h"
 #include "amdgpu_ras.h"
@@ -710,7 +711,8 @@ void amdgpu_detect_virtualization(struct amdgpu_device *adev)
 		adev->virt.caps |= AMDGPU_SRIOV_CAPS_ENABLE_IOV;
 
 	if (!reg) {
-		if (is_virtual_machine())	/* passthrough mode exclus sriov mod */
+		/* passthrough mode exclus sriov mod */
+		if (is_virtual_machine() && !xen_initial_domain())
 			adev->virt.caps |= AMDGPU_PASSTHROUGH_MODE;
 	}
 
-- 
2.35.1

