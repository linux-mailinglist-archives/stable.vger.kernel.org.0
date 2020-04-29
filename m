Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B741BD158
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 02:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgD2Aos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 20:44:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:57050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbgD2Aos (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 20:44:48 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29B78206F0;
        Wed, 29 Apr 2020 00:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588121087;
        bh=pKy4FrLkf1ACTJ00uw8cEOwvQ0SaoPDXLQaY91MyLMI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=jiKYfkZNtQUuCWCAHoPs61RUfIYz1po7EsJxexg6UJc24G6B2N7RV8el2Bjp0my0B
         G47LhV1on1JKp8EjKamSaDfVLrs1EpINU26fW35wBHHRqp95wA6yOe9xrDhXYgGjgZ
         DP2lKBammM/1wSUcPxNHTrz3OiBSWhSYPfmysxkg=
Subject: Re: [PATCH 4.19 000/131] 4.19.119-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200428182224.822179290@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <3b3adfab-cd30-5516-ec63-2e5b8fb40d25@kernel.org>
Date:   Tue, 28 Apr 2020 18:44:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/28/20 12:23 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.119 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Apr 2020 18:20:45 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.119-rc1.gz
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


