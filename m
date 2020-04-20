Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC9C1B182C
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 23:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgDTVQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 17:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726123AbgDTVQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 17:16:45 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95529C061A0C
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 14:16:43 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id g10so8825482lfj.13
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 14:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2jN6r5vrIi0padwgEOntdkWRPVKTeqU1oUMQLiCc9u8=;
        b=RVMGvgq4dRxVUT5c5yRM7AhK9ONOictyu7KmC/oVUe3820d9C3IZ+Cl66v1+icCDF2
         QgktcgmK+enRUmEsD4pcjlFOgbs2CCGzmQZ3a/E9nbtEQg0f5RbB2c6ns7l8HoIvYshY
         AzHkoLW3JYQL1BBA+DEehjxgRjaVjJWqfueOc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2jN6r5vrIi0padwgEOntdkWRPVKTeqU1oUMQLiCc9u8=;
        b=TyQTR7zkjmstWYjpohhiFgZ+I/vGj8+5c7G14Qz1tWF8Lg/BrXeGqVECYeo1E6gO62
         htgDHRU6zUR/1yzfsSppwSQ9UNdqZu6KmAeT8v1hhyinLq8CsA7lf9Lz0R+YC2eooffV
         ASW7iqWLtbaPiGVdlbauC1PnLDw8f7RMamBLBDK6bINldNzAG/Bjc9vB9n7EOLfkD4Lb
         lCdr3hh9p73L0tI8JpK2gAqqSt7fOZXD0T4mijmo94dBVE1CI5TT8EcKlkLiKK8r0wrI
         mV8v21+NDS4D2wumtCxIuqi5mEUBzDZObtpOWu/y0xm6CPLlow6bfs17Ad1NOUW1vvZt
         yvOg==
X-Gm-Message-State: AGi0PuYRmr8Q0vXKZzIJWN4D94glWtU/7+FL2xxxbozrJ5qUz847oU+f
        T61Ln+efYJlfk7Y2XE8xiF2cGJN4qyE=
X-Google-Smtp-Source: APiQypLKul+23UUba85sQ00JfStbA6fp7XtG+HQ6RT5/swU91Axl82XdUfsT0Md8wAnZufxXdOQNsA==
X-Received: by 2002:ac2:48b1:: with SMTP id u17mr11427995lfg.187.1587417402126;
        Mon, 20 Apr 2020 14:16:42 -0700 (PDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id s6sm409806lfs.74.2020.04.20.14.16.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 14:16:41 -0700 (PDT)
Received: by mail-lj1-f180.google.com with SMTP id y4so11657664ljn.7
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 14:16:41 -0700 (PDT)
X-Received: by 2002:a2e:7c1a:: with SMTP id x26mr10530724ljc.209.1587417401085;
 Mon, 20 Apr 2020 14:16:41 -0700 (PDT)
MIME-Version: 1.0
References: <67FF611B-D10E-4BAF-92EE-684C83C9107E@amacapital.net>
 <CAHk-=wjePyyiNZo0oufYSn0s46qMYHoFyyNKhLOm5MXnKtfLcg@mail.gmail.com>
 <CAPcyv4jQ3s_ZVRvw6jAmm3vcebc-Ucf7FHYP3_nTybwdfQeG8Q@mail.gmail.com>
 <CAHk-=wjSqtXAqfUJxFtWNwmguFASTgB0dz1dT3V-78Quiezqbg@mail.gmail.com>
 <CAPcyv4hrfZsg48Gw_s7xTLLhjLTk_U+PV0MsLnG+xh3652xFCQ@mail.gmail.com>
 <CAHk-=wgcc=5kiph7o+aBZoWBCbu=9nQDQtD41DvuRRrqixohUA@mail.gmail.com>
 <CAPcyv4iTaBNPMwqUwas+J4rxd867QL7JnQBYB8NKnYaTA-R_Tw@mail.gmail.com>
 <CAHk-=wgOUOveRe8=iFWw0S1LSDEjSfQ-4bM64eiXdGj4n7Omng@mail.gmail.com>
 <CAPcyv4hKcAvQEo+peg3MRT3j+u8UdOHVNUWCZhi0aHaiLbe8gw@mail.gmail.com>
 <CAHk-=wj0yVRjD9KgsnOD39k7FzPqhG794reYT4J7HsL0P89oQg@mail.gmail.com> <3908561D78D1C84285E8C5FCA982C28F7F5FB29E@ORSMSX115.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F7F5FB29E@ORSMSX115.amr.corp.intel.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 20 Apr 2020 14:16:24 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjcwJd6+HVQNYdssNONWUx1=orzRKkVyr7+t2x9Ydcwsw@mail.gmail.com>
Message-ID: <CAHk-=wjcwJd6+HVQNYdssNONWUx1=orzRKkVyr7+t2x9Ydcwsw@mail.gmail.com>
Subject: Re: [PATCH] x86/memcpy: Introduce memcpy_mcsafe_fast
To:     "Luck, Tony" <tony.luck@intel.com>
Cc:     "Williams, Dan J" <dan.j.williams@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        stable <stable@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Tsaur, Erwin" <erwin.tsaur@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 20, 2020 at 1:57 PM Luck, Tony <tony.luck@intel.com> wrote:
>
> >  (a) is a trap, not an exception - so the instruction has been done,
> > and you don't need to try to emulate it or anything to continue.
>
> Maybe for errors on the data side of the pipeline. On the instruction
> side we can usually recover from user space instruction fetches by
> just throwing away the page with the corrupted instructions and reading
> from disk into a new page. Then just point the page table to the new
> page, and hey presto, its all transparently fixed (modulo time lost fixing
> things).

That's true for things like ECC on real RAM, with traditional executables.

It's not so true of something like nvram that you execute out of
directly. There is not necessarily a disk to re-read things from.

But it's also not true of things like JIT's. They are kind of a big
thing. Asking the JIT to do "hey, I faulted at a random point, you
need to re-JIT" is no different from all the other "that's a _really_
painful recovery point, please delay it".

Sure, the JIT environment will probably just have to kill that thread
anyway, but I do think this falls under the same "you're better off
giving the _option_ to just continue and hope for the best" than force
a non-recoverable state.

For regular ECC, I literally would like the machine to just always
continue. I'd like to be informed that there's something bad going on
(because it might be RAM going bad, but it might also be a rowhammer
attack), but the decision to kill things or not should ultimately be
the *users*, not the JIT's, not the kernel.

So the basic rule should be that you should always have the _option_
to just continue. The corrupted state might not be critical - or it
might be the ECC bits themselves, not the data.

There are situations where stopping everything is worse than "let's
continue as best we can, and inform the user with a big red blinking
light".

ECC should not make things less reliable, even if it's another 10+% of
bits that can go wrong.

It should also be noted that even a good ECC pattern _can_ miss
corruption if you're unlucky with the corruption. So the whole
black-and-white model of "ECC means you need to stop everything" is
questionable to begin with, because the signal isn't that absolute in
the first place.

So when somebody brings up a "what if I use corrupted data and make
things worse", they are making an intellectually dishonest argument.
What if you saw corrupted data and simply never caught it, because it
was a unlucky multi-bit failure"?

There is no "absolute" thing about ECC. The only thing that is _never_
wrong is to report it and try to continue, and let some higher-level
entity decide what to do.

And that final decision might literally be "I ran this simulation for
2 days, I see that there's an error report, I will buy a new machine.
For now I'll use the data it generated, but I'll re-run to validate it
later".

                 Linus
