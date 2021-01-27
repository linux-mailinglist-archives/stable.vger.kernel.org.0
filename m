Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8803057E4
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 11:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235667AbhA0KJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 05:09:57 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:1168 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235443AbhA0KIE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 05:08:04 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60113b5b0000>; Wed, 27 Jan 2021 02:07:23 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 Jan
 2021 10:07:23 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 27 Jan 2021 10:07:22 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/58] 4.19.171-rc1 review
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <3890010f73eb4e3fa52bd25a79050a74@HQMAIL109.nvidia.com>
Date:   Wed, 27 Jan 2021 10:07:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611742043; bh=Z+sYgp4JerJvKKheLYzEc41PsibRASefPB9kZA08P+U=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=ZHW30nWn+cBCYgk+XCpqgMAJzuxBrVfmMz2iOv7t1114zd3Tsyb7qLbGrnGF1ILRk
         6LjeYSnvh98rth3hcG1Z/gn4JKy96m/W19I/Ml4ecn6uanE6Q66Rq2SWhHRt0Zy3n0
         DJ2RiwJlLphSGDrOQ6zaYFWeIplgIH+Fb5JdULsVzhRO5QwZAChUx/zhOD8Sj0OgLe
         j0osVSiMd081kgvvyiq36ZGIpGBOHV3H13YeGvM31Mnpmd5GjtUoD0QHMcxJRMQdov
         Nn+smlRhbzaQTghIlAwVz4FKzwakJVD4Up6QB42u4pY0zEHDIXA1NGZeOhLPOvg1Cy
         XPbsKS2NBI5Fg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 25 Jan 2021 19:39:01 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.171 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Jan 2021 18:31:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.171-rc1.gz
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

Linux version:	4.19.171-rc1-g9b9e817bbee7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
