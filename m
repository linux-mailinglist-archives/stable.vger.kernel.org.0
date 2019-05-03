Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5172013612
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 01:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbfECXRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 19:17:21 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36742 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbfECXRV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 19:17:21 -0400
Received: by mail-lf1-f68.google.com with SMTP id u17so5492141lfi.3
        for <stable@vger.kernel.org>; Fri, 03 May 2019 16:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OHqZ1dasojZtZXeDb6AOgPCoclYuOoFb8Dw9XhQcuX8=;
        b=Z5lqxrRs7Uo5ooOZcjNQMQ0wMKgNkbdgLGUsuVX4JfUFji1uCAkCzJ4BGPfIaizpY6
         JWe5m/qV8Q8llt6hrEswIs+Q/3t9J9sE6JAaJ3czcaSnBtxbhbEqSZL2NpE9lbHSXdrI
         gxKi90AMf5eRvy/aupAWhDZHVdVjhL/W1hUdk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OHqZ1dasojZtZXeDb6AOgPCoclYuOoFb8Dw9XhQcuX8=;
        b=ZXMlPiiCR+13QnXODE5sOhI2r8WX5oiXHNeqYtSBE9tkB90bgv+Z/B15XWXUUvvBQU
         ep50HiEcUYA9n9NWk54YXMb4OpK00CMW7IHwLAPeC/sASAkY3Cc7y66IaOkxLv85CVK8
         KSWD4L/q8/wdyHgKOf+nR6hHnZAeiBQc2KJxkBoRxMsHyZZWBPJgKdhsZfUg5wRx6uwL
         6n2ZJYuw9p/CUHWa3R9cw395L34ACUcqeu4LSzkypS7HpwiddsPkyQodMBc+aZwaF41p
         PF73G52ba0KSb8g0UwwzAAFS/ai6WL3VRpp7WDdwP85XNwg+KZeDoQWbLPLThSf/wHMg
         1W2A==
X-Gm-Message-State: APjAAAWOrApjNPy81uG6wGyfSGiAMNqftL4TE7VhVUYbDJd4uzaIcuUg
        sk7JU1jzWZTgfr6WK1yct4W5yicCPW4=
X-Google-Smtp-Source: APXvYqzLzV9VFtoOURbbmXLUWn4k+0GLtEj0hQOyRScImhJg3hrWSuw1GZXv3lEco0saEi3MuKHcMQ==
X-Received: by 2002:ac2:5181:: with SMTP id u1mr6703989lfi.59.1556925438793;
        Fri, 03 May 2019 16:17:18 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id t17sm615885ljg.70.2019.05.03.16.17.16
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 16:17:18 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id q10so6547767ljc.6
        for <stable@vger.kernel.org>; Fri, 03 May 2019 16:17:16 -0700 (PDT)
X-Received: by 2002:a2e:890a:: with SMTP id d10mr5422300lji.94.1556925434455;
 Fri, 03 May 2019 16:17:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190501202830.347656894@goodmis.org> <20190501203152.397154664@goodmis.org>
 <20190501232412.1196ef18@oasis.local.home> <20190502162133.GX2623@hirez.programming.kicks-ass.net>
 <CAHk-=wijZ-MD4g3zMJ9W2r=h8LUWneiu29OWuxZEoSfAF=0bhQ@mail.gmail.com>
 <20190502181811.GY2623@hirez.programming.kicks-ass.net> <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
 <20190502202146.GZ2623@hirez.programming.kicks-ass.net> <CAHk-=wh8bi5c_GkyjPtDAiaXaZRqtmhWs30usUvs4qK_F+c9tg@mail.gmail.com>
 <20190503152405.2d741af8@gandalf.local.home> <CAHk-=wiA-WbrFrDs-kOfJZMXy4zMo9-SZfk=7B-GfmBJ866naw@mail.gmail.com>
 <2962A4E4-3B9F-4195-9C6D-9932809D98F9@amacapital.net>
In-Reply-To: <2962A4E4-3B9F-4195-9C6D-9932809D98F9@amacapital.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 3 May 2019 16:16:58 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjZDhwStWvioV7totCnZfp74bqH0y1UJxkmFfdLg48wDA@mail.gmail.com>
Message-ID: <CAHk-=wjZDhwStWvioV7totCnZfp74bqH0y1UJxkmFfdLg48wDA@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
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

On Fri, May 3, 2019 at 3:55 PM Andy Lutomirski <luto@amacapital.net> wrote:
>
> But I think this will end up worse than the version where the entry code fixes it up.  This is because, if the C code moves pt_regs, then we need some way to pass the new pointer back to the asm.

What? I already posted that code. Let me quote it again:

Message-ID: <CAHk-=wh8bi5c_GkyjPtDAiaXaZRqtmhWs30usUvs4qK_F+c9tg@mail.gmail.com>

        # args: pt_regs pointer (no error code for int3)
        movl %esp,%eax
        # allocate a bit of extra room on the stack, so that
        # 'kernel_int3' can move the pt_regs
        subl $8,%esp
        call kernel_int3
        movl %eax,%esp

It's that easy (this is with the assumption that we've already applied
the "standalone simple int3" case, but I think the above might work
even with the current code model, just the "call do_int3" needs to
have the kernel/not-kernel distinction and do the above for the kernel
case)

That's *MUCH* easier than your code to move entries around on the
stack just as you return, and has the advantage of not changing any
C-visible layout.

The C interface looks like this

    /* Note: on x86-32, we can move 'regs' around for push/pop emulation */
    struct pt_regs *kernel_int3(struct pt_regs *regs)
    {
        ..
        .. need to pass regs to emulation functions
        .. and call emulation needs to return it
        ..
        return regs;
    }

and I just posted as a response to Stephen the *trivial* do_int3()
wrapper (so that x86-64 doesn't need to care), and the *trivial* code
to actually emulate a call instruction.

And when I say "trivial", I obviously mean "totally untested and
probably buggy", but it sure seems *simple*.,

Notice? Simple and minimal changes to entry code that only affect
int3, and nothing else.

                 Linus
