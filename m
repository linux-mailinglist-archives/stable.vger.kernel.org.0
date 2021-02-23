Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFEE322BA9
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 14:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbhBWNsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 08:48:14 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17615 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbhBWNsM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 08:48:12 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603507740000>; Tue, 23 Feb 2021 05:47:32 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Feb
 2021 13:47:31 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 23 Feb 2021 13:47:31 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/49] 4.9.258-rc1 review
In-Reply-To: <20210222121022.546148341@linuxfoundation.org>
References: <20210222121022.546148341@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d11773ace6114bc9ac06c913033528ce@HQMAIL105.nvidia.com>
Date:   Tue, 23 Feb 2021 13:47:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614088052; bh=0FNU92JtLWbly/i9XDgEsudkZkCBWhzSszrIMIbgsks=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=N7Yafty7zwQ5JEQvJssbzUpY72nDmXr/ouzmAncrGniCv2gVrJppuGsG9hv+7rYJE
         t4t2hDllU2iXCYKSOPaQcvlbQaDzVCb1vYhISK/vXY8/9N+J1OA/Vx7Q7grHN2UNJ0
         ui3pXyiQByETY4ICb0U0l22uouOX2d1uLU7rU75sm26FwSd/Jg+15zbq8aDvZgqPdr
         arBkaxFQQIBbBmlHktadb9J3Va/yiENiWADrMVULOJbUIfUWfDFxKfYR7RXmPTH3Ft
         +zfs55PUO8HNwBgo5OrkIw0ZbE6kmiHZaFF00C8ZwyBcWDMBkHk2VonMWUBH/84xCG
         cX17+3B9nb2qA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Feb 2021 13:35:58 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.258 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.258-rc1.gz
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

Linux version:	4.9.258-rc1-gf0cf73f13b39
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
