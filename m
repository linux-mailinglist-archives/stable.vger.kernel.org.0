Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33C21B235A
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 11:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgDUJzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 05:55:24 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:19197 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbgDUJzX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 05:55:23 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e9ec2970000>; Tue, 21 Apr 2020 02:53:28 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 21 Apr 2020 02:55:23 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 21 Apr 2020 02:55:23 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 21 Apr
 2020 09:55:22 +0000
Received: from [10.26.73.24] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 21 Apr
 2020 09:55:18 +0000
Subject: Re: [PATCH 5.5 00/65] 5.5.19-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200420121505.909671922@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <7e279a95-d7f2-e8eb-cfbe-fbf0b32b2752@nvidia.com>
Date:   Tue, 21 Apr 2020 10:55:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200420121505.909671922@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1587462808; bh=JlnjVIyaBCfx4ltNfhJvPinLB8HoqjOBu/5yHID6SEc=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=qVRxFpxpBEBLprBX4eHch8DwuucO0okp+gVvboOjNVzy79znzX/1ui7/w8SG3twPd
         nh0B2QrB/uPW2BO1JLFQ9RfYUK1GBQiGn34No47NkMHkiHoRt/Gthjp/sMDaQ4bkw8
         PTMCq0vPaZmMIp1X9C9nYlPMO6XY05DfmfGX8RbTVVuZNIRIEyohdx5GjDQQxbjD1m
         Y3aXREfAscLgVW7KWiHk0nSGXhfx09GNS6WVoMzFUN/shZjx4K6pCemIqR2lt0GrvH
         dCqdUJVpIVYrxdebS2pcxX8EJdPbnAxoqZmtblgob5uBE5ZNn9pCkFWo9Jc4jGY2Dj
         IfTn/vbrTjW5A==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 20/04/2020 13:38, Greg Kroah-Hartman wrote:
> --------------------
> NOTE: this is going to be the LAST 5.5.y release, after this one, it will be
> end-of-life, please move to 5.6.y at this point in time.
> --------------------
> 
> This is the start of the stable review cycle for the 5.5.19 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Apr 2020 12:10:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


All tests are passing for Tegra ...

Test results for stable-v5.5:
    13 builds:	13 pass, 0 fail
    24 boots:	24 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	5.5.19-rc1-gd1734e95ac8c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
