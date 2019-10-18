Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF0B9DBF1B
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 09:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729939AbfJRH5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 03:57:51 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7879 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728064AbfJRH5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 03:57:50 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5da970810000>; Fri, 18 Oct 2019 00:57:53 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 18 Oct 2019 00:57:50 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 18 Oct 2019 00:57:50 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Oct
 2019 07:57:49 +0000
Received: from [10.21.133.51] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Oct
 2019 07:57:47 +0000
Subject: Re: [PATCH 4.14 00/65] 4.14.150-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>
References: <20191016214756.457746573@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <55b4d8c4-a8f4-67d3-b35c-d8dd6f6dab3c@nvidia.com>
Date:   Fri, 18 Oct 2019 08:57:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191016214756.457746573@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1571385473; bh=KKH1RYsAHTfHmilhtwWnVOb92wimMTleKCDuZYI2cyk=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=fHx5zxPWH9ytAsd5dzdMOf0P678qbzifq/2q+xof1ZxIR1zzSWfEX4aifMxjm1gSe
         YwDyPb5qn5S0XFXgtHxRVZeSh/czhuvoiuQUUQJWH7Ir+E9f9TH/7UfuYmutYotaVm
         oOMaGLQtVyWF1RBhwksR0MKNJMruu/UYY5ad94tPszw9qGMLCGXZWLi2QMz+ljVppw
         ZEKdX2meDV1Ayskii1fkQzj7iUcpA0zXrF72mOZ45Erkr2gyTt9eaepsacyCfw/+/8
         yufJEOMPh9RIgU6FhASoKPBJk8nDo+9VJ4GCxD0POr8etxmMihTVNvTBLBcI05Npgq
         GteotrMrKbVkw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 16/10/2019 22:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.150 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 18 Oct 2019 09:43:41 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.150-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.14.150-rc1-g66f69184d722
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
