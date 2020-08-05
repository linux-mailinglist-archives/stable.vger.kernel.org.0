Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80B923D2D5
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 22:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgHEUQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 16:16:42 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4475 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgHEQS4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 12:18:56 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f2ad5a50000>; Wed, 05 Aug 2020 08:52:05 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 05 Aug 2020 08:52:55 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 05 Aug 2020 08:52:55 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 5 Aug
 2020 15:52:55 +0000
Received: from [127.0.1.1] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 5 Aug 2020 15:52:46 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.7 000/116] 5.7.13-rc3 review
In-Reply-To: <20200804085233.484875373@linuxfoundation.org>
References: <20200804085233.484875373@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <42f62b34e93b43a58ec90b6f8b973bae@HQMAIL107.nvidia.com>
Date:   Wed, 5 Aug 2020 15:52:46 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1596642725; bh=sxEZcaVXjMbb5T+zPk/l8OYNGMH4JgwgvPIIgS+SqFM=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=Vqi+FyZJjQBSheaQUnjYsCMBlm9d2IWw/ogxPaPW60X/sWSqsocFZi1qxfjMxbQsL
         O+LwOwgPGaVok7SRWi8u4DQ7b6Qb9waCtCgQ4AKxIZr7FT5ep+ftdwBnXyASwVp4ZA
         AY2aIlx7sM5bowEeMsVSMYI3rx4qmnME7z3i3KNREPgfainhNeLRijyAWbR3iOTQLX
         LmcEVUqx5ZeL4BvIu2bziz/8InRSWb8Q1MLZWe3GmvGhVJevzTMrTXfkKgCJ1c3ma7
         GUvu/BkwnRoEgxpy3dwnj8WH+Gfk2Xv5yyqgnNpQ+PXuWcTtaeRZbD8ty29Air60vY
         1vNmB19YBATsA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 04 Aug 2020 10:53:53 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.13 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Aug 2020 08:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.13-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.7:
    11 builds:	11 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.7.13-rc3-gd3223abaf6fd
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Jon
