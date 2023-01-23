Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF5A6775D1
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 08:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbjAWHv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 02:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbjAWHv2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 02:51:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55D0EC5A;
        Sun, 22 Jan 2023 23:51:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61BF260DBF;
        Mon, 23 Jan 2023 07:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4542DC433D2;
        Mon, 23 Jan 2023 07:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674460285;
        bh=SCRkbL2iZB4zfdB9i/1Vjh4wRgvV6Z0WSXYrcWlXYfk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U6ofSfpBt+Rhu0Af/PWGzFsmfqIFrWPo/60I6owTQURlrL882sZQ8pXTvb+IGXnZk
         ol4AbYRGm/b/MHyQQBgmmIRPPu2HmW0I//5I1HzOhXEwNM66eTv06Uu4aeS1MQib1S
         +T0+ip9XezImC+PlZMmS4Zkr9qVbyVHakVEHSJwE=
Date:   Mon, 23 Jan 2023 08:51:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Tom Saeger <tom.saeger@oracle.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 5.15 000/117] 5.15.90-rc1 review
Message-ID: <Y848ey9hzyHf3t8d@kroah.com>
References: <20230122150232.736358800@linuxfoundation.org>
 <CA+G9fYsEvpCj_vSFLxkKA6tzdNOhimqZYF+WCLKYAiNLtrMvsA@mail.gmail.com>
 <Y842R2KIhUL9XMUi@kroah.com>
 <CAMj1kXF02H87N4NsPWCdjdkGz-D_EQVMxbN3=btgzr5F=P0eRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMj1kXF02H87N4NsPWCdjdkGz-D_EQVMxbN3=btgzr5F=P0eRQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 23, 2023 at 08:28:18AM +0100, Ard Biesheuvel wrote:
> On Mon, 23 Jan 2023 at 08:24, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Jan 23, 2023 at 12:39:55PM +0530, Naresh Kamboju wrote:
> > > On Sun, 22 Jan 2023 at 20:46, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 5.15.90 release.
> > > > There are 117 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.90-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > > Results from Linaro’s test farm.
> > >
> > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > >
> > > Build regressions found on sh:
> > >    - build/gcc-8-dreamcast_defconfig
> > >    - build/gcc-8-microdev_defconfig
> > >
> > >
> > > Build error logs:
> > >
> > > `.exit.text' referenced in section `__bug_table' of crypto/algboss.o:
> > > defined in discarded section `.exit.text' of crypto/algboss.o
> > > `.exit.text' referenced in section `__bug_table' of
> > > drivers/char/hw_random/core.o: defined in discarded section
> > > `.exit.text' of drivers/char/hw_random/core.o
> > > make[1]: *** [/builds/linux/Makefile:1218: vmlinux] Error 1
> > >
> > > Bisection points to this commit,
> > >     arch: fix broken BuildID for arm64 and riscv
> > >     commit 99cb0d917ffa1ab628bb67364ca9b162c07699b1 upstream.
> > >
> > > Ref:
> > > upstream discussion thread,
> > > https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/
> >
> > Argh, what a mess.  Ok, let me rip out that commit (and the "fixes up
> > that commit") series from the trees and push out a -rc2 in a few hours
> > after I wake up.  I was worried about that one, and I should have
> > trusted my first instinct...
> >
> 
> The patch in question has
> 
>     Fixes: 994b7ac1697b ("arm64: remove special treatment for the link
> order of head.o")
>     Fixes: 2348e6bf4421 ("riscv: remove special treatment for the link
> order of head.o")
> 
> both of which were introduced in the current v6.2 cycle.
> 
> Neither of those are marked for stable, are obviously non-stable
> material, and were not queued up themselves.
> 
> So how did we end up queuing these in the first place?

Because of this long thread:
	https://lore.kernel.org/r/Y842qsBn37yi9OuR@kroah.com
it was requested by Tom to add it (to: him as well.)

I'm dropping the whole series now, and will wait for a working set of
backports to be submitted by Tom before reconsidering them.

thanks,

greg k-h
