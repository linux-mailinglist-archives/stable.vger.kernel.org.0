Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4191F532F
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 13:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgFJL31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 07:29:27 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:11492 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728458AbgFJL30 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 07:29:26 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ee0c3e90000>; Wed, 10 Jun 2020 04:28:41 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 10 Jun 2020 04:29:26 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 10 Jun 2020 04:29:26 -0700
Received: from [10.26.72.59] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Jun
 2020 11:29:23 +0000
Subject: Re: [PATCH 4.19 00/25] 4.19.128-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200609174048.576094775@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <45eb2e54-1d7a-5efe-be25-4dc68e05fb41@nvidia.com>
Date:   Wed, 10 Jun 2020 12:29:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200609174048.576094775@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1591788521; bh=+8TnYxxgKfuC3u0+G2O9hI9CBDTMzD84ggYwlvEl67M=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=PQ6rOLWQ8ArebURB1BdzS3+5JHu9Vdfc559R6Fhyad8R2tHl+zIREGfFRiUI60mKO
         zaYY7NfiAr5cKVQTQ2A2aZfI0/dw561A+4xqV1iXgaqyxpezuGVcy/CpZAnRDZMuK/
         O9NzHgLmsxYu6XBgmBibmZyiC4dm79WBMDcA36Wvc1AFCZMpaeP+TuLwDBsNxcBH1t
         /cu7L8213rnXhutdsUDbbNhplA8s6aWezuXrtFBhSK2Ah1dno9p1O8Tjdf2jcXf7fe
         AVg27IARwgNn2b6egmIlaRF3aQGEcpDYbsLATiAQ+3hh+NryE50Dcuho6oH6b17kk1
         FHZUwvNZsrMug==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 09/06/2020 18:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.128 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jun 2020 17:40:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.128-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.19:
    11 builds:	11 pass, 0 fail
    22 boots:	22 pass, 0 fail
    36 tests:	36 pass, 0 fail

Linux version:	4.19.128-rc2-gf6c346f2d42d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
