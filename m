Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50C11337E8
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 20:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFCSdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 14:33:50 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15187 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbfFCSdu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 14:33:50 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5cf5680c0000>; Mon, 03 Jun 2019 11:33:48 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 03 Jun 2019 11:33:49 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 03 Jun 2019 11:33:49 -0700
Received: from [10.26.11.157] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 3 Jun
 2019 18:33:46 +0000
Subject: Re: [PATCH 5.0 00/36] 5.0.21-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190603090520.998342694@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <1b2e0b8f-dce7-c829-7c69-ea9550a3d010@nvidia.com>
Date:   Mon, 3 Jun 2019 19:33:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190603090520.998342694@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL108.nvidia.com (172.18.146.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1559586828; bh=oI7xHfAkUTVg+QxW+zVCtnfr5y5ban5i6ZfoWPsUfSc=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=W+h0iSxV5Pyctytbyfn2QYdnPtaYnSeYPEsojED92Pk+rwUpZb/xaEj1WmFXOQBxg
         chlpKezNCUq2e0fyc/LXSkKgGbsvr3HMCzMQZKkC5Qrm+LPSHXfO15sZ3BGj5CHcKd
         vXF9FU845kSFwLIkaeQPHBXvglAXO8cOebsCpYyjPj3gGVvzr5UfwooOv1Og9ifVd9
         mYF9k2cnAyk9sSTO14fgyPm1J7esyqv84z2tMhb9xZ9WdCt7EqG9V1FDShP7CF/2iU
         1URokRa9plBW574DPJxjs+U3Ryrsj4NSDt/ddlsaBWjSQg9T6AWzsKS56cwoEg9ecI
         0XvxmIYCLXRBw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 03/06/2019 10:08, Greg Kroah-Hartman wrote:
> Note, this is going to be the LAST 5.0.y kernel release.  After this one, it is
> end-of-life, please move to 5.1.y at this point in time.  If there is anything
> wrong with the 5.1.y tree, preventing you from moving to 5.1.y, please let me
> know.
> 
> This is the start of the stable review cycle for the 5.0.21 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 05 Jun 2019 09:04:48 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.21-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.0:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	5.0.21-rc1-g9866761
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
