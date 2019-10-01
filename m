Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D16B5C3852
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 16:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732196AbfJAO6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 10:58:23 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14202 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731547AbfJAO6W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 10:58:22 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d9369960000>; Tue, 01 Oct 2019 07:58:30 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 01 Oct 2019 07:58:22 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 01 Oct 2019 07:58:22 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Oct
 2019 14:58:21 +0000
Received: from [10.21.133.51] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Oct 2019
 14:58:19 +0000
Subject: Re: [PATCH 4.19 00/63] 4.19.76-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190929135031.382429403@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <90fc5da5-40f1-03da-785a-2c2c6ce45702@nvidia.com>
Date:   Tue, 1 Oct 2019 15:58:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1569941910; bh=OAyFu/sXs+v97VxHorpaWaVf/KV7sAEw5I17l/FRu/M=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=WXRQ0P8/xZrGiD5GUkRSOLPYyVJIJZ7SHSWXMdn8HguqgKcidbhmUDVGV5PvE6UX7
         A2tzEIke3pmdgHFrsXMI8JpvbYt9spO+ROZo1XZlqMzZ+qrUttLSQ2WVynCkne0z0P
         1TSLVnJ11tFNZimXvFUmzBQh0Z1vGoE3lj0X7P8X5GEV7p6c9ZQiBXq7q1E2J8C4He
         /HThNke+YyTPnK2RYRhCDRytKkeeAH6EjBUHhsH72vRGmr7n2Xq8vVBUqMvo4cd7LW
         MBsQuZZpdP1Ii+WSFWyhYpSA6VNWrxibnNwvTVgLoEsDmhRIJDq7dAuBgCEHpVXSbK
         HhQ7dkHEQtHMg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 29/09/2019 14:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.76 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 01 Oct 2019 01:47:47 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.76-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


All tests are passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.76-g555161ee1b7a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
