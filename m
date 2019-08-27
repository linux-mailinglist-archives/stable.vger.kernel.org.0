Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8DA69F2F3
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 21:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730347AbfH0TJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 15:09:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730262AbfH0TJY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 15:09:24 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB663214DA;
        Tue, 27 Aug 2019 19:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566932963;
        bh=j35b3QQ1PDlfFEvYEGqMq1GykGZQS5sT5QGOHy/w+kM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=IAZKefRmWmh+u6QI7ylZYzizG7jW2/plT9xkMo9X1RFdBr1KitVOZRKEZnYmTLfN9
         vacuFkrD29NZcTcdGVAEl2DOUPUTH/svBYMVCqGueOOSbr/WSleslmTOZ/O6yv8fxx
         ybeZop38Acehz7hcgC6I9Shoqh6zynbJtMrvdsXA=
Subject: Re: [PATCH 5.2 000/162] 5.2.11-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190827072738.093683223@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <af4552f9-6321-dd61-2264-3f3e793aaf61@kernel.org>
Date:   Tue, 27 Aug 2019 13:09:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/27/19 1:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.11 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 29 Aug 2019 07:25:02 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

