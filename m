Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E07712027
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 18:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfEBQ3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 12:29:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbfEBQ3Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 12:29:16 -0400
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9686320675
        for <stable@vger.kernel.org>; Thu,  2 May 2019 16:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556814554;
        bh=dkbCGmB8aJGbYDw70GrUnrtJT8x3nxXrvwASHrQjPTw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iLX5/IR0m54fE0vzkkxIiwsbsWgj4Jp37cw4TzUtk/De3AWomS7hp0i2Z/I06e+Qi
         Hx5xHvrmjx1DgoOQe1qkYH85inCY7lQ6u5c7Yt/WDc+KfPuK7Ro+cHyRFSj3buxfSt
         wesztiPbo4DB8Xk7azvFK4/662GzvJS25JlKZpxQ=
Received: by mail-wm1-f52.google.com with SMTP id y5so3458764wma.2
        for <stable@vger.kernel.org>; Thu, 02 May 2019 09:29:14 -0700 (PDT)
X-Gm-Message-State: APjAAAXJ4zEAT/c4viVZtWY5Ygb9sVOM5W2r06NeBqDlGUSAXA1uH3DE
        NAs+PoMaHgRPIIGxCuqYI0yDrxdA+DdQgxL+TA6FLA==
X-Google-Smtp-Source: APXvYqz8qz5MkdiJ1blV68Tc+EBPo9ntpUvf4xz3iOi91gond5CFj6ha5OGRiPqDokWUmLSqYgWAc/K+F+OBWP5fmto=
X-Received: by 2002:a1c:486:: with SMTP id 128mr2855200wme.83.1556814553206;
 Thu, 02 May 2019 09:29:13 -0700 (PDT)
MIME-Version: 1.0
References: <761345df6285930339aced868ebf8ec459091383.1556807897.git.luto@kernel.org>
 <20190502154043.gfv4iplcvzjz3mc6@linutronix.de>
In-Reply-To: <20190502154043.gfv4iplcvzjz3mc6@linutronix.de>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 2 May 2019 09:29:01 -0700
X-Gmail-Original-Message-ID: <CALCETrWTCB9xLVdKCODghpeQpJ_3Rz3OwE8FB+5hjYXMYwYPLg@mail.gmail.com>
Message-ID: <CALCETrWTCB9xLVdKCODghpeQpJ_3Rz3OwE8FB+5hjYXMYwYPLg@mail.gmail.com>
Subject: Re: [PATCH] x86/fpu: Remove the _GPL from the kernel_fpu_begin/end() export
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@surriel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Nicolai Stange <nstange@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 2, 2019 at 8:41 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> On 2019-05-02 07:42:14 [-0700], Andy Lutomirski wrote:
> > The FPU is not a super-Linuxy internal detail, so remove the _GPL
> > from its export.  Without something like this patch, it's impossible
> > for even highly license-respecting non-GPL modules to use the FPU,
> > which seems silly to me.  After all, the FPU is a CPU feature, not
> > really a kernel feature at all.
> >
> > Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > Cc:: Borislav Petkov <bp@suse.de>
> > Cc: Rik van Riel <riel@surriel.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
> > Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Nicolai Stange <nstange@suse.de>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: x86@kernel.org
> > Cc: stable@vger.kernel.org
> > Fixes: 12209993e98c ("x86/fpu: Don't export __kernel_fpu_{begin,end}()"=
)
> > Signed-off-by: Andy Lutomirski <luto@kernel.org>
> > ---
> >
> > This fixes a genuine annoyance for ZFS on Linux.  Regardless of what
> > one may think about the people who distribute ZFS on Linux
> > *binaries*, as far as I know, the source and the users who build it
> > themselves are entirely respectful of everyone's license.  I have no
> > problem with EXPORT_SYMBOL_GPL() in general, but let's please avoid
> > using it for things that aren't fundamentally Linux internals.
>
> Please don't start this. We have everything _GPL that is used for FPU
> related code and only a few functions are exported because KVM needs it.
> Also with the recent FPU rework it is much easier to get this wrong so I
> would not want for any OOT code to mess with it.
>

I'm not saying that we should export things for ZFS's benefit.  But,
as far as I know, _GPL means "this interface is sufficiently specific
to Linux details that we think that any user must be a derived work".
I don't think that kernel_fpu_begin() is an example of that.

--Andy
