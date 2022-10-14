Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772745FEA42
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 10:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiJNIQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 04:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiJNIP7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 04:15:59 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8768C157F74
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 01:15:58 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id b12so5825743edd.6
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 01:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zi3g0gUsoeReyu3M9Dd3IEc+zU79SSSBwTJbXIApLpg=;
        b=R6gVvB8anInV7lNdqB+ENmzugVdF686pFgLU5ufl0FN5l3OTFcnE/CWYXB84tZWN62
         s6QW8dEAhbSikwOJY0rGxepIzcU4RfQhQ3sdOtyLYwgbzPSXBjSUhKoGlPQ71P5895p1
         rJAjUNy4tk2fVD4LbYDT7qtLD57naKlhvMVoLV1EGACb6X4EcvivZTGcj6EBOhvqK0bq
         KbdFuCpRtU0LgfvGEv+zjrQsHYR+PmKRG38pZhcy0IV81KaJl9+FBbZhedHVdPJ9QRbA
         BOJKXfdptuyNjQ2FWqKjvaAPLj7/Pt3SkDR0ZGULOam1FdC+InCwIHCKa/5WH2TkPhne
         lYFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zi3g0gUsoeReyu3M9Dd3IEc+zU79SSSBwTJbXIApLpg=;
        b=6msSYigYX5o/NmkKnp5I+aiANCapLGnoqucS1B0Q6krrK2L/Gy0PlPcEYnpiRoplay
         hwIOdAuNFgmZQSFQFAsXzHmK8qk3CJ2cobg2yqCtzaLaiUOnbgrXK8XLkeqhE8MrNJ95
         Jx8M+I9lL1N2U4GtojM640HUU1sMeY4nTYiMIkI0C32m3tE26PWZpsf4r9ZaQPqa/vul
         yb8QMUhrLfEtTx0ebn4vQfQJYAsO4EsTlCftZ36ZL9AIFwC8GKOBFXhKrtWO/R64SEPD
         bJbXhRzYu1POmjkJylh/3+Iq3yaOUutQ+4Vfbf9j4cIfZhoSadKBbRI++Ort6/7u/Jwx
         tM1Q==
X-Gm-Message-State: ACrzQf1Ipwlz+jw7pysFNjT8FTnelDAE+5xFdE/50p3sIZcUaW7FGynr
        R1caVLuoWuHIfr1rThLeMebbYycjHQc=
X-Google-Smtp-Source: AMsMyM46Gt3+KeRKQ//eFjkr9Auam70HriXsymEnFt0GVzMbcHlD7zThEefdDu9I06HPHf9hJXFZ6A==
X-Received: by 2002:a05:6402:450c:b0:443:6279:774f with SMTP id ez12-20020a056402450c00b004436279774fmr3352022edb.11.1665735357051;
        Fri, 14 Oct 2022 01:15:57 -0700 (PDT)
Received: from able.fritz.box (p5b0eacfe.dip0.t-ipconnect.de. [91.14.172.254])
        by smtp.gmail.com with ESMTPSA id lb17-20020a170907785100b0078d886c871bsm1146188ejc.70.2022.10.14.01.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 01:15:56 -0700 (PDT)
From:   "=?UTF-8?q?Christian=20K=C3=B6nig?=" 
        <ckoenig.leichtzumerken@gmail.com>
X-Google-Original-From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
To:     luben.tuikov@amd.com, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] drm/amdgpu: use DRM_SCHED_FENCE_DONT_PIPELINE for VM updates
Date:   Fri, 14 Oct 2022 10:15:53 +0200
Message-Id: <20221014081553.114899-2-christian.koenig@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221014081553.114899-1-christian.koenig@amd.com>
References: <20221014081553.114899-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure that we always have a CPU round trip to let the submission
code correctly decide if a TLB flush is necessary or not.

Signed-off-by: Christian König <christian.koenig@amd.com>
CC: stable@vger.kernel.org # 5.19+
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
index 2b0669c464f6..69e105fa41f6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
@@ -116,8 +116,15 @@ static int amdgpu_vm_sdma_commit(struct amdgpu_vm_update_params *p,
 				   DMA_RESV_USAGE_BOOKKEEP);
 	}
 
-	if (fence && !p->immediate)
+	if (fence && !p->immediate) {
+		/*
+		 * Most hw generations now have a separate queue for page table
+		 * updates, but when the queue is shared with userspace we need
+		 * the extra CPU round trip to correctly flush the TLB.
+		 */
+		set_bit(DRM_SCHED_FENCE_DONT_PIPELINE, &f->flags);
 		swap(*fence, f);
+	}
 	dma_fence_put(f);
 	return 0;
 
-- 
2.25.1

