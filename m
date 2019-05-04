Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05F9C13C11
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 22:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfEDU2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 16:28:23 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:32998 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbfEDU2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 May 2019 16:28:23 -0400
Received: by mail-lf1-f67.google.com with SMTP id j11so6623570lfm.0
        for <stable@vger.kernel.org>; Sat, 04 May 2019 13:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SaUefhj41Vo9ICd62i3E2YPs3qFZSdkbgRUMEL66AdI=;
        b=YWFWemqJ0JLsacxwcohY3H1Ru+7m68bmnSG7LYrodNEBsa1vqFIe7N+Z7/ib2SOef8
         WWNNvU+E2HH25gh9czdMXSA1W+PtOHyDLxhTntgAp0nZMXOMd6zYnlK0dQqvtzAQo8bz
         LSBMlFzIL2Q2R5LmuSDspX30nFFTSIPoTZtwA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SaUefhj41Vo9ICd62i3E2YPs3qFZSdkbgRUMEL66AdI=;
        b=BUT3Zln23VNiqQmRK+s31m3G8bJCBvdk6ThafZts5lRffqpnFnK21Xkk2W5rjB3Shf
         VqQxC0uaGdsDdz4bYfXnLfNR2xh6C7TDBK+z2EYGN9deuOsYjTvLbhlkwVdnj7Ik2TSa
         bVt+Y8bliKd6dNTMSwyym7OYdpXU+4nM6ETEWudzGVsZzIHBlbirvKNuNQ8qtyRXIqX0
         EwdLi/nbS3x3zAbaYY6Gns3G7qrLUGgk01TQ/h7TC0Zg+6Fid6WYz+trG+l81FlOhgEa
         0W6hhygE0Nz1K53UR5jVTfEUeDGxYf+5f2ihBkACGjw/sGWSCEQ950uC9wnfSFJIL0d4
         rdlw==
X-Gm-Message-State: APjAAAVr0tCIbScpjaYp/DsLHJ8oy+CmPn2jCE4H06THbyBGqAt5Niy6
        s1Y5j99hpBmyiDNDHnTPdiGdtVOoB80=
X-Google-Smtp-Source: APXvYqxJpx/2WGY7duNapB3qDAgMDRg9/XtyI30egcHszCSvsfyDtkyZ9Wt1CMFgSTBXJRJeOMtV2Q==
X-Received: by 2002:a19:f001:: with SMTP id p1mr9234008lfc.27.1557001700933;
        Sat, 04 May 2019 13:28:20 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id p18sm1220128ljc.54.2019.05.04.13.28.18
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 13:28:20 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id y10so1440712lji.9
        for <stable@vger.kernel.org>; Sat, 04 May 2019 13:28:18 -0700 (PDT)
X-Received: by 2002:a2e:3e0e:: with SMTP id l14mr8970707lja.125.1557001696580;
 Sat, 04 May 2019 13:28:16 -0700 (PDT)
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
Date:   Sat, 4 May 2019 13:28:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiwc8NDahj455iBWmYyvDDS+sN1TObFsxxS51gNbtZ9iw@mail.gmail.com>
Message-ID: <CAHk-=wiwc8NDahj455iBWmYyvDDS+sN1TObFsxxS51gNbtZ9iw@mail.gmail.com>
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

We've definitely historically allowed IOPL=3D3 with the whole "iopl()"
system call. And yes, afaik it works together with the vm86 system
call too. I think we copy the unsafe bits from the original eflags, so
if you do iopl(3) followed by vm86(), you will be running in vm86 mode
with iopl 3.

> (We should maybe consider a config option for iopl() that defaults off. W=
e=E2=80=99ve supported ioperm() for a long, long time.)

It's entirely possible that nobody uses iopl() and we should make it a
config option that defaults to off.

But we've already done that with the VM86 support entirely, and I'm
not sure modern distros even enable it.

And obviously vm86 mode isn't available at all with a 64-bit kernel,
so this is all slowly becoming more or less moot.

                  Linus
