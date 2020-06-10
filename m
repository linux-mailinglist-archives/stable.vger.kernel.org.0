Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7473E1F5339
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 13:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbgFJLaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 07:30:08 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14044 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728393AbgFJLaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 07:30:08 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ee0c4320000>; Wed, 10 Jun 2020 04:29:54 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 10 Jun 2020 04:30:07 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 10 Jun 2020 04:30:07 -0700
Received: from [10.26.72.59] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Jun
 2020 11:30:04 +0000
Subject: Re: [PATCH 5.6 00/41] 5.6.18-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200609174112.129412236@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <1b13360b-b956-2ac6-e683-c7965cf11f81@nvidia.com>
Date:   Wed, 10 Jun 2020 12:30:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200609174112.129412236@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1591788594; bh=TRfD55qFMe0zUJij/og4Yji1xpSaZ+fbLjo/4y0i7+o=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=J0DE6DxwfsonawXR894y0VW1CCyA92dKa+92IGMseY2DmTnYAdDbK0f6HdkgCDhBq
         TyNlLiIYoJm0p3AMwtJBtnOZNKnOl/EsvkfYb3tACCdKPrCqp9yd4NMVzRSxtu8SP8
         qhIV4Lf0qLehAK8os/npqZr3qYq1+1zvsJ0nm1A07sncHksT/2/XO5csH+k0wy6KNd
         ydH2jLmTV8ms1sGdui06pdsXlDppZJevDFmcGP725aQngriLds4oI6AFS4EDQFpcxs
         ZdZlrOS1BzFLiO8ZJCZXIiPXYCus9HW99XU4CPzQznCBn5nUx94Ne0WbrPkW6lCkT6
         hVfgUX0DQLxdg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 09/06/2020 18:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.6.18 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jun 2020 17:40:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.6:
    11 builds:	11 pass, 0 fail
    26 boots:	26 pass, 0 fail
    50 tests:	50 pass, 0 fail

Linux version:	5.6.18-rc1-g1bece508f6a9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
