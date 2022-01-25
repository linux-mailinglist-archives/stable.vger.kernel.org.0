Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50EC949B806
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 16:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349297AbiAYPxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 10:53:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344218AbiAYPvJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 10:51:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551A8C06175E;
        Tue, 25 Jan 2022 07:51:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5C7661714;
        Tue, 25 Jan 2022 15:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89EBBC340E0;
        Tue, 25 Jan 2022 15:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643125867;
        bh=lqaNa2pfwB8IZWQDz+uXS8piYRMBUthGf9Esoh4gpBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KReubvvf80sqg+5GGymWHSGUyKPxT+YLMRinp/RSp6rs84Q1PvubMYKgkESdKoavp
         MjgqMro47o1fAVQ0tBObWTyq5Ck6h6pdMXSXbw2OWCoVUycg0C2MQWGTHP9wAqWJ9y
         7uJfJwYvMEDHcqGHkXXhA/jHyNqPRawrPxI89YiQ=
Date:   Tue, 25 Jan 2022 16:51:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Helge Deller <deller@gmx.de>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        John David Anglin <dave.anglin@bell.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org,
        Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH 5.4 000/320] 5.4.174-rc1 review
Message-ID: <YfAcaFaYlB0FUHMn@kroah.com>
References: <20220124183953.750177707@linuxfoundation.org>
 <e2c9b01d-0500-645f-b4cc-f8dcb769996e@linaro.org>
 <CA+G9fYsvgQyUNBnySuiOrAXRrh4_ZAnqygZ0A5y7pGO5vrXAYA@mail.gmail.com>
 <YfANvxrigpCy5spk@p100>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfANvxrigpCy5spk@p100>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 03:48:31PM +0100, Helge Deller wrote:
> * Naresh Kamboju <naresh.kamboju@linaro.org>:
> > > On 1/24/22 12:39, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.4.174 release.
> > > > There are 320 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.174-rc1.gz
> > > > or in the git tree and branch at:
> > > >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> >
> > [...]
> >
> > This is from PA-RISC with gcc-8, gcc-9, gcc-10, gcc-11:
> >
> > >    /builds/linux/drivers/parisc/sba_iommu.c: In function 'sba_io_pdir_entry':
> > >    /builds/linux/arch/parisc/include/asm/special_insns.h:11:3: error: expected ':' or ')' before 'ASM_EXCEPTIONTABLE_ENTRY'
> > >       ASM_EXCEPTIONTABLE_ENTRY(8b, 9b) \
> > >       ^~~~~~~~~~~~~~~~~~~~~~~~
> >
> > Bisection of the latter points to "parisc: Fix lpa and lpa_user defines".
> >
> > commit 73c8c7ecdc141c20c9dbc8f3ec176e233942b0d9
> > parisc: Fix lpa and lpa_user defines
> >     [ commit db19c6f1a2a353cc8dec35b4789733a3cf6e2838 upstream ]
> 
> Naresh, thanks for noticing and bisecting!
> 
> The problem is, that in v5.4.x we are missing to include a header file
> which is probably already indirectly included in the other Linux versions.
> 
> Greg, can you either drop this commit:
> 
>    commit 73c8c7ecdc141c20c9dbc8f3ec176e233942b0d9
>    parisc: Fix lpa and lpa_user defines
> 
> or simply add the patch below to the commit?
> 
> Either solution which is easier for you is ok.

I've just dropped it now, thanks.

greg k-h
