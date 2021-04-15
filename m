Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5723612F6
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 21:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234784AbhDOThP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 15:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234735AbhDOThP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 15:37:15 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C7BC061574;
        Thu, 15 Apr 2021 12:36:51 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id f8so29469247edd.11;
        Thu, 15 Apr 2021 12:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NNXtYoxo/qwfgdSe6NIOVB0oJtONeFgwJFiktR+gW2w=;
        b=sFmVzGOumL6R9zB3G+mYGAPwaRNK2YIqkVto1Ts6HtUoi1JZVrT+J4kCicgWTkRFSm
         k2IlVN03IcJLq8UK1dCcN25lj/rEDDmkNV1rSvGyAZmZcQ6n+H0mrpoUjwWl+BruHtn5
         anGaNJLqlWFQ195gcQM70z9JOYNP+CrBN3bI8jCvInxXZCHcG24SNgy2PAADehQndk9Z
         RM62OXhFeHs9sXJ6Q5TWLlUWR7onruLmknbTZsOjlIckDL6jvcCI6CYsmsMu485uBLwx
         MQhDs2wYsB37dy8zDqkTvDdIWoLcXfFQSoRUhmSqs6Jz1WQb8eLx8m0PL8FYcp+VLwwf
         pd4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NNXtYoxo/qwfgdSe6NIOVB0oJtONeFgwJFiktR+gW2w=;
        b=KJ656XnQysOpwK+FBp+N9dyOz0MwLLX07Cx1SID6CVDgjZYC6wIVL+c5KdeDQoPfDM
         3Ns2MrDHzKYKYkk4SZGi2Rqnv4LLJXsVm5LCI0YjyrSvxH42PZgR2GDjpGXsrTGRSIEr
         G5P704YdkFPhG1o+J8Sx2OA7L4n2ryt0mCZ0qVzFB4neMyqEyriMCXEhuG7LkeC8RQUf
         zz0tRzcQw+unTFkq7DaUUbue3a8qg+YS2uaLxNXB5gQwTyBKzuL3CPGKKTUyZEItOyXo
         UXyTK3LI75yr2cVGtkNMbI58Qt/2x/yEoqg0pUdAdRPLo+Cpi8vkqL5u0Qb17swMs+BV
         xKQA==
X-Gm-Message-State: AOAM533tLzHp4vxWMmgrTUoMc3DXBZ0yIds/vkElcQ0Ae2W2+7ad9FNB
        YkqmSSza72X4wIh+gY4JxCokOIYWB7ohqOYXnfc=
X-Google-Smtp-Source: ABdhPJxPxXCpsLrJ+yyhlGDY0dJrj6JwBfjSHCfxKihJvxo/88csJPF6GRuQxdEfmVLGiQ09+Iqj9dgMMLC1v14H+2M=
X-Received: by 2002:a05:6402:3506:: with SMTP id b6mr6393593edd.175.1618515410310;
 Thu, 15 Apr 2021 12:36:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210415183639.1487-1-rdunlap@infradead.org>
In-Reply-To: <20210415183639.1487-1-rdunlap@infradead.org>
From:   Adrien Grassein <adrien.grassein@gmail.com>
Date:   Thu, 15 Apr 2021 21:36:39 +0200
Message-ID: <CABkfQAGfaxQJ4xdMpJk3CO-VZueM11BBUR-YpAQ8v0-wvwAheg@mail.gmail.com>
Subject: Re: [PATCH -next] drm: bridge: fix LONTIUM use of mipi_dsi_() functions
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sam Ravnborg <sam@ravnborg.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Adren Grassein <adrien.grassein@gmail.com>

Le jeu. 15 avr. 2021 =C3=A0 20:36, Randy Dunlap <rdunlap@infradead.org> a =
=C3=A9crit :
>
> The Lontium DRM bridge drivers use mipi_dsi_() function interfaces so
> they need to select DRM_MIPI_DSI to prevent build errors.
>
> ERROR: modpost: "mipi_dsi_attach" [drivers/gpu/drm/bridge/lontium-lt9611u=
xc.ko] undefined!
> ERROR: modpost: "mipi_dsi_device_register_full" [drivers/gpu/drm/bridge/l=
ontium-lt9611uxc.ko] undefined!
> ERROR: modpost: "of_find_mipi_dsi_host_by_node" [drivers/gpu/drm/bridge/l=
ontium-lt9611uxc.ko] undefined!
> ERROR: modpost: "mipi_dsi_device_unregister" [drivers/gpu/drm/bridge/lont=
ium-lt9611uxc.ko] undefined!
> ERROR: modpost: "mipi_dsi_detach" [drivers/gpu/drm/bridge/lontium-lt9611u=
xc.ko] undefined!
> ERROR: modpost: "mipi_dsi_attach" [drivers/gpu/drm/bridge/lontium-lt9611.=
ko] undefined!
> ERROR: modpost: "mipi_dsi_device_register_full" [drivers/gpu/drm/bridge/l=
ontium-lt9611.ko] undefined!
> ERROR: modpost: "of_find_mipi_dsi_host_by_node" [drivers/gpu/drm/bridge/l=
ontium-lt9611.ko] undefined!
> ERROR: modpost: "mipi_dsi_device_unregister" [drivers/gpu/drm/bridge/lont=
ium-lt9611.ko] undefined!
> ERROR: modpost: "mipi_dsi_detach" [drivers/gpu/drm/bridge/lontium-lt9611.=
ko] undefined!
> WARNING: modpost: suppressed 5 unresolved symbol warnings because there w=
ere too many)
>
> Fixes: 23278bf54afe ("drm/bridge: Introduce LT9611 DSI to HDMI bridge")
> Fixes: 0cbbd5b1a012 ("drm: bridge: add support for lontium LT9611UXC brid=
ge")
> Fixes: 30e2ae943c26 ("drm/bridge: Introduce LT8912B DSI to HDMI bridge")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Cc: Adrien Grassein <adrien.grassein@gmail.com>
> Cc: Andrzej Hajda <a.hajda@samsung.com>
> Cc: Neil Armstrong <narmstrong@baylibre.com>
> Cc: Robert Foss <robert.foss@linaro.org>
> Cc: dri-devel@lists.freedesktop.org
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/bridge/Kconfig |    3 +++
>  1 file changed, 3 insertions(+)
>
> --- linux-next-20210414.orig/drivers/gpu/drm/bridge/Kconfig
> +++ linux-next-20210414/drivers/gpu/drm/bridge/Kconfig
> @@ -66,6 +66,7 @@ config DRM_LONTIUM_LT8912B
>         depends on OF
>         select DRM_PANEL_BRIDGE
>         select DRM_KMS_HELPER
> +       select DRM_MIPI_DSI
>         select REGMAP_I2C
>         help
>           Driver for Lontium LT8912B DSI to HDMI bridge
> @@ -81,6 +82,7 @@ config DRM_LONTIUM_LT9611
>         depends on OF
>         select DRM_PANEL_BRIDGE
>         select DRM_KMS_HELPER
> +       select DRM_MIPI_DSI
>         select REGMAP_I2C
>         help
>           Driver for Lontium LT9611 DSI to HDMI bridge
> @@ -94,6 +96,7 @@ config DRM_LONTIUM_LT9611UXC
>         depends on OF
>         select DRM_PANEL_BRIDGE
>         select DRM_KMS_HELPER
> +       select DRM_MIPI_DSI
>         select REGMAP_I2C
>         help
>           Driver for Lontium LT9611UXC DSI to HDMI bridge
