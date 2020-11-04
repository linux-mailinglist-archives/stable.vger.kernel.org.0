Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75E42A6009
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 10:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgKDJE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 04:04:26 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13071 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728258AbgKDJDr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 04:03:47 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa26e760000>; Wed, 04 Nov 2020 01:03:50 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 4 Nov
 2020 09:03:46 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 4 Nov 2020 09:03:46 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.9 000/391] 5.9.4-rc1 review
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <4796280b881e4246a6ad2ae268744c37@HQMAIL105.nvidia.com>
Date:   Wed, 4 Nov 2020 09:03:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604480630; bh=0KQdPyrEimHWfurTkSQRPVbheq4kQh2x6yge2jj+NxM=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=iIgTv0GBHyc3/QQVvmUL5k6IZB+ceIyLIqNKorjYF9M4laA7KrpOiw2mGB70a+rma
         2JrTsmTFSShC94ThGW9aPYMAM/4KfR4k7bZnohAgimShf3Vzc/RbAGr+V8iOw9QNUV
         3M8ThdpUzdlalP7YVpb8NuoLhsm6EA3YoodaRgLrV21gbTTue4iHK5OgwBPy7uyKq6
         9EamwxsXp1wq1HqbzvaIPQ7diU6okVqHRI78NQLO7Xdoj479TmcGxQA9CxpXhJhYzp
         D5Re+bWWFgrvw6eVgTd0z7S2UyWubBbiVSIpyh8n9YOD63WeZY6tE+Ane+/330pclr
         cxkZdOuEmldMg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 03 Nov 2020 21:30:51 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.4 release.
> There are 391 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Nov 2020 20:29:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.9:
    15 builds:	15 pass, 0 fail
    26 boots:	26 pass, 0 fail
    61 tests:	61 pass, 0 fail

Linux version:	5.9.4-rc1-g53574a4c558e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
