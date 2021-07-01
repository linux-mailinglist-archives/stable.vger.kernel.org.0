Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6963B8C10
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 04:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238593AbhGACX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 22:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234257AbhGACX2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 22:23:28 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7501C061756;
        Wed, 30 Jun 2021 19:20:58 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id i4so8401097ybe.2;
        Wed, 30 Jun 2021 19:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BZiA++i9/HIlLMmgO3JxJDUc1Suj7A+dnaQIqqLWGAY=;
        b=F6VOyj/xRpKG8vkwDSYJ6vYzHOcMY10qBExtNVeMavmRa6iWqczKrXubuAEQwXWeeD
         8M3ITL3Edtxk+XiqTiP+5eMyRz68QBklfWmmvgXpPY9P2wgVS/JWvUM27EL7ANGVxi/B
         WCA+2OMRQJk/4klXovHBjNiChdj9lsdn9gTkGZLDlhOpHQ1GpKhL4UBGM+7zcEJgTG6T
         jF5ijbRvDVxNqQMFQMchkIr2WcxQjZcqFmPGgO9joEqwFcT5LS03hqy/6q1FVRjYqoDv
         b6qKKlYMeMF7cDEygCOAn/EqpMCHvJu3DIMIPW0FioUewqo1bD00BOeN9PR63wagc3Mh
         H98A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BZiA++i9/HIlLMmgO3JxJDUc1Suj7A+dnaQIqqLWGAY=;
        b=CHcj/TOjF7mchg1TEwbwHAlv0h8cJGay+U3JEQswwzX8wUWq2SacMhjvhseN7tNP32
         hpm4jDZXnJJSgRtavsnKasVfdqu75Xls1E8mWxr2eZ+8QzEKpw4q8Q+PjmKBQqcJax8T
         OJTcWOVDlhDHON0UgEwfw2zqIVFrn2SqaEFVptHFNdRJop5ZKo/o6fv8GWijNJxmSuEc
         UWd088NHLHWvye4rmTl7FppfdsEDWE3zDI9GPQ8TQKSqDXvGE+adV8O43l9jDx5kvq+6
         BahHOHMwqKK8Q7m7dqhFMfYRIdqzN5AEav5u3kos8HglNMDQy7OXbcAajX+i83UkqPiL
         3J1A==
X-Gm-Message-State: AOAM531g8uydoUqvT/ZoQ36uiJl4c4UgdYKoGLtzkVPzkr6mfayVf4CZ
        ILFd49KlAKKKf7jiz8nqS3mLn3cW55PNy1uJvo0=
X-Google-Smtp-Source: ABdhPJx2HrcgpI89x1MjAJexBzDBDQZ5RK4uKgnHTnFzxyXiY5tY/psMDBGCM42IuoX4HT8HMB9caavbBmji/N8HU+A=
X-Received: by 2002:a25:b7cd:: with SMTP id u13mr28799996ybj.152.1625106057861;
 Wed, 30 Jun 2021 19:20:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210627135117.28641-1-bmeng.cn@gmail.com> <11706f7e-a53a-5640-d713-bc4562db71fa@huawei.com>
 <CAEUhbmV=h3nZ8Aa94_uyjrZ_NGe+9-xAorUMubSPJXu3y60PeQ@mail.gmail.com>
 <aa1f027c-bbc7-92f8-80a6-fe290cd1cdf8@huawei.com> <CAEUhbmXeqAsLxm+oCHRPHMZq2mQXPD6fJOFerwp_BRv1kCc7ow@mail.gmail.com>
 <CAEUhbmUvDSocWobb26PcrV6vi6kHjg8o6pNomt9AnGWGbvAuhw@mail.gmail.com> <94a92009-ce49-bbe4-794c-0631520e4c3d@huawei.com>
In-Reply-To: <94a92009-ce49-bbe4-794c-0631520e4c3d@huawei.com>
From:   Bin Meng <bmeng.cn@gmail.com>
Date:   Thu, 1 Jul 2021 10:20:46 +0800
Message-ID: <CAEUhbmX8a+rjc4=5QfR4MivMMx-T_7KDq-QHtmrGsVL2VqLQAA@mail.gmail.com>
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

On Thu, Jul 1, 2021 at 10:08 AM Kefeng Wang <wangkefeng.wang@huawei.com> wr=
ote:
>
>
> On 2021/6/30 19:58, Bin Meng wrote:
> > On Mon, Jun 28, 2021 at 11:21 AM Bin Meng <bmeng.cn@gmail.com> wrote:
> >> On Mon, Jun 28, 2021 at 10:28 AM Kefeng Wang <wangkefeng.wang@huawei.c=
om> wrote:
> >>>
> >>> On 2021/6/28 9:15, Bin Meng wrote:
> >>>> On Mon, Jun 28, 2021 at 8:53 AM Kefeng Wang <wangkefeng.wang@huawei.=
com> wrote:
> >>>>> Hi=EF=BC=8C sorry for the mistake=EF=BC=8Cthe bug is fixed by
> >>>>>
> >>>>> https://lore.kernel.org/linux-riscv/20210602085517.127481-2-wangkef=
eng.wang@huawei.com/
> >>>> What are we on the patch you mentioned?
> >>>>
> >>>> I don't see it applied in the linux/master.
> >>>>
> >>>> Also there should be a "Fixes" tag and stable@vger.kernel.org cc'ed
> >>>> because 32-bit is broken since v5.12.
> >>> https://kernel.googlesource.com/pub/scm/linux/kernel/git/riscv/linux/=
+/c9811e379b211c67ba29fb09d6f644dd44cfcff2
> >>>
> >>> it's on Palmer' riscv-next.
> >> Not sure riscv-next is for which release? This is a regression and
> >> should be on 5.13.
> >>
> >>> Hi Palmer, should I resend or could you help me to add the fixes tag?
> > Your patch mixed 2 things (fix plus one feature) together, so it is
> > not proper to back port your patch.
>
> "mem=3D" will change the range of memblock, so the fix part must be inclu=
ded.
>

Yes, so you can rebase the "mem=3D" changes on top of my patch.

The practice is that we should not mix 2 things in one patch. I can
imagine that you wanted to add "mem=3D" to RISC-V and suddenly found the
existing logic was broken, so you sent one patch to do both.

>
> >
> > Here is my 2 cents:
> >
> > 1. Drop your patch from riscv-next
> > 2. Apply my patch as it is a simple fix to previous commit. This
> > allows stable kernel to cherry-pick the fix to v5.12 and v5.13.
> > 3. Rebase your patch against mine, and resend v2
> >
> > Let me know if this makes sense.
>
> It is not a big problem for me, but I have no right abourt riscv-next,
>
> let's wait Palmer's advise.
>

Sure. Palmer, let me know your thoughts.

Regards,
Bin
