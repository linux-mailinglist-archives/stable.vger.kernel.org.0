Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E44F10CBEC
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 16:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfK1PkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 10:40:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:55548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbfK1PkX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Nov 2019 10:40:23 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AE532178F;
        Thu, 28 Nov 2019 15:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574955622;
        bh=UWC1Jv9o48SXhKCXFcShQccXZClzl6R/wW121sOl224=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=nz2Gfop/wvM5ZTf+S1UyvkROj3Tv14Peebz9CQ6iC+mshaNaULO2aFkNtXja46Kbc
         9CzKSAvfOItRfbplu1Kx7NntmUcE2y4/AXkmegVoEjB8p8wJq43wSFhCiHCkJJKdND
         nJ/0ducdgf+GXk2W8SOnOk/brELKtJFj9UP34A+8=
Subject: Re: [PATCH 5.4 00/66] 5.4.1-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191127202632.536277063@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <1d97b6c7-6fa0-4a74-b48a-c54ef120148b@kernel.org>
Date:   Thu, 28 Nov 2019 08:40:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191127202632.536277063@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/27/19 1:31 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.1 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.1-rc1.gz
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
