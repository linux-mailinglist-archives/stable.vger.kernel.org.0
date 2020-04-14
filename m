Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4CC11A78A8
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 12:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438554AbgDNKoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 06:44:05 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17364 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438550AbgDNKn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 06:43:59 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e9591d40000>; Tue, 14 Apr 2020 03:35:00 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 14 Apr 2020 03:35:58 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 14 Apr 2020 03:35:58 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 14 Apr
 2020 10:35:57 +0000
Received: from [10.26.73.15] (172.20.13.39) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 14 Apr
 2020 10:35:54 +0000
Subject: Re: [PATCH 4.4 00/29] 4.4.219-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200411115407.651296755@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <63b31c56-b5c9-2ced-ee00-772fa9a1dcaf@nvidia.com>
Date:   Tue, 14 Apr 2020 11:35:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200411115407.651296755@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1586860500; bh=wc5RrsSn49RxdciYOKQhAVVgiFmPrVsNjOlrDRUtw+4=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=GOgLo8PUxB7kyLRS26OzHHazN5wgHn/I6uvs5RED9i5PQIj+c4aviQxwu57vqw4V6
         9uF2aBpz/iP4Ttko7L9FUVZcMLT35ZIJnzUqRRIfe/PdKBDj2VzjSO1cegZPw0hdPM
         q/7YHGFP7afn3im8kt5PoQoZvrlcvsmJzm1hW8SXyEIHridXAGMnwvK9a+qYJauGG1
         wGPSNtVeF3Uw8iO5NQb0eb+mCaMMvxUdKWLvIfuby3UGrUBYzwMdmW+/XtShtLpGgk
         Dnm3O3kB3Cje4HErp5+gJ93W+oTvnLUlOAfKsAlzcsfeAjBuBx2t5qeLqb8qG+KYij
         OPqhIfFB1mIdQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/04/2020 13:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.219 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Apr 2020 11:51:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.219-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


Sorry this is late, but all tests are passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    19 tests:	19 pass, 0 fail

Linux version:	4.4.219-rc1-g8cd74c57ff4a
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
