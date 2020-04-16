Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB8E1AD1F6
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 23:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgDPVf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 17:35:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727799AbgDPVf5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 17:35:57 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFB37221F9;
        Thu, 16 Apr 2020 21:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587072957;
        bh=c/KbASC+HiXA03F3f0VKXRU/SOyntQfgE+IQskpSxNg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=kb0g8rYSvDeOcQbZnkjSsimfn0h+5tB7hphhqwQZWALFz8GecOKo6BC/W6L2fNZT9
         SJBc8fwJwL5KzqCViujwWAR4WSmLt4FiNbxMzsAzL+QU6OMgLGkFJlFQY5DUv57kx+
         /tgMpO+ZR7UYX/JMW2XGkn8GkV8qG/zy3ZaOkZeI=
Subject: Re: [PATCH 5.6 000/254] 5.6.5-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200416131325.804095985@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <a83ee7a6-d13d-6929-e4be-669058714fd9@kernel.org>
Date:   Thu, 16 Apr 2020 15:35:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/16/20 7:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.6.5 release.
> There are 254 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Apr 2020 13:11:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.
reboot and poweroff hang forever. I saw this problem on
Linux 5.7rc1 as well.

AMD Ryzen 5 PRO 2400GE

I don't see this problem on Intel i7-8550U

I haven't started debugging yet. I will have to go back and
check if it is introduced in 5.6.4-rc1. 5.6-3-rc2 is the last
good one.

I will update you later on today with bisect data.

thanks,
-- Shuah
