Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0932FB90F
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 15:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395399AbhASOSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 09:18:17 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11906 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389305AbhASLvt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 06:51:49 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6006c7990001>; Tue, 19 Jan 2021 03:50:49 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 19 Jan
 2021 11:50:48 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 19 Jan 2021 11:50:48 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/42] 4.19.169-rc2 review
In-Reply-To: <20210118152502.441191888@linuxfoundation.org>
References: <20210118152502.441191888@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <9ea32f059aae4f12b7ca7772bfa2d798@HQMAIL111.nvidia.com>
Date:   Tue, 19 Jan 2021 11:50:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611057049; bh=dTV6i9f3k3w8egNchFr9+2LlYCdBwn3zjN6hX3q4Yq8=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=Lgq9mQcZ3sowjxJxUXgJ6cm4/fX3BVJqsE2eftFnrI9FuO2g3Dm8v8IzeuHrFStyq
         QDR9R6+n3YlxQ1I84OoEC9TNS3E0PBP4EAbtV9zNnf5hRnjxRyiKsnpNk8TSFUX+ux
         1Zya40oJwFA3K3OQcUgqrRak8NWF2jhWV4fuZQ8kA+dSi5fMbK4m0vsgx5MlhSwR3N
         KPf2tZJd8o9/5/+tK6hTBgaQMj0LXyxVn9qaqxJCNwaSmsF/emmvmUDAf8cNQodLfd
         pVwE+eVe9sL/z1dKGECtXyxgBMDfegq1twR40biPOstiGL2Tnti3Y8e35yKRpZw0IX
         JvlAPAyQ0l2PA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Jan 2021 16:25:18 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.169 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Jan 2021 15:24:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.169-rc2.gz
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

Linux version:	4.19.169-rc2-g121b496fc970
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
