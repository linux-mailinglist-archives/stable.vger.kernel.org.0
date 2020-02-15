Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89A1A15FC51
	for <lists+stable@lfdr.de>; Sat, 15 Feb 2020 03:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbgBOCY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 21:24:56 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:47757 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727642AbgBOCY4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 21:24:56 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id B334550C;
        Fri, 14 Feb 2020 21:24:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 14 Feb 2020 21:24:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        subject:to:cc:references:from:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=fm1; bh=v
        vqKA3w0ogTD2zKTC9vD3A2cJ7V/uBUbB/mhzaoqt58=; b=f4bhfGD2gvxmUUu1M
        gsRPNjVrQhELJyhLkhwUzEr0gG1cbGVbmRkI7Tzycjm0IT3q5IgNpsF2Fh1nc4Ch
        ET0Pp5CLOFWtgkQXl34OMd5RAN+Onjh6VN3RdE1oHbtj4YgF2jnQxwKMhlL1ZCTt
        xuo4UeeIKJZUnyjV+kI01SSmvtk9dCk3X6QpliUxpOR0k5Lrzg+e6PmcoX0QEpCk
        BgnQprdKnr41TWZ6dmc1Ah9g+1RWgUmJECORDkqrFaK4K4KIvbA2w/hq//dhuJ9h
        ClgvjjczBK7wJejBKgbfgN1uIs7gWg1nC2lEXuycpmv34wIGsgpJe63YuaKe7mDk
        JFQbw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=vvqKA3w0ogTD2zKTC9vD3A2cJ7V/uBUbB/mhzaoqt
        58=; b=m2MxJop3TAOfFCE6o+ezxjzlm0u9J9nReM7lfPTUB2OdV7W4AFP8r3ze6
        sYuSujM2R4nRn755JK/7vOUA5qSaStWBOhrrReIE5+MIZCP8u3VVHBhyTvBjQvLX
        2HG4o2oUv2dkD+gE+r7O48IvtBjzIi9FHkP0Ewb6JB7qSlAtd2C+HQRE7cwjgECV
        6fNCBuNXy496wg8Zfmq+0sA8jj6yYi8SPg+uGkJS62HMLTV65Zqffz0beVs97UGE
        adNV99T2JUX9MS+d5a5fg0qSpZC5O9hOsYkuvLVXDl9PntUZ2EtvB3922ZYRI7yL
        OKC+TZLvsIBS9sCg47B3eBAkxHuGw==
X-ME-Sender: <xms:c1ZHXliDOZBDNxLpYgr2XHrmyJwO8tDJsZCvgyW4c1OLFz13GNG3GA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjedugdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecundfkohfvucdliedtmdenucfjughrpefuvfhfhffkff
    gfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpefurghmuhgvlhcujfholhhlrghnugcu
    oehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucfkphepjedtrddufeehrdduge
    ekrdduhedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhho
    mhepshgrmhhuvghlsehshhholhhlrghnugdrohhrgh
X-ME-Proxy: <xmx:c1ZHXob8Q8Kq8w6ZB-0dRiGY1oMEUWlQ_9dYDij9VwF-mbleUurrCw>
    <xmx:c1ZHXngP_Z21VUp2gamWXSSFtu_ldS3oV77EMVp_yzumfEAu3XZv0g>
    <xmx:c1ZHXnfEJigNoa7USvm4OkgkpbYTRToNJtVfi7glxmgqTdvcuW5OcKyEHA>
    <xmx:dlZHXrkvWj8J0XPgqaaeYSoliVuehlhBZt9CGk6lv_PaLtBotAY1Aw>
