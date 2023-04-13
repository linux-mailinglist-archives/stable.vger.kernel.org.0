Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D776E111F
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 17:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbjDMP1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 11:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjDMP1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 11:27:40 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A29AA5E4
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 08:27:24 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-1842df7cb53so18356520fac.10
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 08:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681399644; x=1683991644;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=CUK8UGSHUoiocToUShwFZ6IjnlM5/4ZHnGe4gLnESU0=;
        b=aeAwlhfbuxDEmGLzmr4qn1sIPbcsAKVCFKFu5pGfong4RuRbDlQ09tEYt4hkfk40Ey
         cpSkNpSfAF+AbEEbTQeftznc0uVFDpip6Uo1L16NAnp98MBcBEtetImhHGqCiZ8g5pez
         cD5FrL8Fol+jaO0r9YMWrQiZbQRnXPRStccPuQo1yX5GvLjv03fZPRegLUpQOELRFZWM
         cPRpK3Ln+iUCDTrPCFr2Q4dkfO18MoGSPcY8fWCCuKpjMC/KlzYU8kNTryN3FMyFZWZb
         RrfFxTJGoZx2Le2OwVbcCEyAwdtgr1WB1zn7Tdl9EzsG6dlCnOswkKdx6yoFoGlIjLZP
         PqHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681399644; x=1683991644;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CUK8UGSHUoiocToUShwFZ6IjnlM5/4ZHnGe4gLnESU0=;
        b=WG25SUC9kaa0mDQ2BSkr6s3ewQjIpiE5VI/5A73YC7542CRkX7xPEMYQNZiy2DsWmY
         90ShohJAKDO8jtqSeyaldp68R3AEcdSBDV12gxPG3kIZgOQSOoxFlMdW/xOSzmPZVnU8
         +Y0qviD7M4g8dIZr2gfycaXJXvWoj55cjhDkxL8VakGoaHytz6CrnhpJ7fSAiPRck4Dw
         diJjRs2s1Qo7x3gPIOZFq9Wljw4ehFN5/ranc8ddjlr258qsDhxOGkZD/mWDU/5i6ZdD
         evAG+w6CMVimzjz08YJOeHRJ5pllL0OHZENVObNFsowbU2iKh3jNkXt88GyxeyeXDxaU
         YJ0A==
X-Gm-Message-State: AAQBX9efZzowXRRkNEp5bFlKXscn4qEjWB4KBK7bw5l7SCWp/Jo8uIrB
        aZ9ZSltEFmR185aiZRFNowc=
X-Google-Smtp-Source: AKy350bz179FxBnltSYj2CIpmACrhB4CeMl7xmLodBy6+1eemMwFHEBVzU8OfoLpGLRd7geQvNvWqg==
X-Received: by 2002:a05:6870:210:b0:187:87e3:1247 with SMTP id j16-20020a056870021000b0018787e31247mr2186944oad.43.1681399643830;
        Thu, 13 Apr 2023 08:27:23 -0700 (PDT)
Received: from neuromancer. (76-244-6-13.lightspeed.rcsntx.sbcglobal.net. [76.244.6.13])
        by smtp.gmail.com with ESMTPSA id r4-20020a056870414400b0017ae909afe8sm793608oad.34.2023.04.13.08.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 08:27:23 -0700 (PDT)
Message-ID: <64381f5b.050a0220.1533e.41e2@mx.google.com>
X-Google-Original-Message-ID: <ZDgfWQKFBMeDrqVu@neuromancer.>
Date:   Thu, 13 Apr 2023 10:27:21 -0500
From:   Chris Morgan <macroalpha82@gmail.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     dri-devel@lists.freedesktop.org, Sandy Huang <hjc@rock-chips.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        linux-rockchip@lists.infradead.org, kernel@pengutronix.de,
        =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
        Michael Riesch <michael.riesch@wolfvision.net>,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm/rockchip: vop2: fix suspend/resume
References: <20230413144347.3506023-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413144347.3506023-1-s.hauer@pengutronix.de>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 13, 2023 at 04:43:47PM +0200, Sascha Hauer wrote:
> During a suspend/resume cycle the VO power domain will be disabled and
> the VOP2 registers will reset to their default values. After that the
> cached register values will be out of sync and the read/modify/write
> operations we do on the window registers will result in bogus values
> written. Fix this by re-initializing the register cache each time we
> enable the VOP2. With this the VOP2 will show a picture after a
> suspend/resume cycle whereas without this the screen stays dark.
> 
> Fixes: 604be85547ce4 ("drm/rockchip: Add VOP2 driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
> index ba3b817895091..d9daa686b014d 100644
> --- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
> @@ -215,6 +215,8 @@ struct vop2 {
>  	struct vop2_win win[];
>  };
>  
> +static const struct regmap_config vop2_regmap_config;
> +
>  static struct vop2_video_port *to_vop2_video_port(struct drm_crtc *crtc)
>  {
>  	return container_of(crtc, struct vop2_video_port, crtc);
> @@ -839,6 +841,12 @@ static void vop2_enable(struct vop2 *vop2)
>  		return;
>  	}
>  
> +	ret = regmap_reinit_cache(vop2->map, &vop2_regmap_config);
> +	if (ret) {
> +		drm_err(vop2->drm, "failed to reinit cache: %d\n", ret);
> +		return;
> +	}
> +
>  	if (vop2->data->soc_id == 3566)
>  		vop2_writel(vop2, RK3568_OTP_WIN_EN, 1);
>  
> -- 
> 2.39.2
> 

I confirmed this works on my Anbernic RG353P which uses the rk3566 SOC.
Before applying the patch I displayed a color pattern with modetest
before suspend and it appeared correctly. Then I suspended and resumed
the device, attempted to display the same color pattern, and only got
a single pixel on an otherwise blank display. After applying the patch
I performed the same test and the color pattern appeared correctly
both before and after suspend (and the display was no longer blank
after resume from suspend).

Tested-by: Chris Morgan <macromorgan@hotmail.com>
