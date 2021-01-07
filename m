Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98FD82EE6B4
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 21:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbhAGUVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 15:21:11 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9909 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbhAGUVL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 15:21:11 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff76d0e0006>; Thu, 07 Jan 2021 12:20:30 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 7 Jan
 2021 20:20:30 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 7 Jan 2021 20:20:30 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/13] 5.4.88-rc1 review
In-Reply-To: <20210107143049.929352526@linuxfoundation.org>
References: <20210107143049.929352526@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <332a7663ef5f4891b7a14c9859d69133@HQMAIL107.nvidia.com>
Date:   Thu, 7 Jan 2021 20:20:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610050830; bh=omv+gKMSP5vE49WgXfKrzS/Hfl5kdGIoRIuFfZU2QyQ=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=m/wuCf/zucn02U0hf3w+e7mBRl4aO1N4Ga6b+E2CKP2vKqk7cwPZiqFB1RSZZ1Yom
         tCxhdPRP+SeVdEQqGis8OgcJCxUkMbg5K+y+jBvQpw+b/TjdbIjhyi6dv/iuUZbRlY
         P4cHtVCoYsFiL54+a5iZ1g37PtStir6FjFyBXad7w0ysMKxYtaxwuHbK8iFrcaWNQ5
         dUQdQ1/YmBgIV/6VizzzramIJ8lI4FEfLq1m1SjFH8EjH3uDOXo27BRgpHyf94q8gu
         zRKJ1Q4XLX49oPTAoK7Nm4+RZXT0SPkGKZxkTSF2HpOOG51PyU1hk78S6ZWZls9tfF
         PiYRbAgNB3y+w==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 07 Jan 2021 15:33:19 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.88 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.88-rc1.gz
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

Linux version:	5.4.88-rc1-gf52a40401ee9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
