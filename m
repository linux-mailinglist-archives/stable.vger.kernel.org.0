Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4834E3EBE
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 13:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbiCVMte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 08:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbiCVMtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 08:49:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D7726F6F
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 05:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647953284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=u9yrNlkYpunaRytWgUY4ikU4zuFUDmjdz1rHYai2Yfg=;
        b=gxjqQKGg1e9u31Em0rFb58sOmiuRMlsNTgMLwXTZNP6VSuMDd2PHYX8we24tTNb+pXcRrq
        FZHvrNVzmMPHMkNT/dzZzW6l/hSNefx6WLw0Q/uJaMRNxj9ltJzsrr1ZQtW+GzcuWV5zu8
        FfzrgN6YZv77kvcmA2zGaRo9OXWBW2M=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-oi_E4ujzMGWFfTeTp3bxaQ-1; Tue, 22 Mar 2022 08:48:03 -0400
X-MC-Unique: oi_E4ujzMGWFfTeTp3bxaQ-1
Received: by mail-wm1-f69.google.com with SMTP id n62-20020a1ca441000000b0038124c99ebcso6829148wme.9
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 05:48:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u9yrNlkYpunaRytWgUY4ikU4zuFUDmjdz1rHYai2Yfg=;
        b=rBNlrl1F0XT5Fyt1kqV/Io+3/iI7dwDVwKpYGs1eeRx6pIMP0v5P+w6bUEBHEXYC5q
         KUVmA5iyv6ufWnFsJFikm020Es7fcFA0W41+lS0PGhmJnIWDQZMRc8zYWKmTg98o3n7X
         z5wJqSabU5BESANJDe7de2bidSLfD4KG/mmbrtOzRsD2Vr75zupPqG2daXWjqSrhBho4
         4H1picGo1MWTXACrehqWB3fJAmjcTGLN+y3bh20QEsoKXR6QxsqudgB+LWadGtrlLL0b
         oElUvMYNlNPezZO+/FaBB+kkuAQXzZ9fwGJAYPe8IEWGCuwIt2QON9oF56LYJs+If6Nn
         Ic2A==
X-Gm-Message-State: AOAM530E01gpABGPGAE7Q8pzmJBGS7ZXl/c0OOlj0AMm+b88Jeb05z+s
        bK4XnA641eC87YFlZF97J24oJrycgBuulhN2Osu2sJrL/f6kLoyfeKPg44PwxvcEDEbagl925kX
        PtLP1I9jiHDsv1n9S
X-Received: by 2002:a05:600c:5021:b0:38c:70c0:80e9 with SMTP id n33-20020a05600c502100b0038c70c080e9mr3610558wmr.91.1647953282574;
        Tue, 22 Mar 2022 05:48:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyb73Jj3kArrdOmr4xNJ2g6A2tODfvNxCiROA57ukRjloP9coQ4ogSvUIco5W02naEshguG4A==
X-Received: by 2002:a05:600c:5021:b0:38c:70c0:80e9 with SMTP id n33-20020a05600c502100b0038c70c080e9mr3610550wmr.91.1647953282389;
        Tue, 22 Mar 2022 05:48:02 -0700 (PDT)
Received: from kherbst.pingu.com ([31.16.187.72])
        by smtp.gmail.com with ESMTPSA id s17-20020adfdb11000000b001f02d5fea43sm16823291wri.98.2022.03.22.05.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 05:48:01 -0700 (PDT)
From:   Karol Herbst <kherbst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Karol Herbst <kherbst@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        stable@vger.kernel.org
Subject: [PATCH] drm/nouveau/pmu: Add missing callbacks for Tegra devices
Date:   Tue, 22 Mar 2022 13:48:00 +0100
Message-Id: <20220322124800.2605463-1-kherbst@redhat.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fixes a crash booting on those platforms with nouveau.

Fixes: 4cdd2450bf73 ("drm/nouveau/pmu/gm200-: use alternate falcon reset sequence")
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: nouveau@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.17+
Signed-off-by: Karol Herbst <kherbst@redhat.com>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm20b.c | 1 +
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp102.c | 2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c | 1 +
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/priv.h  | 1 +
 4 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm20b.c b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm20b.c
index e1772211b0a4..612310d5d481 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm20b.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm20b.c
@@ -216,6 +216,7 @@ gm20b_pmu = {
 	.intr = gt215_pmu_intr,
 	.recv = gm20b_pmu_recv,
 	.initmsg = gm20b_pmu_initmsg,
+	.reset = gf100_pmu_reset,
 };
 
 #if IS_ENABLED(CONFIG_ARCH_TEGRA_210_SOC)
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp102.c b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp102.c
index 6bf7fc1bd1e3..1a6f9c3af5ec 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp102.c
@@ -23,7 +23,7 @@
  */
 #include "priv.h"
 
-static void
+void
 gp102_pmu_reset(struct nvkm_pmu *pmu)
 {
 	struct nvkm_device *device = pmu->subdev.device;
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c
index ba1583bb618b..94cfb1791af6 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c
@@ -83,6 +83,7 @@ gp10b_pmu = {
 	.intr = gt215_pmu_intr,
 	.recv = gm20b_pmu_recv,
 	.initmsg = gm20b_pmu_initmsg,
+	.reset = gp102_pmu_reset,
 };
 
 #if IS_ENABLED(CONFIG_ARCH_TEGRA_210_SOC)
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/priv.h b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/priv.h
index bcaade758ff7..21abf31f4442 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/priv.h
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/priv.h
@@ -41,6 +41,7 @@ int gt215_pmu_send(struct nvkm_pmu *, u32[2], u32, u32, u32, u32);
 
 bool gf100_pmu_enabled(struct nvkm_pmu *);
 void gf100_pmu_reset(struct nvkm_pmu *);
+void gp102_pmu_reset(struct nvkm_pmu *pmu);
 
 void gk110_pmu_pgob(struct nvkm_pmu *, bool);
 
-- 
2.35.1

