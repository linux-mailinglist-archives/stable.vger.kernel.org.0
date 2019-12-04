Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4C1113113
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 18:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbfLDRuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 12:50:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:39110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727912AbfLDRuW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 12:50:22 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAA8F20661;
        Wed,  4 Dec 2019 17:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575481821;
        bh=jnuVLegQsWA7TBLtv1Yr0RWlmQ5beYAuduPCYk0KkQw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=tUs9wgecZrhsSg1pE/yohoA2iVkw3t9y0qBRl7LgArC8A9IoLSLzLrT+ApsHbEq2I
         JuUAqhcapG+/JWqGdCVJxwXkHY9TaMLmH/f5AEm/q5qw2uCEWj7JgryayyIkBumbvv
         Bw7vo29KxUWEXZqJNx+M+B7cVa4kOg4Y0lpRYiXA=
Subject: Re: [PATCH 5.4 00/46] 5.4.2-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191203212705.175425505@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <a070b014-b70b-06ae-8765-831819d57fbe@kernel.org>
Date:   Wed, 4 Dec 2019 10:50:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191203212705.175425505@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/3/19 3:35 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.2 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Dec 2019 21:20:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

