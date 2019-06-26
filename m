Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB0D573D4
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 23:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfFZVqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 17:46:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbfFZVqD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 17:46:03 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0750C20665;
        Wed, 26 Jun 2019 21:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561585562;
        bh=DRHwIYagcxSefxtxUmGepQRlcDBzbp7VVh0IXC49n8Y=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=2UE+8Fn0BnnwdB5XkYfFOQT8enkZJtVG1YenOJ3+ZigNVe+qhyTdKpsJXa8nYNdEn
         l/7U9IAwZG2JFXhpN3iHoieAPJkqsdQv8ZCkl7v+aTUZ+K0qF2r6AtYYVK3tGz4zfF
         JufcidEUfCDSdO0ns3YoNaBIegjYlslQsRWiLY5U=
Subject: Re: [PATCH 4.4 0/1] 4.4.184-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190626083604.894288021@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <7507a259-5b00-39bd-a76d-6b8b40ba1f82@kernel.org>
Date:   Wed, 26 Jun 2019 15:46:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190626083604.894288021@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/26/19 2:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.184 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 28 Jun 2019 08:35:42 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.184-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>      Linux 4.4.184-rc1
> 
> Eric Dumazet <edumazet@google.com>
>      tcp: refine memory limit test in tcp_fragment()
> 
> 
> -------------
> 
> Diffstat:
> 
>   Makefile              | 4 ++--
>   net/ipv4/tcp_output.c | 2 +-
>   2 files changed, 3 insertions(+), 3 deletions(-)
> 
> 
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
