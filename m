Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1428C139521
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 16:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgAMPrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 10:47:12 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14825 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgAMPrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 10:47:12 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e1c90eb0000>; Mon, 13 Jan 2020 07:46:51 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 13 Jan 2020 07:47:11 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 13 Jan 2020 07:47:11 -0800
Received: from [10.26.11.97] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 13 Jan
 2020 15:47:08 +0000
Subject: Re: [PATCH 4.9 00/91] 4.9.209-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200111094844.748507863@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <fe9978ff-4d09-f17f-e335-9636b603bf84@nvidia.com>
Date:   Mon, 13 Jan 2020 15:47:06 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200111094844.748507863@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1578930412; bh=VXleV7IGqElsE4+5KIuqk0fYBNQdoDUzMz8rG+9LxEI=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=QX+LLLehS9laoaBC48VD/R3P+rhETppCjwQ5l9uXFCI+TPGGoj1nBLBOHqyKSULjU
         YHP9Wk9cYMC2AbmuSVULih62qRsZmgg26f7eTTVP+SHQfQQU3HZ3Cw/4XdrWi5jHMY
         e3SwdD/fmu7782vXyXXTnu6Pbbb9qGKhgMLFFFqgGNoOEuetFlG06yTFdr9QbJQXZj
         Zv7T2VLE8sqB2d0LiVtjxqp3HHgBt4QnsUnHCwJ8UDJH1H+EEp1HgXFDuymkbUhnj2
         PjJGfELz5WUcloqnArLAg6lBXXk3aiRMmtaFho9bLqkhjk9EMwa0LOdr3YAgdDZyOy
         HSOKK6mQCpLRw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/01/2020 09:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.209 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Jan 2020 09:46:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.209-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

All tests are passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.9.209-rc2-g0dd28c11952d
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
