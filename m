Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 490E5154A6
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 21:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfEFTwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 15:52:41 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37500 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbfEFTwl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 May 2019 15:52:41 -0400
Received: by mail-lj1-f193.google.com with SMTP id 132so4454910ljj.4
        for <stable@vger.kernel.org>; Mon, 06 May 2019 12:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v4kkKa3SRWQVadtU9idY39CCQftkxcpIoOM0XAJqBTM=;
        b=cdF+EPKS6Ge2/s30X7OzfVs/i8EBdXNa487B1p2vGBTd+n7CgEMvurpKHpXcLVem3u
         rzevt8MxZIrbBVHT/2blPyzn4vnzFxGcHXwbP4Rlh59f3LBxbz5pPdNbdmV6lS7efsQa
         93j00k6IAskp5TeuRRIvJP0yqXdlZxHNFN5Nw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v4kkKa3SRWQVadtU9idY39CCQftkxcpIoOM0XAJqBTM=;
        b=LAPxfytWLICTe5wJ2v5pDJmFGmNKFcxHTAg7yus9r3us9DRyQE6Tc0VsggByNKgXzk
         1gsDUUz+qqgyHqwcOwe/1bP0OovH4iht3ewqTltqsRGBaLn6W0ytamqxEAVTxCXYf18t
         +yha2EAGEX3Xxb5oqjReCScO9r6fV0+07UDqXOWEcDbxeZPUEfDHVVbZKcPQh4OOMqJv
         b9MmalR9ZafKBLzLtxk/7pHvY44MRctjAhmGW5lUgk88fFrw3J9qH6TYzECiQZMnjxam
         0OfNsFDjGCUzeVWdgG5oi+7F12T0F3lqMHBjE66sCFEbMnfq1EcytaFoq4MiVGtnE0Rj
         nnsw==
X-Gm-Message-State: APjAAAXSnDbcHGhlz9mP3Qq+p8vzQ8QYjOeRIEqzUsQwpeh5Ajqzq2zE
        52Ql2d212RhX3rBHlZFID6VZAay1XGU=
X-Google-Smtp-Source: APXvYqyGEoRt72u0aKkiU9xa0u57H884m7YcBQQmyZyj+gyW5bVGDUlABT58/IK4ScxqIbBcQhF5PQ==
X-Received: by 2002:a2e:3a0a:: with SMTP id h10mr12726777lja.1.1557172358496;
        Mon, 06 May 2019 12:52:38 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id n18sm1512254ljj.95.2019.05.06.12.52.38
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 12:52:38 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id u27so9783873lfg.10
        for <stable@vger.kernel.org>; Mon, 06 May 2019 12:52:38 -0700 (PDT)
X-Received: by 2002:ac2:43cf:: with SMTP id u15mr13815824lfl.67.1557171988295;
 Mon, 06 May 2019 12:46:28 -0700 (PDT)
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
 <20190506145745.17c59596@gandalf.local.home>
In-Reply-To: <20190506145745.17c59596@gandalf.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 6 May 2019 12:46:11 -0700
X-Gmail-Original-Message-ID: <CAHk-=witfFBW2O5v6g--FmqnAFsMkKNLosTFfWyaoJ7euQF8kQ@mail.gmail.com>
Message-ID: <CAHk-=witfFBW2O5v6g--FmqnAFsMkKNLosTFfWyaoJ7euQF8kQ@mail.gmail.com>
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

On Mon, May 6, 2019 at 11:57 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> You should have waited another week to open that merge window ;-)

Hmm. I'm looking at it while the test builds happen, and since I don't
see what's wrong in the low-level entry code, I'm looking at the
ftrace code instead.

What's going on here?

               *pregs = int3_emulate_call(regs, (unsigned
long)ftrace_regs_caller);

that line makes no sense. Why would we emulate a call to
ftrace_regs_caller()? That function sets up a pt_regs, and then calls
ftrace_stub().

But we *have* pt_regs here already with the right values. Why isn't
this just a direct call to ftrace_stub() from within the int3 handler?

And the thing is, calling ftrace_regs_caller() looks wrong, because
that's not what happens for *real* mcount handling, which uses that
"create_trampoline()" to create the thing we're supposed to really
use?

Anyway, I simply don't understand the code, so I'm confused. But why
is the int3 emulation creating a call that doesn't seem to match what
the instruction that we're actually rewriting is supposed to do?

IOW, it looks to me like ftrace_int3_handler() is actually emulating
something different than what ftrace_modify_code() is actually
modifying the code to do!

Since the only caller of ftrace_modify_code() is update_ftrace_func(),
why is that function not just saving the target and we'd emulate the
call to that? Using anything else looks crazy?

But as mentioned, I just don't understand the ftrace logic. It looks
insane to me, and much more likely to be buggy than the very simple
entry code.

             Linus
