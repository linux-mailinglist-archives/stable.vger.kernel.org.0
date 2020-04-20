Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E1F1B12FC
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 19:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgDTR2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 13:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726211AbgDTR2q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 13:28:46 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C537BC061A0F
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 10:28:45 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id n6so7545091ljg.12
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 10:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IpmTQOayCD1Il3q30iPH6dEUv0PiLxNc2sXawwla/vE=;
        b=cXn3mltz8qorrEfyE5y8hVv9238WfQDrBvoOtyFkveWMr/VgNd23+A0MesJO6OFCV6
         ekBgPWm67RrpmalcOyyI3Lfn/4D8gPsmxyLQQLtBSaECUBbJAREMKbBzRetnjAo+dwFd
         BWGwQIPm49gqAKYyUDjg0Eqhoie/KGQ8r/37o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IpmTQOayCD1Il3q30iPH6dEUv0PiLxNc2sXawwla/vE=;
        b=QPxtSDfy6P5w36xhGmHT7re3/MMPUfAb17GgujCAcZX7j8o5CaPN5ODHh6PQPXLf0T
         fqDS3i7G2ZZJfMuO4pU0Qjo/yXna646d69YHE1/rPoPRi/vFMxnvooqPUWpb67lLiGzP
         sVq0UGKIX3PG1uYxrmru2t5IJCOy+Qv2OzEsmwPaGyZm8LskN64kUvYSBqntFqUmUtRz
         a7y9ZWVCBlFAiyf6l150Y8mqU+khy5DacwD1REVe6OBwlM1xr8qTpPD/xeRv+hwFq9OG
         HgHAs9mR0VjD6LWpDR52cp7Wk1d+1Jfmyq4eQDXKDd4QxqUd9auPjL8CLqFrADCVDfEP
         bFsw==
X-Gm-Message-State: AGi0PubHXq3ELdjUVulDAfPUzvayK6QuvjyiAb26mvOFi0mmY95QiLiX
        VQua1b4ojFWKcXiIT1TazW6+r2PCna8=
X-Google-Smtp-Source: APiQypImUn20Pn3h2EGqSWNsk4Phe2eQveAvxXjYSa7OPnhH1OmKc5Gg/zRKnp9k/dpOiybAiwPw+Q==
X-Received: by 2002:a2e:7606:: with SMTP id r6mr10646182ljc.118.1587403723065;
        Mon, 20 Apr 2020 10:28:43 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id f22sm74926lja.39.2020.04.20.10.28.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 10:28:41 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id r17so8669570lff.2
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 10:28:41 -0700 (PDT)
X-Received: by 2002:a05:6512:405:: with SMTP id u5mr10953490lfk.192.1587403720981;
 Mon, 20 Apr 2020 10:28:40 -0700 (PDT)
MIME-Version: 1.0
References: <67FF611B-D10E-4BAF-92EE-684C83C9107E@amacapital.net>
 <CAHk-=wjePyyiNZo0oufYSn0s46qMYHoFyyNKhLOm5MXnKtfLcg@mail.gmail.com> <CAPcyv4jQ3s_ZVRvw6jAmm3vcebc-Ucf7FHYP3_nTybwdfQeG8Q@mail.gmail.com>
In-Reply-To: <CAPcyv4jQ3s_ZVRvw6jAmm3vcebc-Ucf7FHYP3_nTybwdfQeG8Q@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 20 Apr 2020 10:28:24 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjSqtXAqfUJxFtWNwmguFASTgB0dz1dT3V-78Quiezqbg@mail.gmail.com>
Message-ID: <CAHk-=wjSqtXAqfUJxFtWNwmguFASTgB0dz1dT3V-78Quiezqbg@mail.gmail.com>
Subject: Re: [PATCH] x86/memcpy: Introduce memcpy_mcsafe_fast
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
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

On Sun, Apr 19, 2020 at 10:08 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> Do we have examples of doing exception handling from C? I thought all
> the exception handling copy routines were assembly routines?

You need assembler for the actual access, but that's a _single_
instruction - best done as inline asm.

The best example of something that does *exactly* what you want to do is likely

        unsafe_get_user();
        unsafe_put_user();

