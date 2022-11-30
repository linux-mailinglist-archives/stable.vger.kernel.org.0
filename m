Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3598D63E05D
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiK3S6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:58:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiK3S6C (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:58:02 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5A94A5A2;
        Wed, 30 Nov 2022 10:57:58 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 82so9458484pgc.0;
        Wed, 30 Nov 2022 10:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HARMmg9a8K/b5vAg5+2jWHn5nGF+ldiYt0bz7xqmdnE=;
        b=WGTJiF3yAhGqZTID6d08gJEXQ4pOpw/F8IW70Fk4DX3/XKK4GX6O6O5z6sEg6z3ZxA
         nKoCubP1Y5g7MDxpafjnlDV+EId4HA5w7daSh2YvcN6HdV0obI9+UFlyKjmkKYqFR72y
         gMWy1dzzql8GfeFzdH/WmENL31+zec2xHdtXcCkYXTjR8m3n4QiPg3PrzBzgOcwPIHS6
         AaR7qidp6vLsXCgkZT4up/CQ2btS/YTKnCNO3QAxE+f6yYpnKWixbNMgPaXlio5w8zOX
         hxUDE2u3oizkjBG0c3nPpcxfw2PyzrMLfX65HIkSY8twjcXL4M+p+vy8Z5yNr+rm4yNn
         JTgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HARMmg9a8K/b5vAg5+2jWHn5nGF+ldiYt0bz7xqmdnE=;
        b=qxgeTRD4kqFhqcCAYiK5nZTLG09+JX8DxDIex1JvgbVZTzcf3EBKgEaVzTOWfq8h4D
         NsdfoqJ3Jxrn2+LP03ljDUlMEQVWls3lzGbJ76S8vxcmEbVMIIz41acfgEtvOhQ5kwfT
         9eLW/+OCQ1i+D0ZlHYNKNADaSr5cq99kIbl/bbVwix88jgzDoppVx4GrCxN+8cobZMwN
         ujounUfO0wtjY6Xr3pgnBqEZbHsW7YOz717n3EOy3ogHub8TAiNfYOWabhnwwuKR08z3
         /XRXgijgjtpVcicSiRx1UFZMCQNiHm8LuZx6KracT+f+rp6VmWSu+tWmSVMZzKMVrwYw
         W3EQ==
X-Gm-Message-State: ANoB5pnTaMuLH63HbNuWao7cpnuF2Uyy8OBWU8VgWxDzyxa/6Wf2/AF/
        YjNZ+XrEweP0zQjc95bpGFY=
X-Google-Smtp-Source: AA0mqf6ofi5Ziug2zS6ibi211SCEqrDs35lHLQWBZK6VgQEsxw0C1v/30PItrefwpLD/4ByygYUD8w==
X-Received: by 2002:a63:f506:0:b0:470:14fa:a294 with SMTP id w6-20020a63f506000000b0047014faa294mr37579508pgh.361.1669834678336;
        Wed, 30 Nov 2022 10:57:58 -0800 (PST)
Received: from localhost ([2a00:79e1:abd:4a00:2703:3c72:eb1a:cffd])
        by smtp.gmail.com with ESMTPSA id q14-20020aa7842e000000b00575cc2f74ffsm1735664pfn.35.2022.11.30.10.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 10:57:57 -0800 (PST)
From:   Rob Clark <robdclark@gmail.com>
To:     dri-devel@lists.freedesktop.org
Cc:     Daniel Vetter <daniel@ffwll.ch>,
        Rob Clark <robdclark@chromium.org>, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>,
        Eric Anholt <eric@anholt.net>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Rob Herring <robh@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 2/2] drm/shmem-helper: Avoid vm_open error paths
Date:   Wed, 30 Nov 2022 10:57:48 -0800
Message-Id: <20221130185748.357410-3-robdclark@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130185748.357410-1-robdclark@gmail.com>
References: <20221130185748.357410-1-robdclark@gmail.com>
MIME-Version: 1.0
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

From: Rob Clark <robdclark@chromium.org>

vm_open() is not allowed to fail.  Fortunately we are guaranteed that
the pages are already pinned, thanks to the initial mmap which is now
being cloned into a forked process, and only need to increment the
refcnt.  So just increment it directly.  Previously if a signal was
delivered at the wrong time to the forking process, the
mutex_lock_interruptible() could fail resulting in the pages_use_count
not being incremented.

Fixes: 2194a63a818d ("drm: Add library for shmem backed GEM objects")
Cc: stable@vger.kernel.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 3b7b71391a4c..b602cd72a120 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -571,12 +571,20 @@ static void drm_gem_shmem_vm_open(struct vm_area_struct *vma)
 {
 	struct drm_gem_object *obj = vma->vm_private_data;
 	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
-	int ret;
 
 	WARN_ON(shmem->base.import_attach);
 
-	ret = drm_gem_shmem_get_pages(shmem);
-	WARN_ON_ONCE(ret != 0);
+	mutex_lock(&shmem->pages_lock);
+
+	/*
+	 * We should have already pinned the pages when the buffer was first
+	 * mmap'd, vm_open() just grabs an additional reference for the new
+	 * mm the vma is getting copied into (ie. on fork()).
+	 */
+	if (!WARN_ON_ONCE(!shmem->pages_use_count))
+		shmem->pages_use_count++;
+
+	mutex_unlock(&shmem->pages_lock);
 
 	drm_gem_vm_open(vma);
 }
-- 
2.38.1

