Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10660189265
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 01:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgCRAET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 20:04:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727069AbgCRAET (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 20:04:19 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F293820663;
        Wed, 18 Mar 2020 00:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584489858;
        bh=1OChrTv7HDour+0JZeaq2hFfIPsmggH5Wta+wO6QGZM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Ua70HNHMvyK/K7hMR6gf5YsX1KjzFIGxK4KwD3f+AlOviAXNNBTi1dF+CDkRfLUs1
         n7iswXqa+Y8v9xjnoKEA0W/bQm2C51y62wVLKsaJ8vc4FYldShuR7mdtFwQXrNdx0p
         mrx8SIfGb5Igzi44inuZs117zVuMVv6yHN8ckVIg=
Subject: Re: [PATCH 5.4 000/123] 5.4.26-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200317103307.343627747@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <2ae52030-77bf-cc33-25c8-2a3a74e87d11@kernel.org>
Date:   Tue, 17 Mar 2020 18:04:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/17/20 4:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.26 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Mar 2020 10:31:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.26-rc1.gz
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

