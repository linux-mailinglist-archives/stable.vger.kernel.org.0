Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 641B01060A
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 10:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726040AbfEAIYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 May 2019 04:24:52 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2172 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfEAIYw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 May 2019 04:24:52 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5cc957d00000>; Wed, 01 May 2019 01:24:48 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 01 May 2019 01:24:51 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 01 May 2019 01:24:51 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 1 May
 2019 08:24:49 +0000
Subject: Re: [PATCH 4.9 00/41] 4.9.172-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190430113524.451237916@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <c1fb784e-1a08-5a6f-a652-7fa5f0b24b03@nvidia.com>
Date:   Wed, 1 May 2019 09:24:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190430113524.451237916@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL101.nvidia.com (172.20.187.10)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1556699088; bh=j4/q/3FxxZX3V9FKqTK7Y+a+NtqyIkq57NvphO4IFkA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=EQPe/NMgXIIQRKJuyHI0TbPj6Qlb5gjiUf5QmEbLBUj3iFDJ0GHgYfSkWhlLnt1M7
         8sYueOnlbu7bSJuIf9g+ZiIgJDP5AgH2FI1/rSljN2pLdoOhOLkbTswzGB3RGlBHkS
         nOORj+zk4wMZyEJ1Vi1iVyoj1rxUUbhoWyG5+PTqZULVAOc0y7A8+JNWp3YtC5d7cl
         aaZpIAQgD4flstyMCD6HaqNs9TXF2Tah/FBzUnezrB/OxMObUXTDUmXy6F3Dcp3Cwm
         MLop3Tf5QSZ1GDz8J0TUJetSRcSjNQp2eGXtewpihpeHz5iWKSSQrusWbuY7iV25YM
         LNVYRzHpQU+AQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 30/04/2019 12:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.172 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 02 May 2019 11:34:41 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.172-rc1.gz
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

Linux version:	4.9.172-rc1-ga707069
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
