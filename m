Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9D8379127
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 16:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhEJOpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 10:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233578AbhEJOnC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 10:43:02 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0870BC08EACA
        for <stable@vger.kernel.org>; Mon, 10 May 2021 07:01:50 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id w4so20935155ljw.9
        for <stable@vger.kernel.org>; Mon, 10 May 2021 07:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DQsuL10ttGgvUSSdwEEABCcNLhZF92QzGWTDfsTdZC0=;
        b=qNtWaLjGIXQMeTIChrMNYPp2/WjHnGPearQQprE05w3lsIY390FY2r1cFDsNdyxCNZ
         jrXtwIa2MpTAokF2DjIfBEnGEnFcNeKYhs/jcoPOwoWKck8/JKhBYwPkLF+7hPxoCSie
         WvdtEleVqiDOuLhvesR3tOU4j8ErY0Hxzn6dCO2MZ8Pr0I7BabiZpd1qQwKAE/+hxSY3
         nknoLINClx20aEJImVjqx37XthuTT1uHfzMX2Tt5c37QBi00j991nCh0BrlPoRevPo55
         I4W84RAKkx+qkHsUG7mmdZpFhUW4jCYGkFJ0Nxhg+ZFFjj6pOIzn5jPKD89sKNyn1/xB
         z6kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DQsuL10ttGgvUSSdwEEABCcNLhZF92QzGWTDfsTdZC0=;
        b=XHcefB0UdgEJKTTc6/6LBpmEv4z7EvkLCR1cnI+6vfKJHoHQGeesstsqwzj98eQHa9
         dOQ0cC0fhhFjo7K02Q/MU8g6wrf2UuLwRhlT92+XMJFssR1yVDzlqjpcuJP4hq1afDqG
         sVi6cbuwNlZaWgltNuUV5YkpGjjuZAHwedAB9mBeXQxEVjreoxttEU0FyrJ4LglwIlfq
         PjFhnYo1ykcaYLS7NOI1fNdJf5rtERirtyLoyRFndnf55ywzJYSxSdatsqrKLpoR1ygU
         iqbrd2ki8fN0XzUvd319Q0JlBcNybkgAzsxUFTapm4o5iPasq1x6kZIhZroKq/clsvoc
         XAmA==
X-Gm-Message-State: AOAM530rYGtiNXLSBQ2uyttLmgvRPYpoR2rWamxylKefJKAkmy0vRr0+
        kJRVKWLJ30TowjiE1rjWnhq2jyZUf7sNSRNSimkriw==
X-Google-Smtp-Source: ABdhPJzTAghL8Sdb1Gw9MPXcbmOW24XGnOJcMCgtYTxm5f97ovoej8TmEINBWT+FiI25beskbGWOdasTt0AKNmWY6l8=
X-Received: by 2002:a05:651c:22b:: with SMTP id z11mr19730326ljn.182.1620655306896;
 Mon, 10 May 2021 07:01:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210319121357.255176-1-huobean@gmail.com> <20210319121357.255176-3-huobean@gmail.com>
 <CAPDyKFrU591aeH5GyuuQW8tPeNc9wav=t8wqF1EdTBbCc9xheg@mail.gmail.com>
 <79ec60974875d4ac17589ea4575e36ec1204f881.camel@gmail.com> <9b7ecf8a74e7e04174181aed0c5f0e356d0ed280.camel@gmail.com>
In-Reply-To: <9b7ecf8a74e7e04174181aed0c5f0e356d0ed280.camel@gmail.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Mon, 10 May 2021 16:01:10 +0200
Message-ID: <CAPDyKFqd03GZVtxmoiY3NFS_EggLQLMGk62AneZLoOn_20BDJQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] mmc: cavium: Remove redundant if-statement checkup
To:     Bean Huo <huobean@gmail.com>
Cc:     rric@kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 29 Apr 2021 at 22:30, Bean Huo <huobean@gmail.com> wrote:
>
> On Fri, 2021-03-19 at 16:42 +0100, Bean Huo wrote:
> > On Fri, 2021-03-19 at 15:09 +0100, Ulf Hansson wrote:
> >
> > > On Fri, 19 Mar 2021 at 13:14, Bean Huo <huobean@gmail.com> wrote:
> > > > From: Bean Huo <beanhuo@micron.com>
> > > > Currently, we have two ways to issue multiple-block read/write
> > > > the
> > > > command to the eMMC. One is by normal IO request path fs->block-
> > > > > mmc.
> > > > Another one is that we can issue multiple-block read/write
> > > > through
> > > > MMC ioctl interface. For the first path, mrq->stop, and mrq-
> > > > >stop-
> > > > > opcode
> > > > will be initialized in mmc_blk_data_prep(). However, for the
> > > > second
> > > > IO
> > > > path, mrq->stop is not initialized since it is a pre-defined
> > > > multiple
> > > > blocks read/write.
> > > As a matter of fact this way is also supported for the regular
> > > block
> > > I/O path. To make the mmc block driver to use it, mmc host drivers
> > > need to announce that it's supported by setting MMC_CAP_CMD23.
> > > It looks like that is what your patch should be targeted towards,
> > > can
> > > you have a look at this instead?
> >
> >
> > Hi Ulf,
> >
> > Thanks for your comments. I will look at that as your suggestion.
> >
> > The patch [1/2] is accepted, so I will just update this patch to
> >
> > the next version.
> >
> >
> >
> > Kind regards,
> >
> > Bean
>
>
> Hi Uffe,
> Could you please firstly accept this patch? let the customer update
> their kernel. As I tried to develop the next version of the patch
> according to your suggestion, more changes will be involved. Also, no
> matter how to make the change general, below mrq->stop checkup should
> be deleted since it is obsolete. In the data transmission completion
> interrupt, mrq->stop will be checked again.
>
> -       if (!mrq->data || !mrq->data->sg || !mrq->data->sg_len ||
> -           !mrq->stop || mrq->stop->opcode != MMC_STOP_TRANSMISSION) {
> +       if (!mrq->data || !mrq->data->sg || !mrq->data->sg_len) {
>

Well, I don't think the above checks are incorrect. Instead I think it
points out that the cavium mmc driver lacks support for CMD23, while
only open ended data transfers are supported.

The proper way forward is instead to implement CMD23 support to the
cavium mmc driver. In the same patch adding that support, you should
be able to remove the above checks.

Kind regards
Uffe
