Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3F32CA419
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 14:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389856AbgLANmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 08:42:14 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18896 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387752AbgLANmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 08:42:14 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc6480e0001>; Tue, 01 Dec 2020 05:41:34 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Dec
 2020 13:41:33 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 1 Dec 2020 13:41:33 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/24] 4.4.247-rc1 review
In-Reply-To: <20201201084637.754785180@linuxfoundation.org>
References: <20201201084637.754785180@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6367aa9eee1e412db6cce28c873ebced@HQMAIL111.nvidia.com>
Date:   Tue, 1 Dec 2020 13:41:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606830094; bh=BBf+hZb0BzWkdHI592uruwXY3++uWIhDhfJe9od1Kg8=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=b1c15gMj7lqSgvkO3pX2p3mzM9UdbMrHI5kGFBZuPzlWq3JzZ2+RXD8xFmIwpLlB1
         SkJ1JCqoxsHUlEsOqocwH8CxykiQf2g49wc4tq+24H5whLYXrS837764IofQOYG486
         8rxS71VZ9mu3sGq3VCL9SovPPYIgTsGovCgLPP03O97y8S3DwoiuEqTW7x9SXdmXDt
         y1H5xkBeljzumgLb5O6xeFyluSQL8s183XUoLMQtmret4BCyXk72WCMw/pxq3NedrO
         f4k92Tz1Kj3OMc3ydfwF/ZKLE65NNqqR+V1IY8AZUoAwL8Jg1aBsC9pyj5hPLvuhBU
         orX+cO14PAP+w==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 01 Dec 2020 09:53:06 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.247 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 03 Dec 2020 08:46:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.247-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    25 tests:	25 pass, 0 fail

Linux version:	4.4.247-rc1-g412881df37c2
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
