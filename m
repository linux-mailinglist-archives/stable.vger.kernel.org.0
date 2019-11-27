Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6894A10AB2D
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfK0H3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:29:24 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40364 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbfK0H3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:29:24 -0500
Received: by mail-ot1-f66.google.com with SMTP id m15so18304205otq.7
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 23:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=u8oUQFRZy3gf3+1yf0zkKS6+wd9DrvcbQ832mANUPWo=;
        b=S/SdAfsNtNo4n8om7tQ8ej8pWPma3kUq5jV16c0NRtI0d+7+cBogG4aHNIEOFRIssG
         DqNvD128D3m2Dw4hHw/EN5U0fY7Y+9+GVaZ2wbUCqpTFItYtg4m1gXzE3FX9kTacD0KE
         EzIgZ6gTcM/+yjIjDFAg0X7QxSA48QIcYpxEor2LIp5K7ip6lECTtMlDnVT8s6nRoVp+
         VxhuDmKkPxn3I7TnYd6R+VAn8Byx2sKZrpIKL570sT3n5WZFSaQVFQHvgbcQq0cs1w9V
         +idjzBgwlDMcXNa06M1IXARDreMzmjRFdZ6blxE8OrCksjV71MpuuONorciuI3YLPWrM
         CG6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=u8oUQFRZy3gf3+1yf0zkKS6+wd9DrvcbQ832mANUPWo=;
        b=M855EP2MAVcLqPIovlRmcIm65FqOvJbvFhNTgkr7YRLUF3wPG/VzyHKBus5vs/3017
         wOfBkFDur8HKurSmAgNe8CndTrrOYzVE/odbCiqk4BlrCe/KublaOvqBKx8xzBOueDDK
         2YQi+H91+rNDd4OUGDGbsxi1rigX/0k/nmea6EQzHxtmxxQDx/IjKBoDUUVYhqybp2rc
         eBrIWRPVELhMoZWgMwe9WJdiiG+78hwDkCLEayvk2XU21h3JzEFNstETqlI6l8YKZTqZ
         +f9vxYAC7V5jIhnOFPi+1LXAVeL+mdnsSc0KYfg87w8p/8+j0Ti35efD0fWUGyuR1jed
         kdtQ==
X-Gm-Message-State: APjAAAXXwTcoUE1VSXZyMsLfFccR2ngjE3PRlfbZrRhu1hpKLvZ+JCSA
        xFJMG0hsUJBS1H6yW3IYxUKFU0ihbxDMaQ78zW47n6aF
X-Google-Smtp-Source: APXvYqwUJpU+ywaP4+HdQDqIrP53KyP5oXj3UgopnsUkAWzWQFz8KbbiHHCui0ide4gn0Mof0rjjgxah85RHCbxbzM8=
X-Received: by 2002:a9d:65cd:: with SMTP id z13mr2544801oth.85.1574839762873;
 Tue, 26 Nov 2019 23:29:22 -0800 (PST)
MIME-Version: 1.0
References: <20191126193027.11970-1-jcmvbkbc@gmail.com>
In-Reply-To: <20191126193027.11970-1-jcmvbkbc@gmail.com>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Wed, 27 Nov 2019 08:29:12 +0100
Message-ID: <CAMpxmJV6qCGWKadeDyJLqCDtZ3zFBQAZ0yZuWkYiy3ZqWUFGiA@mail.gmail.com>
Subject: Re: [PATCH] drivers/gpio/gpio-xtensa: fix driver build
To:     Max Filippov <jcmvbkbc@gmail.com>
Cc:     linux-xtensa@linux-xtensa.org, Chris Zankel <chris@zankel.net>,
        linux-gpio <linux-gpio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Baruch Siach <baruch@tkos.co.il>,
        "Stable # 4 . 20+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

wt., 26 lis 2019 o 20:30 Max Filippov <jcmvbkbc@gmail.com> napisa=C5=82(a):
>
> Commit cad6fade6e78 ("xtensa: clean up WSR*/RSR*/get_sr/set_sr") removed
> {RSR,WSR}_CPENABLE from xtensa code, but did not fix up all users,
> breaking gpio-xtensa driver build.
> Update gpio-xtensa to use new xtensa_{get,set}_sr API.
>
> Cc: stable@vger.kernel.org # v5.0+
> Fixes: cad6fade6e78 ("xtensa: clean up WSR*/RSR*/get_sr/set_sr")
> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
> ---
>  drivers/gpio/gpio-xtensa.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpio/gpio-xtensa.c b/drivers/gpio/gpio-xtensa.c
> index 43d3fa5f511a..0fb2211f9573 100644
> --- a/drivers/gpio/gpio-xtensa.c
> +++ b/drivers/gpio/gpio-xtensa.c
> @@ -44,15 +44,14 @@ static inline unsigned long enable_cp(unsigned long *=
cpenable)
>         unsigned long flags;
>
>         local_irq_save(flags);
> -       RSR_CPENABLE(*cpenable);
> -       WSR_CPENABLE(*cpenable | BIT(XCHAL_CP_ID_XTIOP));
> -
> +       *cpenable =3D xtensa_get_sr(cpenable);
> +       xtensa_set_sr(*cpenable | BIT(XCHAL_CP_ID_XTIOP), cpenable);
>         return flags;
>  }
>
>  static inline void disable_cp(unsigned long flags, unsigned long cpenabl=
e)
>  {
> -       WSR_CPENABLE(cpenable);
> +       xtensa_set_sr(cpenable, cpenable);
>         local_irq_restore(flags);
>  }
>
> --
> 2.20.1
>

Patch applied, thanks!

Bart
