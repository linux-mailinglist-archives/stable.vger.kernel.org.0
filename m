Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5752182AA
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 10:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbgGHIkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 04:40:00 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12978 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728121AbgGHIkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 04:40:00 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f0586530000>; Wed, 08 Jul 2020 01:39:47 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 08 Jul 2020 01:39:59 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 08 Jul 2020 01:39:59 -0700
Received: from [10.26.73.185] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 8 Jul
 2020 08:39:57 +0000
Subject: Re: [PATCH 4.4 00/19] 4.4.230-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200707145747.493710555@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <4d2606a1-1a35-31db-3440-11793103e2ec@nvidia.com>
Date:   Wed, 8 Jul 2020 09:39:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200707145747.493710555@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1594197587; bh=yS02Vsb9bWJf3Visd5mCOgiND894kkzAjZsbD0PYZMU=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Aat7/UYDFKB5OPXvsGQluUGvBVFPNBPon67NMH0EYMJewXM+DxkWVi6RFbmuhxQY7
         IDYYQMMscWT6pTTlXTnBQRsA9E0c7pXnCfcUNew3Ub+ZC5/A3A1eW2GMnwQnfjS+dg
         0Xm3EtIhj76A6ZZiNVKx0DTno3PTF20Pw5jrGeDDwisfP70Kzs5nG1/EhnN9iPeAwe
         8TTvxheuDk91O7iPUoSj7FldBEzB5Ew1kWijcNruTQPkxQd80tLkk1BvYBCN2E0yg9
         TYIIldGa7BHEoQ/t1MmdawyJfPZFPTWkxjwgiNpos38T6Y8IdxXR7lnlmxPgOCed1s
         vcLA/Bz+e01Sw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 07/07/2020 16:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.230 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.230-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


All tests are passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    25 tests:	25 pass, 0 fail

Linux version:	4.4.230-rc1-gc19eba6b3434
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
