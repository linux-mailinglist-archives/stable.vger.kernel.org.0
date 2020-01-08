Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94C251347BD
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 17:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbgAHQWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 11:22:43 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:9997 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728273AbgAHQWm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 11:22:42 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e1601bf0002>; Wed, 08 Jan 2020 08:22:23 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 08 Jan 2020 08:22:41 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 08 Jan 2020 08:22:41 -0800
Received: from [10.26.11.166] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 8 Jan
 2020 16:22:39 +0000
Subject: Re: [PATCH 4.14 00/74] 4.14.163-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200107205135.369001641@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <1dd88418-510b-ee47-4358-ebe3c54df0b1@nvidia.com>
Date:   Wed, 8 Jan 2020 16:22:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200107205135.369001641@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1578500543; bh=Fw/dCvbW8epbzb0nikJruAg605AT6QrBFgpG3lrVsDw=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=aQyETl1VjnqV/uW4vezdaOpiS9FUeeQ07qgramWlyjnf2IufPkt6uwkPFe2FLtq6N
         Be8Wv80kzMxu/MI22jzq6bDeKXaTCvhqwrkp91vK1RiPooXVqrEUpvNEGm3sTme5uT
         pJ2+kPs4e8FgWtKrKGOGuhwDQLBxjN8UjC1g4jjRAxq+1oT4x6Ry+NqLKeRiE3MGRn
         TlcCOIJlVpNlBCziMyZyqajRF6VfIeIGSoHgBi6L5QbXsETPSjCmVBliptjLx2TzTu
         kZuOyjgJBDrRCZl0o0yhtClZ+Xl/BhqSAWIJlCwE3E7vPgEXtnaYl4grfe/Rvd3lGX
         SfR9/GWumK7Dg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 07/01/2020 20:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.163 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jan 2020 20:44:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.163-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

All tests for Tegra are passing ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.14.163-rc2-ga95271edf2c8
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
