Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A232627AD
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 09:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgIIHD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 03:03:58 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15549 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728015AbgIIHDt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 03:03:49 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f587e3f000a>; Wed, 09 Sep 2020 00:03:27 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 09 Sep 2020 00:03:40 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 09 Sep 2020 00:03:40 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 9 Sep
 2020 07:03:40 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 9 Sep 2020 07:03:40 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/88] 4.19.144-rc1 review
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <85f8351b9ccf40309185078102a379c7@HQMAIL105.nvidia.com>
Date:   Wed, 9 Sep 2020 07:03:40 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599635007; bh=F7VJ+3POo63bKE4rPtQp+Wt7iaf0fy2be6uVKWK+PzI=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=SN3pGRGOjddn/OFFtPk7s1MvAPqh6BJrF7Z5XG88F4GLTLSZtYi2NU5O/FLUqlkLc
         eLcBBN54jesGxP0UCQbYDo+912twnXgtuG8rBzMzSre8euIuuG29oVthJ8b00CoGDy
         F53o3ATX+KlZ6JECXe65rD+pd/iNE432z35hI4VO8XMzQXh466wBGzMeQ5T8BytTAj
         tH4sYKmlzl39ufGOwOoJKc4WCjkIJ5z9L5f5FW4rncKL1xJI21MSOwpMzp9aHZ+kyh
         4fDgpuGpCsr/PnRdc9P6hnlGUIr2QW+3rnOHRulJyIluIKYXwxdT7z6yd0aIsBpaHx
         VBcx36DunU/KA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 08 Sep 2020 17:25:01 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.144 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Sep 2020 15:21:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.144-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    14 builds:	14 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	4.19.144-rc1-g539e30e8c9cd
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
