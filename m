Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DD01B30EB
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 22:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgDUUEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 16:04:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgDUUEQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 16:04:16 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A63C206B8;
        Tue, 21 Apr 2020 20:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587499455;
        bh=ijsxzxLtyR1+w8+1bP8Fp637enB8g9lYXr9wOsUw4AI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=PkOMYxVo/pe9fJmGqjeSpxdSW0c205O2wCrdYxW5Z3nK0AoMSUhHztjY+zjll9XvF
         u1EGc7gdqEwamlXe3A073MXfLcEynqZXDeIq7Lu2gKFrhtIrVy8P0O0z9RWvgDDlZy
         10PYkRHvN/laN8w+VUAF/8tOFeMJtL6fyYwOgfME=
Subject: Re: [PATCH 4.19 00/40] 4.19.117-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200420121444.178150063@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <b53be106-95a4-4ada-c8e8-22f149dc16e5@kernel.org>
Date:   Tue, 21 Apr 2020 14:04:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200420121444.178150063@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/20/20 6:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.117 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Apr 2020 12:10:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.117-rc1.gz
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

