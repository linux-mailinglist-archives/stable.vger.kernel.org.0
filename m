Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8A6D3BEFE
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 23:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbfFJV5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 17:57:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726556AbfFJV5k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 17:57:40 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A230320820;
        Mon, 10 Jun 2019 21:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560203860;
        bh=sD9JkItz0ofsXR2+OhfJ+f+JIT8mAurGctMWoDkYPeY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=KylGsB+hjJBg+WHkmU4sOucGeQoWVgGiPmgH9qH2WirA8tHm2IEv25OVYBERcG5XB
         n7SvTcqFVh8yNL3gtzD6zuz7oft+sHAOEkXGuBuXAiRJzSM1U6tdzvmCK1T3T+hOYO
         Y8/+us5uULWvbl5tqJAW8B2dJNZtVwh9LTKK/MIk=
Subject: Re: [PATCH 4.19 00/51] 4.19.50-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190609164127.123076536@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <9de06787-d2df-fb51-a12c-3d235fd80314@kernel.org>
Date:   Mon, 10 Jun 2019 15:57:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190609164127.123076536@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/9/19 10:41 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.50 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 11 Jun 2019 04:40:08 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.50-rc1.gz
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
