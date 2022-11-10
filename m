Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85DF76242B2
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 14:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiKJNAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 08:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiKJNAQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 08:00:16 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535B570193
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 05:00:15 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id l14so2161773wrw.2
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 05:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F5NQ6VJyp0baBXTljbwhIqk2j4TLXv8MVbL3XVH/SEM=;
        b=P7ljOBiw/qaMDVJwhvhruGG9ay2oDvHR2Jv3xW0BwgYuqbV2hvhqNPrhgqm5FsAnjq
         3UFQsUW9kMbk075oMUkl80oQQNfp8XLr9Or739IGcPDiknpQ+lSmLIvs2wJTkRDjF5hu
         meotWdTX5OdlesRNlgVu4iNarcs/SOn3VnINnyiocatgdoYgYwDNpclVDK/Oo4qp2DdF
         XzCf8aM5IBEc+OvLQJK809J9rn767gkotPJ4QmQo8mmFqW6p0gVo2CgrX0gWv8OJTzmY
         RrQYqWAZzESvxupTMTWI5J8W84/DyMHLxXHrZBee25twYgSg7lCpF3e0jpdSnzQiliZw
         37Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F5NQ6VJyp0baBXTljbwhIqk2j4TLXv8MVbL3XVH/SEM=;
        b=qFsdhM2BlWQb3CZwPb4lTBH+KXE2AKL0Crq+pPpxH1l8tdzqxCysysx2ZdKRYHAijH
         eE+UQcth/wF1ibPdjbl05n8W/nLlSfY2bHc8UNfX2n+hzPOZztF+c/cEt394MPwFXZsu
         unCJ6uI+c9IlGt5MQ0hPwJRjWcTxGOK4oI+1M0yr7VhM6jhEOqoZ/rQSqqN6W35V8rfr
         4ygqY3JCw0GT4O4qaDt1HCN5JBqn4F8DENvnUKxVYYqmD1JhslnAKDmTm9u7Ar+rb7LN
         B42zgvE4d25oSJ6PjrBCSEGVvOei7H+etAn5uIoJ8TVPYdzAg1ruOjJsJc8MgIMtMib5
         Ak3w==
X-Gm-Message-State: ACrzQf3U2d85DpEHVf/T7bn6InAesGbk5ZchYbaE3EKA810NAa5i4SVd
        4XEg4dmUtyF4bc7BX0eI3ow=
X-Google-Smtp-Source: AMsMyM44ESie0Af+FF8oMD7Jx2Q/lkH8q0GnnzAIzjCZyjIdcw+ilG0t6T5kfVA+BCSchfXdBKpqsQ==
X-Received: by 2002:a5d:498f:0:b0:236:55e9:6c16 with SMTP id r15-20020a5d498f000000b0023655e96c16mr42158212wrq.331.1668085213895;
        Thu, 10 Nov 2022 05:00:13 -0800 (PST)
Received: from able.fritz.box (p5b0ea229.dip0.t-ipconnect.de. [91.14.162.41])
        by smtp.gmail.com with ESMTPSA id az11-20020a05600c600b00b003b4cba4ef71sm5318965wmb.41.2022.11.10.05.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 05:00:13 -0800 (PST)
From:   "=?UTF-8?q?Christian=20K=C3=B6nig?=" 
        <ckoenig.leichtzumerken@gmail.com>
X-Google-Original-From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
To:     felix.kuehling@amd.com, Philip.Yang@amd.com,
        amd-gfx@lists.freedesktop.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/4] drm/amdgpu: fix userptr HMM range handling
Date:   Thu, 10 Nov 2022 14:00:07 +0100
Message-Id: <20221110130009.1835-2-christian.koenig@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110130009.1835-1-christian.koenig@amd.com>
References: <20221110130009.1835-1-christian.koenig@amd.com>
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

The basic problem here is that it's not allowed to page fault while
holding the reservation lock.

So it can happen that multiple processes try to validate an userptr
at the same time.

