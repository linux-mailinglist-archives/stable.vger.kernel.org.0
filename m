Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B9C1ED2F5
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 17:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgFCPGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 11:06:04 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11927 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgFCPGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 11:06:04 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ed7bbfa0001>; Wed, 03 Jun 2020 08:04:26 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 03 Jun 2020 08:06:03 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 03 Jun 2020 08:06:03 -0700
Received: from [10.26.72.154] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 3 Jun
 2020 15:06:01 +0000
Subject: Re: [PATCH 4.9 00/55] 4.9.226-rc3 review
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200602181325.420361863@linuxfoundation.org>
 <4eaf333a-e497-d39e-338e-a790b116dc62@nvidia.com>
Message-ID: <ca7bfb13-a22d-7988-9be2-469b0c4a8437@nvidia.com>
Date:   Wed, 3 Jun 2020 16:05:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <4eaf333a-e497-d39e-338e-a790b116dc62@nvidia.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1591196667; bh=4hUV0TwB+fKkfxySAIqP/sd7nZ7/zxOBIH/wTAQXWIw=;
        h=X-PGP-Universal:Subject:From:To:CC:References:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=XtQaQb8nnM+h52K43PvC+dTjspHT27MKrVaJXs+urGx55oIWrM+F03bWiLmwvld/G
         AudPozz4PVXc3c3638zTdWiJouNxFyID36GPW4PN8R0SFC9uJBNa23nl/VRyU08QK5
         oV6JFj8oq31iWFuaGD1KZXme5X0wMUvy15LJZcowa7R6qg7JSfC691EKNlBOzr23pl
         eGhcbHOJqk9zUsugmwARZYk7JVen5WHFRongUnKFbyhWT1S5J9ZvEzKL+JobUwJ5Iy
         QWTWXsolEBhe/XiQtxZdXZmumxqjtZcMSM9bWwt+AWtyB1slsaBwclmG8Bo0pVlTAs
         bywVysCxQ3R1g==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 03/06/2020 11:42, Jon Hunter wrote:
> 
> On 02/06/2020 19:13, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.9.226 release.
>> There are 55 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 04 Jun 2020 18:12:28 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.226-rc3.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> 
> All tests are passing for Tegra. Seems that our test gremlins are still
> at large and I cannot pull the report yet. However, I can see that
> everything is passing fine.

Just for completeness ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    26 tests:	26 pass, 0 fail

Linux version:	4.9.226-rc3-ga836fd8c024d
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Jon

-- 
nvpublic
