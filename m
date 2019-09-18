Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5016FB681F
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 18:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387590AbfIRQ2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 12:28:55 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16373 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387578AbfIRQ2y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 12:28:54 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d825b4b0000>; Wed, 18 Sep 2019 09:28:59 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 18 Sep 2019 09:28:54 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 18 Sep 2019 09:28:54 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 18 Sep
 2019 16:28:53 +0000
Received: from [10.21.132.148] (172.20.13.39) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 18 Sep
 2019 16:28:51 +0000
Subject: Re: [PATCH 5.2 00/85] 5.2.16-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190918061234.107708857@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <5492c75f-de7c-9fe7-d3f7-3af5f3b3b6ce@nvidia.com>
Date:   Wed, 18 Sep 2019 17:28:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1568824139; bh=HkirmnflytftAuwEqDORh7tOB032Tyt4Pw7BdB70+nw=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=F5vU4NQo/sC7Uj5Y4Wvus6s3Qlz0UE3P4nLo+ZrrDFOxmXyjv9cV7QG7mjXNO+m//
         vDlcljeZ6lvqeBXPlY6NJdN2NneKwK4OXYbUGRMGanZdfhiIPP3E32S/fGNyZBq0rz
         tVz5A+gKsosZPugVCuK/il8hvKIMvWGWjzOUQCzgw+M1Yu0OVpQXjvMALfLFKcT2m0
         ZtmwMiVqFksaiFY14E7weWDhky4Iu6XZlLtqoGOtQBGzi8uehctIEx8Pbwi5XpDFVs
         NXvn7Ciy8tAAmlgzWj8xxHhsGM7VBmttSXmiBUTTpBVrXt/tkAp8Jwu7I65nDWT94S
         /EWQ77OMe9/xw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 18/09/2019 07:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.16 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 20 Sep 2019 06:09:47 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.2:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	5.2.16-rc1-g2f63f02ef506
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
