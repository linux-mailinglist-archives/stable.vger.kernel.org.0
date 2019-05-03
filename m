Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34820133D3
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 21:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfECTCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 15:02:50 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35108 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbfECTCu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 15:02:50 -0400
Received: by mail-lf1-f66.google.com with SMTP id j20so5152817lfh.2
        for <stable@vger.kernel.org>; Fri, 03 May 2019 12:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FSgswcQFEYeHSdxX8AtrFGdX43ZrY81aC7FjCdnF1lw=;
        b=hNiCDOYPcNqnXKK/3FcnwPtAVxPFyrBg+J8d2W/RIoQtc6yDsjbQlTRVrCZF7yVBbf
         GTfzaeel2+A/oHQFAzZEgiHULvVGHr0RUbX7HmdD+IU7HwQy2urlZR/fO3433IvfJrgP
         +aivOpr26ud9zTNlsEaBbSi32zQ6a4Z2OLgV4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FSgswcQFEYeHSdxX8AtrFGdX43ZrY81aC7FjCdnF1lw=;
        b=VjSA4pEad5y6v3MAQZ9e8PefSKz9fl50nZGDiHLWCdLAP54ZCs+fXyJgsyj3o3V87J
         EU+BdbCYUIMQPXL3r4E0H9Xc/5J0DVO4eBAThcFynqIn9vr9ymeZ4Sz+Ttm2rXi4225B
         FPoFuI3hbcylJCeco+2Y1fP/6r/p7NPU9Vs9Sm+4R2q6iu7bxU16zawMbQRLIY7k0uwk
         q/hVVFS/5OK0/0fTYXBhhH5RTagqkLx1bASRTmd8gQ2AQ6Lrz1pAmKGS99XoYsg1Vzrh
         OkTa9uqyLVLCYAIKOz/fkiDQAa8OuBqbPr4fvbhRTO3o1xp3cj3vXEeHeNEvQ1yEAmcH
         Iltg==
X-Gm-Message-State: APjAAAV4RM9wRnKR6qVfWD2ojH5t4d4RyVcthmMCN6PTNrxvwRNOFjMG
        x8Q9iQt+8HpHrYSf1ZOfQ+MAXueHk9s=
X-Google-Smtp-Source: APXvYqySGcWBsPrINe554dcX9XWmlzWMTsfbjQrqtSJbEPAKS0NCO3mRmnvCkYtSRrRyQPBiAyMuZg==
X-Received: by 2002:a19:fc1a:: with SMTP id a26mr585393lfi.82.1556910168212;
        Fri, 03 May 2019 12:02:48 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id k4sm603365lja.18.2019.05.03.12.02.47
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 12:02:47 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id d12so5125406lfk.6
        for <stable@vger.kernel.org>; Fri, 03 May 2019 12:02:47 -0700 (PDT)
X-Received: by 2002:a19:ca02:: with SMTP id a2mr5916283lfg.88.1556909858698;
 Fri, 03 May 2019 11:57:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190501203152.397154664@goodmis.org> <20190501232412.1196ef18@oasis.local.home>
 <20190502162133.GX2623@hirez.programming.kicks-ass.net> <CAHk-=wijZ-MD4g3zMJ9W2r=h8LUWneiu29OWuxZEoSfAF=0bhQ@mail.gmail.com>
 <20190502181811.GY2623@hirez.programming.kicks-ass.net> <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
 <20190502202146.GZ2623@hirez.programming.kicks-ass.net> <20190502185225.0cdfc8bc@gandalf.local.home>
 <20190502193129.664c5b2e@gandalf.local.home> <20190502195052.0af473cf@gandalf.local.home>
 <20190503092959.GB2623@hirez.programming.kicks-ass.net> <20190503092247.20cc1ff0@gandalf.local.home>
 <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net>
In-Reply-To: <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 3 May 2019 11:57:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjrOLqBG1qe9C3T=fLN0m=78FgNOGOEL22gU=+Pw6Mu9Q@mail.gmail.com>
Message-ID: <CAHk-=wjrOLqBG1qe9C3T=fLN0m=78FgNOGOEL22gU=+Pw6Mu9Q@mail.gmail.com>
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
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 3, 2019 at 9:21 AM Andy Lutomirski <luto@amacapital.net> wrote:
>
> So here=E2=80=99s a somewhat nutty suggestion: how about we tweak the 32-=
bit entry code to emulate the sane 64-bit frame, not just for int3 but alwa=
ys?

What would the code actually end up looking like? I don't necessarily
object, since that kernel_stack_pointer() thing certainly looks
horrible, but honestly, my suggestion to just pass in the 'struct
pt_regs' and let the call emulation fix it up would have also worked,
and avoided that bug (and who knows what else might be hiding).

I really think that you're now hitting all the special case magic
low-level crap that I wanted to avoid.

                   Linus
