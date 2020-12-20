Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40CB2DF57A
	for <lists+stable@lfdr.de>; Sun, 20 Dec 2020 14:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbgLTNTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Dec 2020 08:19:21 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3418 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726991AbgLTNTU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Dec 2020 08:19:20 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fdf4f2f0000>; Sun, 20 Dec 2020 05:18:39 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 20 Dec
 2020 13:18:39 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Sun, 20 Dec 2020 13:18:39 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/34] 5.4.85-rc1 review
In-Reply-To: <20201219125341.384025953@linuxfoundation.org>
References: <20201219125341.384025953@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <8c6b37a10d8f4cf8ae8d4488732291f0@HQMAIL107.nvidia.com>
Date:   Sun, 20 Dec 2020 13:18:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608470319; bh=PmK+TEz/tS5K8Ss00Mf+4ihnig9Jwk84qbFH7MFnvZg=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=pDeBasLH3PxU7ybZNHPlHE/E3IdtMzTqyxyVB2XhJ+W3quqfRP7FwPY/znJBxAYIw
         3OyyD5pK2aPX7THsVn4mBBWgJUBzBTc23MEsmW0kkXWa+QgOX8D/+DPxOgbxwzI7BQ
         T6fdLWzGeQN9fRUhkr7hELjJ5+9GbLOrIvUAw7bj22Kvgv1O7VhmNcB1AMSurAgwzl
         g3iqCKi3PfQwMiK9nSAIwRU1/+k2xV7fd2yvLWaznd+Dudf8bSCvMh3Lkdn8a0j2mt
         U6XKTne5eRUqIwK0OEjMOiICmwZ5jNxIxlOsYt8ZxdMshZYeDf/LF6vC7K5eeO1Gew
         sHa5Ayct/8EUA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 19 Dec 2020 14:02:57 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.85 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 21 Dec 2020 12:53:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.85-rc1.gz
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

Linux version:	5.4.85-rc1-gbcf35e05a526
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
