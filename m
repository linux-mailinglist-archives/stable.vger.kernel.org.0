Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE762F19C5
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 16:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730584AbhAKPeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 10:34:02 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2120 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730445AbhAKPeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 10:34:02 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffc6fc10000>; Mon, 11 Jan 2021 07:33:21 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 11 Jan
 2021 15:33:21 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 11 Jan 2021 15:33:21 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/57] 4.14.215-rc1 review
In-Reply-To: <20210111130033.715773309@linuxfoundation.org>
References: <20210111130033.715773309@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0cdc94200cda409185f7c571b2698a95@HQMAIL111.nvidia.com>
Date:   Mon, 11 Jan 2021 15:33:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610379201; bh=Ng244ksU39a+VncMn8ENNfjQxwiTH6Dg6jivbYfBFJM=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=he7qJL5Fy5RC0w2pzfN08H/pJMEO2qA2BNc+EiSL0mzi2hETtl5DceT9mBgpid/gd
         SPnr8Ao+kn8fdx2++CW85t8G41H9wcnhaHXbzFX648UUJT82kB2/X6uMbUdS8C3kUB
         XN3N5DIKAN1DCvG9DTS0z11I4TS1HBhAlUrXcaGEvZNqe0bseZSpJkC3SmlZ+w9rYp
         gBsKA9iwDgJz+sl37/FforrYcI7cGUnBeklDXvk9hvy4glpBW2kNJm55JyyW1r+KWY
         9vPxdrzWMMmikroPYZQtSvJg1uflP9vz/AhHkoxfpVHM8nEhapTo7xGrrKwNDJQ4Nr
         i1Xv8zjh/Znpg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Jan 2021 14:01:19 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.215 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jan 2021 13:00:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.215-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.14.215-rc1-ge3be7c59d3c1
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
