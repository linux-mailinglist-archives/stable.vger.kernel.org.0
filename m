Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE2E30CCD3
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240490AbhBBUKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 15:10:03 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:2891 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240482AbhBBUJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 15:09:30 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6019b1440000>; Tue, 02 Feb 2021 12:08:36 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 20:08:36 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 2 Feb 2021 20:08:36 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/28] 4.4.255-rc1 review
In-Reply-To: <20210202132941.180062901@linuxfoundation.org>
References: <20210202132941.180062901@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <9364b5ba5046422dbc9c7d2065ddc5b5@HQMAIL101.nvidia.com>
Date:   Tue, 2 Feb 2021 20:08:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612296516; bh=usknG7dUwwVPKkg88Usk/dUVm2mqQy2rFCFNkAU+vmM=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=L7iT+dNWjfAbGS437qgeH1XXwwIoNUGshkXRh+c34DUcnij9s51gdQ9ut5GSFyRVW
         xCmRgJHvBWicVqYoGTp4NBMu5qmE/E0+HUT3QFSd3f7ifydcjysNUOMyIimoe8xatP
         G8pzhGyGb+E8JDrLnAPt6AJdlhITk2PCob2KIXz3bnySk3eK5dOkIz/cIrWRf/1zpz
         lJY30/lgFTzXjnffsKA5LwPwqtisIZVEDIDj+oddCdZFXTlIQ+BEfgq7mmA203RV20
         XipYiNfkaXK8CHkLoKUhjrTehbITEFRSv6bNFneoKRQ2dX37dW6xnyExlqmy0W0+V7
         2AOyogvvfefdw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 02 Feb 2021 14:38:20 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.255 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.255-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    28 tests:	28 pass, 0 fail

Linux version:	4.4.255-rc1-g9c98a187325d
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
