Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84A6E67CCF
	for <lists+stable@lfdr.de>; Sun, 14 Jul 2019 05:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbfGNDp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 23:45:58 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51043 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728009AbfGNDp6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jul 2019 23:45:58 -0400
Received: by mail-wm1-f67.google.com with SMTP id v15so12049362wml.0
        for <stable@vger.kernel.org>; Sat, 13 Jul 2019 20:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ggJIsuxJtFXPDh9xNRfFfdtk6eD18vpDTTf0T36AFJ0=;
        b=dY2x+fGIDtsKJmEpmckjBeTDULDjdK0Jek0ypVSkwd2bDidadQe8uMvSm8Z2LYyftP
         inXWJXTJPhqOLieD1raEWviUynF52fHM0h2ZdOwHuaKet7xSLH3ViEl5s0fB+IjAZZ20
         fowFLttLwXXHymmhNsuR6+1ig2Ec8tjlJiBr6NDREIiz8DYf+tbTtxEBFCZaEbbbjVbd
         yudYGT8Z4XYyMyxQBPl05m5RHB6/wZ6oBeAfggPgLZmqqda4/K6uDeYsoip1zau+2KQM
         ZuN5GuESCa2gSE1iaJ9W3kLIAjl0et08kNbHxsPlDZ55LjLpZ0tFudhSe6lw9v4u9Cnm
         Aajg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ggJIsuxJtFXPDh9xNRfFfdtk6eD18vpDTTf0T36AFJ0=;
        b=eguiHongGgZ1N8N92lPiWoY6CcVZSy9rIk5v2N9e2Siqya59K7JFJOa6UfmCvD9yO5
         FNiLtAntJLTJ4nKEocmq5BewlNGGrpcpYWjkQEE1uhJG+PIYRLbqYlpcnGWyA6mWC7t0
         LoX0G5Z/jQrIDRmXq7DSeqTjYR38X25TbsyLWpK7Y9L2Evd8ZnuvMxl9eXS9ZHdkr39J
         TBKa6XmTzOFzXvXeRaWd0AdRJbHVbymNEjjoHDEDaS/ZY87bhV4Y4jwJ/kHUTjZYhE+V
         /GsvEodDr3oD5zvRtX6L3cUXN5blw38c7QV4TopdqCuQpQhanN54Jly/rhU/NadrcTOx
         stXg==
X-Gm-Message-State: APjAAAXTJhcZnv+i26DNm6/BRer0xWECq4gPQh8kf0mngL4OMH2OA27p
        3PsskviuYk3Bza3wx1aZW5s=
X-Google-Smtp-Source: APXvYqxKzfy7n44Z7PMZouC6jqsC1hDEI/O9fVpBxatiFRW3us+6eVeVWmRLtoFdH7R1W35ncjr4uQ==
X-Received: by 2002:a7b:c310:: with SMTP id k16mr15999430wmj.133.1563075956079;
        Sat, 13 Jul 2019 20:45:56 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id s25sm11650959wmc.21.2019.07.13.20.45.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 13 Jul 2019 20:45:55 -0700 (PDT)
Date:   Sat, 13 Jul 2019 20:45:54 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     kbuild test robot <lkp@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     kbuild@01.org, Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org
Subject: Re: [linux-stable-rc:linux-4.14.y 9981/9999]
 arch/x86/kernel/ptrace.c:659:22: warning: ISO C90 forbids mixing
 declarations and code
Message-ID: <20190714034554.GD90669@archlinux-threadripper>
References: <201907140611.AydIXYEe%lkp@intel.com>
 <20190714034125.GA90669@archlinux-threadripper>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190714034125.GA90669@archlinux-threadripper>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 13, 2019 at 08:41:25PM -0700, Nathan Chancellor wrote:
> On Sun, Jul 14, 2019 at 06:55:15AM +0800, kbuild test robot wrote:
> > CC: kbuild-all@01.org
> > TO: Dianzhang Chen <dianzhangchen0@gmail.com>
> > CC: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> > CC: Thomas Gleixner <tglx@linutronix.de>
> > 
> > tree:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> > head:   728f3eef5bdde0f9516277b4c4519fa5436e7e5d
> > commit: 55ac552ebd34f9687cc1bdcb07006bf7f104dc99 [9981/9999] x86/ptrace: Fix possible spectre-v1 in ptrace_get_debugreg()
> > config: x86_64-rhel-7.2 (attached as .config)
> > compiler: clang version 9.0.0 (git://gitmirror/llvm_project 87856e739c8e55f3b4e0f37baaf93308ec2dbd47)
> > reproduce:
> >         git checkout 55ac552ebd34f9687cc1bdcb07006bf7f104dc99
> >         # save the attached .config to linux build tree
> >         make ARCH=x86_64 
> > 
> > If you fix the issue, kindly add following tag
> > Reported-by: kbuild test robot <lkp@intel.com>
> > 
> > All warnings (new ones prefixed by >>):
> > 
> > >> arch/x86/kernel/ptrace.c:659:22: warning: ISO C90 forbids mixing declarations and code [-Wdeclaration-after-statement]
> >                    struct perf_event *bp = thread->ptrace_bps[index];
> >                                       ^
> >    1 warning generated.
> > 
> > vim +659 arch/x86/kernel/ptrace.c
> > 
> > ---
> > 0-DAY kernel test infrastructure                Open Source Technology Center
> > https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
> Hi Greg and Sasha,
> 
> I was going to reply to this on the GCC version of the thread but I
> don't really see a way to get the original message or the message ID
> from the web archive since I'm not subscribed to that list :(
> 
> https://lists.01.org/pipermail/kbuild-all/2019-July/062379.html
> 
> This is not an issue in Linus' tree because he fixed it manually during
> the merge:
> 
> https://lore.kernel.org/lkml/CAHk-=whhq5RQYNKzHOLqC+gzSjmcEGNJjbC=Psc_vQaCx4TCKg@mail.gmail.com/
> 
> I would say that it isn't unreasonable to fold that fixup into the
> original patch, with a note that it came from Linus' merge upstream:
> 
> 223cea6a4f05 ("Merge branch 'x86-pti-for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip").
> 
> Cheers,
> Nathan

Re-adding our list, which I messed up when adding stable. Sorry for the
noise :(
