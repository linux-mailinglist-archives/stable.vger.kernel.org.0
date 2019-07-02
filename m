Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA1635DA90
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 03:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbfGCBSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 21:18:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727375AbfGCBSF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 21:18:05 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33F9621923;
        Tue,  2 Jul 2019 22:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562107914;
        bh=ZLhz76oI3+6LOgRvK2IIo30iL+eaYYe8RicC1yllZ/Y=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=A/duPnxNVesuuY0xhR0eFF83eetjxNx2p03oy4sj8wIA2YzL23SkObXX1sRI/AgRx
         tT3q2CR5cv5Yjm0cATnXa300a8sqYcqPOoSYqk9fY5j1e/X3Z2WPfZc8AyKWMGUoGc
         qKY7nstCD1DZE6xuKtnY4YiZ8ImF3YhogAN7BZHw=
Subject: Re: [PATCH 4.14 00/43] 4.14.132-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190702080123.904399496@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <bb9b6b7e-97af-5d7d-51d4-8df6855bc6a7@kernel.org>
Date:   Tue, 2 Jul 2019 16:51:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190702080123.904399496@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/2/19 2:01 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.132 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 04 Jul 2019 07:59:45 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.132-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

