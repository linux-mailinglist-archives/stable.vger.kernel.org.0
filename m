Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC421AD291
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 00:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbgDPWG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 18:06:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728086AbgDPWGz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 18:06:55 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25EC721973;
        Thu, 16 Apr 2020 22:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587074815;
        bh=hCAq31jWvjwDjm1ybYR++jm9x1cJ+y25i32vOXn5GtQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=HCHy8/fIHimUD6A+rKWqywnlvD0znvCa+eoRjIRRfyZgax3w9TRs7swzilKhXTM9m
         oG7fhZnXs8FAsrQQK2H5LbMuqzXe9aAU1a22j4O+s55NyBWFuI996W7MTGkl68E9MQ
         EuBlU2ubc+ZEhdQnbyq5Kf6b7pKGQd5CHNMOwYms=
Subject: Re: [PATCH 4.19 000/146] 4.19.116-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200416131242.353444678@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <6f560dd4-16fd-67ea-38b2-d052e89939ed@kernel.org>
Date:   Thu, 16 Apr 2020 16:06:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/16/20 7:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.116 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Apr 2020 13:11:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.116-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.
This one is clean and reboot and poweroff worked just fine.

thanks,
-- Shuah
