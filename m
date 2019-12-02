Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 803DF10E8D7
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfLBKa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:30:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:10411 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727567AbfLBKa2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Dec 2019 05:30:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Dec 2019 02:30:28 -0800
X-IronPort-AV: E=Sophos;i="5.69,268,1571727600"; 
   d="scan'208";a="204505581"
Received: from jnikula-mobl3.fi.intel.com (HELO localhost) ([10.237.66.161])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Dec 2019 02:30:25 -0800
From:   Jani Nikula <jani.nikula@intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Martin Peres <martin.peres@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Update bug URL to point at gitlab issues
In-Reply-To: <20191125104248.1690891-1-chris@chris-wilson.co.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20191125104248.1690891-1-chris@chris-wilson.co.uk>
Date:   Mon, 02 Dec 2019 12:30:22 +0200
Message-ID: <878snvkojl.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 25 Nov 2019, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> We are moving our issue tracking over from bugs.fd.o to gitlab.fd.o, so
> update the user instructions accordingly.
>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Martin Peres <martin.peres@linux.intel.com>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Cc: Jani Nikula <jani.nikula@intel.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/i915/i915_gpu_error.c | 2 +-
>  drivers/gpu/drm/i915/i915_utils.c     | 3 +--
>  drivers/gpu/drm/i915/i915_utils.h     | 2 ++
>  3 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_gpu_error.c b/drivers/gpu/drm/i915/i915_gpu_error.c
> index 2b30a45fa25c..1cf53fd4fe66 100644
> --- a/drivers/gpu/drm/i915/i915_gpu_error.c
> +++ b/drivers/gpu/drm/i915/i915_gpu_error.c
> @@ -1817,7 +1817,7 @@ void i915_capture_error_state(struct drm_i915_private *i915,
>  	if (!xchg(&warned, true) &&
>  	    ktime_get_real_seconds() - DRIVER_TIMESTAMP < DAY_AS_SECONDS(180)) {
>  		pr_info("GPU hangs can indicate a bug anywhere in the entire gfx stack, including userspace.\n");
> -		pr_info("Please file a _new_ bug report on bugs.freedesktop.org against DRI -> DRM/Intel\n");
> +		pr_info("Please file a _new_ bug report on " FDO_BUG_URL "\n");
>  		pr_info("drm/i915 developers can then reassign to the right component if it's not a kernel issue.\n");
>  		pr_info("The GPU crash dump is required to analyze GPU hangs, so please always attach it.\n");
>  		pr_info("GPU crash dump saved to /sys/class/drm/card%d/error\n",
> diff --git a/drivers/gpu/drm/i915/i915_utils.c b/drivers/gpu/drm/i915/i915_utils.c
> index c47261ae86ea..9b68b21becf1 100644
> --- a/drivers/gpu/drm/i915/i915_utils.c
> +++ b/drivers/gpu/drm/i915/i915_utils.c
> @@ -8,8 +8,7 @@
>  #include "i915_drv.h"
>  #include "i915_utils.h"
>  
> -#define FDO_BUG_URL "https://bugs.freedesktop.org/enter_bug.cgi?product=DRI"
> -#define FDO_BUG_MSG "Please file a bug at " FDO_BUG_URL " against DRM/Intel " \
> +#define FDO_BUG_MSG "Please file a bug at " FDO_BUG_URL \
>  		    "providing the dmesg log by booting with drm.debug=0xf"

Space between URL and "providing"?

>  
>  void
> diff --git a/drivers/gpu/drm/i915/i915_utils.h b/drivers/gpu/drm/i915/i915_utils.h
> index 04139ba1191e..13674b016092 100644
> --- a/drivers/gpu/drm/i915/i915_utils.h
> +++ b/drivers/gpu/drm/i915/i915_utils.h
> @@ -34,6 +34,8 @@
>  struct drm_i915_private;
>  struct timer_list;
>  
> +#define FDO_BUG_URL "https://gitlab.freedesktop.org/drm/intel/issues/new?"

Do we really need the question mark?

BR,
Jani.

> +
>  #undef WARN_ON
>  /* Many gcc seem to no see through this and fall over :( */
>  #if 0

-- 
Jani Nikula, Intel Open Source Graphics Center
