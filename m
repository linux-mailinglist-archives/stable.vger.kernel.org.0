Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B909302E5
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 21:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfE3TjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 15:39:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbfE3TjV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 May 2019 15:39:21 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27192260FB;
        Thu, 30 May 2019 19:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559245160;
        bh=HAeeeyIuKJlselAZMCf8MCqGbbGxod0OcJMX5igAlNw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=rmks5ni16WOqtF/AY18TEJktC7/0uGmxKKCgtK9Mrm7N7GNdJVVY+FXpIY4pw+G61
         lFWgyWVvGvf84OHHQe5Z47PgPpQg9S6EA5UEFTvI0n/jKvudquK53ilx8yx2fewT+t
         3HAhl9FW93DfwyvgjWzig4S8K9iarj70BQdI1w7M=
Subject: Re: [PATCH 5.0 000/346] 5.0.20-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190530030540.363386121@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <f9aff09d-f6dc-7d0f-e6ed-2445d3a4a45c@kernel.org>
Date:   Thu, 30 May 2019 13:39:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/29/19 9:01 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.0.20 release.
> There are 346 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 01 Jun 2019 03:02:10 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.20-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah


