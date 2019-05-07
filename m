Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1269316C2C
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 22:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbfEGU06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 16:26:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbfEGU06 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 16:26:58 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD48B208C4;
        Tue,  7 May 2019 20:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557260817;
        bh=VKH+f1fXdQwXcJrFRmwJUrSiGqfGMMTzsM1YBtpjij8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=sRzFol9RoVk9ogu50TpIOLHAL4xCm7u6OwdUm3URKjIWkXMt4y8gOgpPf6DfXWnvL
         xzKXd6xcxeMVDM7lJLsT5boAUzT4yblPTo06ui4UkC8sPwljACX1K990n+qB+3cNGx
         8jo8Jzv2TIeUTZ4qTWCVI+zoScqzEapkiR35wDAQ=
Subject: Re: [PATCH 4.14 00/75] 4.14.117-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190506143053.287515952@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <53bb9fd2-f982-3ee0-f2e5-94d925f08776@kernel.org>
Date:   Tue, 7 May 2019 14:26:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190506143053.287515952@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/6/19 8:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.117 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 08 May 2019 02:29:19 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.117-rc1.gz
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

