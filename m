Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1991F322BAC
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 14:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbhBWNso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 08:48:44 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:14311 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbhBWNsn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 08:48:43 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603507920003>; Tue, 23 Feb 2021 05:48:02 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Feb
 2021 13:48:02 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 23 Feb 2021 13:48:02 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/50] 4.19.177-rc1 review
In-Reply-To: <20210222121019.925481519@linuxfoundation.org>
References: <20210222121019.925481519@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f4c2928bfb484d18a7bd8b0f03704024@HQMAIL111.nvidia.com>
Date:   Tue, 23 Feb 2021 13:48:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614088083; bh=287xmrnB+gY9roZMmmvHXUNMCrtweoqoJfCmSR7XMyA=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=a9SFmHvrpvgP8q0ZOp+6/NNjC3KL/6mZZojKpPYesu4s3OYpe23LoMLnXhrsj400l
         c6FdJx1jwudlPPVFgcWa+F92NpWBv/NfjrhUlLh88nmPj90szhYDbHqf+P7ENo3RkO
         Y/NLa3RlVjqT8Dd/BJ+AsmFl6eM54dZvSQFOZvt2bm09fSXbbo5jGGP9g5XDw8DtcN
         YwtQdcbUJF/Uafjqi9QsW3R+WKBz45nFPer6LLNksrKKd5LRsBkvObpLFBuj914eVQ
         5gfJroNyU4ro449K8dQlm7xJ+7amqqJPuWCN8DnQWwkPhldNBNvEiCMtUaaNbhX8R3
         jLLklLSEKi/+w==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Feb 2021 13:12:51 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.177 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.177-rc1.gz
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

Linux version:	4.19.177-rc1-g413fa3cdbf28
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
