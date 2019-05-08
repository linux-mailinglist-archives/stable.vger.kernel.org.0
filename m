Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02E6317548
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 11:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfEHJla convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 8 May 2019 05:41:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:51370 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726544AbfEHJlY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 05:41:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D0738ADC7;
        Wed,  8 May 2019 09:41:21 +0000 (UTC)
From:   Nicolai Stange <nstange@suse.de>
To:     Steven Rostedt <rostedt@goodmis.org>
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
        "the arch\/x86 maintainers" <x86@kernel.org>,
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
        "open list\:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH 0/3] x86_64/ftrace: Emulate calls from int3 when patching functions
References: <20190508015559.767152678@goodmis.org>
Date:   Wed, 08 May 2019 11:41:19 +0200
In-Reply-To: <20190508015559.767152678@goodmis.org> (Steven Rostedt's message
        of "Tue, 07 May 2019 21:55:59 -0400")
Message-ID: <87lfzhwaf4.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> [
>   This is the non-RFC version.
>
>   It went through and passed all my tests. If there's no objections
>   I'm going to include this in my pull request. I still have patches
>   in my INBOX that may still be included, so I need to run those through
>   my tests as well, so a pull request wont be immediate.
> ]

<snip />

> Josh Poimboeuf (1):
>       x86_64: Add gap to int3 to allow for call emulation
>
> Peter Zijlstra (2):
>       x86_64: Allow breakpoints to emulate call instructions
>       ftrace/x86_64: Emulate call function while updating in breakpoint handler

Reviewed-and-tested-by: Nicolai Stange <nstange@suse.de>

for the whole series. Many, many thanks to everybody involved!

I'll resend that live patching selftest once this fix here has been
merged.

Nicolai

-- 
SUSE Linux GmbH, GF: Felix Imendörffer, Mary Higgins, Sri Rasiah, HRB
21284 (AG Nürnberg)
