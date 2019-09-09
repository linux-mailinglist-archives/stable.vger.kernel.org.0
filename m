Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67E4BADD00
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 18:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389454AbfIIQXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 12:23:08 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:38858 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389271AbfIIQXI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 12:23:08 -0400
Received: by mail-ot1-f65.google.com with SMTP id h17so9200136otn.5
        for <stable@vger.kernel.org>; Mon, 09 Sep 2019 09:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Y5V4m4p94PsJz1eXNShESbNBiKSy11fpLV6SBZU7GQs=;
        b=McgtOk7zvnFYeyjzHNeTY0P7u3Oi9/K1EOXjYte2tEL8yqdDF7CpHOxGecKT+YAaK2
         ZIhrImDdGOQp1uP+dX68ZhHGygjrgvfw3xE++/qldATe9BLERiUY4/zFjq45BwJVmxMC
         WBanC9WZb3ugErmgIlVNwj+qOrYzit+nAsipPFL6J1tYpgy/iDWcR1MSFmgvE6XW+xBi
         3FO3E1vCZUzRnpDxdErV/FCDSuIcmp2vqAWcNtFmtHELnpuNYepus/eiMuzeONHQcPvU
         WZHgVA286yiWp6mRrPQWARq4LbTbCKhcvfKuBQfAP/IpDrMr/wGmvaHe0CN7kOWiTuDN
         M6ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Y5V4m4p94PsJz1eXNShESbNBiKSy11fpLV6SBZU7GQs=;
        b=FXNL/mqijXD/A1NPBOYYDxPgxcLN7yrreTlSJ+xqaJz7HT0rLBBQMeQ57s2XPqQpf9
         dhSJJjvZ9pNIFea/NYiQnMf0JlpZXHSNagqRIexblLXXAFFZaAmGt5hAoiMWUZS5cd0O
         bz6je9vrL4QUndvgS7K7mNmSm90CQ49D+rEp4Dc49dDlXG+P5+QPbs1R7b1sDGH2oOdk
         w6bpnFP6MFMjUCi8azIHdq02ExOs+aj656vSg0Qfi6FzuAcwmDSNMPNbRQ0yEInk1Dqd
         AlyJGuzEvwi2tLTWIeXiCRXJ8yeSo7xpv5xqYNcFuwo0dZajc+84Hvu9+CzwtT5+eqTK
         gy6g==
X-Gm-Message-State: APjAAAUdJLYdoXhlXCXxgj1HP2V5GQIiJfQOdMhGa8+L1iadS+LV9xdD
        xHVzuJXOQ0vTrJsh/uk9ZpPGL7PsTtE7r0kwa8G9LA==
X-Google-Smtp-Source: APXvYqy41BXc7ROWAqVe0r8Uh2i/7Qy5WAvA5KsUhiT1aXKk0iuMw41XOuqIJr8Um2egX5sWQhh3nRa2Mtjv9tXlgOY=
X-Received: by 2002:a9d:6d83:: with SMTP id x3mr19771774otp.263.1568046187131;
 Mon, 09 Sep 2019 09:23:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190908024800.23229-1-anarsoul@gmail.com> <CAKGbVbt056DyZHer1bKnAv8uBCX6zbsWeMjE6AQy8HYQf7L1wg@mail.gmail.com>
 <3263343.nbYvo8rMJO@diego>
In-Reply-To: <3263343.nbYvo8rMJO@diego>
From:   Vasily Khoruzhick <anarsoul@gmail.com>
Date:   Mon, 9 Sep 2019 09:23:08 -0700
Message-ID: <CA+E=qVfWYd8QdEi=h7JL=AVV+ehpP=GZ3cUsZ1Cbhh0O5xn1ng@mail.gmail.com>
Subject: Re: [Lima] [PATCH] drm/lima: fix lima_gem_wait() return value
To:     =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc:     lima@lists.freedesktop.org, Qiang Yu <yuq825@gmail.com>,
        David Airlie <airlied@linux.ie>, stable@vger.kernel.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 9, 2019 at 5:18 AM Heiko St=C3=BCbner <heiko@sntech.de> wrote:
>
> Hi Qiang,
>
> Am Montag, 9. September 2019, 04:30:43 CEST schrieb Qiang Yu:
> > Oh, I was miss leading by the drm_gem_reservation_object_wait
> > comments. Patch is:
> > Reviewed-by: Qiang Yu <yuq825@gmail.com>
> >
> > I'll apply this patch to drm-misc-next.
> >
> > Current kernel release is 5.3-rc8, is it too late for this fix to go
> > into the mainline 5.3 release?
> > I'd like to know how to apply this fix for current rc kernels, by
> > drm-misc-fixes? Can I push
> > to drm-misc-fixes by dim or I can only push to drm-misc-next and
> > drm-misc maintainer will
> > pick fixes from it to drm-misc-fixes?
>
> drm-misc-fixes gets merged into drm-misc-next by maintainers regularly,
> so I _think_ you should apply the fix-patch to drm-misc-fixes first.
> [I also always have to read the documentation ;-) ]
>
> In any case you might want to add a "Fixes: ....." tag as well as a
> "Cc: stable@vger.kernel.org" tag, so it can be backported to stable
> kernels if applicable.

Cc: stable is already here, but I think it still needs "Fixes: " tag.

Qiang, can you add it at your side or you want me to resend the patch?

>
> Heiko
>
> > On Sun, Sep 8, 2019 at 10:48 AM Vasily Khoruzhick <anarsoul@gmail.com> =
wrote:
> > >
> > > drm_gem_reservation_object_wait() returns 0 if it succeeds and -ETIME
> > > if it timeouts, but lima driver assumed that 0 is error.
> > >
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
> > > ---
> > >  drivers/gpu/drm/lima/lima_gem.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/gpu/drm/lima/lima_gem.c b/drivers/gpu/drm/lima/l=
ima_gem.c
> > > index 477c0f766663..b609dc030d6c 100644
> > > --- a/drivers/gpu/drm/lima/lima_gem.c
> > > +++ b/drivers/gpu/drm/lima/lima_gem.c
> > > @@ -342,7 +342,7 @@ int lima_gem_wait(struct drm_file *file, u32 hand=
le, u32 op, s64 timeout_ns)
> > >         timeout =3D drm_timeout_abs_to_jiffies(timeout_ns);
> > >
> > >         ret =3D drm_gem_reservation_object_wait(file, handle, write, =
timeout);
> > > -       if (ret =3D=3D 0)
> > > +       if (ret =3D=3D -ETIME)
> > >                 ret =3D timeout ? -ETIMEDOUT : -EBUSY;
> > >
> > >         return ret;
> > > --
> > > 2.23.0
> > >
> > _______________________________________________
> > lima mailing list
> > lima@lists.freedesktop.org
> > https://lists.freedesktop.org/mailman/listinfo/lima
>
>
>
>
