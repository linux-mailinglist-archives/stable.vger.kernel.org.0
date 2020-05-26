Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42E81D95FC
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 14:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728822AbgESMME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 08:12:04 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10168 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbgESMME (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 08:12:04 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ec3cd080000>; Tue, 19 May 2020 05:11:52 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 19 May 2020 05:12:04 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 19 May 2020 05:12:04 -0700
Received: from [10.26.74.144] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 19 May
 2020 12:12:01 +0000
Subject: Re: [PATCH 4.19 00/80] 4.19.124-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200518173450.097837707@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <a629c5d1-10bd-ced7-5d5f-ba1958873c50@nvidia.com>
Date:   Tue, 19 May 2020 13:11:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589890312; bh=s+fXjBaCtqlzY9UmOaoWxd9KQADy3I5FuYRapzhcfsI=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=A07Kn+Jnb2rO3E3GZnKs7FCmrLGBMx0Uw9WO78/lV8unn8tiy6b0zuIUxpKbUdnDX
         6TdPMHgFdCT0ZQQF6PvwTYrzpllj/KUXb2MSlnTdFGy/+XhiKtpbYIpc1T8T0NKhy5
         6vuRe8cF2ewXFn6PdPDTCpytdNgG089HonL56V43QD8fwFSSyj9m2yQOdGjKXyMENz
         sEsUnQW6GO01mhtzWnAM93niCTIYuuTyPie/bblotriTngmqmNp5zqmg6zwf3wuM/Z
         pF9cJtzFIumkFBQBxF4Lm9zzH0UFxP54W+L5jzX+tGNn5JzDS5JoiV+JNFbeRh0WoI
         iaqLzq8hT5fhg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 18/05/2020 18:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.124 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 May 2020 17:32:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.124-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra.

I am having issues pulling the report, but looks good to me.

Cheers
Jon

-- 
nvpublic