Work around that by putting the HMM range object into the mutex
protected bo list for now.

Signed-off-by: Christian König <christian.koenig@amd.com>
CC: stable@vger.kernel.org
---
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 12 +++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c   |  1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h   |  3 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c        |  8 +--
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c       |  6 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c       | 50 +++++--------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h       | 14 ++++--
 7 files changed, 43 insertions(+), 51 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index c5c9bfa2772e..83659e6419a8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -940,6 +940,7 @@ static int init_user_pages(struct kgd_mem *mem, uint64_t user_addr,
 	struct amdkfd_process_info *process_info = mem->process_info;
 	struct amdgpu_bo *bo = mem->bo;
 	struct ttm_operation_ctx ctx = { true, false };
+	struct hmm_range *range;
 	int ret = 0;
 
 	mutex_lock(&process_info->lock);
@@ -969,7 +970,7 @@ static int init_user_pages(struct kgd_mem *mem, uint64_t user_addr,
 		return 0;
 	}
 
-	ret = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages);
+	ret = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages, &range);
 	if (ret) {
 		pr_err("%s: Failed to get user pages: %d\n", __func__, ret);
 		goto unregister_out;
@@ -987,7 +988,7 @@ static int init_user_pages(struct kgd_mem *mem, uint64_t user_addr,
 	amdgpu_bo_unreserve(bo);
 
 release_out:
-	amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm);
+	amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm, range);
 unregister_out:
 	if (ret)
 		amdgpu_mn_unregister(bo);
@@ -2319,6 +2320,8 @@ static int update_invalid_user_pages(struct amdkfd_process_info *process_info,
 	/* Go through userptr_inval_list and update any invalid user_pages */
 	list_for_each_entry(mem, &process_info->userptr_inval_list,
 			    validate_list.head) {
+		struct hmm_range *range;
+
 		invalid = atomic_read(&mem->invalid);
 		if (!invalid)
 			/* BO hasn't been invalidated since the last
@@ -2329,7 +2332,8 @@ static int update_invalid_user_pages(struct amdkfd_process_info *process_info,
 		bo = mem->bo;
 
 		/* Get updated user pages */
-		ret = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages);
+		ret = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages,
+						   &range);
 		if (ret) {
 			pr_debug("Failed %d to get user pages\n", ret);
 
@@ -2348,7 +2352,7 @@ static int update_invalid_user_pages(struct amdkfd_process_info *process_info,
 			 * FIXME: Cannot ignore the return code, must hold
 			 * notifier_lock
 			 */
-			amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm);
+			amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm, range);
 		}
 
 		/* Mark the BO as valid unless it was invalidated
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
index 2168163aad2d..252a876b0725 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
@@ -209,6 +209,7 @@ void amdgpu_bo_list_get_list(struct amdgpu_bo_list *list,
 			list_add_tail(&e->tv.head, &bucket[priority]);
 
 		e->user_pages = NULL;
+		e->range = NULL;
 	}
 
 	/* Connect the sorted buckets in the output list. */
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h
index 9caea1688fc3..e4d78491bcc7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h
@@ -26,6 +26,8 @@
 #include <drm/ttm/ttm_execbuf_util.h>
 #include <drm/amdgpu_drm.h>
 
+struct hmm_range;
+
 struct amdgpu_device;
 struct amdgpu_bo;
 struct amdgpu_bo_va;
@@ -36,6 +38,7 @@ struct amdgpu_bo_list_entry {
 	struct amdgpu_bo_va		*bo_va;
 	uint32_t			priority;
 	struct page			**user_pages;
+	struct hmm_range		*range;
 	bool				user_invalidated;
 };
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index d371000a5727..7f9cedd8e157 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -910,7 +910,7 @@ static int amdgpu_cs_parser_bos(struct amdgpu_cs_parser *p,
 			goto out_free_user_pages;
 		}
 
