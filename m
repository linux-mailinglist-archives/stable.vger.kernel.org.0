Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21AEC2FC4C2
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 00:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbhASXcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 18:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbhASXag (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 18:30:36 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32489C061573;
        Tue, 19 Jan 2021 15:29:56 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id n142so23773640qkn.2;
        Tue, 19 Jan 2021 15:29:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d94cS14NAvNpT+0LRM0deV47EMUpdOZrviz+DSohwD8=;
        b=i9fTLjTyV7m/T5eKJHlOhLNOh1rMxoKZrtzGVr0wi3kQe88upJ2oQPIlkDtrZPddrn
         eSUTEzxCobTIEoyxMFOgb/bMNWOk0k3YVgLgnGFLVNxnHxxcYc1JGxUxOvAV59hjfi0e
         1rQph6CV0uCYTRuVOzBXQVONmQ81/cur/ap/uPrP5IXuoZHo/f+bt2T9aPYfKxyn76hE
         IjH1vhA59/dpY6SEOAY3E1obqT8edrgK6IVzg4VtTYB/0WQqdsJJn4VSwg5ZkYto3B8a
         FGzlg2tja6taplbHIcvdj3p/njLriQymwTiA7AcH+AZIbsxEo/RTvoPeefpjoE15yW7U
         FNJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d94cS14NAvNpT+0LRM0deV47EMUpdOZrviz+DSohwD8=;
        b=WuqQgjFw6BfPGDimTBe9VN50SOdrGgbGEX6p5Z3is5ixOEXpC8eOFFk8gZFSNI9kcO
         UTOStBAAy1npy/Vp3Ye4TAtPzYqY4SezG/k8ylwXoo+k8hKoUDzGXX8XQjo1EgVvVpvj
         MgvRk7xhLfEeDnU0n3wnIjQDkHCjwZvPfjAZ87oMZGVTH0uchgxxsBgIFI24oUc6XtHc
         8S4GcSXSWzilTtoxhFgXagUL5QI+DzdvSFKsA3MRy1cQcwaHmmFRjrpwsYqS9lCgnMWN
         7oUiaXg1RUFql+Jx9p1ZTZRA43LsETD4Ev9h4UQInaeYGsW1mTJvbAVruyn6chH6OvaN
         zC5g==
X-Gm-Message-State: AOAM532CnbbpT/CbezhpkkcEOr2b05HxcrJ+zx9YDJ7PA9bg1Bym+2GP
        W8CdiMaY3vM79/EC0Q42iO4=
X-Google-Smtp-Source: ABdhPJwOVVmjlVTvyAFhpuyGk9BYpBeUGXGTJRD7mVwiZ8zb/ffE19uoBLT30nGC8TLEjm0uQIxIxA==
X-Received: by 2002:a37:4a82:: with SMTP id x124mr6953365qka.458.1611098995304;
        Tue, 19 Jan 2021 15:29:55 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id l20sm128686qtu.25.2021.01.19.15.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 15:29:54 -0800 (PST)
Date:   Tue, 19 Jan 2021 16:29:52 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Will Deacon <will@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Florian Weimer <fweimer@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Caroline Tice <cmtice@google.com>,
        Luis Lozano <llozano@google.com>,
        Stephen Hines <srhines@google.com>
Subject: Re: [STABLE BACKPORT 4.4.y, 4.9.y and 4.14.y] compiler.h: Raise
 minimum version of GCC to 5.1 for arm64
Message-ID: <20210119232952.GA2650682@ubuntu-m3-large-x86>
References: <20210118135426.17372-1-will@kernel.org>
 <CAKwvOdmShphZV96PjaHbUW17mKhhRi_X0AZotryKmiGVKyiQyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdmShphZV96PjaHbUW17mKhhRi_X0AZotryKmiGVKyiQyw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 19, 2021 at 02:15:43PM -0800, Nick Desaulniers wrote:
> On Mon, Jan 18, 2021 at 5:54 AM Will Deacon <will@kernel.org> wrote:
> >
> > commit dca5244d2f5b94f1809f0c02a549edf41ccd5493 upstream.
> >
> > GCC versions >= 4.9 and < 5.1 have been shown to emit memory references
> > beyond the stack pointer, resulting in memory corruption if an interrupt
> > is taken after the stack pointer has been adjusted but before the
> > reference has been executed. This leads to subtle, infrequent data
> > corruption such as the EXT4 problems reported by Russell King at the
> > link below.
> >
> > Life is too short for buggy compilers, so raise the minimum GCC version
> > required by arm64 to 5.1.
> >
> > Reported-by: Russell King <linux@armlinux.org.uk>
> > Suggested-by: Arnd Bergmann <arnd@kernel.org>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > Tested-by: Nathan Chancellor <natechancellor@gmail.com>
> > Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> > Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> > Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: <stable@vger.kernel.org> # 4.4.y, 4.9.y and 4.14.y only
> > Cc: Theodore Ts'o <tytso@mit.edu>
> > Cc: Florian Weimer <fweimer@redhat.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > Link: https://lore.kernel.org/r/20210105154726.GD1551@shell.armlinux.org.uk
> > Link: https://lore.kernel.org/r/20210112224832.10980-1-will@kernel.org
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > [will: backport to 4.4.y/4.9.y/4.14.y]
> 
> Merging this from stable into "Android Common Kernel" trees that were
> built with AOSP GCC 4.9, I expect this to break some builds.  Arnd,
> IIRC did you mention that AOSP GCC had picked up a fix?  If so, did
> you verify that via disassembly, or gerrit patch file?
> 
> (AOSP GCC 4.9: https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/
> master branch, roll back a few commits).
> It looks like AOSP GCC `#defines __android__ 1`.

It seems like this is the source for that toolchain?

https://android.googlesource.com/toolchain/gcc

If so, it looks like that patch was picked up in this commit.

https://android.googlesource.com/toolchain/gcc/+/5ae0308a147ec3f6502fd321860524e634a647a6

Cheers,
Nathan
