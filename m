Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0E99115424
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 16:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbfLFPYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 10:24:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:37104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726246AbfLFPYt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Dec 2019 10:24:49 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A76B21835;
        Fri,  6 Dec 2019 15:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575645888;
        bh=VCI07YpJoKvlpez5wSqx6sv7NGs+glTaNo5SkOXxBOk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=pD5AQGKRguHgCLNEfdjmNqI6Su7mK5UUImQ1sNCExOGk5W1AP9io90dcG24DEqw76
         JwQEJlX5gVfGCO6nj+hU1IRYCMtYcOlDnUAnNeuEulso40ZrT34p7b3EZ47Mborq7J
         9QaasnAia/CkiJgBlfz3CaLllcR/oOIsCGequ0JE=
Subject: Re: [PATCH 4.14 000/209] 4.14.158-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191204175321.609072813@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <1dac10cd-7183-9dfd-204c-05fae75bcd74@kernel.org>
Date:   Fri, 6 Dec 2019 08:24:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/4/19 10:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.158 release.
> There are 209 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Dec 2019 17:50:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.158-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Starting with Linux 4.14.157, 4.9.204, and 4.4.204 stables stopped
booting on my system. It can't find the root disk. No config changes
in between.

I have been bisecting 4.14 and 4.9 with no luck so far. I updated
to Ubuntu 19.10 in between.

The only other thing I see is CONFIG_GCC_VERSION which is supported
starting 4.18. I don't this boot failing issue on 4.19 + up. I am
also chasing any links between this config and scripts and tools
that generate the initramfs.

I am still debugging ... Serious for me since I can no longer test
older stables. :(

thanks,
-- Shuah



