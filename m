Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4D729D978
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 23:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389718AbgJ1Wyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:54:50 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:16473 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389711AbgJ1Wyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 18:54:46 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f99c6a20000>; Wed, 28 Oct 2020 12:29:38 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 28 Oct
 2020 19:29:34 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 28 Oct 2020 19:29:34 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/264] 4.19.153-rc1 review
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <4df1955a86a94ebfb6ef8451bf75f57f@HQMAIL105.nvidia.com>
Date:   Wed, 28 Oct 2020 19:29:34 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603913378; bh=C3GTybsBopaTeKN6PjLOFYbGJ2BKk9Lvc0uvQ3b5/8c=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=h/RpJarZf55+iT0V6NeVpKpg0RQ7KIHxI+Xbu0Gn/qv80Cb3C0IZQhzCtp61sol3A
         AeQm6TdXizIPs9TOeQo96MW/tYd59cKJq8KVXdXEpkX0H/PBAJJXW/5C79LMiLY+Mp
         0wRhh5uwIDJWoGW3jlGA4LYmv8raEmuNv0ALMLF+yquP649ErcP5Qe26iId2dKH80r
         Oth3aL1SLZCzwbdEuztfrOuege5jFcCNUJ89+XvDgF6+S7OAa0LLlRTpzu0diKOsAp
         zcbV7gqZzLikvXat6hZPFqYcJIj6SOzjlrmqrmXDDNRsEwt2sJ7iocvVY0EDZk9aup
         2sQvYVo1Tk7qA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Oct 2020 14:50:58 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.153 release.
> There are 264 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Oct 2020 13:53:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.153-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    15 builds:	15 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	4.19.153-rc1-g8919185062d4
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
