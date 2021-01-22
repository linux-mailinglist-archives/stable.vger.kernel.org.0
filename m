Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3DE73007A7
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 16:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbhAVPno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 10:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729032AbhAVPni (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 10:43:38 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066A1C06174A;
        Fri, 22 Jan 2021 07:42:50 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id z9so4376702qtv.6;
        Fri, 22 Jan 2021 07:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6dQh4eu6OadVK+LYkdoHUNDrCwpiKoNQBIPdj3Z2wsU=;
        b=djw84JL/n9DMrCkHSRIyzbIzKi/0jFfjiUmcJUvH2VkUkdkFVAO+047m6crX4gAnkG
         L5KaIcdhZ5KbFMbh9AsGN3xxbcstK86Z1WWZ9/W2WnSnRUstPray1B6mYhoczg+9cS6G
         UYFB1cPlZ73j9hLyClV+dLv+Sqdbjxo/zE5kfptCGZ7sn3Gdp5S93W4sWE0Zs03aJyaW
         AiIbSEjUiQ6VpMtzvn/9W/TJ57S3hIc3fnJLF55X9czaniyvfPCKwPkUBQg7EhTdvhf4
         DK8aZgE83uSQ+/Kc0vIk3+JXszBmXI/8hwaldUNgAw24RYdIGGgp0aSR6E1YZeQz+dST
         E0cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6dQh4eu6OadVK+LYkdoHUNDrCwpiKoNQBIPdj3Z2wsU=;
        b=rfiNhf3WrvC09SX34PBlyznh5WDOHEEwuo3+/cSG6/hdLz5AC9kp0eDipFOBCtE3QV
         qwRrtNNpfQfQZ7/w0XtHxfSJP2rYGDPjHexQZ5Ak1XjaG1OFIejZoz46B6qeCcAmUqkt
         q9uocBux1m6iYcEhYMJIdvUYBC4yjjaK6eyNj9PCUVFSn4wgDPdYiaxy+E4qszvfrrxX
         BRJfzJNUsFBTHIA5JL37kesxeVPx6/Ogbz6UvmQl459ljZvcuNhTOxOEHl1KS/MFsck1
         D7/jD9C1HRG6ZfGx+AfAi9x2xq1GQnX77tT/dEuZfFTWOYWvK3pBMaI68H1DqYeQ4UH3
         iI7A==
X-Gm-Message-State: AOAM532v9G5t1CgVAsANM8QXB/t309KtJYVt6/FvAADtymVCs8LUdAIk
        btYRaqaBSMzNp6NWNsM4TKo=
X-Google-Smtp-Source: ABdhPJwxwcoqIGf4Hd+gRO14StcrONSBu6o8bPrBtWtYBfcrU81kGkORjgCwnoUKJkXKxwLPQPOAPg==
X-Received: by 2002:ac8:4e55:: with SMTP id e21mr4677048qtw.159.1611330169191;
        Fri, 22 Jan 2021 07:42:49 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id h8sm6161683qtm.5.2021.01.22.07.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 07:42:48 -0800 (PST)
Date:   Fri, 22 Jan 2021 08:42:46 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Will Deacon <will@kernel.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH 4.14 00/50] 4.14.217-rc1 review
Message-ID: <20210122154246.GA1308786@ubuntu-m3-large-x86>
References: <20210122135735.176469491@linuxfoundation.org>
 <CA+G9fYso4QNbRWdrQiiOiMb5RUr8VtM3AkKEGLasgN+KsPSvDw@mail.gmail.com>
 <YArqULK9c1Cnt5gM@kroah.com>
 <CA+G9fYuzE9WMSB7uGjV4gTzK510SHEdJb_UXQCzsQ5MqA=h9SA@mail.gmail.com>
 <20210122153604.GA24972@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122153604.GA24972@willie-the-truck>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 22, 2021 at 03:36:04PM +0000, Will Deacon wrote:
> On Fri, Jan 22, 2021 at 08:43:18PM +0530, Naresh Kamboju wrote:
> > On Fri, 22 Jan 2021 at 20:38, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Fri, Jan 22, 2021 at 08:32:46PM +0530, Naresh Kamboju wrote:
> > > > On Fri, 22 Jan 2021 at 19:45, Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > This is the start of the stable review cycle for the 4.14.217 release.
> > > > > There are 50 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > >
> > > > > Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
> > > > > Anything received after that time might be too late.
> > > > >
> > > > > The whole patch series can be found in one patch at:
> > > > >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.217-rc1.gz
> > > > > or in the git tree and branch at:
> > > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> > > > > and the diffstat can be found below.
> > > > >
> > > > > thanks,
> > > > >
> > > > > greg k-h
> > > >
> > > > arm64 clang-10 builds breaks due to this patch on
> > > >    - stable-rc 4.14
> > > >    - stable-rc 4.9
> > > >    - stable-rc 4.4
> > > >
> > > > > Will Deacon <will@kernel.org>
> > > > >     compiler.h: Raise minimum version of GCC to 5.1 for arm64
> > > >
> > > > arm64 (defconfig) with clang-10 - FAILED
> > >
> > > How is a clang build breaking on a "check what version of gcc is being
> > > used" change?
> > >
> > > What is the error message?
> > 
> > make --silent --keep-going --jobs=8
> > O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=arm64
> > CROSS_COMPILE=aarch64-linux-gnu- 'HOSTCC=sccache clang' 'CC=sccache
> > clang'
> > In file included from <built-in>:1:
> > include/linux/kconfig.h:74:
> > include/linux/compiler_types.h:58:
> > include/linux/compiler-gcc.h:160:3: error: Sorry, your version of GCC
> > is too old - please use 5.1 or newer.
> > # error Sorry, your version of GCC is too old - please use 5.1 or newer.
> >   ^
> > 1 error generated.
> > 
> > build error link:
> > https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/980489003#L514
> 
> Urgh, looks like we need backports of 815f0ddb346c
> ("include/linux/compiler*.h: make compiler-*.h mutually exclusive") then.
> 
> Greg -- please drop my changes from 4.14, 4.9 and 4.4 for now and I'll
> look at this next week.

That backport is going to be pretty gnarly, there was a pretty decent
tailwind of fixes around that patch IIRC.

The simple solution would be to stick a !defined(__clang__) in that
preprocessor conditional so that it truly fires only for GCC.

Cheers,
Nathan
