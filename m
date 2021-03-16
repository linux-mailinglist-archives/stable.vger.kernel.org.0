Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9ED33DB66
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 18:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbhCPRvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 13:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233255AbhCPRug (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 13:50:36 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C40C06174A
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 10:50:35 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id y20so19792247iot.4
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 10:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JtrNAHIlNGqyu7tY2KgHDa90TRR2iABoGQSIvstGdZs=;
        b=kN4jETKpOsMT8ujABTKX/KoA1MUTlDRb+Z9NHUYVnpAh0syYrBtdaNgzA3IIHB602i
         HsTlTbMAjEyLIPblDWQdvaFB6Q6U8xj7Wm6Qa/UJmkrU/ZRuins9KWZSKS1KwDBsxG0K
         uk71bJAwFyqxS1ex5mOipRhoh7DVGXgqio8WQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JtrNAHIlNGqyu7tY2KgHDa90TRR2iABoGQSIvstGdZs=;
        b=dCrv7H/8W4ar4o8tVmCjkO4SgnO6iTlCp7RvozVbbifeDPgkMahbM6lJXS2viuboWO
         lhAdzvzJjQ9iOYIFNlAB/FN0m21Jz318Ve4WgSy5qzLxG5QlH4HHai9Y7MgNCbfPX8eR
         PP7r2xn5sajH6wpSltsPNt7hBUnGilQ4PH0mnJjYyguoDugSqwu3Ydko/dbMU413u1RM
         VBvMg71suCZlcEod1J3gP3DmCHAHi2Fkoe29hRK/CKTXUaq6EkXjqHcnWrhVwDkEcOcw
         LeKQ0Xcjyh7prv2Xbz/z7EjdO+XrG/MXRxkazs0VHouMXlW2qAz/yF9qwtpqg0UhXYSl
         Qzgg==
X-Gm-Message-State: AOAM530KDaySGYgj8QO5rjADIQycATWcZEZH4hzFBqOH85ciL3IokIIO
        T6exzd69bDKOKgeQX2iDv6aO2U5x230+kQ==
X-Google-Smtp-Source: ABdhPJwf3tQVDo/EPiXYqgu14x+HWyBNoo/tCa5nKiq3yQhkZ3CoQXa9Plj6UR2EFOVDesUfIzCrYw==
X-Received: by 2002:a6b:5112:: with SMTP id f18mr4313107iob.196.1615917034127;
        Tue, 16 Mar 2021 10:50:34 -0700 (PDT)
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com. [209.85.166.44])
        by smtp.gmail.com with ESMTPSA id g14sm8851941ioc.38.2021.03.16.10.50.32
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 10:50:33 -0700 (PDT)
Received: by mail-io1-f44.google.com with SMTP id n132so38138745iod.0
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 10:50:32 -0700 (PDT)
X-Received: by 2002:a02:cb4b:: with SMTP id k11mr15230940jap.144.1615917032400;
 Tue, 16 Mar 2021 10:50:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210315123406.1523607-1-ribalda@chromium.org> <34c90095-bcbf-5530-786a-e709cc493fa9@linux.intel.com>
In-Reply-To: <34c90095-bcbf-5530-786a-e709cc493fa9@linux.intel.com>
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Tue, 16 Mar 2021 18:50:20 +0100
X-Gmail-Original-Message-ID: <CANiDSCvMvYVN0+zN3du2pJfGLPJ_f7Ees2YrfybJgUDmBjq2jQ@mail.gmail.com>
Message-ID: <CANiDSCvMvYVN0+zN3du2pJfGLPJ_f7Ees2YrfybJgUDmBjq2jQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] media: staging/intel-ipu3: Fix memory leak in imu_fmt
To:     Bingbu Cao <bingbu.cao@linux.intel.com>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Tianshu Qiu <tian.shu.qiu@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Bingbu

Thanks for your review

On Tue, Mar 16, 2021 at 12:29 PM Bingbu Cao <bingbu.cao@linux.intel.com> wrote:
>
> Hi, Ricardo
>
> Thanks for your patch.
> It looks fine for me, do you mind squash 2 patchsets into 1 commit?

Are you sure? There are two different issues that we are solving.

Best regards!

>
> On 3/15/21 8:34 PM, Ricardo Ribalda wrote:
> > We are losing the reference to an allocated memory if try. Change the
> > order of the check to avoid that.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 6d5f26f2e045 ("media: staging/intel-ipu3-v4l: reduce kernel stack usage")
> > Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> > ---
> >  drivers/staging/media/ipu3/ipu3-v4l2.c | 11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/staging/media/ipu3/ipu3-v4l2.c b/drivers/staging/media/ipu3/ipu3-v4l2.c
> > index 60aa02eb7d2a..35a74d99322f 100644
> > --- a/drivers/staging/media/ipu3/ipu3-v4l2.c
> > +++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
> > @@ -693,6 +693,13 @@ static int imgu_fmt(struct imgu_device *imgu, unsigned int pipe, int node,
> >               if (inode == IMGU_NODE_STAT_3A || inode == IMGU_NODE_PARAMS)
> >                       continue;
> >
> > +             /* CSS expects some format on OUT queue */
> > +             if (i != IPU3_CSS_QUEUE_OUT &&
> > +                 !imgu_pipe->nodes[inode].enabled) {
> > +                     fmts[i] = NULL;
> > +                     continue;
> > +             }
> > +
> >               if (try) {
> >                       fmts[i] = kmemdup(&imgu_pipe->nodes[inode].vdev_fmt.fmt.pix_mp,
> >                                         sizeof(struct v4l2_pix_format_mplane),
> > @@ -705,10 +712,6 @@ static int imgu_fmt(struct imgu_device *imgu, unsigned int pipe, int node,
> >                       fmts[i] = &imgu_pipe->nodes[inode].vdev_fmt.fmt.pix_mp;
> >               }
> >
> > -             /* CSS expects some format on OUT queue */
> > -             if (i != IPU3_CSS_QUEUE_OUT &&
> > -                 !imgu_pipe->nodes[inode].enabled)
> > -                     fmts[i] = NULL;
> >       }
> >
> >       if (!try) {
> >
>
> --
> Best regards,
> Bingbu Cao



-- 
Ricardo Ribalda
