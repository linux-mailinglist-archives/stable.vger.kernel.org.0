Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D45C1AF454
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 21:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgDRTmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 15:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728241AbgDRTmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Apr 2020 15:42:23 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75E1C061A0C
        for <stable@vger.kernel.org>; Sat, 18 Apr 2020 12:42:21 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id m2so4620658lfo.6
        for <stable@vger.kernel.org>; Sat, 18 Apr 2020 12:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p4rEAS/O53Re2CpfxSr2/Dv5edNKCIi/n2DeEZZR7KY=;
        b=Zqa5Mu9fEAhtFeza5prrV1yWpCwrYY/kIL7e1PzuB0VaPYchsmGNPq2A2yJx0KdktA
         yKw2D4sAGZ7F2FEHUIRbuZqtw/gJTtLzShlshLMHwsW0bSUtv5dD1XzzxNPOvxuoXbhB
         B55HwDWCbOhs5ZBK+tO/PcjS/+L1qRJJ57Rxg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p4rEAS/O53Re2CpfxSr2/Dv5edNKCIi/n2DeEZZR7KY=;
        b=eOxzHp1+H6TfBsh0hWKp2U++QILdwGHpq0dplO3cVV3AGnORkppljhVMWd7cDhnYVi
         78yfFu1/jqDIIBxn0rmwq6qmtNLoj8aGFx9i4SeMHzVmAjirS1/lF0riYUmkgY1F1UTs
         ftwWRsQ56hZFAczQ5tm+ZiGXBNv6izDMj5eC6+aReINmnX3CSvSdga8UlEqwG95kMi51
         j8YYRKW5+Ma9TaFWefVo7Gmh1UytShN3oxPWMIePyoXGSUMvUk7Kw2oAZ3uA0gJeIFGD
         qhyWN1Ui8RLFzOseGykBWbFZ9f9NsjwmbiR1MBmSjUxA3lO/Lf5eyHfi55p4MjQtmsiq
         3D9w==
X-Gm-Message-State: AGi0PuYkZ9M+XBreXKhTXAZ/auVogDbpYn6TLxLN8zEmgXERqsv9kvQi
        S0cLfEV1hdWhjJVT4P1gNiMGPk96D+0=
X-Google-Smtp-Source: APiQypI3sEBVxIjjys4E0qTjAVFi39p8rorL5mfasDriuzVgdry0iQekx+mmPjIafLD9w5NYetPRlA==
X-Received: by 2002:a19:7706:: with SMTP id s6mr5658652lfc.31.1587238939861;
        Sat, 18 Apr 2020 12:42:19 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id z65sm21523230lfa.37.2020.04.18.12.42.18
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 12:42:19 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id z26so5617985ljz.11
        for <stable@vger.kernel.org>; Sat, 18 Apr 2020 12:42:18 -0700 (PDT)
X-Received: by 2002:a2e:7c1a:: with SMTP id x26mr5121816ljc.209.1587238938281;
 Sat, 18 Apr 2020 12:42:18 -0700 (PDT)
MIME-Version: 1.0
References: <158654083112.1572482.8944305411228188871.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4gOVN5QVPWduJupVgzq8Sbc_-B0qdYYcw2OcFhk-y2zBw@mail.gmail.com>
In-Reply-To: <CAPcyv4gOVN5QVPWduJupVgzq8Sbc_-B0qdYYcw2OcFhk-y2zBw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 18 Apr 2020 12:42:02 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiV1Xk6ShTeafyius+76OvXN=rfSh_VAjk7ZXFvzuFU4Q@mail.gmail.com>
Message-ID: <CAHk-=wiV1Xk6ShTeafyius+76OvXN=rfSh_VAjk7ZXFvzuFU4Q@mail.gmail.com>
Subject: Re: [PATCH] x86/memcpy: Introduce memcpy_mcsafe_fast
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        stable <stable@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 17, 2020 at 5:12 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> > @@ -106,12 +108,10 @@ static __always_inline __must_check unsigned long
> >  memcpy_mcsafe(void *dst, const void *src, size_t cnt)
> >  {
> >  #ifdef CONFIG_X86_MCE
> > -       if (static_branch_unlikely(&mcsafe_key))
> > -               return __memcpy_mcsafe(dst, src, cnt);
> > -       else
> > +       if (static_branch_unlikely(&mcsafe_slow_key))
> > +               return memcpy_mcsafe_slow(dst, src, cnt);
> >  #endif
> > -               memcpy(dst, src, cnt);
> > -       return 0;
> > +       return memcpy_mcsafe_fast(dst, src, cnt);
> >  }

It strikes me that I see no advantages to making this an inline function at all.

Even for the good case - where it turns into just a memcpy because MCE
is entirely disabled - it doesn't seem to matter.

The only case that really helps is when the memcpy can be turned into
a single access. Which - and I checked - does exist, with people doing

        r = memcpy_mcsafe(&sb_seq_count, &sb(wc)->seq_count, sizeof(uint64_t));

to read a single 64-bit field which looks aligned to me.

But that code is incredible garbage anyway, since even on a broken
machine, there's no actual reason to use the slow variant for that
whole access that I can tell. The macs-safe copy routines do not do
anything worthwhile for a single access.

So my reaction remains that a lot of this is just completely wrong and
incredibly mis-designed.

Yes, the hardware was buggy garbage. But why should we make things
worse with making the software be incomprehensibly bad too?

              Linus
