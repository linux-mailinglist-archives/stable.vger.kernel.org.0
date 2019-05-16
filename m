Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3DB52040A
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 13:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfEPLEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 07:04:37 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2954 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbfEPLEh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 07:04:37 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5cdd439b0001>; Thu, 16 May 2019 04:03:55 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 16 May 2019 04:04:36 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 16 May 2019 04:04:36 -0700
Received: from [10.21.132.148] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 16 May
 2019 11:04:33 +0000
Subject: Re: [PATCH 5.1 00/46] 5.1.3-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190515090616.670410738@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <5b7b4163-f616-3cd8-ea45-3fd3f495ae7f@nvidia.com>
Date:   Thu, 16 May 2019 12:04:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515090616.670410738@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1558004635; bh=NQoOq/5EeDi+HzR+1avUBXkV8WDOXJJTiLY5G2RZTg8=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=EpyE4lPf0W1Iqv5qc6ysuul/CTIevH2Ot3aM7xA1nmUK6sbpxsdco6U/0TD1Q8MTH
         3H+LoUHTzOzU1k4KVpwpSU9TFucQKIOmxqyLqET6o3jicnZTo761WDznh0giuErF/G
         hE6crDDhvv+UnAlBE4I+D9QKTRwEb4n+LY/7jOdL2DMw45TUGXLpQ9sSDkeV/rI7iT
         5wnZyC/oCFnKKfdT2EjO62lWu02EcmMTv+/ycM/XTRenUDoUBRxoLRq/8sPEY4Bhsi
         IR90r4wWT883D+e4MqWT8CX0p+TLLlzEfHepVuOWoxQzvM0o9oAkn6fiX7iwYJ/GBH
         O2g5g8ohLTL+A==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 15/05/2019 11:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.3 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 17 May 2019 09:04:22 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.1:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	5.1.3-rc1-g6c9703a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