Received: from [192.168.50.169] (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1D90A3060C28;
        Fri, 14 Feb 2020 21:24:51 -0500 (EST)
Subject: Re: [PATCH 3/4] drm/sun4i: dsi: Allow binding the host without a
 panel
To:     Maxime Ripard <mripard@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20200211072858.30784-1-samuel@sholland.org>
 <20200211072858.30784-3-samuel@sholland.org>
From:   Samuel Holland <samuel@sholland.org>
Message-ID: <11bf69b6-9081-7d29-148a-ebc14eef549d@sholland.org>
Date:   Fri, 14 Feb 2020 20:24:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200211072858.30784-3-samuel@sholland.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Maxime,

On 2/11/20 1:28 AM, Samuel Holland wrote:
> Currently, the DSI host blocks binding the display pipeline until the
> panel is available. This unnecessarily prevents other display outpus
> from working, and adds logspam to dmesg when the panel driver is built
> as a module (the component master is unsuccessfully brought up several
> times during boot).
> 
> Flip the dependency, instead requiring the host to be bound before the
> panel is attached. The panel driver provides no functionality outside of
> the display pipeline anyway.
> 
> Since the panel is now probed after the DRM connector, we need a hotplug
> event to turn on the connector after the panel is attached.
> 
> This has the added benefit of fixing panel module removal/insertion.
> Previously, the panel would be turned off when its module was removed.
> But because the connector state was hardcoded, nothing knew to turn the
> panel back on when it was re-attached. Now, with hotplug events
> available, the connector state will follow the panel module state, and
> the panel will be re-enabled properly.
> 
> Fixes: 133add5b5ad4 ("drm/sun4i: Add Allwinner A31 MIPI-DSI controller support")
> Signed-off-by: Samuel Holland <samuel@sholland.org>
> ---
>  drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c | 22 ++++++++++++++++------
>  drivers/gpu/drm/sun4i/sun6i_mipi_dsi.h |  1 +
>  2 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
> index 019fdf4ec274..ef35ce5a9bb0 100644
> --- a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
> +++ b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
> @@ -804,7 +804,10 @@ static struct drm_connector_helper_funcs sun6i_dsi_connector_helper_funcs = {
>  static enum drm_connector_status
>  sun6i_dsi_connector_detect(struct drm_connector *connector, bool force)
>  {
> -	return connector_status_connected;
> +	struct sun6i_dsi *dsi = connector_to_sun6i_dsi(connector);
> +
> +	return dsi->panel ? connector_status_connected :
> +			    connector_status_disconnected;
>  }
>  
>  static const struct drm_connector_funcs sun6i_dsi_connector_funcs = {
> @@ -945,10 +948,15 @@ static int sun6i_dsi_attach(struct mipi_dsi_host *host,
>  
>  	if (IS_ERR(panel))
>  		return PTR_ERR(panel);
> +	if (!dsi->drm)
> +		return -EPROBE_DEFER;

There's actually a bug here. If the panel and DSI drivers are loaded in
parallel, sun6i_dsi_attach() can be called after sun6i_dsi_bind() but before
sun4i_framebuffer_init() initializes drm->mode_config.funcs, causing the hotplug
call to crash. This check also needs to consider dsi->drm->registered before
allowing the panel to be added.

I can send a v2 or a follow-up, whichever you prefer.

Thanks,
Samuel

>  	dsi->panel = panel;
>  	dsi->device = device;
>  
> +	drm_panel_attach(dsi->panel, &dsi->connector);
> +	drm_kms_helper_hotplug_event(dsi->drm);
> +
>  	dev_info(host->dev, "Attached device %s\n", device->name);
>  
>  	return 0;
> @@ -958,10 +966,14 @@ static int sun6i_dsi_detach(struct mipi_dsi_host *host,
>  			    struct mipi_dsi_device *device)
>  {
>  	struct sun6i_dsi *dsi = host_to_sun6i_dsi(host);
> +	struct drm_panel *panel = dsi->panel;
>  
>  	dsi->panel = NULL;
>  	dsi->device = NULL;
>  
> +	drm_panel_detach(panel);
> +	drm_kms_helper_hotplug_event(dsi->drm);
> +
>  	return 0;
>  }
>  
> @@ -1026,9 +1038,6 @@ static int sun6i_dsi_bind(struct device *dev, struct device *master,
>  	struct sun6i_dsi *dsi = dev_get_drvdata(dev);
>  	int ret;
>  
> -	if (!dsi->panel)
> -		return -EPROBE_DEFER;
> -
>  	drm_encoder_helper_add(&dsi->encoder,
>  			       &sun6i_dsi_enc_helper_funcs);
>  	ret = drm_encoder_init(drm,
> @@ -1054,7 +1063,8 @@ static int sun6i_dsi_bind(struct device *dev, struct device *master,
>  	}
>  
>  	drm_connector_attach_encoder(&dsi->connector, &dsi->encoder);
> -	drm_panel_attach(dsi->panel, &dsi->connector);
> +
> +	dsi->drm = drm;
>  
>  	return 0;
>  
> @@ -1068,7 +1078,7 @@ static void sun6i_dsi_unbind(struct device *dev, struct device *master,
>  {
>  	struct sun6i_dsi *dsi = dev_get_drvdata(dev);
>  
> -	drm_panel_detach(dsi->panel);
> +	dsi->drm = NULL;
>  }
>  
>  static const struct component_ops sun6i_dsi_ops = {
> diff --git a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.h b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.h
> index 61e88ea6044d..c863900ae3b4 100644
> --- a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.h
> +++ b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.h
> @@ -29,6 +29,7 @@ struct sun6i_dsi {
>  
>  	struct device		*dev;
>  	struct mipi_dsi_device	*device;
> +	struct drm_device	*drm;
>  	struct drm_panel	*panel;
>  };
>  
> 

