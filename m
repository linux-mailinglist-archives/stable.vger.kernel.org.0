Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2BD1FD2D2
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 18:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgFQQvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 12:51:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726597AbgFQQvo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 12:51:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E19A220897;
        Wed, 17 Jun 2020 16:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592412703;
        bh=yJIMgYmxE2b021HNjLcZ5z539vezI9aKTyvm8qWgNZ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cldD3ElD8yqoB76E4PyeMP7F89GQLxHb0bzpP4BRLOSM2q7MkRU/jGZPSLhPDV6PN
         reHpz1KbRt+UwiyRS8ii7eEDQlLJF1pr6q6QGK25H6y6mjkzCgssKuow5mU8kMutAo
         arEspLenHqyJUAiJ3Gnn4XNYqz7YnEzeEsiwcAgA=
Date:   Wed, 17 Jun 2020 18:51:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.7 000/162] 5.7.3-rc2 review
Message-ID: <20200617165136.GA3794995@kroah.com>
References: <20200616172615.453746383@linuxfoundation.org>
 <77015800-d0a2-38f7-e70a-e6dcbc6325f9@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77015800-d0a2-38f7-e70a-e6dcbc6325f9@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 16, 2020 at 09:21:09PM +0100, Jon Hunter wrote:
> 
> On 16/06/2020 18:27, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.7.3 release.
> > There are 162 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 18 Jun 2020 17:25:43 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.3-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.7:
>     11 builds:	11 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     56 tests:	56 pass, 0 fail
> 
> Linux version:	5.7.3-rc2-g55b987cbccd9
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 

Thanks for testing all of these and letting me know.

greg k-h
