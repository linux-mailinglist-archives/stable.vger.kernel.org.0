Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D51F016600
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 16:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfEGOsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 10:48:50 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39776 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfEGOst (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 10:48:49 -0400
Received: by mail-pg1-f193.google.com with SMTP id w22so7120188pgi.6
        for <stable@vger.kernel.org>; Tue, 07 May 2019 07:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=WzezD33BMd1lMmbzTwPzPdqm4AKLM8U8TugyOVRuE80=;
        b=wmv/7GCZi5CeIq7FJsrMGAWH5gOvg8rDEOeHyrJ4YFduj3v5gFwLwT+o9ian/HZCG9
         FA6qRrQ1LZwAxz/xX9VRlJ1TSjE19h7dJis+ndpNxYlo5Cdc0aoWNsp6c9l8ryzmY0N8
         zDR3wXMjdCZSwYjV87Z+bFgYJbJNG/CadhqSR8Vjqm4hIHTpprDhAOIdPcdDzBJfsR6l
         N2fh7KHJks0GJNvnw928sPavtpOMW6bxb9SKQJtjM+jWv+QcKHUbN/VSBbkWNKaSG8dH
         5Lmy2biU8H1Jc7jBGp09G6ZcdMoOaudatzgGTW8qtpXBK2MauBFkFaDqPUqo6q0IgBpN
         0oaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=WzezD33BMd1lMmbzTwPzPdqm4AKLM8U8TugyOVRuE80=;
        b=CGJBrA+WYVq5C+uZj482KAy9bbugBkS3pmspvzoNmsWtKivI3WZCx6cx5VsC5dgPh2
         58+Y6Li8fOW5yhegVKSyUImJD2yWhG+e7nsWYXkJGYEn0oD8/yLYnOD5OxhyvrZggOK8
         HhzVswpNi937Th/u6mE/KTJpfiTc7NpxXkW8AJx16n6Z6rWXgzJZSLcqVllRKN3XA2xV
         aJPqhY4hdxCBnQXp+uyfKVZ1btnKqKLZjOlKL1/vy/gBQlWNS0az60evrORucnrgan6j
         GIO+yxmYN0a4Nc4yeZmwhG/sFaHdiNSNKXqFhi+uTZAXbj7QmyesulPjHjjYZRUalPHG
         WzmQ==
X-Gm-Message-State: APjAAAXD9EwB3Ra9w7gnu0ditxdTwS1Qz5JNiFF8K6ynOOQufbxyEBbc
        UvR7s9t6YoJpLluDGOJtYjDkxw==
X-Google-Smtp-Source: APXvYqyT5gbOV/5NFXoVfR57SO0fxUbRroCIAZBQeDN1/S9mWSMEvPm3+p6EIlRPBOiywaqRybSG8Q==
X-Received: by 2002:a65:6554:: with SMTP id a20mr40715795pgw.284.1557240528817;
        Tue, 07 May 2019 07:48:48 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:39d2:a63b:3c03:79ae? ([2601:646:c200:1ef2:39d2:a63b:3c03:79ae])
        by smtp.gmail.com with ESMTPSA id 129sm18934352pff.140.2019.05.07.07.48.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 07:48:46 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16E227)
In-Reply-To: <CAHk-=wjLXmOn=Cp=uOfO4gE01eN_-UcOUyrMTTw5-f_OfPO48Q@mail.gmail.com>
Date:   Tue, 7 May 2019 07:48:45 -0700
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
        <linux-kselftest@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <48BDF7B6-252B-4D29-9116-844363010BC0@amacapital.net>
