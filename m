Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D166B2F808E
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 17:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbhAOQU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 11:20:27 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10231 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbhAOQU0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 11:20:26 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6001c0a20000>; Fri, 15 Jan 2021 08:19:46 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 15 Jan
 2021 16:19:45 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 15 Jan 2021 16:19:45 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/18] 4.4.252-rc1 review
In-Reply-To: <20210115121955.112329537@linuxfoundation.org>
References: <20210115121955.112329537@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <43ada088d31d4620911970330a1d071d@HQMAIL109.nvidia.com>
Date:   Fri, 15 Jan 2021 16:19:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610727586; bh=y/sGGtHPAJhlmVx1MyFRiKplFL8Tmam5ceULh+pUfIQ=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=hlm4kk00dn8dyHF9vroaddonvJb1N5r6wB3DM4su4PyoT00aEV1OorWy7XZmdXcMa
         D02CoX71J8Ii8PbA3dv6SHzDNiZ/y4UKATy+aTlilCJ5/0RZBNvCGu4PULqfuxGW8L
         MtNeDGchs6VZOUtJc3m0FRs81y01kBfH8bqboZNpv0i+QkWRCyDUcjEOQ+SZTmBiC1
         9TSb57P3PbHP1PCEMr1acmww0rQVEcWzMwOWVAxVB1B2wQph/7Rm5f+0SSa4tp0K7R
         N84qKHXInvWLpk849MzCzJseQkEuv58TlnZW+I90K23pqj5eZq8VaQIIlL8w0bV9XO
         F3XUH/gHa/7tg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 15 Jan 2021 13:27:28 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.252 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.252-rc1.gz
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

Linux version:	4.4.252-rc1-gbca740d5a2a1
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
