Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABE6191A57
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 20:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbgCXTvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 15:51:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbgCXTvO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 15:51:14 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8EF620753;
        Tue, 24 Mar 2020 19:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585079474;
        bh=ADNIe9cFdpef1tn0PLNQnErvo13SJKJYbtrzwvySUYs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=rrs4XTacgHraLML5tYs8B4t2y4KNYPWazQUi4HTTFMCuzA5gUxs588yQLeeEl7YlW
         OUhl8BuGSCgormihoUoozqKr/8He/PGIlvRkTkqnT0ZPf504mL5dQdspCaii3W9jUH
         Jpvfx++xxoa49fSashZPgovSS1L+nn8awyL+idho=
Subject: Re: [PATCH 4.19 00/65] 4.19.113-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200324130756.679112147@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <b55ae28f-fd66-494a-e372-d0bdf460738d@kernel.org>
Date:   Tue, 24 Mar 2020 13:51:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200324130756.679112147@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/24/20 7:10 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.113 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Mar 2020 13:06:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.113-rc1.gz
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
