Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71C2A14C375
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 00:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgA1XSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 18:18:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbgA1XSY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 18:18:24 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40F9F2087F;
        Tue, 28 Jan 2020 23:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580253503;
        bh=eEb6oKewZ2flS068WdKDDbnPMYYEMESGs+lNNoy271Q=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=akHzN35ftatxztzyo2Msb7U51rTUxAmghwLDH5IF5yAuioaGgMMxlkAR4Z+R9QhEN
         wdwf0fmQ9rO/KcbkkM6qr8kWzQw7wd4kEOLMAgHM+XrzvWEr2pVK+xSSS0haRy1FI2
         TUaM7prsl6WQmSHo+j9AykR9faXSk+kF7uKFm+jk=
Subject: Re: [PATCH 4.4 000/183] 4.4.212-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200128135829.486060649@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <535fce51-b0ba-6275-c1d8-2ced989499b7@kernel.org>
Date:   Tue, 28 Jan 2020 16:18:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/28/20 7:03 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.212 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.212-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
