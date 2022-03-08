Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F854D2308
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 22:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245606AbiCHVGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 16:06:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241663AbiCHVGx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 16:06:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74DA47077;
        Tue,  8 Mar 2022 13:05:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5000C61868;
        Tue,  8 Mar 2022 21:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84ECC340EB;
        Tue,  8 Mar 2022 21:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646773555;
        bh=mYqMNx9pKqFYL/FDYMjOkeTrTnmEiYyKLzmGgh/VjJs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ywhavWVbVVse1twgmQMIBO3N1UTKzMnb+NxZ0NdosoykxPXeq+EHAxkiwoKHomIHU
         tIVez9aCzbGc/fZC9SGLnZyyiRp8MG0ln6xFvh2xkm2Xu0Mi0n9PSOgJkw73+9zIfq
         JPd2ND25PUa5lHMN1aochyEauHvyBOqoOE42bcbM=
Date:   Tue, 8 Mar 2022 22:05:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/256] 5.15.27-rc2 review
Message-ID: <YifFMPFMp9gPnjPc@kroah.com>
References: <20220307162207.188028559@linuxfoundation.org>
 <Yid4BNbLm3mStBi2@debian>
 <CADVatmPdzXRU2aTeh-8dfZVmW6YPJwntSDCO8gcGDUJn-qzzAg@mail.gmail.com>
 <CA+G9fYv74gGWQLkEZ4idGYri+F9BFV1+9=bz5L0+aophSzDdVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYv74gGWQLkEZ4idGYri+F9BFV1+9=bz5L0+aophSzDdVA@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 08, 2022 at 11:08:10PM +0530, Naresh Kamboju wrote:
> Hi Greg,
> 
> On Tue, 8 Mar 2022 at 21:40, Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
> >
> > On Tue, Mar 8, 2022 at 3:36 PM Sudip Mukherjee
> > <sudipm.mukherjee@gmail.com> wrote:
> > >
> > > Hi Greg,
> > >
> > > On Mon, Mar 07, 2022 at 05:28:50PM +0100, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.15.27 release.
> > > > There are 256 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> >
> > <snip>
> >
> > >
> > > Mips failures,
> > >
> > > allmodconfig, gpr_defconfig and mtx1_defconfig fails with:
> 
> LKFT build regression noticed as Sudip reported.
>    - mips-gcc-10-allmodconfig - FAILED.
> 
> >
> > And, here is the bisect log:
> >
> > # bad: [7b9aacd770fa105a0a5f0be43bc72ce176d30331] Linux 5.15.27-rc2
> > # good: [8993e6067f263765fd26edabf3e3012e3ec4d81e] Linux 5.15.26
> > git bisect start 'HEAD' 'v5.15.26'
> > # bad: [6d4f8e67749d97f83f377911e874ca116be71fbd] drm/amd/display: For
> > vblank_disable_immediate, check PSR is really used
> > git bisect bad 6d4f8e67749d97f83f377911e874ca116be71fbd
> > # bad: [527ec9ffce51cb10a3172380aba30066ee2d056c] Input: ti_am335x_tsc
> > - fix STEPCONFIG setup for Z2
> > git bisect bad 527ec9ffce51cb10a3172380aba30066ee2d056c
> > # good: [96039b910c5a933221faa9aeca4f2fb2fa4976a1] arm64: Mark
> > start_backtrace() notrace and NOKPROBE_SYMBOL
> > git bisect good 96039b910c5a933221faa9aeca4f2fb2fa4976a1
> > # bad: [4778338032b338f80393b9dfab6832d02bddb819] MIPS: fix
> > local_{add,sub}_return on MIPS64
> > git bisect bad 4778338032b338f80393b9dfab6832d02bddb819
> > # good: [ba52217d4edd5824427134cfdfa9c2ab4390d77f] drm/amdgpu: check
> > vm ready by amdgpu_vm->evicting flag
> > git bisect good ba52217d4edd5824427134cfdfa9c2ab4390d77f
> > # good: [9eeb0cb7e2d675e3bbecc08302e3bafe21c61c52] NFSD: Fix
> > zero-length NFSv3 WRITEs
> > git bisect good 9eeb0cb7e2d675e3bbecc08302e3bafe21c61c52
> > # good: [8e68b6e3bdce82f387619e7fb6e85e6be9820182]
> > tools/resolve_btf_ids: Close ELF file on error
> > git bisect good 8e68b6e3bdce82f387619e7fb6e85e6be9820182
> > # good: [238d4d64ad4da4acefedd73094be0d1051897810] mtd: spi-nor: Fix
> > mtd size for s3an flashes
> > git bisect good 238d4d64ad4da4acefedd73094be0d1051897810
> > # first bad commit: [4778338032b338f80393b9dfab6832d02bddb819] MIPS:
> > fix local_{add,sub}_return on MIPS64
> >
> > Reverting 4778338032b3 ("MIPS: fix local_{add,sub}_return on MIPS64")
> > has fixed all the 3 build failures.
> 
> MIPS: fix local_{add,sub}_return on MIPS64
> [ Upstream commit 277c8cb3e8ac199f075bf9576ad286687ed17173 ]
> 
> Use "daddu/dsubu" for long int on MIPS64 instead of "addu/subu"
> 
> Fixes: 7232311ef14c ("local_t: mips extension")
> Signed-off-by: Huang Pei <huangpei@loongson.cn>
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Ah, I'll queue up the revert for that in the morning, thanks for finding
it.  Odd it doesn't trigger the same issue in 5.16.y.

thanks,

greg k-h
