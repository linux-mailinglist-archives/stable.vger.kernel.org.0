Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 246FA12350
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 22:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfEBU0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 16:26:00 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45607 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbfEBUZ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 16:25:59 -0400
Received: by mail-pg1-f194.google.com with SMTP id i21so1555639pgi.12
        for <stable@vger.kernel.org>; Thu, 02 May 2019 13:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Io3DgdKgd9vrTCiqn1ty9ma6MeZxtY5mWHTy1rGcWSk=;
        b=JRGEOa2M9VSTVxV8OWvGI2jo8mrtudnNCX9J67xa+uuu9xIcscAMsy5EVezgdK890M
         nIOgUqCwrV6zdyLl4F2fSz9D+CW4kiaSbBRDoKbiLntIdStjJcd5DOlESpoSUoT/5MPe
         nkgyGakMQHMJ/aE61Ly6IrWMINs0h7hCM/paI2GuwAm0QlSNzFZp4f2QcoTOWt6FHlFV
         7APR1qqnbDHZ1MUyvjs0b7fMma+WF0VCNPwXglhjSf20z8ZyumgqnfJ/GYpWGMXCJvk+
         gAHeHAAPEI+8fZHQkKIt8fYVS1YgV+pYBIvg7H29r8/cvQOPT7yOrlVvjZUfsWgQTiSH
         B76Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Io3DgdKgd9vrTCiqn1ty9ma6MeZxtY5mWHTy1rGcWSk=;
        b=lpmNIvJwSKt2AOTGhVw+N4c/MS9qUzH0P8gIooy2bmjkJNk92slPLaLWQJyccwzknP
         ZU9UDHzXIZXe9t//OXAmXq3PHm8xn0t8uiicIZZs0Bz6YLgCpp8GQbsVOgXj+Ekjk4o7
         X2KCYOOIdDpdRgSrQe94P2XDyCtV2R7p/vyHzRjhPyK3d2XTfEa0yXDXdqfnp1ZB2ZCC
         uY/wYoUHP6DJvuCAjUz8Q/bqwi6FZEFcGstmUGew/uhhDaqnebpNvBynFGOQfAh/goYd
         suCctJx2FrqOq5uPr+tAqTgeG4Hr9aIDZhFc1zHlu7ZL8L7rn222ZF8seei9R+n2uqXp
         MOwQ==
X-Gm-Message-State: APjAAAWEF9bKHJSclozSMP/Y0kPoTx5TxJEbE+Fs9gbI8Iqvt3InM/uy
        GcNkRVA4jMafUlcEWLMMWCUoRslcjiE=
X-Google-Smtp-Source: APXvYqxTa+wO6NCzor7FpiJk3O2Yual5TrsL5e7AjO0IODWu6S5r6CX+1Mn1g9ZBaMeUizlwwZ+icw==
X-Received: by 2002:a63:4714:: with SMTP id u20mr6090953pga.316.1556828758292;
        Thu, 02 May 2019 13:25:58 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:4138:7cfc:eb31:bf4a? ([2601:646:c200:1ef2:4138:7cfc:eb31:bf4a])
        by smtp.gmail.com with ESMTPSA id j67sm38422pfc.72.2019.05.02.13.25.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 13:25:57 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16E227)
In-Reply-To: <nycvar.YFH.7.76.1905022101060.10635@cbobk.fhfr.pm>
Date:   Thu, 2 May 2019 13:25:56 -0700
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
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
Message-Id: <D87B1B37-C06B-4C81-BF82-994B03DE2BFF@amacapital.net>
References: <20190501202830.347656894@goodmis.org> <20190501203152.397154664@goodmis.org> <20190501232412.1196ef18@oasis.local.home> <20190502162133.GX2623@hirez.programming.kicks-ass.net> <CAHk-=wijZ-MD4g3zMJ9W2r=h8LUWneiu29OWuxZEoSfAF=0bhQ@mail.gmail.com> <20190502181811.GY2623@hirez.programming.kicks-ass.net> <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com> <nycvar.YFH.7.76.1905022101060.10635@cbobk.fhfr.pm>
To:     Jiri Kosina <jikos@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On May 2, 2019, at 12:28 PM, Jiri Kosina <jikos@kernel.org> wrote:
>=20
>> On Thu, 2 May 2019, Linus Torvalds wrote:
>>=20
>> I forget: is #BP _only_ for the "int3" instruction?=20
>=20
> Hmm, according to 17.3.2 in vol 3 of SDM (and table 6-1 there), that=20
> indeed seems to be the case, so we should be fine.

I=E2=80=99m reasonably confident that the absurd MOV SS; INT3 sequence resul=
ts in #BP from user mode and then #DB inside that (as opposed to vice versa)=
, so this should be okay.

