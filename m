Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6933A13C09
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 22:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfEDUMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 16:12:12 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33885 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbfEDUMM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 May 2019 16:12:12 -0400
Received: by mail-pl1-f194.google.com with SMTP id ck18so4367147plb.1
        for <stable@vger.kernel.org>; Sat, 04 May 2019 13:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=NCMi/IJcY48aFW4si21DdOI0x27Xmxnd2GdXSGtj0KE=;
        b=QuR1yzxQKn7DFRWWMR7fSBvuGvXauTjs+QWjPOOSysETTl7I7IUQZRZYJGQZEWrzXC
         aXLuopskBKG1lhvC6mZrbZ19GZQbAXZxbgrHcEY7Ne2rv2yRv1+wyy9Aed2EFweFh6sT
         MgUpM2KgnYL4er2RhJuziduNFgdJtQUuNY+rxGB6YYm4L5wZ1h2YrICNBMRWST/sIk1d
         x9FS2IhTzzNlLOEXa4KJ5A+G6yffez6cK9ONx3kgBDi79QMtaQN7mE+Ead5KYOCSP/ew
         B8BvOEnVYxCJoBIzbJDeiLf8mBt3Ri3eWcg7XWeNKx9f/9jOlgXQYd9q1O//WCtIlh13
         V6Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=NCMi/IJcY48aFW4si21DdOI0x27Xmxnd2GdXSGtj0KE=;
        b=oweuswdAQ6hD+/7p1qpo17AOIFT+wW07uHZwUrucAEcs1CXI6TE/04Gllz00Z0v7VF
         kKcyCXnZBwS9xBxItb7Qt6VLIu51Pw4r6DJrJEuECzx4IhK3+kuVJEYopxeqt7DQN14S
         kqWZygA57Juy2eMUxSYghs6PjDUJZ3VP4KetFAqWoqAUkYIVxLob0ee5nAFltVUwb6in
         LDwIiR3pzW7GhdqNKieddQUNEkCD1JJlqm6Y/hdVxT+6RryDOc+p37o9kpWyVTC/xMuM
         QIASzqHcOhqXR9dUQAeXqTJFU9Wm66331OBVmrGByFPPiSPl7RyMCrh4MBNVKkMDAKqa
         AtLA==
X-Gm-Message-State: APjAAAWeJEdYUDsthYhETOwkm+Z1FyVrHcGvXR3iFKLjJAoD7wMhn6tv
        hJhrxY0Liv1mW+ZOTQo2ew45ZA==
X-Google-Smtp-Source: APXvYqxkMzmtMZymSQaZOjrq9gCEfLF9um4RJzYrrParpn8NStb9c8UxiLkvDWVFYtWVnpgI8AzCFg==
X-Received: by 2002:a17:902:e293:: with SMTP id cf19mr21832986plb.151.1557000731668;
        Sat, 04 May 2019 13:12:11 -0700 (PDT)
Received: from ?IPv6:2600:1010:b01f:7d2b:6939:d09e:b43f:2a80? ([2600:1010:b01f:7d2b:6939:d09e:b43f:2a80])
        by smtp.gmail.com with ESMTPSA id c137sm8834253pfb.154.2019.05.04.13.12.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 13:12:10 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16E227)
In-Reply-To: <CAHk-=wjGNx8xcwg=7nE_0-nLQ_d4UALHvJ8O+TurbA25n8MyNg@mail.gmail.com>
Date:   Sat, 4 May 2019 13:12:09 -0700
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
        <linux-kselftest@vger.kernel.org>, stable <stable@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <2BF1AE4B-8105-49F0-8B6A-AA3B11FD66FD@amacapital.net>
References: <20190501202830.347656894@goodmis.org> <20190501203152.397154664@goodmis.org> <20190501232412.1196ef18@oasis.local.home> <20190502162133.GX2623@hirez.programming.kicks-ass.net> <CAHk-=wijZ-MD4g3zMJ9W2r=h8LUWneiu29OWuxZEoSfAF=0bhQ@mail.gmail.com> <20190502181811.GY2623@hirez.programming.kicks-ass.net> <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com> <20190502202146.GZ2623@hirez.programming.kicks-ass.net> <CAHk-=wh8bi5c_GkyjPtDAiaXaZRqtmhWs30usUvs4qK_F+c9tg@mail.gmail.com> <20190503152405.2d741af8@gandalf.local.home> <CAHk-=wiA-WbrFrDs-kOfJZMXy4zMo9-SZfk=7B-GfmBJ866naw@mail.gmail.com> <20190503184919.2b7ef242@gandalf.local.home> <CAHk-=wh2vPLvsGBi6JtmEYeqHxB5UpTzHDjY5JsWG=YR0Lypzw@mail.gmail.com> <20190504001756.17fad840@oasis.local.home> <CAHk-=wiuSFbv_rELND-BLWcP0GSZ0yF=xOAEcf61GE3bU9d=yg@mail.gmail.com> <CAHk-=wjGNx8xcwg=7nE_0-nLQ_d4UALHvJ8O+TurbA25n8MyNg@mail.gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On May 4, 2019, at 11:59 AM, Linus Torvalds <torvalds@linux-foundation.org=
> wrote:
>=20
> On Fri, May 3, 2019 at 10:08 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>=20
>> I'll look at it tomorrow, but I think this actually makes unnecessary cha=
nges.
>>=20
>> In particular, I think we could keep the existing entry code almost uncha=
nged with this whole approach.
>=20
> So here's what I *think* should work. Note that I also removed your
> test-case code, because it really didn't have a chance in hell of
> working. Doing that
>=20
>        int3_emulate_call(regs, (unsigned long)&int3_magic);
>=20
> inside of int3_exception_notify() could not possibly be valid, since
> int3_emulate_call() returns the new pt_regs that need to be used, and
> throwing it away is clearly wrong.
>=20
> So you can't use a register_die_notifier() to try to intercept the
> 'int3' error and then do it manually, it needs to be done by the
> ftrace_int3_handler() code that actually returns the new regs, and
> where do_kernel_int3() will then return it to the low-level handler.

I hate register_die_notifier(), so I consider this a plus. I=E2=80=99ve occa=
sionally considered removing the ability for the notifiers to skip normal pr=
ocessing, because, as it stands, figuring out what actually happens in the t=
rap handlers is almost impossible.

It generally looks sane to me.

As an aside, is it even *possible* to get #BP from v8086 mode?  On a quick S=
DM read, the INT3 instruction causes #GP if VM=3D1 and IOPL<3.  And, if we a=
llow vm86() to have IOPL=3D3, we should just remove that ability. It=E2=80=99=
s nuts.

(We should maybe consider a config option for iopl() that defaults off. We=E2=
=80=99ve supported ioperm() for a long, long time.)=
