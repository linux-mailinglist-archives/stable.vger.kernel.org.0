Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7B21B16AB
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 22:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgDTUH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 16:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725918AbgDTUH2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 16:07:28 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D800C061A0C
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 13:07:27 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id h6so9144054lfc.0
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 13:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CkLzDOs2QhGApweR1QmmWlbi9o5ixalfBfDesdrfxCg=;
        b=BazmrNGdTnM2FQ5CtGkMj83BfdJa4Yp3E5qxoKOOrd3F9bdAFvJI4Bd7wUfW440c25
         fcBUzphgipH/0eS786g3ZSKfwKmAcpIo7XBMPXb8HD5Wraa4Lh9QMQbTto9Z2/5fRG9w
         wi+Jb2TouNkb2lobBro+yIBnKNzlulF08P2ho=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CkLzDOs2QhGApweR1QmmWlbi9o5ixalfBfDesdrfxCg=;
        b=fRuGtLXXHPW8EExN5K1jTp5KGkzZm2jqOeYNBfAuWG+lxZbMUluQVfEscJdV1En4gW
         a2OyVWYjhvqwKC5hcysTu8AKbtG8MOLYw5uSLc4w5qAxNaCgqxhSeqzNQBHXEAU7ZKbq
         boPrXJVEf1f15BZbdy8/QdMI5K9tonBFGC57bNoPq7AKApAENVRFGSsiF+//caN8uEXe
         o7xoBAAc4k1qWpR3m7D0LDpPVXMMODWMCmH2SDjD3zLv+SLbuwtsE4xoG9AsW1lGnWMp
         5uHIlFaHu4xiwfn6g3YfP2xwuIdcBLWI+9BZ8GkDfPFlNUz1ZlH0qKMYUOV1qgIoSaIo
         pZZA==
X-Gm-Message-State: AGi0PubMjkCPF0wtQsSyVDOvliPoz7RFyUjU8URZjTXnGLb3k8bjdoVu
        Knhkq9u82Qu7J2jRmealGCPAaLIWyxs=
X-Google-Smtp-Source: APiQypKF7Z1pWgqHQwpvGSxltL68sL3u0TgcAGA4dsmEQEdM5KnAfkMAllxOy/KpCUsdcaOMb3BuEg==
X-Received: by 2002:ac2:4573:: with SMTP id k19mr11272170lfm.144.1587413246095;
        Mon, 20 Apr 2020 13:07:26 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id x17sm351049lfg.36.2020.04.20.13.07.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 13:07:25 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id u10so9107948lfo.8
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 13:07:25 -0700 (PDT)
X-Received: by 2002:a19:9109:: with SMTP id t9mr11708783lfd.10.1587413245018;
 Mon, 20 Apr 2020 13:07:25 -0700 (PDT)
MIME-Version: 1.0
References: <67FF611B-D10E-4BAF-92EE-684C83C9107E@amacapital.net>
 <CAHk-=wjePyyiNZo0oufYSn0s46qMYHoFyyNKhLOm5MXnKtfLcg@mail.gmail.com>
 <CAPcyv4jQ3s_ZVRvw6jAmm3vcebc-Ucf7FHYP3_nTybwdfQeG8Q@mail.gmail.com>
 <CAHk-=wjSqtXAqfUJxFtWNwmguFASTgB0dz1dT3V-78Quiezqbg@mail.gmail.com>
 <CAPcyv4hrfZsg48Gw_s7xTLLhjLTk_U+PV0MsLnG+xh3652xFCQ@mail.gmail.com>
 <CAHk-=wgcc=5kiph7o+aBZoWBCbu=9nQDQtD41DvuRRrqixohUA@mail.gmail.com> <CAPcyv4iTaBNPMwqUwas+J4rxd867QL7JnQBYB8NKnYaTA-R_Tw@mail.gmail.com>
In-Reply-To: <CAPcyv4iTaBNPMwqUwas+J4rxd867QL7JnQBYB8NKnYaTA-R_Tw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 20 Apr 2020 13:07:09 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgOUOveRe8=iFWw0S1LSDEjSfQ-4bM64eiXdGj4n7Omng@mail.gmail.com>
Message-ID: <CAHk-=wgOUOveRe8=iFWw0S1LSDEjSfQ-4bM64eiXdGj4n7Omng@mail.gmail.com>
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

