Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB2D16ACC
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 20:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfEGS52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 14:57:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727346AbfEGS52 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 14:57:28 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F14220578;
        Tue,  7 May 2019 18:57:25 +0000 (UTC)
Date:   Tue, 7 May 2019 14:57:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
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
Subject: Re: [RFC][PATCH 1/3] x86_64: Add gap to int3 to allow for call
 emulation
Message-ID: <20190507145724.132dc8ec@gandalf.local.home>
In-Reply-To: <20190507175655.u3kcvedpfao4rchj@treble>
References: <20190507174227.673261270@goodmis.org>
        <20190507174400.064350937@goodmis.org>
        <20190507175655.u3kcvedpfao4rchj@treble>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 7 May 2019 12:56:55 -0500
Josh Poimboeuf <jpoimboe@redhat.com> wrote:


> > +	.if \create_gap == 1
> > +	/*
> > +	 * If coming from kernel space, create a 6-word gap to allow the static
> > +	 * call #BP handler to emulate a call instruction.  
> 
> Might as well refer to it as the int3 handler, since that's what the
> rest of the code calls it.  Also, no static calls yet :-)  So:
> 
> s/static call #BP handler/int3 handler/
> 

Done.

-- Steve
