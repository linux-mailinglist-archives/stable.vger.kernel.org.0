Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A02C64104
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 08:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbfGJGOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 02:14:12 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9488 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGJGOM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jul 2019 02:14:12 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d25822e0000>; Tue, 09 Jul 2019 23:14:06 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 09 Jul 2019 23:14:11 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 09 Jul 2019 23:14:11 -0700
Received: from [10.26.11.158] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Jul
 2019 06:14:08 +0000
Subject: Re: [PATCH 5.1 00/96] 5.1.17-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190708150526.234572443@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <65c41248-f391-1231-c2b3-9c65922a696e@nvidia.com>
Date:   Wed, 10 Jul 2019 07:14:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL104.nvidia.com (172.18.146.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1562739246; bh=47zcmkEVGGs0u7F+UgjpWdJ+PHkQ4oGZBaA2iUvqwCc=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=sRjJl0ftYApqTi5BicRxsyd3pbQgL/g9L3hp5TxtYPEJ1vKNnOsEZ9Z9OlHhIbWZa
         eMIJLi6R752QE0xboaBBm7aBe8XfwwI2TvAvL70zSGvp1OjDNHoGpUyS9KzeqC1i1O
         KQ3hlCwhMid7cYZvFHJ7K+pw8DbFIsoHlcbPZlNH5bD+veuDSIWnWdQHQ8c2UocMvj
         JraiOU2o+bIfjd65pii9OG9Tzhv0Wp6y1azO56MRc8XG3hgigY2BRDAFUiKO0q2EE9
         uyZIgmj+3ocxrD1eAEt6qB0T9PgshnrCvEsA4CcjxXN/q1hShUsGzUCYeQKNuN75KB
         wPYR5e8/rfe0w==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 08/07/2019 16:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.17 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.1:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	5.1.17-rc1-gb64119f8dffe
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
