Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2BCF4D450D
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 11:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241441AbiCJKxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 05:53:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241463AbiCJKxs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 05:53:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E306D1A7;
        Thu, 10 Mar 2022 02:52:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 38E51CE22C8;
        Thu, 10 Mar 2022 10:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02392C340F3;
        Thu, 10 Mar 2022 10:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646909563;
        bh=NAiA4gsqmJkeAHk0Hak4NB+zhLn08hBkLxTAPu4dSto=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g0SbEzs+TmK6wAdzS3QQLnWrUFEQkgsBJaZmhnhMBWzPvqirOjdCXcajtkc/TlLa3
         ILB4XYcJHtle50WjTLD/fh9r1V9oHhJasW2ho0bxDtZHuDzLGpUr2vBA6gLWx1IFYn
         qZHfvTWtXG/aMwfvby4DkXZnceGdfIOAy3r/yfDg=
Date:   Thu, 10 Mar 2022 11:52:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/43] 5.15.28-rc1 review
Message-ID: <YinYdfpyNjPSUoEN@kroah.com>
References: <20220309155859.734715884@linuxfoundation.org>
 <b17d6dad-b5b3-6c59-b156-831913f7cd3e@linaro.org>
 <CADYN=9+VTyVCxuMBNfYGdLX+BzOhXPPURy8iaLDywyqmyiBZyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADYN=9+VTyVCxuMBNfYGdLX+BzOhXPPURy8iaLDywyqmyiBZyw@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 11:30:48AM +0100, Anders Roxell wrote:
> On Wed, 9 Mar 2022 at 22:14, Daniel Díaz <daniel.diaz@linaro.org> wrote:
> >
> > Hello!
> >
> > On 09/03/22 09:59, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.15.28 release.
> > > There are 43 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.28-rc1.gz
> > > or in the git tree and branch at:
> > >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Regressions found.
> >
> 
> [...]
> 
> >
> >
> > And here's one for Clang (same imx_v4_v5_defconfig config, but with clang-11):
> >
> >    ld.lld: error: ./arch/arm/kernel/vmlinux.lds:117: AT expected, but got NOCROSSREFS
> >    >>>  __vectors_lma = .; OVERLAY 0xffff0000 : NOCROSSREFS AT(__vectors_lma) { .vectors { *(.vectors) } .vectors.bhb.loop8 { *(.vectors.bhb.loop8) } .vectors.bhb.bpiall { *(.vectors.bhb.bpiall) } } __vectors_start = LOADADDR(.vectors); __vectors_end = LOADADDR(.vectors) + SIZEOF(.vectors); __vectors_bhb_loop8_start = LOADADDR(.vectors.bhb.loop8); __vectors_bhb_loop8_end = LOADADDR(.vectors.bhb.loop8) + SIZEOF(.vectors.bhb.loop8); __vectors_bhb_bpiall_start = LOADADDR(.vectors.bhb.bpiall); __vectors_bhb_bpiall_end = LOADADDR(.vectors.bhb.bpiall) + SIZEOF(.vectors.bhb.bpiall); . = __vectors_lma + SIZEOF(.vectors) + SIZEOF(.vectors.bhb.loop8) + SIZEOF(.vectors.bhb.bpiall); __stubs_lma = .; .stubs ADDR(.vectors) + 0x1000 : AT(__stubs_lma) { *(.stubs) } __stubs_start = LOADADDR(.stubs); __stubs_end = LOADADDR(.stubs) + SIZEOF(.stubs); . = __stubs_lma + SIZEOF(.stubs); PROVIDE(vector_fiq_offset = vector_fiq - ADDR(.vectors));
> >    >>>                                          ^
> >    make[1]: *** [/builds/linux/Makefile:1183: vmlinux] Error 1
> 
> Bisection showed patch 8f4782a68faf ("ARM: Spectre-BHB workaround") as
> the faulty patch.

Thanks, but we can't drop that one for obvious reasons :)
