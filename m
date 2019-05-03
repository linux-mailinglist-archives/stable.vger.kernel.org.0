Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECE3713211
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 18:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbfECQU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 12:20:59 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40616 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfECQU7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 12:20:59 -0400
Received: by mail-pf1-f195.google.com with SMTP id u17so3120881pfn.7
        for <stable@vger.kernel.org>; Fri, 03 May 2019 09:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=KZ7M2mWr1HgOjFYLO00FIxnzVOAK+l4FuiGi1wr1wow=;
        b=AKvvYHpJ2edjcm0204j+PW95iowk2lDK7GCc0BA/nSaF6MDeF0AIRnHVXuk6WBOY24
         FcaQymKNmQJ6pm2GWVojQ23VP1xtGzSP22dM3GLay0Sv1n+qpV809/ndAM30cjG3Qtcj
         S+z06FlWFGt+qUrsK7BrZD/QgWeRQQPOQl0JH5GrW7V0zKM1bmFzlf6OsH/w7K3roSun
         hJ7ZNZsvmswPBpD+I1pVnI1LmG33ZWGhrCx5WkmMteKy0ij31Mg+QopA8cGZ9m9GpRgV
         qCNybIBlnqbR8jGguO7m5y/C1qwwPhDgrs0lwmsWsMdgGLFnzB643lNtdv/V/V55e+r4
         JgCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=KZ7M2mWr1HgOjFYLO00FIxnzVOAK+l4FuiGi1wr1wow=;
        b=QTIk4CXXaYS3QYIh2+pEIayDwfNEhunbZu5xHBpj1oKHZRd41IomH7/OW2zbPiH/7O
         WT79qFHyn8Fpf/kt2dgg2Iq5lA6aGxa71OU/QEWjrnlNPGaKfQrB+9A9vVIi7XfY1RIb
         g13uKnwNMx/utLj0hm9yknAk6JpS4ZmJVd8lcyxM/78SLv2mEOyVTbKFRqLmECHBsDVv
         xFMOkH2kaycLT0YzdshtIMeAQ51+Ba38xdMF4KlSrAPaxX5sAuRI7YpSoYad+QgckcPC
         RjWt0MUNN9VH0ZSla6Z4Q2PDMZtMVOsR2Pxq2K2EouQWIQ+aym8z/+orOxAstunHcNgR
         2BoQ==
X-Gm-Message-State: APjAAAWyKSAV81nkO/AnYrkq+a8pmr90eEK8KZTEEv8jxyzsQeQNfi2q
        IaoDPs0iNBWcuw2yMJ3DCWGSLQ==
X-Google-Smtp-Source: APXvYqz27PSp/BKOF8HBP5MdA5oDqaxXNQsgs6iiXXWd28RIrWLPk7vwjcnah74eFGU3dKeS0GbWjw==
X-Received: by 2002:a63:f503:: with SMTP id w3mr11524403pgh.60.1556900457569;
        Fri, 03 May 2019 09:20:57 -0700 (PDT)
Received: from ?IPv6:2600:1010:b025:b35:85ec:5278:6fc6:7ef4? ([2600:1010:b025:b35:85ec:5278:6fc6:7ef4])
        by smtp.gmail.com with ESMTPSA id x4sm3519353pfm.19.2019.05.03.09.20.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 09:20:56 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16E227)
