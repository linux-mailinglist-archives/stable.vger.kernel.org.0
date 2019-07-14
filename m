Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81F9467CCA
	for <lists+stable@lfdr.de>; Sun, 14 Jul 2019 05:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbfGNDla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 23:41:30 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34829 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728009AbfGNDla (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jul 2019 23:41:30 -0400
Received: by mail-wr1-f67.google.com with SMTP id y4so13635338wrm.2
        for <stable@vger.kernel.org>; Sat, 13 Jul 2019 20:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=k4o+Y+KDbpD7pfOtNz8nE6Kx+5avwGIQVeyOodyoX/E=;
        b=ryXACw5EGYpgYUgmw+8GoAkWQ6rOMeOxfebDnhnxmfCAlFRA0nWwZawNd67StuhRPX
         Ld/OSiABaK1PfNXK+xvxFiLWF1z+91qfyOE+dYCFuKmbUe8nE7V9iTOv29AFXa2/p6Ry
         eFJJHW59ZBBpoRN6ybw4OLnFM2X/cnt+0npiCJ6BWe8oBwd7frDZL+srbcW2clyvD0ZV
         8oIvDk4YsVD3JtaapiNdsJkO+3aAFtFYKx/EBUlfFCdcXSDBLHMEWCeD1j5THAXJ6lxL
         ufN2ygt+gjz9usWjx/hya0t+oKOgVNq2URHa7xZzXMs3RAaJamP+2so62AF5N0mP2e/Q
         6pNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=k4o+Y+KDbpD7pfOtNz8nE6Kx+5avwGIQVeyOodyoX/E=;
        b=qZtvwpz81hYZg32rBE0nTAHt3ao1Kk0yPtHdsNDMicaA2k0j2RQ2f4EeLe1+bEONRd
         DjAmETf85Xka6sTBUIi29SLEUinYIRqltNyUkZnII/odj+1/5kYQWUGi/3NN3TjytfuI
         OadMZ21rV53XOq10r3764weTOADTvcMnoy7My5X63u03UXC6pVDMlkRP9anJrUKBqFQO
         GnwFjOUywGASFJibhRJsdEKVTJDzPFU7CXu2OZF528FfBuWLiJi6tqzf7exGAH2nY+sI
         erHtP7mMbJFVB97g+8wy8PERnt1dtHDwtvJETnzyJT5ARwp40LZpnJ4lYNsg9Nyj2yzF
         aGYQ==
X-Gm-Message-State: APjAAAV21cWQB9/By0dDMyGtor+2RUdhUAlex2GLqTdaUHT5cDw0oSSo
        5G62bMrJHYbT0jQS8XNBk4o=
X-Google-Smtp-Source: APXvYqyCfKLB/LDrLw47yPvuMbhTBXJK1oPguJXZPcoQI6s1Y8YIx84HDgLpHIBn6CSC5JGewTJIDQ==
X-Received: by 2002:adf:f281:: with SMTP id k1mr19602109wro.154.1563075687954;
        Sat, 13 Jul 2019 20:41:27 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id 2sm15179531wrn.29.2019.07.13.20.41.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 13 Jul 2019 20:41:27 -0700 (PDT)
Date:   Sat, 13 Jul 2019 20:41:25 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     kbuild test robot <lkp@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     kbuild@01.org, Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups, stable@vger.kernel.org
Subject: Re: [linux-stable-rc:linux-4.14.y 9981/9999]
 arch/x86/kernel/ptrace.c:659:22: warning: ISO C90 forbids mixing
 declarations and code
Message-ID: <20190714034125.GA90669@archlinux-threadripper>
References: <201907140611.AydIXYEe%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201907140611.AydIXYEe%lkp@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 14, 2019 at 06:55:15AM +0800, kbuild test robot wrote:
> CC: kbuild-all@01.org
> TO: Dianzhang Chen <dianzhangchen0@gmail.com>
> CC: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> CC: Thomas Gleixner <tglx@linutronix.de>
> 
> tree:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> head:   728f3eef5bdde0f9516277b4c4519fa5436e7e5d
> commit: 55ac552ebd34f9687cc1bdcb07006bf7f104dc99 [9981/9999] x86/ptrace: Fix possible spectre-v1 in ptrace_get_debugreg()
> config: x86_64-rhel-7.2 (attached as .config)
> compiler: clang version 9.0.0 (git://gitmirror/llvm_project 87856e739c8e55f3b4e0f37baaf93308ec2dbd47)
> reproduce:
>         git checkout 55ac552ebd34f9687cc1bdcb07006bf7f104dc99
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
> >> arch/x86/kernel/ptrace.c:659:22: warning: ISO C90 forbids mixing declarations and code [-Wdeclaration-after-statement]
>                    struct perf_event *bp = thread->ptrace_bps[index];
>                                       ^
>    1 warning generated.
> 
> vim +659 arch/x86/kernel/ptrace.c
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

Hi Greg and Sasha,

I was going to reply to this on the GCC version of the thread but I
don't really see a way to get the original message or the message ID
from the web archive since I'm not subscribed to that list :(

https://lists.01.org/pipermail/kbuild-all/2019-July/062379.html

This is not an issue in Linus' tree because he fixed it manually during
the merge:

https://lore.kernel.org/lkml/CAHk-=whhq5RQYNKzHOLqC+gzSjmcEGNJjbC=Psc_vQaCx4TCKg@mail.gmail.com/

I would say that it isn't unreasonable to fold that fixup into the
original patch, with a note that it came from Linus' merge upstream:

223cea6a4f05 ("Merge branch 'x86-pti-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip").

Cheers,
Nathan
