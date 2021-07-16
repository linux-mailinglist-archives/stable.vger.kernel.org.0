Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A533CB0B3
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 04:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhGPCR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 22:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbhGPCR1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 22:17:27 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AD5C06175F;
        Thu, 15 Jul 2021 19:14:32 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id b13so12368496ybk.4;
        Thu, 15 Jul 2021 19:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bDpz3xiBhEz0ZZ2vw/9YGDuwg2vaRKleCOGcjaj3zg4=;
        b=XaId+1qnRj2oNBeX0nz4OjboMoi0KPWUrc9e8pe/yfJdlg4lWqivxBZc2+1h4QdWbK
         yswl4M0mPayEhwrTlL1pWmAt8UpG/rzL71rzXBqpJPt+xiU8GeKPRQbvS6kbltJiUdJa
         b188EH4ApBzyF+jreycjfVEEHOIscxtViw0jQDBpG8mFWFyBGhJOHP7Kd9/cvmQuM5Jp
         XgyW0dWFaEmpBZBK5NGTnUgFqq0UHgiZ2Q7yGqEHZj0k1RPbaCXFjbkaCrGgIRWk/Hrs
         YG9nWZVh55IJJuS15fkNrnN/PytpMAPNWQybCGle4p/OfulLibTwplqNZTCVLQEDFx2e
         oR7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bDpz3xiBhEz0ZZ2vw/9YGDuwg2vaRKleCOGcjaj3zg4=;
        b=bO4a5XFjZ1MAa+PAKQ7gy4wQsGU9uYgTPyuCaPpJlbE0tjwODJMeBKbMVDNZPXp6Oq
         elHLG+NoZSaAh/4w/iOJzl9/+zk/MWODJcu1rXUmqBSWwf+OoWB/xB0UObU2OuTnrNp7
         PfB7vV2pCLwZDr0ZrHuVmFAzubaNgSou0mx+cqnjFTWQEKUZMOE4uduzYZYkqjG3m+de
         +XCwHkD8wer32ytrZp9Uq8CD0L+e5TG5Gb24Bq85BTha4i9Ls1U4chf04MOIEJw+3p5z
         x/+wbW0871kJe/3wemtTv4mrtUAGMD8rJSS2QJ9wMSpR7FzaYJwdDTsQdszi9pCAPGdc
         MUzA==
X-Gm-Message-State: AOAM532AF9LLb4YMYbpZVxhVOn3qPO68yYeneILqtoov2dJf0MTx7plE
        Zc+qnWFl3WmuhKEfED1fSw895eRrinHITJi2JUI=
X-Google-Smtp-Source: ABdhPJzw92hfvOr8tCGDvjfAYyHupxas+W5zP3mI0mOwj/Sbm57yeTdrS56J7ejmHTJIDHhU8zMdkIkAscRyeR4tmpM=
X-Received: by 2002:a25:df11:: with SMTP id w17mr9327459ybg.314.1626401672149;
 Thu, 15 Jul 2021 19:14:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210627135117.28641-1-bmeng.cn@gmail.com> <11706f7e-a53a-5640-d713-bc4562db71fa@huawei.com>
 <CAEUhbmV=h3nZ8Aa94_uyjrZ_NGe+9-xAorUMubSPJXu3y60PeQ@mail.gmail.com>
 <aa1f027c-bbc7-92f8-80a6-fe290cd1cdf8@huawei.com> <CAEUhbmXeqAsLxm+oCHRPHMZq2mQXPD6fJOFerwp_BRv1kCc7ow@mail.gmail.com>
 <CAEUhbmUvDSocWobb26PcrV6vi6kHjg8o6pNomt9AnGWGbvAuhw@mail.gmail.com>
 <94a92009-ce49-bbe4-794c-0631520e4c3d@huawei.com> <CAEUhbmX8a+rjc4=5QfR4MivMMx-T_7KDq-QHtmrGsVL2VqLQAA@mail.gmail.com>
 <CAEUhbmVQPYQSuYLaTRY112TpUB9g-KfCEREGODxNivHhnWNb_Q@mail.gmail.com>
