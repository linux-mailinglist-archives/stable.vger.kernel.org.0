Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017A42D695F
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 22:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393968AbgLJVFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 16:05:47 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5096 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393945AbgLJVFm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 16:05:42 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd28d740000>; Thu, 10 Dec 2020 13:04:52 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 10 Dec
 2020 21:04:52 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 10 Dec 2020 21:04:52 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/39] 4.19.163-rc1 review
In-Reply-To: <20201210142602.272595094@linuxfoundation.org>
References: <20201210142602.272595094@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c221eebbc60543a7a05dafeb55792c8f@HQMAIL109.nvidia.com>
Date:   Thu, 10 Dec 2020 21:04:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607634293; bh=vRdnI0Q0wEuD1dPYMfMIkq5IhXV9QSW7CWDJ5I2xCFE=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=amfx9JI438JXuAG9D0qo3jkXE1AFVqSIiBIMZ3bmGZPOLIoLzX7SQE27QxT25YLc3
         aw4VD/ZWXghfRHDYMqdyYTXOGLQ0tWgUOpOHGiFN4QDN4JpK161/qV++eERBUs9l4c
         zw/JTeXocQ6KCycOP6A7gfLvNHs2gcrLDNnmN327JRrUfhcb5aA4TeEe5nyb188mGj
         ZZ1TrZ5+AvPYcRoJzbtO9BC0RFBbVD+c9pN6LMqAecKFYawuVqtPuuXmSTQ0H3EEWh
         DCtSXDvLGjaQXBcjgeMxTJoKjZyc88701EehTWBMPzRQd1PfExh/JKnBMuJIQLVaWL
         YbSlC7rbD1TXw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 10 Dec 2020 15:26:39 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.163 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Dec 2020 14:25:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.163-rc1.gz
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

Linux version:	4.19.163-rc1-ga1b1c60de6b9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
