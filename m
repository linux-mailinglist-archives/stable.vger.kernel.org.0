Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D60B2E9F56
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 22:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbhADVKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 16:10:17 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:7770 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbhADVKR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 16:10:17 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff384100000>; Mon, 04 Jan 2021 13:09:36 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 Jan
 2021 21:09:36 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 4 Jan 2021 21:09:36 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/63] 5.10.5-rc1 review
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c0b77eb92f3640d3a1007209c0af3ccb@HQMAIL109.nvidia.com>
Date:   Mon, 4 Jan 2021 21:09:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609794576; bh=L6yg/j57FbzGryXJC08+rwAVM/Ps64MWu4v8WL+1u6E=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=KGTEb5y46Ba/Ygcr9RHZ7CS0RpPgJRu/lALbfw8wvwFLTFlZqjuo8nanUbR6bRsp0
         ljHVOUxvTgLMNaLveOewQVt6hFAPEs1vlIQdMSLVJnlyx1Age4LrRniqGU+oCN3qa+
         arkyQdZGDf1AohJtahGeums8VQuzIfKb++JRp8/+coiyI6AeK0w5CnNAqn+ZhzbPwj
         RwDrvEjYD/AjpuKOKeA/r9HA/yA+0JE2IiKwDoTdDIaLRrDyYXbMQO2H/tpwCJHOqc
         i2iBh4P79EPHqZirYbV6Id+cZiWRIleb0K6KnBnZf8BILAXQiLX7l+kJgVhAEBg3sp
         ShXhkXmr+JRKg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 04 Jan 2021 16:56:53 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.5 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Jan 2021 15:56:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    64 tests:	64 pass, 0 fail

Linux version:	5.10.5-rc1-g18347c4f0781
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
