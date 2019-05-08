Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F33E71703B
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 06:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbfEHE5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 00:57:46 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44058 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbfEHE5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 May 2019 00:57:45 -0400
Received: by mail-lf1-f65.google.com with SMTP id n134so11678476lfn.11
        for <stable@vger.kernel.org>; Tue, 07 May 2019 21:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I5e/UfOxO1ET3GG/v6CYadKGMC4a8arhmGhydGAJn8s=;
        b=fCVBMlCqXFaNG3/T7joMRaQg4ceXtuYdPorGYMf1oXOX02JSfkDNtMBZ392mp3Xa+w
         XzLxNjp4lFJG4QNeeBTaE98AcmNY9mHk/ZS6OieHVwaCDyObPW9cGux/hc2VnbzcJFR6
         4ExSRI8O2Vzt05xYgeQ6pkrUST7OnP3nm4W/A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I5e/UfOxO1ET3GG/v6CYadKGMC4a8arhmGhydGAJn8s=;
        b=X27gM3fbEntPk/+Au4yIzf8bFYUbKtv96z6i1nazKS7SX7YXYoZGsxfXPweCzDNc3U
         RIg8i6V0V5UhRq2oxI4mbRpwyhm6PuR5xF4VtJXRUK/r0Y/mrAtvG8l2iTfxwbacQpmc
         nr/6XvcRgKO88FaVV/ti/AoY5hHh3qwAofiZj5z+XIGq8epXlMpcdAnzC0H6uWgZmjn1
         kZb2ZYxTQVHZtCq0O0oaHqauWlkeWxCRxwkvxdzaQn5nRTMRnwh1UWGRabaj4SI2QtuT
         x1aIUoqwd3rQZyQ4C4VIq8GXWXOeGyT3gCI290isuPPAMpvvkVeaTbHoGlUeDeFHeGM2
         OIVA==
X-Gm-Message-State: APjAAAW1POCxlccB+dpq0jjJiSe7ZIV/OpCrqdiw4C4GWSk3eh7FNyb3
        M7WYQ8B1HVnxdWKGyeuq/LBG1DOepmI=
X-Google-Smtp-Source: APXvYqx4Ui+RzGD04BU43NqipqPPUBj1ZZAs6KgITygNONkXgBR0PGHqX+anc6BM0BlzyFwIQz4JpA==
X-Received: by 2002:ac2:4301:: with SMTP id l1mr19814043lfh.54.1557291463660;
        Tue, 07 May 2019 21:57:43 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id x23sm1107603lfc.25.2019.05.07.21.57.43
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 21:57:43 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id m20so7059218lji.2
        for <stable@vger.kernel.org>; Tue, 07 May 2019 21:57:43 -0700 (PDT)
X-Received: by 2002:a2e:9d86:: with SMTP id c6mr17393609ljj.135.1557291068666;
 Tue, 07 May 2019 21:51:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wjLXmOn=Cp=uOfO4gE01eN_-UcOUyrMTTw5-f_OfPO48Q@mail.gmail.com>
 <20190506225819.11756974@oasis.local.home> <CAHk-=wh4FCNBLe8OyDZt2Tr+k9JhhTsg3H8R4b55peKcf0b6eQ@mail.gmail.com>
 <20190506232158.13c9123b@oasis.local.home> <CAHk-=wi4vPg4pu6RvxQrUuBL4Vgwd2G2iaEJVVumny+cBOWMZw@mail.gmail.com>
 <CAHk-=wg2_okyU8mpkGCUrudgfg8YmNetSD8=scNbOkN+imqZdQ@mail.gmail.com>
 <20190507111227.1d4268d7@gandalf.local.home> <CAHk-=wjYdj+vvV8uUA8eaUSxOhu=xuQxdo-dtM927j0-3hSkEw@mail.gmail.com>
 <20190507163440.GV2606@hirez.programming.kicks-ass.net> <CAHk-=wiuue37opWK5QaQ9f6twqDZuSratdP-1bK6kD9-Az5WnA@mail.gmail.com>
 <20190507172159.5t3bm3mjkwagvite@treble> <20190507172418.67ef6fc3@gandalf.local.home>
In-Reply-To: <20190507172418.67ef6fc3@gandalf.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 7 May 2019 21:50:52 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg5_fwx_-ybD9TLQE4rAUqtYzO2CAmpciWTkDn3dtKMOw@mail.gmail.com>
Message-ID: <CAHk-=wg5_fwx_-ybD9TLQE4rAUqtYzO2CAmpciWTkDn3dtKMOw@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
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

On Tue, May 7, 2019 at 2:24 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> And there's been several times I forget that regs->sp can not be read
> directly. Especially most of my bug reports are for x86_64 these days.
> But when I had that seldom x86_32 one, and go debugging, I would print
> out "regs->sp" and then the system would crash. And I spend some time
> wondering why?
>
> It's been a bane of mine for some time.

Guys, I have basically a one-liner patch for your hangups.

It's called "rename 'sp' to 'user_sp' on x86-32".

Then we make the 'sp' field on x86-64 be a union, so that you can call
it user_sp or sp as you wish.

Yeah, it's really more than one line, because obviously the users will
need chaning, but honestly, that would be a _real_ cleanup. Make the
register match what it actually is.

And it doesn't mess up the stack frame, and it doesn't change the
entry code. It just reminds people that the entry is the USER stack
pointer.

Problem solved.

               Linus
