Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1CB16908
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 19:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfEGRWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 13:22:41 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37477 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbfEGRWk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 13:22:40 -0400
Received: by mail-lj1-f196.google.com with SMTP id 132so7315917ljj.4;
        Tue, 07 May 2019 10:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6PNDzrjcpUnF2ox8n27775TY/wH+ql2a/Pdl5jrIFYE=;
        b=USDDugBCti1omKMaJ+lePP2NJJOBT+kdaOAPkCwlDm/xFScLP7RKjwiA4OVbkYYsZ/
         rB+Cets8kTZOPyUTpYJGf13gmuMdIiBUUEomgjZBYMULBx4mW2MUDtSxtls7yQyxm/x8
         IIfFFtxJI7iSASALqypt4rmoNTeF92lJlKkPM/ZriDb/pe6763gpQmp430bcDrFSZ26o
         5OKhmwk6QGhLN14rcQWGDs5vmrc/gzH3GEIrOW2WyF2KVb8j6l1R5LFP3ACxgI/lZ482
         QkE2DO+hGaLN7KG1YZfEFY+DjuuHBGirKhCKJ3ZMHY4qhEH+I/zIASL3Uoep0lLI+vUX
         6esA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6PNDzrjcpUnF2ox8n27775TY/wH+ql2a/Pdl5jrIFYE=;
        b=KKViP/R+zaePeWKhUo/nLYpB28w3yBR9AhhZgVKJ2D1nE4c5AffFO0tkm0RGhf7CFZ
         v9EtPNE0YUi3Anukh9eiGpFxYd2vKiFiyJiE8xoiAlJoTRtLES3zrFkyCxiirOP/IB2Q
         WeLMQ8sGp/ZSGJt2+ONhYqi3it7QdKzlfDsWWHj2Ajpc7RLmaFNMmZ9/TlESyT4Ydb9i
         0UVaWjnc+vSLtXrW+KPscG85MLkmw7vjDg/n8Tu5BIHQ7TP2304Coxx9gZV07+gdUoC2
         WH1k8z2RvzB5uTad2bEKQ1B6HgIowXOqDfinnpPmvToFsy4QbvU3wIpl2IAltXI1i31r
         jr3Q==
X-Gm-Message-State: APjAAAXLxZQR0/EAoff1LSvoa3zLZuma7trPNJSetP4knFs92+nDZ/bz
        7/Naa5d/cxXijwRsNxkC1pBlo3i6KLioetsJGto=
X-Google-Smtp-Source: APXvYqwSZNtebCFzz431MrdMsGtiBpuF+nfLHauiIB2m9pngsg+jgTHyuxkhtVAXHTIHSYaJBzcdpPG+xOfr+/dpSJY=
X-Received: by 2002:a2e:5301:: with SMTP id h1mr17664822ljb.196.1557249758675;
 Tue, 07 May 2019 10:22:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190502193129.664c5b2e@gandalf.local.home> <20190502195052.0af473cf@gandalf.local.home>
 <20190503092959.GB2623@hirez.programming.kicks-ass.net> <20190503092247.20cc1ff0@gandalf.local.home>
 <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net> <CAHk-=wjrOLqBG1qe9C3T=fLN0m=78FgNOGOEL22gU=+Pw6Mu9Q@mail.gmail.com>
 <20190506081951.GJ2606@hirez.programming.kicks-ass.net> <20190507085753.GO2606@hirez.programming.kicks-ass.net>
 <20190507092731.GH2650@hirez.programming.kicks-ass.net> <20190507082716.73cd5a01@gandalf.local.home>
 <20190507124131.GO2623@hirez.programming.kicks-ass.net> <20190507085417.381d96d0@gandalf.local.home>
In-Reply-To: <20190507085417.381d96d0@gandalf.local.home>
From:   Masami Hiramatsu <masami.hiramatsu@gmail.com>
Date:   Wed, 8 May 2019 02:22:26 +0900
Message-ID: <CADyE4xHw_eikPhgsVuOwpi34vF22_i0MhVaQac0bVvKZ6hLqdw@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
        <linux-kselftest@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2019=E5=B9=B45=E6=9C=887=E6=97=A5(=E7=81=AB) 21:54 Steven Rostedt <rostedt@=
goodmis.org>:
>
> On Tue, 7 May 2019 14:41:31 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
>
> > > Kprobes sets the FTRACE_OPS_FL_IPMODIFY flag, thus
> > > they can never be put at the same location that is being live patched=
.
> >
> > OK, so do we want to allow kprobes that also modify regs->sp ? Because
> > then we need to change these trampolines a bit.
> >
> > I'd prefer not to allow kprobes this.
>
> I believe no kprobe changes sp, because it would have had the same
> issues we are trying to solve now. And even though we are changing
> things to allow it, it's not a regression to keep kprobes from doing it.

No, kprobes doesn't allow to change sp. At this moment we can't change
"&regs->sp" since it is just a value :)
kprobes user (e.g. function fault-injection) will change regs->ip,
that is why kprobes sets IPMODIFY flag.

Thank you,

--=20
Masami Hiramatsu
mailto:masami.hiramatsu@gmail.com
