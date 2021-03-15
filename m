Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23C833B015
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 11:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhCOKhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 06:37:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhCOKhn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 06:37:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C7B264E99
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 10:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615804663;
        bh=2mcHhZunRKf2pmIpcWDF+bT3l2pBE1Mu9v+bAsSeGtM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=anErYdfWRebdGgyAQP81stOM2EW0gCWrxMqwIQsW4tFePzwJrPudELQocw8RWMnEq
         dRGcW1Yy/mXcvJ0FtlacLHDtSxQKNQ0xsTu6wmpqw7dn9CxrHGIs0GFXsbiXm8mT2v
         6aPVFoMHPCfiraEKUZvUrJsH8i2r0zRCDX39OvVpNCJyUCgoK/Vd8w0v5VNDdDdxPo
         joCXkfapb7vlp3Mb9HzjB87VYmwmYwnYG/taDHTKidrbW/l70kvsL3g0kpqUzLsQm/
         /V8HdEz4eX2EM7pu9I0r4GpukPtamkWSXsFBsVgm5MFc6ZE6nhoQ8h75dG791vq6zt
         Nq3hkl9fODarQ==
Received: by mail-ot1-f53.google.com with SMTP id o19-20020a9d22130000b02901bfa5b79e18so4864045ota.0
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 03:37:43 -0700 (PDT)
X-Gm-Message-State: AOAM530l0KPO/RgRTWSaBoZSs0TydYLinKy5XYFXv6vlKBv0bX5VvC/p
        nNu2LChSfPp9SEZ+JpCyn2h9I7F7ngWUiYVU2Dg=
X-Google-Smtp-Source: ABdhPJyP/pA6L3VF3Pp9cT0gjhRXg0wKy6LW1DKr2fmVN1B5EdahDUOquP7El2eUy7JtqWXiwbIkUrCpOWMLb3L5UL4=
X-Received: by 2002:a9d:6e15:: with SMTP id e21mr13403906otr.77.1615804662665;
 Mon, 15 Mar 2021 03:37:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAKwvOdka=y54W=ssgCZRgr2B+NaYFHF07KnnNDfrwv79-geSQw@mail.gmail.com>
 <YEs+iaQzEQYNgXcw@kroah.com> <CAKwvOd=xr5je726djQeMMrZAuNcJpX9=R-X19epVy85cjbNbqw@mail.gmail.com>
 <YEw6i39k6hqZJS8+@sashalap> <YE8kIbyWKSojC1SV@kroah.com> <YE8k/2WTPFGwMpHk@kroah.com>
 <YE8l2qhycaGPYdNn@kroah.com>
In-Reply-To: <YE8l2qhycaGPYdNn@kroah.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 15 Mar 2021 11:37:31 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGLrVXZPAoxTtMueB9toeoktuKza-mRpd4vZ0SLN6bSSQ@mail.gmail.com>
Message-ID: <CAMj1kXGLrVXZPAoxTtMueB9toeoktuKza-mRpd4vZ0SLN6bSSQ@mail.gmail.com>
Subject: Re: ARCH=arm LLVM_IAS=1 patches for 5.10, 5.4, and 4.19
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jian Cai <jiancai@google.com>, Stefan Agner <stefan@agner.ch>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sami Tolvanen <samitolvanen@google.com>, candle.sun@unisoc.com,
        =?UTF-8?B?TWlsZXMgQ2hlbiAo6Zmz5rCR5qi6KQ==?= 
        <miles.chen@mediatek.com>, Stephen Hines <srhines@google.com>,
        Luis Lozano <llozano@google.com>,
        Sandeep Patil <sspatil@google.com>,
        Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Mar 2021 at 10:16, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Mar 15, 2021 at 10:12:31AM +0100, Greg KH wrote:
> > On Mon, Mar 15, 2021 at 10:08:49AM +0100, Greg KH wrote:
> > > On Fri, Mar 12, 2021 at 11:07:39PM -0500, Sasha Levin wrote:
> > > > On Fri, Mar 12, 2021 at 09:28:56AM -0800, Nick Desaulniers wrote:
> > > > > My mistake, meant to lop those last two commits off of 4.19.y, they
> > > > > were the ones I referred to earlier working their way through the ARM
> > > > > maintainers tree.  Regenerated the series' (rather than edit the patch
> > > > > files) additionally with --base=auto. Re-attached.
> > > >
> > > > Queued up, thanks!
> > >
> > > This series seems to cause build breakages in a lot of places, so I'm
> > > going to drop the whole set of them now:
> > >     https://lore.kernel.org/r/be846d89-ab5a-f02a-c05e-1cd40acc5baa@roeck-us.net
> > > and:
> > >     https://lore.kernel.org/r/066efc42-0788-8668-2ff5-d431e77068b5@roeck-us.net
> > >
> > > Nick, if you want these merged, can you fix up the errors and resend?
> > >
> > > Perhaps you might want to run these through the tuxbuild tool before
> > > sending?  You should have access to it...
> >
> > Oops, wait, they are fine for 5.10.y, just 4.19 and 5.4 are broken, will
> > go drop those patches only.
>
> Also, these are a lot of churn for 5.4 and 4.19, I'm not convinced it's
> really needed there.  Why again is this required?
>

I think backporting this stuff is causing more problems than it
solves. Note that the 5.4 Thumb2 build is still broken today because
it carries

eff8728fe698 vmlinux.lds.h: Add PGO and AutoFDO input sections

but does not carry

f77ac2e378be ARM: 9030/1: entry: omit FP emulation for UND exceptions
taken in kernel mode

which is tagged as a fix for the former patch, and landed in v5.11.
(Side question: anyone have a clue why the patch in question was never
selected for backporting?)

So I really think we should apply more caution here, and have a
*really* good story on why it is essential that these patches are
backported. In this case, I am not convinced there is one.

-- 
Ard.
