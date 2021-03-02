Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A8132AEE1
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236316AbhCCAHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:07:05 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8054 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378955AbhCBJXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 04:23:13 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603e03950000>; Tue, 02 Mar 2021 01:21:25 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Mar
 2021 09:21:25 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 2 Mar 2021 09:21:25 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.11 000/774] 5.11.3-rc2 review
In-Reply-To: <20210301193729.179652916@linuxfoundation.org>
References: <20210301193729.179652916@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d7aaf0e4f6074ae69fa921d4a8758b84@HQMAIL109.nvidia.com>
Date:   Tue, 2 Mar 2021 09:21:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614676885; bh=0abCiTev9unBNw0TB3JdUODmXfrGI8jbFOKZL6kV0Wk=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=QY8StPRJT7mNhP3v9bKr9XIo33+PFm0QpuGVUgAxB6TVc/IQbXo8KJ8iTQkm0j9lh
         XIq23/vIe73G9zSh2kggtxVmHOrXL6+AYG3LfYMzsjFnAOhTSb2K28rFEvoTaZY5qS
         ZGkel/8IQt7kKZwRfw6zVTHUi855bfCkEFT4tBYGx7n/KqZVXT0eov8H5wlaNgzcl4
         H68b+HRwQiHLOdbzSL0Ukb3tXBgTKBvud9TX9U1dgEPgoAcZByVopKHQN4xSoVQVsH
         o92YjfdVz9zGsgLAtHExjZ/wjMvAhOs00xYSEjezEaeytnbyB536d429/s/E66I8PP
         ij3OShrUZQGuQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 01 Mar 2021 20:38:32 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.3 release.
> There are 774 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Mar 2021 19:35:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.11:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    65 tests:	65 pass, 0 fail

Linux version:	5.11.3-rc2-g687a937c5987
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
