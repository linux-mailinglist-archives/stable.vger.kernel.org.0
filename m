Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22AB4FE4D1
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 17:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238173AbiDLPhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 11:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357074AbiDLPhx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 11:37:53 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA0140925
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 08:35:35 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id e8so11873642wra.7
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 08:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VwOMhba2UBHTBdEcSB8ubF3LHDfdwxShkl2jYJGZwac=;
        b=eOj/bw3wwAIvAAhbgxLLgJ4/I/SsQUTJzUpBZOu+lHI3PxiIDDh2QD0J+zLXJCjmkl
         ZYVz8u1gr1RshZumc1gkjPhBfi8L8H44zTnz91eV+IKEmbeYoYd1J5Runw81S3Xkp1LT
         fVb3+gqTsYC0g8fISFaLA6JkzfMfHKgAjVzhslR45IHvlQqFJ1tNe0MfLrAz1WXCmKeL
         kRPWw7XItDToIH5q/ALTcgDZBB3OcBTOBsWzW8UH/OPkZDCFOHwzRXFCVdhKTF3gtAdD
         xPRrAhzsmvFg1njgPt0rHrXJhi5qgcpFWiE1YO4I+yEev17rMyhp9DQS+ezm1CdsCGKi
         BEtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VwOMhba2UBHTBdEcSB8ubF3LHDfdwxShkl2jYJGZwac=;
        b=m91GHYWTcjvBsrqvcG4HZuwtXd5naMuLMuTUAoNmEQfELrS1ga1riK1ZzMYKfoc7ne
         hY8zvtGlbBtqSoEACW35ImgsGMrPwZtMLVdV5TpqKv+rBRfzGXhpeP6FlKsepjnDRI9N
         GI9buoRpSjcX7S/NtaM18WLz/TE2Cp3cK9bC9cJyV4gUBY8nkGQzkBeZwMCh4m36fBa+
         OorQv8Quaj3eua7cz5+Q7dOMTO22bza7TlPi49MQ1TLqasZNl+ezQjiixZf/SHlHYxHm
         wqEKMslwHMldx6YoZbrwYnZISY7uy9LbcV20h4EF4lgJzZML6feroMDm9r1h8jV+rVsA
         Yl4A==
X-Gm-Message-State: AOAM530z11/M08Vdq1CIk2x3fAU9PJ0sUNHKcutTL7MoLY6m/oGQFKBL
        mkYA+WF0+L1wnThb+cTjHcQ6cQ==
X-Google-Smtp-Source: ABdhPJzN2nIUAo8GyjwEfVrI6mSlaVgYt6CfZqC6FHc0/mqgZ//dokwgr/pWS9EpJGKuhyNrsXy7rg==
X-Received: by 2002:a5d:6dd1:0:b0:207:92c4:eaef with SMTP id d17-20020a5d6dd1000000b0020792c4eaefmr18208780wrz.498.1649777734319;
        Tue, 12 Apr 2022 08:35:34 -0700 (PDT)
Received: from joneslee-l.cable.virginm.net (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id p3-20020adfaa03000000b00207a1db96cfsm8463621wrd.71.2022.04.12.08.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 08:35:33 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 4.19 2/2] drm/amdgpu: Ensure the AMDGPU file descriptor is legitimate
Date:   Tue, 12 Apr 2022 16:35:29 +0100
Message-Id: <20220412153529.1173412-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
In-Reply-To: <20220412153529.1173412-1-lee.jones@linaro.org>
References: <20220412153529.1173412-1-lee.jones@linaro.org>
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
index f92597c292fe5..4488aad64643b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1044,11 +1044,15 @@ int amdgpu_amdkfd_gpuvm_acquire_process_vm(struct kgd_dev *kgd,
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

