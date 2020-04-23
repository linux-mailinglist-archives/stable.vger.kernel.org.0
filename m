Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1CD1B590E
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 12:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgDWKWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 06:22:17 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5847 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgDWKWQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 06:22:16 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ea16c180000>; Thu, 23 Apr 2020 03:21:12 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 23 Apr 2020 03:22:15 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 23 Apr 2020 03:22:15 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 23 Apr
 2020 10:22:15 +0000
Received: from [10.26.73.193] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 23 Apr
 2020 10:22:11 +0000
Subject: Re: [PATCH 4.19 00/64] 4.19.118-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200422095008.799686511@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <994d756a-3659-c22d-e056-f739a35ff677@nvidia.com>
Date:   Thu, 23 Apr 2020 11:22:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200422095008.799686511@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1587637272; bh=4PTecHOzV1Vq708KN+Y5xaZBKB8Q/aoMcR55AE6G70Q=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=qhw65OtANj1TQn8mGsraRarWdwI5//uX/kceoOLV211IFsl6YtURBMY9D1+2tUHvG
         ETpN3kcNylImKLsRSsvgIPnfGxw6uxaA3EpbPubGVpWT7Y5ax2ouFN4M4DCJqoybSH
         qERY0f9gX0kk3rdsUqoQJ+ZB4pDkjudwkirAz7XKR4WP1FKMkM3WpRWVuGrnWIR9gB
         ZxtyDyxf9qByehUIHg3joih8bIZ8sqiv68O0PzeejI1ZW7zxqPWV9noNyAqACi1I4P
         VtXb5evbhlBoKZjtk1PezZXNz0fJz983eU5FQDb6ewYQf90L2/883LUQCmjXnBLNCV
         OSNYClzsql1jA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 22/04/2020 10:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.118 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Apr 2020 09:48:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.118-rc1.gz
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

Linux version:	4.19.118-rc1-gb5f03cd61ab6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
