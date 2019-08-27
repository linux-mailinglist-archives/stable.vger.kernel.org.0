Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4629F2F7
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 21:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730954AbfH0TKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 15:10:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730465AbfH0TKF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 15:10:05 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71D8A214DA;
        Tue, 27 Aug 2019 19:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566933004;
        bh=cK8R8M0P4YzXDIjPRUDK2R0P/pIWXsdyndhUG44ptkg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=A7tk0LDmJ/grJO+mdXUmh80AJX1fRJxA8zhAbrOCOsIdmmVt6wcTiXy0SbbXw19uF
         tOaCVNOh/VzYFt4bsjQt5Mb01gR9jZntXg5YYXwgyH92O0zrYBtlmstNXHfnUIsH2y
         V6sXqITpunXVkQepF15qHLtfpMqrZbVJI5R0g4QU=
Subject: Re: [PATCH 4.19 00/98] 4.19.69-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190827072718.142728620@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <54c96152-aef5-857e-ad89-db20f7afa40b@kernel.org>
Date:   Tue, 27 Aug 2019 13:10:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/27/19 1:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.69 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 29 Aug 2019 07:25:02 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.69-rc1.gz
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
