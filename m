Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAEA1585AF
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 23:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbgBJWmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 17:42:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727433AbgBJWmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 17:42:07 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59E652082F;
        Mon, 10 Feb 2020 22:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581374527;
        bh=1Lwn9DPESpKJkjpNQKi1kJJiWTQgqZ/NAKGNmDF4Z2M=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=CBb3qru7Y/l07qVmRQFV7sCurpftTayxtZPn1ThSigQBO/IH8BJuJp+8z/jDcnvaL
         NBrZCslAdUZEuxOrBiHOYImSvpQ+hi84Tw9ZJBmsOx7MkD5Xo1zpI6CTJQ7yLTCvOS
         bfz96Hb4iw+MhIpaxv9KfAChSHmbKVEwt/YGdwWQ=
Subject: Re: [PATCH 5.4 000/309] 5.4.19-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200210122406.106356946@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <c8bef6fb-6c59-78b2-b3dd-e9f17bf485a4@kernel.org>
Date:   Mon, 10 Feb 2020 15:42:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/10/20 5:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.19 release.
> There are 309 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Feb 2020 12:18:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.19-rc1.gz
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

