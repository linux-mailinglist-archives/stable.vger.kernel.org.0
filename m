Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B47A0EDD2E
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 11:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbfKDK7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 05:59:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:46912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727663AbfKDK7N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 05:59:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5306221D71;
        Mon,  4 Nov 2019 10:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572865152;
        bh=HUdxCMu6xBUopH6EcbPDSSLqXUxI0M4SppvWvEPfEqs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kJ5Hj/mtkdgzOR3bdrfZhnnr5sFiwZWuPbBF16OhIo0gKg4uerNuOVtWt8Cj4gLZH
         ZFSxzpbAoI37D8a5ZCXnZuXjrlNSvw/SA4sjK9XgRsluGY2ZyMFB8JxZo4LD+ZsDyZ
         5BdL1nCchdXhk772IsIrWEtUDPU+hnGmQHwNaObE=
Date:   Mon, 4 Nov 2019 11:59:10 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hanjun Guo <guohanjun@huawei.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Hanjun Guo <hanjun.guo@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, suzuki.poulose@arm.com,
        catalin.marinas@arm.com, john.garry@huawei.com,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        zhangshaokun@hisilicon.com, lkft-triage@lists.linaro.org,
        andrew.murray@arm.com, will@kernel.org,
        Dave P Martin <Dave.Martin@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: stable-rc-4.19: cpufeature.c:909:21: error: 'MIDR_HISI_TSV110'
 undeclared
Message-ID: <20191104105910.GB1945210@kroah.com>
References: <CA+G9fYtoODTuayzXdsv=bFuRPvw1-+dmZxHqQePy6LX8ixOG5A@mail.gmail.com>
 <98f10e13-8ec8-1690-a867-f212bcea969f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98f10e13-8ec8-1690-a867-f212bcea969f@huawei.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 04, 2019 at 09:10:06AM +0800, Hanjun Guo wrote:
> Hi Sasha, Greg,
> 
> On 2019/11/4 7:22, Naresh Kamboju wrote:
> > stable rc 4.19  branch build broken for arm64 with the below error log,
> > 
> > Build error log,
> > arch/arm64/kernel/cpufeature.c: In function 'unmap_kernel_at_el0':
> > arch/arm64/kernel/cpufeature.c:909:21: error: 'MIDR_HISI_TSV110'
> > undeclared (first use in this function); did you mean
> > 'GICR_ISACTIVER0'?
> >   MIDR_ALL_VERSIONS(MIDR_HISI_TSV110),
> >                     ^
> > arch/arm64/include/asm/cputype.h:141:12: note: in definition of macro
> > 'MIDR_RANGE'
> >   .model = m,     \
> >            ^
> > arch/arm64/kernel/cpufeature.c:909:3: note: in expansion of macro
> > 'MIDR_ALL_VERSIONS'
> >   MIDR_ALL_VERSIONS(MIDR_HISI_TSV110),
> >   ^~~~~~~~~~~~~~~~~
> > arch/arm64/kernel/cpufeature.c:909:21: note: each undeclared
> > identifier is reported only once for each function it appears in
> >   MIDR_ALL_VERSIONS(MIDR_HISI_TSV110),
> >                     ^
> > arch/arm64/include/asm/cputype.h:141:12: note: in definition of macro
> > 'MIDR_RANGE'
> >   .model = m,     \
> >            ^
> > arch/arm64/kernel/cpufeature.c:909:3: note: in expansion of macro
> > 'MIDR_ALL_VERSIONS'
> >   MIDR_ALL_VERSIONS(MIDR_HISI_TSV110),
> 
> Patch "efd00c7 arm64: Add MIDR encoding for HiSilicon Taishan CPUs" needs to
> be bacported as well, would you like me to do that, or just cherry-pick by yourself?

I need the backport please, cherry-pick fails :(

thanks,

greg k-h