In-Reply-To: <CAEUhbmVQPYQSuYLaTRY112TpUB9g-KfCEREGODxNivHhnWNb_Q@mail.gmail.com>
From:   Bin Meng <bmeng.cn@gmail.com>
Date:   Fri, 16 Jul 2021 10:14:20 +0800
Message-ID: <CAEUhbmVO_dV86LJLz3S4PFu9oFp4_5HWSkKLwqc-ZkQK=yYZfw@mail.gmail.com>
Subject: Re: [PATCH] riscv: Fix 32-bit RISC-V boot failure
To:     Kefeng Wang <wangkefeng.wang@huawei.com>
Cc:     Palmer Dabbelt <palmerdabbelt@google.com>,
        Atish Patra <atish.patra@wdc.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 8, 2021 at 9:29 PM Bin Meng <bmeng.cn@gmail.com> wrote:
>
> Hi Palmer,
>
> On Thu, Jul 1, 2021 at 10:20 AM Bin Meng <bmeng.cn@gmail.com> wrote:
> >
> > On Thu, Jul 1, 2021 at 10:08 AM Kefeng Wang <wangkefeng.wang@huawei.com=
> wrote:
> > >
> > >
> > > On 2021/6/30 19:58, Bin Meng wrote:
> > > > On Mon, Jun 28, 2021 at 11:21 AM Bin Meng <bmeng.cn@gmail.com> wrot=
e:
> > > >> On Mon, Jun 28, 2021 at 10:28 AM Kefeng Wang <wangkefeng.wang@huaw=
ei.com> wrote:
> > > >>>
> > > >>> On 2021/6/28 9:15, Bin Meng wrote:
> > > >>>> On Mon, Jun 28, 2021 at 8:53 AM Kefeng Wang <wangkefeng.wang@hua=
wei.com> wrote:
> > > >>>>> Hi=EF=BC=8C sorry for the mistake=EF=BC=8Cthe bug is fixed by
> > > >>>>>
> > > >>>>> https://lore.kernel.org/linux-riscv/20210602085517.127481-2-wan=
gkefeng.wang@huawei.com/
> > > >>>> What are we on the patch you mentioned?
> > > >>>>
> > > >>>> I don't see it applied in the linux/master.
> > > >>>>
> > > >>>> Also there should be a "Fixes" tag and stable@vger.kernel.org cc=
'ed
> > > >>>> because 32-bit is broken since v5.12.
> > > >>> https://kernel.googlesource.com/pub/scm/linux/kernel/git/riscv/li=
nux/+/c9811e379b211c67ba29fb09d6f644dd44cfcff2
> > > >>>
> > > >>> it's on Palmer' riscv-next.
> > > >> Not sure riscv-next is for which release? This is a regression and
> > > >> should be on 5.13.
> > > >>
> > > >>> Hi Palmer, should I resend or could you help me to add the fixes =
tag?
> > > > Your patch mixed 2 things (fix plus one feature) together, so it is
> > > > not proper to back port your patch.
> > >
> > > "mem=3D" will change the range of memblock, so the fix part must be i=
ncluded.
> > >
> >
> > Yes, so you can rebase the "mem=3D" changes on top of my patch.
> >
> > The practice is that we should not mix 2 things in one patch. I can
> > imagine that you wanted to add "mem=3D" to RISC-V and suddenly found th=
e
> > existing logic was broken, so you sent one patch to do both.
> >
> > >
> > > >
> > > > Here is my 2 cents:
> > > >
> > > > 1. Drop your patch from riscv-next
> > > > 2. Apply my patch as it is a simple fix to previous commit. This
> > > > allows stable kernel to cherry-pick the fix to v5.12 and v5.13.
> > > > 3. Rebase your patch against mine, and resend v2
> > > >
> > > > Let me know if this makes sense.
> > >
> > > It is not a big problem for me, but I have no right abourt riscv-next=
,
> > >
> > > let's wait Palmer's advise.
> > >
> >
> > Sure. Palmer, let me know your thoughts.
>
> Ping?

Ping?
