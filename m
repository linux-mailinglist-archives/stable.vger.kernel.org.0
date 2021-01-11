Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732352F19C9
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 16:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730658AbhAKPeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 10:34:03 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:17349 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730596AbhAKPeD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 10:34:03 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffc6fc20009>; Mon, 11 Jan 2021 07:33:22 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 11 Jan
 2021 15:33:22 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 11 Jan 2021 15:33:22 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/92] 5.4.89-rc1 review
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <be6fd259ad8e4115bcdea91f5585a383@HQMAIL105.nvidia.com>
Date:   Mon, 11 Jan 2021 15:33:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610379202; bh=gID5tSR07xcOpvVfD1OEgLLCJ8XfVWCZMZumkflSIao=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=pdld/PILN1n2nydEQvMPpUKHS1IZGHo2352ZaXFQ4pvZVOw9mmPgZ9hsQ4m3Non6Z
         Xhf0JLly2b4TL7YN257HmW8LZMYHusfXXjSuSwHNpQnqFpV/yZG90M+iH2VZJkws+y
         Qnv+EWskF53zhxPPWa/8I/X8ST55K7vfI9+EVX9Ep7O+mVxcZGwamxMYDs3fsSuagg
         /nL4T1B313LVtLQz8x78XEiHjpyEJlLzRaTs15fzvido7n743JH5X4kfDnIgmEfWir
         NKHLa9GLRu7MXTF9LZa611AZrAOuFy5EM5r4RelSlG/cjxXEgQJZlsI/4NxSC1hrEZ
         cS19E32Q3xxsA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Jan 2021 14:01:04 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.89 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jan 2021 13:00:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.89-rc1.gz
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

Linux version:	5.4.89-rc1-gcdbc5a73c7f4
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
