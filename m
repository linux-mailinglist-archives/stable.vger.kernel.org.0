Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334A424BC86
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729618AbgHTMsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:48:22 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10395 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729422AbgHTMsS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 08:48:18 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3e70d6000a>; Thu, 20 Aug 2020 05:47:18 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 20 Aug 2020 05:48:17 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 20 Aug 2020 05:48:17 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 20 Aug
 2020 12:48:17 +0000
Received: from [127.0.1.1] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 20 Aug 2020 12:48:09 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/152] 5.4.60-rc1 review
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <83e5fccd4faa4226be6d779402d8fe25@HQMAIL107.nvidia.com>
Date:   Thu, 20 Aug 2020 12:48:09 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597927638; bh=6egb251KFsW5txQSJjyYEalrt9p2rm5ybMsCiuz/N0Y=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=YTGjzYp0S+ui059Ly8CiOl6+pjFGdGVlA/Tl4Pc7jI/BCsHHOrddz8aZo7k17xLji
         AvOQIEJKDuJtO9ZJOsHPfdalSJQaVJMkCgVNsOdvxlUPhWadcPa34uhh2Kc9C0ryjk
         zKTW4f3hdWFUG8K+dMPaEjS5G3J4/XQiGdWVznVDrOq9M4jw+/NpDgN+mdjQnE8GQ3
         HGUAX6OeivdPCJoJD4QdGyUfmRUcAU3oOucbDcbgNlUjBlN7qhoRgJ74Ct2YJ6ptY4
         xOJhcUtREaRljmAVkbUdZYfkvQqAixwroxW/f5/c34rl3yPd/jE0MaBHud47ieiOnR
         zrR8L2Lq+aamQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 Aug 2020 11:19:27 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.60 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.60-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    11 builds:	11 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.60-rc1-g6793ee834d88
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Jon
