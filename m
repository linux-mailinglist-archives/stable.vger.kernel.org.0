Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6EDA180A81
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 22:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgCJVcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 17:32:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgCJVcS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 17:32:18 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE5B2208C3;
        Tue, 10 Mar 2020 21:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583875938;
        bh=krPSIEZ2F/hA74wColUFSAT1UABB88jixa8bZnvs/xg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=SkzhmiOczfo2r195XwaoFxD1kw2DvypQE6k1T3M7KnJNGBfR8BapL3+gqH5tkY1NE
         ikD7psqckH/3rlgUqjwrh/txZDxAQcw4P0JI2UKVXkXhFFITwaLcgg8hHIvPQXZPeS
         pTbg3XgTXYk4IOBuitsgv4hXbCjO8jr0XLpLhvkQ=
Subject: Re: [PATCH 4.9 00/88] 4.9.216-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200310123606.543939933@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <fc4053a7-d156-027c-5b80-45efc4f51559@kernel.org>
Date:   Tue, 10 Mar 2020 15:32:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200310123606.543939933@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/20 6:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.216 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Mar 2020 12:34:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.216-rc1.gz
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
