Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11A3574A0B
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 12:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237856AbiGNKEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 06:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237673AbiGNKEU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 06:04:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F431DFFC;
        Thu, 14 Jul 2022 03:04:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA07161FC9;
        Thu, 14 Jul 2022 10:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB804C34114;
        Thu, 14 Jul 2022 10:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657793058;
        bh=XV+fvidSE85iVWA39bDNH9XKnV+Mg+AU/aBFdWrQP6U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GHlKKvxhKp92LpsmEhGWbxA+YNanFCYGwblEx8EnCl0B6TSwCkui+2/e1X5FwT9RS
         VJfNrvvvRd3vZwghSZeH6UjGSx1+MHncMhQ0pl1rjUt86PiNurIhu7w/cdcqOlnL7N
         1EHQUaTMKAVnvi8VPw3SmSLn0UPQCp/HDLzMws1k=
Date:   Thu, 14 Jul 2022 12:04:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        kvm list <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 5.15 00/78] 5.15.55-rc1 review
Message-ID: <Ys/qHw7E/6gWqEbN@kroah.com>
References: <20220712183238.844813653@linuxfoundation.org>
 <CA+G9fYtntg7=zWSs-dm+n_AUr_u0eBOU0zrwWqMeXZ+SF6_bLw@mail.gmail.com>
 <1a143d949dc333666374cf14fae4496045f77db4.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a143d949dc333666374cf14fae4496045f77db4.camel@redhat.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 12:50:10PM +0300, Maxim Levitsky wrote:
> On Wed, 2022-07-13 at 18:22 +0530, Naresh Kamboju wrote:
> > On Wed, 13 Jul 2022 at 00:17, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > 
> > > This is the start of the stable review cycle for the 5.15.55 release.
> > > There are 78 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 14 Jul 2022 18:32:19 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.55-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Results from Linaro’s test farm.
> > Regressions on x86_64.
> > 
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > 1) Kernel panic noticed on device x86_6 while running kvm-unit-tests.
> >    - APIC base relocation is unsupported by KVM
> 
> My 0.2 cent:
> 
> APIC base relocation warning is harmless, and I removed it 5.19 kernel:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.19-rc6&id=3743c2f0251743b8ae968329708bbbeefff244cf

Nice, but doesn't look relevant for stable trees.

> The 'emulating exchange as write' is also something that KVM unit tests trigger
> normally although this warning recently did signal a real and very nasty bug, which I fixed in this commit:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.19-rc6&id=33fbe6befa622c082f7d417896832856814bdde0

Already in the 5.18.2 release, doesn't look all that relevant for 5.15,
odd that it is showing up on 5.15.

thanks,

greg k-h
