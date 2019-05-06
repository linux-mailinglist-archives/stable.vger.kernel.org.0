Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0962B15380
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 20:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfEFSPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 14:15:01 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39491 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbfEFSPB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 May 2019 14:15:01 -0400
Received: by mail-lf1-f68.google.com with SMTP id z124so3707419lfd.6
        for <stable@vger.kernel.org>; Mon, 06 May 2019 11:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+QBasbgDBBBZgS2pVJekzI8/+EO3uoHDtSFy2Fyb2GE=;
        b=KY56o2zkPfttJHquP5i+aSm2DJQcYtHn8+L5gH++7lWF4448+Xba0wDZ28VwqzrGv1
         tcq/bdUNFwTDnHCXu5vdwHSNmP7T3yuhy8K9P+M95vYbA5STJOSfgc37VSP/ttbrK7R6
         jlISK8kLlMP2oYwfXqmkLs9dVgVVu51tUvEBQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+QBasbgDBBBZgS2pVJekzI8/+EO3uoHDtSFy2Fyb2GE=;
        b=rBS8+5/W/myS6bS1kKIVxMzWRt+mjEXdxYz/VOAuwI3I7k1ToNfhUG+v512QbrIk4P
         mEDilc6A07aZczayZfrw6exipsMpzrEJKmXeLa/yZvPsqf5B7506XY5jhAniPqnWYNpw
         fwGYBYJAEpLUfFnTyBakgHAem3bH+2J+9gXLNtb3MNp4vV0WDdPMrTv/krjZuWIQVfrQ
         mih08I9bDaeLCLbZPTFGs+HKPuDxjThAhLojx3yuu5wY4z/PToIjLIfzAacP9AevA18M
         hvnmpM4vOI9ILOCC61bWpIUuMsWku6CR62Qpy+iurAdk0g7SUYLuDb1KP5NhWFETCU/J
         DumA==
X-Gm-Message-State: APjAAAUt5BEjoQQsLOfL9VUcvQtsQSJwlAD6rgziAhgBQDjST7ZxRIxd
        aXz6Z3GkHGGvKmkwX46Bo3DjADTlMmA=
X-Google-Smtp-Source: APXvYqyoO1eOUPlIcY+2hdelffKqdQCF5jbau9BMmtvkRapkB8NfZR4uLKrNSACigNrTApe0SNVZfA==
X-Received: by 2002:a19:5507:: with SMTP id n7mr14603261lfe.140.1557166499131;
        Mon, 06 May 2019 11:14:59 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id d23sm2270029ljj.38.2019.05.06.11.14.58
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 11:14:58 -0700 (PDT)
Received: by mail-lj1-f174.google.com with SMTP id d15so11927229ljc.7
        for <stable@vger.kernel.org>; Mon, 06 May 2019 11:14:58 -0700 (PDT)
X-Received: by 2002:a2e:9ac8:: with SMTP id p8mr13096464ljj.79.1557166027424;
 Mon, 06 May 2019 11:07:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190502181811.GY2623@hirez.programming.kicks-ass.net>
 <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
 <20190502202146.GZ2623@hirez.programming.kicks-ass.net> <20190502185225.0cdfc8bc@gandalf.local.home>
 <20190502193129.664c5b2e@gandalf.local.home> <20190502195052.0af473cf@gandalf.local.home>
 <20190503092959.GB2623@hirez.programming.kicks-ass.net> <20190503092247.20cc1ff0@gandalf.local.home>
 <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net> <CAHk-=wjrOLqBG1qe9C3T=fLN0m=78FgNOGOEL22gU=+Pw6Mu9Q@mail.gmail.com>
 <20190506081951.GJ2606@hirez.programming.kicks-ass.net> <20190506095631.6f71ad7c@gandalf.local.home>
 <CAHk-=wgw_Jmn1iJWanoSFb1QZn3mbTD_JEoMsWcWj5QPeyHZHA@mail.gmail.com> <20190506130643.62c35eeb@gandalf.local.home>
In-Reply-To: <20190506130643.62c35eeb@gandalf.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 6 May 2019 11:06:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=whesas+GDtHZks62wqXWXe4d_g3XJ359GX81qj=Fgs6qQ@mail.gmail.com>
Message-ID: <CAHk-=whesas+GDtHZks62wqXWXe4d_g3XJ359GX81qj=Fgs6qQ@mail.gmail.com>
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

On Mon, May 6, 2019 at 10:06 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Can you try booting with:
> [ snip snip ]
>
> And see if it boots?

No it doesn't.

Dang, I tried to figure out what's up, but now I really have to start
handling all the puill requests..

I thought it might be an int3 that happens on the entry stack, but I
don't think that should ever happen. Either it's a user-mode int3, or
we're in the kernel and have switched stacks. So I still don't see why
my patch doesn't work, but now I have no time to debug it.

                   Linus
