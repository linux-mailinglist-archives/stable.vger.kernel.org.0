Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77EF32182BA
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 10:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgGHIli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 04:41:38 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13089 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgGHIlh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 04:41:37 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f0586b40000>; Wed, 08 Jul 2020 01:41:24 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 08 Jul 2020 01:41:37 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 08 Jul 2020 01:41:37 -0700
Received: from [10.26.73.185] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 8 Jul
 2020 08:41:35 +0000
Subject: Re: [PATCH 5.4 00/65] 5.4.51-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200707145752.417212219@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <6fbcdd30-68d3-e8c5-d762-7b8a8c48d112@nvidia.com>
Date:   Wed, 8 Jul 2020 09:41:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200707145752.417212219@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1594197684; bh=OLAVjACBHPac/O+/ibthi0narYKfvDiOAO7o1+ULSHk=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=SJzR81Su2CtlV3w0TQWBW0kD+u6JgEKF1ZUQrK2L26EXrAFOe6LZJ7BYGE8DjHSJf
         mr51GEceVCZr5wMgYbsB3XpQTlpc3JsnaFqeixxFIIEiYiHEOdJSrp/q3de3d0aAQf
         ZqbQ4xk62S2FSVTqhAMh8EQRA3ZMDiEDCFswOmP2djUYSC5aUQ8JNp2FptwSuaKqsm
         3d8TrefUJBxHm87BiJK8wYtCM8bP8eXW8QNa9TaGd1HozXuA6olEO0NwV13OWqbNKO
         gD9tCQE3TSCpSwUzIGDcC0uDKQvbIjBN7AYC8aiOxZnsZpobnPGEZNmjpwmwNDvyIY
         LooJIiyPfBW9Q==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 07/07/2020 16:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.51 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.51-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.4:
    11 builds:	11 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.51-rc1-g47d410b54275
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
