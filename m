Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5993649B694
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 15:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1579802AbiAYOj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 09:39:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389251AbiAYOfO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 09:35:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63CCC061756;
        Tue, 25 Jan 2022 06:34:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54677615B4;
        Tue, 25 Jan 2022 14:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04018C340E0;
        Tue, 25 Jan 2022 14:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643121279;
        bh=1DQnWgHZJKj5ukHqGYmPdLyxXLH9Wa25z3VPX1fMJC8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kuAIhNpBlHeJepM6g0GgkQjv6J5Qlik6/db2hAuO6vQuTisg77AROUkzA0ld2TXc9
         oJ+9Skhu+UuT2p5yXaRSpEzyUoooIz4rB+O8zMU2KMZZPZFst40ja4/N27TgP2yG1I
         DUbp3yyMXwt34UsMCPdmGJ9SGi+Nz2nWuhYhYt/A=
Date:   Tue, 25 Jan 2022 15:34:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/157] 4.9.298-rc1 review
Message-ID: <YfAKfTtZqb7EIm3T@kroah.com>
References: <20220124183932.787526760@linuxfoundation.org>
 <CA+G9fYvzftL7cWFysem9z4AMKFXMRShy6-Ewp74ckP1xeaBCAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvzftL7cWFysem9z4AMKFXMRShy6-Ewp74ckP1xeaBCAA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 06:24:39PM +0530, Naresh Kamboju wrote:
> On Tue, 25 Jan 2022 at 00:24, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.9.298 release.
> > There are 157 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.298-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> same as 4.14 build error.
> stable-rc 4.9 build failed.
> arm (imx_v6_v7_defconfig) with gcc-8, gcc-9, gcc-10 and gcc-11 - FAILED
> 
>  > Lucas Stach <l.stach@pengutronix.de>
>  >     drm/etnaviv: limit submit sizes
> 
> drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c: In function
> 'etnaviv_ioctl_gem_submit':
> drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c:329:37: error: 'struct
> drm_etnaviv_gem_submit' has no member named 'nr_pmrs'; did you mean
> 'nr_bos'?
>       args->nr_bos > SZ_64K || args->nr_pmrs > 128) {
>                                      ^~~~~~~
>                                      nr_bos
> make[5]: *** [scripts/Makefile.build:307:
> drivers/gpu/drm/etnaviv/etnaviv_gem_submit.o] Error 1
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks, already dropped.

greg k-h
