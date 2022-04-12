Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4579B4FE4D0
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 17:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiDLPhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 11:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357071AbiDLPhx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 11:37:53 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E003C73B
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 08:35:34 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id e21so11777680wrc.8
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 08:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R8tCAcef8XwJl9KTqrtg+6fe8UCJe3U1QYYPaYj+qfQ=;
        b=HsVtVNZKO4dILqYqxSUWjS2SGL/4TmifveOGMHwmuTp68q68G1ZeQvPBGddKz698Pe
         IdfBA2pwXuk1WZlvIaG3uPp8OvV8fEelWZnIqsWxfPZffviKxisvegjb0RxBIWFfSOlT
         tmtArcp7kQSq9MNuROSDdRtyVeYmcEExKY2EPeEXIk25RBCvcnVcLBvEm48rfOtcnBlN
         UImguNaMDCY3xdv2jSSXDkybhjngHUeZMX1XkFeGz6N6ZuL/oU5h1GgwGGOg0mjcD+od
         KVoIOFb6jAWpxLQNeE19IW6iHnSALxkS5VB5WyAHrCjbtDVj3GtnAW5ILxbE2/JlRPso
         x3yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R8tCAcef8XwJl9KTqrtg+6fe8UCJe3U1QYYPaYj+qfQ=;
        b=dw7/LtlVrQjBdyk3aA4iLZpCpbVaoBzKxXdB+wzCO/2lAuF9vVy3yIsVAyVpDPMDlT
         MkxosNmYBBWx+jTF4rs4tVTNGRFsNKdHCGNE2FtvYBfBItMT6uh4DCaTdfgKHGoVZiqG
         Rhnyqw0EVQ53kebA5rT8Uko1bdAKkoN4CnCCRyvGX83v34inV1s1sgn3zrDiEUX+t8r+
         /2rL1Ja/iduW9oWQJY49+diXAaq690C8Jj1L0yTzhWUT1wTWZMSsAX9j98jBgKmebtly
         AwntS1aRaAySmJ0PPxpi3byW8QoD28ra7znW1D/yZQWA27c6RKfjZFyGBDgAGtSuBCi/
         GVlA==
X-Gm-Message-State: AOAM531IoAH8aTz+JmOSGMua0eB+wvdRrk3TvKO+BIHPzL19VC9GcFEq
        4qt4gtwN5J1irRbsCrws/e0f8A==
X-Google-Smtp-Source: ABdhPJzUkHNn+3YdLFEMdtBrSdi3OtBRyyIQ73jg0NzUODmGehiltfBY7h/QiG7HYp4qS8+jdX6Qsg==
X-Received: by 2002:a5d:48c8:0:b0:207:afc8:13fa with SMTP id p8-20020a5d48c8000000b00207afc813famr2526733wrs.487.1649777733295;
        Tue, 12 Apr 2022 08:35:33 -0700 (PDT)
Received: from joneslee-l.cable.virginm.net (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id p3-20020adfaa03000000b00207a1db96cfsm8463621wrd.71.2022.04.12.08.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 08:35:32 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 4.19 1/2] drm/amdgpu: Check if fd really is an amdgpu fd.
Date:   Tue, 12 Apr 2022 16:35:28 +0100
Message-Id: <20220412153529.1173412-1-lee.jones@linaro.org>
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

From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

[ Upstream commit 021830d24ba55a578f602979274965344c8e6284 ]

Otherwise we interpret the file private data as drm & amdgpu data
while it might not be, possibly allowing one to get memory corruption.

Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: amd-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h       |  2 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c   | 16 ++++++++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c | 10 +++++++---
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index 447c4c7a36d68..acbd33fcb73d3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -955,6 +955,8 @@ struct amdgpu_gfx {
 	DECLARE_BITMAP			(pipe_reserve_bitmap, AMDGPU_MAX_COMPUTE_QUEUES);
 };
 
+int amdgpu_file_to_fpriv(struct file *filp, struct amdgpu_fpriv **fpriv);
+
 int amdgpu_ib_get(struct amdgpu_device *adev, struct amdgpu_vm *vm,
 		  unsigned size, struct amdgpu_ib *ib);
 void amdgpu_ib_free(struct amdgpu_device *adev, struct amdgpu_ib *ib,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 63b1e325b45c5..b3b22a87b232b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1132,6 +1132,22 @@ static const struct file_operations amdgpu_driver_kms_fops = {
 #endif
 };
 
+int amdgpu_file_to_fpriv(struct file *filp, struct amdgpu_fpriv **fpriv)
+{
+        struct drm_file *file;
+
+	if (!filp)
+		return -EINVAL;
+
+	if (filp->f_op != &amdgpu_driver_kms_fops) {
+		return -EINVAL;
+	}
+
+	file = filp->private_data;
+	*fpriv = file->driver_priv;
+	return 0;
+}
+
 static bool
 amdgpu_get_crtc_scanout_position(struct drm_device *dev, unsigned int pipe,
 				 bool in_vblank_irq, int *vpos, int *hpos,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
index 1cafe8d83a4db..0b70410488b66 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
@@ -54,16 +54,20 @@ static int amdgpu_sched_process_priority_override(struct amdgpu_device *adev,
 						  enum drm_sched_priority priority)
 {
 	struct file *filp = fget(fd);
-	struct drm_file *file;
 	struct amdgpu_fpriv *fpriv;
 	struct amdgpu_ctx *ctx;
 	uint32_t id;
+	int r;
 
 	if (!filp)
 		return -EINVAL;
 
-	file = filp->private_data;
-	fpriv = file->driver_priv;
+	r = amdgpu_file_to_fpriv(filp, &fpriv);
+	if (r) {
+		fput(filp);
+		return r;
+	}
+
 	idr_for_each_entry(&fpriv->ctx_mgr.ctx_handles, ctx, id)
 		amdgpu_ctx_priority_override(ctx, priority);
 
-- 
2.35.1.1178.g4f1659d476-goog

