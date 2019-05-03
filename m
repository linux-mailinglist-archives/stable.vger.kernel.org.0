Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B97F135E1
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 00:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfECWzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 18:55:17 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39152 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbfECWzQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 18:55:16 -0400
Received: by mail-pl1-f195.google.com with SMTP id e92so3369581plb.6
        for <stable@vger.kernel.org>; Fri, 03 May 2019 15:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Jh8aRs6M204wQzik6wivrIiSI13IXCdNHX7pPqq9CBI=;
        b=OCtteQBYyMIkBq9cEO5w0dUfflKGQ9tjo/sN0ogG8gF6bMVn3+Ow1X7rjho8n1A3fq
         a4RWG8yh5WKNJhTiolQN9daJ2OM4WkQ3MTpo9IZ3+1ngvaZRtSui3RbXHdxJRHJkDoRg
         XB9cuBpEiuqbTfot6T0Z8qoLrCn8MtzLorIz7xiF8HMwfzZklsv9dI+LvEXJoA4tfUvq
         P2WdHZhY00dni3VupTFKa4VN8vMPM4m3G7z9hQ7viHoCN051/T1tsNszD7akvGflqq80
         YFGMze56lazv1nqPymHG3ho/LCC0KZ9Yt1JRVkExWD9JY7k/u4Kew+ntpabxyfHfd259
         cspg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Jh8aRs6M204wQzik6wivrIiSI13IXCdNHX7pPqq9CBI=;
        b=t6GPCLyZPn17k4YrbTFYog0VtA+hutIKctmteLgihqVMbx/cGlWvgx7CfXOAZPwVF4
         WwnJ690CyMVnZWmoVtxNpeSmWPoT6ZWpJlfFUX7TFk0enh92UfynzNV9LI+rywGlXRUA
         VjT5wHy92dXx1Bis5X+f2cjSrZd8dfYY9JhI8SAEkmt4AEKhGd+A3qWMnPjorpTFD5r3
         SsKjaBEeRLW8j/YqVBdIUug3AApxbBkG53RhyGetVmkembnzVQGihVAZkuMrH2LMtcrA
         FKhL2y3cXadXEuqBlBHOGIdBzHnVE3vmL2Wo9N+T3FE7CdKKyyr5HW2z9T/0/h4ngbao
         GHyg==
X-Gm-Message-State: APjAAAWgnO88DZQYe1g6zLRtMFsiBUE3+garCehf+Cb9y1P9mAkJtC6o
        uEAp/9fjCnngUhFu7uNa9xBgtw==
X-Google-Smtp-Source: APXvYqxOMrve5vMLWGbWTyUTBFUkDVaaOUrfEcD9ZTOc7JwEAkevEiH30M1gMq/yEyB1KC6PAi2S2g==
X-Received: by 2002:a17:902:9a48:: with SMTP id x8mr14226141plv.133.1556924115416;
        Fri, 03 May 2019 15:55:15 -0700 (PDT)
Received: from ?IPv6:2600:1010:b02a:6215:98ef:57cc:ac0d:e82b? ([2600:1010:b02a:6215:98ef:57cc:ac0d:e82b])
        by smtp.gmail.com with ESMTPSA id d3sm4094108pfn.113.2019.05.03.15.55.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 15:55:14 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16E227)
In-Reply-To: <CAHk-=wiA-WbrFrDs-kOfJZMXy4zMo9-SZfk=7B-GfmBJ866naw@mail.gmail.com>
Date:   Fri, 3 May 2019 15:55:12 -0700
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
Message-Id: <2962A4E4-3B9F-4195-9C6D-9932809D98F9@amacapital.net>
References: <20190501202830.347656894@goodmis.org> <20190501203152.397154664@goodmis.org> <20190501232412.1196ef18@oasis.local.home> <20190502162133.GX2623@hirez.programming.kicks-ass.net> <CAHk-=wijZ-MD4g3zMJ9W2r=h8LUWneiu29OWuxZEoSfAF=0bhQ@mail.gmail.com> <20190502181811.GY2623@hirez.programming.kicks-ass.net> <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com> <20190502202146.GZ2623@hirez.programming.kicks-ass.net> <CAHk-=wh8bi5c_GkyjPtDAiaXaZRqtmhWs30usUvs4qK_F+c9tg@mail.gmail.com> <20190503152405.2d741af8@gandalf.local.home> <CAHk-=wiA-WbrFrDs-kOfJZMXy4zMo9-SZfk=7B-GfmBJ866naw@mail.gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On May 3, 2019, at 2:46 PM, Linus Torvalds <torvalds@linux-foundation.org>=
 wrote:
>=20
>> On Fri, May 3, 2019 at 12:24 PM Steven Rostedt <rostedt@goodmis.org> wrot=
e:
>>=20
>> The problem with this approach is that it would require doing the same
>> for x86_64, as the int3 C code is the same for both. And that may be a
>> bit more difficult on the x86_64 side because it's all done with a
>> simple flag in the idtentry macro to add the gap.
>=20
> That argument is weakened by the fact that we have to do _other_
> things differently on 32-bit and 64-bit anyway.
>=20
> So we might as well have a "on 32-bit, the call emulation needs to
> move the pt_regs to make space" special case in the call emulation
> code. It's very easy to explain why.
>=20
> And then we'd limit the special case to where it matters (with a big
> comment about what's going on), rather than adding random special case
> handling to random _other_ places.

If we do this, it should IMO look like this:

struct pt_regs *change_kernel_stack_pointer(struct pt_regs *, unsigned long n=
ew_sp);

And that helper should be used on both variants.

But I think this will end up worse than the version where the entry code fix=
es it up.  This is because, if the C code moves pt_regs, then we need some w=
ay to pass the new pointer back to the asm.  We will also have a much harder=
 time with runtime sanity checks.  In the model where the C code merely upda=
tes regs->sp, it=E2=80=99s very easy to compare sp and &regs to check for ov=
erlap, but it=E2=80=99s much harder to tell whether memmoveing it is going t=
o overwrite something important.  And we have to worry about whether there=E2=
=80=99s some other code that assumes that pt_regs stays put.

So my intuition is that the pure asm fixup will result is more maintainable c=
ode.
