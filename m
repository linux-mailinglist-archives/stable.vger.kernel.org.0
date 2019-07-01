Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1098329683
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 13:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390654AbfEXLEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 07:04:07 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6471 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390374AbfEXLEG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 07:04:06 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ce7cfa60000>; Fri, 24 May 2019 04:04:06 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 24 May 2019 04:04:05 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 24 May 2019 04:04:05 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 24 May
 2019 11:04:03 +0000
Subject: Re: [PATCH 4.9 00/53] 4.9.179-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190523181710.981455400@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <f2cd8618-eec9-e46c-a476-8bb4f73fcb9d@nvidia.com>
Date:   Fri, 24 May 2019 12:04:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523181710.981455400@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1558695846; bh=PQN2kWMNhnBUCGTqtCDK4wjKvYu9US1k8DVUexG457U=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=fJugU/VuaPy9QnEs0AMpRXHtCHWi4/JARyr8gSDx73KR46bsUbTDXbttjo/HmiYfx
         jKFIbeX1lpjQkeMYsbB7h5rXfihlr8V49YhptVT0sOUFEGs/lLFD+vEPBHYbJKQX2Q
         OlC4az08vlHM/zEnTmECmIIsY/UuNVCu2ebo9piNOROpHZFec5jcYkkzhPMdCCv3sq
         8jfH8baS9GdQBSaeEY91s7484YSWpW7TJGnLQeU1q588NIrCiZC23gClvlFJIuCzAi
         AeWm3zk8BKacBHi7ElUMytdfO9tTWEX1vduRGibURYkGqw5DoVg8S5cuGzmkTJjs4h
         GBbTF7c+0O4Mg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 23/05/2019 20:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.179 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 25 May 2019 06:15:18 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.179-rc1.gz
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

Linux version:	4.9.179-rc1-gf6bc31d
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
