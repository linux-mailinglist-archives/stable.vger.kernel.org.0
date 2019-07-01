Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88EF229E8A
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 20:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391688AbfEXS4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 14:56:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391181AbfEXS4A (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 May 2019 14:56:00 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 994C421848;
        Fri, 24 May 2019 18:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558724160;
        bh=JoRKWDQyc4cEQRAscFeeZIV1M25atevzGhSsP/KqxSo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=kr0ftbvVsdqKqzzf1Ly+DdCXWBTLWvT2aLvMxzE5pLWt5iH8Q5/1CqbcrHQubNAsc
         O9bmCUQsrvSo2vOfz7009fCNULary+UBMQJQbeEZYvVGIcOsb4Nnj1J2RoOmhUOrmy
         x2HL/Mdv1IWQdOi7heF9vA8N/zErxxfAy4fhqpkk=
Subject: Re: [PATCH 5.1 000/122] 5.1.5-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190523181705.091418060@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <689feba6-bce3-1d16-b5b6-27ce8b8a9e2d@kernel.org>
Date:   Fri, 24 May 2019 12:55:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/23/19 1:05 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.5 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 25 May 2019 06:14:44 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
