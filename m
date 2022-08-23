Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4CDF59EB72
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 20:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232378AbiHWSvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 14:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbiHWSuo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 14:50:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BA28C444
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 10:14:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65C81B81FDB
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 17:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27DBEC43140
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 17:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661274841;
        bh=0l2e7AEMB26GbMicu+Gxo6P6hcCdemCnqhFgOYjvvwU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GPX40d4fBu6bu6C53o50ZTk7CX8C3uz4ujYaNZFSMI8s+QaevtYg0TDHvuSulKtIa
         wASqzdw/nZ0yxyXY3YMLULStLLBFcIVHp+jHaRoax4IhzDw1kOD4Bhay2FqRqqoEp9
         7f5pDYmZAkgEHfvOkfvnWz0JUaQiYPYGqatKC7Ylofut01bykvEF/5Cfb/UqLlIco9
         wC5M9CEvGwfuz1TOPoO35jHe9BTrG8tLWA8Nx3YcMdudFaAXoulKSv3wunKTKe1sIw
         HbSlXqYMzToFVbSJ9Y3z4rl8J++LLpvc0d+cvGzmDApDfTAIOfFC7uVCxMa1HnbsIZ
         JU9JLxfdnILZQ==
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-3376851fe13so363922927b3.6
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 10:14:01 -0700 (PDT)
X-Gm-Message-State: ACgBeo1zA0M/W/ChfMVtLNuPapSubfd6AK2jO6Gw7+xuxnBEI1H+WpZL
        9P5cmxn0ADNck//dL4L19XQ0xyt3HQLvLBKBX6A=
X-Google-Smtp-Source: AA6agR7pK8zUJ/YyKcYl4BgvfFAQmRvmnt1ZvRaHC/VHHXvSpwujQl+eYE8kW4U1HUuWwv7tHueksFDat8UZE3nDZdg=
X-Received: by 2002:a81:910d:0:b0:330:23a8:bec4 with SMTP id
 i13-20020a81910d000000b0033023a8bec4mr27044820ywg.148.1661274840199; Tue, 23
 Aug 2022 10:14:00 -0700 (PDT)
MIME-Version: 1.0
References: <000401d8a746$3eaca200$bc05e600$@whissi.de> <000001d8ad7e$c340ad70$49c20850$@whissi.de>
 <2a2d1075-aa22-8c4d-ca21-274200dce2fc@leemhuis.info> <0FBCAB10-545E-45E2-A0C8-D7620817651D@digitalocean.com>
 <CAPhsuW5f9QD+gzJ9eBhn5irsHvrsvkWjSnA4MPaHsQjjLMypXg@mail.gmail.com>
 <43e678ca-3fc3-6c08-f035-2c31a34dd889@whissi.de> <701f3fc0-2f0c-a32c-0d41-b489a9a59b99@whissi.de>
 <0192a465-d75d-c09a-732a-eb2215bf3479@whissi.de> <CAPhsuW6yLLcj3GtA+4mUFooQmfGo3cVTYn-xBEY2KuP1wwmQNA@mail.gmail.com>
 <b903abd4-d101-e6a5-06a0-667853286308@whissi.de> <4f69659f-7160-7854-0ed5-6867e3eb2edb@whissi.de>
 <CAPhsuW6Bq8rkiCzsWW7bkrCbYYEwFWtKaswOZcXsyk8tu3C5Dg@mail.gmail.com>
 <be8542cf-9b58-8861-11b5-8eeaa08f1421@whissi.de> <CAPhsuW45eYTjmA4C_wc_Z=ELbw9NStGpX6Mkf=tn1AEBknDg4Q@mail.gmail.com>
 <CAPhsuW7zdynykfXnz8X4CDEusHSHm9Vr01yiQSpEvizGwBUDkQ@mail.gmail.com> <172d7663-ce22-f87a-6aa0-0b6145115711@whissi.de>
In-Reply-To: <172d7663-ce22-f87a-6aa0-0b6145115711@whissi.de>
From:   Song Liu <song@kernel.org>
Date:   Tue, 23 Aug 2022 10:13:47 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4ZeQXL2KsLD_xxUy2dz-aoe+1fZj_+tMEeaLwXJywf=g@mail.gmail.com>
Message-ID: <CAPhsuW4ZeQXL2KsLD_xxUy2dz-aoe+1fZj_+tMEeaLwXJywf=g@mail.gmail.com>
Subject: Re: [REGRESSION] v5.17-rc1+: FIFREEZE ioctl system call hangs
To:     Thomas Deutschmann <whissi@whissi.de>
Cc:     Christoph Hellwig <hch@lst.de>,
        Vishal Verma <vverma@digitalocean.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Jens Axboe <axboe@kernel.dk>
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

On Mon, Aug 22, 2022 at 8:15 PM Thomas Deutschmann <whissi@whissi.de> wrote:
>
> On 2022-08-23 03:37, Song Liu wrote:
> > Thomas, have you tried to bisect with the fio repro?
>
> Yes, just finished:
>
> > d32d3d0b47f7e34560ae3c55ddfcf68694813501 is the first bad commit
> > commit d32d3d0b47f7e34560ae3c55ddfcf68694813501
> > Author: Christoph Hellwig
> > Date:   Mon Jun 14 13:17:34 2021 +0200
> >
> >     nvme-multipath: set QUEUE_FLAG_NOWAIT
> >
> >     The nvme multipathing code just dispatches bios to one of the blk-mq
> >     based paths and never blocks on its own, so set QUEUE_FLAG_NOWAIT
> >     to support REQ_NOWAIT bios.
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d32d3d0b47f7e34560ae3c55ddfcf68694813501
>
>
> So another NOWAIT issue -- similar to the bad commit which is causing
> the mdraid issue I already found
> (https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0f9650bd838efe5c52f7e5f40c3204ad59f1964d).
>
> Reverting the commit, i.e. deleting
>
>    blk_queue_flag_set(QUEUE_FLAG_NOWAIT, head->disk->queue);
>
> fixes the problem for me. Well, sort of. Looks like this will disable
> io_uring. fio reproducer fails with

My system doesn't have multipath enabled. I guess bisect will point to something
else here.

I am afraid we won't get more information from bisect.

Thanks,
Song

>
> > $ fio reproducer.fio
> > filename0: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=io_uring, iodepth=1
> > fio-3.30
> > Starting 1 thread
> > fio: io_u error on file /srv/machines/fio/filename0.0.0: Operation not supported: write offset=12648448, buflen=4096
> > fio: pid=1585, err=95/file:io_u.c:1846, func=io_u error, error=Operation not supported
>
> My MariaDB reproducer also doesn't trigger the problem anymore, but
> probably for the same reason -- it cannot use io_uring anymore.
>