-		r = amdgpu_ttm_tt_get_user_pages(bo, e->user_pages);
+		r = amdgpu_ttm_tt_get_user_pages(bo, e->user_pages, &e->range);
 		if (r) {
 			kvfree(e->user_pages);
 			e->user_pages = NULL;
@@ -988,9 +988,10 @@ static int amdgpu_cs_parser_bos(struct amdgpu_cs_parser *p,
 
 		if (!e->user_pages)
 			continue;
-		amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm);
+		amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm, e->range);
 		kvfree(e->user_pages);
 		e->user_pages = NULL;
+		e->range = NULL;
 	}
 	mutex_unlock(&p->bo_list->bo_list_mutex);
 	return r;
@@ -1265,7 +1266,8 @@ static int amdgpu_cs_submit(struct amdgpu_cs_parser *p,
 	amdgpu_bo_list_for_each_userptr_entry(e, p->bo_list) {
 		struct amdgpu_bo *bo = ttm_to_amdgpu_bo(e->tv.bo);
 
-		r |= !amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm);
+		r |= !amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm, e->range);
+		e->range = NULL;
 	}
 	if (r) {
 		r = -EAGAIN;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
index 111484ceb47d..91571b1324f2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -378,6 +378,7 @@ int amdgpu_gem_userptr_ioctl(struct drm_device *dev, void *data,
 	struct amdgpu_device *adev = drm_to_adev(dev);
 	struct drm_amdgpu_gem_userptr *args = data;
 	struct drm_gem_object *gobj;
+	struct hmm_range *range;
 	struct amdgpu_bo *bo;
 	uint32_t handle;
 	int r;
@@ -418,7 +419,8 @@ int amdgpu_gem_userptr_ioctl(struct drm_device *dev, void *data,
 		goto release_object;
 
 	if (args->flags & AMDGPU_GEM_USERPTR_VALIDATE) {
-		r = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages);
+		r = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages,
+						 &range);
 		if (r)
 			goto release_object;
 
@@ -441,7 +443,7 @@ int amdgpu_gem_userptr_ioctl(struct drm_device *dev, void *data,
 
 user_pages_done:
 	if (args->flags & AMDGPU_GEM_USERPTR_VALIDATE)
-		amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm);
+		amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm, range);
 
 release_object:
 	drm_gem_object_put(gobj);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 76a8ebfc9e71..a56d28bd23be 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -642,9 +642,6 @@ struct amdgpu_ttm_tt {
 	struct task_struct	*usertask;
 	uint32_t		userflags;
 	bool			bound;
-#if IS_ENABLED(CONFIG_DRM_AMDGPU_USERPTR)
-	struct hmm_range	*range;
-#endif
 };
 
 #define ttm_to_amdgpu_ttm_tt(ptr)	container_of(ptr, struct amdgpu_ttm_tt, ttm)
@@ -657,7 +654,8 @@ struct amdgpu_ttm_tt {
  * Calling function must call amdgpu_ttm_tt_userptr_range_done() once and only
  * once afterwards to stop HMM tracking
  */
-int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages)
+int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages,
+				 struct hmm_range **range)
 {
 	struct ttm_tt *ttm = bo->tbo.ttm;
 	struct amdgpu_ttm_tt *gtt = ttm_to_amdgpu_ttm_tt(ttm);
@@ -673,10 +671,6 @@ int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages)
 		return -EFAULT;
 	}
 
-	/* Another get_user_pages is running at the same time?? */
-	if (WARN_ON(gtt->range))
-		return -EFAULT;
-
 	if (!mmget_not_zero(mm)) /* Happens during process shutdown */
 		return -ESRCH;
 
@@ -694,7 +688,7 @@ int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages)
 
 	readonly = amdgpu_ttm_tt_is_readonly(ttm);
 	r = amdgpu_hmm_range_get_pages(&bo->notifier, mm, pages, start,
-				       ttm->num_pages, &gtt->range, readonly,
+				       ttm->num_pages, range, readonly,
 				       true, NULL);
 out_unlock:
 	mmap_read_unlock(mm);
