Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBA2191A41
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 20:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgCXTpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 15:45:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgCXTpS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 15:45:18 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0999206F6;
        Tue, 24 Mar 2020 19:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585079118;
        bh=QXe2BDonVd4A5y1YVgANV1HUjWeMBpY4X8beEd0nj3M=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=DTWTEvWdVIpKECx/Pn/aY+VOG6RB8UPUOMahkv0F0AQp1PiZYwmV8TklDY8uN+WHT
         o0hw54itihCJ3Bdko63bw8QpThr8SCEJxpsBhC1oAscFwuFU2J8mt5sjPvaVokfZy2
         fG8PLzwb58OMPHWuVy1hxKo+G2U/UtI6NslXQMkM=
Subject: Re: [PATCH 5.5 000/119] 5.5.12-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200324130808.041360967@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <ec5380ae-add2-09af-1690-4edf509dd908@kernel.org>
Date:   Tue, 24 Mar 2020 13:45:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/24/20 7:09 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.12 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Mar 2020 13:06:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

