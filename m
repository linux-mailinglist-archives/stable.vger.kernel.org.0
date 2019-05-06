Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2291550E
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 22:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfEFUsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 16:48:04 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38816 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfEFUsE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 May 2019 16:48:04 -0400
Received: by mail-lj1-f193.google.com with SMTP id u21so3196031lja.5
        for <stable@vger.kernel.org>; Mon, 06 May 2019 13:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LN8/NTM9pRgOW6Qf1pdY0qkm+a38UqLa0bBTAH2+TkU=;
        b=evA/FZOl+4vi7XMcxBB/gYj89Z6IdHQ5/igigK5Y+YPsXpuGYwuw6t4TEIDlA60P57
         BPb+CmUxzNVrjEfc4zrJ5mmulbz8GTGhJS3vzxORSu4CzH/aGkuq6kd1492nwVstVwD7
         +BsguG7MutEBgjcZlB/Jrxx7a0wvgr9VRX8Jo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LN8/NTM9pRgOW6Qf1pdY0qkm+a38UqLa0bBTAH2+TkU=;
        b=KdrMi6EHNZ2Jw5cjY/Xwe0ersTT0+lFvbE8XYqVu0iDX1HrmRTXvuNwzeXQf0XT7+v
         6DwoIoSFWnZUaAhj1IjZ4zQW9p2KG79kP5EK/Vf9O80SRRFZen5tCZa8ItchPzgPN3AH
         0ItjdpMnnG5sK1fyRG4ou22sl3t6sy95sKO/twzI1BGtClgFPPKV63MROAlOSE+Tg5Jb
         t/BASlgvABQpl1OiFTSWipEjEvjP6UK4HV042ZC/aMFJJmf3ENisHUB/xbE1J6DjiUvB
         1UB+Mj/FTLlLdreirOioZGXFUGUuxzefKe2svmIm9RSqVAg/2VgHZaiPy66/q8lCskgl
         O65Q==
X-Gm-Message-State: APjAAAUXnZmMX++6fcsJnxgXrMn6Yqxt1duru21zb1Bpyza2GZ1OurYe
        DJKHEEbObksL6/PkAOu72sdyqs5lIZU=
X-Google-Smtp-Source: APXvYqx6JS7zp/hywOMIhwZDPexx38h9T2KIE6cJpfwetkbN2iDIi1pW9LK4J2rXRZXgTpLjdK0QMA==
X-Received: by 2002:a2e:63d1:: with SMTP id s78mr10218046lje.166.1557175681331;
        Mon, 06 May 2019 13:48:01 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id w17sm1046271ljd.41.2019.05.06.13.48.00
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 13:48:01 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id o16so10149508lfl.7
        for <stable@vger.kernel.org>; Mon, 06 May 2019 13:48:00 -0700 (PDT)
X-Received: by 2002:a19:f50e:: with SMTP id j14mr13952445lfb.11.1557175348252;
 Mon, 06 May 2019 13:42:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190502181811.GY2623@hirez.programming.kicks-ass.net>
 <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
 <20190502202146.GZ2623@hirez.programming.kicks-ass.net> <20190502185225.0cdfc8bc@gandalf.local.home>
 <20190502193129.664c5b2e@gandalf.local.home> <20190502195052.0af473cf@gandalf.local.home>
 <20190503092959.GB2623@hirez.programming.kicks-ass.net> <20190503092247.20cc1ff0@gandalf.local.home>
 <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net> <CAHk-=wjrOLqBG1qe9C3T=fLN0m=78FgNOGOEL22gU=+Pw6Mu9Q@mail.gmail.com>
 <20190506081951.GJ2606@hirez.programming.kicks-ass.net> <20190506095631.6f71ad7c@gandalf.local.home>
 <CAHk-=wgw_Jmn1iJWanoSFb1QZn3mbTD_JEoMsWcWj5QPeyHZHA@mail.gmail.com>
 <20190506130643.62c35eeb@gandalf.local.home> <CAHk-=whesas+GDtHZks62wqXWXe4d_g3XJ359GX81qj=Fgs6qQ@mail.gmail.com>
 <20190506145745.17c59596@gandalf.local.home> <CAHk-=witfFBW2O5v6g--FmqnAFsMkKNLosTFfWyaoJ7euQF8kQ@mail.gmail.com>
 <20190506162915.380993f9@gandalf.local.home>
In-Reply-To: <20190506162915.380993f9@gandalf.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 6 May 2019 13:42:12 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi5KBWUOvM94aTOPnoJ5L_aQG=vgLQ4SxxZDeQD0pF2tQ@mail.gmail.com>
Message-ID: <CAHk-=wi5KBWUOvM94aTOPnoJ5L_aQG=vgLQ4SxxZDeQD0pF2tQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Juergen Gross <jgross@suse.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nayna Jain <nayna@linux.ibm.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Joerg Roedel <jroedel@suse.de>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 6, 2019 at 1:29 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Because that call to ftrace_stub is also dynamic.

You're missing the point.

We are rewriting a single "cal" instruction to point to something.

The "int3" emulation should call THE SAME THING.

Right now it doesn't.

> Part of the code will change it to call the function needed directly.
>
> struct ftrace_ops my_ops {
>         .func = my_handler
> };
>
>         register_ftrace_function(&my_ops);
>
> Will change "call ftrace_stub" into "call my_handler"

But that's not what you're actually *doing*.

Instead, you're now _emulating_ calling ftrace_regs_caller, which will
call that ftrace_stub, which in turn will try to update the call site.

But that's insane. It's insane because

 - it's not even what your call rewriting is doing Why aren't you just
doing the emulation using the *SAME* target that you're rewriting the
actual call instruction with?

 - even if ftrace_regs_caller ends up being that same function, you'd
be better off just passing the "struct pt_regs" that you *ALREADY
HAVE* directly to ftrace_stub in the int3 handler, rather than create
*another* pt_regs stack

See? In that second case, why don't you just use "int3_emulate_call()"
to do the reguired 'struct pt_regs' updates, and then call
ftrace_stub() *with* that fixed-up pt_regs thing?

In other words, I think you should always do "int3_emulate_call()"
with the *exact* same address that the instruction you are rewriting
is using. There's no "three different cases". The only possible cases
are "am I rewriting a jump" or "am I rewriting a call".

There is no "am I rewriting a call to one address, and then emulating
it with a call to another address" case that makes sense.

What *can* make sense is "Oh, I'm emulating a call, but I know that
call will be rewritten, so let me emulate the call and then
short-circuit the emulation immediately".

But that is not what the ftrace code is doing. The ftrace code is
doing something odd and insane.

And no, your "explanation" makes no sense. Because it doesn't actually
touch on the fundamental insanity.

            Linus
