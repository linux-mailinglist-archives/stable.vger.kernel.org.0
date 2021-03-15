Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E323C33C4FA
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 18:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhCOR5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 13:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233173AbhCOR5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 13:57:18 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87012C061762
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 10:43:40 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id a1so17253585ljp.2
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 10:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OtMjZ54OJDOqbtIenqxR+lq1GcaSGpVZuR7abMKUDls=;
        b=DOparOOWNjFSzT0WLXYcgWo45dz5psBgKIGV7respI0DOAw+ytj1pRuhTs7D2SqEPH
         ljRWKIxPmia711zdBEWPDhKgRI64SupDSG2W+f7jD/wbFKp2Clkn4/+tqueeJfyLmls4
         ZUWAY787zjg/tE9U7LfjbbDfcDDX/XM9gEOcD+FjFTyphW0Dhb6cdqVYBzutwlvbqnXd
         sBClYWJvlSoqhoDY907VwLV06KH+/tgAleUrgUaNTNIu0JkpQNMJ99hewftjMCBrfbzs
         3ypqM6dIw1zSwwuRQDCLBaBqfSScB/vmY5dz0zoVyzMIelArgjjIQEhEz2qRekftjHLQ
         qArg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OtMjZ54OJDOqbtIenqxR+lq1GcaSGpVZuR7abMKUDls=;
        b=Kov29MQr6xcazBxW9Ve0Q6KeXRh1KkSt6fm46a5q+dlZWcLt2Ix/dUaV3ONBoZkejG
         7SrLKFM+G4sp1+YbcmG0hUBbJoKXOcoClvk2shi36L0paQTl2de8Ks0VhL/qlFIOWdLs
         0aab5EDRi+2oM8QTyrISCMSi0ltMefRYRmIsKYgvdzaITTTMSE9lIFh3IM+ejKNd6JIz
         zDiF4SeCfNRIGoL+mgOCxiHtrI6QwxrVRfaeVPrU9Ne/o/4JFdXJt18y1fR1RLRzW+/v
         KfYM4kENh3EaHcDwUunYYDKyh32Wuvyfdio5OQYoKvku4a0VdRBTJgU3MYem7L3nJ+lX
         jZ9Q==
X-Gm-Message-State: AOAM530JKLPKb7is/O28wnn99850talDVqn2G1J8crnwXQ69D+SdHwRJ
        EAEODkAW6KvkSxVKgU6uECrts2Mj/v0sqn8TD0Wgdw==
X-Google-Smtp-Source: ABdhPJyoWoJhb8Ys25u9Mfsi7IM38mLM841V2NfuRriNEsngycl2SFnbuly6ANDglO7IcDj3yNfopCvRvwo8479gMqI=
X-Received: by 2002:a2e:b008:: with SMTP id y8mr88050ljk.233.1615830218474;
 Mon, 15 Mar 2021 10:43:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAKwvOdka=y54W=ssgCZRgr2B+NaYFHF07KnnNDfrwv79-geSQw@mail.gmail.com>
 <YEs+iaQzEQYNgXcw@kroah.com> <CAKwvOd=xr5je726djQeMMrZAuNcJpX9=R-X19epVy85cjbNbqw@mail.gmail.com>
 <YEw6i39k6hqZJS8+@sashalap> <YE8kIbyWKSojC1SV@kroah.com> <YE8k/2WTPFGwMpHk@kroah.com>
 <YE8l2qhycaGPYdNn@kroah.com> <CAMj1kXGLrVXZPAoxTtMueB9toeoktuKza-mRpd4vZ0SLN6bSSQ@mail.gmail.com>
In-Reply-To: <CAMj1kXGLrVXZPAoxTtMueB9toeoktuKza-mRpd4vZ0SLN6bSSQ@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 15 Mar 2021 10:43:26 -0700
Message-ID: <CAKwvOdmJm3v3sHfopWXrSPFn46qaSX9cna=Nd+FZiN=Nz9zmQQ@mail.gmail.com>
Subject: Re: ARCH=arm LLVM_IAS=1 patches for 5.10, 5.4, and 4.19
To:     Ard Biesheuvel <ardb@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
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