References: <20190502181811.GY2623@hirez.programming.kicks-ass.net>
 <20190503092247.20cc1ff0@gandalf.local.home> <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net>
 <CAHk-=wjrOLqBG1qe9C3T=fLN0m=78FgNOGOEL22gU=+Pw6Mu9Q@mail.gmail.com>
 <20190506081951.GJ2606@hirez.programming.kicks-ass.net> <20190506095631.6f71ad7c@gandalf.local.home>
 <CAHk-=wgw_Jmn1iJWanoSFb1QZn3mbTD_JEoMsWcWj5QPeyHZHA@mail.gmail.com>
 <20190506130643.62c35eeb@gandalf.local.home> <CAHk-=whesas+GDtHZks62wqXWXe4d_g3XJ359GX81qj=Fgs6qQ@mail.gmail.com>
 <20190506145745.17c59596@gandalf.local.home> <CAHk-=witfFBW2O5v6g--FmqnAFsMkKNLosTFfWyaoJ7euQF8kQ@mail.gmail.com>
 <20190506162915.380993f9@gandalf.local.home> <CAHk-=wi5KBWUOvM94aTOPnoJ5L_aQG=vgLQ4SxxZDeQD0pF2tQ@mail.gmail.com>
 <20190506174511.2f8b696b@gandalf.local.home> <CAHk-=wj3R_s0RTJOmTBNaUPhu4fz2shNBUr4M6Ej65UYSNCs-g@mail.gmail.com>
 <20190506210416.2489a659@oasis.local.home> <CAHk-=whZwqzbu-=1r_j_cXfd=ta1q7RFCuneqBZfQQhS_P-BmQ@mail.gmail.com>
 <20190506215353.14a8ef78@oasis.local.home> <CAHk-=wjLXmOn=Cp=uOfO4gE01eN_-UcOUyrMTTw5-f_OfPO48Q@mail.gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



>> On May 6, 2019, at 7:22 PM, Linus Torvalds <torvalds@linux-foundation.org=
> wrote:
>>=20
>> On Mon, May 6, 2019 at 6:53 PM Steven Rostedt <rostedt@goodmis.org> wrote=
:
>>=20
>> Also, I figured just calling ftrace_regs_caller() was simpler then
>> having that int3 handler do the hash look ups to determine what handler
>> it needs to call.
>=20
> So what got me looking at this - and the races (that didn't turn out
> to be races) - and why I really hate it, is because of the whole
> notion of "atomic state".
>=20
> Running an "int3" handler (when the int3 is in the kernel) is in some
> sense "atomic". There is the state in the caller, of course, and
> there's the state that the int3 handler has, but you can *mostly*
> think of the two as independent.
>=20
> In particular, if the int3 handler doesn't ever enable interrupts, and
> if it doesn't need to do any stack switches, the int3 handler part
> looks "obvious". It can be interrupted by NMI, but it can't be
> interrupted (for example) by the cross-cpu IPI.
>=20
> That was at least the mental model I was going for.
>=20
> Similarly, the "caller" side mostly looks obvious too. If we don't
> take an int3, none of this matter, and if we *do* take an int3, if we
> can at least make it "atomic" wrt the rewriter (before or after
> state), it should be easy to think about.
>=20
> One of the things I was thinking of doing, for example, was to simply
> make the call emulation do a "load four bytes from the instruction
> stream, and just use that as the emulation target offset".
>=20
> Why would that matter?
>=20
> We do *not* have very strict guarantees for D$-vs-I$ coherency on x86,
> but we *do* have very strict guarantees for D$-vs-D$ coherency. And so
> we could use the D$ coherency to give us atomicity guarantees for
> loading and storing the instruction offset for instruction emulation,
> in ways we can *not* use the D$-to-I$ guarantees and just executing it
> directly.
>=20
> So while we still need those nasty IPI's to guarantee the D$-vs-I$
> coherency in the "big picture" model and to get the serialization with
> the actual 'int3' exception right, we *could* just do all the other
> parts of the instruction emulation using the D$ coherency.
>=20
> So we could do the actual "call offset" write with a single atomic
> 4-byte locked cycle (just use "xchg" to write - it's always locked).
> And similarly we could do the call offset *read* with a single locked
> cycle (cmpxchg with a 0 value, for example). It would be atomic even
> if it crosses a cacheline boundary.

I don=E2=80=99t quite get how this could work.  Suppose we start with a five=
-byte NOP (0F 1F ...).  Then we change the first byte to INT3 (CC).  Now we c=
an atomically change the other four bytes, but the INT3 could happen first. I=
 suppose that we could treat 1F 00 00 00 or similar as a known-bogus call ta=
rget, but that seems dangerous.

IOW I think your trick only works if the old and new states are CALL, but we=
 don=E2=80=99t know that until we=E2=80=99ve looked up the record, at which p=
oint we can just use the result of the lookup.

An I missing something clever?  IMO it=E2=80=99s a bummer that there isn=E2=80=
=99t a way to turn NOP into CALL by changing only one byte.
