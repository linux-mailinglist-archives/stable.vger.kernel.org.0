Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580092E6BAD
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 00:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729485AbgL1Wzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 17:55:50 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12408 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729487AbgL1VJC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 16:09:02 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fea49460000>; Mon, 28 Dec 2020 13:08:22 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 28 Dec
 2020 21:08:22 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 28 Dec 2020 21:08:22 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 000/132] 4.4.249-rc1 review
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <3bbc3c18df4b40ec91bad960445e5fce@HQMAIL107.nvidia.com>
Date:   Mon, 28 Dec 2020 21:08:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609189702; bh=fxhLPIwM4YCLKjVzzzLsAVn97JiJGaoCaeScnnWCwyc=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=ELPsPghXJnWKQPKuGvQZxSDpNCXjiww2O0NerNrndDhJM9tcnTj/d7ZT6034UKe85
         6dH45Qpz4wDnRE/qI0bIBWGCPZl+2X3QSqN7KsaWzroT/w36SOx519ZCMDtrdTEveM
         Tv/NJPW9fAYhfddrjqgbRnl/QGfd/lB8zSbW09nrHhD1hbSEgVwXV5430YKKsAl2Wq
         DGFMXsvCEr/blHPyIjNbN6zwps9Xy8M2mjJ51qUyUTFpPF0KZiABk26c4Jexeck7bJ
         ayzzkzmnghDVFoxhZPgIQl7s3kWKaElyGpN82Py38I00j7+8oshYmN50o34Ixap5uS
         fhA+z+5+rLuKA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Dec 2020 13:48:04 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.249 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Dec 2020 12:48:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.249-rc1.gz
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

Linux version:	4.4.249-rc1-g45f5fd21658c
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
