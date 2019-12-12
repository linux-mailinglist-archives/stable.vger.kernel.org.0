Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4A511CE12
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 14:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbfLLNSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 08:18:17 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1091 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729337AbfLLNSR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 08:18:17 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5df23e110001>; Thu, 12 Dec 2019 05:18:09 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 12 Dec 2019 05:18:16 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 12 Dec 2019 05:18:16 -0800
Received: from [10.21.133.51] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Dec
 2019 13:18:14 +0000
Subject: Re: [PATCH 5.4 00/92] 5.4.3-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191211150221.977775294@linuxfoundation.org>
 <20191212100433.GA1470066@kroah.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <03e70a93-f575-06b6-f2a8-3c35af591363@nvidia.com>
Date:   Thu, 12 Dec 2019 13:18:12 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191212100433.GA1470066@kroah.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576156689; bh=4hSSrC+4saXhFscm3z7l7VvH06eA8FfoL+8C/4mM0aI=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=UMgVwL6m0b9CR3sPEfrqFqGALTgGXU9BwV6vmSI061YDbrbayshhj12uZO+/QpVPg
         9hjVEO5B7GxEhU/mM7OZ/N3MJcH0cu61KxKkawZPk6hY+Zs+e1SU6+Wzlb79OjVzqL
         JVtBIVdhmJwHsvW/Al5TFMe62QDqOA8KFIYhu/3RBQYqnJ+TlvV0pJ3e7aeBCrzYVl
         BPyYZsh/dW987Ac+CKbh4/+HUzbirlk+TEr0iZwoMLpCoV6wXRRLZaA2TfXl/+SuRA
         dUBV9sLqrTazdbwC/VXMZjvXehOjTmCZBw1GIP+e8G3xoIk95VikCdh1K9iMDfQtXu
         b8IkHpPgo46NA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 12/12/2019 10:04, Greg Kroah-Hartman wrote:
> On Wed, Dec 11, 2019 at 04:04:51PM +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.4.3 release.
>> There are 92 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.3-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
>> and the diffstat can be found below.
> 
> I have pushed out -rc2 with a number of additional fixes:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.3-rc2.gz
> 


All tests are passing for Tegra ...

Test results for stable-v5.4:
    13 builds:	13 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	5.4.3-rc2-g2d52a20a4c40
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
