Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC254F0A3D
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 00:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbfKEXgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 18:36:22 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:10056 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbfKEXgW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 18:36:22 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dc207770000>; Tue, 05 Nov 2019 15:36:24 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 05 Nov 2019 15:36:21 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 05 Nov 2019 15:36:21 -0800
Received: from [10.26.11.93] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 5 Nov
 2019 23:36:18 +0000
Subject: Re: [PATCH 4.4 00/46] 4.4.199-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191104211830.912265604@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <f6c2e5a9-93c2-18d1-323e-131dd391e762@nvidia.com>
Date:   Tue, 5 Nov 2019 23:36:16 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104211830.912265604@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572996984; bh=jMa4F/aMtkFoaCou/D8Gpq9JjU/CMBY8QV0r2MXQGtA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=bRk8zvLOM2d2K8E6OV3N1dlUYi/c5LaYt60G4C74DIT80gmrN6rB26GgTfZV3nvVY
         vwAYE6XjoXpisiAON2jkngnuVQP77hZN7V/5T4/jOMHmEjP2h3Xl4H4d392TOIm2aX
         YBJn1kFQP6v8+jjTrLHi9iKFXZJtbie4wCrQlj1gIKVwPTva/3TWbqKAtAHa0aQFwq
         SPcZFQq54BNuc/pJotqb7wpSfByVz0GZdYMvvsTq0Vycz5io9R4DvxDKBEaCquZHku
         3kcdMy2T67/4BEOSTIC7byzTFQFml3kUB3Q83vLFKzLuZ7nhvzoVPYY31l1zoGxCZw
         DyeExt2Zj7XUw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 04/11/2019 21:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.199 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 06 Nov 2019 09:14:04 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.199-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests for Tegra are passing ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    19 tests:	19 pass, 0 fail

Linux version:	4.4.199-rc1-g3849b8fee3c3
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
