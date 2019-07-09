Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 106D762D30
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 02:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbfGIAyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 20:54:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725857AbfGIAyS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 20:54:18 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5383A2166E;
        Tue,  9 Jul 2019 00:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562633658;
        bh=TaA19Hq9hxZFjnO5RqNyFUJ2lZYwSReMYdu022N7vBw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=0qYdrUYKYIOnGkHKaWNt5AQ5jduT5TEBIbEXx/vhlAm3C3BM8MkVKuvCjeoSEf2U8
         4Qi/pUunvfz8/DeeWI8XSYdY0Gh2Xpga7B6uv53aX9IZEDItdMYYm0WX3QhrchRTYq
         kZW7IG1Py6Q2KxonLMb72t0vIJm5KPnp8Zna4Fp4=
Subject: Re: [PATCH 4.19 00/90] 4.19.58-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190708150521.829733162@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <e048e940-ff30-a35e-092b-1623aa77241b@kernel.org>
Date:   Mon, 8 Jul 2019 18:54:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/8/19 9:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.58 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.58-rc1.gz
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

