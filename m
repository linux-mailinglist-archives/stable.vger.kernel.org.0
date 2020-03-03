Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 359B5178618
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 00:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgCCXBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 18:01:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:40350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727604AbgCCXBg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 18:01:36 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4190206E6;
        Tue,  3 Mar 2020 23:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583276496;
        bh=tbUhVX64Ga1x6NtGWMm83ZXrBQg/M9ws6QFjmSxTP3E=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=umLLqyduRoxqqa9ZrW0eySxsCa4x00+YN9EXfo0u7SKAXmOKiRmrWPiQ7M7VwfmcA
         lvUsoI1ivZTU+d03Y3DXJgipA6BMByb3lTCpDDjfsd/sY7lgAs/YPo9LuFHY7LUo5+
         kpEk7lEdfqfIcBRDIppKfcRSCwNQB3k/Rs/AkXHI=
Subject: Re: [PATCH 5.5 000/176] 5.5.8-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200303174304.593872177@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <925b1535-00ef-5583-8119-3c9fd50cd6e8@kernel.org>
Date:   Tue, 3 Mar 2020 16:01:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/3/20 10:41 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.8 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Mar 2020 17:42:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

