Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D924C8032B
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 01:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389421AbfHBXUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 19:20:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:60180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388056AbfHBXUn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 19:20:43 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BB5F20B7C;
        Fri,  2 Aug 2019 23:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564788042;
        bh=qi5ay9/kdJhy1ODdxA6n7mf2MOolGcG0+fzIwVabdMU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=HsibIOlnCBlDDdyzMZrXgaW958H7qPEqCAwLdF+tGpWHDbxZRLRCaFawCczueg96y
         /cp9dheEo83rYZSiNe27PxoiXjq4qWdgkm/j5jrMCqnQwUau6off6/iVDMGzOnfkaf
         Bbn1UQlE63MQwYbEDkTqec2lMO/RChYXKZZUbHqQ=
Subject: Re: [PATCH 4.14 00/25] 4.14.136-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190802092058.428079740@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <cb52ee66-6034-6fbb-d19c-96b2c7242d65@kernel.org>
Date:   Fri, 2 Aug 2019 17:20:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190802092058.428079740@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/2/19 3:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.136 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 04 Aug 2019 09:19:34 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.136-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

