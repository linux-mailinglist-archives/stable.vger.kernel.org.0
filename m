Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 180E49A0D6
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 22:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388205AbfHVUIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 16:08:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40580 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731461AbfHVUIf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 16:08:35 -0400
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9CE61C087353
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 20:08:34 +0000 (UTC)
Received: by mail-qt1-f199.google.com with SMTP id b9so7686077qti.20
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 13:08:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=1HwbjAImq/TuNotWvdcVoa3mGdNn5Egs5qx+SREdsro=;
        b=cGNmYGf/WxC+747S1aSdBHJteGxaHmXrP69++qjtonbuANhMNuQWU57an6DVfhjz9d
         AtRkOemRclWYxmDy4m+YLIxsGeLtku5V+A27hBwigzevrwsIMDdxx/6zO0hfaVEQc1yz
         ULnhJw/qKJKYmq3W8ilszPIlRxCoFgJFJ7zj5w1o3qVrDlaIsFrm1eMNbTaIEEXydRM5
         qRDZWdZO0BvXhpR9D0jNm6Hdg56ptUtCEGpHjfmAVAyeOh+ycImmBbf2ghhVLfYt19YM
         omS2GBfkTGyicVDs/5h6cODeOzsTdc+EgWa2Bg8itoiZHLDcnVr5IvuHv3Q860NfdI2Q
         EDqg==
X-Gm-Message-State: APjAAAVn4vL0RVGq5WQj+N6Ty67ULWlf70lIouURqIIb3FgFHjXNjF18
        UR2/BM+5elzJTW+d+7xdRkWaodzgUMjt93aNg/5U2VsH1Rlm0tnJX97SNpBQIdh8wKw+7aHqkO/
        rjeOQ2ogF9rHHksTA
X-Received: by 2002:a0c:f705:: with SMTP id w5mr1127286qvn.30.1566504513811;
        Thu, 22 Aug 2019 13:08:33 -0700 (PDT)
X-Google-Smtp-Source: APXvYqySAr9fq99xeRHVctr7dbn1oR0ZIEu7ZH+DhlXQ9brutHrwUpQWUX8SjTWCzm4JZgh88CbFEQ==
X-Received: by 2002:a0c:f705:: with SMTP id w5mr1127254qvn.30.1566504513494;
        Thu, 22 Aug 2019 13:08:33 -0700 (PDT)
Received: from dhcp-10-20-1-11.bss.redhat.com ([144.121.20.162])
        by smtp.gmail.com with ESMTPSA id n14sm391037qkk.75.2019.08.22.13.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 13:08:33 -0700 (PDT)
Message-ID: <c90348c9b569bebe2efbf21c53c155756f592988.camel@redhat.com>
Subject: Re: [PATCH] drm/i915: Call dma_set_max_seg_size() in
 i915_ggtt_probe_hw()
From:   Lyude Paul <lyude@redhat.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Date:   Thu, 22 Aug 2019 16:08:32 -0400
In-Reply-To: <20190822200420.23485-1-lyude@redhat.com>
References: <20190822200420.23485-1-lyude@redhat.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

...whoops.

Ignore this patch-Chris Wilson had requested that I send a patch along with
this one to enable CONFIG_DMA_API_DEBUG_SG in CI, but I completely forgot to
do that before sending. Will send out a reroll with that in just a moment

On Thu, 2019-08-22 at 16:04 -0400, Lyude Paul wrote:
> Currently, we don't call dma_set_max_seg_size() for i915 because we
> intentionally do not limit the segment length that the device supports.
> However, this results in a warning being emitted if we try to map
> anything larger than SZ_64K on a kernel with CONFIG_DMA_API_DEBUG_SG
> enabled:
> 
> [    7.751926] DMA-API: i915 0000:00:02.0: mapping sg segment longer
> than device claims to support [len=98304] [max=65536]
> [    7.751934] WARNING: CPU: 5 PID: 474 at kernel/dma/debug.c:1220
> debug_dma_map_sg+0x20f/0x340
> 
> This was originally brought up on
> https://bugs.freedesktop.org/show_bug.cgi?id=108517 , and the consensus
> there was it wasn't really useful to set a limit (and that dma-debug
> isn't really all that useful for i915 in the first place). Unfortunately
> though, CONFIG_DMA_API_DEBUG_SG is enabled in the debug configs for
> various distro kernels. Since a WARN_ON() will disable automatic problem
> reporting (and cause any CI with said option enabled to start
> complaining), we really should just fix the problem.
> 
> Note that as me and Chris Wilson discussed, the other solution for this
> would be to make DMA-API not make such assumptions when a driver hasn't
> explicitly set a maximum segment size. But, taking a look at the commit
> which originally introduced this behavior, commit 78c47830a5cb
> ("dma-debug: check scatterlist segments"), there is an explicit mention
> of this assumption and how it applies to devices with no segment size:
> 
> 	Conversely, devices which are less limited than the rather
> 	conservative defaults, or indeed have no limitations at all
> 	(e.g. GPUs with their own internal MMU), should be encouraged to
> 	set appropriate dma_parms, as they may get more efficient DMA
> 	mapping performance out of it.
> 
> So unless there's any concerns (I'm open to discussion!), let's just
> follow suite and call dma_set_max_seg_size() with UINT_MAX as our limit
> to silence any warnings.
> 
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: <stable@vger.kernel.org> # v4.18+
> ---
>  drivers/gpu/drm/i915/i915_gem_gtt.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/i915_gem_gtt.c
> b/drivers/gpu/drm/i915/i915_gem_gtt.c
> index 0b81e0b64393..a1475039d182 100644
> --- a/drivers/gpu/drm/i915/i915_gem_gtt.c
> +++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
> @@ -3152,6 +3152,11 @@ static int ggtt_probe_hw(struct i915_ggtt *ggtt,
> struct intel_gt *gt)
>  	if (ret)
>  		return ret;
>  
> +	/* We don't have a max segment size, so set it to the max so sg's
> +	 * debugging layer doesn't complain
> +	 */
> +	dma_set_max_seg_size(ggtt->vm.dma, UINT_MAX);
> +
>  	if ((ggtt->vm.total - 1) >> 32) {
>  		DRM_ERROR("We never expected a Global GTT with more than
> 32bits"
>  			  " of address space! Found %lldM!\n",
-- 
Cheers,
	Lyude Paul

