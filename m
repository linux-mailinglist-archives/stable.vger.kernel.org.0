Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8690A322CD3
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 15:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233072AbhBWOum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 09:50:42 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8734 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbhBWOuf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 09:50:35 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603516120000>; Tue, 23 Feb 2021 06:49:54 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Feb
 2021 14:49:53 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 23 Feb 2021 14:49:53 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/29] 5.10.18-rc1 review
In-Reply-To: <20210222121019.444399883@linuxfoundation.org>
References: <20210222121019.444399883@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <cf54c3f403cb4355bac81437c44d34a0@HQMAIL107.nvidia.com>
Date:   Tue, 23 Feb 2021 14:49:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614091794; bh=T9G4a3+yG6stubVyrutT2Y5z2rlBOSkx0HgnhiBoIIs=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=d3O16bfWwQgUiysicREdrL+66aPpsMB5S6nHRf5K/LRlWmyjJyO22iXAaKX/xng+6
         tS6riI79kQ7mFjuQrDqg/tYfon6pvgmZn1OrQt1AnvZzfM57jTMIza8ugT1N+jz0hb
         8yzu0iqA8cJe8h8Xn9cc3T/kubN1HwOUa/ryTdCI/L4//T3JGddSdIQ7yGGYfMRRD5
         3eH5cRd8xSgGe0pstcUNeKMgyCnBZ2UL2tDJOfOdAf5+49WLQn0pLMjDK2Mo4yjASa
         PV7S8q8tPTkFS/noHm1bfA5CeMR9JPbk1yeEOUy5H7ayb/JbKtSn+G66utICT+8UE5
         e81rwUlGGRSDA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Feb 2021 13:12:54 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.18 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.18-rc1.gz
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
    65 tests:	65 pass, 0 fail

Linux version:	5.10.18-rc1-g905cc0ddef72
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
