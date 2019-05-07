Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65CBC16BD1
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 21:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbfEGT6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 15:58:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726658AbfEGT6W (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 15:58:22 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96C41208C4;
        Tue,  7 May 2019 19:58:18 +0000 (UTC)
Date:   Tue, 7 May 2019 15:58:17 -0400
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
Subject: Re: [RFC][PATCH 2/3] x86_64: Allow breakpoints to emulate call
 functions
Message-ID: <20190507155817.2d08d0eb@gandalf.local.home>
In-Reply-To: <20190507194925.qndvv67rinrmbefj@treble>
References: <20190507174227.673261270@goodmis.org>
        <20190507174400.219947724@goodmis.org>
        <20190507175342.fskdj2qidpao65qi@treble>
        <20190507150153.7a5d376d@gandalf.local.home>
        <20190507191412.n4uhoyfwagagyfwi@treble>
        <20190507152016.77f7a3af@gandalf.local.home>
        <20190507194925.qndvv67rinrmbefj@treble>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 7 May 2019 14:49:25 -0500
Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> > New version:
> > 
> >     x86_64: Allow breakpoints to emulate call functions
> >     
> >     In order to allow breakpoints to emulate call functions, they need to push  
> 
> Sorry to keep nitpicking, but "call functions" -> "function calls" would
> sound more accurate to me (in both subject and description).

I disagree ;-)

Matters how you look at it. I look at it as emulating the "call"
function, not a function call. Like emulating an "addl" function, or a
"jmp" function.

See?

To remove the ambiguity, I could replace "function" with "instruction".

> 
> Otherwise it looks good.

Thanks!

-- Steve
