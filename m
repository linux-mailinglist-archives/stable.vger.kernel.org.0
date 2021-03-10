Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118EB3339C9
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 11:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhCJKQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 05:16:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbhCJKQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 05:16:43 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E378DC061761
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 02:16:42 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id n132so17334208iod.0
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 02:16:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YnjTlCzPSM64YPwZtIYFy5lAVDG5f9v4P0vMMvdQJ4g=;
        b=d0SaJGU+8Urml23wTMTDfhpGRRTwD+zpckGUZVMl+sVOy1WZYmEJ452QYDEt+HEMPH
         IgYQZsfm5TUykrsjmeIEmLfHZGFzcwLIgOiDgolB3dDU+UugpwZSaiyTCDiqkBCrQWWh
         l7f5WKbbFlEUefe7S8uASrebDK0rSAdB2PHd0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YnjTlCzPSM64YPwZtIYFy5lAVDG5f9v4P0vMMvdQJ4g=;
        b=B5G00sbMNzZ6qZLIR+Yq43uhQWdlLOmw2f9ZVop7IPx3kLcUSUy/jPRf5NzUFOni8p
         kN1yfq3Qg8PnJIohRI7ww4Mp4w+74P4f/Gx49g2OvltPAf6yCcr6mChy9j8iRybZK6z1
         baMIuhToA6H9PABu6a9MyeJ9JOxQaKoO2sleZnL7IutPm0HZAJxLjvpgz4gZqM3OFCuI
         ywQeEkm67WTX9+95+V8SHyvGpeRo2zd00m2nzwVzemB6w21hPkHvbV69vA09sZfUcPDu
         r6qzYyA9JrTUXPSFzQX2y5YxrlcTK7wOibvnehu+SkYt/ISgJsetARH6a3v846kd7aee
         tNhg==
X-Gm-Message-State: AOAM533Md/zIHPYtkt5bFk/ob9lTXcZi74u+lH+mf0XPqXI1Yh1cSJQY
        9LFDvQbnOO/whf8rD1nRAyd9L78gx7cfb+7R
X-Google-Smtp-Source: ABdhPJxi7n1jyO+1mtpXAjT+Cy2PNKnj2Tm/Orn6hDZOrQjtHKKQnhob8XAwS/p+azBh5qiJuv1xPA==
X-Received: by 2002:a05:6638:58f:: with SMTP id a15mr2205132jar.35.1615371402081;
        Wed, 10 Mar 2021 02:16:42 -0800 (PST)
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com. [209.85.166.180])
        by smtp.gmail.com with ESMTPSA id i3sm8679877ioq.13.2021.03.10.02.16.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 02:16:41 -0800 (PST)
Received: by mail-il1-f180.google.com with SMTP id b5so15018898ilq.10
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 02:16:41 -0800 (PST)
X-Received: by 2002:a05:6e02:194e:: with SMTP id x14mr2059514ilu.218.1615371400880;
 Wed, 10 Mar 2021 02:16:40 -0800 (PST)
MIME-Version: 1.0
References: <20210309234317.1021588-1-ribalda@chromium.org>
 <YEh6AIQPa75MzP+8@pendragon.ideasonboard.com> <CANiDSCuz76q0Ukq5UfrgeRH_JFWKQ9hCpMqZTHUtiwHxpEd4oQ@mail.gmail.com>
 <YEh/ZsfC34+aGI0Q@pendragon.ideasonboard.com>
In-Reply-To: <YEh/ZsfC34+aGI0Q@pendragon.ideasonboard.com>
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Wed, 10 Mar 2021 11:16:30 +0100
X-Gmail-Original-Message-ID: <CANiDSCv7q1iY=QrtG2ssC_Y1Z1EiiWegfXmd=ha-=2vmngW_dQ@mail.gmail.com>
Message-ID: <CANiDSCv7q1iY=QrtG2ssC_Y1Z1EiiWegfXmd=ha-=2vmngW_dQ@mail.gmail.com>
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

On Wed, Mar 10, 2021 at 9:12 AM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Ricardo,
>
> On Wed, Mar 10, 2021 at 08:58:39AM +0100, Ricardo Ribalda wrote:
> > On Wed, Mar 10, 2021 at 8:49 AM Laurent Pinchart wrote:
> > > On Wed, Mar 10, 2021 at 12:43:17AM +0100, Ricardo Ribalda wrote:
> > > > The plane_length is an unsigned integer. So, if we have a size of
> > > > 0xffffffff bytes we incorrectly allocate 0 bytes instead of 1 << 32.
> > > >
> > > > Cc: stable@vger.kernel.org
> > > > Fixes: 7f8414594e47 ("[media] media: videobuf2: fix the length check for mmap")
> > > > Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> > > > ---
> > > >  drivers/media/common/videobuf2/videobuf2-core.c | 4 +++-
> > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> > > > index 02281d13505f..543da515c761 100644
> > > > --- a/drivers/media/common/videobuf2/videobuf2-core.c
> > > > +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> > > > @@ -223,8 +223,10 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
> > > >        * NOTE: mmapped areas should be page aligned
> > > >        */
> > > >       for (plane = 0; plane < vb->num_planes; ++plane) {
> > > > +             unsigned long size = vb->planes[plane].length;
> > >
> > > unsigned long is still 32-bit on 32-bit platforms.
> > >
> > > > +
> > > >               /* Memops alloc requires size to be page aligned. */
> > > > -             unsigned long size = PAGE_ALIGN(vb->planes[plane].length);
> > > > +             size = PAGE_ALIGN(size);
> > > >
> > > >               /* Did it wrap around? */
> > > >               if (size < vb->planes[plane].length)
> > >
> > > Doesn't this address the issue already ?
> >
> > Yes and no. If you need to allocate 0xffffffff you are still affected
> > by the underrun. The core will return an error instead of doing the
> > allocation.
> >
> > (yes, I know it is a lot of memory for a buffer)
>
> That's my point, I don't think there's a need for this :-) Especially
> with v4l2_buffer.m.offset being a __u32, we are limited to 4GB for *all*
> buffers.

I guess I will convert this patch into a documentation patch, so we
explicitly know the limit of the API
(1<<32 - PAGE_SIZE).

Thanks!

>
> --
> Regards,
>
> Laurent Pinchart



-- 
Ricardo Ribalda
