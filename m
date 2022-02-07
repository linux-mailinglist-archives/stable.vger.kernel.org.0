Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01194ABFC6
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 14:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347135AbiBGNoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 08:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344368AbiBGNiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 08:38:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315BCC043181;
        Mon,  7 Feb 2022 05:38:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C121961258;
        Mon,  7 Feb 2022 13:38:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA267C340F5;
        Mon,  7 Feb 2022 13:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644241100;
        bh=pckcxANR31hSoBJ7CS3Tfcm617BRnX3Og809MDixEeU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qbJV0bSaAAPUvgIW7JVwfgqJXLwUETek0dyrM2yFdYP9klX4oAReMN6n8ZvBg4Wov
         YDH5FBJTk/3oWTAcWs19D0oxv5Wd4tg2/2tDu8agigNGBGDEAu2rDpT2cFU9oufiDU
         +pveXsElDpciuCurAvk/jBQ5jamyA9nmKK3AXaOs=
Date:   Mon, 7 Feb 2022 14:38:17 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nicolas Saenz Julienne <nsaenzju@redhat.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Arnd Bergmann <arnd@arndb.de>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 5.16 000/126] 5.16.8-rc1 review
Message-ID: <YgEgybmgfR/DzNUZ@kroah.com>
References: <20220207103804.053675072@linuxfoundation.org>
 <CA+G9fYsd_kjuXOJx9umAhkaA7rRx40gVhY9ZBEe6xsMOZ2oTQg@mail.gmail.com>
 <d4a766d90803e794985e8d693972c24e5fe1926f.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d4a766d90803e794985e8d693972c24e5fe1926f.camel@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 07, 2022 at 01:22:45PM +0100, Nicolas Saenz Julienne wrote:
> On Mon, 2022-02-07 at 17:49 +0530, Naresh Kamboju wrote:
> > > This is the start of the stable review cycle for the 5.16.8 release.
> > > There are 126 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >         
> > > https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.8-rc1.gz
> > > or in the git tree and branch at:
> > >          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > > linux-5.16.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > 
> > Linux stable-rc 5.16 arm64 builds failed due to below errors.
> > 
> >   kvm/arm64: rework guest entry logic
> >   [ Upstream commit 8cfe148a7136bc60452a5c6b7ac2d9d15c36909b ]
> > 
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > arch/arm64/kvm/arm.c: In function 'kvm_arm_vcpu_enter_exit':
> > arch/arm64/kvm/arm.c:778:9: error: implicit declaration of function
> > 'guest_state_enter_irqoff'; did you mean 'guest_enter_irqoff'?
> > [-Werror=implicit-function-declaration]
> >   778 |         guest_state_enter_irqoff();
> >       |         ^~~~~~~~~~~~~~~~~~~~~~~~
> >       |         guest_enter_irqoff
> > arch/arm64/kvm/arm.c:780:9: error: implicit declaration of function
> > 'guest_state_exit_irqoff'; did you mean 'guest_exit_irqoff'?
> > [-Werror=implicit-function-declaration]
> >   780 |         guest_state_exit_irqoff();
> >       |         ^~~~~~~~~~~~~~~~~~~~~~~
> >       |         guest_exit_irqoff
> > arch/arm64/kvm/arm.c: In function 'kvm_arch_vcpu_ioctl_run':
> > arch/arm64/kvm/arm.c:875:17: error: implicit declaration of function
> > 'guest_timing_enter_irqoff'; did you mean 'guest_enter_irqoff'?
> > [-Werror=implicit-function-declaration]
> >   875 |                 guest_timing_enter_irqoff();
> >       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~
> >       |                 guest_enter_irqoff
> > arch/arm64/kvm/arm.c:925:17: error: implicit declaration of function
> > 'guest_timing_exit_irqoff'; did you mean 'guest_exit_irqoff'?
> > [-Werror=implicit-function-declaration]
> >   925 |                 guest_timing_exit_irqoff();
> >       |                 ^~~~~~~~~~~~~~~~~~~~~~~~
> >       |                 guest_exit_irqoff
> > cc1: some warnings being treated as errors
> > 
> > 
> > build link:
> > -----------
> 
> I think this patch is missing:
> https://lore.kernel.org/lkml/87czk65vhq.wl-maz@kernel.org/T/#m49f8ab674c269f14f57dae33f90af30617bc735f


Thanks, I'll go queue this up now and push out some -rc2 releases.

greg k-h
