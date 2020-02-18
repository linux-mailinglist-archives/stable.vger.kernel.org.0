Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B45191636B2
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 00:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbgBRXCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 18:02:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:36684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727298AbgBRXCt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 18:02:49 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB2D62173E;
        Tue, 18 Feb 2020 23:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582066969;
        bh=2AKDvd36MyttW56BeXPy2flInfAoyRcXnCj4KGVY8rk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=D5gKxVvqnJcFQOLrxmtcO30le3tVvnXkZoZ4dk/g3RyOdCsdY1NZ/SkFS9ak5OSZa
         OqgeoGQ2JpN4hynkEsBQxrEAcaszx1vcjiYn1q4zEU3d9XnvRNc+ie9/gErefotDcM
         3H2yt9FB/7gxpTW/kfm8tSyX2q/yH07Afj9H6ZbM=
Subject: Re: [PATCH 5.5 00/80] 5.5.5-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200218190432.043414522@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <263059ef-8934-23fc-ddcd-fe91b0eaf4b7@kernel.org>
Date:   Tue, 18 Feb 2020 16:02:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/18/20 12:54 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.5 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Feb 2020 19:03:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.5-rc1.gz
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

