Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93FE2168EE
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 19:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfEGRRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 13:17:00 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33404 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbfEGRRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 13:17:00 -0400
Received: by mail-lj1-f196.google.com with SMTP id f23so15061957ljc.0
        for <stable@vger.kernel.org>; Tue, 07 May 2019 10:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4KUGjoGcov4BXfpien7M8qYX6aNwFIJx0EHxkMkElaU=;
        b=Z6iOqWkun3Jd9gm+DDXapbbb/k9j2i/UbgOnfBaxIvdIF4vaABZyWVyhCMkwQcCtGG
         NQgm6OFnvaJSbD3GdDXE3LA3StNA2Owk7D3wKvpNJgS7nbxcRNbrQfL9JRdZ0dVFZyOm
         4T9KbfhkVqyCfzVxsGzk8bboSYGtVl76YPyag=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4KUGjoGcov4BXfpien7M8qYX6aNwFIJx0EHxkMkElaU=;
        b=cwBlQkMgw8lxD3mFIAMOlLyJLEO1SKtgYN3HJnFoJHePLbGLijpS3C7vOQDu6+jMK+
         VG96xsmGrnegOLUqUm16KqENSpjLD4E6Asvg6AYrm+H1aOObWaU23uXX3COSXulBIMkJ
         DQgN3q31o2+psh2ZtCcXx7UW3WbToE4v67QsJBGcP3gTtyhMLI03TihHRqWM12wFvbOp
         9faqLJmi2mtxDz53c6k87DZzPXg7h+XD37PMMUkvqpLBRaWCy3YzciYiKd6g9OBWHzJd
         7Ifn8HRQm8U119+mTPtkwMpLPSpSsbwa2XfzeLxljrH2drvXVx4PfmZcGR0eYRFV2dlW
         6UqA==
X-Gm-Message-State: APjAAAUqKJ4ZqAFCAn0NaZRePYdfxM4dn/o0QxGQjigx04T3xLZ2nLmS
        N5VQ0pMnzgAVJ/iBioNIj75/NGZxTLs=
X-Google-Smtp-Source: APXvYqzSxkQUrz/bXM/Z2ocgOHK+qG2TSRyiCgHfuMyedHuvbtKJTYO23VaE3rARq6ABA5m1UCjYYQ==
X-Received: by 2002:a2e:9155:: with SMTP id q21mr16243294ljg.178.1557249417687;
        Tue, 07 May 2019 10:16:57 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id d6sm2184688lfm.20.2019.05.07.10.16.57
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 10:16:57 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id h21so14991708ljk.13
        for <stable@vger.kernel.org>; Tue, 07 May 2019 10:16:57 -0700 (PDT)
X-Received: by 2002:a2e:9044:: with SMTP id n4mr2888004ljg.94.1557248948170;
 Tue, 07 May 2019 10:09:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=whZwqzbu-=1r_j_cXfd=ta1q7RFCuneqBZfQQhS_P-BmQ@mail.gmail.com>
 <20190506215353.14a8ef78@oasis.local.home> <CAHk-=wjLXmOn=Cp=uOfO4gE01eN_-UcOUyrMTTw5-f_OfPO48Q@mail.gmail.com>
 <20190506225819.11756974@oasis.local.home> <CAHk-=wh4FCNBLe8OyDZt2Tr+k9JhhTsg3H8R4b55peKcf0b6eQ@mail.gmail.com>
 <20190506232158.13c9123b@oasis.local.home> <CAHk-=wi4vPg4pu6RvxQrUuBL4Vgwd2G2iaEJVVumny+cBOWMZw@mail.gmail.com>
 <CAHk-=wg2_okyU8mpkGCUrudgfg8YmNetSD8=scNbOkN+imqZdQ@mail.gmail.com>
 <20190507111227.1d4268d7@gandalf.local.home> <CAHk-=wjYdj+vvV8uUA8eaUSxOhu=xuQxdo-dtM927j0-3hSkEw@mail.gmail.com>
 <20190507163440.GV2606@hirez.programming.kicks-ass.net>
In-Reply-To: <20190507163440.GV2606@hirez.programming.kicks-ass.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 7 May 2019 10:08:50 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiuue37opWK5QaQ9f6twqDZuSratdP-1bK6kD9-Az5WnA@mail.gmail.com>
Message-ID: <CAHk-=wiuue37opWK5QaQ9f6twqDZuSratdP-1bK6kD9-Az5WnA@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
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
        <linux-kselftest@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 7, 2019 at 9:34 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> Would you consider my approach later on, under the guise of unification?

WHY?

The *only* advantage of your patch is that trivial "look up kernel stack" macro.

Seriously. There's absolutely nothing else.

Is that macro ugly? Yes. But it's directly explainable by just
pointing to the architecture documentation.

It's a one-liner hack.

And for that, you want to complicate the x86-32 entry and exit code?

Do we have different emulation for "push" on 32-bit and 64-bit? Yes.
But again, that's just how the hardware works. This is not some
"generic hw-independent code". This is literally emulating
instructions that care about instruction encoding and bit size
details, where there are certainly _similarities_ (and in the case of
'call', they look bit-identical), but it's also not like "same code"
is a big argument. That's why we have a helper function, to hide the
details.

I point to my diffstat once again. It's smaller, and I argue that it
is actually conceptually *simpler* to simply say "this is how the
architecture works".

And yes, I realize that I may be biased by the fact that I simply know
i386 so well, so to me it simply makes more sense to just work with
what the hardware gives us. The i386 exception model with the kernel
stack nesting is a *hell* of a lot simpler than the x86-64 one. The
fact is, x86-64 messed things up, and swapgs and friends are an
abomination against God.

So the whole "let's clean up x86-32 to look like x86-64, which got
things right" is to me a completely bogus argument. x86-64 got the
"yes, push ss/sp unconditionally" part right, but got a lot of other
things horribly wrong. So this is all just one small detail that
differs, across two architectures that are similar but have very
different warts.

But that diffstat is still hard, cold, unbiased data.

                    Linus
