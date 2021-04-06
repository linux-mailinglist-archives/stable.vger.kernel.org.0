Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE214355520
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 15:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbhDFNaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 09:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232450AbhDFNaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 09:30:22 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D09C06175F
        for <stable@vger.kernel.org>; Tue,  6 Apr 2021 06:30:11 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id r17so5315496ilt.0
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 06:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zbkgM7EklYBgMqnsRgXu/OttXW0k5WuSVERLeYOfs6c=;
        b=YKa/dr0N4/hryeRJlHCpY30TWqqo7GaxNQfMYygCMtHN2eujpvjvFMIbxRxAEAOzrX
         IJuv5hzDc5ZXN+N87aAvcuy+cZ3Ljpezx/x5edPftTwLA3XImsRyBsG8vk/ViMTiMnO8
         6EzkJLq532/nm+WSEeyWkvZ7ZEiN+DRhbL2zE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zbkgM7EklYBgMqnsRgXu/OttXW0k5WuSVERLeYOfs6c=;
        b=TSJYjGuZMUHPcD0dU+6Xb4M3qGTseIN7qhsnP1CnYjsQ6SL7ka15WPrdiA/eiwdwyi
         ounIiAdcdGI1dH59NTx3ODan9TqSywa+LGso5SlgrgRa+XY251Ldtzc5zNy+LKAlZMV1
         11SgFfGN13Pg/cZj2pu7cAOHTPX/8baRa/hYeCsoOYPF/VxOKiq0ItQ/Q9OteDx85s7K
         dB9iO/McG4W46ET6//lq0v9FaNa+g5JYtQk0Tcwjo8FaE4ihCyJnT91otox3KOvYK92T
         qVnZmxQNGmxGOBfbCmvBpTV6AaKK6YqhAhFhOOfE3yFirZE0NR1CcAX1s/kBCp2bPQ9O
         Xw/Q==
X-Gm-Message-State: AOAM530mdrlFWjlo0450LxzAJzJvG9uRjlYzFrJhj+gXGA9ikj+XWPcB
        N0q3Sip4pbMiVYpog0UwuyvWdcitQKk+gA==
X-Google-Smtp-Source: ABdhPJzTB9/gHNx6WW7buJShPGj+6rIIFxYqSokuOZVd924pcse+XQXo+T6Z89UWBQ0J/tnh248O1Q==
X-Received: by 2002:a92:2c08:: with SMTP id t8mr23468577ile.72.1617715810740;
        Tue, 06 Apr 2021 06:30:10 -0700 (PDT)
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com. [209.85.166.52])
        by smtp.gmail.com with ESMTPSA id h193sm13843443iof.9.2021.04.06.06.30.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Apr 2021 06:30:09 -0700 (PDT)
Received: by mail-io1-f52.google.com with SMTP id b10so15546574iot.4
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 06:30:09 -0700 (PDT)
X-Received: by 2002:a6b:8ec2:: with SMTP id q185mr23730961iod.150.1617715808496;
 Tue, 06 Apr 2021 06:30:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210315123406.1523607-1-ribalda@chromium.org>
 <34c90095-bcbf-5530-786a-e709cc493fa9@linux.intel.com> <CANiDSCvMvYVN0+zN3du2pJfGLPJ_f7Ees2YrfybJgUDmBjq2jQ@mail.gmail.com>
 <db0bac15-01a1-5cc0-f72d-135ce5f9b788@linux.intel.com>
In-Reply-To: <db0bac15-01a1-5cc0-f72d-135ce5f9b788@linux.intel.com>
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Tue, 6 Apr 2021 15:29:57 +0200
X-Gmail-Original-Message-ID: <CANiDSCujua6DYbys7EF_Qgg4XskvG0qRDOrVmAvTpZDMFtzf9g@mail.gmail.com>
Message-ID: <CANiDSCujua6DYbys7EF_Qgg4XskvG0qRDOrVmAvTpZDMFtzf9g@mail.gmail.com>
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


Maybe you want to add your Reviewed-by ? ;)

Thanks!
On Wed, Mar 17, 2021 at 7:48 AM Bingbu Cao <bingbu.cao@linux.intel.com> wrote:
>
>
> On 3/17/21 1:50 AM, Ricardo Ribalda wrote:
> > Hi Bingbu
> >
> > Thanks for your review
> >
> > On Tue, Mar 16, 2021 at 12:29 PM Bingbu Cao <bingbu.cao@linux.intel.com> wrote:
> >>
> >> Hi, Ricardo
> >>
> >> Thanks for your patch.
> >> It looks fine for me, do you mind squash 2 patchsets into 1 commit?
> >
> > Are you sure? There are two different issues that we are solving.
>
> Oh, I see. I thought you were fixing 1 issue here.
> Thanks!
>
> >
> > Best regards!
> >
> >>
> >> On 3/15/21 8:34 PM, Ricardo Ribalda wrote:
> >>> We are losing the reference to an allocated memory if try. Change the
> >>> order of the check to avoid that.
> >>>
> >>> Cc: stable@vger.kernel.org
> >>> Fixes: 6d5f26f2e045 ("media: staging/intel-ipu3-v4l: reduce kernel stack usage")
> >>> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> >>> ---
> >>>  drivers/staging/media/ipu3/ipu3-v4l2.c | 11 +++++++----
> >>>  1 file changed, 7 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/drivers/staging/media/ipu3/ipu3-v4l2.c b/drivers/staging/media/ipu3/ipu3-v4l2.c
> >>> index 60aa02eb7d2a..35a74d99322f 100644
> >>> --- a/drivers/staging/media/ipu3/ipu3-v4l2.c
> >>> +++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
> >>> @@ -693,6 +693,13 @@ static int imgu_fmt(struct imgu_device *imgu, unsigned int pipe, int node,
> >>>               if (inode == IMGU_NODE_STAT_3A || inode == IMGU_NODE_PARAMS)
> >>>                       continue;
> >>>
> >>> +             /* CSS expects some format on OUT queue */
> >>> +             if (i != IPU3_CSS_QUEUE_OUT &&
> >>> +                 !imgu_pipe->nodes[inode].enabled) {
> >>> +                     fmts[i] = NULL;
> >>> +                     continue;
> >>> +             }
> >>> +
> >>>               if (try) {
> >>>                       fmts[i] = kmemdup(&imgu_pipe->nodes[inode].vdev_fmt.fmt.pix_mp,
> >>>                                         sizeof(struct v4l2_pix_format_mplane),
> >>> @@ -705,10 +712,6 @@ static int imgu_fmt(struct imgu_device *imgu, unsigned int pipe, int node,
> >>>                       fmts[i] = &imgu_pipe->nodes[inode].vdev_fmt.fmt.pix_mp;
> >>>               }
> >>>
> >>> -             /* CSS expects some format on OUT queue */
> >>> -             if (i != IPU3_CSS_QUEUE_OUT &&
> >>> -                 !imgu_pipe->nodes[inode].enabled)
> >>> -                     fmts[i] = NULL;
> >>>       }
> >>>
> >>>       if (!try) {
> >>>
> >>
> >> --
> >> Best regards,
> >> Bingbu Cao
> >
> >
> >
>
> --
> Best regards,
> Bingbu Cao



-- 
Ricardo Ribalda
