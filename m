Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3191511F9
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 22:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbgBCVk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 16:40:26 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14032 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbgBCVk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Feb 2020 16:40:26 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e3893320000>; Mon, 03 Feb 2020 13:40:03 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 03 Feb 2020 13:40:26 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 03 Feb 2020 13:40:26 -0800
Received: from [10.26.11.224] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 3 Feb
 2020 21:40:23 +0000
Subject: Re: [PATCH 5.5 00/23] 5.5.2-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200203161902.288335885@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <10cd3c5f-0a2a-f73c-f071-17d1cc33531b@nvidia.com>
Date:   Mon, 3 Feb 2020 21:40:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200203161902.288335885@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1580766003; bh=3TYh/+aUvFUKSSNQGZDQVMaqpDp0RF3uw3k0ih4gKYE=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=CfPGYVqV2eeZix3gl3jz9/wOjWYQ/jtZHKPXsdLjvOkNegNphR06oTUE7N2L6rBkf
         okOlwxSxLa0SDyz8CpW39lKe0MDyBQBvKcVHQbfgnUFP4bSKHY7q+RJ2dv9mNrtIQM
         GaG9D7BD088A6gBqPp9e1lVK1blwZYIlbfdD5kA4U3cCqpxmn0gPwSntIju1Jnf6Db
         Dxieh5uyKNMpOu+urDotuuuLWpRAo8Ee036AEo3RD/3RzcaSvYbDAerNM1GjKMD2vj
         sw0owKqWFa8exyLDHlH7eCN179AqyAGDa+WZI8FkI14KRImxkHH1kklHylbVT6lkGa
         fjauqJWD5Ws4Q==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 03/02/2020 16:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.2 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.2-rc1.gz
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
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	5.5.2-rc1-g8dc0cb8ae177
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
