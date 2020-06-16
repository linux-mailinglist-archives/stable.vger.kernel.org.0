Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD451FBFEB
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 22:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgFPUVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 16:21:14 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13852 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbgFPUVO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 16:21:14 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ee929ac0002>; Tue, 16 Jun 2020 13:21:01 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 16 Jun 2020 13:21:14 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 16 Jun 2020 13:21:14 -0700
Received: from [10.26.75.222] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 16 Jun
 2020 20:21:11 +0000
Subject: Re: [PATCH 5.7 000/162] 5.7.3-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200616172615.453746383@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <77015800-d0a2-38f7-e70a-e6dcbc6325f9@nvidia.com>
Date:   Tue, 16 Jun 2020 21:21:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200616172615.453746383@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1592338861; bh=j6RgMiyZhoUQpXwvzKMM+XqwB9kk88z1ChkrQlLH4rk=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=lo4R6hnQL1XrfnBXommLXRsrPi5ZicPsaGHEiIlkBSWkuQHt/vc0hG1xdeosyw7Gb
         SrqFQFfpi0RYqLE6fAC5pCAcbNr9xOpIhUGLRsTyuXLno9az1sJ1ls5fdXbHvWYwyp
         A4CTz5I3goaV3/CWYpPwLoEfMVyzGPiHQ++4LqLICRP1o1+MMt/2XtQiblytn3HK1a
         XzjyT7rXEdXeVbawbjUPomw/VmQAmaE135+OrW59cyzRDviQdEdvoFqThyAtZ5UPH+
         v+SYwvPQl8AuUjQ+6/0lkZ4aqtUjMfaYeCvBvLmvotaP37k1R66k2FTihETmc8zUfm
         lE01w5XIrcbtA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 16/06/2020 18:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.3 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2020 17:25:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.7:
    11 builds:	11 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.7.3-rc2-g55b987cbccd9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
