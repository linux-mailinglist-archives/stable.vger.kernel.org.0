Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71152163745
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 00:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgBRXeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 18:34:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:41350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727772AbgBRXeE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 18:34:04 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B644222B48;
        Tue, 18 Feb 2020 23:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582068844;
        bh=tADbs7+vMmC2wdGtNIYrUlaWEITG75T1VqIEm5r6Nm8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=LDWTd+fNRWQ710TkyAFGVODdJxYPatd97J79NivbbuINMgJoo5ay7m19cT7EVZaQz
         h3oSt+g+5ybQj4jr+v1/tBA0k4e7BO3YPT0s0szZLaIQQWLEXZIIlo9qF9BGoI+Box
         ha9XDcO2SiY5BYXHVi/d+yDP1uHRtLTIBgfxhRd0=
Subject: Re: [PATCH 5.4 00/66] 5.4.21-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200218190428.035153861@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <76af662b-927a-2b6a-ab0b-2465a9d52d6d@kernel.org>
Date:   Tue, 18 Feb 2020 16:34:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/18/20 12:54 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.21 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Feb 2020 19:03:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.21-rc1.gz
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

