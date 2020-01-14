Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3B0713ACEE
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 16:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbgANPDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 10:03:01 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:19879 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729195AbgANPDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 10:03:01 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e1dd7ed0000>; Tue, 14 Jan 2020 07:02:05 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 14 Jan 2020 07:03:00 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 14 Jan 2020 07:03:00 -0800
Received: from [10.21.133.51] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 14 Jan
 2020 15:02:57 +0000
Subject: Re: [PATCH 5.4 00/78] 5.4.12-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200114094352.428808181@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <67098cc6-6b86-c441-065a-2cb7fe9a2be6@nvidia.com>
Date:   Tue, 14 Jan 2020 15:02:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1579014125; bh=yzSPuWLBN2YvMW/0WwtrJdbVbpD4+Umhl9BNaZEckJ8=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=gOVFuwQl0SzM+tv7X82SM8I7IyiCKCeDVFh5Kw9nwcQwzZD4WMhdWVuuD6GDoSLwW
         SuAN6AdIWlbbggCLICYJaRZjmgPhP/En0q0eBO1TgO07dtoKJ7U8sqktHKIS+pUXqq
         sXSVGVEHRzCaPhpW+MF/39IvLzaYskuuKvftGCU7DiyQA71uLdr44nI5yyfewMwzh2
         1dv/ca4QVnDjBQD8kyYvybpDcxai6VGgNOItos3Y1IKstfp9RNQSjeSQV32WHXE1u0
         xEQ1h/qY3RLUrkq5GNemcum0WDNd5hW84HSVV5A6pImHHa1dvmesjIqPKaW1rSCpQt
         yEScrFHP9RP1w==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 14/01/2020 10:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.12 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jan 2020 09:41:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.4:
    13 builds:	13 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	5.4.12-rc1-g5c903e10834d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
