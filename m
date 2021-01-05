Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33312EA988
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 12:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbhAELJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 06:09:10 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4798 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727764AbhAELJJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 06:09:09 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff448ad0000>; Tue, 05 Jan 2021 03:08:29 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 5 Jan
 2021 11:08:28 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 5 Jan 2021 11:08:28 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/29] 4.19.165-rc2 review
In-Reply-To: <20210105090818.518271884@linuxfoundation.org>
References: <20210105090818.518271884@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <edfc33725b9c477b9999d74f3004fcbc@HQMAIL105.nvidia.com>
Date:   Tue, 5 Jan 2021 11:08:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609844909; bh=N5NRamjfxzye9bfEe3q8TbLIZl7pAQoQd9yfQq19vUM=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=Swl4mJ7Mp5dPEDAMfBAOthDbnjfDQfQU4WlrieReXH8vqnjhn28ku5e741Wc3v0tk
         koDgNdyIJHTbbLV/lFAD1hpysXfgkR00YBce0bSEZppnM4SBw1Ay7Mca7+r+QUu5py
         WKWcKu1lROG6cUqalkyV+CDTx6DGvFLWqDEBhh2z9InOH/xrEi0sFoeiLQd8OMPjXu
         hF24P4nwhormwIr1kreGxcsl5RFkh1/DxDFaIuoxFcXpQFKEM9bXofOnXmb2pDoF+T
         sp/FxDTyQStlHIOyZ3LuxmpU37EiMXg5T2s0zo1MMSpREr/1DenLTvIhMUZN8VDOlC
         vpi91Pgv8LUdw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 05 Jan 2021 10:28:46 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.165 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jan 2021 09:08:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.165-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	4.19.165-rc2-g40a2b34effd3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
