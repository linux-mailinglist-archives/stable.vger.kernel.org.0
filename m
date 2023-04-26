Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C156EEBAE
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 02:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238820AbjDZAtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 20:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238763AbjDZAsz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 20:48:55 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E513618E80;
        Tue, 25 Apr 2023 17:48:46 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1a6b17d6387so12719165ad.0;
        Tue, 25 Apr 2023 17:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682470126; x=1685062126;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o0BnfPBPiojl+QP/k4t2sPrlYYfp861ciAthUpTF5X4=;
        b=HqoNoVrVJ0tYNI9Bcc8izp2vO9TiFwXSsmlLp9xOUhj53NzjTbyewO2fTWssq5dCXq
         R9f6ivJblpFgQFJ2P42l/8IJggxjPLS3wQB4PQjvwx04sSPvotNgV37FOWKpLpe/OUAU
         hFwPp2YcVADhEUji0dbloenohkutOfWIJGU3rNntY2scMAMlL5WRZ/PFPr2e8QINCYRK
         oYlzSG7Biw4RkhICfWQ1xYGg3BIEGrxQdEIIL+uwcGjvD/4gJAQ4xiEm9n/04Xp1tvdm
         lylzhgDYcyCcTfFKXyNQYt+aNsEvBuRcmC1MY4RpvF0ZhWpHKbiqM9WCLKa/2yV+zjVi
         NeBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682470126; x=1685062126;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o0BnfPBPiojl+QP/k4t2sPrlYYfp861ciAthUpTF5X4=;
        b=hnrb/1e4WXAlKUwLoZOrIZqtwOITiNgC+UnIQqQncpC2I8P7htjN1gW2g5CH8y/Loh
         DkyP2tslKT/otm5q2Jw4dAcznqHSPmuS1SdiipStz7WR5cnhEHJ27LNNjDNYqnq9Raf+
         uiXyFAjAkJvjJNnlmAo04ihw3STHfKlh1sDKZCz4KY1y+dwMV3AAfTJ1hm3GLcMxZ6OY
         MM1PWSrPzWZFps2lzXeNJ0hBtlVPPMABIFw3qk6F2jWefPDD8tfyPcErmpDxPYS6DrbJ
         hFMTupnHuzg4lGNGm+RoJstZfzcxonEzpaX42sCY+d4e4UUDhCrFvPYOHkH7PUqdC0yj
         HcXg==
X-Gm-Message-State: AAQBX9d2MdaW6ZnfmUhgd2uxAWSKDY0BK2yiy6xEREQC3XFYiY0yWXDF
        8jMTgx/OgWSAS9Vp3VaIxxk=
X-Google-Smtp-Source: AKy350ajvykvbDO2EsAOkoWDcIipTLmTGBCKWlhBF3bRZPXOHTwGHyYwev95vinACirrl3ksLTtIuA==
X-Received: by 2002:a17:903:1d1:b0:1a6:93cc:924b with SMTP id e17-20020a17090301d100b001a693cc924bmr24020006plh.3.1682470126042;
        Tue, 25 Apr 2023 17:48:46 -0700 (PDT)
Received: from olv-ct-22.c.googlers.com.com (217.108.125.34.bc.googleusercontent.com. [34.125.108.217])
        by smtp.gmail.com with ESMTPSA id q1-20020a170902788100b001a688de1f0esm8798611pll.234.2023.04.25.17.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 17:48:45 -0700 (PDT)
From:   Chia-I Wu <olvaffe@gmail.com>
To:     dri-devel@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm/amdgpu: add a missing lock for AMDGPU_SCHED
Date:   Tue, 25 Apr 2023 17:48:27 -0700
Message-ID: <20230426004831.650908-1-olvaffe@gmail.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
index e9b45089a28a6..863b2a34b2d64 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
@@ -38,6 +38,7 @@ static int amdgpu_sched_process_priority_override(struct amdgpu_device *adev,
 {
 	struct fd f = fdget(fd);
 	struct amdgpu_fpriv *fpriv;
+	struct amdgpu_ctx_mgr *mgr;
 	struct amdgpu_ctx *ctx;
 	uint32_t id;
 	int r;
@@ -51,8 +52,11 @@ static int amdgpu_sched_process_priority_override(struct amdgpu_device *adev,
 		return r;
 	}
 
-	idr_for_each_entry(&fpriv->ctx_mgr.ctx_handles, ctx, id)
+	mgr = &fpriv->ctx_mgr;
+	mutex_lock(&mgr->lock);
+	idr_for_each_entry(&mgr->ctx_handles, ctx, id)
 		amdgpu_ctx_priority_override(ctx, priority);
+	mutex_unlock(&mgr->lock);
 
 	fdput(f);
 	return 0;
-- 
2.40.0.634.g4ca3ef3211-goog

