Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203FF5A698D
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiH3RUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbiH3RTp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:19:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0646DD4E6;
        Tue, 30 Aug 2022 10:19:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAAC161775;
        Tue, 30 Aug 2022 17:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BDFC433D6;
        Tue, 30 Aug 2022 17:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661879962;
        bh=avKLgB8ycs/5i5FbGLyyAohN1rYc0v6FmHyhCFQT7ME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sRlvWlT5viU3x2g5frNT5ictw8td/yUS/qL9Nnx3euq7b7jy680tctkvJckRUGne3
         8S4jKl9dK34vIOI9ajmHpgGDs6B53+Udn43I5dBZ4vRt/jm4ojsMPcisY2gfi2g5cy
         uRuzldrz2ADdtCJH3YQeR+nt17N27/iFGRwzbVnm3kPETtoyFrWn9rYtYjtcMJ7/2i
         r4rhl3F4jzDw++BHOGncFXHH6FWY4tPk8Uumugkf5a//WegfU/CkdQNVjHWukbZqgy
         37MAxraDgEhAkZ7cdvzfbNI7BM9xugs/sWYsqAZOS4L+1wjkymhXvpo3fr5uQYtJGS
         0T19wwDub5zHw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     shaoyunl <shaoyun.liu@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        andrey.grodzovsky@amd.com, guchun.chen@amd.com,
        Amaranath.Somalapuram@amd.com, lang.yu@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 12/33] drm/amdgpu: Remove the additional kfd pre reset call for sriov
Date:   Tue, 30 Aug 2022 13:18:03 -0400
Message-Id: <20220830171825.580603-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830171825.580603-1-sashal@kernel.org>
References: <20220830171825.580603-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: shaoyunl <shaoyun.liu@amd.com>

[ Upstream commit 06671734881af2bcf7f453661b5f8616e32bb3fc ]

The additional call is caused by merge conflict

Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: shaoyunl <shaoyun.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index ea2b74c0fd229..67d4a3c13ed19 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4475,8 +4475,6 @@ static int amdgpu_device_reset_sriov(struct amdgpu_device *adev,
 retry:
 	amdgpu_amdkfd_pre_reset(adev);
 
-	amdgpu_amdkfd_pre_reset(adev);
-
 	if (from_hypervisor)
 		r = amdgpu_virt_request_full_gpu(adev, true);
 	else
-- 
2.35.1

