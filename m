Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D574688E6
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 02:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhLEBnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 20:43:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbhLEBnu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Dec 2021 20:43:50 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B1FC061751
        for <stable@vger.kernel.org>; Sat,  4 Dec 2021 17:40:24 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id m5so6610375ilh.11
        for <stable@vger.kernel.org>; Sat, 04 Dec 2021 17:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3P6ZX2WPGBZUGrwX1sNIx6IAkSPjFdUxOLTdoRj9Dmo=;
        b=kfGd0Jpzo6Fd7lE7mHGoL11lT6QSFySbtiGKp3riIN2EwI1KDN8I8URMvZsNASeEVn
         FesP98muuzb4GTtjN2HP5iiigpRTjSnKwr3VfM9T+DsLDBl0X09/VcZZ99PwLtCVv1ds
         Nprnmk3qobq1fP9ggJBMWqKTmm8dewLPyNhe1B4u+o2LOV/nuYE/87BscIELHVI8/AdR
         r48d35LHznOn9QCJ7aqQNYTS26NtHf2QlcFoo5mcsYkE/QZ33Gh+aKhNLjGNFemf9TKk
         H7j4CjE0WBzUQrvKW6UdnYReKIewM2hQHHWu7tv1NmJiPsh/EN44CawWtpDb0FqvuUk5
         iDDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3P6ZX2WPGBZUGrwX1sNIx6IAkSPjFdUxOLTdoRj9Dmo=;
        b=z5eVsqmzrZzKgQsYCMXdzVCbK+k4eVn5Lkk+h713FE3aXORoRymbR+EpEJfo3uDUAH
         8wp598BkZ8FUP0w0+TPE929dV6V9DUXhG3dPZxllR8ETKVlBRxzajVL1elV6kZIIgNny
         7MKMLrKFahRASwRfozxM/CXgaHVucmZncETep0RJgcR/9x51DA0wtH4pdkbmqfc8fuEe
         NeRj6U/3i438rhvXVEvcYmNO5E2UfQyhUHQ54oc5f7Xc1A+K2TraemQge9JqhlEd0uzS
         MSx2t+pSoiEcs4Oqu1hQVJ4C29IG6EcXBggGlz+SHmmWfRWRY6ZOu6nFuQjGuQTA8uim
         QL9w==
X-Gm-Message-State: AOAM533UmHqcdgbVAG4Rce7+vApg19d7xTSuEUZJQ4O/w97GZMpP1tO6
        u6Du9Y4gpYuXemZ2HOPwdAPDX2t+4BtqWPJHIPY1jY94P1RVVA==
X-Google-Smtp-Source: ABdhPJywRHsvboNCZFXyNJZ6yyLHwQxzUnZwqly9zRIXu+bOfV0AQOfJ+rvWiU5wcJhNhOg2w1OLr46aH1KeiPasVxs=
X-Received: by 2002:a05:6e02:20ca:: with SMTP id 10mr26576405ilq.246.1638668423547;
 Sat, 04 Dec 2021 17:40:23 -0800 (PST)
MIME-Version: 1.0
References: <20210315135545.132503808@linuxfoundation.org> <61abde5e.1c69fb81.474b3.97fbSMTPIN_ADDED_BROKEN@mx.google.com>
In-Reply-To: <61abde5e.1c69fb81.474b3.97fbSMTPIN_ADDED_BROKEN@mx.google.com>
From:   Art Nikpal <email2tema@gmail.com>
Date:   Sun, 5 Dec 2021 09:40:13 +0800
Message-ID: <CAKaHn9J+vhMcxwYxV0L2edZ9sFT11LEokDCvM6j_ccMuqo-__Q@mail.gmail.com>
Subject: Re: [PATCH 5.10] Revert "drm: meson_drv add shutdown function"
To:     Jerome Brunet <jbrunet@baylibre.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        Artem Lapkin <art@khadas.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hi all

i have test it on (VIM1 VIM2 VIM3 VIM3L) its works on my side
+ 5.10.11
+ 5.11.x
+ 5.13.x
+ 5.14.x
+ 5.15.x
+ 5.16.x

can u share your kernel config (i know for some kernel configuration
drivers still have problem with reboot )


On Sun, Dec 5, 2021 at 5:32 AM Jerome Brunet <jbrunet@baylibre.com> wrote:
>
> This reverts commit d66083c0d6f5125a4d982aa177dd71ab4cd3d212
> and commit d4ec1ffbdaa8939a208656e9c1440742c457ef16.
>
> On v5.10 stable, reboot gets stuck on gxl and g12a chip family (at least).
> This was tested on the aml-s905x-cc from libretch and the u200 reference
> design.
>
> Bisecting on the v5.10 stable branch lead to
> commit d4ec1ffbdaa8 ("drm: meson_drv add shutdown function").
>
> Reverting it (and a fixes on the it) sloves the problem.
>
> Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
> ---
>
> Hi Greg,
>
> Things are fine on master but it breaks on v5.10-y.
> I did not check v5.14-y yet. I'll try next week.
>
>
>  drivers/gpu/drm/meson/meson_drv.c | 12 ------------
>  1 file changed, 12 deletions(-)
>
> diff --git a/drivers/gpu/drm/meson/meson_drv.c b/drivers/gpu/drm/meson/meson_drv.c
> index 2753067c08e6..3d1de9cbb1c8 100644
> --- a/drivers/gpu/drm/meson/meson_drv.c
> +++ b/drivers/gpu/drm/meson/meson_drv.c
> @@ -482,17 +482,6 @@ static int meson_probe_remote(struct platform_device *pdev,
>         return count;
>  }
>
> -static void meson_drv_shutdown(struct platform_device *pdev)
> -{
> -       struct meson_drm *priv = dev_get_drvdata(&pdev->dev);
> -
> -       if (!priv)
> -               return;
> -
> -       drm_kms_helper_poll_fini(priv->drm);
> -       drm_atomic_helper_shutdown(priv->drm);
> -}
> -
>  static int meson_drv_probe(struct platform_device *pdev)
>  {
>         struct component_match *match = NULL;
> @@ -564,7 +553,6 @@ static const struct dev_pm_ops meson_drv_pm_ops = {
>
>  static struct platform_driver meson_drm_platform_driver = {
>         .probe      = meson_drv_probe,
> -       .shutdown   = meson_drv_shutdown,
>         .driver     = {
>                 .name   = "meson-drm",
>                 .of_match_table = dt_match,
> --
> 2.34.0
>
