Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8523E3C1449
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 15:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhGHNcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 09:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbhGHNcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Jul 2021 09:32:19 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5193C061574;
        Thu,  8 Jul 2021 06:29:37 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id r135so9020158ybc.0;
        Thu, 08 Jul 2021 06:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7iY/t0V3e2tJ2lgZLF6BcOUJNLhB502Wbe1KPKqB0LA=;
        b=ovlSDhRfTlXIGTTpWKdVDJDYwHGRnh6RX5bu82M/prXU1TSsMXMwyHyt6NeSyG/VZH
         WfLIwt73YEx9HQlGzD9Nt+sB6mdU06Y86CL4x5ZIDeOpfi30OLMC8K5rMs37G1+nGGQ0
         PLn/75deF/+N1QH89L5zG+YOf2FEqLowpgKxKYfm67N6HBSIfyTngRtQcIALFjIrgiBh
         grlCNI4Wg4L9c7XQesChJZf1zzCoimDOazQsXajqWyAu/9Fep0xpcJp178DeHqNor/4O
         COrYXyp4WP/WO8UzcTx9xvvf8bklfn/1rP4BMaGgG1J3a8urNcLzAAmNrs8BWoYEwEo7
         f7wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7iY/t0V3e2tJ2lgZLF6BcOUJNLhB502Wbe1KPKqB0LA=;
        b=jwsyw/2woXE/awYLUR8Vk5OKKY4B11GR3vhmwElMUPxP90Q62BKCyxW2vtckACAQ6T
         xr84uDLoPfq4Hh29L9dd4wCYcJM7jxvep0TLP2Hne4sxIbixsN39M+QtAMLEj1HHOU5m
         J9Dx76yDEvsQaUKNhyN4KRsqRSZnpZNs2e354U9fdmLFi+3Nr5HK5mO8J2931TdYR1NO
         T2NmTnE1wGqH9f2rdvCNc+1tav03QBNMd5GCXUCMGC6IrY6jbk0QRd3jTV/NZJm4YdMq
         GNTVDC3s+rrh3qtubgE4c5/LE1vbxUp+jvZZ+Hb4czsFiqp+ZHSCGs/7Mo1fCjw1b2Hf
         NVCA==
X-Gm-Message-State: AOAM5326H56sc9G2oKYVy1XwWxwpuI2IX9XxPjhgSG3cUb/BkqOxdNM6
        JaY9phO8oEAND3opu9pb+C9B1tUP+qVTXrszGKM=
X-Google-Smtp-Source: ABdhPJyj0wCPN4rnzDZzw3u1A5K0DoAv/kiMbwKUFoPpA7LrFI9EzkCTntijaxa4pc8RU+DfXx4dyiP1Os1eM+sR6kQ=
X-Received: by 2002:a5b:504:: with SMTP id o4mr40480864ybp.332.1625750977168;
 Thu, 08 Jul 2021 06:29:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210627135117.28641-1-bmeng.cn@gmail.com> <11706f7e-a53a-5640-d713-bc4562db71fa@huawei.com>
 <CAEUhbmV=h3nZ8Aa94_uyjrZ_NGe+9-xAorUMubSPJXu3y60PeQ@mail.gmail.com>
 <aa1f027c-bbc7-92f8-80a6-fe290cd1cdf8@huawei.com> <CAEUhbmXeqAsLxm+oCHRPHMZq2mQXPD6fJOFerwp_BRv1kCc7ow@mail.gmail.com>
 <CAEUhbmUvDSocWobb26PcrV6vi6kHjg8o6pNomt9AnGWGbvAuhw@mail.gmail.com>
 <94a92009-ce49-bbe4-794c-0631520e4c3d@huawei.com> <CAEUhbmX8a+rjc4=5QfR4MivMMx-T_7KDq-QHtmrGsVL2VqLQAA@mail.gmail.com>
In-Reply-To: <CAEUhbmX8a+rjc4=5QfR4MivMMx-T_7KDq-QHtmrGsVL2VqLQAA@mail.gmail.com>
From:   Bin Meng <bmeng.cn@gmail.com>
Date:   Thu, 8 Jul 2021 21:29:26 +0800
Message-ID: <CAEUhbmVQPYQSuYLaTRY112TpUB9g-KfCEREGODxNivHhnWNb_Q@mail.gmail.com>
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

Hi Palmer,

On Thu, Jul 1, 2021 at 10:20 AM Bin Meng <bmeng.cn@gmail.com> wrote:
>
> On Thu, Jul 1, 2021 at 10:08 AM Kefeng Wang <wangkefeng.wang@huawei.com> =
wrote:
> >
> >
> > On 2021/6/30 19:58, Bin Meng wrote:
> > > On Mon, Jun 28, 2021 at 11:21 AM Bin Meng <bmeng.cn@gmail.com> wrote:
> > >> On Mon, Jun 28, 2021 at 10:28 AM Kefeng Wang <wangkefeng.wang@huawei=
.com> wrote:
> > >>>
> > >>> On 2021/6/28 9:15, Bin Meng wrote:
> > >>>> On Mon, Jun 28, 2021 at 8:53 AM Kefeng Wang <wangkefeng.wang@huawe=
i.com> wrote:
> > >>>>> Hi=EF=BC=8C sorry for the mistake=EF=BC=8Cthe bug is fixed by
> > >>>>>
> > >>>>> https://lore.kernel.org/linux-riscv/20210602085517.127481-2-wangk=
efeng.wang@huawei.com/
> > >>>> What are we on the patch you mentioned?
> > >>>>
> > >>>> I don't see it applied in the linux/master.
> > >>>>
> > >>>> Also there should be a "Fixes" tag and stable@vger.kernel.org cc'e=
d
> > >>>> because 32-bit is broken since v5.12.
> > >>> https://kernel.googlesource.com/pub/scm/linux/kernel/git/riscv/linu=
x/+/c9811e379b211c67ba29fb09d6f644dd44cfcff2
> > >>>
> > >>> it's on Palmer' riscv-next.
> > >> Not sure riscv-next is for which release? This is a regression and
> > >> should be on 5.13.
> > >>
> > >>> Hi Palmer, should I resend or could you help me to add the fixes ta=
g?
> > > Your patch mixed 2 things (fix plus one feature) together, so it is
> > > not proper to back port your patch.
> >
> > "mem=3D" will change the range of memblock, so the fix part must be inc=
luded.
> >
>
> Yes, so you can rebase the "mem=3D" changes on top of my patch.
>
> The practice is that we should not mix 2 things in one patch. I can
> imagine that you wanted to add "mem=3D" to RISC-V and suddenly found the
> existing logic was broken, so you sent one patch to do both.
>
> >
> > >
> > > Here is my 2 cents:
> > >
> > > 1. Drop your patch from riscv-next
> > > 2. Apply my patch as it is a simple fix to previous commit. This
> > > allows stable kernel to cherry-pick the fix to v5.12 and v5.13.
> > > 3. Rebase your patch against mine, and resend v2
> > >
> > > Let me know if this makes sense.
> >
> > It is not a big problem for me, but I have no right abourt riscv-next,
> >
> > let's wait Palmer's advise.
> >
>
> Sure. Palmer, let me know your thoughts.

Ping?

Regards,
Bin
