Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9AA4B450
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 10:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731244AbfFSIqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 04:46:39 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11041 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731136AbfFSIqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 04:46:39 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d09f66e0000>; Wed, 19 Jun 2019 01:46:38 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 19 Jun 2019 01:46:38 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 19 Jun 2019 01:46:38 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 19 Jun
 2019 08:46:36 +0000
Subject: Re: [PATCH 5.1 000/115] 5.1.12-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190617210759.929316339@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <0d1686a1-8f7e-a131-be69-89d5a4439043@nvidia.com>
Date:   Wed, 19 Jun 2019 09:46:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1560933998; bh=AYb22n0UqOZnyy1UAyQVueYgWc6XRaW/bgAibAg1QGw=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Sr0j6cUOvXlu+VkOSi7Ah9k5eipCLIpKa36MlZ24cP7KiEZzH9ZTbUKrr+sN2Nsyu
         PFfWRDZYy232IAS//oW3ps5QsqznU5fpXJh3a0D+KxMBNZuAgiGsOddosEOQNdkY1y
         ZeFtGKR6HlqcGMO8pOrTds6dUyJYJ9nyar2JrytbdXPxSvT/iTi0Ze9YVhlwFSJCbi
         VVzMjKE6VhTi/1xEvZ4PFxX+r1hvPbCRX56LKTwd+JsI55vrZK8Aihkk7Zcp3uTJD/
         I8M2y8/YtzttFJrRcdQL47/cRe9v26eMNmlSALmP+w3TrIZY2bXlnVjW0bIL0f/myy
         L+peMIY5fhYhA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 17/06/2019 22:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.12 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 19 Jun 2019 09:06:21 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.1:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	5.1.12-rc1-g760bc74bb0d3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
