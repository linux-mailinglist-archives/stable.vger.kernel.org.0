Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3523F8F16
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 13:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbfKLMAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 07:00:43 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:1134 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfKLMAn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 07:00:43 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dca9eb20000>; Tue, 12 Nov 2019 03:59:46 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 12 Nov 2019 04:00:42 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 12 Nov 2019 04:00:42 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 Nov
 2019 12:00:40 +0000
Subject: Re: [PATCH 4.9 00/65] 4.9.201-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191111181331.917659011@linuxfoundation.org>
 <20191112052759.GB1208865@kroah.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <86212269-c981-3ae8-e45e-b224c3dabfef@nvidia.com>
Date:   Tue, 12 Nov 2019 12:00:38 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191112052759.GB1208865@kroah.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573559987; bh=nXFKULZh/Yle6zIUeyfxJiKLsnU4d4464p84ERTGTbI=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Njh7pBEmbmAZG3bLJBiYz2jIpvKjpusQL1ITqvmYxxH873akDs37N6+mvBCgCCizd
         01CbCVF60krpWfbPg/jJAadmDCyW7Rk+f8R3zW8fFYJBh5zThouqUjIeQ/214lSuL1
         vBM/eAslY9MAuKNPIl5BDxfqO28mzZ0kvqNlMUNcurMlhnVF+JOz2jydBA2H2LYSTO
         ziPiNzLO6iclFmWveiVhojB3Q1ywB3jFHIsSerrecSjemdJjXZzCOmoXsz5v6Qymix
         3XuzWGmbQ2uGA5BzDWBR3KXITRxjP5fyLNAOFg9AQO0dvC7traRB5qYq9x+1cZw/W6
         WaXL5mxsMxaCA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 12/11/2019 05:27, Greg Kroah-Hartman wrote:
> On Mon, Nov 11, 2019 at 07:28:00PM +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.9.201 release.
>> There are 65 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 13 Nov 2019 18:08:44 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.201-rc1.gz
> 
> There is now an -rc2:
>  	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.201-rc2.gz
> 


All tests for Tegra are passing ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.9.201-rc2-ga3a12cc6ffc1
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
