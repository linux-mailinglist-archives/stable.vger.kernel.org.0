Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E00807EE69
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 10:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730509AbfHBIJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 04:09:49 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36319 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730124AbfHBIJs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 04:09:48 -0400
Received: by mail-wm1-f66.google.com with SMTP id g67so61344053wme.1;
        Fri, 02 Aug 2019 01:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pkiniAbpRIYowvObZzSgzowbMCSR9A1msLp8+g6NbmY=;
        b=t/55TxhYOnwkgnBw6OrU26YQqR6ENDg0R/MR5E56TfzAkYyYiqlAmOZjLMcBOMrlpU
         JZp/js/aPWamgbUod4YQGPG22Qyib50OVmQsMHbTEg9xLW2D3rFwiNVEJ4BIbaXY6P/m
         eIo53ZJLYyFMp+7viZ9AdPWyIlx+g7fp8uUFCUTmAZa8//QcYybcLx4ejoctYdUA+uxE
         lR9YTVjK4V3xZKh60iTm6mu5KTo7ml7cYZOBwRY8Ud27TqvJ8P8ze9uK5yh7ETyVsYY+
         macC0BvCvjqxHuPDHiDp0Zs2c/MDjzO3YgQx3Iz2kbuPt5x4DSAoO6bMoRpJH4Y+ibeu
         EHFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pkiniAbpRIYowvObZzSgzowbMCSR9A1msLp8+g6NbmY=;
        b=KB7f8+tE2hGMWfY1QQ4fvEbjcEkyTlF7qMg1D+9ctwuh2JkLXrMtHHsu2i5BOumX44
         EqP8bszv+4vv09/f2ZHyoRVp+KW59SMrFhqF5dnopC0Rm7BnN+k54iQhIGE4al3M7c1d
         099uAyuOFxzsLLYnv9tbOHAwFCe8pnBPhPhd3gXXXkoTqxvWCkfOztL2+bU3CslDcXos
         6LQHVpB2vIA/KD4JMFDc0c+3sze2SuwZxuwotDkz60BsSjAU0PyDATBj/v18iko3fpd2
         Zbt156eTCWUMAU6XFBzSlvVcWX4ekOVbmXVX/OLWfmnMv7VkpdG9QrDwqaUwJBx8f1gN
         PI2A==
X-Gm-Message-State: APjAAAXmt/jqHxQm7OiiZdzlYlMCZsGDwsn/QM3NUHH0ebs0ZjzNfcWc
        5bYAZoDlopzeGEjgmfeRg+0=
X-Google-Smtp-Source: APXvYqybG7FTRlfurFUY6MZcehfpc9LYt6rO9cTZmsS+xJ87Ku6PQ6khMAtPOiGEm6PUcZNVDytNUw==
X-Received: by 2002:a1c:e90d:: with SMTP id q13mr3304390wmc.89.1564733384959;
        Fri, 02 Aug 2019 01:09:44 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id j33sm163382443wre.42.2019.08.02.01.09.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 01:09:44 -0700 (PDT)