On Mon, Apr 20, 2020 at 12:29 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
>  I didn't consider asynchronous to be
> better because that means there is a gap between when the data
> corruption is detected and when it might escape the system that some
> external agent could trust the result and start acting on before the
> asynchronous signal is delivered.

The thing is, absolutely nobody cares whether you start acting on the
wrong data or not.

Even if you use the wrong data as a pointer, and get other wrong data
behind it (or take an exception), that doesn't change a thing: the end
result is still the exact same thing "unpredictably wrong data". You
didn't really make things worse by continuing, and people who care
about some very particular case can easily add a barrier to get any
error before they go past some important point.

It's not like Intel hasn't done that before. It's how legacy FP
instructions work - and while the legacy FP unit had horrendous
problems, the delayed exception wasn't one of them (routing it to
irq13 was, but that's on IBM, not Intel). Async exception handling
simplifies a lot of problems, and in fact, if you then have explicit
"check now" points (which the Intel FPU also had, as long as you
didn't have that nasty irq13 routing), it simplifies software too.

So there is no _advantage_ to being synchronous to the source of the
problem.  There is only pain.

There are lots and lots of disadvantages, most of them being
variations - on many different levesl of - "it hit at a point where I
cannot recover".

The microcode example is one such example that Intel engineers should
really take to heart. But the real take-away is that it is only _one_
such example. And making the microcode able to recover doesn't fix all
the _other_ places that aren't able to recover at that point, or fix
the fundamental pain.

For example, for the kernel, NMI's tend to be pretty special things,
and we simply may not be able to handle errors inside an NMI context.
It's not all that unlike the intel microcode example, just at another
level.

But we have lots of other situations. We have random
compiler-generated code, and we're simply not able to take exceptions
at random stages and expect to recover. We have very strict rules
about "this might be unsafe", and a normal memory access of a trusted
pointer IS NOT IT.

But at a higher level, something like "strnlen()" - or any other
low-level library routine - isn't really all that different from
microcode for most programs. We don't want to have a million copies of
"standard library routine, except for nvram".

The whole - and ONLY - point of something like nvram is that it's
supposed to act like memory. It's part of the name, and it's very much
part of the whole argument for why it's a good idea.

And the advantage of it being memory is that you are supposed to be
able to do all those random operations that you just do normally on
any memory region - ask for string lengths, do copies, add up numbers,
look for patterns. Without having to do an "IO" operation for it.

Taking random synchronous faults is simply not acceptable. It breaks
that fundamental principle.

Maybe you have a language with a try/catch/throw model of exception
handling - but one where throwing exceptions is constrained to happen
for documented operations, not any random memory access. That's very
common, and kind of like what the kernel exception handling does by
hand.

So an allocation failure can throw an exception, but once you've
allocated memory, the language runtime simply depends on knowing that
it has pointer safety etc, and normal accesses won't throw an
exception.

In that kind of model, you can easily add a model where "SIGBUS sets a
flag, we'll handle it at catch time", but that depends on things being
able to just continue _despite_ the error.

So a source-synchronous error can be really hard to handle. Exception
handling at random points is simply really really tough in general -
and there are few more random and more painful points than some "I
accessed memory".

So no. An ECC error is nothing like a page fault. A page fault you
have *control* over. You can have a language without the ability to
generate wild pointers, or you can have a language like C where wild
pointers are possible, but they are a bug. So you can work on the
assumption that a page fault is always entirely invisible to the
program at hand.

A synchronous ECC error doesn't have that "entirely invisible to the
program at hand" behavior.

And yes, I've asked for ECC for regular memory for regular CPU's from
Intel for over two decades now. I do NOT want their broken machine
check model with it. I don't even necessarily want the "correction"
part of it - I want reporting of "your hardware / the results of your
computation is no longer reliable". I don't want a dead machine, I
don't want some worry about "what happens if I get an ECC error in
NMI", I don't want any of the problems that come from taking an
absolute "ECC errors are fatal" approach. I just want "an error
happened", with as much information about where it happened as
possible.

                 Linus
