Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F5630168D
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 17:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbhAWQDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 11:03:06 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10513 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbhAWQDF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 11:03:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600bf28c0000>; Sat, 23 Jan 2021 01:55:29 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 23 Jan
 2021 09:55:15 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Sat, 23 Jan 2021 09:55:15 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/48] 4.14.217-rc2 review
In-Reply-To: <20210122160828.128883527@linuxfoundation.org>
References: <20210122160828.128883527@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <657f66a12589437ab346a93c283e7eb2@HQMAIL107.nvidia.com>
Date:   Sat, 23 Jan 2021 09:55:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611414143; bh=LRZICLR4KuakosHi5zoeBSHI8h0J651LZ8OseDHvCnA=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=e2kJf/tg3vxahb6Yr9Kup3JvsIVxnfX7GydTizFfvxV3aVi640GofkoRyB3yYCx8z
         b9g8/GReP7sf4Sdy6IzJO5KW3I/NXmiV77R+mVPPE33LZsS0Y8cr456Kl+wapjn6M+
         6v2o7Q5jM6/6sQOyDBziX+jknQM5MvSdPf3mJdjPO3ChN1cv6HMCJNl0xMXDQJAwha
         1RVCSFEVhMDLygEet5B3umARfw7TpI1IBklbg1xdL3aQlRctpccpp328JAOKDNfiCZ
         jyKt9uiztJnbdlUOQa4xRJ0WvRzW/RQ2vChi84re8bJzRn2O7sOJCe+Hr02oTN+8uX
         bmXU1qTbEWrbA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 22 Jan 2021 17:09:54 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.217 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Jan 2021 16:08:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.217-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.14.217-rc2-g10fddc03bd61
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
