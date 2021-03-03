Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A5832BC3D
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444806AbhCCNqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:46:50 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17684 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357408AbhCCKtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 05:49:45 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603f56a20002>; Wed, 03 Mar 2021 01:28:02 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 3 Mar
 2021 09:28:01 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 3 Mar 2021 09:28:01 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/657] 5.10.20-rc4 review
In-Reply-To: <20210302192700.399054668@linuxfoundation.org>
References: <20210302192700.399054668@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <1eca83a8a33c44f99ed11d3b423505df@HQMAIL107.nvidia.com>
Date:   Wed, 3 Mar 2021 09:28:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614763682; bh=6GRaDQfVJKOSkTKiGtMkyKOVhC5yEQlBoasZyCb7WpE=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=WOXzid3PwLjUMt0Nz8w4Btny5TIcCIT1GwOujNvu4ErsPu+vH4sPpXVul9L3mcoBl
         1K2nTZAQoDcZbDHtcRig2VRGLw4syn6ntNn9siM9otn9F5mzv0yv7jxiqAL03vqkOU
         58eNbPDG95Tc76P5CQ9cCRj/k3bAmYh3fN5NL3cGgX0LrRA/LKA8DISB2hC/Q0LWuQ
         0l400Ccg7IsyF6rcM1WCsYqQzW1VFTMMrzUapdz/l4Zncx9qpZGdxSMAeOKTaNS4Mv
         rulQ1ybBSxEnTzUsYGimeQIayuSnnSUqIeoFqJIClpEJZOC1rAxOKup/vbAfjy5DM+
         TqsoNJoLgYayw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 02 Mar 2021 20:28:49 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.20 release.
> There are 657 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.20-rc4.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    65 tests:	65 pass, 0 fail

Linux version:	5.10.20-rc4-g083cbba104d9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
