Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE962B6E15
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 20:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgKQTJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 14:09:30 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17773 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgKQTJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 14:09:30 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb41fe10003>; Tue, 17 Nov 2020 11:09:21 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Nov
 2020 19:09:30 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 17 Nov 2020 19:09:30 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/101] 4.19.158-rc1 review
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <a405214817c945528105081e1c2101b9@HQMAIL101.nvidia.com>
Date:   Tue, 17 Nov 2020 19:09:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605640161; bh=hhOEv3JaadQrQ1bbkv0eW3qbsrkTWSAXoETuN+JEwOw=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=qTlVAeU1dQ8TOf1TKlmY017PhCk9W4CNIoEp8LjIyjpxwSR1s6RKDueUgYcNLWQBE
         b6zPSjRNvEHBMfnVazCNwjPY+UbjBsFENRBZ/1puDOCh7K/gtwTYTloAFXvTlMhRrV
         SiABIb5v98BgLWcemy18jjzN5V91N6w9BCj+Dz7pQ+MhMB2svjFq05VUp501Yw0ClF
         qh0P+632T9hFZlzFccDUBTNOPeKAYYNfiX8FkKF63YPcj7R2wqw5AM2WRbguc91cur
         M87Cy3d1EfbjiB0mjSJcS+ynulQuwC7OpaLahU8D/zTFv7XbKN9rjp5vZvhd8pbkWB
         o3cR1aj4rPMyA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 17 Nov 2020 14:04:27 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.158 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Nov 2020 12:20:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.158-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    15 builds:	15 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	4.19.158-rc1-g1d674327c1b7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