@@ -712,30 +706,24 @@ int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages)
  *
  * Returns: true if pages are still valid
  */
-bool amdgpu_ttm_tt_get_user_pages_done(struct ttm_tt *ttm)
+bool amdgpu_ttm_tt_get_user_pages_done(struct ttm_tt *ttm,
+				       struct hmm_range *range)
 {
 	struct amdgpu_ttm_tt *gtt = ttm_to_amdgpu_ttm_tt(ttm);
-	bool r = false;
 
-	if (!gtt || !gtt->userptr)
+	if (!gtt || !gtt->userptr || !range)
 		return false;
 
 	DRM_DEBUG_DRIVER("user_pages_done 0x%llx pages 0x%x\n",
 		gtt->userptr, ttm->num_pages);
 
-	WARN_ONCE(!gtt->range || !gtt->range->hmm_pfns,
-		"No user pages to check\n");
+	WARN_ONCE(!range->hmm_pfns, "No user pages to check\n");
 
-	if (gtt->range) {
-		/*
-		 * FIXME: Must always hold notifier_lock for this, and must
-		 * not ignore the return code.
-		 */
-		r = amdgpu_hmm_range_get_pages_done(gtt->range);
-		gtt->range = NULL;
-	}
-
-	return !r;
+	/*
+	 * FIXME: Must always hold notifier_lock for this, and must
+	 * not ignore the return code.
+	 */
+	return !amdgpu_hmm_range_get_pages_done(range);
 }
 #endif
 
@@ -812,20 +800,6 @@ static void amdgpu_ttm_tt_unpin_userptr(struct ttm_device *bdev,
 	/* unmap the pages mapped to the device */
 	dma_unmap_sgtable(adev->dev, ttm->sg, direction, 0);
 	sg_free_table(ttm->sg);
-
-#if IS_ENABLED(CONFIG_DRM_AMDGPU_USERPTR)
-	if (gtt->range) {
-		unsigned long i;
-
-		for (i = 0; i < ttm->num_pages; i++) {
-			if (ttm->pages[i] !=
-			    hmm_pfn_to_page(gtt->range->hmm_pfns[i]))
-				break;
-		}
-
-		WARN((i == ttm->num_pages), "Missing get_user_page_done\n");
-	}
-#endif
 }
 
 static void amdgpu_ttm_gart_bind(struct amdgpu_device *adev,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
index 6a70818039dd..a37207011a69 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
@@ -39,6 +39,8 @@
 
 #define AMDGPU_POISON	0xd0bed0be
 
+struct hmm_range;
+
 struct amdgpu_gtt_mgr {
 	struct ttm_resource_manager manager;
 	struct drm_mm mm;
@@ -149,15 +151,19 @@ void amdgpu_ttm_recover_gart(struct ttm_buffer_object *tbo);
 uint64_t amdgpu_ttm_domain_start(struct amdgpu_device *adev, uint32_t type);
 
 #if IS_ENABLED(CONFIG_DRM_AMDGPU_USERPTR)
-int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages);
-bool amdgpu_ttm_tt_get_user_pages_done(struct ttm_tt *ttm);
+int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages,
+				 struct hmm_range **range);
+bool amdgpu_ttm_tt_get_user_pages_done(struct ttm_tt *ttm,
+				       struct hmm_range *range);
 #else
 static inline int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo,
-					       struct page **pages)
+					       struct page **pages,
+					       struct hmm_range **range)
 {
 	return -EPERM;
 }
-static inline bool amdgpu_ttm_tt_get_user_pages_done(struct ttm_tt *ttm)
+static inline bool amdgpu_ttm_tt_get_user_pages_done(struct ttm_tt *ttm,
+						     struct hmm_range *range)
 {
 	return false;
 }
-- 
2.34.1

