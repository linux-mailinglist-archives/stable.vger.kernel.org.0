Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032255712DB
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 09:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbiGLHMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 03:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiGLHMp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 03:12:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5DB2AE2D;
        Tue, 12 Jul 2022 00:12:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 170E7CE19C1;
        Tue, 12 Jul 2022 07:12:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0395C3411E;
        Tue, 12 Jul 2022 07:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657609957;
        bh=ZxGWYMMD64itBG/ESY2ZgGhNK3FcEGZ7q+1wcoeTY3Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TRan373ApgToLLso3FpoCPZM7ASspUjfH+Ms81rl59ZolWlvAQEvzvwMYSlMG4Rlp
         6SD/VtZOKP9JzT7RYRrdTsOvTmcn1gkyfMh7jZZqU9lFdSpNx1D0xofDyospDP6n3U
         Eb72YiHXk6w+yrE2YfLZOaMWSJCmulEdj0oBsiMk=
Date:   Tue, 12 Jul 2022 09:12:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/229] 5.15.54-rc2 review
Message-ID: <Ys0e3kVgc0iGSiha@kroah.com>
References: <20220711145306.494277196@linuxfoundation.org>
 <20220712011904.GG2305683@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712011904.GG2305683@roeck-us.net>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 11, 2022 at 06:19:04PM -0700, Guenter Roeck wrote:
> On Mon, Jul 11, 2022 at 04:54:12PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.54 release.
> > There are 229 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 13 Jul 2022 14:51:35 +0000.
> > Anything received after that time might be too late.
> > 
> 
> This report is for v5.15.53-230-gfba36d04986b.
> 
> Build results:
> 	total: 159 pass: 153 fail: 6
> Failed builds:
> 	powerpc:defconfig
> 	powerpc:allmodconfig
> 	powerpc:ppc64e_defconfig
> 	powerpc:cell_defconfig
> 	powerpc:skiroot_defconfig
> 	powerpc:maple_defconfig
> Qemu test results:
> 	total: 488 pass: 457 fail: 31
> Failed tests:
> 	<all ppc64>
> 
> All failed builds/tests:
> --------------
> Error log:
> arch/powerpc/kernel/vdso64/gettimeofday.S: Assembler messages:
> arch/powerpc/kernel/vdso64/gettimeofday.S:25: Error: unrecognized opcode: `cvdso_call'
> arch/powerpc/kernel/vdso64/gettimeofday.S:36: Error: unrecognized opcode: `cvdso_call'
> arch/powerpc/kernel/vdso64/gettimeofday.S:47: Error: unrecognized opcode: `cvdso_call'
> arch/powerpc/kernel/vdso64/gettimeofday.S:57: Error: unrecognized opcode: `cvdso_call_time'
> make[2]: *** [scripts/Makefile.build:390: arch/powerpc/kernel/vdso64/gettimeofday.o] Error 1
> 
> and:
> 
> Building powerpc:allmodconfig ... failed
> 
> same as above, plus
> 
> arch/powerpc/perf/callchain_64.c: In function 'is_sigreturn_64_address':
> arch/powerpc/include/asm/vdso.h:20:61: error: 'vdso64_offset_sigtramp_rt64' undeclared
> 
> arch/powerpc/kernel/vdso.c: In function 'vdso_fixup_features':
> arch/powerpc/include/asm/vdso.h:20:61: error: 'vdso64_offset_ftr_fixup_start' undeclared
> arch/powerpc/include/asm/vdso.h:20:61: error: 'vdso64_offset_ftr_fixup_end' undeclared
> 
> and various other similar errors.

Ick, I think Sasha's builders forgot to run on these patches :(

I've dropped all of the powerpc vdso patches from the 5.15.y queue now,
I'll push out a -rc3 if anyone wants to test them on that arch.

thanks,

greg k-h
