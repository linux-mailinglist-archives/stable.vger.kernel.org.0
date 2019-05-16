Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0F0208AD
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 15:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfEPNzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 09:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbfEPNzz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 09:55:55 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E22F620657;
        Thu, 16 May 2019 13:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558014954;
        bh=BvXt+eR4jR0LUyZlbGdZ51x2LIrl45NN9y7NG5dGC9s=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=UpoTFQ/JWVo7a9UoCtESEVaHEbqguTunbA6Bw/K9JWTyBGrhJp8JWY7J7m80hF63B
         R436BoQqvmQRhB77Fx2eUOSUg5e+agLBWYry7rXyriP4BjDKBtDr9DSjvRHn9eWQ9Y
         Nfe0zHdLcRpbZCfLx4Phi4x47DT8+zM+vAL2lf4Q=
Subject: Re: [PATCH 5.1 00/46] 5.1.3-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190515090616.670410738@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <38cc4651-4e70-48c8-5793-5857d0f33cc5@kernel.org>
Date:   Thu, 16 May 2019 07:55:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515090616.670410738@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/15/19 4:56 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.3 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 17 May 2019 09:04:22 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.3-rc1.gz
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
