Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF0441347CB
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 17:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbgAHQYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 11:24:13 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10093 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727127AbgAHQYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 11:24:12 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e16021a0001>; Wed, 08 Jan 2020 08:23:54 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 08 Jan 2020 08:24:12 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 08 Jan 2020 08:24:12 -0800
Received: from [10.26.11.166] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 8 Jan
 2020 16:24:09 +0000
Subject: Re: [PATCH 5.4 000/191] 5.4.9-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200107205332.984228665@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <87bea213-7dd5-412b-0faa-fc3b336da673@nvidia.com>
Date:   Wed, 8 Jan 2020 16:24:07 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1578500634; bh=grsyNcX1AD4Jociez9mW3EaKlqz2HqfPphp1BwVFD0A=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=fWRDYZQqsyRtAUyyMWKrOEwzYWGF+8sqnqFyqUxMK8D2ExHlNM6Gz2caMqa/i+F8r
         Ad68z/JG6596IMF7YROAgdKfaEWft+HwbdUv1I4dhNRELI9tGmCaacImc+2eCPSaFh
         1q3q+NeJFGJwbmoUIKb4OzFL0m/59Y4E914Mxy4ptI+mkNNhrmaRJl5TuhT9tkS7X5
         /YwR1dlIE69+8uYg5sCQvoI8TKiHdjRQ/hv5F8xtV51d1gwYMZCEDwaXIiBVM+f6zd
         MbWkmPXb1U0IE3GO6e5y+EWQEBjZbUAwynUrx/UWBCnw/asQMr9GhWY1qZ+j+p++9Q
         0K8WHAJ5gKomA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 07/01/2020 20:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.9 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jan 2020 20:44:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

All tests for Tegra are passing ...

Test results for stable-v5.4:
    13 builds:	13 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	5.4.9-rc2-gdd269ce619cb
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
