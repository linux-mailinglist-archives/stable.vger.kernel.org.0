Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC8DAB385F
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 12:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbfIPKlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 06:41:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfIPKlT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Sep 2019 06:41:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2520206A4;
        Mon, 16 Sep 2019 10:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568630478;
        bh=KZCQFQ2jWJ/yM+MIITapXWtt+47ECo1VTLcix6k4Nvc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SZH+na1YyykUuJgCsqGUcW7LUbXDW3DBipaW12vp+oOzP/QLLkMUo7CidPwo28DMU
         q4jM98ZuEZAl/FBHMpLqtcmTyHZwtc812rZIcgFnFglNXls/WmTCh7wrYM25zB3UQQ
         MdRvZ17q0UZkCnJ8oQbLrjV3dZ0B/PtVSYbw4nhY=
Date:   Mon, 16 Sep 2019 12:41:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.2 00/37] 5.2.15-stable review
Message-ID: <20190916104115.GA1386544@kroah.com>
References: <20190913130510.727515099@linuxfoundation.org>
 <8ee066b8-ec21-ef87-dbb7-0c2328f93e6d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ee066b8-ec21-ef87-dbb7-0c2328f93e6d@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 16, 2019 at 10:25:33AM +0100, Jon Hunter wrote:
> 
> On 13/09/2019 14:07, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.15 release.
> > There are 37 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun 15 Sep 2019 01:03:32 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.15-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v5.2:
>     12 builds:	12 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	38 pass, 0 fail
> 
> Linux version:	5.2.15-rc2-g4a69042627aa
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04

Thanks for testing all of these and letting me know.

greg k-h
