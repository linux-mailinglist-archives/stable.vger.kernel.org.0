Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E713231AE
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 20:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhBWT5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 14:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232389AbhBWT5W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 14:57:22 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF3BC06174A
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 11:56:41 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id y7so62460859lji.7
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 11:56:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RKIeQDdno260XDjLO0s3XwvHiwIe7NNi5S4HPc73sDY=;
        b=engQRC2wMpRf00+RORi2u1Rzb6xGXaz04XcfDL7u5MFrYYlwWNf/AvpYDHbnTQxzzs
         YJffEBUVu7I0PpY7O95EzLGUWDWXm/yIKIS++N+S23UNvCH0xRvruieP+LYhPT+Yp3RZ
         RZGsophmURY558y3LsWD/gIQSSZUQ8xztUwZFsCIFLKfbcW32l5otd6VQOazkcEyWc/b
         k+J8gkw33YuIoK2yW+Se1WDVcbE55h/R3oLvQxliZLfseOY/dbB5npclejgbBNQDY9FK
         LUNnW7P4Ah76nBu3MBfKWLY3eCUrRsoXOgyHRjVwRxA+W1NFGAno7D4Kdw9G/Qk/4WAk
         sAyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RKIeQDdno260XDjLO0s3XwvHiwIe7NNi5S4HPc73sDY=;
        b=GmEgEFzlh0zdAg8kVU4nD4xStQoyvoyQEkQ5X7e1/m/S8f/Wgl3ICiaaEXyowzzapc
         ESC6FHRdjLeTVkoaswFTMo3R8oMyl3jYsEGCCGSIEf4cMePEydEZ5np/tM7fpXWO9XsR
         x1O4sgoUJjk1usA2G0FyzkTVQ2zqwC0HJke//kv1R/v+X1cB/tbHresVtlYtjVjwGuxD
         8dxgEX+tzzvd4vrn1VZapd1H9RlPSV5Qx5jRWkd/RFSO0qMaPAQLIkhD4o6RwVZ29YG3
         gkMfACEsVSb1KlyE6JE8JD5DgOS3L2/FMPlx/nFifs2bTlCOt0y1pitV4kjBe6yX6kEG
         a+pA==
X-Gm-Message-State: AOAM531UzyNm+H8jDruirF6zTWTycjKQTRLTDVgj1PuEaiB8f7a1BUKc
        FU00FdblLjLJq9fXxMRDqhvpoGixKQnTcBECaNo1BA==
X-Google-Smtp-Source: ABdhPJxyl/3UyqiHKpd1ESZE8rAxWJCHzAvC9HBi6cBchZ8HuF5wjKgaObBTVT6WQmuozVQKHz8QjHBWkvH3VZCUlzo=
X-Received: by 2002:a2e:8357:: with SMTP id l23mr2679418ljh.116.1614110200101;
 Tue, 23 Feb 2021 11:56:40 -0800 (PST)
MIME-Version: 1.0
References: <202102151855.H817KoOF-lkp@intel.com>
In-Reply-To: <202102151855.H817KoOF-lkp@intel.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 23 Feb 2021 11:56:29 -0800
Message-ID: <CAKwvOdmqso8SmPeZ4tOLP-wFSbkkDAthG1vt6k045_C0JoU4Rg@mail.gmail.com>
Subject: Re: [linux-stable-rc:linux-5.4.y 2231/4843] ERROR: "__memcat_p" undefined!
To:     Nathan Chancellor <nathan@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        kernel test robot <lkp@intel.com>,
        "# 3.4.x" <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 15, 2021 at 2:49 AM kernel test robot <lkp@intel.com> wrote:
>
> Hi Nick,
>
> First bad commit (maybe != root cause):
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> head:   642aa3284e09f63bf1d4832798dd787b4320ca64
> commit: f05f667f8764f9ec834ca3e412ed7f5a20dea3bf [2231/4843] lib/string.c: implement stpcpy
> config: x86_64-randconfig-a005-20210215 (attached as .config)
> compiler: clang version 12.0.0 (https://github.com/llvm/llvm-project c9439ca36342fb6013187d0a69aef92736951476)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install x86_64 cross compiling tool for clang build
>         # apt-get install binutils-x86-64-linux-gnu
>         # https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?id=f05f667f8764f9ec834ca3e412ed7f5a20dea3bf
>         git remote add linux-stable-rc https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>         git fetch --no-tags linux-stable-rc linux-5.4.y
>         git checkout f05f667f8764f9ec834ca3e412ed7f5a20dea3bf
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=x86_64
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
> >> ERROR: "__memcat_p" [drivers/hwtracing/stm/stm_core.ko] undefined!

This error is unrelated to the referenced commit, but we did fix this
error finally in 5.7:
https://github.com/ClangBuiltLinux/linux/issues/515. This is not a
regression, but something that never worked with LLD until 5.7.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7273ad2b08f8ac9563579d16a3cf528857b26f49
looks like the commit of interest, though I seem to have left a
comment implying there were dependencies:
https://github.com/ClangBuiltLinux/linux/issues/515#issuecomment-612999929
(I no longer recall what they were).

Some other commits in tree reference that bug from the issue tracker.
https://github.com/0day-ci/linux/commit/0cf9baa2dbb8ca29f30ac8a1afb69de51f222d17
https://github.com/0day-ci/linux/commit/565508bb949dd72638b52522fb6ac6ec04ec57fc
https://github.com/0day-ci/linux/commit/0d0537aa772566473bd5310be3874060cbff8672

Not sure whether all 4 of the above worth backporting to 4.4.y?
Thoughts? (Perhaps these would allow us to add x86_64 allmodconfig CI
coverage with LLD for 4.4.y)

>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org



-- 
Thanks,
~Nick Desaulniers
