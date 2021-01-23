Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA148301462
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 10:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbhAWJ4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 04:56:02 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5540 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbhAWJz4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 04:55:56 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600bf2820003>; Sat, 23 Jan 2021 01:55:14 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 23 Jan
 2021 09:55:14 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Sat, 23 Jan 2021 09:55:13 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/29] 4.4.253-rc2 review
In-Reply-To: <20210122160822.198606273@linuxfoundation.org>
References: <20210122160822.198606273@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <679c82bb70ff45f5a61526dc86edb828@HQMAIL101.nvidia.com>
Date:   Sat, 23 Jan 2021 09:55:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611395714; bh=LpuyTk/6jxJRt9lG/YI8jNle3wN3y1SHNeobk4rNySA=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=hkU6w8/ddgQhYDlv5AEigmi9QKsKCO0+SJdufAxpMKeC0S82bwWTnjy5eS7Ti2VHK
         i/VRWTuZ50DvYG5aGYNQCIbOWLrgAgaKmCtK2qg+ZyTmgDLQKK9UpgCz/7y3LSAO9W
         AXv0y3LOlNiR+Y5h7ECkk1xrIqn7qLLbQQbRR5zal/fsSpMjKgTEhdMkWElPEtGSxT
         sF49LHLL4iBwHFDPYMt+PZ4itAtnW+GblTIfcfoohu0wxmly7gtD5iZ3uZqlkjumAI
         B2Gpp13TOavM20UO75YcImKdhab15SvKMIllSKHMZz3pukv3BnNQjd7z4l2C39XNhp
         S1CmWqJBepEzQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 22 Jan 2021 17:09:19 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.253 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Jan 2021 16:08:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.253-rc2.gz
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

Linux version:	4.4.253-rc2-g36175a29c09c
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
