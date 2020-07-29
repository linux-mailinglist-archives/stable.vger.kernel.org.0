Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1E4231B23
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 10:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgG2IWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 04:22:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgG2IWn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jul 2020 04:22:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4ACBF206D4;
        Wed, 29 Jul 2020 08:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596010962;
        bh=tXBTHxTrjeaNwrHl2lRRCFNppBO0POfp8G+RESBPgJY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bIkKMDlaa7WxgaW2wIu//ShNYA/4V7B5gwp0Ee7bcdsIdJSemX1QsL9K7fREnvb2K
         K0BYLhBaeMIYFn1doeRvjDiy6xRNNDv38eTpgvcL/f7kdMNcJOM0q2atptu5oSt9+3
         inWXhBIL/XX7YGLtUeC91qf7fBG6oEqQ8uOZAE20=
Date:   Wed, 29 Jul 2020 10:22:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thierry Reding <treding@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.7 000/179] 5.7.11-rc1 review
Message-ID: <20200729082234.GD529870@kroah.com>
References: <20200727134932.659499757@linuxfoundation.org>
 <8bd52f5eab274431925b82ee9c5f13c5@HQMAIL105.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd52f5eab274431925b82ee9c5f13c5@HQMAIL105.nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27, 2020 at 02:47:09PM +0000, Thierry Reding wrote:
> On Mon, 27 Jul 2020 16:02:55 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.7.11 release.
> > There are 179 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 29 Jul 2020 13:48:51 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.11-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v5.7:
>     11 builds:	11 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     56 tests:	56 pass, 0 fail
> 
> Linux version:	5.7.11-rc1-g5e6331d4c49c
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04

Thanks for testing all of these and letting me know.

greg k-h
