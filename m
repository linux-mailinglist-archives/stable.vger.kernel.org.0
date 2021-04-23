Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE5A3695BE
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 17:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbhDWPMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 11:12:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230294AbhDWPMS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 11:12:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 785D8611C2;
        Fri, 23 Apr 2021 15:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619190701;
        bh=wexHp2v7gGzu5q484ZfGvVhyFvGiwG4gWVQmW++Ze9Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I/4gp4NJzGkrxLMEiLGIxza8hJpT425GZ2yF8nff5YZItyAuDbtCDWk7sWuHbmeZ1
         dyIZKaJ/4/uoIiIo3SAMIFoXeAcbWbRTGoovGthFrwhCDXvkaDpMJYA0F+q7eiIwxu
         vholPNVkZyoWSbZJm21fMtyHNFvCCfZeiKIANcSI=
Date:   Fri, 23 Apr 2021 17:11:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/103] 5.10.32-rc1 review
Message-ID: <YILjq1AAUicdA/1l@kroah.com>
References: <20210419130527.791982064@linuxfoundation.org>
 <dcf6134c-9a67-cc1d-c8bc-75178557296b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dcf6134c-9a67-cc1d-c8bc-75178557296b@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 19, 2021 at 02:07:38PM -0700, Florian Fainelli wrote:
> 
> 
> On 4/19/2021 6:05 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.32 release.
> > There are 103 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.32-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:
> 
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>
> -- 
> Florian

Thanks for testing and letting me know.

greg k-h

