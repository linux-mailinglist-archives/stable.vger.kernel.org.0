Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF0A1CBB36
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 01:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgEHXWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 19:22:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727110AbgEHXWI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 19:22:08 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 520C12184D;
        Fri,  8 May 2020 23:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588980127;
        bh=J/r6SK59vuvuBhQJCATqjHVW+gb0aCI1Afvx+tsgRH4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ukbw6BUvJg/AlAC/N9nMWN6MM+31tLSJs1MnWcClD5RwhAVeag5lf8aIvIrCv/MI5
         L0gArysPxOvVkmhZT2q5i/FCZIwpuFhzxzEf2G9zWmFKA0JBGYKerMS36BcC444P59
         HV5chNmefQvstONjYtdsqf7KLF/MLKLwoXntPjZA=
Subject: Re: [PATCH 5.6 00/49] 5.6.12-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200508123042.775047422@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <a4f032c8-af33-857f-c539-89872599e7dd@kernel.org>
Date:   Fri, 8 May 2020 17:22:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200508123042.775047422@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/8/20 6:35 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.6.12 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 May 2020 12:29:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

