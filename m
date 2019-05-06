Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A59B15129
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 18:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbfEFQYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 12:24:25 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41498 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbfEFQYZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 May 2019 12:24:25 -0400
Received: by mail-lf1-f65.google.com with SMTP id d8so9585290lfb.8
        for <stable@vger.kernel.org>; Mon, 06 May 2019 09:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gdKWMzG0jTPJKQefPY2Ldaf6Ms3KDojiEWREzp6GY/0=;
        b=acUkx/SyXE0iTsaLBqBApazjPIDAcpKLa6eanB/pwg3/nd2wX7zX61gfnOb7YkZ3Ll
         QSKrbp97fW9PaMvvakbU30HZC6d9E8ZxMJWyn8rtqBZLvZSLIjhpYOKX3sVWKA+T51pr
         jCo9GXVhBGPddoOghrCGtgtxD8b+3ePfN7F28=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gdKWMzG0jTPJKQefPY2Ldaf6Ms3KDojiEWREzp6GY/0=;
        b=H0XENVlbw5fijAPIOxAihPbNefuD7JWiHUg8cquDuPJPYDadWNx4y1TBnV5B0g/JCv
         OgnVPLA4nihBsg63GGJwfq1q6aVQu8Zo2NSjya7tdyZWueRHUpS+QgTRfYBIfwOrTm64
         CUVq7e3qep5EIyq+a9PSoXrKUmNNX+ezL0pdmIy2BrV75vfdAfvTHFzYhHigy55tx36d
         dviaUklYJyvXl83GPsfv5fkRbFM5Rzq7fBPmeLGEJR0hZynWUnIzRvebwoOPfxXwsjPv
         g85yI319iIfR7W1GyVlZZFdhgbVMRmltZ58m4tIDyEqotMrt90FD2M7rHCwR4XZZSpM7
         k5Ug==
X-Gm-Message-State: APjAAAUY/5lQYZ1KxXPdPwnEBWnzXSamWestpwnKf2sB7S1T+IyvszPO
        cKOperfUTqPuRTRqmu/6WhlhJeyou8Y=
X-Google-Smtp-Source: APXvYqz1O0Z7BCcZs/AEZKnE9n4VwIesZPzD8dRg4BBNDhcsIkRg+WoobJNPB7138BTOykE6w5D7OA==
X-Received: by 2002:ac2:5381:: with SMTP id g1mr13374793lfh.130.1557159861942;
        Mon, 06 May 2019 09:24:21 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id m12sm2501952lfk.21.2019.05.06.09.24.21
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 09:24:21 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id h126so9597334lfh.4
        for <stable@vger.kernel.org>; Mon, 06 May 2019 09:24:21 -0700 (PDT)
X-Received: by 2002:a19:ec07:: with SMTP id b7mr7420419lfa.62.1557159455483;
 Mon, 06 May 2019 09:17:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190502181811.GY2623@hirez.programming.kicks-ass.net>
 <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
 <20190502202146.GZ2623@hirez.programming.kicks-ass.net> <20190502185225.0cdfc8bc@gandalf.local.home>
 <20190502193129.664c5b2e@gandalf.local.home> <20190502195052.0af473cf@gandalf.local.home>
 <20190503092959.GB2623@hirez.programming.kicks-ass.net> <20190503092247.20cc1ff0@gandalf.local.home>
 <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net> <CAHk-=wjrOLqBG1qe9C3T=fLN0m=78FgNOGOEL22gU=+Pw6Mu9Q@mail.gmail.com>
 <20190506081951.GJ2606@hirez.programming.kicks-ass.net> <20190506095631.6f71ad7c@gandalf.local.home>
In-Reply-To: <20190506095631.6f71ad7c@gandalf.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 6 May 2019 09:17:19 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgw_Jmn1iJWanoSFb1QZn3mbTD_JEoMsWcWj5QPeyHZHA@mail.gmail.com>
Message-ID: <CAHk-=wgw_Jmn1iJWanoSFb1QZn3mbTD_JEoMsWcWj5QPeyHZHA@mail.gmail.com>
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

On Mon, May 6, 2019 at 6:56 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> I can test this too. I was hoping to get this in by this merge window.
> I spent 3 hours yesterday trying to get Linus's version working on
> i386 with no success. Not sure how much time Linus will have to look at
> this, as he just opened the merge window.

I acvtually just tested it in qemu, and it worked fine.

Ok, so my test was admittedly really simple and stupid, in that al I did was

        printk("Before int3\n");
        asm("int3; nop; nop; nop; nop" : : :"ax","dx","cx");
        printk("After int3\n");

and then I hacked up do_kernel_int3() to just unconditionally do

        return int3_emulate_call(regs, (unsigned long)test_int3);

with a stupid test-function:

    void test_int3(void)
    {
        printk("In int3 handler");
    }

instead fo anything fancy.

But it did exactly the expected thing, and resulted in

    Before int3
    In int3 handler
    After int3

on the screen.

So what is it that doesn't actually work? I've looked at the patch
even more, and I can't for the life of me see how it wouldn't work.

Of course, I didn't test any of the actual ftrace parts, since I
short-circuited them intentionally with the above test function hack.
I have no idea what the semantics for those
ftrace_location(ip)/is_ftrace_caller(ip) cases are supposed to be, I
only tested that yes, the infrastructure clearly emulates a call
instruction.

               Linus
