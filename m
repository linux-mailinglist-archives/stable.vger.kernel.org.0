Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C865426BEDD
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 10:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgIPIMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 04:12:23 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17930 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgIPIMW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 04:12:22 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f61c8d80001>; Wed, 16 Sep 2020 01:12:08 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 16 Sep 2020 01:12:21 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 16 Sep 2020 01:12:21 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 16 Sep
 2020 08:12:21 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 16 Sep 2020 08:12:21 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/130] 5.4.66-rc3 review
In-Reply-To: <20200916063531.282549329@linuxfoundation.org>
References: <20200916063531.282549329@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <0e7228bef5fc48fa9d8afd6651d1d149@HQMAIL105.nvidia.com>
Date:   Wed, 16 Sep 2020 08:12:21 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600243928; bh=EAgwF4jzTMDceNc6VsEP2mUBbriBptaV4VYW6mS8Vfw=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=Di/rDUHh4747VihyGw0/940Ihy+EYfHyqNsm6gLTMSEFomT+q+pazKGQ9k6b2zgod
         q1vYjwHcJKGgGxHmpM8Io41iBg5oE5Zx3il6PYLjdASn0QKHQ25AE98Gimtk9MLrRE
         jCMXAIgewsQojdkza+bQj9BcpHs8vML4CCxfJjtYePBR+lBba04xW9T0QLNoxxKgjb
         crYYNsOoKfFoz3+CH+s5U2U+Yl7YSvHvKBJv0gy9FU17dCQKHYPBsJngux96Z0Y9JU
         GeJ4A/wFm46po0dzdtkRwAfQfYrK7s7nQxQj4BVnd+1qz3yNsBT+/Epgxu4V8UonxZ
         FcXfbMLeQmD2g==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 16 Sep 2020 08:37:45 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.66 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 18 Sep 2020 06:35:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.66-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    14 builds:	14 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.66-rc3-g0d8c7a7aec77
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
