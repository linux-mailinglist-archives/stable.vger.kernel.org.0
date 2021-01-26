Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1AA303ABC
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 11:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731577AbhAZKtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 05:49:25 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14476 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404372AbhAZKtK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 05:49:10 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600ff37d0003>; Tue, 26 Jan 2021 02:48:29 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 10:47:44 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 26 Jan 2021 10:47:44 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/86] 5.4.93-rc1 review
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <4456fcb266434d6296d2b69d3b8ea392@HQMAIL111.nvidia.com>
Date:   Tue, 26 Jan 2021 10:47:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611658109; bh=9yGdReLerh2zqQ1FvOcamaF4eb/F7yVwPGzy5Rlo/dE=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=HmSmxhNFt0S0dz7wWVcmGsKi73xz8/lTXOu7GLk7BDKg1TFY1DP6YNW8Sy74AlzlF
         ld4Cdnf0y0X1YzvgZ91OqiCO4t570vaMkyygd2cjwF8u2UdE+KGOcrnAmZ9sxnodC9
         Jne5r4G/bSz+yA1pTQHDTeorKQqJncWWknX+45hzo5nIzbF6m7v3NDddJGBlS6BY5o
         3nmrGL34ED9hBJ+WrPrZMP+MtNUm9iLOlbc+wZF02eXgL2NhGZ4qElT0Etv64cj1rc
         tmom/+1qBIlQVzpXBCTDRFUwl/2k7erd7E91bTlfseVIE3m20KzC5OHRZK4YjLg5Qj
         VRQcGTK+vkV/Q==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 25 Jan 2021 19:38:42 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.93 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Jan 2021 18:31:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.93-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.93-rc1-g3deaa28e41d9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
