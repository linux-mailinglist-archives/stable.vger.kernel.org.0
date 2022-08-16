Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA4BA595BAC
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 14:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiHPMV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 08:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiHPMVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 08:21:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672A917E02;
        Tue, 16 Aug 2022 05:21:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEBED61199;
        Tue, 16 Aug 2022 12:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9308C433D6;
        Tue, 16 Aug 2022 12:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660652480;
        bh=nCo2keX/vyktzHEJfYoLil0f7n5O9MU+p9hriBKmC5s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yZ5MGtCcdgbtb9ZSlur+uIBmF1K2Fu41wGpSbGxUumldS4WPhpUY6m6JZpI5DfD3j
         J4FNVYdmcPyaAxwKkBpaIKLq1Ms/ht5SeBieCZ/2bBwJoWJD6xjFk7+ZknRnErkyWn
         /t4O1sQxQGL8W4kU9mCHtj6mfEloD1Uy03n8w894=
Date:   Tue, 16 Aug 2022 14:21:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 5.15 000/779] 5.15.61-rc1 review
Message-ID: <YvuLvVXks7JnGPSo@kroah.com>
References: <20220815180337.130757997@linuxfoundation.org>
 <CA+G9fYuXHvYQkWnDac6T8s9XnP_jctCbV=yEx3Z9EhWko2dPPg@mail.gmail.com>
 <20220816084703.nbciiu63x4dgulwc@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220816084703.nbciiu63x4dgulwc@pali>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 10:47:03AM +0200, Pali Rohár wrote:
> On Tuesday 16 August 2022 14:11:45 Naresh Kamboju wrote:
> > On Mon, 15 Aug 2022 at 23:44, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.15.61 release.
> > > There are 779 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 17 Aug 2022 18:01:29 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.61-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > The powerpc defconfig failed on stable-rc 5.15.
> > 
> > * powerpc, build
> >   - gcc-10-ppc6xx_defconfig
> >   - gcc-11-ppc6xx_defconfig
> >   - gcc-8-ppc6xx_defconfig
> >   - gcc-9-ppc6xx_defconfig
> > 
> > arch/powerpc/sysdev/fsl_pci.c: In function 'fsl_add_bridge':
> > arch/powerpc/sysdev/fsl_pci.c:601:39: error:
> > 'PCI_CLASS_BRIDGE_PCI_NORMAL' undeclared (first use in this function);
> > did you mean 'PCI_CLASS_BRIDGE_PCI'?
> >   601 |                         class_code |= PCI_CLASS_BRIDGE_PCI_NORMAL << 8;
> >       |                                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> >       |                                       PCI_CLASS_BRIDGE_PCI
> > arch/powerpc/sysdev/fsl_pci.c:601:39: note: each undeclared identifier
> > is reported only once for each function it appears in
> > make[3]: *** [scripts/Makefile.build:289: arch/powerpc/sysdev/fsl_pci.o] Error 1
> 
> Hello, this is probably because of missing PCI_CLASS_BRIDGE_PCI_NORMAL
> define which was added in this change:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/diff/include/linux/pci_ids.h?id=904b10fb189cc15376e9bfce1ef0282e68b0b004

I've taken that portion of the commit in the tree now, thanks.

greg k-h
