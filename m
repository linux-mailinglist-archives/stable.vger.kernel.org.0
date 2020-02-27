Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A468D172815
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 19:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbgB0Suy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 13:50:54 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:6501 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729172AbgB0Suy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 13:50:54 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e580f800000>; Thu, 27 Feb 2020 10:50:40 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 27 Feb 2020 10:50:53 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 27 Feb 2020 10:50:53 -0800
Received: from [10.21.133.51] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 27 Feb
 2020 18:50:46 +0000
Subject: Re: [PATCH 4.4 000/113] 4.4.215-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200227132211.791484803@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <0dda68e6-8bfe-2848-7db8-51691eda147e@nvidia.com>
Date:   Thu, 27 Feb 2020 18:50:44 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200227132211.791484803@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1582829440; bh=7WeUF2Hi49Ibo6G2pkSbWE+GO8+KpLajDv9vGQsnAM4=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=OYotaRKwFEMM7IXbhMZ4CwgSN9pH8Js5Me+0Owa7UDQQHHF0Ex3ClheWJQh7HDcC1
         4K/cAYd9NGT+MSDC0GAkpY9ucAXe68XgfJznYHfO93uBQu9kS68OlQVnAKnE1GfcLH
         K3OBhNNDk7GzSiIWOi9dVVY36uM3HKXfvJQa2rvW6pD6y7BE528HtR0GGYBLkBbq60
         lfXgOu0N52rIF/Mo8ExI2lyUHq7MjIQGMPYWTWR+kykOfEpwuC1eMKAxzjdR8dFbPE
         iSGimA3iJSRZn1NXIY5vwCvlrzpj+DPUes23oIWr8n54e368LhUNnl9Wh8Y++/5sme
         fPvwV8zswQffw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 27/02/2020 13:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.215 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.215-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


All tests are passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    19 tests:	19 pass, 0 fail

Linux version:	4.4.215-rc1-g68572b1fc85a
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
