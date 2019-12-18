Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA095124467
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 11:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbfLRKXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 05:23:08 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11759 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfLRKXI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 05:23:08 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5df9fe020000>; Wed, 18 Dec 2019 02:22:58 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 18 Dec 2019 02:23:07 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 18 Dec 2019 02:23:07 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 18 Dec
 2019 10:23:04 +0000
Subject: Re: [PATCH 5.3 00/25] 5.3.18-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191217200903.179327435@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <0d53cd34-e8d6-ca55-243a-ccf9d7c5c408@nvidia.com>
Date:   Wed, 18 Dec 2019 10:23:02 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191217200903.179327435@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576664578; bh=TPEZlhSuVfY6nI6tLEC1n2/R8FGA4pqI51Nust1czuk=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=YW/VfDGxq8ezuJNLtKoJigKsgGJlojaOEpnMVh0pEcBobT0nbgV+ysxRuL49vLW6i
         PhM5ZDMaFe7pHPKYt/WBC1dllbz5oLGtcco+LMLastlimzD+PmSdgvj140kY43vau0
         s2CVesNB2tuJNSRUopUnmsOp2hNIFNvxkCrr8rwR04ArUtlowMJxxRvaTxTdNhUajX
         AZO7YQwJueFpfDHajkJj52QWFt6qGzBTzulGDVMN/0HkXFX8MSiMNxRNHiBFu7akz/
         qWW47rbU7KWnL7brga99HlCZ1vofYYyBHaPDZJ1BVpj2OuG+b9vjy1er0nFM8LYPJl
         rxfL94uXfsggg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 17/12/2019 20:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.18 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Note, this is the LAST 5.3.y kernel to be released, after this one, it
> will be end-of-life.  You should have moved to the 5.4.y series already
> by now.
> 
> Responses should be made by Thu, 19 Dec 2019 20:08:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

All tests are passing for Tegra ...

Test results for stable-v5.3:
    13 builds:	13 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	5.3.18-rc1-g0763039c4844
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
