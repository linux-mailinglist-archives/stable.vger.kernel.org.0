Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A8A2D696C
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 22:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393881AbgLJVGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 16:06:55 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17118 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392154AbgLJVGz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 16:06:55 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd28dc60008>; Thu, 10 Dec 2020 13:06:14 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 10 Dec
 2020 21:06:14 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 10 Dec 2020 21:06:14 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/39] 4.4.248-rc1 review
In-Reply-To: <20201210142600.887734129@linuxfoundation.org>
References: <20201210142600.887734129@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6e21ffd9ff0f4f83a688bad902e28fd6@HQMAIL111.nvidia.com>
Date:   Thu, 10 Dec 2020 21:06:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607634374; bh=HPT7yPVL9eagZUw6hylbH1kKZw4TqKW46zYRxCPaJK0=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=NA/sw30qdGMp2WWJP9CPop027J2ZsrTqsiCzaM97kuXjcd40cf5iKcOr1tvCUeOWu
         xlsncWcF4QyGx52mJgBDKjlRX1Tg5gcXKVT4FWDxS+sY7vqHuFSdYoxISusmLY5op5
         eHWERIPJble4S2qds7Ni708qR/iuZhWe0rG/iAaktaE2Pm52oOmHDD8w4m8aHWnb+3
         rGqS8Fziq15GxaD/k5zNWvmhyLmG/8tptmSWVqsmDcdrmEIz0W5u6tuGCcCKFoOvcH
         aE2SjMvy2Xd4KZQ4t3P1UX9eLF4OK1LNF7j39I6SWJPeb/FIUdWsciwinhfgNIej5X
         NoaK1wcP6aGfQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 10 Dec 2020 15:26:11 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.248 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Dec 2020 14:25:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.248-rc1.gz
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
    25 tests:	25 pass, 0 fail

Linux version:	4.4.248-rc1-g122526e6e784
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
