Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B97FEF0A4C
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 00:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbfKEXlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 18:41:21 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15131 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfKEXlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 18:41:21 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dc208670000>; Tue, 05 Nov 2019 15:40:23 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 05 Nov 2019 15:41:20 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 05 Nov 2019 15:41:20 -0800
Received: from [10.26.11.93] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 5 Nov
 2019 23:41:17 +0000
Subject: Re: [PATCH 5.3 000/163] 5.3.9-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191104212140.046021995@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <a9c51735-86c7-9e77-707b-74628a99f76b@nvidia.com>
Date:   Tue, 5 Nov 2019 23:41:15 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572997223; bh=7YS8VdMS5xEzFW/MqfNlabrrat+Sb6EI15l+MQ8vt54=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=BH4w6bZPLQjZuMmwkNoXX5G1YwV1PIWpWrKBu0gTOQ40Qziqvuzqu7mZ/OboYpfAF
         78C+bouQ61Jjy7SkO2HHfR6lx6XJPUXPh/92JocvcaBbaKNUuv8Afxj2xjChAg1GUC
         bVs9AWRquDPRDQmo8hF9oUBCWKqp8soD3CQpXtXo3rHmD9dq7ml4Y9+MTFKCfIYRMg
         dFJi5itJz/UHp/Vv0LD5PUEkGsOpCmFhJW1olbfrKKlEZ11y+E8T6fc+cYtm1Z4hys
         qvwaHxt7WA6PkaS6YRPVA4SMxo1zv7vF3NUIaOQBKU7hRXj2dCvMvIJCEqSHrArb80
         QrYGIofb1z4AA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 04/11/2019 21:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.9 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 06 Nov 2019 09:14:04 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests for Tegra are passing ...

Test results for stable-v5.3:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	5.3.9-rc1-g75c9913bbf6e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
