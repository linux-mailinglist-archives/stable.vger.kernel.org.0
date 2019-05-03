Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9A8E13279
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 18:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbfECQtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 12:49:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728056AbfECQtL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 May 2019 12:49:11 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C20B2075C;
        Fri,  3 May 2019 16:49:07 +0000 (UTC)
Date:   Fri, 3 May 2019 12:49:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call
 functions
Message-ID: <20190503124906.576c21f7@gandalf.local.home>
In-Reply-To: <CALCETrUcEH8kswYGNkoupVVP+3hEsTA4BWTfLk-RY_RfkDsHGw@mail.gmail.com>
References: <20190502181811.GY2623@hirez.programming.kicks-ass.net>
        <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
        <20190502202146.GZ2623@hirez.programming.kicks-ass.net>
        <20190502185225.0cdfc8bc@gandalf.local.home>
        <20190502193129.664c5b2e@gandalf.local.home>
        <20190502195052.0af473cf@gandalf.local.home>
        <20190503092959.GB2623@hirez.programming.kicks-ass.net>
        <20190503092247.20cc1ff0@gandalf.local.home>
        <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net>
        <20190503123126.3a2801be@gandalf.local.home>
        <20190503163527.GI2606@hirez.programming.kicks-ass.net>
        <CALCETrUcEH8kswYGNkoupVVP+3hEsTA4BWTfLk-RY_RfkDsHGw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 3 May 2019 09:44:35 -0700
Andy Lutomirski <luto@kernel.org> wrote:

> On Fri, May 3, 2019 at 9:35 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Fri, May 03, 2019 at 12:31:26PM -0400, Steven Rostedt wrote:  
> > > I guess the real question is, what's the performance impact of doing
> > > that?  
> >
> > Is there anyone that considers i386 a performance platform?  
> 
> Not me.  As far as I'm concerned, I will basically always gladly trade
> several cycles for simplicity on 32-bit.
>

So should I wait for a new PATCH 1 from Peter to implement it this way?
I'd like to get this into the next merge window (although, I am marking
it for stable since it fixes a bug for live kernel patching).

Linus, what's your thoughts?

-- Steve
