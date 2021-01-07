Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82BE72EE6B8
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 21:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbhAGUVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 15:21:13 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:19581 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbhAGUVN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 15:21:13 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff76d110000>; Thu, 07 Jan 2021 12:20:33 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 7 Jan
 2021 20:20:33 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 7 Jan 2021 20:20:33 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/33] 4.9.250-rc2 review
In-Reply-To: <20210107143053.692614974@linuxfoundation.org>
References: <20210107143053.692614974@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <20c479e435414defb36ae98016d39728@HQMAIL107.nvidia.com>
Date:   Thu, 7 Jan 2021 20:20:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610050833; bh=TxPygfraQp4UBzWlaR0bcTWh8GvLeeW6n4xvAJH7QJw=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=nb6JQ8AcR4HHy/jISBQjiKOt9lGABl+27/6nfGPFMPl90fNhsJjaM0Rm6i1LwOUVw
         SPdiwb/kmweBE6F2blZGIRakym1KfFL4/8HylAWv13QAQM9+x9rBywPkw3jEWNO5Ys
         xW92cWDR3glFoGZN0EQBS1vQt7Dy9LC1xoNylDhpBmzBdG8/6P53Jc0LY/glhFX/y+
         EeWACzFTjzeeIfXmMPOYgkpNVRrW1nzSl8J3Ekws++M39dv6/z8uFx3rZbj4Mb/tkY
         GwU07zunvpJUJ5d9sjlSVCVcfqLQghmCLVP/fJkYCyHM5iQZZRUvne3y9lPypvBGZU
         8VXf4KQOkBLgQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 07 Jan 2021 15:31:33 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.250 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.250-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.9.250-rc2-g15b2e80c9e2b
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
