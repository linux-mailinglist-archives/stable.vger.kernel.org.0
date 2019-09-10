Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70F29AE1DB
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 03:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391061AbfIJBRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 21:17:01 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:45065 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391048AbfIJBRB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 21:17:01 -0400
Received: by mail-io1-f66.google.com with SMTP id f12so33581302iog.12
        for <stable@vger.kernel.org>; Mon, 09 Sep 2019 18:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fg07MweLHH4wwPyRQaIsuq/bTMsYPypgSVQcw/P+MR0=;
        b=h7VXX4xJlyJnzFkKo+dr0BzEin5+6/viDKTQYzDMLynP0Nez9ia4CzqgR8UELh+wuU
         4OXshvpNw2uLG784aBIaeo+KpiEcByJ8FKAYe4PU+gu2/czPplW+U941caT0RC3QVwvv
         U/KXBYQgzeN90M+y+T2pb5VVxY2rbWES54at95Xowh4HbYwYiQMLiQtvOgteW3Fq3zA6
         mzZckfTOJnq0XASKg0BvPJe1EWW7UE1jvIU+FnLHt/WKAfQnrxk9Z+zF1jG4m7DrFxxC
         aR92Z++Gj9EKPV2vCMp1dOFsJWq9wBQ65g93zewuehBfwKvvgmkPMD/jX4MaBcd0B+co
         ujQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fg07MweLHH4wwPyRQaIsuq/bTMsYPypgSVQcw/P+MR0=;
        b=tYsuf/Y27gzn9vMXkk9+kSMKdyMe0UymgewMFZfWvaeZhiF88xWkGb0nnBP7BiGOT1
         3mi/b0SW3MnYbNkgSn3hzgMD5YLWlcnDMImMxla5FXlul2ke4lbt1ONRVyEK7YAP2Abp
         dzVVfJC2By8Veb6GHrmYYZFpTEux9fIMpg3XCKjl6vwKN92CAeQ1Pq/eWAVqB5XTD5rE
         Jc2iF2UG+10kwe+WiiNmUXA2Ks90BZ4DXE9NNqPdw6jbLnNJQILVHN8cMC81RcRwgHaW
         4W0yxB3reWMHMcVgXP8NtqPXHsxpeIJQzTHZoOad6ghvOOfcYhgz/LDX6GIx5Rv6iN7C
         WY/w==
X-Gm-Message-State: APjAAAWPvUeCuucm6WKfoEWsd+OBJN9erpUJaRMVQz7SApCUoZx/GUeo
        jZ6p8JpbHD/u+3Kh4LU3IIQBSvE7vnisTJC7yNs=
X-Google-Smtp-Source: APXvYqwZLqBFcmbEZwhjb9lNyCjHpoASHU6acW71ZcdmWqXHot1wHyGGIn4FaToWl3Rdc/vej10yEYc7PCqksQO+J8s=
X-Received: by 2002:a02:ad0e:: with SMTP id s14mr28514301jan.97.1568078219833;
 Mon, 09 Sep 2019 18:16:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190908024800.23229-1-anarsoul@gmail.com> <CAKGbVbt056DyZHer1bKnAv8uBCX6zbsWeMjE6AQy8HYQf7L1wg@mail.gmail.com>
 <3263343.nbYvo8rMJO@diego> <CA+E=qVfWYd8QdEi=h7JL=AVV+ehpP=GZ3cUsZ1Cbhh0O5xn1ng@mail.gmail.com>
In-Reply-To: <CA+E=qVfWYd8QdEi=h7JL=AVV+ehpP=GZ3cUsZ1Cbhh0O5xn1ng@mail.gmail.com>
From:   Qiang Yu <yuq825@gmail.com>
Date:   Tue, 10 Sep 2019 09:16:48 +0800
Message-ID: <CAKGbVbskXmWJOrRWOSJ2f1dN7VAKTosLmYEA_n6fn+AjQnBj9Q@mail.gmail.com>
Subject: Re: [Lima] [PATCH] drm/lima: fix lima_gem_wait() return value
To:     Vasily Khoruzhick <anarsoul@gmail.com>
Cc:     =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        lima@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        stable@vger.kernel.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks Heiko, I'll push this patch to drm-misc-fixes.

I can add the Fixes tag before push.

Thanks,
Qiang

On Tue, Sep 10, 2019 at 12:23 AM Vasily Khoruzhick <anarsoul@gmail.com> wro=
te:
>
> On Mon, Sep 9, 2019 at 5:18 AM Heiko St=C3=BCbner <heiko@sntech.de> wrote=
:
> >
> > Hi Qiang,
> >
> > Am Montag, 9. September 2019, 04:30:43 CEST schrieb Qiang Yu:
> > > Oh, I was miss leading by the drm_gem_reservation_object_wait
> > > comments. Patch is:
> > > Reviewed-by: Qiang Yu <yuq825@gmail.com>
> > >
> > > I'll apply this patch to drm-misc-next.
> > >
> > > Current kernel release is 5.3-rc8, is it too late for this fix to go
> > > into the mainline 5.3 release?
> > > I'd like to know how to apply this fix for current rc kernels, by
> > > drm-misc-fixes? Can I push
> > > to drm-misc-fixes by dim or I can only push to drm-misc-next and
> > > drm-misc maintainer will
> > > pick fixes from it to drm-misc-fixes?
> >
> > drm-misc-fixes gets merged into drm-misc-next by maintainers regularly,
> > so I _think_ you should apply the fix-patch to drm-misc-fixes first.
> > [I also always have to read the documentation ;-) ]
> >
> > In any case you might want to add a "Fixes: ....." tag as well as a
> > "Cc: stable@vger.kernel.org" tag, so it can be backported to stable
> > kernels if applicable.
>
> Cc: stable is already here, but I think it still needs "Fixes: " tag.
>
> Qiang, can you add it at your side or you want me to resend the patch?
>
> >
> > Heiko
> >
> > > On Sun, Sep 8, 2019 at 10:48 AM Vasily Khoruzhick <anarsoul@gmail.com=
> wrote:
> > > >
> > > > drm_gem_reservation_object_wait() returns 0 if it succeeds and -ETI=
ME
> > > > if it timeouts, but lima driver assumed that 0 is error.
> > > >
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
> > > > ---
> > > >  drivers/gpu/drm/lima/lima_gem.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/gpu/drm/lima/lima_gem.c b/drivers/gpu/drm/lima=
/lima_gem.c
> > > > index 477c0f766663..b609dc030d6c 100644
> > > > --- a/drivers/gpu/drm/lima/lima_gem.c
> > > > +++ b/drivers/gpu/drm/lima/lima_gem.c
> > > > @@ -342,7 +342,7 @@ int lima_gem_wait(struct drm_file *file, u32 ha=
ndle, u32 op, s64 timeout_ns)
> > > >         timeout =3D drm_timeout_abs_to_jiffies(timeout_ns);
> > > >
> > > >         ret =3D drm_gem_reservation_object_wait(file, handle, write=
, timeout);
> > > > -       if (ret =3D=3D 0)
> > > > +       if (ret =3D=3D -ETIME)
> > > >                 ret =3D timeout ? -ETIMEDOUT : -EBUSY;
> > > >
> > > >         return ret;
> > > > --
> > > > 2.23.0
> > > >
> > > _______________________________________________
> > > lima mailing list
> > > lima@lists.freedesktop.org
> > > https://lists.freedesktop.org/mailman/listinfo/lima
> >
> >
> >
> >
