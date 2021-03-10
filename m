Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA6E3336D3
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 08:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhCJH66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 02:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhCJH6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 02:58:52 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7DDC06174A
        for <stable@vger.kernel.org>; Tue,  9 Mar 2021 23:58:51 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id 81so16908166iou.11
        for <stable@vger.kernel.org>; Tue, 09 Mar 2021 23:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dDHfNc51CgldvtatwYM1lsSynRkGjuxm5k6/u6903Hc=;
        b=Qa2MtGNuff4eyItegNCe7pu9ngKvR9dshCz/I7c2oaf78qW2wnFYIiIdGrpy3JFSbq
         C71/jB3QMs8q+hLb1YEDkUpH/reUoqF4wY6aTgDCyEFkmnlJK2IAtm1jkz8z/XlTp+Cu
         CSHff+giLmF6zKKWiF4hLe1RNHitXgSL7mQ3w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dDHfNc51CgldvtatwYM1lsSynRkGjuxm5k6/u6903Hc=;
        b=d3mE1pjrqf84pqsojXe7FE0sgxV5l2cfPH7MAhtC7bGEWsmc/WzqCkn4Plr73pHuV0
         HHzQNwMFE3VEVjQ+BVczZU9DtUUwH+7QwRjkWb/yMO54QTS1bH1FJ9gUeM8BmRQTLc1k
         0EHt+KkzyWB18Z74ukfkfMPPZIfrV3LQNJD2c12eXxVKQZI6THg4LyOmloO1hMI4Ed+W
         p6VgO10HsslnYkDEN1GkD9i9s+5knlUGQP3SwCCLaZmIEciTGqjm/vsxpUERHoLAMD1x
         bBaKrwllIw8zD7pG4sHMiK+PsG43/rDmnVoqj2HMnvfX6yMH9XSGzV/A2HEX5hWdTqmH
         5Qww==
X-Gm-Message-State: AOAM532jLKTjLuYWLBjl0Fkvudg2iQLsfVbY6DIQoe3+F9oCHozcvgNU
        Ya+A8U5VJG+NDTvVhN+1Kaj7hN/awT7VhZXC
X-Google-Smtp-Source: ABdhPJxDtWYZINSh4fhg6Wdjpgb7SlFtaXWKuhqpb8qFEss5r/yc914sf1B7GqL0h0SyWIbSu7Tl5w==
X-Received: by 2002:a02:aa92:: with SMTP id u18mr1905238jai.119.1615363130880;
        Tue, 09 Mar 2021 23:58:50 -0800 (PST)
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com. [209.85.166.172])
        by smtp.gmail.com with ESMTPSA id q207sm8580238iod.6.2021.03.09.23.58.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 23:58:50 -0800 (PST)
Received: by mail-il1-f172.google.com with SMTP id e7so14698645ile.7
        for <stable@vger.kernel.org>; Tue, 09 Mar 2021 23:58:50 -0800 (PST)
X-Received: by 2002:a92:3648:: with SMTP id d8mr1614657ilf.69.1615363129930;
 Tue, 09 Mar 2021 23:58:49 -0800 (PST)
MIME-Version: 1.0
References: <20210309234317.1021588-1-ribalda@chromium.org> <YEh6AIQPa75MzP+8@pendragon.ideasonboard.com>
In-Reply-To: <YEh6AIQPa75MzP+8@pendragon.ideasonboard.com>
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Wed, 10 Mar 2021 08:58:39 +0100
X-Gmail-Original-Message-ID: <CANiDSCuz76q0Ukq5UfrgeRH_JFWKQ9hCpMqZTHUtiwHxpEd4oQ@mail.gmail.com>
Message-ID: <CANiDSCuz76q0Ukq5UfrgeRH_JFWKQ9hCpMqZTHUtiwHxpEd4oQ@mail.gmail.com>
Subject: Re: [PATCH] media: videobuf2: Fix integer overrun in allocation
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Tomasz Figa <tfiga@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Laurent

On Wed, Mar 10, 2021 at 8:49 AM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Ricardo,
>
> Thank you for the patch.
Thank you!
>
> On Wed, Mar 10, 2021 at 12:43:17AM +0100, Ricardo Ribalda wrote:
> > The plane_length is an unsigned integer. So, if we have a size of
> > 0xffffffff bytes we incorrectly allocate 0 bytes instead of 1 << 32.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 7f8414594e47 ("[media] media: videobuf2: fix the length check for mmap")
> > Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> > ---
> >  drivers/media/common/videobuf2/videobuf2-core.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> > index 02281d13505f..543da515c761 100644
> > --- a/drivers/media/common/videobuf2/videobuf2-core.c
> > +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> > @@ -223,8 +223,10 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
> >        * NOTE: mmapped areas should be page aligned
> >        */
> >       for (plane = 0; plane < vb->num_planes; ++plane) {
> > +             unsigned long size = vb->planes[plane].length;
>
> unsigned long is still 32-bit on 32-bit platforms.
>
> > +
> >               /* Memops alloc requires size to be page aligned. */
> > -             unsigned long size = PAGE_ALIGN(vb->planes[plane].length);
> > +             size = PAGE_ALIGN(size);
> >
> >               /* Did it wrap around? */
> >               if (size < vb->planes[plane].length)
>
> Doesn't this address the issue already ?

Yes and no. If you need to allocate 0xffffffff you are still affected
by the underrun. The core will return an error instead of doing the
allocation.

(yes, I know it is a lot of memory for a buffer)

>
>
> --
> Regards,
>
> Laurent Pinchart



-- 
Ricardo Ribalda
