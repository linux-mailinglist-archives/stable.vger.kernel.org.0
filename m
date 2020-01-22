Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABBA8145D4F
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 21:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgAVUwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 15:52:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:54484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725827AbgAVUwG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 15:52:06 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D1002087E;
        Wed, 22 Jan 2020 20:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579726325;
        bh=y/Uq6iFURAdMZvlP9oKlXOEQRjvn2wjF4Inp+bSR9Dg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=AfBJpWPWU3ju2CuX9aLMpNtSkOXqaE5BNFGmlbvCrZWohdmEagROrJ8jJZNxnfD43
         FL7k0+NpHss/1rbqTl8b8Jj/5GdEKdT2/ZPXCjGXdgoXiLnZRfmJoCQG+SnU1kI1DF
         S8VaUdlPYNp+kkT36bIU0PIuGMlPG3IPkENvkeS4=
Subject: Re: [PATCH 4.9 00/97] 4.9.211-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200122092755.678349497@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <48e8104f-c1b6-0fd5-d6d7-bb71379da3c4@kernel.org>
Date:   Wed, 22 Jan 2020 13:52:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200122092755.678349497@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/22/20 2:28 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.211 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jan 2020 09:25:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.211-rc1.gz
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
