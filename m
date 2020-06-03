Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E831ECA92
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 09:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgFCH35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 03:29:57 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10556 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgFCH35 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 03:29:57 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ed7511d0006>; Wed, 03 Jun 2020 00:28:29 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 03 Jun 2020 00:29:56 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 03 Jun 2020 00:29:56 -0700
Received: from [10.26.72.154] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 3 Jun
 2020 07:29:53 +0000
Subject: Re: [PATCH 4.19 00/92] 4.19.126-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200602101901.374486405@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <feda2b19-7484-31ab-4c71-af989b0cecf1@nvidia.com>
Date:   Wed, 3 Jun 2020 08:29:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200602101901.374486405@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1591169309; bh=lufYxrco0AobdhlKZ1dyk5XDKGqsOceXZQMqEoxvTM0=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=E7vxp7vIy26RndBkO5BGgSx7VmRZ/U4qc8jzdCztZIBTMcwG4RZ0GM/Xk+JtjSCTB
         2iLTFcdVsx4V+SKSRoSu1XUPARkhTH+0dE5vZTGFy1srZxIrCSLzF/IN/plgnYICCJ
         W2I/YvF3JMuwLWQ3MTH6NYtveA8q8wWvhXrFN21oI6/RfgnBSTCRFd+cSYEqKmmKwf
         cs3UHgpoPtbynFM6pyEcrKegosgytQRQk8ZpsL1Gc6aWD/uSnrxqnIvG9+4zxdV5HI
         KFAf5DZdNpFweCb8nXNkUHKGNH+L5XBgTCRQJHvupXnUyrK9ZR7IcgbtF348ENy//k
         gNSQJSZo9qJPQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 02/06/2020 11:23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.126 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Jun 2020 10:16:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.126-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.19:
    11 builds:	11 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.126-rc2-gf6262a450952
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
