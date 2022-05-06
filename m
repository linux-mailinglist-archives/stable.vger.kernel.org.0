Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A701951DB1E
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 16:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441832AbiEFOzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 10:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351730AbiEFOzP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 10:55:15 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC2E6AA64
        for <stable@vger.kernel.org>; Fri,  6 May 2022 07:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651848690; x=1683384690;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hWwuZjBSX/ZoyFqbXll/JerVFhPiqFOpwebjdahJrUM=;
  b=caqhiay87iMReZRFLvpF62yv/nLX/6N5LLSA9cCUiGTWDPk01+dexwJ7
   +7JQa/vt3IK8whwNnszOCmvjeac3Dw/u8f6gDnZ3IWLaZejfLRu3hABT/
   yZrXCLtQi+gU1XomGfAGMtWsTKQEH6JoQqSr8NXUDr/55EwnxpYjB8VTq
   7CwM9qBupmr+Q4kcN/s0T3vRPI49V3NE7mZZrrSVjEcoRpkRBwq4wRe5L
   cKbdcewHgWJG34y/6HdbTeIW30/3o4Z+BYbN6HWj3bw22ciCm8QYE7WhB
   SxW0nBU+om56IyWiU/E7aSJWoW+sZ+TxmAb9mtmzbjADa4SNwNMxaUjUf
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="268089774"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="268089774"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 07:51:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="621854316"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga008.fm.intel.com with ESMTP; 06 May 2022 07:51:21 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 6 May 2022 07:51:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 6 May 2022 07:51:20 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.027;
 Fri, 6 May 2022 07:51:20 -0700
From:   "Bloomfield, Jon" <jon.bloomfield@intel.com>
To:     "Teres Alexis, Alan Previn" <alan.previn.teres.alexis@intel.com>,
        "gfx-internal-devel@eclists.intel.com" 
        <gfx-internal-devel@eclists.intel.com>
CC:     "Harrison, John C" <john.c.harrison@intel.com>,
        Jason Ekstrand <jason@jlekstrand.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: RE: [PATCH 1/3] drm/i915: Revert "drm/i915/gem: Asynchronous
 cmdparser"
Thread-Topic: [PATCH 1/3] drm/i915: Revert "drm/i915/gem: Asynchronous
 cmdparser"
Thread-Index: AQHYYGGLfR215WufgEKRN5InihUH060R7t7A
Date:   Fri, 6 May 2022 14:51:07 +0000
Deferred-Delivery: Fri, 6 May 2022 14:50:07 +0000
Message-ID: <73ae908279714c3aab056a8e5f1ed435@intel.com>
References: <20220505092132.1901800-1-alan.previn.teres.alexis@intel.com>
 <20220505092132.1901800-2-alan.previn.teres.alexis@intel.com>
In-Reply-To: <20220505092132.1901800-2-alan.previn.teres.alexis@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.401.20
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Acked-by: Jon Bloomfield  <jon.bloomfield@intel.com>

