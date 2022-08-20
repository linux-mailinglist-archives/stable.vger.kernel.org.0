Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE02259B278
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 09:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiHUHBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 03:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiHUHAz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 03:00:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D732AC45;
        Sun, 21 Aug 2022 00:00:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6988760DBD;
        Sun, 21 Aug 2022 07:00:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8EFC433C1;
        Sun, 21 Aug 2022 07:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661065252;
        bh=s7VPN+oaTFY7tSucwup8RgiG7PYjh0syFZQzRlqgOaw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R0gKFWBl92vaM8c14IH0U1+S5/n39gXQZ2UbLL0Jkn766oZu6uIVwaT+NIVvsHk7M
         LhTKs4EbCnSOu03aCyXI5HtvdqbJ/XybyD8p5QISWpsjOp7NIiRmussrd0m2lNVcFY
         dkORY8m+6w2be/NOcgUaQM3fsNgPiMYZVDcrLYVQ=
Date:   Sat, 20 Aug 2022 20:28:11 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Nicholas Piggin <npiggin@gmail.com>,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 000/545] 5.10.137-rc1 review
Message-ID: <YwEnu7ChHnkgWF00@kroah.com>
References: <20220819153829.135562864@linuxfoundation.org>
 <CA+G9fYsj9ihvrUnMJ2zK-wLF6fcP6D6Kn7GRPqN3-BsrUVmr-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsj9ihvrUnMJ2zK-wLF6fcP6D6Kn7GRPqN3-BsrUVmr-Q@mail.gmail.com>
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 20, 2022 at 02:11:53PM +0530, Naresh Kamboju wrote:
> On Fri, 19 Aug 2022 at 21:16, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.137 release.
> > There are 545 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 21 Aug 2022 15:36:59 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.137-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro's test farm.
> Following regression found on powerpc.
> 
> > Nicholas Piggin <npiggin@gmail.com>
> >     KVM: PPC: Book3S HV: Remove virt mode checks from real mode handlers
> 
> The powerpc defconfig build failed on stable-rc 5.10 with gcc and clang.
> 
> In file included from arch/powerpc/kvm/book3s_xive.c:53:
> arch/powerpc/kvm/book3s_xive.c:42:15: error: 'xive_vm_h_ipi' defined
> but not used [-Werror=unused-function]
>    42 | #define X_PFX xive_vm_
>       |               ^~~~~~~~
> arch/powerpc/kvm/book3s_xive_template.c:8:20: note: in definition of
> macro 'XGLUE'
>     8 | #define XGLUE(a,b) a##b
>       |                    ^
> arch/powerpc/kvm/book3s_xive_template.c:606:14: note: in expansion of
> macro 'GLUE'
>   606 | X_STATIC int GLUE(X_PFX,h_ipi)(struct kvm_vcpu *vcpu, unsigned
> long server,
>       |              ^~~~
> arch/powerpc/kvm/book3s_xive_template.c:606:19: note: in expansion of
> macro 'X_PFX'
>   606 | X_STATIC int GLUE(X_PFX,h_ipi)(struct kvm_vcpu *vcpu, unsigned
> long server,
>       |                   ^~~~~
> arch/powerpc/kvm/book3s_xive.c:42:15: error: 'xive_vm_h_eoi' defined
> but not used [-Werror=unused-function]
>    42 | #define X_PFX xive_vm_
>       |               ^~~~~~~~
> arch/powerpc/kvm/book3s_xive_template.c:8:20: note: in definition of
> macro 'XGLUE'
>     8 | #define XGLUE(a,b) a##b
>       |                    ^
> arch/powerpc/kvm/book3s_xive_template.c:501:14: note: in expansion of
> macro 'GLUE'
>   501 | X_STATIC int GLUE(X_PFX,h_eoi)(struct kvm_vcpu *vcpu, unsigned
> long xirr)
>       |              ^~~~
> arch/powerpc/kvm/book3s_xive_template.c:501:19: note: in expansion of
> macro 'X_PFX'
>   501 | X_STATIC int GLUE(X_PFX,h_eoi)(struct kvm_vcpu *vcpu, unsigned
> long xirr)
>       |                   ^~~~~
> arch/powerpc/kvm/book3s_xive.c:42:15: error: 'xive_vm_h_cppr' defined
> but not used [-Werror=unused-function]
>    42 | #define X_PFX xive_vm_
>       |               ^~~~~~~~
> arch/powerpc/kvm/book3s_xive_template.c:8:20: note: in definition of
> macro 'XGLUE'
>     8 | #define XGLUE(a,b) a##b
>       |                    ^
> arch/powerpc/kvm/book3s_xive_template.c:442:14: note: in expansion of
> macro 'GLUE'
>   442 | X_STATIC int GLUE(X_PFX,h_cppr)(struct kvm_vcpu *vcpu,
> unsigned long cppr)
>       |              ^~~~
> arch/powerpc/kvm/book3s_xive_template.c:442:19: note: in expansion of
> macro 'X_PFX'
>   442 | X_STATIC int GLUE(X_PFX,h_cppr)(struct kvm_vcpu *vcpu,
> unsigned long cppr)
>       |                   ^~~~~
> arch/powerpc/kvm/book3s_xive.c:42:15: error: 'xive_vm_h_ipoll' defined
> but not used [-Werror=unused-function]
>    42 | #define X_PFX xive_vm_
>       |               ^~~~~~~~
> arch/powerpc/kvm/book3s_xive_template.c:8:20: note: in definition of
> macro 'XGLUE'
>     8 | #define XGLUE(a,b) a##b
>       |                    ^
> arch/powerpc/kvm/book3s_xive_template.c:323:24: note: in expansion of
> macro 'GLUE'
>   323 | X_STATIC unsigned long GLUE(X_PFX,h_ipoll)(struct kvm_vcpu
> *vcpu, unsigned long server)
>       |                        ^~~~
> arch/powerpc/kvm/book3s_xive_template.c:323:29: note: in expansion of
> macro 'X_PFX'
>   323 | X_STATIC unsigned long GLUE(X_PFX,h_ipoll)(struct kvm_vcpu
> *vcpu, unsigned long server)
>       |                             ^~~~~
> arch/powerpc/kvm/book3s_xive.c:42:15: error: 'xive_vm_h_xirr' defined
> but not used [-Werror=unused-function]
>    42 | #define X_PFX xive_vm_
>       |               ^~~~~~~~
> arch/powerpc/kvm/book3s_xive_template.c:8:20: note: in definition of
> macro 'XGLUE'
>     8 | #define XGLUE(a,b) a##b
>       |                    ^
> arch/powerpc/kvm/book3s_xive_template.c:272:24: note: in expansion of
> macro 'GLUE'
>   272 | X_STATIC unsigned long GLUE(X_PFX,h_xirr)(struct kvm_vcpu *vcpu)
>       |                        ^~~~
> arch/powerpc/kvm/book3s_xive_template.c:272:29: note: in expansion of
> macro 'X_PFX'
>   272 | X_STATIC unsigned long GLUE(X_PFX,h_xirr)(struct kvm_vcpu *vcpu)
>       |                             ^~~~~
> cc1: all warnings being treated as errors
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 

Thanks, I've dropped 2 powerpc kvm patches now that look to have caused
this and will push out a -rc2 with that hopefully fixed up.

greg k-h
