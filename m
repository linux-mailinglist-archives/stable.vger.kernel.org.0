Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F301E3C0F
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 10:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387397AbgE0Ie3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 04:34:29 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18593 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388037AbgE0Ie3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 04:34:29 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ece25bc0000>; Wed, 27 May 2020 01:33:00 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 27 May 2020 01:34:29 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 27 May 2020 01:34:29 -0700
Received: from [10.26.74.131] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 May
 2020 08:34:26 +0000
Subject: Re: [PATCH 5.6 000/126] 5.6.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200526183937.471379031@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <d5c1dffe-98d3-d60e-669b-90277bbb0a03@nvidia.com>
Date:   Wed, 27 May 2020 09:34:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590568380; bh=eCJczOzJXw50OnVXon9Pjid3fsAlyDrm8Ygj/fkaOrM=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=h1KNMu/XVnIl1vo5WTH7xZEo9V2aT1R4mKchd/aVj2v+oSBvTDza3eX0sWWvIeY52
         KzRhUsZBQL/FdLW6yZ8SUF6OqcU5jkQhlO7rxkABVKwjYsSaK8xkwieq4czbkXoLbU
         6A65JuIU3X5Eh+3Fw2OVkHD174Rka3EhStIZISFgNhBAfFrFadiWDDUMLLxlSpd5tC
         k7iueYaULTIuDXBhJHA25239LRo06msrWouX7HXHMaaIwvjbQoKVmDHApcvmklIwX2
         VVvuOKzwm8befNRLP4dHSRpFwWYjDlwXgQ/jeTSZN1guTvBXpI7v7I9jXb3uEXWK5O
         DYhIcfgs5Ge2g==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 26/05/2020 19:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.6.15 release.
> There are 126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 May 2020 18:36:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.15-rc1.gz
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
    42 tests:	42 pass, 0 fail

Linux version:	5.6.15-rc1-g8f40203f4915
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
