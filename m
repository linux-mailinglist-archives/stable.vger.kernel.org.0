Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6303123CC21
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 18:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgHEQ0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 12:26:17 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14407 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgHEQYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 12:24:00 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f2ad5550000>; Wed, 05 Aug 2020 08:50:45 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 05 Aug 2020 08:50:59 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 05 Aug 2020 08:50:59 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 5 Aug
 2020 15:50:58 +0000
Received: from [127.0.1.1] (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 5 Aug 2020 15:50:55 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/47] 4.14.192-rc3 review
In-Reply-To: <20200804085215.362760089@linuxfoundation.org>
References: <20200804085215.362760089@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <3d8435af64054f67a9015004638ed70d@HQMAIL101.nvidia.com>
Date:   Wed, 5 Aug 2020 15:50:55 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1596642645; bh=amxctjbH3Ku1BKBU3DtBrtA0UUWeQF0UttAkw7yNsQY=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=rNN9gwoiCaUS15EzcmcdPs55oEbddUr0eHxGsp9L+GBBY3fNDwM6HJqQbt6BdS/Dl
         6GwdtIUv/xHo7zl2VDCaOzFdlVzNV0QYeranh06VM38Lwa5Q+wIomrAfxYXAMrNCxg
         iA2Tzj6qH8VuzxWVBai3VOVj/DT2FICr1Abv1qEaDR5LbjXgtz5IAg0+q5L/f7WQkQ
         3ua7fYspV6MJ5VU4d2/XUjEWvXa++GPUVmj8TAVfY9+sZ0YR6pvcGPwuDYy45L7pah
         /zSKd1krjAQTrZq5jTs1z4hAvwcGDWGaaeeyFBAVne1mELumFXVR5ozVW6ABojbuRQ
         BrJRLEktALB5Q==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 04 Aug 2020 10:53:16 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.192 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Aug 2020 08:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.192-rc3.gz
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

Linux version:	4.14.192-rc3-g7083248d6b07
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Jon
