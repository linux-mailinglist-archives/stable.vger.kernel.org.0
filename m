Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F7C303D04
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 13:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404333AbhAZM3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 07:29:39 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14436 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404375AbhAZKtJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 05:49:09 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600ff36e0002>; Tue, 26 Jan 2021 02:48:14 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 10:48:14 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 26 Jan 2021 10:48:14 +0000
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
Message-ID: <05cc6f906dc349fe91fc6a48f3c934bd@HQMAIL107.nvidia.com>
Date:   Tue, 26 Jan 2021 10:48:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611658094; bh=9yGdReLerh2zqQ1FvOcamaF4eb/F7yVwPGzy5Rlo/dE=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=eqLUuAgIg+XvRc9LpS78tgDjadi6vOm13luB5SA+Pn3he8VfI1cKfFTuoChZ0eedG
         PBc1ivXzull4KM3/xay1BKBbxCB/deTU94HkG5tmia6FdvBwOI7CkKjy9Go/JvA1Wm
         8miZWUdlpJv291IWU55Z2w5SKPy5lCqaoQDF4Srksz3UKKVuocCgfloMInNlWiTIH2
         uUxE3mcjgZFk3HNtX++edT9GcZfB9Xg5uADSyaQvhvWx0Hz5JV9L9BFN3w5pYiagds
         Gktw+YWX/avRfMAefINPGnuav2ICgZExE1Ias2pgWx+H1p7wjU53QhQVCuMncYvqD8
         iBR1QfAXsd/FA==
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
