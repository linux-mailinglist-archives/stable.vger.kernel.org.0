Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D082C299A
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 00:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfI3WcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 18:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbfI3WcE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Sep 2019 18:32:04 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDDCD20842;
        Mon, 30 Sep 2019 22:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569882723;
        bh=033EVoPIbQQt4saxfg6lYo0ljc8tIp/LXV1ZE2Iuc3I=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=jvrjwEXeiQkObnYuYANaOaLjZAUqrBZiamURy4U/bJnIV8dodgVEmgbSI8EIxjEM8
         X/s9oSW6Ws6mqxPnTSVfnQF7pKfeJXDHoq8q1PRucGhr1Y0LRI4Etec7Z5iqT4vhLN
         SyvDu6ohgsJOSzlmvz532BR/9eBoROYW3fG8+dV0=
Subject: Re: [PATCH 5.3 00/25] 5.3.2-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190929135006.127269625@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <519f66ea-9cd5-b151-3383-b1331c710b42@kernel.org>
Date:   Mon, 30 Sep 2019 16:31:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190929135006.127269625@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/29/19 7:56 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.2 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 01 Oct 2019 01:47:47 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

