Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B346632CF9B
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 10:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237443AbhCDJ10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 04:27:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:44782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235321AbhCDJ1W (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 04:27:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAFAA60230;
        Thu,  4 Mar 2021 09:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614850002;
        bh=Di34rcAItgxIKwuN+0FDjI2roNL7uVmzSNg4wqjcyLc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gISDi5JyH/Ud+CvoZxvQ+gYGtLLF1do/evROU1kzVJczKAPjT1TGZiwGVpoOhOCFQ
         RVWzdDzggJVjjoZuelxCQCoqTy208sbQuaoATIPmKOO6oNEomQORmdX9T0nOgbkMhJ
         dnVhoWBb1ugOT1hAv/2v7L+NaVm27Hbsud080J0k=
Date:   Thu, 4 Mar 2021 10:26:39 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hanjun Guo <guohanjun@huawei.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/340] 5.4.102-rc1 review
Message-ID: <YECnz8ceaBAk3Opa@kroah.com>
References: <20210301161048.294656001@linuxfoundation.org>
 <c689884d-6418-98ff-f535-da022ba527f7@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c689884d-6418-98ff-f535-da022ba527f7@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 03, 2021 at 04:11:09PM +0800, Hanjun Guo wrote:
> On 2021/3/2 0:09, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.102 release.
> > There are 340 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 03 Mar 2021 16:09:49 +0000.
> > Anything received after that time might be too late.
> 
> Tested on arm64 and x86 for 5.4.102-rc4+,
> 
> arm64:
> --------------------------------------------------------------------
> Testcase Result Summary:
> total_num: 4716
> succeed_num: 4716
> failed_num: 0
> timeout_num: 0
> 
> x86 (No kernel failures)
> --------------------------------------------------------------------
> Testcase Result Summary:
> total_num: 4716
> succeed_num: 4715
> failed_num: 1
> timeout_num: 0
> 
> Tested-by: Hulk Robot <hulkci@huawei.com>

Thanks for testing some of these releases and letting me know.

greg k-h
