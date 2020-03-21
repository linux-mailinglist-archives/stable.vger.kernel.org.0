Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE4D18DC8E
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 01:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgCUAkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 20:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbgCUAkW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 20:40:22 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01C9D2070A;
        Sat, 21 Mar 2020 00:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584751221;
        bh=KPTTZRR0P1krQVF9aGGXYjeBN6m0kMJWsQK1NP3CY0c=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=u9oer6e8glTW6WNO/0mTSpDEoTMszTLT8AK4qLApltuL2Ksrga40OrZRBuxXPNzvj
         W8GAnXYd2yzParOUl2Yb7qTMGHPlQILuYI/Gmn5Bo2wR0g85nh6DTK5SQZvn1FsSi8
         MNl3Cb7Hp9rkRN7uvANAKmzCwSFL8hFf/0iFdZwY=
Subject: Re: [PATCH 4.19 00/48] 4.19.112-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200319123902.941451241@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <cb1fa4c2-bfee-2632-bac7-696fc57fae93@kernel.org>
Date:   Fri, 20 Mar 2020 18:40:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200319123902.941451241@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/19/20 7:03 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.112 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 21 Mar 2020 12:37:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.112-rc1.gz
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
