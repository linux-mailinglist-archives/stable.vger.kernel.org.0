Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFD1611C383
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 03:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbfLLCsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 21:48:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:53770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727599AbfLLCs3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 21:48:29 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAC742054F;
        Thu, 12 Dec 2019 02:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576118909;
        bh=BYkjhzKIuktii6xSof1BOBNHWNSxPKMC25YuyhU174o=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ZHYKwTltg7WeAtYkme3X09TeZMmaQTJaJSH2tMmiNg+frFXd21r3xH+zmnw8+I8L0
         jivLj8U774wWoktqcnOG03QgP7DI4dGA6KHGefLrFFh29ZCJxR1Eg/vs1Wyg1uDA1a
         4i7TDq4s+o2plOvDspTNQzBq39fyaYvzdygb3zkg=
Subject: Re: [PATCH 5.4 00/92] 5.4.3-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191211150221.977775294@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <0253e33d-afa5-3dda-95d5-220535537eb4@kernel.org>
Date:   Wed, 11 Dec 2019 19:48:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/11/19 8:04 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.3 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.3-rc1.gz
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
