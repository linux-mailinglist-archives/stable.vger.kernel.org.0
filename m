Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B6A2E723E
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 17:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgL2QUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Dec 2020 11:20:37 -0500
Received: from mga17.intel.com ([192.55.52.151]:31243 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgL2QUh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Dec 2020 11:20:37 -0500
IronPort-SDR: kFMObO64BUSoFD6zV7v8huG1Ac4OYlzA06lJESOookyBtup8iHWDdETiUkvcBkqlEjOBmE9MMv
 8kCcHQC0eExg==
X-IronPort-AV: E=McAfee;i="6000,8403,9849"; a="156296242"
X-IronPort-AV: E=Sophos;i="5.78,458,1599548400"; 
   d="scan'208";a="156296242"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2020 08:18:52 -0800
IronPort-SDR: Qf3WpQ1yXqG+UCLjOO5TZFekEo3PcN7vFYDQejY8JEAFpy720rH3E/xGez2z9IiD1ieUdI3AAg
 uyAyFQJpWKPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,458,1599548400"; 
   d="scan'208";a="567774530"
Received: from gaia.fi.intel.com ([10.237.72.192])
  by fmsmga005.fm.intel.com with ESMTP; 29 Dec 2020 08:18:51 -0800
Received: by gaia.fi.intel.com (Postfix, from userid 1000)
        id 93AC25C20E4; Tue, 29 Dec 2020 18:16:20 +0200 (EET)
From:   Mika Kuoppala <mika.kuoppala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Define guc firmware blob for older Cometlakes
In-Reply-To: <20201229120828.29931-1-chris@chris-wilson.co.uk>
References: <20201229120828.29931-1-chris@chris-wilson.co.uk>
Date:   Tue, 29 Dec 2020 18:16:20 +0200
Message-ID: <871rf8mvu3.fsf@gaia.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Chris Wilson <chris@chris-wilson.co.uk> writes:

> When splitting the Coffeelake define to also identify Cometlakes, I
> missed the double fw_def for Coffeelake. That is only newer Cometlakes
> use the cml specific guc firmware, older Cometlakes should use kbl
> firmware.
>
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2859
> Fixes: 5f4ae2704d59 ("drm/i915: Identify Cometlake platform")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: <stable@vger.kernel.org> # v5.9+

Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>

> ---
>  drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
> index 180c23e2e25e..602f1a0bc587 100644
> --- a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
> +++ b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
> @@ -53,6 +53,7 @@ void intel_uc_fw_change_status(struct intel_uc_fw *uc_fw,
>  	fw_def(ELKHARTLAKE, 0, guc_def(ehl, 49, 0, 1), huc_def(ehl,  9, 0, 0)) \
>  	fw_def(ICELAKE,     0, guc_def(icl, 49, 0, 1), huc_def(icl,  9, 0, 0)) \
>  	fw_def(COMETLAKE,   5, guc_def(cml, 49, 0, 1), huc_def(cml,  4, 0, 0)) \
> +	fw_def(COMETLAKE,   0, guc_def(kbl, 49, 0, 1), huc_def(kbl,  4, 0, 0)) \
>  	fw_def(COFFEELAKE,  0, guc_def(kbl, 49, 0, 1), huc_def(kbl,  4, 0, 0)) \
>  	fw_def(GEMINILAKE,  0, guc_def(glk, 49, 0, 1), huc_def(glk,  4, 0, 0)) \
>  	fw_def(KABYLAKE,    0, guc_def(kbl, 49, 0, 1), huc_def(kbl,  4, 0, 0)) \
> -- 
> 2.20.1
>
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx
