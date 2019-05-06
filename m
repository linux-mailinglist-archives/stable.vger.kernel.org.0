Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CADB15137
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 18:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfEFQ2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 12:28:04 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37800 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfEFQ2E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 May 2019 12:28:04 -0400
Received: by mail-lj1-f194.google.com with SMTP id 132so3907342ljj.4
        for <stable@vger.kernel.org>; Mon, 06 May 2019 09:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YVhVdCTcPM0PTipUC5cKupbZldiZWmaMJ+OXUnCYkpU=;
        b=Uf62pHFtgllYqALvEUKMKV6I76IKCFItvVqLvjkQ3d2lCpV1XjpBx0yJQ+iFGh0+Ij
         IF7dcBQsUWv2vieVJNPLLPfGaN2XG0Ytn2qDMwNEB3RNtdjQ3+fNKlJGrdwbxOWlqMDS
         z9PbLEvLjajjgofELNpGz9INcqnXVrYbR8qgQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YVhVdCTcPM0PTipUC5cKupbZldiZWmaMJ+OXUnCYkpU=;
        b=Zfyzy3EtRvJaG09gbomwTwQNzZRm3wWq+Dvu4rdNol95hq/tADsYKNP+aqGtgGWvsH
         y5zoOwpb0ZGGlUNWejyDk05Xq+dGdUb8aDBi4NMkEAHCX2QnZ3mj4poUwJtlef9UlCC4
         Gpn4urUZWpYq4pRb2FgXzIxaY+wU6SVjVbq8wcIsTxT4/Fv1edaap/ANbwn+6e9mhNMu
         wvbYDIXHswXMqphvALG0Al2lo+61qSauAy6DursHdsMEp0YVoIcUXnyQPGFce0SPR4J6
         mAi+DFvNv/UyEHnq2pYwKTRW/BAkWx9eGJEMxLBhiMGGpcZmd/pcg0Sk3523L8I3Plr5
         2GLQ==
X-Gm-Message-State: APjAAAX2YNQD88RgAE242pcG/O04m6m97gXtN9eEmX6+OgluGT8vw+Ht
        wPB9//SZC+2fTP1a2DlLkUI+J0LdUfU=
X-Google-Smtp-Source: APXvYqz1XCzHjG1NO51nrBrV75Rxw91ltrmXFWd5ba4vm2Ti6FYhVEE+8WZTbCUEJRFS8DY4ZT38TA==
X-Received: by 2002:a2e:9f07:: with SMTP id u7mr5249199ljk.115.1557160082275;
        Mon, 06 May 2019 09:28:02 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id v1sm357779lfa.93.2019.05.06.09.28.01
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 09:28:02 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id u21so2514071lja.5
        for <stable@vger.kernel.org>; Mon, 06 May 2019 09:28:01 -0700 (PDT)
X-Received: by 2002:a05:651c:8f:: with SMTP id 15mr13394592ljq.118.1557159592300;
 Mon, 06 May 2019 09:19:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190502181811.GY2623@hirez.programming.kicks-ass.net>
 <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
 <20190502202146.GZ2623@hirez.programming.kicks-ass.net> <20190502185225.0cdfc8bc@gandalf.local.home>
 <20190502193129.664c5b2e@gandalf.local.home> <20190502195052.0af473cf@gandalf.local.home>
 <20190503092959.GB2623@hirez.programming.kicks-ass.net> <20190503092247.20cc1ff0@gandalf.local.home>
 <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net> <CAHk-=wjrOLqBG1qe9C3T=fLN0m=78FgNOGOEL22gU=+Pw6Mu9Q@mail.gmail.com>
 <20190506081951.GJ2606@hirez.programming.kicks-ass.net> <20190506095631.6f71ad7c@gandalf.local.home>
 <CAHk-=wgw_Jmn1iJWanoSFb1QZn3mbTD_JEoMsWcWj5QPeyHZHA@mail.gmail.com>
In-Reply-To: <CAHk-=wgw_Jmn1iJWanoSFb1QZn3mbTD_JEoMsWcWj5QPeyHZHA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 6 May 2019 09:19:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjs8hhEdLUb=rD1tZC-JzBHALpi0hQSNf=esw96Gnta6A@mail.gmail.com>
Message-ID: <CAHk-=wjs8hhEdLUb=rD1tZC-JzBHALpi0hQSNf=esw96Gnta6A@mail.gmail.com>
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

On Mon, May 6, 2019 at 9:17 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So what is it that doesn't actually work? I've looked at the patch
> even more, and I can't for the life of me see how it wouldn't work.

And I do still react to PeterZ's

 arch/x86/entry/entry_32.S            | 150 +++++++++++++++++++++++++++++------

vs

 arch/x86/entry/entry_32.S            |  7 ++++++-

for mine. And PeterZ's  apparently still had bugs.

Yes, mine can have bugs too, but I really *have* done some basic
testing, and with 6 lines of code, I think they are more localized.

                Linus
