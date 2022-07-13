Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 831EB5736CA
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 15:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbiGMNDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 09:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbiGMND2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 09:03:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1142D6479;
        Wed, 13 Jul 2022 06:03:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C87061C0D;
        Wed, 13 Jul 2022 13:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7582CC34114;
        Wed, 13 Jul 2022 13:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657717407;
        bh=U8MYRqSlDlnXbvCd2fQeD4DFnO1nFiqGvy0p3/e/5ss=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1ObPix5W0gjk8JhRZ/8y31jfLfdgQxY+XXvp4ydIP/z+dY/jtz3DDZiWPiO9SlWIj
         YaNL4PJ9mNSb2zq2kgFUWEb2QemJsTWjCAtFDFJBmgJX7Z5BHyoa/Ri3frXDl5n5JN
         WZwSPxAeZVZCrv3adp/xKcHze2J45SbEZPaPYRhs=
Date:   Wed, 13 Jul 2022 15:03:23 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     kvm list <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
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
        Anders Roxell <anders.roxell@linaro.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH 5.18 00/61] 5.18.12-rc1 review
Message-ID: <Ys7Cm17ShWUOXkRw@kroah.com>
References: <20220712183236.931648980@linuxfoundation.org>
 <CA+G9fYvRQ9gzee8pjRmsyedz6oGyh5pzSYEPkuDoKEE+X2RZDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYvRQ9gzee8pjRmsyedz6oGyh5pzSYEPkuDoKEE+X2RZDg@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 13, 2022 at 04:33:24PM +0530, Naresh Kamboju wrote:
> On Wed, 13 Jul 2022 at 00:21, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.18.12 release.
> > There are 61 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 14 Jul 2022 18:32:19 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.12-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> Results from Linaro’s test farm.
> Regressions on x86_64 (and still validating results)
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> 1) kernel panic on x86_64 while running kvm-unit-tests.
>    - APIC base relocation is unsupported by KVM

Seems others are hitting this too:
	https://lore.kernel.org/r/CAMGffEm9y0wnn8LNS9Qo3obPhs0GD5iJZ0WejFzC4baGPDsYTw@mail.gmail.com

Does this also happen right now on Linus's tree?

> 2) qemu_x86_64 boot warning
>    - WARNING: CPU: 0 PID: 0 at arch/x86/kernel/alternative.c:558
> apply_returns+0x19c/0x1d0

Warning, but does everything still work?

And again, still on Linus's tree?

> 3) New warnings noticed while building perf
>    - Warning: Kernel ABI header at
> 'tools/arch/x86/include/asm/disabled-features.h' differs from latest
> version at 'arch/x86/include/asm/disabled-features.h'

Ick, I'll wait for that to get synced in Linus's tree.

thanks,

greg k-h
