Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C560DAA6A2
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 17:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390160AbfIEPAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 11:00:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389796AbfIEPAt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Sep 2019 11:00:49 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC886206A5;
        Thu,  5 Sep 2019 15:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567695649;
        bh=yhgyCiB+I9wAcv8ppJAFLmRKDtH0ObHuh3loI62ivI0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=i8g21wcK+xIi0s3Y0J5TOvQFCSeYJqVsbuB7qyqEdNsiFa0OI9Xm9+3PpW08chnym
         2G3ivKWmoMgtz+5MEaU09eMl1+5flLgw7ZyTRxpDG7r7tFAj/D51fCJpXU+JNfUD0Q
         7UTuZSXSCU3ovQVC4dm0bps/sCJ/0Gg0HrZMSSLU=
Subject: Re: [PATCH 5.2 000/143] 5.2.12-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190904175314.206239922@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <a27a3bd5-8b11-8e7f-88ce-58444410f9a7@kernel.org>
Date:   Thu, 5 Sep 2019 09:00:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/4/19 11:52 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.12 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Thanks,
-- Shuah
