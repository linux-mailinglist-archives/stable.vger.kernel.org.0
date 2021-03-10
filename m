Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3257433453D
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 18:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhCJRgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 12:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhCJRgX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 12:36:23 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0C2C061761
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 09:36:22 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id p1so29329867edy.2
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 09:36:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o0qx1P3+0pCBpzbRfl6S1GiH0ttn2Cr7Rfh1TFUYrhQ=;
        b=Uja17BIpkiNfpDNxhJMmLhmb8CGjis7QUU3NcZ4/f3U1Qn5cTg6ox4jcC5tq0n/EN3
         ykXWeo9+ZXtwb/CXKbssqJu33xOUSyOYr8gfiXneu/zi5M/TT9zLlIEGTsglPgNCdUf5
         Lv1PaJZve5bvCaVruzXelkNouHd120Qv+4/EPbWqN/gPHtpT4eYiUHTosynuYl3GieVJ
         29tBxIFl4NPkAQiPp18tq5V/UqxxeL6Jp7Wk7oTvUAdwpLRc9cLrh1p96GkY03RDMF0U
         2ghfmrdoYKBzr5VmuHmY+Z3Fxl6hO7gP6BP+VvwxTZlBJ0rjAF++t45lqY3dmRwVC/jh
         iaGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o0qx1P3+0pCBpzbRfl6S1GiH0ttn2Cr7Rfh1TFUYrhQ=;
        b=bYL/NtIq/QOTg1btlbiYgIhU7c7UiFD4hG+nPlWASe408MnQDypZurUG/luKUQyh4J
         0/6e/4qYhaTWBGfWV30BFQMGrLj0/6Rn/U+5ZMuUIZxQ3ZpOD1V73/LT715o1R8xSNoY
         8WrnevZVm1WEEJyl65jmtWOZq9y6SQbJaVDj0R7qDGp1etdwTOGQztvZ9xFXzV35QM2/
         InF+QtxvoFplojMaJM4G496ujvDmnw5KKrm+oN8Qvi5WnX+rQlFHRlUmi6EEytaFfhMx
         kA5kRrl4+FtqYvgT0NQgrBkMllUzR7sxaVexao2Wuh1/LYetRbTjn4p+sxRKtYUHh3cj
         D+sg==
X-Gm-Message-State: AOAM531RnJFH04pvh28It+JRdvACFXenYOyigYGeGZs6vI+ru6aynDfH
        vHAwvgLro4gmyy0yuj/20Pa1VjhojQ9SEGKLwweGFw==
X-Google-Smtp-Source: ABdhPJxuJpOuewGAFdUepGTu6BAQ6RHOh3x6zUiz5X50hVjX0yh0BlB9XEQck/Z2EiEIxaMK0K9YPFqJ7FPp+5UJUtc=
X-Received: by 2002:aa7:c3cd:: with SMTP id l13mr4530827edr.52.1615397780739;
 Wed, 10 Mar 2021 09:36:20 -0800 (PST)
MIME-Version: 1.0
References: <20210310132321.948258062@linuxfoundation.org> <20210310132322.413240905@linuxfoundation.org>
In-Reply-To: <20210310132322.413240905@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 10 Mar 2021 23:06:09 +0530
Message-ID: <CA+G9fYthEr7TtFBpAXxQfDtwxCe+qg=bbE74nPQ+mpGmSSJ2dw@mail.gmail.com>
Subject: Re: [PATCH 5.10 14/49] net: ipa: ignore CHANNEL_NOT_RUNNING errors
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>, Alex Elder <elder@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Mar 2021 at 18:56, <gregkh@linuxfoundation.org> wrote:
>
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> From: Alex Elder <elder@linaro.org>
>
> [ Upstream commit f849afcc8c3b27d7b50827e95b60557f24184df0 ]
>
> IPA v4.2 has a hardware quirk that requires the AP to allocate GSI
> channels for the modem to use.  It is recommended that these modem
> channels get stopped (with a HALT generic command) by the AP when
> its IPA driver gets removed.
>
> The AP has no way of knowing the current state of a modem channel.
> So when the IPA driver issues a HALT command it's possible the
> channel is not running, and in that case we get an error indication.
> This error simply means we didn't need to stop the channel, so we
> can ignore it.
>
> This patch adds an explanation for this situation, and arranges for
> this condition to *not* report an error message.
>
> Signed-off-by: Alex Elder <elder@linaro.org>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/ipa/gsi.c | 24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
> index 2a65efd3e8da..48ee43b89fec 100644
> --- a/drivers/net/ipa/gsi.c
> +++ b/drivers/net/ipa/gsi.c
> @@ -1052,10 +1052,32 @@ static void gsi_isr_gp_int1(struct gsi *gsi)
>         u32 result;
>         u32 val;
>
> +       /* This interrupt is used to handle completions of the two GENERIC
> +        * GSI commands.  We use these to allocate and halt channels on
> +        * the modem's behalf due to a hardware quirk on IPA v4.2.  Once
> +        * allocated, the modem "owns" these channels, and as a result we
> +        * have no way of knowing the channel's state at any given time.
> +        *
> +        * It is recommended that we halt the modem channels we allocated
> +        * when shutting down, but it's possible the channel isn't running
> +        * at the time we issue the HALT command.  We'll get an error in
> +        * that case, but it's harmless (the channel is already halted).
> +        *
> +        * For this reason, we silently ignore a CHANNEL_NOT_RUNNING error
> +        * if we receive it.
> +        */
>         val = ioread32(gsi->virt + GSI_CNTXT_SCRATCH_0_OFFSET);
>         result = u32_get_bits(val, GENERIC_EE_RESULT_FMASK);
> -       if (result != GENERIC_EE_SUCCESS_FVAL)
> +
> +       switch (result) {
> +       case GENERIC_EE_SUCCESS_FVAL:
> +       case GENERIC_EE_CHANNEL_NOT_RUNNING_FVAL:


While building stable rc 5.10 for arm64 the build failed due to
the following errors / warnings.

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=arm64
CROSS_COMPILE=aarch64-linux-gnu- 'HOSTCC=sccache clang' 'CC=sccache
clang'
drivers/net/ipa/gsi.c:1074:7: error: use of undeclared identifier
'GENERIC_EE_CHANNEL_NOT_RUNNING_FVAL'
        case GENERIC_EE_CHANNEL_NOT_RUNNING_FVAL:
             ^
1 error generated.
make[4]: *** [scripts/Makefile.build:279: drivers/net/ipa/gsi.o] Error 1

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log link,
https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1086862412#L210

-- 
Linaro LKFT
https://lkft.linaro.org
