Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A260C51DB2A
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 16:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442476AbiEFO4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 10:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442312AbiEFO4O (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 10:56:14 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907556972C
        for <stable@vger.kernel.org>; Fri,  6 May 2022 07:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651848751; x=1683384751;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ukQ/vL9pJghNRoOJ4H/Yehkdce/pqcWxiOcZ3zgErXM=;
  b=FGT9t6ZyTHwwfBggg5EV6oGcPY0fwMvMrRTGb8+LQkD3pz1EHjfeDBLL
   E7Gs9nP6W5XXeEm0o++dBv/mJ+tdfx+1pOAEf8QKJNW0qC5MqwVzG7xzm
   D5H7LvQ+73kb/kBO+I3pJyVWuDDBbqV3EhHPPEIisHxBn31A7mF/Nu2Qs
   ENPsNkkx5lPN+HVeWbu35Hr00Ngq5VEVS5ksfc+yzqRa2Hwpafm152oW4
   cOqEO+eSi0tifQtMFmw1K1PSYwfLSl4D64/EfPqmsa/WNgAPttCtxly9Q
   /rXy2nqrl5+tjBjqFTLjMqMdGPeToTb5RDFG0VLvzo0M3VvuCKHYvLrJy
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="255970314"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="255970314"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 07:52:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="537920071"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga006.jf.intel.com with ESMTP; 06 May 2022 07:52:21 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 6 May 2022 07:52:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 6 May 2022 07:52:20 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.027;
 Fri, 6 May 2022 07:52:20 -0700
From:   "Bloomfield, Jon" <jon.bloomfield@intel.com>
To:     "Teres Alexis, Alan Previn" <alan.previn.teres.alexis@intel.com>,
        "gfx-internal-devel@eclists.intel.com" 
        <gfx-internal-devel@eclists.intel.com>
CC:     "Harrison, John C" <john.c.harrison@intel.com>,
        Jason Ekstrand <jason@jlekstrand.net>,
        "Slusarz, Marcin" <marcin.slusarz@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jason Ekstrand <jason.ekstrand@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: RE: [PATCH 2/3] Revert "drm/i915: Propagate errors on awaiting
 already signaled fences"
Thread-Topic: [PATCH 2/3] Revert "drm/i915: Propagate errors on awaiting
 already signaled fences"
Thread-Index: AQHYYGGLH30HLwToDEm7ls5Su9AVSq0R70IQ
Date:   Fri, 6 May 2022 14:52:08 +0000
Deferred-Delivery: Fri, 6 May 2022 14:51:18 +0000
Message-ID: <f8e7e2fe6f8e4695a35c70fa271c8c8e@intel.com>
References: <20220505092132.1901800-1-alan.previn.teres.alexis@intel.com>
 <20220505092132.1901800-3-alan.previn.teres.alexis@intel.com>
In-Reply-To: <20220505092132.1901800-3-alan.previn.teres.alexis@intel.com>
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

Acked-by: Jon Bloomfield <jon.bloomfield@intel.com>

> -----Original Message-----
> From: Teres Alexis, Alan Previn <alan.previn.teres.alexis@intel.com>
> Sent: Thursday, May 5, 2022 2:22 AM
> To: gfx-internal-devel@eclists.intel.com
> Cc: Teres Alexis, Alan Previn <alan.previn.teres.alexis@intel.com>; Harri=
son,
> John C <john.c.harrison@intel.com>; Jason Ekstrand
> <jason@jlekstrand.net>; Slusarz, Marcin <marcin.slusarz@intel.com>;
> stable@vger.kernel.org; Jason Ekstrand <jason.ekstrand@intel.com>; Daniel
> Vetter <daniel.vetter@ffwll.ch>; Bloomfield, Jon
> <jon.bloomfield@intel.com>
> Subject: [PATCH 2/3] Revert "drm/i915: Propagate errors on awaiting alrea=
dy
> signaled fences"
>=20
> From: Jason Ekstrand <jason@jlekstrand.net>
>=20
> This reverts commit 9e31c1fe45d555a948ff66f1f0e3fe1f83ca63f7.  Ever
> since that commit, we've been having issues where a hang in one client
> can propagate to another.  In particular, a hang in an app can propagate
> to the X server which causes the whole desktop to lock up.
>=20
> Error propagation along fences sound like a good idea, but as your bug
> shows, surprising consequences, since propagating errors across security
> boundaries is not a good thing.
>=20
> What we do have is track the hangs on the ctx, and report information to
> userspace using RESET_STATS. That's how arb_robustness works. Also, if my
> understanding is still correct, the EIO from execbuf is when your context
> is banned (because not recoverable or too many hangs). And in all these
> cases it's up to userspace to figure out what is all impacted and should
> be reported to the application, that's not on the kernel to guess and
> automatically propagate.
>=20
> What's more, we're also building more features on top of ctx error
> reporting with RESET_STATS ioctl: Encrypted buffers use the same, and the
> userspace fence wait also relies on that mechanism. So it is the path
> going forward for reporting gpu hangs and resets to userspace.
>=20
> So all together that's why I think we should just bury this idea again as
> not quite the direction we want to go to, hence why I think the revert is
> the right option here.
>=20
> For backporters: Please note that you _must_ have a backport of
> https://lore.kernel.org/dri-devel/20210602164149.391653-2-
> jason@jlekstrand.net/
> for otherwise backporting just this patch opens up a security bug.
>=20
> v2: Augment commit message. Also restore Jason's sob that I
> accidentally lost.
>=20
> v3: Add a note for backporters
>=20
> Signed-off-by: Jason Ekstrand <jason@jlekstrand.net>
> Reported-by: Marcin Slusarz <marcin.slusarz@intel.com>
> Cc: <stable@vger.kernel.org> # v5.6+
> Cc: Jason Ekstrand <jason.ekstrand@intel.com>
> Cc: Marcin Slusarz <marcin.slusarz@intel.com>
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3080
> Fixes: 9e31c1fe45d5 ("drm/i915: Propagate errors on awaiting already
> signaled fences")
> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Reviewed-by: Jon Bloomfield <jon.bloomfield@intel.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Link:
> https://patchwork.freedesktop.org/patch/msgid/20210714193419.1459723-
> 3-jason@jlekstrand.net
> (cherry picked from commit 93a2711cddd5760e2f0f901817d71c93183c3b87)
> ---
>  drivers/gpu/drm/i915/i915_request.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/i915_request.c
> b/drivers/gpu/drm/i915/i915_request.c
> index 8bd484e2a0ec..08484c14d11e 100644
> --- a/drivers/gpu/drm/i915/i915_request.c
> +++ b/drivers/gpu/drm/i915/i915_request.c
> @@ -1426,10 +1426,8 @@ i915_request_await_execution(struct
> i915_request *rq,
>=20
>  	do {
>  		fence =3D *child++;
> -		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence-
> >flags)) {
> -			i915_sw_fence_set_error_once(&rq->submit, fence-
> >error);
> +		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence-
> >flags))
>  			continue;
> -		}
>=20
>  		if (fence->context =3D=3D rq->fence.context)
>  			continue;
> @@ -1527,10 +1525,8 @@ i915_request_await_dma_fence(struct
> i915_request *rq, struct dma_fence *fence)
>=20
>  	do {
>  		fence =3D *child++;
> -		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence-
> >flags)) {
> -			i915_sw_fence_set_error_once(&rq->submit, fence-
> >error);
> +		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence-
> >flags))
>  			continue;
> -		}
>=20
>  		/*
>  		 * Requests on the same timeline are explicitly ordered,
> along
