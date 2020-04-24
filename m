Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9156E1B6F2A
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 09:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgDXHlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 03:41:21 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11373 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbgDXHlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 03:41:21 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ea298140000>; Fri, 24 Apr 2020 00:41:08 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 24 Apr 2020 00:41:20 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 24 Apr 2020 00:41:20 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 24 Apr
 2020 07:41:20 +0000
Received: from [10.26.73.231] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 24 Apr
 2020 07:41:18 +0000
Subject: Re: [PATCH 4.9 000/124] 4.9.220-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200423103316.219054872@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <a686ef98-ea00-32c1-a448-22f5497f7485@nvidia.com>
Date:   Fri, 24 Apr 2020 08:41:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200423103316.219054872@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1587714068; bh=zwnR2jM/fuP37FA5Cq8ywqRHDxLo4HKidb7PRPJ2W74=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=o2K+99TH4KjCIllrDrCAi9A4mF8BKNjtmvAUbH3ofbxfATBCP3hzyugUALPaCvFUI
         9fckivJO8GIuGZEzqdGlr09KYMiXNshMdrsfpleSEwbc1Stp5/opk0QsXafzDRreZT
         JYOAwsT7oPRtyQPYZNZYCWPaHM/x7uJYpvX9ECqab3TVbSgPAW1C9Tcq2DJW+S7PJI
         0Oi061OBmORI8i3fv2B8EhKdwNUiIm+zOtwsg2ov95nekn4MozUtSgD/QN+UBXMcS+
         Dy309q5M5kqqBrFu/gaXodqTOxwSlo+X/HXD5PV1X43ZVp9j1lbmiVogsUoLDsTQQ4
         l1MWXoKS93thA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 23/04/2020 11:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.220 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Apr 2020 10:31:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.220-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


All tests are passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.9.220-rc2-g01b8cf611034
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
