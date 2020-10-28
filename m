Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D561D29D476
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 22:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgJ1VwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 17:52:18 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12039 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728025AbgJ1VwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 17:52:17 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f99c68b0000>; Wed, 28 Oct 2020 12:29:15 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 28 Oct
 2020 19:29:35 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 28 Oct 2020 19:29:35 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 000/139] 4.9.241-rc1 review
In-Reply-To: <20201027134902.130312227@linuxfoundation.org>
References: <20201027134902.130312227@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7b2a57a88c414dc9ad768677907e3671@HQMAIL105.nvidia.com>
Date:   Wed, 28 Oct 2020 19:29:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603913355; bh=zuBOEKOIxBOIo5Ntq95iJAzkvIxei5tK6Nbd0DUMBIw=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=hN3ABikBDBSLcVco779pyOCf3b65Bhtpam9nqWTZgpt9V5/FAl7Z1Uo3+5BKdAVxs
         xEal52trBbMilYQJv7+uuCrwvvvJ999hhKay+9GrxJpbGPQC/i4YBuZ+woylkZnqRe
         TCju3TVatcLh7UIFIaiR/q4lmPcyTCeYCcvr246azfYX9kFsV84Xh+U7T0tzG1svIW
         iZiiBOJXjVw/67vvZ3YzYMlH0xsGhPHoLbCctCVpNZ+sJR7id9s5ZzRVr8Ba2077YZ
         uZrW1SfEJ3WDzR3hKPmNCeMxvsBXTiwYWlySSuQRIblKDtVdkngbwgSy2fOTYAmS+H
         PJPg7s2yH8Rdg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Oct 2020 14:48:14 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.241 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Oct 2020 13:48:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.241-rc1.gz
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

Linux version:	4.9.241-rc1-g97bfc73b33b5
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
