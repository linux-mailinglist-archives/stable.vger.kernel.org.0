Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D511C28D9
	for <lists+stable@lfdr.de>; Sun,  3 May 2020 01:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgEBXRe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 May 2020 19:17:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbgEBXRe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 2 May 2020 19:17:34 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFB4E20787;
        Sat,  2 May 2020 23:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588461454;
        bh=aC7Kcfh8UBeMXZzvDPo5DsZGjFonufPfw+jtUrV+K54=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=kSIDeyZEHsTeK7hpVamF/p9+EZ+LjwI9jvDroI4TnuSgTn1xPwrM/TUAkzn9LHY4b
         GmQufjZJb0GwNrgHBzxmS+FwUhc3ELIGzV9x2tMpMqsvaSLaQ+p5kjzw1HZF2xM5X1
         AODkbXZgYGlZ8T776FGsjJ7OCvQm/l3kulhMEpSk=
Subject: Re: [PATCH 4.14 000/117] 4.14.178-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200501131544.291247695@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <004c336c-d777-f83f-377e-0f5b19ccf45a@kernel.org>
Date:   Sat, 2 May 2020 17:17:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/1/20 7:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.178 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 03 May 2020 13:12:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.178-rc1.gz
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
