Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5761661C
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 16:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfEGO5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 10:57:48 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41350 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbfEGO5s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 10:57:48 -0400
Received: by mail-lj1-f193.google.com with SMTP id k8so14617237lja.8
        for <stable@vger.kernel.org>; Tue, 07 May 2019 07:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rbrh0+eAfH6c7Xl2PV8FyhyJfKNvVcOio3KOqwrWtto=;
        b=Rbs4zhZWSZAoIEvFW8ZqicaczCDoK8wfJtXVM/czDDUkauJt0TcGt6pZghqByNBQb0
         ehSlEkONi7tskD0aHaudB30RNMZSHHZykUVA+izGKdIq/z2+gRVDVhHjGCa4I43HAqLa
         yuB6PrQdRmt/3nK2dXUGpm0su0mwkDdFFseIs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rbrh0+eAfH6c7Xl2PV8FyhyJfKNvVcOio3KOqwrWtto=;
        b=O/e5w62GrDiNWUgW192th4jD45nLrHQlrrdKCPa/D3cIuqM3mrQ3N5JPY/CiFskIIZ
         lHyZT1ZVmrGbHLjsbxguolL7Ap5VSTBgEJDVlBNMj8xICa74oGPWeed2bPJ5DY21r71a
         QqdMKlJZvrNCoMAc2yEU9k+U5WV0zFwfeu0lFSYk/DpG0EDpf3m5CAhj9xKuVZkftkBw
         wLvfAQRem5k3+73oy5dcs3T+2PGRIl9+xkS8VzH7oaj2XE+VaXv6bgAzRMKYNnrdhKK4
         fluWLbzb2iYI5PkMQAeAAdTF4RmsZNMxpYNMRMXE/nULLIsL0x+/px/+hAY5JYpYc5ch
         uizQ==
X-Gm-Message-State: APjAAAWY1xmRQgpluusC0uOgOGKQumKegS1mLjzoI/MVl+MpOtZBBXoI
        XwCIQ4NoquAl1VVyg69gJJj6GAbJMNY=
X-Google-Smtp-Source: APXvYqz254t6pJ9smJ8tmt/wIIYRNhi6fOCKWvuDwZwFsF+i7uTbQwSU3Mkk6lu9gCo7wozL86uu0g==
X-Received: by 2002:a2e:9d86:: with SMTP id c6mr15540879ljj.135.1557241064440;
        Tue, 07 May 2019 07:57:44 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id h14sm1392209ljg.83.2019.05.07.07.57.40
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 07:57:43 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id 132so6898915ljj.4
        for <stable@vger.kernel.org>; Tue, 07 May 2019 07:57:40 -0700 (PDT)
X-Received: by 2002:a2e:9ac8:: with SMTP id p8mr16118039ljj.79.1557241059252;
 Tue, 07 May 2019 07:57:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190502181811.GY2623@hirez.programming.kicks-ass.net>
 <20190503092247.20cc1ff0@gandalf.local.home> <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net>
 <CAHk-=wjrOLqBG1qe9C3T=fLN0m=78FgNOGOEL22gU=+Pw6Mu9Q@mail.gmail.com>
 <20190506081951.GJ2606@hirez.programming.kicks-ass.net> <20190506095631.6f71ad7c@gandalf.local.home>
 <CAHk-=wgw_Jmn1iJWanoSFb1QZn3mbTD_JEoMsWcWj5QPeyHZHA@mail.gmail.com>
 <20190506130643.62c35eeb@gandalf.local.home> <CAHk-=whesas+GDtHZks62wqXWXe4d_g3XJ359GX81qj=Fgs6qQ@mail.gmail.com>
 <20190506145745.17c59596@gandalf.local.home> <CAHk-=witfFBW2O5v6g--FmqnAFsMkKNLosTFfWyaoJ7euQF8kQ@mail.gmail.com>
 <20190506162915.380993f9@gandalf.local.home> <CAHk-=wi5KBWUOvM94aTOPnoJ5L_aQG=vgLQ4SxxZDeQD0pF2tQ@mail.gmail.com>
 <20190506174511.2f8b696b@gandalf.local.home> <CAHk-=wj3R_s0RTJOmTBNaUPhu4fz2shNBUr4M6Ej65UYSNCs-g@mail.gmail.com>
 <20190506210416.2489a659@oasis.local.home> <CAHk-=whZwqzbu-=1r_j_cXfd=ta1q7RFCuneqBZfQQhS_P-BmQ@mail.gmail.com>
 <20190506215353.14a8ef78@oasis.local.home> <CAHk-=wjLXmOn=Cp=uOfO4gE01eN_-UcOUyrMTTw5-f_OfPO48Q@mail.gmail.com>
 <48BDF7B6-252B-4D29-9116-844363010BC0@amacapital.net>
In-Reply-To: <48BDF7B6-252B-4D29-9116-844363010BC0@amacapital.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 7 May 2019 07:57:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjMFRZ7bX4NFc1+=Sy5NDHh=8rAvK-JBqB+HySM1W-Nbg@mail.gmail.com>
Message-ID: <CAHk-=wjMFRZ7bX4NFc1+=Sy5NDHh=8rAvK-JBqB+HySM1W-Nbg@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
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

On Tue, May 7, 2019 at 7:48 AM Andy Lutomirski <luto@amacapital.net> wrote:
>
> IOW I think your trick only works if the old and new states are CALL, but=
 we don=E2=80=99t know that until we=E2=80=99ve looked up the record, at wh=
ich point we can just use the result of the lookup.

It would indeed only work for call instructions. I was thinking we'd
know that because we only ever batch up call instructions, though.

But it doesn't matter. I was looking at the ftrace code because I
thought there was some subtle timing bug or race or similar. But it
turned out my "memmove()" was the problem. See the patch I just sent
out.

               Linus
