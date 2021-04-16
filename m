Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6FC0361D07
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 12:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241568AbhDPJOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 05:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235020AbhDPJOw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 05:14:52 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F749C061756
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 02:14:27 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id f29so18802688pgm.8
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 02:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8lDqc+TYkF9pP4uENPMPvtRZ1G1LiLYNI2+86HjZ3j4=;
        b=U+Nll+6qi9gighJPhyw/5xmLkh+myCNJH8LtUaH/kjyn353iLZcEsskXL8ml4YkRCj
         w2wFm+i7gUrXuZmdZzZC2sqDLSpE77zRvujOHMSkdw2nShClvTHA5armSVUD562+D9Ii
         l4JA3AFw9hBT/VExwC/ZpUrAFOE879pIA1spaev+ejW78F1zmBCEeQy/PMbCiyJmb4Gr
         i6zy9UktR8oOzfzDR8lQzHeHGmOYPSvaou142xr3LNWoc0n3toZ/atbibpnkc1Jn5l/V
         gTMGR100per33u3NDA4xgQAwqcjH7a2DoNp6GJ6y5jprwfswVP4TXWRoJ25rXHaqe8qd
         YkXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8lDqc+TYkF9pP4uENPMPvtRZ1G1LiLYNI2+86HjZ3j4=;
        b=jTjQvb2KuItog+ZGCium/WAXABXWrKbJMSGN3jA+RBDRyk9OPtwPVO7rjL6AxPPqCH
         Ip0mCkHj0bNP3j3ShfbKGj1wM2xRqNgxkccfqq4aXQKaxtsCFumi2EMFE2uq7fQF7v1o
         MiFEBSSNj6G0G/1FLQK998bqiEej3biFe75quRVVqygfgiWo6S67EFNji21dTaFO8uDJ
         H4ec5+7pbkLxhYRkFRuArLLv0rKQtTOSMkFt8GpXZSybM3hHSCM+/cZEqQY0NWb6bNqx
         YTQ2GHQmayHQgufkMwPecyyYTO0B56eAw4XWtXSp3kPfMj4y+hVh8tEWg47LJHS9CDJo
         LDpg==
X-Gm-Message-State: AOAM531yxTzahtXAVd4UsFZI49bk1oa8ogRo4xwr4vnoEMvD8EvJU1o/
        +h5HFJ9Zyvk0upjkcC2ce1YsBBjJ2rgbHPZ8stqJlA==
X-Google-Smtp-Source: ABdhPJxSkqkrwhYv5hXxKmkv9csB4kg1BQcPtIeGKgQQAuzgS5nXWtbBRz4tpaSCZ+S/3OLaNgRMLjfA4wRpQnPUF7M=
X-Received: by 2002:aa7:9d8e:0:b029:258:aaea:7000 with SMTP id
 f14-20020aa79d8e0000b0290258aaea7000mr4986162pfq.39.1618564466665; Fri, 16
 Apr 2021 02:14:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210415183639.1487-1-rdunlap@infradead.org> <CABkfQAGfaxQJ4xdMpJk3CO-VZueM11BBUR-YpAQ8v0-wvwAheg@mail.gmail.com>
In-Reply-To: <CABkfQAGfaxQJ4xdMpJk3CO-VZueM11BBUR-YpAQ8v0-wvwAheg@mail.gmail.com>
From:   Robert Foss <robert.foss@linaro.org>
Date:   Fri, 16 Apr 2021 11:14:15 +0200
Message-ID: <CAG3jFyuty4pVzd+6+tFgKtmAE06dOtz1AwnZRefQD9F7bvbKGQ@mail.gmail.com>
Subject: Re: [PATCH -next] drm: bridge: fix LONTIUM use of mipi_dsi_() functions
To:     Adrien Grassein <adrien.grassein@gmail.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sam Ravnborg <sam@ravnborg.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Merged for 5.13 in drm-misc-next-fixes

On Thu, 15 Apr 2021 at 21:36, Adrien Grassein <adrien.grassein@gmail.com> w=
rote:
>
> Reviewed-by: Adren Grassein <adrien.grassein@gmail.com>
>
> Le jeu. 15 avr. 2021 =C3=A0 20:36, Randy Dunlap <rdunlap@infradead.org> a=
 =C3=A9crit :
