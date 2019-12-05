Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE8A113867
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 01:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbfLEAHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 19:07:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:35564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728053AbfLEAHg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 19:07:36 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 623C7206DF;
        Thu,  5 Dec 2019 00:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575504456;
        bh=sRCeD/1G5Ng78Yt2wnCvgpVYusC5RkViZ3DJ0S5ELGk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=SWgHpBkeCOIvBslpUVkHmGzUedINWTOP53TbGN/aLGb7ktLWyLXAJr720pnlDnYKG
         mfsTM7v3qqxKeMrly0T6s4nSP+xJMAdmDinoh2MT8TvSC6i+01pm2hw9v3TZ340rzN
         DapcvV/kDBVyBW55Xs9xSO1E5zx5VaTDfyhRwy/s=
Subject: Re: [PATCH 4.19 000/321] 4.19.88-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191203223427.103571230@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <b8455bf4-7d3c-6626-7bda-ecc08e503b65@kernel.org>
Date:   Wed, 4 Dec 2019 17:07:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/3/19 3:31 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.88 release.
> There are 321 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Dec 2019 22:30:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.88-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
