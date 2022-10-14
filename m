Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D16D5FEA41
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 10:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiJNIP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 04:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiJNIP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 04:15:58 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73095152C4E
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 01:15:57 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id m15so5791835edb.13
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 01:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Tiq+iZ8WHyngN/AauVz6Bi2y5WOuCWMci27ME2OuFVA=;
        b=OtYtw4lO/czie0rpjgh2BgsFgqTFYYwqfo0FTaehi609mTI3Rnt0+LOFYG2VtTqw1+
         TDzmq4HfG79ceq1+iNYGzsoP/GLcLUzICZHPsJq7wJA7TFEE8u2NhvSBqz7DtkXDk8vn
         MHOYU1rZgTUcibC5qC6dHXmEVIJrXWlaiCBMs2ikv9IC0SSd+t85MvElW6rwVtCybnuc
         sOQIqd9SxZA6ibWmtNjUYeYtEdtj/I0UNnkD2Amqbr2Max1jSnkFMhb2hI/tKpTKUTkU
         uhFB2Dnwv4nkb4iQWR5/TZTwkE44yHs4TXqCQNdEqQj1q6z3eh5ugwdSReBbSl/xoLQO
         AWKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tiq+iZ8WHyngN/AauVz6Bi2y5WOuCWMci27ME2OuFVA=;
        b=V15vqVo+Rj2MnU7vRl7EFO9CcuSLXeXBVxgXE6eTQyEGmz4ElO0Fkkop4hi08AMwQ3
         hb+k+BYJmyGJDG3jElLZD0kYGJi3K5niPtiZBeBmBL8PpvWhJ4VftYrQmkrUTnKJyqra
         DhsG0FCA2RNDqTvLfQm0e/OEk5vN9awiQ+0ai1wQOqMs8FAmqM8eaXUVaMQOgbEMLM9y
         ISNtbEarJq0da+TzE7nGsGoOV8AcmxsgvLZVSwGNYBLhJuLCT+ZYgOEu6tZ2+gGYlV2f
         CHds5JCkXxX0elho3v0q/ROR5UZXKw8q/cdx3aNo1Mly1i2voXxCAQ4MqCcL2yEJrRrQ
         zbdA==
X-Gm-Message-State: ACrzQf3EDBkhf+BDH915so9BJiJWHipj1xFT3WOIEGSR9hOEyrwEXijK
        tNtW3nRJku5nfkbaFeO0TqI=
X-Google-Smtp-Source: AMsMyM5kEC1M52w1Fj9TW33rmzmDwveDjjNBlmEPlubyz6eZ4p25Fi5F4stmsUPB7IcSdgvEBYeH8w==
X-Received: by 2002:a05:6402:847:b0:453:943b:bf4 with SMTP id b7-20020a056402084700b00453943b0bf4mr3245709edz.301.1665735355961;
        Fri, 14 Oct 2022 01:15:55 -0700 (PDT)
Received: from able.fritz.box (p5b0eacfe.dip0.t-ipconnect.de. [91.14.172.254])
        by smtp.gmail.com with ESMTPSA id lb17-20020a170907785100b0078d886c871bsm1146188ejc.70.2022.10.14.01.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 01:15:55 -0700 (PDT)
From:   "=?UTF-8?q?Christian=20K=C3=B6nig?=" 
        <ckoenig.leichtzumerken@gmail.com>
X-Google-Original-From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
To:     luben.tuikov@amd.com, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] drm/sched: add DRM_SCHED_FENCE_DONT_PIPELINE flag
Date:   Fri, 14 Oct 2022 10:15:52 +0200
Message-Id: <20221014081553.114899-1-christian.koenig@amd.com>
X-Mailer: git-send-email 2.25.1
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

Setting this flag on a scheduler fence prevents pipelining of jobs
depending on this fence. In other words we always insert a full CPU
round trip before dependen jobs are pushed to the pipeline.

Signed-off-by: Christian König <christian.koenig@amd.com>
CC: stable@vger.kernel.org # 5.19+
---
 drivers/gpu/drm/scheduler/sched_entity.c | 3 ++-
 include/drm/gpu_scheduler.h              | 9 +++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/scheduler/sched_entity.c b/drivers/gpu/drm/scheduler/sched_entity.c
index 191c56064f19..43d337d8b153 100644
--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -385,7 +385,8 @@ static bool drm_sched_entity_add_dependency_cb(struct drm_sched_entity *entity)
 	}
 
 	s_fence = to_drm_sched_fence(fence);
-	if (s_fence && s_fence->sched == sched) {
+	if (s_fence && s_fence->sched == sched &&
+	    !test_bit(DRM_SCHED_FENCE_DONT_PIPELINE, &fence->flags)) {
 
 		/*
 		 * Fence is from the same scheduler, only need to wait for
diff --git a/include/drm/gpu_scheduler.h b/include/drm/gpu_scheduler.h
index 0fca8f38bee4..f01d14b231ed 100644
--- a/include/drm/gpu_scheduler.h
+++ b/include/drm/gpu_scheduler.h
@@ -32,6 +32,15 @@
 
 #define MAX_WAIT_SCHED_ENTITY_Q_EMPTY msecs_to_jiffies(1000)
 
+/**
+ * DRM_SCHED_FENCE_DONT_PIPELINE - Prefent dependency pipelining
+ *
+ * Setting this flag on a scheduler fence prevents pipelining of jobs depending
+ * on this fence. In other words we always insert a full CPU round trip before
+ * dependen jobs are pushed to the hw queue.
+ */
+#define DRM_SCHED_FENCE_DONT_PIPELINE	DMA_FENCE_FLAG_USER_BITS
+
 struct drm_gem_object;
 
 struct drm_gpu_scheduler;
-- 
2.25.1

