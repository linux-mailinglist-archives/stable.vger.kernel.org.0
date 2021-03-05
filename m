Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3FE32F1C6
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 18:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhCERva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 12:51:30 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1169 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhCERvM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 12:51:12 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60426f900000>; Fri, 05 Mar 2021 09:51:12 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 5 Mar
 2021 17:51:12 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 5 Mar 2021 17:51:12 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.11 000/104] 5.11.4-rc1 review
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6831ce864b9249c69fac4828b545bdb0@HQMAIL111.nvidia.com>
Date:   Fri, 5 Mar 2021 17:51:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614966672; bh=uTRv2JHZapN4sbPnu6KF8ZRpXwQMs5V/tRcL/HZSRuo=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=OYP1RKzgV3DXphr36BZXu5JLHgDrLuaOJAWMVQvrgOJdppzvTRRULl4FJ2oGDga5E
         48/ajUwpnzfy9Fk7xu9hrTp6HMq5nRKOZKHGET2CKNMUlxrzKIgMuf8Gng4pgOTZQx
         TDM+kNMvQtD9FtXLixQx8g05YOWqCtPzAyuhXKSU/KiYnLAWcgunKE8p2lBYVHpQwU
         /WajApXQbtapD63IvijBpRkU529VY2S3AS8cs4itqnxx5yD0C/PqF5iQB3WK6KwbMK
         i8ybw9CCm6DBmSkXuh2WyIbA1ALiHdpg4ULuabsardfjX3NtcOfNiQr3Fswd25wHIl
         KO2bEVBesKunA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 05 Mar 2021 13:20:05 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.4 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.11:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    65 tests:	65 pass, 0 fail

Linux version:	5.11.4-rc1-gf598f183ed0a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
