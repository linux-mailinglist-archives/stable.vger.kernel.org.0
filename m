Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05968528DA
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 12:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbfFYKAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 06:00:37 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:9058 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbfFYKAh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 06:00:37 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d11f0c30000>; Tue, 25 Jun 2019 03:00:35 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 25 Jun 2019 03:00:36 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 25 Jun 2019 03:00:36 -0700
Received: from [10.21.132.148] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 25 Jun
 2019 10:00:31 +0000
Subject: Re: [PATCH 4.19 00/90] 4.19.56-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190624092313.788773607@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <0738e917-8aeb-f55e-da35-bcc7ca897ce5@nvidia.com>
Date:   Tue, 25 Jun 2019 11:00:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL103.nvidia.com (172.20.187.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1561456835; bh=lsuzsalk0PpqQ/GtVL8tHM5PgQYS6mNSeL5u7mML4bQ=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=MpvSXVMExjlnY5Mm4wS3bhHc3LNMBbhYO/nkAqw3320xnujMtmR/i/udvsllmZi5L
         gVQTLFEDBifTN65fgqiJs2JrX54VeoY6n62PK14+5e1cj1c/rkGCSLD7TdeoqVMYQJ
         LGL8mDbHEhUDIB7Qok0K+7tn5OzDg2T1fH1Ov6BAvck1VSBCki2USzcztl8uWIdBUl
         aOUYGkJPx3zfqDq+oPIJQIJfbG9sU8DefomGdzz4Qj26qf75MH3CRw8SGDN9uc/7aW
         DNupD5iNI7Gtl983vkmWTsOU7l9oyT3BvkSFhkvMBAD2pAXtXP2mVPPftLVdhiQYZr
         9LinqfGgl5wwg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 24/06/2019 10:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.56 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 26 Jun 2019 09:22:03 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.56-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.56-rc1-gc491b02eb03a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
