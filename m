Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5969E32B1DB
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232707AbhCCAtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:49:33 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15423 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449403AbhCBQqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 11:46:48 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603e6b860001>; Tue, 02 Mar 2021 08:44:54 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Mar
 2021 16:44:53 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 2 Mar 2021 16:44:53 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/247] 4.19.178-rc3 review
In-Reply-To: <20210302122300.309814713@linuxfoundation.org>
References: <20210302122300.309814713@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <9bb6f58dbc84417e8a4ab6d86255c137@HQMAIL109.nvidia.com>
Date:   Tue, 2 Mar 2021 16:44:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614703494; bh=3Px6ZUFWvMNAXaApbcGwzXz6xzQW3W5X4bpZqtFH+yc=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=aJ3nW0IWNrhStcmnsMMErpnX/0qNNByshaG4lhAd5/bk5qo39x8uI3+EoX3eZYfKL
         Y51abez74Jqxc+fe/EnSh5PWSIKZ5qtMOn6b2fjigILwlLwZR2u3m9SGJQ/3kyHLwV
         HCS67DfHTC2LSBzwdectt15VJ04zHhfj4BLvpb9GfBWMX/zD3sB0wnIM4wGDTpNQKh
         ekPBGUEMfH6zxAeKqZSts7nKXO02v9BzvlOdQ5yfLVHju3fjHPOEw4DlZQKU3J3135
         5PRQfBjjLlQPFzDicjfwk0n0lTOFuBKPKN13LA4sm4FJGdy/SmuDg27V3kaxEQ0LtN
         /pGmq+qk8C3iA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 02 Mar 2021 13:27:00 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.178 release.
> There are 247 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Mar 2021 12:22:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.178-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	4.19.178-rc3-gbe9fac34eff6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
