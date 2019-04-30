Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA811025D
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 00:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfD3Was (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 18:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbfD3War (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 18:30:47 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ABBA20854;
        Tue, 30 Apr 2019 22:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556663447;
        bh=U+RK7QVKrRrwIB1cIC/ouXI0J8QLjs1RQHruqx2ITUA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=UI0FQWF24/AZVHTSy1p4SMxVd5H+xE4KXxfbBLZq4XwasNDa3fLsEcqaA2ineN995
         m5UKyphn+ZUBg5CmsUPlBAK7Lhq0ftKikoPg72fuCk8qcHz4eY/gZdbON/PrCX57mp
         K919vOco9MB91XICtoDhL0Dl0bHUNbKezB+8hULw=
Subject: Re: [PATCH 4.9 00/41] 4.9.172-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190430113524.451237916@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <762d21f8-eb3d-7f6b-e242-4af543058cd3@kernel.org>
Date:   Tue, 30 Apr 2019 16:30:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190430113524.451237916@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/30/19 5:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.172 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 02 May 2019 11:34:41 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.172-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

