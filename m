Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8FEF03AA
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 18:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389298AbfKERB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 12:01:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:41858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389267AbfKERB1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 12:01:27 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4ADA21D6C;
        Tue,  5 Nov 2019 17:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572973287;
        bh=iK3jjbUTTiyBlr35WTgbMKzVOI3PrZ7iul/+3YpY8tU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=dVnGltsxpUh1HQ374CncBp3Jab/eUH+zJ0B23kYETFA+BxDda2Kdnp4c6LyU5OZY/
         waI2fBV7KP8FXx5GUVqdAdlXrq/Z7ghXbrmmTdPidVfYPGIpcT2o99u9sx2NiGnWhS
         wEZy7s4ooXAIZb7rjQW+tvQ1BvYrEDLzHQNAYQkc=
Subject: Re: [PATCH 4.9 00/62] 4.9.199-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191104211901.387893698@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <ac7672a2-33a8-191d-006e-33613d511d18@kernel.org>
Date:   Tue, 5 Nov 2019 10:01:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104211901.387893698@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/4/19 2:44 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.199 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 06 Nov 2019 09:14:04 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.199-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

