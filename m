Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50F1266E0BD
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 15:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbjAQOc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 09:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbjAQOcK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 09:32:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7321F2CC71;
        Tue, 17 Jan 2023 06:31:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31599B8164F;
        Tue, 17 Jan 2023 14:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598B5C433F1;
        Tue, 17 Jan 2023 14:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673965902;
        bh=cZUwr8wft3TGwdwisT4Mb2q2UbVcMvi+LPIhyGVXIVA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B7L+KVerOooJWA9T61GYurpIqVos0ufrXXwT5rSr6kuLSBSAk4uHw5ha7y/GgyO7S
         UNCd6IILGdzMAQ3zhh1syb81pnxXtTnvkGzLK1eRmg1V/VzeUND1m+FkAOtzXT7HQE
         k8m7wCC+r0+YHZ6+vBwJLoGehUtuJVUUS8E2BGOY=
Date:   Tue, 17 Jan 2023 15:31:40 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, llvm@lists.linux.dev
Subject: Re: [PATCH 5.15 00/86] 5.15.89-rc1 review
Message-ID: <Y8axTFlEA8Cv2NPT@kroah.com>
References: <20230116154747.036911298@linuxfoundation.org>
 <CA+G9fYtpsFtS=1gECq97PWPK8uA6-3B-NY0Vkk8Vgd04BskONQ@mail.gmail.com>
 <Y8avdat8Jk+CaE8D@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y8avdat8Jk+CaE8D@dev-arch.thelio-3990X>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 17, 2023 at 07:23:49AM -0700, Nathan Chancellor wrote:
> Hi Naresh,
> 
> On Tue, Jan 17, 2023 at 04:57:52PM +0530, Naresh Kamboju wrote:
> > On Mon, 16 Jan 2023 at 21:33, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.15.89 release.
> > > There are 86 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.89-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > Results from Linaro’s test farm.
> > No regressions on arm64, arm, x86_64, and i386.
> > 
> > Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > NOTE:
> > clang-nightly build errors noticed on defconfig of arm64. arm. x86_64,
> > i386, riscv, s390 and powerpc.
> > 
> > include/trace/events/initcall.h:38:3: error: 'struct (unnamed at
> > include/trace/events/initcall.h:27:1)' cannot be defined in
> > '__builtin_offsetof'
> >                 __field_struct(initcall_t, func)
> >                 ^
> > include/trace/events/initcall.h:38:3: error: initializer element is
> > not a compile-time constant
> >                 __field_struct(initcall_t, func)
> >                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Thanks for the report! I sent backports to avoid this issue and the one
> reported on the 5.4 review but it appears they did not make this round
> of stable updates.
> 
> https://lore.kernel.org/Y8TWrJpb6Vn6E4+v@dev-arch.thelio-3990X/
> 
> Hopefully it will be cleared up next round.

Yes, I will get to them after these are released, I figured it wasn't
that big of a rush...

thanks,

greg k-h
