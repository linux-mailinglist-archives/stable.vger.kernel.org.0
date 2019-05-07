Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB65715813
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 05:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfEGD3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 23:29:17 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40845 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfEGD3Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 May 2019 23:29:16 -0400
Received: by mail-lf1-f65.google.com with SMTP id o16so10662553lfl.7
        for <stable@vger.kernel.org>; Mon, 06 May 2019 20:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R/noB65+Fd0EtB5jindlqg68zm1kIzE0gEKXXHcvn94=;
        b=DG2xlulfe4TTtjwKg5Jp1xduUBYvL0FZXB9N1jpK7TAE6uYF4tpucaXoUi8R5d9l/+
         KytcIWEKsvMcy0fp+OpEeYKcHIMZN9WN7rp9vnbGoWccBQuAPieF3W305wOTrvjQbR3o
         QSx3rkOQMZZZvtBKSjpN+Rv+b8+W+G1Cxk73Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R/noB65+Fd0EtB5jindlqg68zm1kIzE0gEKXXHcvn94=;
        b=aA/4UMT/2vODwvh7fd8e2p5EBrWjFSebjazLAYXESz6EMiJqQCbomq7GPE3SNy8/jH
         jivOaVW/Pw1YkRVxXnNrUy6/u/+2fTW3wwAJNGX9LFRZ5W8XPRIkG8xw/zeBEMrxgIEz
         uSeP44ZS/mmxeYq/+egaAYRflCEjSLVNlnoJjNGTOu56O0PX9OfQpSeRNp9rK6l10v+f
         tUu+ltXHnlfVEIySY9dGwSQRlM2pac/0R2Kka/rk5U+b7Nfcm3HCNfmS6pvRjE74qaJN
         bCby+DrFx0XXZlRIMrAJnqGsMCRLXGEGoyxR9L2720+JCjgTcB6xblAcxADfjT6/TACT
         ND5w==
X-Gm-Message-State: APjAAAV81mzRM+J9Rp4nJvXXEoSbXkQ+jQa2spJLnHLFCspZAee4Brw9
        bjQFrCD1oBRckA51XAOiXa+iwuTvDcE=
X-Google-Smtp-Source: APXvYqx/3MqzkOdn8qbug76VKprpv44QtEomYpG1K0PJaZ4zT3L/MbxTvUpCkzP6ci2hRADsY8eeKQ==
X-Received: by 2002:a19:96:: with SMTP id 144mr12640391lfa.29.1557199753901;
        Mon, 06 May 2019 20:29:13 -0700 (PDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id q15sm2952180lfh.59.2019.05.06.20.29.10
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 20:29:13 -0700 (PDT)
Received: by mail-lj1-f170.google.com with SMTP id z5so7814156lji.10
        for <stable@vger.kernel.org>; Mon, 06 May 2019 20:29:10 -0700 (PDT)
X-Received: by 2002:a2e:9644:: with SMTP id z4mr116194ljh.22.1557199749357;
 Mon, 06 May 2019 20:29:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190502181811.GY2623@hirez.programming.kicks-ass.net>
 <20190506095631.6f71ad7c@gandalf.local.home> <CAHk-=wgw_Jmn1iJWanoSFb1QZn3mbTD_JEoMsWcWj5QPeyHZHA@mail.gmail.com>
 <20190506130643.62c35eeb@gandalf.local.home> <CAHk-=whesas+GDtHZks62wqXWXe4d_g3XJ359GX81qj=Fgs6qQ@mail.gmail.com>
 <20190506145745.17c59596@gandalf.local.home> <CAHk-=witfFBW2O5v6g--FmqnAFsMkKNLosTFfWyaoJ7euQF8kQ@mail.gmail.com>
 <20190506162915.380993f9@gandalf.local.home> <CAHk-=wi5KBWUOvM94aTOPnoJ5L_aQG=vgLQ4SxxZDeQD0pF2tQ@mail.gmail.com>
 <20190506174511.2f8b696b@gandalf.local.home> <CAHk-=wj3R_s0RTJOmTBNaUPhu4fz2shNBUr4M6Ej65UYSNCs-g@mail.gmail.com>
 <20190506210416.2489a659@oasis.local.home> <CAHk-=whZwqzbu-=1r_j_cXfd=ta1q7RFCuneqBZfQQhS_P-BmQ@mail.gmail.com>
 <20190506215353.14a8ef78@oasis.local.home> <CAHk-=wjLXmOn=Cp=uOfO4gE01eN_-UcOUyrMTTw5-f_OfPO48Q@mail.gmail.com>
 <20190506225819.11756974@oasis.local.home> <CAHk-=wh4FCNBLe8OyDZt2Tr+k9JhhTsg3H8R4b55peKcf0b6eQ@mail.gmail.com>
 <20190506232158.13c9123b@oasis.local.home>
In-Reply-To: <20190506232158.13c9123b@oasis.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 6 May 2019 20:28:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi4vPg4pu6RvxQrUuBL4Vgwd2G2iaEJVVumny+cBOWMZw@mail.gmail.com>
Message-ID: <CAHk-=wi4vPg4pu6RvxQrUuBL4Vgwd2G2iaEJVVumny+cBOWMZw@mail.gmail.com>
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

On Mon, May 6, 2019 at 8:22 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> But still, we need to emulate the call, which requires pushing the
> return code back onto the stack. I believe that part is the part we are
> struggling with.

Yes. But I was looking at the ftrace parts because I didn't see the
bug in the low-level x86 side, so...

The x86 int3 faulting code itself looks so *trivially* simple, and it
does work for the trivial test-case too. Which was what made me go
"Hmm, maybe there's timing or something".

But it could obviously also be that the trivial test-case is just too
trivial, and doesn't involve nmi etc etc.

               Linus
