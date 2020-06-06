Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878741F0564
	for <lists+stable@lfdr.de>; Sat,  6 Jun 2020 08:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgFFGcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Jun 2020 02:32:10 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1502 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgFFGcJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Jun 2020 02:32:09 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5edb38100000>; Fri, 05 Jun 2020 23:30:40 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 05 Jun 2020 23:32:09 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 05 Jun 2020 23:32:09 -0700
Received: from [10.26.72.65] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 6 Jun
 2020 06:32:07 +0000
Subject: Re: [PATCH 4.19 00/28] 4.19.127-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200605140252.338635395@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <29f81676-b293-2264-b7b4-77ebcd6326f1@nvidia.com>
Date:   Sat, 6 Jun 2020 07:32:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200605140252.338635395@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1591425040; bh=OZHQ47mDxq6zFilAAEclFEWXhcggRYiBL/bQd3vSZpk=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=SiCFxSQR149DTuOIhyHR+CM6OOtEHbk8DIO79DK5zagerJ4nyKQxonKwmIGunCWi2
         zBsqXbouINkUd5MeAmpmHoggtqzSxncRosgV8w7xR7Pruj41jkEtP5HLhd0o0zGzY7
         yx9UO6dpYhXQx2mnqZgKVFBZn5nTdSux3wxHMzyZ/ygl/Y4mfHKrUnApuuLMuHyBIR
         1elq9IlZDVqJzvH8GB0CximWO1ZRoN0I26eKa4X2wNFUJ1uQg96sRjkh5+XZaqxY2Y
         6HET2GaI+0R8SuOPKZM24j0AfmorM9RLSnnGjOxRuNQU85+dB0stdwlsk5DpRMEp84
         Y69M+mO4YianQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 05/06/2020 15:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.127 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Jun 2020 13:54:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.127-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


All tests are passing for Tegra. I am missing the report for this one. I
can see everything passed but now our builders have been off-lined for
the weekend. Can't believe we are giving the builders the weekend off!

Cheers
Jon

-- 
nvpublic
