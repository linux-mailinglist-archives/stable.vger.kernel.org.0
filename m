Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B3D1D9274
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 10:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgESItv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 04:49:51 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13543 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgESItv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 04:49:51 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ec39da30000>; Tue, 19 May 2020 01:49:39 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 19 May 2020 01:49:51 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 19 May 2020 01:49:51 -0700
Received: from [10.26.74.144] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 19 May
 2020 08:49:48 +0000
Subject: Re: [PATCH 4.14 000/114] 4.14.181-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200518173503.033975649@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <ef049668-6f4b-462c-f74a-5d3d6fa94e74@nvidia.com>
Date:   Tue, 19 May 2020 09:49:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589878179; bh=yxMOqq/v6AVi6n7tbVkgX8AljEqfLMC/CBxZaZ/PNyA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=IJxIZxvahkz4qnq37lPsMynAxXGqiFazpDaDf7xc9MIXscRS1DsjUhlILpmRKF9I1
         BfVyAZt+/bQvbJ0MqDXgIOV4QP9139l8PJy+mMnNJfqchuJ6I5SZa6fgtBZdP3ar0y
         TlRZ37s3j4H/LVGTU3a50sfmLXY8Urlu8ggLja9MjkRriRRZCxTiEGWXGdcofDGU3c
         b/vcAY0Wk3dmqN6bd2eu612P3kxhhA1YYeAlzkqQHx/86ZvzObLmSe/bfmJfB+/RfO
         UeuU6tlLyWaI2ix99WwPO+dpP9QUpuHPy6aEEB79/HFjcoFRbY2HpSPSdvnGjQlMxG
         KxUT3ydpDGgtw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 18/05/2020 18:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.181 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 May 2020 17:32:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.181-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.14.181-rc1-gea63200ccd3f
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
