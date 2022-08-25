Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB525A1C38
	for <lists+stable@lfdr.de>; Fri, 26 Aug 2022 00:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbiHYWYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 18:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbiHYWYf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 18:24:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23B9C5786
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 15:24:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 547ACB82EB4
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 22:24:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0B5C4347C
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 22:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661466272;
        bh=kbid+yAxhD0peTtBLuBbST88kUBhO5yA5WbEZLiL7GU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ieMg6rf+MIKPi2zSdsq9+uOQG/5/a0Ft8NJT1Nn5IKxTDSyqtmDYT6YYprlWTzq0q
         QbHIss805JqC0JPxi3+W58Cc/lYKCaubRV/VI6UscOa/UC4v+EPVUgQGuRmGmUmHHX
         ssgrXh/t9972eSbO/Ko7Lmu+7jspQl03sOZLQwcprzts6YEIotf07iMXC3WWpbaioo
         OT8Za34lcFmGuhquwoRV57zzXZEsCB1Esw6ey31SkKBZqTBPtFh0fa9P+vfuzo89fA
         IjmMA9AiToh8j+KQvmBLbkMxi101sow1qtFgJXjLxEX0J9wKUdPYTKAKZ8jEQ9YAFH
         7og9OvRHE3W5w==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-33dbbf69b3dso79595637b3.1
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 15:24:31 -0700 (PDT)
X-Gm-Message-State: ACgBeo2D8XIzy4TCJd9+kWewDF1wnPppWhJyTDfIJD3gc7sD0Y/kHhwv
        p/Q0YgcGq6U1+RYj5tm0ubUTzSx+PeMJqCI1DMc=
X-Google-Smtp-Source: AA6agR6zE4vjihgs0WHX7ETVPLZCOgYzHa+i2RwZzv215gtNx/cisxaQkqIR9Tu9IDAJw79qXLm0jjApBCIjwtHJDU8=
X-Received: by 2002:a81:91d0:0:b0:335:10ff:8ee4 with SMTP id
 i199-20020a8191d0000000b0033510ff8ee4mr5893651ywg.73.1661466271069; Thu, 25
 Aug 2022 15:24:31 -0700 (PDT)
MIME-Version: 1.0
References: <000401d8a746$3eaca200$bc05e600$@whissi.de> <2a2d1075-aa22-8c4d-ca21-274200dce2fc@leemhuis.info>
 <0FBCAB10-545E-45E2-A0C8-D7620817651D@digitalocean.com> <CAPhsuW5f9QD+gzJ9eBhn5irsHvrsvkWjSnA4MPaHsQjjLMypXg@mail.gmail.com>
 <43e678ca-3fc3-6c08-f035-2c31a34dd889@whissi.de> <701f3fc0-2f0c-a32c-0d41-b489a9a59b99@whissi.de>
 <0192a465-d75d-c09a-732a-eb2215bf3479@whissi.de> <CAPhsuW6yLLcj3GtA+4mUFooQmfGo3cVTYn-xBEY2KuP1wwmQNA@mail.gmail.com>
 <b903abd4-d101-e6a5-06a0-667853286308@whissi.de> <4f69659f-7160-7854-0ed5-6867e3eb2edb@whissi.de>
 <CAPhsuW6Bq8rkiCzsWW7bkrCbYYEwFWtKaswOZcXsyk8tu3C5Dg@mail.gmail.com>
 <be8542cf-9b58-8861-11b5-8eeaa08f1421@whissi.de> <CAPhsuW45eYTjmA4C_wc_Z=ELbw9NStGpX6Mkf=tn1AEBknDg4Q@mail.gmail.com>
 <CAPhsuW7zdynykfXnz8X4CDEusHSHm9Vr01yiQSpEvizGwBUDkQ@mail.gmail.com>
 <172d7663-ce22-f87a-6aa0-0b6145115711@whissi.de> <CAPhsuW4ZeQXL2KsLD_xxUy2dz-aoe+1fZj_+tMEeaLwXJywf=g@mail.gmail.com>
 <CAPhsuW6OcFeyVO-=12opRDijXHpQh1drQZZ6nLAq9P5TzvpnMA@mail.gmail.com> <3114ed77-3802-8ca4-52e4-0e4b917d88b2@kernel.dk>
