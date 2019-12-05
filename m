Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B205113C03
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 07:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbfLEG7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 01:59:14 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:8950 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbfLEG7O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 01:59:14 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5de8aac50000>; Wed, 04 Dec 2019 22:59:17 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 04 Dec 2019 22:59:13 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 04 Dec 2019 22:59:13 -0800
Received: from [10.26.11.205] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 5 Dec
 2019 06:59:10 +0000
Subject: Re: [PATCH 4.4 00/92] 4.4.206-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191204174327.215426506@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <3faa827e-eb8b-ef26-0392-0fbb1cd589b2@nvidia.com>
Date:   Thu, 5 Dec 2019 06:59:07 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191204174327.215426506@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1575529157; bh=ZX192Uyt24fnPEqsVv7TYZEmGjW8ChTs/SJylwWFttU=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=V7T9IEYErW1YLAzF6zPs0yW6vyt4cdgr3/KR9wTseO1dYvHCocFScd8tHpL4hQ7xp
         nw9SOHWwvwkUYp3wz79e/9X+5uSW2sCdYg9XBj+jZNnNNC/sIpLzMkjls/9VLv1cUI
         QdlTZR7Nku7kMi8Tz//eXfS6zXtUF5ZhSYhuu8tdArtonjitWeZejGBJ7xZYKM2Mvn
         DsCovCyzxMFf1iOT2vjclASt/Xdhfh2rAbBC4Z1g5QQFEzSBuK74zh30hV8FMjXrbA
         4B3t2KJMzQb/cLoKTQ6Tlc/bWUgZ4frONxzSh81AtSdpDc+76VP8S+b1x+Z8SjA6Oc
         /dJGAlT9GXH1Q==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 04/12/2019 17:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.206 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Dec 2019 17:42:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.206-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------


All tests are passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    19 tests:	19 pass, 0 fail

Linux version:	4.4.206-rc1-g4fd2af91bc35
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
