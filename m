Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8FC1A45F
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 23:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbfEJVOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 17:14:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727767AbfEJVOX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 May 2019 17:14:23 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D40E020896;
        Fri, 10 May 2019 21:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557522863;
        bh=OiD4klmlDx4ebr58MRTAUWVkd1ubPKp5dZly/Zy+rw4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=pZwH7vsNtJ731NggO+1fV6rh764EQUo2A4IDRPgXIfGG5TLGX4y73wykfvTh1S+tR
         o0guKsPffmJLF4UtyPYPKRnYnUPwGDOC2TaSTtX6uOLEbZKEmxMZRPnzkECE6Te6Vt
         Tu0GphLu3Wk5FwiCeNxB7ghKgzLlHS9tdFURLVis=
Subject: Re: [PATCH 5.1 00/30] 5.1.1-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190509181250.417203112@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <c6179816-83d8-a12e-5bfb-256f23f835db@kernel.org>
Date:   Fri, 10 May 2019 15:14:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190509181250.417203112@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/9/19 12:42 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.1 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 11 May 2019 06:11:35 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

