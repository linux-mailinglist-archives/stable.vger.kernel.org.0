Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C854FE49F
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 17:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240174AbiDLPX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 11:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiDLPX1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 11:23:27 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FAA1A82F
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 08:21:09 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id r7so12153004wmq.2
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 08:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vs73aHyAmGEvpCioRI3iBUOW914um+My5SdypFp/cZw=;
        b=i6sVsTx7slmXjbeB3WRYDPa+2iJH7EsSfuofElc2rklvTjGwIjryej9zCt4Ep5Pw6F
         9hv9Di8ot5cFzFXu9c4vfRdsfZ9sVh5FhhIugfA/X3fpcHnzXKZGJVh1pTltOqpIFDqW
         WqR1stJnxSWOmJqzhYFtV4ZzNz0eEBFkdbt8E9EiQbbSpthsV7UhNKi0lA+A4dVpR6vU
         ziPxK1+LyLJI1yvge2kwpLYIkrKhhW0het9vHl4WSY+xDOZrKWqpYBFJXdWIBxiMrR1Y
         orl32gT62bkrnpKaw+Vv5rdEAUMJedEg639sO1TbGk0YLPRENCpjvyyuX0X0WxKe25st
         6wxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vs73aHyAmGEvpCioRI3iBUOW914um+My5SdypFp/cZw=;
        b=QQf7rQd6qXF525MvOjd68+DL0PW9r5SJ4WSaBs+2XwkS3VPDsNI9geyzM9O7pV6Jig
         TgMcxhxNbOvSaUv9uDYniM8hQmwF0nn8tsBfY5EbjsjD4Wmn7HpIzYh2EcSWCsF4hmbb
         4ABlW5WYRPTNt+tzQ7bGcI3zxQE3hGDChcG76pv2VmgK4vuC1xbAiwqkAsHn//08w+Vz
         Qxcpwc4MvM27y01O8K0C8zaoRo2+Zt1l27ODEetgbUf36YGWTfIcn3+0cvI3CYAMOibT
         fi2EbZFqnHOiflEHI0MBuJyG9FWWoB78/VpxjAxgwHNYyOy2U0MgqZMY+/JjawSH5cQN
         Udkg==
X-Gm-Message-State: AOAM530sapALah3vMKa92cRXSdmi3D55g8NiQyeESloOg/g9s+u+ZMeM
        6++lwPB8/xescTjokhnpHaSumw==
X-Google-Smtp-Source: ABdhPJxxahNWQ1No7pe0Pv0bxjkJb7c+vjvr0Tl71uomMjhpW9Xzi8N8CeTr8vY5QVn1ApIUpPEgzg==
X-Received: by 2002:a05:600c:1d26:b0:38e:ae44:9ec with SMTP id l38-20020a05600c1d2600b0038eae4409ecmr4468981wms.87.1649776868084;
        Tue, 12 Apr 2022 08:21:08 -0700 (PDT)
Received: from joneslee-l.cable.virginm.net (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id 7-20020a05600c024700b0038ec0c4a2e7sm2549832wmj.11.2022.04.12.08.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 08:21:07 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 5.10 1/1] drm/amdgpu: Ensure the AMDGPU file descriptor is legitimate
Date:   Tue, 12 Apr 2022 16:20:57 +0100
Message-Id: <20220412152057.1170235-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b40a6ab2cf9213923bf8e821ce7fa7f6a0a26990 ]

This is a partial cherry-pick of the above upstream commit.

It ensures the file descriptor passed in by userspace is a valid one.

Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: amd-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 26f8a21383774..1b4c7ced8b92c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1024,11 +1024,15 @@ int amdgpu_amdkfd_gpuvm_acquire_process_vm(struct kgd_dev *kgd,
 					   struct dma_fence **ef)
 {
 	struct amdgpu_device *adev = get_amdgpu_device(kgd);
-	struct drm_file *drm_priv = filp->private_data;
-	struct amdgpu_fpriv *drv_priv = drm_priv->driver_priv;
-	struct amdgpu_vm *avm = &drv_priv->vm;
+	struct amdgpu_fpriv *drv_priv;
+	struct amdgpu_vm *avm;
 	int ret;
 
+	ret = amdgpu_file_to_fpriv(filp, &drv_priv);
+	if (ret)
+		return ret;
+	avm = &drv_priv->vm;
+
 	/* Already a compute VM? */
 	if (avm->process_info)
 		return -EINVAL;
-- 
2.35.1.1178.g4f1659d476-goog

