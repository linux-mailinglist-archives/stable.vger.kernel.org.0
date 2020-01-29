Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29BC714CB3A
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 14:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgA2NMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 08:12:14 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3034 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgA2NMO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 08:12:14 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e31849a0000>; Wed, 29 Jan 2020 05:11:54 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 29 Jan 2020 05:12:13 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 29 Jan 2020 05:12:13 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 29 Jan
 2020 13:12:11 +0000
Subject: Re: [PATCH 4.4 000/183] 4.4.212-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200128135829.486060649@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <062d1c63-3c68-fbd4-14d9-5d1198ae565b@nvidia.com>
Date:   Wed, 29 Jan 2020 13:12:09 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1580303514; bh=0piV9Lgz8AFvzH2FLbpSr7DKVx71UR1mKXzkXgu5hxQ=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=UE2ntlRa5ws8oNBQdczRTLXxmIFI6KTbeOcH1y9bLJSYKcOTXP6dTpW04gVVGqleh
         wMdVV2SDIgToPMQ26YKDyDu0PBvNUAznXp85az8hs96BMVYTo1kyyw63oEfQw/mFbC
         ReEdq3358fv65IAbeXVWOikNnW+Y0K0R4wISI02bCE6hXjMYGGcxY4NcQwZ9yAAQnj
         cuw2zRckovct6+b6XtLRKFvECESdTmIKxfiaDNQ6w0ZhSeBpCQhFj4oGkVQoHKW3Xj
         WeqnHufbJjE0KPj43kbl3sCkwJ2AGoRb9xd+dz7XCTWBtpH9UvhF0t8XtHfXfaiEz6
         2Y9WGc8T8nTCQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 28/01/2020 14:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.212 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.212-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


All tests are passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    19 tests:	19 pass, 0 fail

Linux version:	4.4.212-rc1-gc4e686398655
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
