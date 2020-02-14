Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7D3015D58B
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 11:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729111AbgBNK0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 05:26:41 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7559 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729240AbgBNK0l (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 05:26:41 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e4675d00000>; Fri, 14 Feb 2020 02:26:26 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 14 Feb 2020 02:26:40 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 14 Feb 2020 02:26:40 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 14 Feb
 2020 10:26:35 +0000
Subject: Re: [PATCH 4.14 000/173] 4.14.171-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200213151931.677980430@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <1b59734b-19cf-64fe-e4ed-596b5a46a3d0@nvidia.com>
Date:   Fri, 14 Feb 2020 10:26:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1581675986; bh=IMD3XZ5HTvMiLedOn8BSac4hnCVTvp/oySGQUDucXGs=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=d6oWcnxK8DxD9xKgEdoMbIBK4kjYT6CrSTi/0b6RGG/OuGQEP7zWoWXwkeDwzKv8L
         mvvRj5I7lpo6/abuNY9MTZLrVpTe3hNGID0psYEMLQeqlZW1z5NHQIDO83l8n/OtMH
         SNGH/F+wanYAfCstmX1R2haQecFfvpGCAcwp18ssd+zzmSMItNO5j3qaIzqCgPcU+V
         uzoS+pEN06XZBbxti1xAsiAfwztBhmS/i68KW7XIPVzd9TbaKJfTqzNyD7nTqVYa+B
         r2npyC/0hah24kU0nN3wJScQHVdcPDZ3hW67Yyb4K0kfl24uBhQlZoYPxYPlEtWUtP
         5RBF0l3/NuhQg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 13/02/2020 15:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.171 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Feb 2020 15:16:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.171-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.14.171-rc1-g2874fe097995
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