> -----Original Message-----
> From: Teres Alexis, Alan Previn <alan.previn.teres.alexis@intel.com>
> Sent: Thursday, May 5, 2022 2:22 AM
> To: gfx-internal-devel@eclists.intel.com
> Cc: Teres Alexis, Alan Previn <alan.previn.teres.alexis@intel.com>; Harri=
son,
> John C <john.c.harrison@intel.com>; Jason Ekstrand
> <jason@jlekstrand.net>; stable@vger.kernel.org; Maarten Lankhorst
> <maarten.lankhorst@linux.intel.com>; Bloomfield, Jon
> <jon.bloomfield@intel.com>; Daniel Vetter <daniel.vetter@ffwll.ch>
> Subject: [PATCH 1/3] drm/i915: Revert "drm/i915/gem: Asynchronous
> cmdparser"
>=20
> From: Jason Ekstrand <jason@jlekstrand.net>
>=20
> This reverts 686c7c35abc2 ("drm/i915/gem: Asynchronous cmdparser").  The
> justification for this commit in the git history was a vague comment
> about getting it out from under the struct_mutex.  While this may
> improve perf for some workloads on Gen7 platforms where we rely on the
> command parser for features such as indirect rendering, no numbers were
> provided to prove such an improvement.  It claims to closed two
> gitlab/bugzilla issues but with no explanation whatsoever as to why or
> what bug it's fixing.
>=20
> Meanwhile, by moving command parsing off to an async callback, it leaves
> us with a problem of what to do on error.  When things were synchronous,
> EXECBUFFER2 would fail with an error code if parsing failed.  When
> moving it to async, we needed another way to handle that error and the
> solution employed was to set an error on the dma_fence and then trust
> that said error gets propagated to the client eventually.  Moving back
> to synchronous will help us untangle the fence error propagation mess.
>=20
> This also reverts most of 0edbb9ba1bfe ("drm/i915: Move cmd parser
> pinning to execbuffer") which is a refactor of some of our allocation
> paths for asynchronous parsing.  Now that everything is synchronous, we
> don't need it.
>=20
> v2 (Daniel Vetter):
>  - Add stabel Cc and Fixes tag
>=20
> Signed-off-by: Jason Ekstrand <jason@jlekstrand.net>
> Cc: <stable@vger.kernel.org> # v5.6+
> Fixes: 9e31c1fe45d5 ("drm/i915: Propagate errors on awaiting already
> signaled fences")
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Reviewed-by: Jon Bloomfield <jon.bloomfield@intel.com>
> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Link:
> https://patchwork.freedesktop.org/patch/msgid/20210714193419.1459723-
> 2-jason@jlekstrand.net
> (cherry picked from commit 93b713304188844b8514074dc13ffd56d12235d3)
> ---
>  .../gpu/drm/i915/gem/i915_gem_execbuffer.c    | 227 +-----------------
>  .../i915/gem/selftests/i915_gem_execbuffer.c  |   4 +
>  drivers/gpu/drm/i915/i915_cmd_parser.c        | 118 +++++----
>  drivers/gpu/drm/i915/i915_drv.h               |   7 +-
>  4 files changed, 91 insertions(+), 265 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> index d218717e6253..305c320f9a83 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> @@ -25,8 +25,6 @@
>  #include "i915_gem_clflush.h"
>  #include "i915_gem_context.h"
>  #include "i915_gem_ioctls.h"
> -#include "i915_memcpy.h"
> -#include "i915_sw_fence_work.h"
>  #include "i915_trace.h"
>  #include "i915_user_extensions.h"
>=20
> @@ -1456,6 +1454,10 @@ static u32 *reloc_gpu(struct i915_execbuffer *eb,
>  		int err;
>  		struct intel_engine_cs *engine =3D eb->engine;
>=20
> +		/* If we need to copy for the cmdparser, we will stall anyway
> */
> +		if (eb_use_cmdparser(eb))
> +			return ERR_PTR(-EWOULDBLOCK);
> +
>  		if (!reloc_can_use_engine(engine)) {
>  			engine =3D engine->gt-
> >engine_class[COPY_ENGINE_CLASS][0];
>  			if (!engine)
> @@ -2372,217 +2374,6 @@ shadow_batch_pin(struct i915_execbuffer *eb,
>  	return vma;
>  }
>=20
> -struct eb_parse_work {
> -	struct dma_fence_work base;
> -	struct intel_engine_cs *engine;
> -	struct i915_vma *batch;
> -	struct i915_vma *shadow;
> -	struct i915_vma *trampoline;
> -	unsigned long batch_offset;
> -	unsigned long batch_length;
> -	unsigned long *jump_whitelist;
> -	const void *batch_map;
> -	void *shadow_map;
> -};
> -
> -static int __eb_parse(struct dma_fence_work *work)
> -{
> -	struct eb_parse_work *pw =3D container_of(work, typeof(*pw),
> base);
> -	int ret;
> -	bool cookie;
> -
> -	cookie =3D dma_fence_begin_signalling();
> -	ret =3D intel_engine_cmd_parser(pw->engine,
> -				      pw->batch,
> -				      pw->batch_offset,
> -				      pw->batch_length,
> -				      pw->shadow,
> -				      pw->jump_whitelist,
> -				      pw->shadow_map,
> -				      pw->batch_map);
> -	dma_fence_end_signalling(cookie);
> -
> -	return ret;
> -}
> -
> -static void __eb_parse_release(struct dma_fence_work *work)
> -{
> -	struct eb_parse_work *pw =3D container_of(work, typeof(*pw),
> base);
> -
> -	if (!IS_ERR_OR_NULL(pw->jump_whitelist))
> -		kfree(pw->jump_whitelist);
> -
> -	if (pw->batch_map)
> -		i915_gem_object_unpin_map(pw->batch->obj);
> -	else
> -		i915_gem_object_unpin_pages(pw->batch->obj);
> -
> -	i915_gem_object_unpin_map(pw->shadow->obj);
> -
> -	if (pw->trampoline)
> -		i915_active_release(&pw->trampoline->active);
> -	i915_active_release(&pw->shadow->active);
> -	i915_active_release(&pw->batch->active);
> -}
> -
> -static const struct dma_fence_work_ops eb_parse_ops =3D {
> -	.name =3D "eb_parse",
> -	.work =3D __eb_parse,
> -	.release =3D __eb_parse_release,
> -};
> -
> -static inline int
> -__parser_mark_active(struct i915_vma *vma,
> -		     struct intel_timeline *tl,
> -		     struct dma_fence *fence)
> -{
> -	struct intel_gt_buffer_pool_node *node =3D vma->private;
> -
> -	return i915_active_ref(&node->active, tl->fence_context, fence);
> -}
> -
> -static int
> -parser_mark_active(struct eb_parse_work *pw, struct intel_timeline *tl)
> -{
> -	int err;
> -
> -	mutex_lock(&tl->mutex);
> -
> -	err =3D __parser_mark_active(pw->shadow, tl, &pw->base.dma);
> -	if (err)
> -		goto unlock;
> -
> -	if (pw->trampoline) {
> -		err =3D __parser_mark_active(pw->trampoline, tl, &pw-
> >base.dma);
> -		if (err)
> -			goto unlock;
> -	}
> -
> -unlock:
> -	mutex_unlock(&tl->mutex);
> -	return err;
> -}
> -
> -static int eb_parse_pipeline(struct i915_execbuffer *eb,
> -			     struct i915_vma *shadow,
> -			     struct i915_vma *trampoline)
> -{
> -	struct eb_parse_work *pw;
> -	struct drm_i915_gem_object *batch =3D eb->batch->vma->obj;
> -	bool needs_clflush;
> -	int err;
> -
> -	GEM_BUG_ON(overflows_type(eb->batch_start_offset, pw-
> >batch_offset));
> -	GEM_BUG_ON(overflows_type(eb->batch_len, pw-
> >batch_length));
> -
> -	pw =3D kzalloc(sizeof(*pw), GFP_KERNEL);
> -	if (!pw)
> -		return -ENOMEM;
> -
> -	err =3D i915_active_acquire(&eb->batch->vma->active);
> -	if (err)
> -		goto err_free;
> -
> -	err =3D i915_active_acquire(&shadow->active);
> -	if (err)
> -		goto err_batch;
> -
> -	if (trampoline) {
> -		err =3D i915_active_acquire(&trampoline->active);
> -		if (err)
> -			goto err_shadow;
> -	}
> -
> -	pw->shadow_map =3D i915_gem_object_pin_map(shadow->obj,
> I915_MAP_WB);
> -	if (IS_ERR(pw->shadow_map)) {
> -		err =3D PTR_ERR(pw->shadow_map);
> -		goto err_trampoline;
> -	}
> -
> -	needs_clflush =3D
> -		!(batch->cache_coherent &
> I915_BO_CACHE_COHERENT_FOR_READ);
> -
> -	pw->batch_map =3D ERR_PTR(-ENODEV);
> -	if (needs_clflush && i915_has_memcpy_from_wc())
> -		pw->batch_map =3D i915_gem_object_pin_map(batch,
> I915_MAP_WC);
> -
> -	if (IS_ERR(pw->batch_map)) {
> -		err =3D i915_gem_object_pin_pages(batch);
> -		if (err)
> -			goto err_unmap_shadow;
> -		pw->batch_map =3D NULL;
> -	}
> -
> -	pw->jump_whitelist =3D
> -		intel_engine_cmd_parser_alloc_jump_whitelist(eb-
> >batch_len,
> -							     trampoline);
> -	if (IS_ERR(pw->jump_whitelist)) {
> -		err =3D PTR_ERR(pw->jump_whitelist);
> -		goto err_unmap_batch;
> -	}
> -
> -	dma_fence_work_init(&pw->base, &eb_parse_ops);
> -
> -	pw->engine =3D eb->engine;
> -	pw->batch =3D eb->batch->vma;
> -	pw->batch_offset =3D eb->batch_start_offset;
> -	pw->batch_length =3D eb->batch_len;
> -	pw->shadow =3D shadow;
> -	pw->trampoline =3D trampoline;
> -
> -	/* Mark active refs early for this worker, in case we get interrupted
> */
> -	err =3D parser_mark_active(pw, eb->context->timeline);
> -	if (err)
> -		goto err_commit;
> -
> -	err =3D dma_resv_reserve_shared(pw->batch->resv, 1);
> -	if (err)
> -		goto err_commit;
> -
> -	err =3D dma_resv_reserve_shared(shadow->resv, 1);
> -	if (err)
> -		goto err_commit;
> -
> -	/* Wait for all writes (and relocs) into the batch to complete */
> -	err =3D i915_sw_fence_await_reservation(&pw->base.chain,
> -					      pw->batch->resv, NULL, false,
> -					      0, I915_FENCE_GFP);
> -	if (err < 0)
> -		goto err_commit;
> -
> -	/* Keep the batch alive and unwritten as we parse */
> -	dma_resv_add_shared_fence(pw->batch->resv, &pw->base.dma);
> -
> -	/* Force execution to wait for completion of the parser */
> -	dma_resv_add_excl_fence(shadow->resv, &pw->base.dma);
> -
> -	dma_fence_work_commit_imm(&pw->base);
> -	return 0;
> -
> -err_commit:
> -	i915_sw_fence_set_error_once(&pw->base.chain, err);
> -	dma_fence_work_commit_imm(&pw->base);
> -	return err;
> -
> -err_unmap_batch:
> -	if (pw->batch_map)
> -		i915_gem_object_unpin_map(batch);
> -	else
> -		i915_gem_object_unpin_pages(batch);
> -err_unmap_shadow:
> -	i915_gem_object_unpin_map(shadow->obj);
> -err_trampoline:
> -	if (trampoline)
> -		i915_active_release(&trampoline->active);
> -err_shadow:
> -	i915_active_release(&shadow->active);
> -err_batch:
> -	i915_active_release(&eb->batch->vma->active);
> -err_free:
> -	kfree(pw);
> -	return err;
> -}
> -
>  static struct i915_vma *eb_dispatch_secure(struct i915_execbuffer *eb,
> struct i915_vma *vma)
>  {
>  	/*
> @@ -2672,7 +2463,15 @@ static int eb_parse(struct i915_execbuffer *eb)
>  		goto err_trampoline;
>  	}
>=20
> -	err =3D eb_parse_pipeline(eb, shadow, trampoline);
> +	err =3D dma_resv_reserve_shared(shadow->resv, 1);
> +	if (err)
> +		goto err_trampoline;
> +
> +	err =3D intel_engine_cmd_parser(eb->engine,
> +				      eb->batch->vma,
> +				      eb->batch_start_offset,
> +				      eb->batch_len,
> +				      shadow, trampoline);
>  	if (err)
>  		goto err_unpin_batch;
>=20
> diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_execbuffer.c
> b/drivers/gpu/drm/i915/gem/selftests/i915_gem_execbuffer.c
> index 4df505e4c53a..16162fc2782d 100644
> --- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_execbuffer.c
> +++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_execbuffer.c
> @@ -125,6 +125,10 @@ static int igt_gpu_reloc(void *arg)
>  	intel_gt_pm_get(&eb.i915->gt);
>=20
>  	for_each_uabi_engine(eb.engine, eb.i915) {
> +		if (intel_engine_requires_cmd_parser(eb.engine) ||
> +		    intel_engine_using_cmd_parser(eb.engine))
> +			continue;
> +
>  		reloc_cache_init(&eb.reloc_cache, eb.i915);
>  		memset(map, POISON_INUSE, 4096);
>=20
> diff --git a/drivers/gpu/drm/i915/i915_cmd_parser.c
> b/drivers/gpu/drm/i915/i915_cmd_parser.c
> index e6f1e93abbbb..ce61ea4506ea 100644
> --- a/drivers/gpu/drm/i915/i915_cmd_parser.c
> +++ b/drivers/gpu/drm/i915/i915_cmd_parser.c
> @@ -1145,19 +1145,41 @@ find_reg(const struct intel_engine_cs *engine,
> u32 addr)
>  static u32 *copy_batch(struct drm_i915_gem_object *dst_obj,
>  		       struct drm_i915_gem_object *src_obj,
>  		       unsigned long offset, unsigned long length,
> -		       void *dst, const void *src)
> +		       bool *needs_clflush_after)
>  {
> -	bool needs_clflush =3D
> -		!(src_obj->cache_coherent &
> I915_BO_CACHE_COHERENT_FOR_READ);
> -
> -	if (src) {
> -		GEM_BUG_ON(!needs_clflush);
> -		i915_unaligned_memcpy_from_wc(dst, src + offset, length);
> -	} else {
> -		struct scatterlist *sg;
> +	unsigned int src_needs_clflush;
> +	unsigned int dst_needs_clflush;
> +	void *dst, *src;
> +	int ret;
> +
> +	ret =3D i915_gem_object_prepare_write(dst_obj,
> &dst_needs_clflush);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	dst =3D i915_gem_object_pin_map(dst_obj, I915_MAP_WB);
> +	i915_gem_object_finish_access(dst_obj);
> +	if (IS_ERR(dst))
> +		return dst;
> +
> +	ret =3D i915_gem_object_prepare_read(src_obj, &src_needs_clflush);
> +	if (ret) {
> +		i915_gem_object_unpin_map(dst_obj);
> +		return ERR_PTR(ret);
> +	}
> +
> +	src =3D ERR_PTR(-ENODEV);
> +	if (src_needs_clflush && i915_has_memcpy_from_wc()) {
> +		src =3D i915_gem_object_pin_map(src_obj, I915_MAP_WC);
> +		if (!IS_ERR(src)) {
> +			i915_unaligned_memcpy_from_wc(dst,
> +						      src + offset,
> +						      length);
> +			i915_gem_object_unpin_map(src_obj);
> +		}
> +	}
> +	if (IS_ERR(src)) {
> +		unsigned long x, n, remain;
>  		void *ptr;
> -		unsigned int x, sg_ofs;
> -		unsigned long remain;
>=20
>  		/*
>  		 * We can avoid clflushing partial cachelines before the write
> @@ -1168,40 +1190,34 @@ static u32 *copy_batch(struct
> drm_i915_gem_object *dst_obj,
>  		 * validate up to the end of the batch.
>  		 */
>  		remain =3D length;
> -		if (!(dst_obj->cache_coherent &
> I915_BO_CACHE_COHERENT_FOR_READ))
> +		if (dst_needs_clflush & CLFLUSH_BEFORE)
>  			remain =3D round_up(remain,
>  					  boot_cpu_data.x86_clflush_size);
>=20
>  		ptr =3D dst;
>  		x =3D offset_in_page(offset);
> -		sg =3D i915_gem_object_get_sg(src_obj, offset >>
> PAGE_SHIFT, &sg_ofs, false);
> -
> -		while (remain) {
> -			unsigned long sg_max =3D sg->length >> PAGE_SHIFT;
> -
> -			for (; remain && sg_ofs < sg_max; sg_ofs++) {
> -				unsigned long len =3D min(remain, PAGE_SIZE -
> x);
> -				void *map;
> -
> -				map =3D kmap_atomic(nth_page(sg_page(sg),
> sg_ofs));
> -				if (needs_clflush)
> -					drm_clflush_virt_range(map + x,
> len);
> -				memcpy(ptr, map + x, len);
> -				kunmap_atomic(map);
> -
> -				ptr +=3D len;
> -				remain -=3D len;
> -				x =3D 0;
> -			}
> -
> -			sg_ofs =3D 0;
> -			sg =3D sg_next(sg);
> +		for (n =3D offset >> PAGE_SHIFT; remain; n++) {
> +			int len =3D min(remain, PAGE_SIZE - x);
> +
> +			src =3D
> kmap_atomic(i915_gem_object_get_page(src_obj, n));
> +			if (src_needs_clflush)
> +				drm_clflush_virt_range(src + x, len);
> +			memcpy(ptr, src + x, len);
> +			kunmap_atomic(src);
> +
> +			ptr +=3D len;
> +			remain -=3D len;
> +			x =3D 0;
>  		}
>  	}
>=20
> +	i915_gem_object_finish_access(src_obj);
> +
>  	memset32(dst + length, 0, (dst_obj->base.size - length) /
> sizeof(u32));
>=20
>  	/* dst_obj is returned with vmap pinned */
> +	*needs_clflush_after =3D dst_needs_clflush & CLFLUSH_AFTER;
> +
>  	return dst;
>  }
>=20
> @@ -1360,6 +1376,9 @@ static int check_bbstart(u32 *cmd, u32 offset, u32
> length,
>  	if (target_cmd_index =3D=3D offset)
>  		return 0;
>=20
> +	if (IS_ERR(jump_whitelist))
> +		return PTR_ERR(jump_whitelist);
> +
>  	if (!test_bit(target_cmd_index, jump_whitelist)) {
>  		DRM_DEBUG("CMD: BB_START to 0x%llx not a previously
> executed cmd\n",
>  			  jump_target);
> @@ -1369,14 +1388,10 @@ static int check_bbstart(u32 *cmd, u32 offset,
> u32 length,
>  	return 0;
>  }
>=20
> -unsigned long *intel_engine_cmd_parser_alloc_jump_whitelist(u32
> batch_length,
> -							    bool trampoline)
> +static unsigned long *alloc_whitelist(u32 batch_length)
>  {
>  	unsigned long *jmp;
>=20
> -	if (trampoline)
> -		return NULL;
> -
>  	/*
>  	 * We expect batch_length to be less than 256KiB for known users,
>  	 * i.e. we need at most an 8KiB bitmap allocation which should be
> @@ -1409,21 +1424,21 @@ unsigned long
> *intel_engine_cmd_parser_alloc_jump_whitelist(u32 batch_length,
>   * Return: non-zero if the parser finds violations or otherwise fails; -=
EACCES
>   * if the batch appears legal but should use hardware parsing
>   */
> +
>  int intel_engine_cmd_parser(struct intel_engine_cs *engine,
>  			    struct i915_vma *batch,
>  			    unsigned long batch_offset,
>  			    unsigned long batch_length,
>  			    struct i915_vma *shadow,
> -			    unsigned long *jump_whitelist,
> -			    void *shadow_map,
> -			    const void *batch_map)
> +			    bool trampoline)
>  {
>  	u32 *cmd, *batch_end, offset =3D 0;
>  	struct drm_i915_cmd_descriptor default_desc =3D noop_desc;
>  	const struct drm_i915_cmd_descriptor *desc =3D &default_desc;
> +	bool needs_clflush_after =3D false;
> +	unsigned long *jump_whitelist;
>  	u64 batch_addr, shadow_addr;
>  	int ret =3D 0;
> -	bool trampoline =3D !jump_whitelist;
>=20
>  	GEM_BUG_ON(!IS_ALIGNED(batch_offset, sizeof(*cmd)));
>  	GEM_BUG_ON(!IS_ALIGNED(batch_length, sizeof(*cmd)));
> @@ -1431,8 +1446,18 @@ int intel_engine_cmd_parser(struct
> intel_engine_cs *engine,
>  				     batch->size));
>  	GEM_BUG_ON(!batch_length);
>=20
> -	cmd =3D copy_batch(shadow->obj, batch->obj, batch_offset,
> batch_length,
> -			 shadow_map, batch_map);
> +	cmd =3D copy_batch(shadow->obj, batch->obj,
> +			 batch_offset, batch_length,
> +			 &needs_clflush_after);
> +	if (IS_ERR(cmd)) {
> +		DRM_DEBUG("CMD: Failed to copy batch\n");
> +		return PTR_ERR(cmd);
> +	}
> +
> +	jump_whitelist =3D NULL;
> +	if (!trampoline)
> +		/* Defer failure until attempted use */
> +		jump_whitelist =3D alloc_whitelist(batch_length);
>=20
>  	shadow_addr =3D gen8_canonical_addr(shadow->node.start);
>  	batch_addr =3D gen8_canonical_addr(batch->node.start +
> batch_offset);
> @@ -1533,6 +1558,9 @@ int intel_engine_cmd_parser(struct
> intel_engine_cs *engine,
>=20
>  	i915_gem_object_flush_map(shadow->obj);
>=20
> +	if (!IS_ERR_OR_NULL(jump_whitelist))
> +		kfree(jump_whitelist);
> +	i915_gem_object_unpin_map(shadow->obj);
>  	return ret;
>  }
>=20
> diff --git a/drivers/gpu/drm/i915/i915_drv.h
> b/drivers/gpu/drm/i915/i915_drv.h
> index 88d1ea48b2b2..b4354d916876 100644
> --- a/drivers/gpu/drm/i915/i915_drv.h
> +++ b/drivers/gpu/drm/i915/i915_drv.h
> @@ -1939,17 +1939,12 @@ const char *i915_cache_level_str(struct
> drm_i915_private *i915, int type);
>  int i915_cmd_parser_get_version(struct drm_i915_private *dev_priv);
>  int intel_engine_init_cmd_parser(struct intel_engine_cs *engine);
>  void intel_engine_cleanup_cmd_parser(struct intel_engine_cs *engine);
> -unsigned long *intel_engine_cmd_parser_alloc_jump_whitelist(u32
> batch_length,
> -							    bool trampoline);
> -
>  int intel_engine_cmd_parser(struct intel_engine_cs *engine,
>  			    struct i915_vma *batch,
>  			    unsigned long batch_offset,
>  			    unsigned long batch_length,
>  			    struct i915_vma *shadow,
> -			    unsigned long *jump_whitelist,
> -			    void *shadow_map,
> -			    const void *batch_map);
> +			    bool trampoline);
>  #define I915_CMD_PARSER_TRAMPOLINE_SIZE 8
>=20
>  /* intel_device_info.c */
