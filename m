Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9F4F3BEE0
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 23:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387872AbfFJVqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 17:46:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387661AbfFJVqr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 17:46:47 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C32FA2086A;
        Mon, 10 Jun 2019 21:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560203207;
        bh=t97ur+9GQx6INNRvH/SYTGaRmbEqYM3CkKHCIUu1fs8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=uKzwmsXmdqNX+rTXBaTy4P3zmxdgjrQipOzwOPS3FBx8oEWayaKjTYd2C3eQD1af1
         Je3GL6y2M8XpSZu1byCvolPkDH8yikuXQvrXsZQxTfP34ZVCfN83juaaUoeY7icyEa
         4p9PhNZZHVFkQc2fFGIYc2U0UbkhLMf61FBZOMLM=
Subject: Re: [PATCH 4.4 000/241] 4.4.181-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190609164147.729157653@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <0cf24cea-4e85-6ed8-1a4c-e3ce00c9f418@kernel.org>
Date:   Mon, 10 Jun 2019 15:46:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/9/19 10:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.181 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 11 Jun 2019 04:39:53 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.181-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

