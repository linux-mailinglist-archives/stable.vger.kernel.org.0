Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14662D1AA0
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 21:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgLGUgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 15:36:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47277 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLGUgy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 15:36:54 -0500
Received: from mail-wm1-f70.google.com ([209.85.128.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <dann.frazier@canonical.com>)
        id 1kmNEx-0004FF-Gf
        for stable@vger.kernel.org; Mon, 07 Dec 2020 20:36:11 +0000
Received: by mail-wm1-f70.google.com with SMTP id f12so166760wmf.6
        for <stable@vger.kernel.org>; Mon, 07 Dec 2020 12:36:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iay94n4vbXtVqh1Izy3qyGaxyyIzLgFJf2vEF0h7crw=;
        b=CrfXzxNwiwMvzu5IhzlGFd5ZY/sO52cf3rIgaz0fs2TQXFcsLSWS7I6C498ms2oinu
         Xrzzs3p3aMKmnm9Szngr9ILgk+W+lTPkQ4Sp4+Zl/N7r26ki6GHLWFWQ6WKzZhstWTvU
         70qpkcMuvbtTL2linlm13ains7VPRzI9Y41vd8A5Ux1cfNXhR7cO1sy7zmbU9pSGEECi
         6Ovu1zRR9F+IWHrNOq9H7sEvMfJexycD2Cs9OHSNwcJFcoAy80/gT0O/ElToh3kjMta5
         WKPjfeMnntal8iuQI/Y0bBFlVdz0QtnbjCEhIR5JZKoJ0gt/vl8l3ejdU8QFzHQvI7sb
         QxpA==
X-Gm-Message-State: AOAM531/IBZ8D85gDP1WEh5A69LlF4PTEO9ZjPzj73bAGPc3v+FBxf4U
        wN2sPbwK2Pwi82R+ah28HW4JnmcXCeVtA7md+VgHiuB/1oS4OaBK7egZfHPv4eN2SrzU5/k69cj
        h9+XCqaEDTXLmpCl+hQv4ifO98bZ/C4nbBwQen/fSJNyAhEl0MQ==
X-Received: by 2002:a05:600c:d8:: with SMTP id u24mr585926wmm.103.1607373371130;
        Mon, 07 Dec 2020 12:36:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy3Y5Tlb8k4fV/2cmGn8FoKYCkGlPyJr06XedKUC0hTDrXtYmdsTR5c7SAw1bAcRzJyrTiqxmsm4sfYY4hN4ZM=
X-Received: by 2002:a05:600c:d8:: with SMTP id u24mr585909wmm.103.1607373370869;
 Mon, 07 Dec 2020 12:36:10 -0800 (PST)
MIME-Version: 1.0
References: <X8yoWHNzfl7vHVRA@kroah.com> <20201207172625.2888810-1-dann.frazier@canonical.com>
 <CAMj1kXHdqaso9Vkm3KeKFntMBQeRTkY-fU1GW8K8rcxBbQbKBA@mail.gmail.com>
 <CALdTtnv6VCBjvS-rtUTdhmLHkiJJrY+m4CLW4F8F89NEpZYF7A@mail.gmail.com> <CAMj1kXFAn2bJgwpN+SkGQSzXVdssaZ0Sjpspn8n0QQn4MDk5CA@mail.gmail.com>
In-Reply-To: <CAMj1kXFAn2bJgwpN+SkGQSzXVdssaZ0Sjpspn8n0QQn4MDk5CA@mail.gmail.com>
From:   dann frazier <dann.frazier@canonical.com>
Date:   Mon, 7 Dec 2020 13:35:59 -0700
Message-ID: <CALdTtnuT7fVJ17C2nq8kks_rFRGtDySx61tWpt8b+roajyi7vg@mail.gmail.com>
Subject: Re: [PATCH 4.4] Revert "crypto: arm64/sha - avoid non-standard inline
 asm tricks"
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Michael Schaller <misch@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Jeremy Kerr <jk@ozlabs.org>,
        linux-efi <linux-efi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 7, 2020 at 11:29 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Mon, 7 Dec 2020 at 19:08, dann frazier <dann.frazier@canonical.com> wrote:
> >
> > On Mon, Dec 7, 2020 at 10:50 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> > >
> > > On Mon, 7 Dec 2020 at 18:26, dann frazier <dann.frazier@canonical.com> wrote:
> > > >
> > > > This reverts commit c042dd600f4e89b6e7bdffa00aea4d1d3c1e9686.
> > > >
> > > > This caused the build to emit ADR_PREL_PG_HI21 relocations in the sha{1,2}_ce
> > > > modules. This relocation type is not supported by the linux-4.4.y kernel
> > > > module loader when CONFIG_ARM64_ERRATUM_843419=y, which we have enabled, so
> > > > these modules now fail to load:
> > > >
> > > >   [   37.866250] module sha1_ce: unsupported RELA relocation: 275
> > > >
> > > > This issue does not exist with the backport to 4.9+. Bisection shows that
> > > > this is due to those kernels also having a backport of
> > > > commit 41c066f ("arm64: assembler: make adr_l work in modules under KASLR")
> > >
> > > Hi Dann,
> > >
> > > Would it be an option to backport 41c066f as well?
> >
> > Hi Ard,
> >
> > That was attempted before, but caused a build failure which would
> > still happen today:
> >   https://www.spinics.net/lists/stable/msg179709.html
> > Specifically, head.S still has a 3 argument usage of adr_l. I'm not
> > sure how to safely fix that up myself.
> >
>
> Given that the original reason for reverting the backport of 41c066f
> no longer holds (as there are other users of adr_l in v4.4 now), I
> think the best solution is to backport it again, but with the hunk
> below folded in. (This just replaces the macro invocation with its
> output when called with the 3 arguments in question, so the generated
> code is identical)
>
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -424,7 +424,8 @@ __mmap_switched:
>         str     xzr, [x6], #8                   // Clear BSS
>         b       1b
>  2:
> -       adr_l   sp, initial_sp, x4
> +       adrp    x4, initial_sp
> +       add     sp, x4, :lo12:initial_sp
>         str_l   x21, __fdt_pointer, x5          // Save FDT pointer
>         str_l   x24, memstart_addr, x6          // Save PHYS_OFFSET
>         mov     x29, #0

Thanks Ard - that works. I'll follow-up with a backport patch.

  -dann
