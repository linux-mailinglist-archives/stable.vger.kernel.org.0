Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F3046951C
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 12:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242564AbhLFLmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 06:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241994AbhLFLmc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 06:42:32 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA860C061746
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 03:39:03 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id s6so4366978ild.9
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 03:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a+oCJ+atN0VFdgn7140KXkYPDq4iifagIT5svcAVP1o=;
        b=Ep5qug1EBruv9aDB/9aWQlZDgWqXSUQDFu5Nz94+GEJGr1Kggh+dx8cscNLgZoBh9i
         fLFyJ5tGZSt7ToEBBuECSOSTXY2hnoTL1vTp1/P/tVUyaXBorHCc2w3SFWb5DcvAPEuP
         fywnAkJFu7HtjKlIKaEG0+tvg6X5WlNtEWLxU8PaPAjU92xZXGBzRMhJlVGU4VNU7mkl
         JubDzWc0XYgtErSFPqkl+tgRglAvpQnz1vGiuCRUeWl/9CcIZyz4hVYOxd3fxNpamnX3
         +10Ex1kSlR5arXCsKCqmPCOYI32fYUBwGxJ68j3tN7Bt8zpj8tDGl6y5953a81pQ+Zcx
         KePQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a+oCJ+atN0VFdgn7140KXkYPDq4iifagIT5svcAVP1o=;
        b=c5qPCWbYC7rv0Q4squcsrzgc65l8lX87aFMrJjz/0zZNB8cCaxYIoB9qZo+8p4i9Lw
         jf0V5JfKJz9TJh27Vwom601pbj+xpnyIIq7aWNv42s3u3oPedU+s1gRfOXWjSlzOPb/j
         QpMid7GJWHw3ue3NLGzHNHvStaSuXG+ZAv7/Swb7Ogs78KIb8IPKjHqGcxFlVhjLw48c
         WIXvYnZ9T92Bx/2nAZvi1QTujfIncwPa6YKEuuBLynGGRR8ijkKtNbIWF/HNNR/AVWEV
         YW7yXaAbepvnqKzfCDAW9pNDbEWLIM8eZ8qvepO3SauFRS4CuyFw8FrspJNuRlvxG5z/
         34tw==
X-Gm-Message-State: AOAM533KC08O+TimXSWBVgiZ2bNt/i80sFkNOnQJERE8qf5L3kMIy7AI
        HkDNasaFY3/wEUzpYJ3Fj1BDvw3Ep9v3NlSxvqZ8I4DfiPOFyw==
X-Google-Smtp-Source: ABdhPJylNo4XQ/898/+DK3rweqRiecQnjMAcb8QFHkeyGGniFxiaue7P6a0YuVngqZNcRlHWUFJhKuipYe5cs3lPE7E=
X-Received: by 2002:a05:6e02:20ca:: with SMTP id 10mr33113486ilq.246.1638790743290;
 Mon, 06 Dec 2021 03:39:03 -0800 (PST)
MIME-Version: 1.0
References: <20210315135545.132503808@linuxfoundation.org> <61abde5e.1c69fb81.474b3.97fbSMTPIN_ADDED_BROKEN@mx.google.com>
In-Reply-To: <61abde5e.1c69fb81.474b3.97fbSMTPIN_ADDED_BROKEN@mx.google.com>
From:   Art Nikpal <email2tema@gmail.com>
Date:   Mon, 6 Dec 2021 19:38:52 +0800
Message-ID: <CAKaHn9JCDNVY+8aua-TsM1Wp8q4Zz87w5WZ4h2yY66kU=ktNhg@mail.gmail.com>
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

On Sun, Dec 5, 2021 at 5:32 AM Jerome Brunet <jbrunet@baylibre.com> wrote:
>
> This reverts commit d66083c0d6f5125a4d982aa177dd71ab4cd3d212
> and commit d4ec1ffbdaa8939a208656e9c1440742c457ef16.
>
> On v5.10 stable, reboot gets stuck on gxl and g12a chip family (at least).
> This was tested on the aml-s905x-cc from libretch and the u200 reference
> design.

What about the rate ? it's 100% stuck for any reboot try !

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
