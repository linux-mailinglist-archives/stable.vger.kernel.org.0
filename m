Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9725232BC39
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383282AbhCCNqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:46:04 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14292 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357407AbhCCKtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 05:49:45 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603f569f0000>; Wed, 03 Mar 2021 01:27:59 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 3 Mar
 2021 09:27:59 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 3 Mar 2021 09:27:59 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/246] 4.19.178-rc4 review
In-Reply-To: <20210302192550.512870321@linuxfoundation.org>
References: <20210302192550.512870321@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <1d172bcc33f44475b8c6737e9b58c439@HQMAIL107.nvidia.com>
Date:   Wed, 3 Mar 2021 09:27:59 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614763679; bh=WSPAOAhI7MISTKlyRoXww2Q4ACNNdWBOpDqCGsXhlzw=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=Fu4tDpD2ReKrS1RPpcfol0SWdTXU5GDtevYZSpdRM6gvSVQamCyuWgWUQZnvYU2N9
         9a+koNsNPxGQOS9/VqLIVZ0jNWmeXYTVj+PWAl68BXxHM03bjUOD6aH+vy0nyQU8hu
         t3tXIWp1v/l7zIUQXp9r+vISXHoKPHMMyTh+7HlPFzIElmTx1GhDfuoGhYOcsyeVXu
         rw9PCctRrR8ajYqtWQpxgS2aKDhzDXBdYucbcs890lK14AvScuCXby4NACIJxPe16d
         kTJI8wuJqZmgB5A/wABWPkHex0REUBQR6eUsfM5dABEQUgv/CthAnWP1Pm/Nm7eZBX
         W9qSdTL9VMZQA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 02 Mar 2021 20:28:20 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.178 release.
> There are 246 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.178-rc4.gz
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

Linux version:	4.19.178-rc4-g26e47b79f5ec
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
