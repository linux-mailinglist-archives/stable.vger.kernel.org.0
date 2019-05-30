Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35251302F7
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 21:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfE3Tou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 15:44:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbfE3Tot (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 May 2019 15:44:49 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 209C92610E;
        Thu, 30 May 2019 19:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559245489;
        bh=uHgJtIQUwDZzgBzTZLl/NcwOh42F8eSUaOsgj4kmz5s=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=HXRv+t3fmPj22C+4ah8Opfw8GJJDoPkawWRTGWu15o3r1SWpAbrdZQXD56SDyFKwP
         Tl448RghlF5RQO6KzxQSloUErZwdtYXbfBu7/714u6cPFYYBUSzyg3v6deOYIcvmt9
         53zrk8ffEyXVF9Iit1q/eB3fiQez+OR3uE+2fj8g=
Subject: Re: [PATCH 4.9 000/128] 4.9.180-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190530030432.977908967@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <7727fe5f-fcd6-0c7a-607d-106cac4d16ac@kernel.org>
Date:   Thu, 30 May 2019 13:44:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/29/19 9:05 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.180 release.
> There are 128 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 01 Jun 2019 03:02:06 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.180-rc1.gz
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
