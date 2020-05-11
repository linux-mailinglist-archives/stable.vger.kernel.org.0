Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C9C1CE154
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 19:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730624AbgEKRNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 13:13:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729731AbgEKRNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 13:13:18 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E87920714;
        Mon, 11 May 2020 17:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589217198;
        bh=HzRnoLxva5TEjQwJpL7oLKvb5b5J0ffUrtcmvG8XvGg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=bl1wqPPQKxQvvTYa3bHowvivrmonuWrMLWBkCickE7r2v0LJz+eMYMQnSrHyr/pCa
         aL4dzGv1FyRKql8ZL+NUFhBx/EDyeA92IvAjT8Gy+BDHaVz0hlgdEfIy9JQkA7Pfef
         gI8BC9/J5W1HtjODpNpQ55FDjcYfbjd9Ak0hEuTo=
Subject: Re: [PATCH 4.9 00/18] 4.9.223-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200508123030.497793118@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <413ec0d9-f857-c46a-0313-a8a9a34857d6@kernel.org>
Date:   Mon, 11 May 2020 11:13:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200508123030.497793118@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/8/20 6:35 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.223 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 May 2020 12:29:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.223-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. Same emergency message
in this release as well.

Initramfs unpacking failed: Decoding failed

I will starting debug and let you know.

thanks,
-- Shuah
