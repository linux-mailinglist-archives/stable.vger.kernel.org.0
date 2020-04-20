Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835BA1B1770
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 22:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgDTUqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 16:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726644AbgDTUqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 16:46:39 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34F5C061A0E
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 13:46:38 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id w145so9215420lff.3
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 13:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LlaaVbm8PuebFJl/q63Tt+vA9aaeM21+f84Se7YPrVk=;
        b=IeyZiD2b5ww4LcmgBhjJAIyDJH/nL1yFN68MXiPJ5Rxcul6oFhjIyBWGxbK06/bW34
         3s7lJfT9DTUdt4FDYgflOIqw5NeAOwgt0vX4JgYIi4os7Dw7D9EOJbsrdiluBqX2dEfL
         KnnfIX9RrBlu8lC5HNlW/lH1/EQZTSFFinSss=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LlaaVbm8PuebFJl/q63Tt+vA9aaeM21+f84Se7YPrVk=;
        b=XtHEPHedw3j/byT/ttqoRukYp2DAzR2w79sBlCcttYxszzoOZpY1FpZgfCTJ7aHDmp
         B0mA2RHO4GhcuaFPxSflcX0SS01yC5zIJVvQS71ltWfV0uIDqjaEdTi/tRFsY5T31cPU
         sJA8RqECTUrN6VA39S5pGcTfNLmpu9XguCv5Ouv6JNCzVfFT7VH1hTYambhbBas7znho
         34mB/1ly25W8/BVlgbpfuqV8zXk6xqWPeFLWITYNU+j/EAR/fyEpApqQjfQ7WMvVns6U
         AU7iWxQPBdA3DUJt1k6mlnBz2W98dTBEHgOba33n7uiiIAgD4MBwrMnImvpl7odT2PI7
         dddw==
X-Gm-Message-State: AGi0Puabwk+omx2KJlsfaOwZ9c9N6EjGwd/BD/tM+ojbm0Sof7fjoEC4
        UFmE2hINsvUAxq8pfMGpxehLG/cf2BA=
X-Google-Smtp-Source: APiQypLK4gXBj48CNnn+atNZoE820eZzGcLbtBy/XuAmwcmB5fNpDjglp929620gYdRNQdPnX5+Hzw==
X-Received: by 2002:a19:40d0:: with SMTP id n199mr11679025lfa.161.1587415596012;
        Mon, 20 Apr 2020 13:46:36 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id u3sm404755lff.26.2020.04.20.13.46.34
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 13:46:35 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id q19so11564245ljp.9
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 13:46:34 -0700 (PDT)
X-Received: by 2002:a2e:814e:: with SMTP id t14mr878197ljg.204.1587415594444;
 Mon, 20 Apr 2020 13:46:34 -0700 (PDT)
MIME-Version: 1.0
References: <67FF611B-D10E-4BAF-92EE-684C83C9107E@amacapital.net>
 <CAHk-=wjePyyiNZo0oufYSn0s46qMYHoFyyNKhLOm5MXnKtfLcg@mail.gmail.com>
 <CAPcyv4jQ3s_ZVRvw6jAmm3vcebc-Ucf7FHYP3_nTybwdfQeG8Q@mail.gmail.com>
 <CAHk-=wjSqtXAqfUJxFtWNwmguFASTgB0dz1dT3V-78Quiezqbg@mail.gmail.com>
 <CAPcyv4hrfZsg48Gw_s7xTLLhjLTk_U+PV0MsLnG+xh3652xFCQ@mail.gmail.com>
 <CAHk-=wgcc=5kiph7o+aBZoWBCbu=9nQDQtD41DvuRRrqixohUA@mail.gmail.com>
 <CAPcyv4iTaBNPMwqUwas+J4rxd867QL7JnQBYB8NKnYaTA-R_Tw@mail.gmail.com>
 <CAHk-=wgOUOveRe8=iFWw0S1LSDEjSfQ-4bM64eiXdGj4n7Omng@mail.gmail.com> <CAPcyv4hKcAvQEo+peg3MRT3j+u8UdOHVNUWCZhi0aHaiLbe8gw@mail.gmail.com>
In-Reply-To: <CAPcyv4hKcAvQEo+peg3MRT3j+u8UdOHVNUWCZhi0aHaiLbe8gw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 20 Apr 2020 13:46:18 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj0yVRjD9KgsnOD39k7FzPqhG794reYT4J7HsL0P89oQg@mail.gmail.com>
Message-ID: <CAHk-=wj0yVRjD9KgsnOD39k7FzPqhG794reYT4J7HsL0P89oQg@mail.gmail.com>
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

On Mon, Apr 20, 2020 at 1:25 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> ...but also some kind of barrier semantic, right? Because there are
> systems that want some guarantees when they can commit or otherwise
> shoot the machine if they can not.

The optimal model would likely be a new instruction that could be done
in user space and test for it, possibly without any exception at all
(because the thing that checks for errors is also presumably the only
thing that can decide how to recover - so raising an exception doesn't
necessarily help).

Together with a way for the kernel to save/restore the exception state
on task switch (presumably in the xsave area) so that the error state
of one process doesn't affect another one. Bonus points if it's all
per-security level, so that a pure user-level error report doesn't
poison the kernel state and vice versa.

That is _very_ similar to how FPU exceptions work right now. User
space can literally do an operation that creates an error on one CPU,
get re-scheduled to another one, and take the actual signal and read
the exception state on that other CPU.

(Of course, the "not even take an exception" part is different).

An alternate very simple model that doesn't require any new
instructions and no new architecturally visible state (except of
course the actual error data) would be to just be raising a *maskable*
trap (with the Intel definition of trap vs exception: a trap happens
_after_ the instruction).

The trap could be on the next instruction if people really want to be
that precise, but I don't think it even matters. If it's delayed until
the next serializing instruction, that would probably be just fine
too.

But the important thing is that it

 (a) is a trap, not an exception - so the instruction has been done,
and you don't need to try to emulate it or anything to continue.

 (b) is maskable, so that the trap handler can decide to just mask it
and return (and set a separate flag to then handle it later)

With domain transfers either being barriers, or masking it (so NMI and
external interrupts would presumably mask it for latency reasons)?

I dunno. Wild handwaving. But much better than that crazy
unrecoverable machine check model.

                   Linus
