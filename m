Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBED8180A5C
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 22:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgCJV04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 17:26:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726100AbgCJV0z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 17:26:55 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D046208C3;
        Tue, 10 Mar 2020 21:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583875615;
        bh=FlWv/AqGmYrZZ/nZf4IZWyCVYAPpG8FWVQ8reyGMOq4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=y3K9HW6EuluJgxUud8P29n1Watnpu2YHIX989eGjj/vJfAKe1ULKx5pY7gsE7CJ4i
         e4y9HYEdHyZWRCdqBI+PmvOsbZJQfesXKsp3ZrTstG4V1HIPgBgl5KVaBmZIItohpv
         dBUkqT2UbO0mjNDfyAZMR9EH+zce6AYaSwtKprfA=
Subject: Re: [PATCH 4.14 000/126] 4.14.173-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200310124203.704193207@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <0074ed5d-1c87-4e0c-7d3f-bb5cc4e80366@kernel.org>
Date:   Tue, 10 Mar 2020 15:26:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/20 6:40 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.173 release.
> There are 126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Mar 2020 12:41:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.173-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. I have a new alert on my system:

RIP: kvm_mmu_set_mmio_spte_mask+0x34/0x40 [kvm] RSP: ffffb4f7415b7be8

I haven't tracked it yet.

thanks,
-- Shuah