which basically turns into a single instruction with exception
handling, with the exception hander jumping directly to an error
label.

Ok, so right now gcc can't do that for inline asm with outputs, so it
generates fairly nasty code (a secondary register with the error state
that then causes a conditional branch on it), but that's a compiler
limitation that will eventually go away (where "eventially" means that
it already works in LLVM with experimental patches).

You could literally mis-use those helpers as-is (please don't - the
code generation is correct, but at the very least we'd have to
re-organize a bit to make it a better interface, ie have an
alternative name like "unsafe_get_kernel()" for kernel pointer
accesses).

You'd have to do the alignment guarantees yourself, but there are
examples of that in this area too (strnlen_user() does exactly that -
aligned word accesses).

So the point here is that the current interfaces are garbage, _if_ the
whole "access a single value" is actually performance-critical.

And if that is *not* the case, then the best thing to do is likely to
just use a static call. No inlining of single instructions at all,
just always use a function call, and then pick the function
appropriately.

Honestly, I can't imagine that the "single access" case is so
timing-critical that the static call isn't the right model. Your use
case is _not_ as important or common as doing user accesses.

Finally, the big question is whether the completely broken hardware
even matters. Are there actual customers that actually use the garbage
"we can crash the machine" stuff?

Because when it comes to things like nvdimms etc, the _primary_
performance target would be getting the kernel entirely out of the
way, and allowing databases etc to just access the damn thing
directly.

And if you allow user space to access it directly, then you just have
to admit that it's not a software issue any more - it's the hardware
that is terminally broken and unusable garbage. It's not even
interesting to work around things in the kernel, because user space
can just crash the machine directly.

This is why I absolutely detest that thing so much. The hardware is
_so_ fundamentally broken that I have always considered the kernel
workarounds to basically be "staging" level stuff - good enough for
some random testing of known-broken stuff, but not something that
anybody sane should ever use.

So my preference would actually be to just call the broken cases to be
largely ignored, at least from a performance angle. If you can only
access it through the kernel, the biggest performance limitation is
that you cannot do any DAX-like thing at all safely, so then the
performance of some kernel accessors is completely secondary and
meaningless. When a kernel entry/exit takes a few thousand cycles on
the broken hardware (due to _other_ bugs), what's the point about
worrying about trying to inline some single access to the nvdimm?

Did the broken hardware ever spread out into the general public?
Because if not, then the proper thing to do might be to just make it a
compile-time option for the (few) customers that signed up for testing
the initial broken stuff, and make the way _forward_ be a clean model
without the need to worry about any exceptions at all.

> The writes can mmu-fault now that memcpy_mcsafe() is also used by
> _copy_to_iter_mcsafe(). This allows a clean bypass of the block layer
> in fs/dax.c in addition to the pmem driver access of poisoned memory.
> Now that the fallback is a sane rep; movs; it can be considered for
> plain copy_to_iter() for other user copies so you get exception
> handling on kernel access of poison outside of persistent memory. To
> Andy's point I think a recoverable copy (for exceptions or faults) is
> generally useful.

I think that's completely independent.

If we have good reasons for having targets with exception handling,
then that has absolutely nothing to do with machine checks or buggy
hardware.

And it sure shouldn't be called "mcsafe", since it has nothing to do
with that situation any more.

> I understand the gripes about the mcsafe_slow() implementation, but
> how do I implement mcsafe_fast() any better than how it is currently
> organized given that, setting aside machine check handling,
> memcpy_mcsafe() is the core of a copy_to_iter*() front-end that can
> mmu-fault on either source or destination access?

So honestly, once it is NOT about the broken machine check garbage,
then it should be sold on its own independent reasons.

Do we want to have a "copy_to_iter_safe" that can handle page faults?
Because we have lots of those kinds of things, we have

 - load_unaligned_zeropad()

   This loads a single word knowing that the _first_ byte is valid,
but can take an exception and zero-pad if it crosses a page boundary

 - probe_kernel_read()/write()

   This is a kernel memcpy() with the source/destination perhaps being unmapped.

 - various perf and tracing helpers that have special semantics.

but once it's about some generic interface, then it also needs to take
other architectures into account.

               Linus
