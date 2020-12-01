Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754182CA40A
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 14:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391111AbgLANkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 08:40:09 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13526 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387823AbgLANkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 08:40:09 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc647910001>; Tue, 01 Dec 2020 05:39:29 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Dec
 2020 13:39:28 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 1 Dec 2020 13:39:28 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.9 000/152] 5.9.12-rc1 review
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <507f52cca2ba4a4a82ce29a06af3243d@HQMAIL109.nvidia.com>
Date:   Tue, 1 Dec 2020 13:39:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606829969; bh=3mTiIGp3HfuDxpy7cOV6G2zGvDqRCvKppN/GXCxsZU0=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=rKExTtxJUiOslADpsnsvOah+lbuIRv1QDAtINNsfF2Uf99SwoFv6xIjBEaisAiqLj
         o0zB6pc83PKji1ecUk48S4FID1ch2sPRw8TmwZzx6RidwUhNobJc1V35wTLk9L4xE9
         MZQ2FzJO9A5I1GVqGPFT/d1oTx0KPAF1QLF1MBURjz0o07u7/5ML/SAr9baUlxo5iC
         nHhUs0jNZ1upjrEgROA8KTfl5e7CjhIN70r2XtHiTWI6f+pZwRb/A5P8ebQiBNablt
         eSLYBLVa3/1xA9GdtncGQBaOifkvE4oMJk4yRw5gBa5KXcWI2OgkFobZc8jPoeqQsW
         6JQYUEXSXesGw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 01 Dec 2020 09:51:55 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.12 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 03 Dec 2020 08:46:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.9:
    15 builds:	15 pass, 0 fail
    26 boots:	26 pass, 0 fail
    64 tests:	64 pass, 0 fail

Linux version:	5.9.12-rc1-gfb49ad2107f4
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
