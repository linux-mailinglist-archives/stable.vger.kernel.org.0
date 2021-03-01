Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC89328977
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236731AbhCAR5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238921AbhCARv1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 12:51:27 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A767C061224
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 09:48:09 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id ci14so10835618ejc.7
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 09:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kKAwYJoDEnuNKA7NDxSNMttjG6oI4M6ycG0b0QK71X4=;
        b=K3Wu1CRni/FcygK9s0nDOo+LOi/QsIK9pC2qcIZisiCTiBFFyeG5pGO1PFD9D/2JZ+
         Bvf0xq9pahLEzCNVwR9seMyOWNxggnLxnVpPYz2NHM0bue7mr7+fChOYOmf8EbleGsYG
         Cun1hkf7ALRFNd9gwzGa6mZCa5tGjeIanfEoghvOU4rstxztSLec6d5coGH3dSuXLdGD
         UVnvPjD8qxQc3p2sYkGCkiM9SCZH8PNIsEtC8Vji1iCWutIfMu51gqijkUUbnIgSDTic
         4+1E8YDV37gk2mJSHsHeqiVn9k/kW0QroJD69JR9ul1xZ/puiRxS3eOG/yLlJFCdJMlW
         sM2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kKAwYJoDEnuNKA7NDxSNMttjG6oI4M6ycG0b0QK71X4=;
        b=fXx/Q0STy0gQcAySx2m4pesEzNuBB5XHXBXwzbKMsTbjKhmvI6tfEEOpCTX/0BfLE2
         x8ldJ4oBLxr6cmEvXPTV6m92PX5xnBsQS+sWHRkTVZWmqBrz9fzJP3fRYNdi3ClnpSeY
         iZXAvmQz6pmaRYrygYLK/tv7tvZ+mlL/e943TquTX14GLFIq8swwayn3MOOGexsuLh6z
         fFV111neLjWMowKQuMoxSgnfYIcpVnirCrh695VhpiicaOWrpIYqG/bhU5ZsfFmQf977
         TidwwJCv9VW4KoUXDimVUNEVEh6PrZW9ZAoWgmB8mxJaI/ZWOgGHx+en6OwIWwtyNOt9
         0Ipw==
X-Gm-Message-State: AOAM530+WVADm7T9vxhQCtBfsAoeAWAE6njxO4N4/Oa3QCegPb6+7BRa
        KCF8hoRr3Uzb36O6My4JZpFvdFsVW1zPxTTEi5izXQ==
X-Google-Smtp-Source: ABdhPJzP4WNgoNINfvklMYsaaLWAkFd6O+mPU5Y3Qmi5KdRFJb3oaFi3Gphz6n7E8p4bAtOgLQVCxAsdCar9WQ9UggE=
X-Received: by 2002:a17:906:d8ca:: with SMTP id re10mr17047184ejb.18.1614620888000;
 Mon, 01 Mar 2021 09:48:08 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYvApAT=vx_XxhbMZ=rS8ShhYkSKa0JsHC8k0dFn5xwU=Q@mail.gmail.com>
In-Reply-To: <CA+G9fYvApAT=vx_XxhbMZ=rS8ShhYkSKa0JsHC8k0dFn5xwU=Q@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 1 Mar 2021 23:17:56 +0530
Message-ID: <CA+G9fYsDd2Rk0YO=bELuWqcsA817v2GEaJvPxXfOJAVu0Jy5ig@mail.gmail.com>
Subject: Re: rcar_du_kms.c:781:24: error: passing argument 1 of
 '__drmm_add_action' from incompatible pointer type
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        kieran.bingham+renesas@ideasonboard.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 1 Mar 2021 at 23:11, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On stable rc 5.11 the x86_64 build failed due to below errors/warnings.

These build failures were also noticed on stable rc 5.10 for arm64,
arm, x86_64, and i386 architectures.

>
> drivers/gpu/drm/rcar-du/rcar_du_kms.c: In function 'rcar_du_modeset_cleanup':
> drivers/gpu/drm/rcar-du/rcar_du_kms.c:754:32: error: implicit
> declaration of function 'to_rcar_du_device'; did you mean
> 'to_rtc_device'? [-Werror=implicit-function-declaration]
>   struct rcar_du_device *rcdu = to_rcar_du_device(dev);
>                                 ^~~~~~~~~~~~~~~~~
>                                 to_rtc_device
> drivers/gpu/drm/rcar-du/rcar_du_kms.c:754:32: warning: initialization
> makes pointer from integer without a cast [-Wint-conversion]
> In file included from drivers/gpu/drm/rcar-du/rcar_du_kms.c:17:0:
> drivers/gpu/drm/rcar-du/rcar_du_kms.c: In function 'rcar_du_modeset_init':
> drivers/gpu/drm/rcar-du/rcar_du_kms.c:781:24: error: passing argument
> 1 of '__drmm_add_action' from incompatible pointer type
> [-Werror=incompatible-pointer-types]
>   ret = drmm_add_action(&rcdu->ddev, rcar_du_modeset_cleanup, NULL);
>                         ^
> include/drm/drm_managed.h:25:20: note: in definition of macro 'drmm_add_action'
>   __drmm_add_action(dev, action, data, #action)
>                     ^~~
> include/drm/drm_managed.h:27:18: note: expected 'struct drm_device *'
> but argument is of type 'struct drm_device **'
>  int __must_check __drmm_add_action(struct drm_device *dev,
>                   ^~~~~~~~~~~~~~~~~
> cc1: some warnings being treated as errors
>
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
>
> Build link,
> https://ci.linaro.org/job/openembedded-lkft-linux-stable-rc-5.11/DISTRO=lkft,MACHINE=ls2088ardb,label=docker-buster-lkft/8/consoleText
>
> --
> Linaro LKFT
> https://lkft.linaro.org
