Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41EED453387
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 15:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237000AbhKPOFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 09:05:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:35980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236984AbhKPOFu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 09:05:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD42861BF5;
        Tue, 16 Nov 2021 14:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637071373;
        bh=i1PyKtc/WMNy+30MKeIuCcVD/sibXDMyViISlxKZz8s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t9QFlSiAPU51qaEMz+RH7/ta9C6TuiCjQLFYowmf/C8ePjn3lwMKT4oscE8xdwgcO
         YeQrj0AK/mqn0lxkz/UQDTfFbobeP/HFNFHdhRXW0AgROW6bwsgiOnzsp20FWHX8Ma
         yr+MLiKupFQASA5GoPwuAZJUW3a9e+AZkZ7KvQ6k=
Date:   Tue, 16 Nov 2021 15:02:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.14 000/849] 5.14.19-rc1 review
Message-ID: <YZO6C1fxSP7dgCUb@kroah.com>
References: <20211115165419.961798833@linuxfoundation.org>
 <8805071f-e696-c2b1-05dc-c13b00bb95e1@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8805071f-e696-c2b1-05dc-c13b00bb95e1@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 01:39:37PM +0000, Jon Hunter wrote:
> Hi Greg,
> 
> On 15/11/2021 16:51, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.14.19 release.
> > There are 849 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 17 Nov 2021 16:52:23 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.19-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> > Pseudo-Shortlog of commits:
> 
> ...
> 
> > Mikko Perttunen <mperttunen@nvidia.com>
> >      reset: tegra-bpmp: Handle errors in BPMP response
> 
> 
> The above is causing a regression for HDA audio on Tegra. Please can you
> drop this from stable for now until we get this sorted out.

Already dropped.  I'll be pushing out some -rc2 releases soon as there's
been a number of changes for all of these trees.

thanks,

greg k-h
