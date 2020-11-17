Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E282B6E14
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 20:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgKQTJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 14:09:30 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13304 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbgKQTJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 14:09:29 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb41fed0000>; Tue, 17 Nov 2020 11:09:33 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Nov
 2020 19:09:29 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 17 Nov 2020 19:09:29 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/151] 5.4.78-rc1 review
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <81a0aa89828f4af9956d6d5dcb479ec0@HQMAIL109.nvidia.com>
Date:   Tue, 17 Nov 2020 19:09:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605640173; bh=y9iRdsPrQXaz1cWKUO99HRnr7n3quZNseOfauZhzJ1M=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=A9ATIOauc1p6EdB9qr1u5ibbQQIvV83mEYeq2P6tKmD5sjcrL2MVN6hRiyQy3hEmE
         4gGFv64gLvWKGEpsKenVKih0XB5r13jZljoU7+QZheDQK0MaNC3e0viVK8KJCSs+nl
         JbKTXRgGJ52DavsnKt0oWZjDTT2vPO6BLq3T1Gkj/ZoWVYg6n8sj57/xCv1WCJ40dw
         DkMjLK64iZthcwBQVWxZ3J0VWpzcuHSXFLvuCZmO0QSg4LVJsZkpR1GsPhfCUE0pVm
         QBO1cJRFq8wPJUq6gbCvT9l3r0plo4RYs28z1VUp4r3Uoo5jcZkN4r6VrPYAwWtPmw
         czyX+UuJUgkgg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 17 Nov 2020 14:03:50 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.78 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Nov 2020 12:20:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.78-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    15 builds:	15 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.78-rc1-ga3746663c347
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
