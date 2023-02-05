Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 138D068B173
	for <lists+stable@lfdr.de>; Sun,  5 Feb 2023 20:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjBETvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Feb 2023 14:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjBETvU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Feb 2023 14:51:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FBD1B545;
        Sun,  5 Feb 2023 11:51:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DD4F60BA6;
        Sun,  5 Feb 2023 19:51:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812EDC433EF;
        Sun,  5 Feb 2023 19:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675626678;
        bh=Cfoi1fMvKQ+evElfR1WMirNcIoGAQaH3B+wkU7DqXV4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MvcZdFZg/xHLkp7b83g3kjNleHoLKzlz6oRoW47yybJHhOwV+lHds4wSQMBySE+cb
         +3tYF/R6oPo4f5IgnmTSjUTrj5XWX61XTdok7Ee8ZvqOoTLRv6BTcEAZJtvmhkU/vw
         Dje5Rhfe29c0vmfgLy07RqXvMu26ESVwXtbnoz4DD6EEKAW+PbSIs0WkcyA/7b3PyN
         Wc3Gsxa+rB/LtL3QPaAiEAop6fdNzgyqHzUpf6nLBw0UlGjNWpYkm/y8HiaijMPKnp
         +znSzrIREnMU1hMenIInjNOLVHQIOaPxvVKH7yGmVTTH7Lc8giryN3xrSG7hLGAwJ2
         LFv+nxUUxja5Q==
Date:   Sun, 5 Feb 2023 12:51:15 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        llvm@lists.linux.dev
Subject: Re: [PATCH 6.1 00/28] 6.1.10-rc1 review
Message-ID: <Y+AIsz4/7Ms28aWK@dev-arch.thelio-3990X>
References: <20230203101009.946745030@linuxfoundation.org>
 <CA+G9fYtsSuw=W0LSpzJRzsXB6qGYS3og1v=FOrvPHSAdRPCDPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtsSuw=W0LSpzJRzsXB6qGYS3og1v=FOrvPHSAdRPCDPA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Naresh,

On Sat, Feb 04, 2023 at 12:55:10PM +0530, Naresh Kamboju wrote:
> On Fri, 3 Feb 2023 at 15:50, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.1.10 release.
> > There are 28 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.10-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> NOTE:
> 
> clang-nightly-allmodconfig - Failed
> 
> Build error:
> -----------
>   include/linux/fortify-string.h:430:4: error: call to '__write_overflow_field'
>    declared with 'warning' attribute: detected write beyond size of field
>    (1st parameter); maybe use struct_group()? [-Werror,-Wattribute-warning]
> 
> This is already reported upstream,
> https://lore.kernel.org/llvm/63d0c141.050a0220.c848b.4e93@mx.google.com/

I think you copied the wrong warning, as the one upstream is a write
warning, whereas the one I see in your build logs is a read error:

In file included from /builds/linux/drivers/infiniband/core/cma.c:9:
In file included from /builds/linux/include/linux/completion.h:12:
In file included from /builds/linux/include/linux/swait.h:7:
In file included from /builds/linux/include/linux/spinlock.h:56:
In file included from /builds/linux/include/linux/preempt.h:78:
In file included from /builds/linux/arch/x86/include/asm/preempt.h:7:
In file included from /builds/linux/include/linux/thread_info.h:60:
In file included from /builds/linux/arch/x86/include/asm/thread_info.h:53:
In file included from /builds/linux/arch/x86/include/asm/cpufeature.h:5:
In file included from /builds/linux/arch/x86/include/asm/processor.h:22:
In file included from /builds/linux/arch/x86/include/asm/msr.h:11:
In file included from /builds/linux/arch/x86/include/asm/cpumask.h:5:
In file included from /builds/linux/include/linux/cpumask.h:12:
In file included from /builds/linux/include/linux/bitmap.h:11:
In file included from /builds/linux/include/linux/string.h:253:
/builds/linux/include/linux/fortify-string.h:543:4: error: call to '__read_overflow' declared with 'error' attribute: detected read beyond size of object (1st parameter)
                        __read_overflow();
                        ^

Regardless, this is still a clang bug that we are actively investigating, so it
can still be safely ignored by the kernel folks.

https://github.com/ClangBuiltLinux/linux/issues/1687

Cheers,
Nathan
