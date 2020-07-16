Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1146222A70
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 19:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgGPRui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 13:50:38 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:43706 "EHLO
        asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728672AbgGPRug (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jul 2020 13:50:36 -0400
Received: from ravnborg.org (unknown [188.228.123.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk3.altibox.net (Postfix) with ESMTPS id 9D83520024;
        Thu, 16 Jul 2020 19:50:33 +0200 (CEST)
Date:   Thu, 16 Jul 2020 19:50:32 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Thierry Reding <thierry.reding@gmail.com>, od@zcrc.me,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] drm/panel-simple: Fix inverted V/H SYNC for Frida
 FRD350H54004 panel
Message-ID: <20200716175032.GD2235355@ravnborg.org>
References: <20200716125647.10964-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716125647.10964-1-paul@crapouillou.net>
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=f+hm+t6M c=1 sm=1 tr=0
        a=S6zTFyMACwkrwXSdXUNehg==:117 a=S6zTFyMACwkrwXSdXUNehg==:17
        a=kj9zAlcOel0A:10 a=VwQbUJbxAAAA:8 a=ER_8r6IbAAAA:8
        a=etWGH2V3dnbwptkrp_gA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=9LHmKk7ezEChjTCyhBa9:22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 16, 2020 at 02:56:46PM +0200, Paul Cercueil wrote:
> The FRD350H54004 panel was marked as having active-high VSYNC and HSYNC
> signals, which sorts-of worked, but resulted in the picture fading out
> under certain circumstances.
> 
> Fix this issue by marking VSYNC and HSYNC signals active-low.
> 
> v2: Rebase on drm-misc-next
> 
> Fixes: 7b6bd8433609 ("drm/panel: simple: Add support for the Frida FRD350H54004 panel")
> Cc: stable@vger.kernel.org # v5.5
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>

Thanks for the re-submit. Applied both patches to drm-misc-next.

	Sam

> ---
>  drivers/gpu/drm/panel/panel-simple.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
> index f42249b72548..8b0bab9dd075 100644
> --- a/drivers/gpu/drm/panel/panel-simple.c
> +++ b/drivers/gpu/drm/panel/panel-simple.c
> @@ -1763,7 +1763,7 @@ static const struct drm_display_mode frida_frd350h54004_mode = {
>  	.vsync_start = 240 + 2,
>  	.vsync_end = 240 + 2 + 6,
>  	.vtotal = 240 + 2 + 6 + 2,
> -	.flags = DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC,
> +	.flags = DRM_MODE_FLAG_NHSYNC | DRM_MODE_FLAG_NVSYNC,
>  };
>  
>  static const struct panel_desc frida_frd350h54004 = {
> -- 
> 2.27.0
