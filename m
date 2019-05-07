Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6632E16BD9
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 22:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfEGUCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 16:02:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50269 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbfEGUCx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 16:02:53 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5C98F308793F;
        Tue,  7 May 2019 20:02:52 +0000 (UTC)
Received: from treble (ovpn-123-166.rdu2.redhat.com [10.10.123.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 23D29600D4;
        Tue,  7 May 2019 20:02:46 +0000 (UTC)
Date:   Tue, 7 May 2019 15:02:44 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
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
Message-ID: <20190507200244.mo6po3xxdg3kv2xy@treble>
References: <20190507174227.673261270@goodmis.org>
 <20190507174400.219947724@goodmis.org>
 <20190507175342.fskdj2qidpao65qi@treble>
 <20190507150153.7a5d376d@gandalf.local.home>
 <20190507191412.n4uhoyfwagagyfwi@treble>
 <20190507152016.77f7a3af@gandalf.local.home>
 <20190507194925.qndvv67rinrmbefj@treble>
 <20190507155817.2d08d0eb@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190507155817.2d08d0eb@gandalf.local.home>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 07 May 2019 20:02:52 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 03:58:17PM -0400, Steven Rostedt wrote:
> On Tue, 7 May 2019 14:49:25 -0500
> Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> 
> > > New version:
> > > 
> > >     x86_64: Allow breakpoints to emulate call functions
> > >     
> > >     In order to allow breakpoints to emulate call functions, they need to push  
> > 
> > Sorry to keep nitpicking, but "call functions" -> "function calls" would
> > sound more accurate to me (in both subject and description).
> 
> I disagree ;-)
> 
> Matters how you look at it. I look at it as emulating the "call"
> function, not a function call. Like emulating an "addl" function, or a
> "jmp" function.
> 
> See?

I kind of see your point... but then you're overloading the meaning of
the word "function", in a context where it clearly means something else.

> To remove the ambiguity, I could replace "function" with "instruction".

Yes, that would be much better :-)

-- 
Josh
