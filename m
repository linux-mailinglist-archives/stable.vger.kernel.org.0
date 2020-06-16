Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94D71FBFE7
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 22:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731646AbgFPUUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 16:20:41 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13809 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbgFPUUk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 16:20:40 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ee9298b0000>; Tue, 16 Jun 2020 13:20:27 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 16 Jun 2020 13:20:40 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 16 Jun 2020 13:20:40 -0700
Received: from [10.26.75.222] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 16 Jun
 2020 20:20:38 +0000
Subject: Re: [PATCH 5.6 000/158] 5.6.19-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200616172611.492085670@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <a29e265d-bc23-732c-a795-e89e153d23eb@nvidia.com>
Date:   Tue, 16 Jun 2020 21:20:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200616172611.492085670@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1592338827; bh=6D/67igiXSAH2Xo68Ry5AtFQo+ljJK9Gng6m2ERTOUo=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=G0q47/ItIb0nA4x7ZBWkuJlGFgNUGzVlYXXHbLQnIhsHJygbzA5wsS/0ShA8MO0li
         dxkadPYfia7YAe+9e45KK/xGSluwzC+5XrhliObMsuyXy9MdufXrAtM+tzwdl3+hEy
         XJL6xoomD0rKr2L9MRTmcW8nPtFZPUMMK7lx7RfaHVdbqUpKhcTm54uGC69U8nZSek
         K0BWw0KV3uQBIHjnFqVEsc7fwjk0kck3ygd8R0htffvw2UnGiX/qDAlS34B2GwJeWc
         YWVx59KBly2lGzSJS1/L465ic3T/QtRhw8DaB6hSjelq4Kzcsf9Ip82UzETYmdGtdo
         nCDqwV/FWqGDg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 16/06/2020 18:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.6.19 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2020 17:25:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.19-rc2.gz
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
    24 boots:	24 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.6.19-rc2-gb60e06c98873
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
