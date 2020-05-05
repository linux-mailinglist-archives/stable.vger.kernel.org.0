Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204F31C507A
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 10:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgEEIhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 04:37:34 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14619 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgEEIhe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 04:37:34 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eb125c10000>; Tue, 05 May 2020 01:37:21 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 05 May 2020 01:37:34 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 05 May 2020 01:37:34 -0700
Received: from [10.26.73.45] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 5 May
 2020 08:37:31 +0000
Subject: Re: [PATCH 4.14 00/26] 4.14.179-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200504165442.494398840@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <2c269c56-31d9-737f-03f6-9da448fd1206@nvidia.com>
Date:   Tue, 5 May 2020 09:37:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200504165442.494398840@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1588667842; bh=z2wzyQbtBCsaPoGACqHOCFPgFG31IFkXxMBYj/lHLpI=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=MY170NPC+Hgm3sZw5zqvvmZcdZ0ciPpqi6tWxwaHwdmUiRu5jhhnlaJ0kYt8roWXR
         XYLsa+k2YUJIXOyXXYq2+sfP3pgW6eM3UVOcwGwpObNiLZ8scZ+hS1UI6lSaCmn1/P
         7SiR4jKrben6Ww0FphbWiQY3hG7H1I8OK+x3kH5fH9l92g9U/muVm/F7hNGrnm5+px
         xaKwjx4xvya9Kde+AzQndxsneP8dv1/XCLwPbLk//MHSxAmZOCPullRdk0yv+y4TAn
         YJSwU//XCf8qOKa0ssL/C2q/CEPLrHyL7b8DgAjM+xIEu56Pley1b94QJTLur/iD5n
         +SQsxPp9Tg/Ag==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 04/05/2020 18:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.179 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 May 2020 16:52:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.179-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.14.179-rc1-g6d39cf919746
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
