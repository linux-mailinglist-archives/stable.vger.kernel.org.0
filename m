Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBE0322BAB
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 14:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhBWNsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 08:48:31 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:14260 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbhBWNsa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 08:48:30 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603507850000>; Tue, 23 Feb 2021 05:47:49 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Feb
 2021 13:47:49 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 23 Feb 2021 13:47:49 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/57] 4.14.222-rc1 review
In-Reply-To: <20210222121027.174911182@linuxfoundation.org>
References: <20210222121027.174911182@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <4896932579674071b4c0d308c47ac440@HQMAIL111.nvidia.com>
Date:   Tue, 23 Feb 2021 13:47:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614088070; bh=HLHmsK+pLpQuDBBf8vSttViufYcxveU7B6LJMHVdyo0=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=VAem63usy4semBDiBxg+YOz7G6Q0Uy2hKJR6dz0acvERr13qvXRZaHkP/jtRQz+PO
         ftPOzyMlj7853jH6ATIYajFs6GMvYCOcerk3SDJl3bWlyx+tNV64UhOppiJ1Pje1l4
         Xassl/oDG4rjtFq//uSz1RDUhT01zTYGZch0lCG515MWjpTOY5mqCcNfSHBkJLhSnB
         OibsjvLdcMIRblqv/1LEmwTxEYVXVSoRKOBl9/8qIFOdDPn5HZ1WRGMHbGy0Ji7FRF
         ES7LELwt/4+MKkiUf4+ygq/RaxCwuKPdDjjfTMYLdI/8dU5Aqztx/gtV/5EoYxc/Vo
         KAf9GtCTyOt4w==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Feb 2021 13:35:26 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.222 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.222-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.14.222-rc1-g5d849f076141
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
