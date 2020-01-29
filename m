Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33E0A14CB41
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 14:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgA2NNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 08:13:31 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3077 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgA2NNb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 08:13:31 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e3184e60001>; Wed, 29 Jan 2020 05:13:10 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 29 Jan 2020 05:13:30 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 29 Jan 2020 05:13:30 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 29 Jan
 2020 13:13:28 +0000
Subject: Re: [PATCH 4.9 000/271] 4.9.212-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200128135852.449088278@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <28b129d7-e97f-913f-ede2-5edfb3e63654@nvidia.com>
Date:   Wed, 29 Jan 2020 13:13:26 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1580303590; bh=vBStl0y7KLg1KmAPXtCCpnS0BCo0CiZ1NPipIyTkpC4=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=jGLjWmH9lvAqgJ4wmMnpE9ZWZ3ZEYt6+FRstIPBAt+p6tpslOUmQguYscAeJaXffB
         J1+kAIVJeKD3P0zzaH/E7yFuyJeuDaBoOHssKoLDTwmZTxhkCrfOv3rmetS4BiyD62
         f3mbfYfWrB00l6FA0gb4pPE+UtktLBrVAE/Ow+GdIFcU8WoawyLGR2gSZGzsOyxQqf
         CtroA0Mf/Bq7X67IVkgc0b955uObRUMnCNrNoU++1ZsAgislHs0aTCmCpAcDR9u2Ic
         +RAmeskmsmo69pnw8bOL5Uw0OazOPoMuBn7gHXI5gH39WOogLH80RlmLqxfygTBEbo
         kkHQIIfqZeNGg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 28/01/2020 14:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.212 release.
> There are 271 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.212-rc1.gz
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

Linux version:	4.9.212-rc2-g91ff8226a074
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
