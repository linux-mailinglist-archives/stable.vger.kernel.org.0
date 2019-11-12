Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAF1F8F13
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 13:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbfKLMAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 07:00:15 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18535 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfKLMAP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 07:00:15 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dca9ece0000>; Tue, 12 Nov 2019 04:00:14 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 12 Nov 2019 04:00:14 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 12 Nov 2019 04:00:14 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 Nov
 2019 12:00:12 +0000
Subject: Re: [PATCH 4.4 00/43] 4.4.201-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191111181246.772983347@linuxfoundation.org>
 <20191112052741.GA1208865@kroah.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <4171f826-d86d-6874-928d-c9367453a1fc@nvidia.com>
Date:   Tue, 12 Nov 2019 12:00:09 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191112052741.GA1208865@kroah.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573560014; bh=gu3dc92hoJpdj8b6NW2Sia1Ni0nbzufWDxpOPaCWZ8k=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=k+b32ZvZYw4uySPLsO8q1LK2SZ3E6dZchaZbfBdl1WxMghmGSuldpy00dEYddvWUC
         MQo2/tADaqj7uXHPrtODzjutP67Zh5XtSlYE2UBDXaz7p0qZ39AaMe+CAjmKBL6vYw
         2f4izzsqNf8wW7e7illy9MJyz0vlRVKaHWGaiEf7wGwSp/RJIcwJgFFiwYPEBtaPjL
         N2Gn8uG6pqgw6dX0lU4HMki8gygYUdDnHDGHcoHOrw296APp32PlKpyetCO0L/7t//
         uicGG8RopDn6Y9ApDQK+dL8zVT6QKN7r6Fjkz8jmDSzMywf73YS4VXJ6U0GEibqedl
         VLsI4bMWXs4GQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 12/11/2019 05:27, Greg Kroah-Hartman wrote:
> On Mon, Nov 11, 2019 at 07:28:14PM +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.4.201 release.
>> There are 43 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 13 Nov 2019 18:08:44 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.201-rc1.gz
> 
> -rc2 is out:
>  	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.201-rc2.gz
> 


All tests for Tegra are passing ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    19 tests:	19 pass, 0 fail

Linux version:	4.4.201-rc2-gca1d1b5f0f2a
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
