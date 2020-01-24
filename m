Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63B9A148D7C
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 19:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391045AbgAXSH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 13:07:56 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11334 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391024AbgAXSH4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 13:07:56 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e2b326d0000>; Fri, 24 Jan 2020 10:07:41 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 24 Jan 2020 10:07:55 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 24 Jan 2020 10:07:55 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 24 Jan
 2020 18:07:53 +0000
Subject: Re: [PATCH 4.19 000/639] 4.19.99-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200124093047.008739095@linuxfoundation.org>
 <23f2a904-3351-4a75-aaaf-2623dc55d114@nvidia.com>
 <20200124173659.GD3166016@kroah.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <8a782263-aca3-3846-12a0-4eb21f015894@nvidia.com>
Date:   Fri, 24 Jan 2020 18:07:51 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200124173659.GD3166016@kroah.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1579889261; bh=v4oPTR2YZWxHlL+tTFjcNkmCCof+ja1sD/+qaxtlzAA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=n3qnwZz0CZL/XmU/8R8VCRRVCRsOhZ88HDYYtAW9jlgbr9XmN5nngUFcSPzgZNBtx
         OEeg5I+J/ZNNbaTMCnEEluRm2AnsFIa5ttlIrk3Q7WJ4n9rhUS+iBNMXj9QmFZ4nKd
         vggSxpi7XFeFpMPHRM+Hc0iyA80zkEnn8MlMcO9h5lbFrTIwFvkFZPBEAx/GRf3+Cc
         eX2vQLlJghbufGAWiXOFk5/4pgoLuuumFkpoyYp+MULaWLXC+qh3C8PQ8/Xi1pJZeZ
         tJNrQKY61A9awhsZ8lgXaWvCVHQKc5tOlOyX7ZLYzjXZCJS/gWfUg4FI0PVBNKc9fg
         t4/8wCnrvA+pg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 24/01/2020 17:36, Greg Kroah-Hartman wrote:
> On Fri, Jan 24, 2020 at 02:50:05PM +0000, Jon Hunter wrote:
>> Hi Greg,
>>
>> On 24/01/2020 09:22, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 4.19.99 release.
>>> There are 639 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sun, 26 Jan 2020 09:26:29 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.99-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>> -------------
>>> Pseudo-Shortlog of commits:
>>
>> ...
>>
>>> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>     PCI: PM: Skip devices in D0 for suspend-to-idle
>>
>> The above commit is causing a suspend regression on Tegra124 Jetson-TK1.
>> Reverting this on top of v4.19.99-rc1 fixes the issue.
> 
> This is also in the 4.14 queue, so should I drop it there too?

I did not see any failures with the same board on that branch, so I
would say no, but odd that it only fails here. It was failing for me
100% so I would have expected to see if there too if it was a problem.

Jon

-- 
nvpublic
