Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B99253457
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 18:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgHZQFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 12:05:41 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8753 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbgHZQEX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 12:04:23 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4687f10004>; Wed, 26 Aug 2020 09:04:01 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 26 Aug 2020 09:04:15 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 26 Aug 2020 09:04:15 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 26 Aug
 2020 16:04:15 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 26 Aug 2020 16:04:15 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.8 00/16] 5.8.5-rc1 review
In-Reply-To: <20200826114911.216745274@linuxfoundation.org>
References: <20200826114911.216745274@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <1505aad2fc61485e8c6b02117b0a5ea9@HQMAIL107.nvidia.com>
Date:   Wed, 26 Aug 2020 16:04:15 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598457841; bh=XUy7RKRfhORG84FkMp9ZQDnkRSAxkNy1oBBz135zN/8=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=FkgaJKpg79CTgEXdefLrwEAYg/bxqsV/0simIG46G60gL6e7JNz+E9WZ9yONZL6Ni
         8l4u5Fe3TFctFwCrcez6/IE6m5zLe1Ti0qI1tSiX/K0UuHwrLFdKL9N5nFjQtKyfki
         Z4H6dGQ0DnxO+7RVVj54g3PbliedpIw6a9o995+1qzTr6vJBJhXZ/YUndxH3TLsOTC
         yLipihpDJJlQQdAqX970GKdiEcXMj8Fwu12VaG7w/iCANOKzrj0Vx2ISgCqyIupJnJ
         kt5iDalSsE6RfeX1lttKYw1gwY/oO2ALqAhs4Br380lxky86UARduKCr8mas3JjslH
         RC7uoXk/StIIg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 26 Aug 2020 14:02:37 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.5 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 28 Aug 2020 11:49:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.8:
    11 builds:	11 pass, 0 fail
    20 boots:	20 pass, 0 fail
    45 tests:	45 pass, 0 fail

Linux version:	5.8.5-rc1-ga8485efcbc70
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
