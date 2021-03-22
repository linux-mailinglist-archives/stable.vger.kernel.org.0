Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E2F343D3A
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 10:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhCVJvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 05:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhCVJur (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 22 Mar 2021 05:50:47 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542D6C061574
        for <Stable@vger.kernel.org>; Mon, 22 Mar 2021 02:50:47 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id a198so20227761lfd.7
        for <Stable@vger.kernel.org>; Mon, 22 Mar 2021 02:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SqyDcv3cJHFxDzjprtmEQDTZ+RyQB7KwQy3HXHyhF/4=;
        b=qiJrJgQPgMdjGzuurxDwGSXMKrmWcRI/RFAr/duKbfGr+AcAqdNzVXWXRTkEL1TTGT
         gAKZgKnAbRCx65l7aGYr+EFUXHMnjCMdUX6Co5+QweUxjgshNpjq+5NjXGETLc3u3knj
         64eXKpSKeH2rAxg+cOlqfAmrZJtQKYaj6aLeK7A47UUndlJtlvKV8Iuk89/E7hQb6Wxu
         NqWs8Z3scwkkNJU1lEcnNvx5X2QXH07kLeIMMKPfo2OCnSxbIA71Cy9zMkW1Gj/6jQi1
         90Lhq9tFcTcMvOKfyKdRbqdHTeRSykg0iP28LciARZJNeDye+P3fQwwneGvxBfjNPHwX
         ytxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SqyDcv3cJHFxDzjprtmEQDTZ+RyQB7KwQy3HXHyhF/4=;
        b=fCWB9BGw9gp0CxW/VvBmfgoyAefUokbfgQUEmIXXzbr69wqDGbS/E3d+tbafYCXrMV
         Qv/J41q6WIHlZNeduz9aIWGZ9kMhrijArsRZKh5qbcmkazuiTUfoXdpcs3Q+aZRWP5aQ
         pWOCoipSTXoh3wmJvd/R8zKWPkJr6Q02MoSVP6q2W8cYoTXICPqrPar4q57ATGHAIJoN
         snfqUa0MOt8ibTklo7+9foYdkDBOPqLoJpnTd0gJvtqrb4hnD/nr9LCE0tjVup/KFHUn
         P3d0ZDiTloS/eNa/5cGh+ILvgPd0wNUQkxmKEfrojRjIviEvnhR5/k7zOMbnfYcsPFug
         Wb3g==
X-Gm-Message-State: AOAM532oWI0uY63S94EM7e7IXPW6JF8bDPkaOvMgG9O6W8dvLqlOMWqO
        GQ9LiMpCYkZziNC7vox16B58VyYIz7ISw1UIfyt565T4
X-Google-Smtp-Source: ABdhPJzC7PTW1hzNuBWo/9sLUqXGCuyDy1WThM9FadPow+WSNQg7gL7RcyborwMDFcmWTNU8O8eSwVPViT3r2r1OW6M=
X-Received: by 2002:ac2:558d:: with SMTP id v13mr8319249lfg.582.1616406645861;
 Mon, 22 Mar 2021 02:50:45 -0700 (PDT)
MIME-Version: 1.0
References: <16158225222918@kroah.com>
In-Reply-To: <16158225222918@kroah.com>
From:   Wilfried Wessner <wilfried.wessner@gmail.com>
Date:   Mon, 22 Mar 2021 10:50:34 +0100
Message-ID: <CAMwq6HhA77EOVeN65YUXw4p+HO4SLj5HXGHVXwRPPBK3QfZ3sA@mail.gmail.com>
Subject: Re: patch "iio: adc: ad7949: fix wrong ADC result due to incorrect
 bit mask" added to staging-linus
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Charles-Antoine Couret <charles-antoine.couret@essensium.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

That is exciting news.

Thanks everybody!

Best regards,
Willi



On Mon, Mar 15, 2021 at 4:35 PM <gregkh@linuxfoundation.org> wrote:
>
>
> This is a note to let you know that I've just added the patch titled
>
>     iio: adc: ad7949: fix wrong ADC result due to incorrect bit mask
>
> to my staging git tree which can be found at
>     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> in the staging-linus branch.
>
> The patch will show up in the next release of the linux-next tree
> (usually sometime within the next 24 hours during the week.)
>
> The patch will hopefully also be merged in Linus's tree for the
> next -rc kernel release.
>
> If you have any questions about this process, please let me know.
>
>
> From f890987fac8153227258121740a9609668c427f3 Mon Sep 17 00:00:00 2001
> From: Wilfried Wessner <wilfried.wessner@gmail.com>
> Date: Mon, 8 Feb 2021 15:27:05 +0100
> Subject: iio: adc: ad7949: fix wrong ADC result due to incorrect bit mask
>
> Fixes a wrong bit mask used for the ADC's result, which was caused by an
> improper usage of the GENMASK() macro. The bits higher than ADC's
> resolution are undefined and if not masked out correctly, a wrong result
> can be given. The GENMASK() macro indexing is zero based, so the mask has
> to go from [resolution - 1 , 0].
>
> Fixes: 7f40e0614317f ("iio:adc:ad7949: Add AD7949 ADC driver family")
> Signed-off-by: Wilfried Wessner <wilfried.wessner@gmail.com>
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Reviewed-by: Charles-Antoine Couret <charles-antoine.couret@essensium.com>
> Cc: <Stable@vger.kernel.org>
> Link: https://lore.kernel.org/r/20210208142705.GA51260@ubuntu
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> ---
>  drivers/iio/adc/ad7949.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/iio/adc/ad7949.c b/drivers/iio/adc/ad7949.c
> index 5d597e5050f6..1b4b3203e428 100644
> --- a/drivers/iio/adc/ad7949.c
> +++ b/drivers/iio/adc/ad7949.c
> @@ -91,7 +91,7 @@ static int ad7949_spi_read_channel(struct ad7949_adc_chip *ad7949_adc, int *val,
>         int ret;
>         int i;
>         int bits_per_word = ad7949_adc->resolution;
> -       int mask = GENMASK(ad7949_adc->resolution, 0);
> +       int mask = GENMASK(ad7949_adc->resolution - 1, 0);
>         struct spi_message msg;
>         struct spi_transfer tx[] = {
>                 {
> --
> 2.30.2
>
>
