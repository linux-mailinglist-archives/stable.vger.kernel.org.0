Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7500020296F
	for <lists+stable@lfdr.de>; Sun, 21 Jun 2020 09:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbgFUH57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jun 2020 03:57:59 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:55548 "EHLO
        asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729443AbgFUH57 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Jun 2020 03:57:59 -0400
Received: from ravnborg.org (unknown [188.228.123.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk3.altibox.net (Postfix) with ESMTPS id E6A3E20024;
        Sun, 21 Jun 2020 09:57:56 +0200 (CEST)
Date:   Sun, 21 Jun 2020 09:57:55 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc:     dri-devel@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Tony Lindgren <tony@atomide.com>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/panel-simple: fix connector type for
 newhaven_nhd_43_480272ef_atxl
Message-ID: <20200621075755.GG74146@ravnborg.org>
References: <20200609102809.753203-1-tomi.valkeinen@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609102809.753203-1-tomi.valkeinen@ti.com>
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=edQTgYMH c=1 sm=1 tr=0
        a=S6zTFyMACwkrwXSdXUNehg==:117 a=S6zTFyMACwkrwXSdXUNehg==:17
        a=kj9zAlcOel0A:10 a=sozttTNsAAAA:8 a=VwQbUJbxAAAA:8 a=e5mUnYsNAAAA:8
        a=ACxb6AsmS7fQEqgjs6EA:9 a=CjuIK1q_8ugA:10 a=aeg5Gbbo78KNqacMgKqU:22
        a=AjGcO6oz07-iQ99wixmX:22 a=Vxmtnl_E_bksehYqCbjh:22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tomi
On Tue, Jun 09, 2020 at 01:28:09PM +0300, Tomi Valkeinen wrote:
> Add connector type for newhaven_nhd_43_480272ef_atxl, as
> drm_panel_bridge_add() requires connector type to be set.
> 
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: stable@vger.kernel.org # v5.5+

Applied to drm-misc-fixes.
I looked at adding a Fixes: tag for the original commit introducing
newhaven_nhd_43_480272ef_atxl, but we did not have connector_type back
then.

	Sam

> ---
>  drivers/gpu/drm/panel/panel-simple.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
> index 3ad828eaefe1..00c1a8dc4ce8 100644
> --- a/drivers/gpu/drm/panel/panel-simple.c
> +++ b/drivers/gpu/drm/panel/panel-simple.c
> @@ -2465,6 +2465,7 @@ static const struct panel_desc newhaven_nhd_43_480272ef_atxl = {
>  	.bus_format = MEDIA_BUS_FMT_RGB888_1X24,
>  	.bus_flags = DRM_BUS_FLAG_DE_HIGH | DRM_BUS_FLAG_PIXDATA_DRIVE_POSEDGE |
>  		     DRM_BUS_FLAG_SYNC_DRIVE_POSEDGE,
> +	.connector_type = DRM_MODE_CONNECTOR_DPI,
>  };
>  
>  static const struct display_timing nlt_nl192108ac18_02d_timing = {
> -- 
> Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
> Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