In-Reply-To: <20190503092247.20cc1ff0@gandalf.local.home>
Date:   Fri, 3 May 2019 09:20:55 -0700
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
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
Content-Transfer-Encoding: quoted-printable
Message-Id: <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net>
References: <20190501203152.397154664@goodmis.org> <20190501232412.1196ef18@oasis.local.home> <20190502162133.GX2623@hirez.programming.kicks-ass.net> <CAHk-=wijZ-MD4g3zMJ9W2r=h8LUWneiu29OWuxZEoSfAF=0bhQ@mail.gmail.com> <20190502181811.GY2623@hirez.programming.kicks-ass.net> <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com> <20190502202146.GZ2623@hirez.programming.kicks-ass.net> <20190502185225.0cdfc8bc@gandalf.local.home> <20190502193129.664c5b2e@gandalf.local.home> <20190502195052.0af473cf@gandalf.local.home> <20190503092959.GB2623@hirez.programming.kicks-ass.net> <20190503092247.20cc1ff0@gandalf.local.home>
To:     Steven Rostedt <rostedt@goodmis.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On May 3, 2019, at 6:22 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>=20
> On Fri, 3 May 2019 11:29:59 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
>=20
>=20
>> OMG, WTF, ARGH... That code is fsck'ing horrible. I'd almost argue to
>> always do the INT3 thing, just to avoid games like that.
>=20
> Hehe, that's almost the exact same thoughts I had when seeing this
> code ;-)
>=20
>>=20
>> That said; for normal traps &regs->sp is indeed the previous context --
>> if it doesn't fall off the stack. Your hack detects the regular INT3
>> frame. Howver if regs->sp has been modified (int3_emulate_push, for
>> example) your detectoring comes unstuck.
>=20
> Yep. I realized the issue as well. But wanted to make sure this did
> work when sp wasn't changed.
>=20
>>=20
>> Now, it is rather unlikely these two code paths interact, but just to be
>> safe, something like so might be more reliable:
>>=20
>>=20
>> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
>> index 4b8ee05dd6ad..aceaad0cc9a9 100644
>> --- a/arch/x86/kernel/ptrace.c
>> +++ b/arch/x86/kernel/ptrace.c
>> @@ -163,6 +163,9 @@ static inline bool invalid_selector(u16 value)
>>  * stack pointer we fall back to regs as stack if no previous stack
>>  * exists.
>>  *
>> + * There is a special case for INT3, there we construct a full pt_regs
>> + * environment. We can detect this case by a high bit in regs->cs
>> + *
>>  * This is valid only for kernel mode traps.
>>  */
>> unsigned long kernel_stack_pointer(struct pt_regs *regs)
>> @@ -171,6 +174,9 @@ unsigned long kernel_stack_pointer(struct pt_regs *re=
gs)
>>    unsigned long sp =3D (unsigned long)&regs->sp;
>>    u32 *prev_esp;
>>=20
>> +    if (regs->__csh & (1 << 13)) /* test CS_FROM_INT3 */
>> +        return regs->sp;
>> +
>=20
> Thanks, I was looking into doing something like this (setting a flag in
> the int3 code), but didn't have the time to see the best way to do this.
>=20
> I'll add this version of the code and run it through my tests.
>=20
> -- Steve
>=20
>>    if (context =3D=3D (sp & ~(THREAD_SIZE - 1)))
>>        return sp;
>>=20
>> --- a/arch/x86/entry/entry_32.S
>> +++ b/arch/x86/entry/entry_32.S
>> @@ -388,6 +388,7 @@
>>=20
>> #define CS_FROM_ENTRY_STACK    (1 << 31)
>> #define CS_FROM_USER_CR3    (1 << 30)
>> +#define CS_FROM_INT3        (1 << 29)
>>=20
>> .macro SWITCH_TO_KERNEL_STACK
>>=20
>> @@ -1515,6 +1516,9 @@ ENTRY(int3)
>>=20
>>    add    $16, 12(%esp) # point sp back at the previous context
>>=20
>> +    andl    $0x0000ffff, 4(%esp)
>> +    orl    $CS_FROM_INT3, 4(%esp)
>> +
>>    pushl    $-1                # orig_eax; mark as interrupt
>>=20
>>    SAVE_ALL
>=20

So here=E2=80=99s a somewhat nutty suggestion: how about we tweak the 32-bit=
 entry code to emulate the sane 64-bit frame, not just for int3 but always? =
 Basically, the entry asm for entries from kernel mode would do, roughly:

push $0 ;dummy for call emulation
push %ss
push $0 ;a dummy for ESP
push 3*4(%esp) ;EFLAGS
push 3*4(%esp) ;CS
push 3*4(%esp) ;EIP
push %rax
lea 7*4(%esp), %rax
mov %rax, 4*4(%esp) ;ESP

And the exit asm would do a little dance to write EFLAGS, CS, and EIP to the=
 right spot, then load ESP-3*4 into %esp and do IRET.

Now the annoying kernel_stack_pointer() hack can just go away, since regs->s=
p is always correct!

I probably screwed up some arithmetic there, but it=E2=80=99s the idea that c=
ounts :)