> >
> > The Lontium DRM bridge drivers use mipi_dsi_() function interfaces so
> > they need to select DRM_MIPI_DSI to prevent build errors.
> >
> > ERROR: modpost: "mipi_dsi_attach" [drivers/gpu/drm/bridge/lontium-lt961=
1uxc.ko] undefined!
> > ERROR: modpost: "mipi_dsi_device_register_full" [drivers/gpu/drm/bridge=
/lontium-lt9611uxc.ko] undefined!
> > ERROR: modpost: "of_find_mipi_dsi_host_by_node" [drivers/gpu/drm/bridge=
/lontium-lt9611uxc.ko] undefined!
> > ERROR: modpost: "mipi_dsi_device_unregister" [drivers/gpu/drm/bridge/lo=
ntium-lt9611uxc.ko] undefined!
> > ERROR: modpost: "mipi_dsi_detach" [drivers/gpu/drm/bridge/lontium-lt961=
1uxc.ko] undefined!
> > ERROR: modpost: "mipi_dsi_attach" [drivers/gpu/drm/bridge/lontium-lt961=
1.ko] undefined!
> > ERROR: modpost: "mipi_dsi_device_register_full" [drivers/gpu/drm/bridge=
/lontium-lt9611.ko] undefined!
> > ERROR: modpost: "of_find_mipi_dsi_host_by_node" [drivers/gpu/drm/bridge=
/lontium-lt9611.ko] undefined!
> > ERROR: modpost: "mipi_dsi_device_unregister" [drivers/gpu/drm/bridge/lo=
ntium-lt9611.ko] undefined!
> > ERROR: modpost: "mipi_dsi_detach" [drivers/gpu/drm/bridge/lontium-lt961=
1.ko] undefined!
> > WARNING: modpost: suppressed 5 unresolved symbol warnings because there=
 were too many)
> >
> > Fixes: 23278bf54afe ("drm/bridge: Introduce LT9611 DSI to HDMI bridge")
> > Fixes: 0cbbd5b1a012 ("drm: bridge: add support for lontium LT9611UXC br=
idge")
> > Fixes: 30e2ae943c26 ("drm/bridge: Introduce LT8912B DSI to HDMI bridge"=
)
> > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > Reported-by: kernel test robot <lkp@intel.com>
> > Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> > Cc: Sam Ravnborg <sam@ravnborg.org>
> > Cc: Vinod Koul <vkoul@kernel.org>
> > Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> > Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> > Cc: Adrien Grassein <adrien.grassein@gmail.com>
> > Cc: Andrzej Hajda <a.hajda@samsung.com>
> > Cc: Neil Armstrong <narmstrong@baylibre.com>
> > Cc: Robert Foss <robert.foss@linaro.org>
> > Cc: dri-devel@lists.freedesktop.org
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/gpu/drm/bridge/Kconfig |    3 +++
> >  1 file changed, 3 insertions(+)
> >
> > --- linux-next-20210414.orig/drivers/gpu/drm/bridge/Kconfig
> > +++ linux-next-20210414/drivers/gpu/drm/bridge/Kconfig
> > @@ -66,6 +66,7 @@ config DRM_LONTIUM_LT8912B
> >         depends on OF
> >         select DRM_PANEL_BRIDGE
> >         select DRM_KMS_HELPER
> > +       select DRM_MIPI_DSI
> >         select REGMAP_I2C
> >         help
> >           Driver for Lontium LT8912B DSI to HDMI bridge
> > @@ -81,6 +82,7 @@ config DRM_LONTIUM_LT9611
> >         depends on OF
> >         select DRM_PANEL_BRIDGE
> >         select DRM_KMS_HELPER
> > +       select DRM_MIPI_DSI
> >         select REGMAP_I2C
> >         help
> >           Driver for Lontium LT9611 DSI to HDMI bridge
> > @@ -94,6 +96,7 @@ config DRM_LONTIUM_LT9611UXC
> >         depends on OF
> >         select DRM_PANEL_BRIDGE
> >         select DRM_KMS_HELPER
> > +       select DRM_MIPI_DSI
> >         select REGMAP_I2C
> >         help
> >           Driver for Lontium LT9611UXC DSI to HDMI bridge