On Mon, Mar 15, 2021 at 3:37 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> Note that the 5.4 Thumb2 build is still broken today because
> it carries
>
> eff8728fe698 vmlinux.lds.h: Add PGO and AutoFDO input sections
>
> but does not carry
>
> f77ac2e378be ARM: 9030/1: entry: omit FP emulation for UND exceptions
> taken in kernel mode
>
> which is tagged as a fix for the former patch, and landed in v5.11.
> (Side question: anyone have a clue why the patch in question was never
> selected for backporting?)

I will follow up on the rest, but some quick forensics.

f77ac2e378be ("ARM: 9030/1: entry: omit FP emulation for UND
exceptions taken in kernel mode")

was selected for inclusion into 5.10.y on 2020-12-20:
https://lore.kernel.org/stable/20201228125038.405690346@linuxfoundation.org/

I actually don't have a
Subject: FAILED: patch "[PATCH] <oneline>" failed to apply to X.YY-stable tree
email for this, which seems unusual. I don't know if one wasn't sent,
or message engine had a hiccup or what, so I don't know if it simply
failed to apply to older trees.  Ard, did you as the author receive
such an email?  Usually everyone cc'ed on the patch gets such emails
from autosel, it looks like.

Then *later*
eff8728fe698 ("vmlinux.lds.h: Add PGO and AutoFDO input sections")
was sent to stable on 2021-01-13:
https://lore.kernel.org/stable/20210113185758.GA571703@ubuntu-m3-large-x86/

I was cc'ed on both, and didn't notice or forgot that one had
additional fixes necessary.  My mistake.

I think one way to avoid that in the future in a semi automated
fashion would be to have an in tree script like checkpatch that given
a sha from mainline would check git log for any Fixes tag that may
exist on subsequent patches.  Then it should be possible for any patch
that itself is backported (contains "commit XXX upstream") to be fed
in when auto selected or submitted to stable (or before then) to check
for new fixes.  Probably would still need to be run periodically, as
Fixes: aren't necessarily available when AutoSel runs.  For the
toolchain, we have a bot that watches for reverts for example, but
non-standard commit messages denoting one patch fixes another makes
this far from perfect.  Would still need to be run periodically,
because if a Fixes: exists, but hasn't been merged yet, it could get
missed.

Though I'm curious how the machinery that picks up Fixes: tags works.
Does it run on a time based cadence?  Is it only run as part of
AutoSel, but not for manual backports sent to the list?  Would it have
picked up on f77ac2e378be at some point?

f77ac2e378be doesn't apply cleanly to linux-5.4.y. There's a conflict
in arch/arm/vfp/vfphw.S due to 5.4 missing
commit 2cbd1cc3dcd3 ("ARM: 8991/1: use VFP assembler mnemonics if available")
which is one of the patches I sent in the 5.4 series in this thread.
That was 1 of a 3 patch series:
https://lore.kernel.org/linux-arm-kernel/cover.1593205699.git.stefan@agner.ch/

Should I separate out just those 3 and f77ac2e378be and send that for
5.4, or manually backport just f77ac2e378be and note in the commit
message the conflict?

eff8728fe698 was sent back to 4.4, so if it's easy to reproduce the
observed failure, we can test to see if branches older than 5.4 are
also affected.  It sounds like eff8728fe698 was merged 2021-01-15, so
THUMB2 would have been broken since then. I didn't see any reports on
https://lore.kernel.org/stable/20210113185758.GA571703@ubuntu-m3-large-x86/;
was this reported elsewhere earlier? Did automated testing help find
this, or was it found manually just now?  I'm curious if there's a way
to expand our automated coverage since this eluded us?

commit 3ce47d95b734 ("powerpc: Handle .text.{hot,unlikely}.* in linker script")
is the only other commit in mainline that refers to eff8728fe698, but
doesn't use that in its Fixes tag.  I don't see any other follow up
patches (yet! *ducks*).
--
Thanks,
~Nick Desaulniers