In-Reply-To: <3114ed77-3802-8ca4-52e4-0e4b917d88b2@kernel.dk>
From:   Song Liu <song@kernel.org>
Date:   Thu, 25 Aug 2022 15:24:20 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7AYMXrW4DNRTnGEvySSLHVz_8n0vJDHzZh90o5NR_5_Q@mail.gmail.com>
Message-ID: <CAPhsuW7AYMXrW4DNRTnGEvySSLHVz_8n0vJDHzZh90o5NR_5_Q@mail.gmail.com>
Subject: Re: [REGRESSION] v5.17-rc1+: FIFREEZE ioctl system call hangs
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Thomas Deutschmann <whissi@whissi.de>,
        Christoph Hellwig <hch@lst.de>,
        Vishal Verma <vverma@digitalocean.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 25, 2022 at 12:12 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 8/25/22 10:47 AM, Song Liu wrote:
> > On Tue, Aug 23, 2022 at 10:13 AM Song Liu <song@kernel.org> wrote:
> >>
> >> On Mon, Aug 22, 2022 at 8:15 PM Thomas Deutschmann <whissi@whissi.de> wrote:
> >>>
> >>> On 2022-08-23 03:37, Song Liu wrote:
> >>>> Thomas, have you tried to bisect with the fio repro?
> >>>
> >>> Yes, just finished:
> >>>
> >>>> d32d3d0b47f7e34560ae3c55ddfcf68694813501 is the first bad commit
> >>>> commit d32d3d0b47f7e34560ae3c55ddfcf68694813501
> >>>> Author: Christoph Hellwig
> >>>> Date:   Mon Jun 14 13:17:34 2021 +0200
> >>>>
> >>>>     nvme-multipath: set QUEUE_FLAG_NOWAIT
> >>>>
> >>>>     The nvme multipathing code just dispatches bios to one of the blk-mq
> >>>>     based paths and never blocks on its own, so set QUEUE_FLAG_NOWAIT
> >>>>     to support REQ_NOWAIT bios.
> >>>
> >>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d32d3d0b47f7e34560ae3c55ddfcf68694813501
> >>>
> >>>
> >>> So another NOWAIT issue -- similar to the bad commit which is causing
> >>> the mdraid issue I already found
> >>> (https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0f9650bd838efe5c52f7e5f40c3204ad59f1964d).
> >>>
> >>> Reverting the commit, i.e. deleting
> >>>
> >>>    blk_queue_flag_set(QUEUE_FLAG_NOWAIT, head->disk->queue);
> >>>
> >>> fixes the problem for me. Well, sort of. Looks like this will disable
> >>> io_uring. fio reproducer fails with
> >>
> >> My system doesn't have multipath enabled. I guess bisect will point to something
> >> else here.
> >>
> >> I am afraid we won't get more information from bisect.
> >
> > OK, I am able to pinpoint the issue, and Jens found the proper fix for
> > it (see below,
> > also available in [1]). It survived 100 runs of the repro fio job.
> >
> > Thomas, please give it a try.
> >
> > Thanks,
> > Song
> >
> > diff --git c/fs/io_uring.c w/fs/io_uring.c
> > index 3f8a79a4affa..72a39f5ec5a5 100644
> > --- c/fs/io_uring.c
> > +++ w/fs/io_uring.c
> > @@ -4551,7 +4551,12 @@ static int io_write(struct io_kiocb *req,
> > unsigned int issue_flags)
> >  copy_iov:
> >                 iov_iter_restore(&s->iter, &s->iter_state);
> >                 ret = io_setup_async_rw(req, iovec, s, false);
> > -               return ret ?: -EAGAIN;
> > +               if (!ret) {
> > +                       if (kiocb->ki_flags & IOCB_WRITE)
> > +                               kiocb_end_write(req);
> > +                       return -EAGAIN;
> > +               }
> > +               return 0;
>
> This should be 'return ret;' for that last line. I had to double check
> the ones I did, but they did get it right. But I did a double take when
> I saw this one :-)

Ah, right... "ret ?: -EAGAIN" is a lot of information..

Song

>
> It'll work fine for testing as we won't hit errors here unless we run
> out of memory, so...
>
> --
> Jens Axboe
