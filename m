Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABF711026A
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 00:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfD3Wdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 18:33:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbfD3Wdn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 18:33:43 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B6C520854;
        Tue, 30 Apr 2019 22:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556663623;
        bh=9wSYxXkx+CfgvotWRGp+O1nbG34pPkl4kUFqqIWcr28=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=hMkRMiVbhBv6SAGi9tEUs1i9rGXBaa4O683aUwX8DWo3vo9ff0t9BgUzQWFtJWZLJ
         S1z5XwI2RjWmsSxQZZ6R5svGuEKm3BfGZQO239j2JHgrp64gkXotEWjPm68kCbbMMp
         uzbseN/8RpSwv3OacwsWyKGNSHY/k7gS+LgyVXWM=
Subject: Re: [PATCH 5.0 00/89] 5.0.11-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190430113609.741196396@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <cc6e90a5-8d67-62cf-8720-fd5cf5af45e2@kernel.org>
Date:   Tue, 30 Apr 2019 16:33:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/30/19 5:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.0.11 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 02 May 2019 11:35:03 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

