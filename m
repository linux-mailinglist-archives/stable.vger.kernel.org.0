Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3CF32F1C8
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 18:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhCERva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 12:51:30 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3081 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhCERvM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 12:51:12 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60426f900000>; Fri, 05 Mar 2021 09:51:12 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 5 Mar
 2021 17:51:11 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 5 Mar 2021 17:51:11 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/72] 5.4.103-rc1 review
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
References: <20210305120857.341630346@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <a920a1953039491a8c24a8f821143d61@HQMAIL109.nvidia.com>
Date:   Fri, 5 Mar 2021 17:51:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614966672; bh=HEoV5paFguMXHoVypwYZLCsQpzuoyuj87VL11i1yUpk=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=LzXeXAYU01/id16O9arsfcR/R+yiqvgKSFS/DXU/hcQJvOP6uYcH2XWhzag2Suikf
         DtJQRWPdBHwQN89D5rMjB5bkKDtywckknb+Pr87z0zmY6DKBX8/fqCsOus6Lm6j/mj
         QGQIixo+58odvu2mFkTK2xjlPhexCoJHM+bRXzfshysnhEFnPJU1i4M7mH+p0XGl1Z
         VeoAog2roygFSY2WRcwC5fLnBLiBuP2NWgM19jtAZXhj8KV+9rjzCaIFiwBPqsiLtu
         xvkfktyYCzt2JyBDT47niADRgTzVG6HJKrnBIxD6mxjZl5V/fwuyhrVe7FQpMEO3fn
         hWjaXgwFduJHg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 05 Mar 2021 13:21:02 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.103 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.103-rc1.gz
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
    57 tests:	57 pass, 0 fail

Linux version:	5.4.103-rc1-g2e10dba9fe0e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
