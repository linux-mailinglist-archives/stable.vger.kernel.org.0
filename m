Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C837E5A0F22
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 13:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbiHYLdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 07:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235429AbiHYLdU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 07:33:20 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843D0ADCD4
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 04:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661427199; x=1692963199;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=b7csjJ66m9R1nYCYuZ8qDs+sOFrF9Bp0aHUcdF5vRq8=;
  b=j4czR3KJReSjh27CBQKkvFDhS0c5puzlGoZcXCmUhlGJstF/SuJTWjLh
   FJJJ5nRI4vsoWo2SNL79aTaWeT5THyyaHE1p7PCEgMnadFWnY0tVdvEl2
   XI+SuJ6QvJ4tMIVyhdi24PiR40hV6SRDf82vjl1dkyNE0+fzcdRyoJ476
   xl+oj2/1cLB5tJ3dX2T/h7n923S0aTLj+JSZ75pwGkt/RhZ+VVuuQTQvx
   D68tNRepO1pY/Rrofz3FP1JKzRV7JliCj0ZDTDi2+3jY1PsCDSA5wFCYK
   x7/5I8s19uzfBONer2oX51jxonfNYOwvD4buhUNApkLFzRM07YnxlZgDY
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="281185487"
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="281185487"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 04:33:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="610132871"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.59])
  by orsmga002.jf.intel.com with SMTP; 25 Aug 2022 04:33:16 -0700
Received: by stinkbox (sSMTP sendmail emulation); Thu, 25 Aug 2022 14:33:15 +0300
Date:   Thu, 25 Aug 2022 14:33:15 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     intel-gfx@lists.freedesktop.org,
        Diego Santa Cruz <Diego.SantaCruz@spinetix.com>,
        stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/glk: ECS Liva Q2 needs GLK HDMI
 port timing quirk
Message-ID: <Ywdd+7ifzC7AknS7@intel.com>
References: <20220616124137.3184371-1-jani.nikula@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220616124137.3184371-1-jani.nikula@intel.com>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 16, 2022 at 03:41:37PM +0300, Jani Nikula wrote:
> From: Diego Santa Cruz <Diego.SantaCruz@spinetix.com>
> 
> The quirk added in upstream commit 90c3e2198777 ("drm/i915/glk: Add
> Quirk for GLK NUC HDMI port issues.") is also required on the ECS Liva
> Q2.
> 
> Note: Would be nicer to figure out the extra delay required for the
> retimer without quirks, however don't know how to check for that.
> 
> Cc: stable@vger.kernel.org
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1326
> Signed-off-by: Diego Santa Cruz <Diego.SantaCruz@spinetix.com>
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>

Seems fine. Although I do wonder whether we could directly identify the
bogus retimer chip via the dual mode adapter registers. I've asked for
that in the bug.

Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

> ---
>  drivers/gpu/drm/i915/display/intel_quirks.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_quirks.c b/drivers/gpu/drm/i915/display/intel_quirks.c
> index c8488f5ebd04..e415cd7c0b84 100644
> --- a/drivers/gpu/drm/i915/display/intel_quirks.c
> +++ b/drivers/gpu/drm/i915/display/intel_quirks.c
> @@ -191,6 +191,9 @@ static struct intel_quirk intel_quirks[] = {
>  	/* ASRock ITX*/
>  	{ 0x3185, 0x1849, 0x2212, quirk_increase_ddi_disabled_time },
>  	{ 0x3184, 0x1849, 0x2212, quirk_increase_ddi_disabled_time },
> +	/* ECS Liva Q2 */
> +	{ 0x3185, 0x1019, 0xa94d, quirk_increase_ddi_disabled_time },
> +	{ 0x3184, 0x1019, 0xa94d, quirk_increase_ddi_disabled_time },
>  };
>  
>  void intel_init_quirks(struct drm_i915_private *i915)
> -- 
> 2.30.2

-- 
Ville Syrjälä
Intel
