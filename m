Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5C624AD0
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 10:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfEUIv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 04:51:56 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5089 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbfEUIv4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 04:51:56 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ce3bc280000>; Tue, 21 May 2019 01:51:52 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 21 May 2019 01:51:55 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 21 May 2019 01:51:55 -0700
Received: from [10.21.132.148] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 21 May
 2019 08:51:52 +0000
Subject: Re: [PATCH 4.19 000/105] 4.19.45-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190520115247.060821231@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <9ab1510d-2267-597b-f535-921d5222a3dc@nvidia.com>
Date:   Tue, 21 May 2019 09:51:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1558428712; bh=mcfKx22kMNO+4c4sL36djKvHbw1MN3LZjtcdvVrU0Ic=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=NOhmqr3rmwScoqtQcCKwotm3f1hKvYgzZr8LkfLVFqV7OBy/4crZ44+vXsahwUQt6
         mHGBJzmaoMsulh4HNTngIjN6mo5zeK6rCO++4TRCkp/qediHZ43t629AIyBENQmFbh
         QEXurlGnRHBcFZyq4SOQINJOqx7q9F5QhDBDCZKA01uQfNu3HGLMxpOi7j60norGI2
         LIL+z/WWYBvp+mAxZVm8SwfgX9ipd1NbxgY5IvbvhfESHcTCuVoHgA9Ha8A9/Vrmcu
         w2xH+owTTE7tkuA9leB/WV97EXYe2zPDutVCAPo2apO4V5K2+YVbpGZ3/SlVzLpcP7
         Y8CkLmUxfEePg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 20/05/2019 13:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.45 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 22 May 2019 11:50:49 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.45-rc1.gz
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

Linux version:	4.19.45-rc1-g6b27ffd
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
