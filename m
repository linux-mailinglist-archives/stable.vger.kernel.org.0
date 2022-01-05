Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882B648551F
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 15:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241156AbiAEO4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 09:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241148AbiAEO4N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 09:56:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E709C03401F;
        Wed,  5 Jan 2022 06:56:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45493B81B43;
        Wed,  5 Jan 2022 14:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303F4C36AE0;
        Wed,  5 Jan 2022 14:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641394570;
        bh=3mdwlycZw7pKMKWIAB/yKocSgLCRCferWtCbJSfHIbE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ASHjY5qXizy4dfTSyI2GbdrJj+nfN/9fcOYlbCu+e5Slg51QEB8prbIH1PY5fv/uJ
         KfmM7JxPwu+r8np08Vik9sIpkTVPDdUjT2FyjkXUEVKHLPtM5nte7GCNHpxsBH9Tat
         pfu0AicMVEmBz/vpfmUt2vG137U2S+BP8akEtNWw=
Date:   Wed, 5 Jan 2022 15:56:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 00/72] 5.15.13-rc2 review
Message-ID: <YdWxh/OR0dQDeS9E@kroah.com>
References: <20220104073845.629257314@linuxfoundation.org>
 <54461ffb9ebe34e673e6730f3e9cc94218ad2f49.camel@rajagiritech.edu.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54461ffb9ebe34e673e6730f3e9cc94218ad2f49.camel@rajagiritech.edu.in>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 05, 2022 at 06:32:43PM +0530, Jeffrin Jose T wrote:
> On Tue, 2022-01-04 at 08:41 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.13 release.
> > There are 72 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 06 Jan 2022 07:38:29 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> >         
> > https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.13-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> > stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
>  hello,
> 
> There was a compilation error....
> 
> -----------x--------------x------------------x--
> MODPOST vmlinux.symvers
>   MODINFO modules.builtin.modinfo
>   GEN     modules.builtin
> BTF: .tmp_vmlinux.btf: pahole (pahole) is not available
> Failed to generate BTF for vmlinux
> Try to disable CONFIG_DEBUG_INFO_BTF
> make: *** [Makefile:1183: vmlinux] Error 1

Is this a regression?  If so, what commit caused this?

> i did CONFIG_DEBUG_INFO_BTF=n  in .config and then compilation was
> success.

Or you can install pahole, right?  That's a requirement for that build
option I think.

thanks,

greg k-h
