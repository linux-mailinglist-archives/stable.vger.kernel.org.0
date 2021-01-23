Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAFF230168B
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 17:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbhAWQCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 11:02:45 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10504 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbhAWQCp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 11:02:45 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600bf2870000>; Sat, 23 Jan 2021 01:55:24 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 23 Jan
 2021 09:55:14 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Sat, 23 Jan 2021 09:55:14 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/33] 4.9.253-rc2 review
In-Reply-To: <20210122160829.171484729@linuxfoundation.org>
References: <20210122160829.171484729@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <95dc35c59ecf4bddae80cd88b8442175@HQMAIL101.nvidia.com>
Date:   Sat, 23 Jan 2021 09:55:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611414143; bh=5TOh4xo986atqNcrh/u8w6QbnefXbQ4RtzOP35i7pOg=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=FZwrfib1LsjiG2VTbsVwmEkbDosTxJrweFKTyf5FVaXq9bUhNitminy77K41LLPcH
         VREGCxg6W8soJCqthGbBaRLSDpXmynfeqRT14BPcChoTzftbmp513ffmBJ8MzL4uH2
         7rEGMFL9kRYGBsx3JZVhcsXwc8J+57ALtw38aEi5iPlwjakIrt+0KRSSbV3bRyva+D
         8uMGMFS6YQ1tjS8i4488JlSzBddkzxnjNoFfwZ2mkQKJnfd4E+sGjXoa4+jNtkFgqP
         xmkKTX6mBiphavs0iamj+D1Paaruz/5YsWuHyjbYNCxk/aoKVAGvXPJnXfLhtk95qH
         8IZcGn4vHOBKw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 22 Jan 2021 17:09:41 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.253 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Jan 2021 16:08:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.253-rc2.gz
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

Linux version:	4.9.253-rc2-ga4108af7f0fa
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
