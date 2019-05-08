Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1866E17DAD
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 18:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfEHQGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 12:06:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbfEHQGT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 12:06:19 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8BF720989;
        Wed,  8 May 2019 16:06:15 +0000 (UTC)
Date:   Wed, 8 May 2019 12:06:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
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
Subject: Re: [PATCH 0/3] x86_64/ftrace: Emulate calls from int3 when
 patching functions
Message-ID: <20190508120614.037779be@gandalf.local.home>
In-Reply-To: <20190508133022.78cd9c9b8fcb7838fc0280d0@kernel.org>
References: <20190508015559.767152678@goodmis.org>
        <20190508133022.78cd9c9b8fcb7838fc0280d0@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 8 May 2019 13:30:22 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> > To solve this, an int3_emulate_call() is created for x86_64 to allow
> > ftrace on x86_64 to emulate the call to ftrace_regs_caller() which will
> > make sure all the registered handlers to that function are still called.
> > And this keeps live kernel patching happy!  
> 
> Out of curiosity, would you have any idea to re-use these function for
> other use-case? Maybe kprobes can reuse it, but very limited use-case.

Yes, but only for x86_64.

> 
> > To mimimize the changes, and to avoid controversial patches, this
> > only changes x86_64. Due to the way x86_32 implements the regs->sp
> > the complexity of emulating calls on that platform is too much for
> > stable patches, and live kernel patching does not support x86_32 anyway.  
> 
> This series looks good to me.
> 
> Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>

Thanks Masami!

-- Steve
