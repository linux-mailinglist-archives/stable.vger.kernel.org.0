Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4EE813C1D
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 22:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbfEDUgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 16:36:35 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34123 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727499AbfEDUge (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 May 2019 16:36:34 -0400
Received: by mail-lj1-f194.google.com with SMTP id s7so2556191ljh.1
        for <stable@vger.kernel.org>; Sat, 04 May 2019 13:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=avpeditiG05762mr+ZBdVz17aE8sPPywlzbuzRkmGu8=;
        b=eBpIF9Qh2Hh0a0CcqEOOixnUMFDAfxwLic/0D52BIV/HRO+FWsY+c08Ox/yuCHEacF
         mJC8j9rp5rLkkT9f+c1BKX/iz9KrtGntnPsK8AK0jGNLBjYY4668h41M7CZS5dbNLsey
         YaMrbtqOGLf0xVoZWCaQuSJHUjRnRlFE0Y9iQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=avpeditiG05762mr+ZBdVz17aE8sPPywlzbuzRkmGu8=;
        b=c6TNvDBsoWJ4jGmmdW7JJkFGKvtDC6doZezbLyeZC25nVK5DWKjHdHedfpCleES5+P
         eOJvlFhG2BU3ERQaV+5i2k1xYpu/f7q6UeNU1aM001rANr3BAViLz12e6n53dU0kO9iV
         fR32ntl8SKx3J22A9D2fCR5IVlbGPAEJCdE3HS/F+c1rJX2srYD/25N6SfdwT5G/+Rx3
         GlMWE3HWonxh/BkrRtC16bAGsLMEBY2MSAvG91JxNzgs006+YH6f0Kt77KoFVU8PdLGi
         bK4ZcAWV6zaDYUra9PUTcj0GkkZbaftD06TvDhxsQ/4U1xS/tCsXTARuIawpHAx9565S
         m5hQ==
X-Gm-Message-State: APjAAAXXNW+/4Sw30D6tFSk2zjriweQgNAzBmDnqjhCPJLB0ouuSqinH
        7kVkiVjHeTOR4eEESQSqU+6VqzVXMt0=
X-Google-Smtp-Source: APXvYqzHEK8lCW5PkV34iEWGTaHvLXtNBfdn0wIEVynxg6P4BJOsC313F+wWP7DFJ5DSlsBJ56Gneg==
X-Received: by 2002:a2e:8602:: with SMTP id a2mr1629522lji.21.1557002192588;
        Sat, 04 May 2019 13:36:32 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id l15sm1070231ljh.62.2019.05.04.13.36.29
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 13:36:32 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id o16so6601369lfl.7
        for <stable@vger.kernel.org>; Sat, 04 May 2019 13:36:29 -0700 (PDT)
X-Received: by 2002:ac2:4567:: with SMTP id k7mr8933590lfm.166.1557002188058;
 Sat, 04 May 2019 13:36:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190501202830.347656894@goodmis.org> <20190501203152.397154664@goodmis.org>
 <20190501232412.1196ef18@oasis.local.home> <20190502162133.GX2623@hirez.programming.kicks-ass.net>
 <CAHk-=wijZ-MD4g3zMJ9W2r=h8LUWneiu29OWuxZEoSfAF=0bhQ@mail.gmail.com>
 <20190502181811.GY2623@hirez.programming.kicks-ass.net> <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
 <20190502202146.GZ2623@hirez.programming.kicks-ass.net> <CAHk-=wh8bi5c_GkyjPtDAiaXaZRqtmhWs30usUvs4qK_F+c9tg@mail.gmail.com>
 <20190503152405.2d741af8@gandalf.local.home> <CAHk-=wiA-WbrFrDs-kOfJZMXy4zMo9-SZfk=7B-GfmBJ866naw@mail.gmail.com>
 <20190503184919.2b7ef242@gandalf.local.home> <CAHk-=wh2vPLvsGBi6JtmEYeqHxB5UpTzHDjY5JsWG=YR0Lypzw@mail.gmail.com>
 <20190504001756.17fad840@oasis.local.home> <CAHk-=wiuSFbv_rELND-BLWcP0GSZ0yF=xOAEcf61GE3bU9d=yg@mail.gmail.com>
 <CAHk-=wjGNx8xcwg=7nE_0-nLQ_d4UALHvJ8O+TurbA25n8MyNg@mail.gmail.com> <2BF1AE4B-8105-49F0-8B6A-AA3B11FD66FD@amacapital.net>
In-Reply-To: <2BF1AE4B-8105-49F0-8B6A-AA3B11FD66FD@amacapital.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 4 May 2019 13:36:11 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgEDAFUKRR=iELwUCk1kpoACk4eOfyyQhnYb78H9AEaSw@mail.gmail.com>
Message-ID: <CAHk-=wgEDAFUKRR=iELwUCk1kpoACk4eOfyyQhnYb78H9AEaSw@mail.gmail.com>
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
        <linux-kselftest@vger.kernel.org>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 4, 2019 at 1:12 PM Andy Lutomirski <luto@amacapital.net> wrote:
>
> As an aside, is it even *possible* to get #BP from v8086 mode?  On a quic=
k SDM read, the INT3 instruction causes #GP if VM=3D1 and IOPL<3.  And, if =
we allow vm86() to have IOPL=3D3, we should just remove that ability. It=E2=
=80=99s nuts.

Oh, and I think you mis-read the SDM.

Yes, iopl matters for "int X" (cd xx) instruction in vm86 mode.

But no, iopl does *not* matter for the special "int3/into/int1"
(cc/ce/f1) instructions, I think.

              Linus
