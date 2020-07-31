Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6B6234646
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 14:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730695AbgGaMwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 08:52:38 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1951 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbgGaMwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jul 2020 08:52:38 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f2414080001>; Fri, 31 Jul 2020 05:52:24 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 31 Jul 2020 05:52:37 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 31 Jul 2020 05:52:37 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 31 Jul
 2020 12:52:37 +0000
Received: from [127.0.1.1] (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 31 Jul 2020 12:52:34 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/17] 4.19.136-rc1 review
In-Reply-To: <20200730074420.449233408@linuxfoundation.org>
References: <20200730074420.449233408@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <567f30667e4a4aeab8cd7f4d0309abfe@HQMAIL105.nvidia.com>
Date:   Fri, 31 Jul 2020 12:52:34 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1596199944; bh=1UoM/iwDNgtl4Wmu329WrXnOYEtJeijaLT+4ZXhWoIQ=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=ebiSmm1bRNQrbzjtBocrv+Bu29MwDyuYr18hh2UvHdN5cH9wMmMCFc6IuwCnuE7Pl
         x/rQWwRw5+eLS5PzFmEDgElRziX8u0mdgc1c+JhRyQkWVkDhfElIhOSu7NnQ9kgyGR
         IV7VZ29uJCcEKS42KiPTApx9Ksaj3HzodwTh3wk6EyXCYZ6FaZBBOvDe1qsWrpz/YJ
         MWQVC8O34hUPu1TIZ9CybYUQjEnWAvrj2GuPTMccIwzraziQ50IbapJCFWFm2ov/so
         gRHKgMWDRVTICus9JkeSe7ODUnLFwX8tR3Xkzs995BoFOSSJts+3xN7CxT8q3nTi6a
         dcvkOZSVSh3zA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 30 Jul 2020 10:04:26 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.136 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Aug 2020 07:44:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.136-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    11 builds:	11 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	4.19.136-rc1-g62c048b85133
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Jon
