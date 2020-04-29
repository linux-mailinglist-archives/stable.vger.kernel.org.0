Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03FEC1BD150
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 02:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgD2Ans (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 20:43:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbgD2Ans (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 20:43:48 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5812220731;
        Wed, 29 Apr 2020 00:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588121027;
        bh=XID5/4qpArD5J2A+ZRnuF8pIAyPS3QSs3oNy0oghB6U=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=xQCpCR4EZAQqsis/Lz0O4YdkkdYNuaJq0Y31yj2CO6czxm6b3ylaJQxSTBGDeaGUr
         tXaanjM3tognkyLEcyH9KJZc762odyT63Wb50wH+GGHqVNcNoOzxQs5BdFHGXxL5m1
         XCtUqk422XdVlk7O3HmjI5gEhh3/xiKxgS6tsOVE=
Subject: Re: [PATCH 5.4 000/168] 5.4.36-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200428182231.704304409@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <8e82a0f9-202c-d4dd-b1a2-46efac572bb8@kernel.org>
Date:   Tue, 28 Apr 2020 18:43:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/28/20 12:22 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.36 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Apr 2020 18:21:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.36-rc1.gz
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