Date:   Fri, 2 Aug 2019 01:09:42 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Rolf Eike Beer <eb@emlix.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: Building arm64 EFI stub with -fpie breaks build of 4.9.x
 (undefined reference to `__efistub__GLOBAL_OFFSET_TABLE_')
Message-ID: <20190802080942.GA27595@archlinux-threadripper>
References: <779905244.a0lJJiZRjM@devpool35>
 <CAKwvOdnegLvkAa+-2uc-GM63HLcucWZtN5OoFvocLs50iLNJLg@mail.gmail.com>
 <CAKwvOdn9g2Z=G_qz84S5xmn2GBNK7T-MWOGYT5C52sP0R=M_-Q@mail.gmail.com>
 <2102708.6BiaULqomI@devpool35>
 <20190802075745.GI26174@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802075745.GI26174@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 02, 2019 at 09:57:45AM +0200, Greg KH wrote:
> On Thu, Jun 06, 2019 at 09:11:00AM +0200, Rolf Eike Beer wrote:
> > Nick Desaulniers wrote:
> > > On Wed, Jun 5, 2019 at 10:27 AM Nick Desaulniers
> > > 
> > > <ndesaulniers@google.com> wrote:
> > > > On Wed, Jun 5, 2019 at 9:26 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > > On Wed, Jun 05, 2019 at 05:19:40PM +0200, Rolf Eike Beer wrote:
> > > > > > I decided to dig out a toy project which uses a DragonBoard 410c. This
> > > > > > has
> > > > > > been "running" with kernel 4.9, which I would keep this way for
> > > > > > unrelated
> > > > > > reasons. The vanilla 4.9 kernel wasn't bootable back then, but it was
> > > > > > buildable, which was good enough.
> > > > > > 
> > > > > > Upgrading the kernel to 4.9.180 caused the boot to suddenly fail:
> > > > > > 
> > > > > > aarch64-unknown-linux-gnueabi-ld:
> > > > > > ./drivers/firmware/efi/libstub/lib.a(arm64- stub.stub.o): in function
> > > > > > `handle_kernel_image':
> > > > > > /tmp/e2/build/linux-4.9.139/drivers/firmware/efi/libstub/arm64-stub.c:
> > > > > > 63:
> > > > > > undefined reference to `__efistub__GLOBAL_OFFSET_TABLE_'
> > > > > > aarch64-unknown-linux-gnueabi-ld:
> > > > > > ./drivers/firmware/efi/libstub/lib.a(arm64- stub.stub.o): relocation
> > > > > > R_AARCH64_ADR_PREL_PG_HI21 against symbol
> > > > > > `__efistub__GLOBAL_OFFSET_TABLE_' which may bind externally can not
> > > > > > be used when making a shared object; recompile with -fPIC
> > > > > > /tmp/e2/build/linux-4.9.139/drivers/firmware/efi/libstub/arm64-stub.c:
> > > > > > 63:
> > > > > > (.init.text+0xc): dangerous relocation: unsupported relocation
> > > > > > /tmp/e2/build/linux-4.9.139/Makefile:1001: recipe for target 'vmlinux'
> > > > > > failed -make[1]: *** [vmlinux] Error 1
> > > > > > 
> > > > > > This is caused by commit 27b5ebf61818749b3568354c64a8ec2d9cd5ecca from
> > > > > > linux-4.9.y (which is 91ee5b21ee026c49e4e7483de69b55b8b47042be),
> > > > > > reverting
> > > > > > this commit fixes the build.
> > > > > > 
> > > > > > This happens with vanilla binutils 2.32 and gcc 8.3.0 as well as
> > > > > > 9.1.0. See
> > > > > > the attached .config for reference.
> > > > > > 
> > > > > > If you have questions or patches just ping me.
> > > > > 
> > > > > Does Linus's latest tree also fail for you (or 5.1)?
> > > > > 
> > > > > Nick, do we need to add another fix that is in mainline for this to work
> > > > > properly?
> > > > > 
> > > > > thanks,
> > > > > 
> > > > > greg k-h
> > > > 
> > > > Doesn't immediately ring any bells for me.
> > > 
> > > Upstream commits:
> > > dd6846d77469 ("arm64: drop linker script hack to hide __efistub_ symbols")
> > > 1212f7a16af4 ("scripts/kallsyms: filter arm64's __efistub_ symbols")
> > > 
> > > Look related to __efistub__ prefixes on symbols and aren't in stable
> > > 4.9 (maybe Rolf can try cherry picks of those).
> > 
> > I now have cherry-picked these commits:
> > 
> > dd6846d77469
> > fdfb69a72522e97f9105a6d39a5be0a465951ed8
> > 1212f7a16af4
> > 56067812d5b0e737ac2063e94a50f76b810d6ca3
> > 
> > The 2 additional ones were needed as dependencies of the others. Nothing of 
> > this has helped.
> 
> Did this ever get resolved, or is it still an issue?
> 
> thanks,
> 
> greg k-h
> 

This appears to have been resolved by commit 8fca3c364683 ("efi/libstub:
Unify command line param parsing") in 4.9.181. I can build defconfig +
CONFIG_RANDOMIZE_BASE without any issues.

Cheers,
Nathan
