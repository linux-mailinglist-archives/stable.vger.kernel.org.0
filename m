Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60071D926C
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 10:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgESItK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 04:49:10 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13505 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgESItK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 04:49:10 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ec39d790001>; Tue, 19 May 2020 01:48:57 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 19 May 2020 01:49:09 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 19 May 2020 01:49:09 -0700
Received: from [10.26.74.144] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 19 May
 2020 08:49:07 +0000
Subject: Re: [PATCH 4.4 00/86] 4.4.224-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200518173450.254571947@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <20c46455-d403-89f2-9f5b-82a8f679d97c@nvidia.com>
Date:   Tue, 19 May 2020 09:49:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589878137; bh=aUrtNfycJMaM6JFZ6gtmXfhoRBylsDCxXvp0ZFVVrtk=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=LlDcY3ciXipMyDozkc42kS3mygWMIzHbDBT/BFODjWgLmmE42BehRLcQdWYcyyWWt
         We+KjH9vR2Ef8YWxyAM8jvZXTBZN9P9Rt6ErSGWkZMw7a56GIv02tgIo0ZFT9jDcbM
         XG7mxZzX9DnPMsFXjcGjdPxBoftOXkeVGkqmCbj99RT7p4z6GuDpuUA12lXMLUyZOj
         uHhs3O+85HqfKBWOQR63DtgRjNfcxQdUh3jTes5v24UWJnPzq1JYwIAsSWwa6OLNnI
         BqA93Vh2kzSUKKAXcwJcd3h1v0B4c3H2Or9ap9PN24zkwNcDOdB6l7BCixdti/LxME
         O8HkJKXn1y81A==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 18/05/2020 18:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.224 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 May 2020 17:32:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.224-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


All tests are passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    19 tests:	19 pass, 0 fail

Linux version:	4.4.224-rc1-g4935dd6adfe2
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
