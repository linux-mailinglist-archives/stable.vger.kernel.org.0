Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6461D9A42
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 16:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgESOou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 10:44:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726504AbgESOou (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 10:44:50 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC5FD2072C;
        Tue, 19 May 2020 14:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589899490;
        bh=f2m/vpKesJuAgpJWphNK74mGGeooA6hNDsxNNkyr/7A=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=MAX4uQGJcs47DiTwe1+vbMtz89JP86KaEl3LPFGLgzHIl5B0eMgFjApLLN9+U5y2O
         dfcTwt0C9vty4h88iZAOlUx1BPqJesj6lq/NVu6M5ktJfuq3oiASuL1YgJFr0fErj9
         rsL9rxQ2n3XADd5GODp4vmxOaUK7IUIAYFa+/w2Y=
Subject: Re: [PATCH 5.6 000/194] 5.6.14-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200518173531.455604187@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <09b1c244-6db3-f35c-7853-7ebafd443424@kernel.org>
Date:   Tue, 19 May 2020 08:44:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/18/20 11:34 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.6.14 release.
> There are 194 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 May 2020 17:32:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.
I see rc2, I will test that and let you know the results.

thanks,
-- Shuah
