Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 239FC166F6
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 17:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfEGPhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 11:37:32 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43492 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbfEGPhc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 11:37:32 -0400
Received: by mail-lj1-f193.google.com with SMTP id z5so9652093lji.10
        for <stable@vger.kernel.org>; Tue, 07 May 2019 08:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y6ybn9R2wRwK7OVl8uatl/i1llM+QJoRgaCyqAFbo9Y=;
        b=BNzVqUAAViERdEuxZy8DHUiuYxo8ddmm9cVx4BOchUH3WtVYroxRTUSipMK+LTDMnx
         G6Nz0qaFq78h9Jxdf15yovQ7B7GKRx+9GVUL2kenVn+ddQfRmu4UzyEd25IlQcp/jSGE
         dAIUJDF1c1Wz5T5Q+QRd4jWS9Etfzd3108pkw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y6ybn9R2wRwK7OVl8uatl/i1llM+QJoRgaCyqAFbo9Y=;
        b=jOJnqBfmEcqczhu21w52JnnR1voJt1LDEzXdfXNrfQHkIxC9mg4IkeYtk4HA+ZDVcY
         27XuCYIXTbGObkPE0StE4yXq1jBTxFS6BrV+MGI4saVX/c77LPO1Rb5TF6aFSTk5CNTO
         ck3gOv8+zZnRddO7BcbXGHZ3vrY6A+7bZn5c5yKRdr1P8GR+ww6R7wGKR1BcHe2M1YWA
         TK4BDs0zt0QMv7Bhr4n3/AkvQ5Ce46rG1aeFhOaWU/iOWcis/SAcCt186leQpU7LUUcf
         IBZ2XPo5vPzUyyF859LGj+OLiuvXADfCFg4o7bzfKb2VcbWysFwyMjG5w1k9hvPVDICb
         xHoA==
X-Gm-Message-State: APjAAAVVDD4n9twY6+yYyb178SjdfbMu2drJJNb/k3qjAwHMv32WxJpQ
        y+EJ0QEklS69CN2LkR8/eyqBNEvREug=
X-Google-Smtp-Source: APXvYqxewhYuDuzY2y+5Ta8j1UfY+IjdSWtjrgWIfE20VQIeloHMILUu1GpidWx5YqS7UUaLJrkRZw==
X-Received: by 2002:a2e:9155:: with SMTP id q21mr15990503ljg.178.1557243449934;
        Tue, 07 May 2019 08:37:29 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id h24sm3247964ljk.10.2019.05.07.08.37.29
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 08:37:29 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id h21so14718067ljk.13
        for <stable@vger.kernel.org>; Tue, 07 May 2019 08:37:29 -0700 (PDT)
X-Received: by 2002:a2e:3e0e:: with SMTP id l14mr17667665lja.125.1557243091071;
 Tue, 07 May 2019 08:31:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190502181811.GY2623@hirez.programming.kicks-ass.net>
 <20190506145745.17c59596@gandalf.local.home> <CAHk-=witfFBW2O5v6g--FmqnAFsMkKNLosTFfWyaoJ7euQF8kQ@mail.gmail.com>
 <20190506162915.380993f9@gandalf.local.home> <CAHk-=wi5KBWUOvM94aTOPnoJ5L_aQG=vgLQ4SxxZDeQD0pF2tQ@mail.gmail.com>
 <20190506174511.2f8b696b@gandalf.local.home> <CAHk-=wj3R_s0RTJOmTBNaUPhu4fz2shNBUr4M6Ej65UYSNCs-g@mail.gmail.com>
 <20190506210416.2489a659@oasis.local.home> <CAHk-=whZwqzbu-=1r_j_cXfd=ta1q7RFCuneqBZfQQhS_P-BmQ@mail.gmail.com>
 <20190506215353.14a8ef78@oasis.local.home> <CAHk-=wjLXmOn=Cp=uOfO4gE01eN_-UcOUyrMTTw5-f_OfPO48Q@mail.gmail.com>
 <20190506225819.11756974@oasis.local.home> <CAHk-=wh4FCNBLe8OyDZt2Tr+k9JhhTsg3H8R4b55peKcf0b6eQ@mail.gmail.com>
 <20190506232158.13c9123b@oasis.local.home> <CAHk-=wi4vPg4pu6RvxQrUuBL4Vgwd2G2iaEJVVumny+cBOWMZw@mail.gmail.com>
 <CAHk-=wg2_okyU8mpkGCUrudgfg8YmNetSD8=scNbOkN+imqZdQ@mail.gmail.com> <20190507111227.1d4268d7@gandalf.local.home>
In-Reply-To: <20190507111227.1d4268d7@gandalf.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 7 May 2019 08:31:14 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjYdj+vvV8uUA8eaUSxOhu=xuQxdo-dtM927j0-3hSkEw@mail.gmail.com>
Message-ID: <CAHk-=wjYdj+vvV8uUA8eaUSxOhu=xuQxdo-dtM927j0-3hSkEw@mail.gmail.com>
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
        <linux-kselftest@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 7, 2019 at 8:12 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>>
> Yes, band-aids are usually simpler than a proper fix.

What? No/.

My fix is the *proper* fix.

PeterZ's is the bandaid.

>             We have 28 years
> of hacks built on hacks. There's a lot of hacks in the C code to handle
> the differences between the crappy way x86_32 does pt_regs and the
> proper way x86_64 does them.

You're confusing "reality": with "your dream world". They are different.

The reality is that the i386 kernel stack is just how things work. End of story.

The reality is that changing something fundamental like the kernel
stack at this point for an architecture that will not change in the
future is silly.

The reality is that Peter's patch is much bigger than mine, because it
needed a lot of other changes *because* it did that change.

> To implement your way, we need to change how the int3 handler works.
> It will be the only exception handler having to return regs, otherwise
> it will crash.

What? That's what the patch *does*. It's trivial.  It is done.

                  Linus
