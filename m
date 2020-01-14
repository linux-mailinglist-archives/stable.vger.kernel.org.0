Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6F613B38A
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 21:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbgANUUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 15:20:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:39532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727102AbgANUUA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 15:20:00 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54FDC24658;
        Tue, 14 Jan 2020 20:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579033199;
        bh=DL+90P/EWaKpgjQhzELm1QtcKaipMjhpGWKnAdLZJzw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=REMMLXfRfstTi3AjDBsMPU9gAQ2pFjtmKTZzTvGeueeO0j2vLt3b091Yw61VbgJeL
         xM+4SIE94YeSVAFJXk0ELfPhac+pFjjfHMsCQ/VyrnHHw47Da5blCKCE5U700EOZU5
         O1yWDR9KY3mGdF5Ep0BhSznPx//b++SPnEApkz94=
Subject: Re: [PATCH 5.4 00/78] 5.4.12-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200114094352.428808181@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <0c5ca0ba-fac2-03e6-72b8-3d1a4a52f346@kernel.org>
Date:   Tue, 14 Jan 2020 13:19:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/14/20 3:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.12 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jan 2020 09:41:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.12-rc1.gz
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
