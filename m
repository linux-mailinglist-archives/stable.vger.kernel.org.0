Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04BAEAB34C
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 09:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392502AbfIFHhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 03:37:15 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9319 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389819AbfIFHhP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Sep 2019 03:37:15 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d720cab0000>; Fri, 06 Sep 2019 00:37:15 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 06 Sep 2019 00:37:14 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 06 Sep 2019 00:37:14 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 6 Sep
 2019 07:37:12 +0000
Subject: Re: [PATCH 4.19 00/93] 4.19.70-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190904175302.845828956@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <2a960a0c-f907-a515-7aff-6023647fdda4@nvidia.com>
Date:   Fri, 6 Sep 2019 08:37:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1567755435; bh=eZwkne6pGd9YDNyfTFRx8zjgs3nnyHRQQ08LTLTpsyI=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=N+Wike3DBVGBqBzsYdqhmCrsWYg5h7Wp8+//Mu+vL5+WQvlDLk4eCJXUq86MIHUl9
         VkwE7MFQ8R1+qsY/7OBbGsCfopLndFVUy/r/1bekYxJlFVR7jA0w0lRcJi3l0lon75
         zpYCwgixiLVjNqqD65jTA49XSCF/Pn5V8Gglv8kBGMMIeq7RRzPXBNqoVloi55zfHF
         9HS+X4I8Itfz/5xKJi4C3zHCwYFQ+CNk335nmZ9Sw9ZWKHW4G9bTuwIjaAI3ednAvQ
         QDQQGbmbVym+DjrcmTRi/+H5Nfcf8EL/k2n5ganEcNhHsQAqZ3XVklCQT3GpdDL/T7
         W7Ao1IR/N/ayQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 04/09/2019 18:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.70 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.70-rc1.gz
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

Linux version:	4.19.70-rc1-gb755ab504136
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
