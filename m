Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2717E134D1
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 23:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfECVU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 17:20:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbfECVU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 May 2019 17:20:56 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D19C02070B;
        Fri,  3 May 2019 21:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556918456;
        bh=/WMzP40RbFtjcJ6LTGuEYzfrBOk69N5o+DTUgzHmpTc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=olWyYZD2caUzz600FIkFIWqOOEEQRC85kSJBySwJZo4l316iCM94BvwRb17GsZktp
         wvJvRK6Q4UD/8j4DwAQFVJFVnS+KkPFR2ZodBFtfoK/q7d/zMoyOEbnVEOxz448bAt
         FhYyHT8PeE+O4bBNQ88bZtPWuIzbIuP2OiazZCxw=
Subject: Re: [PATCH 4.14 00/49] 4.14.116-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190502143323.397051088@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <2ccd16f0-5c37-3e19-163d-32387cad0c68@kernel.org>
Date:   Fri, 3 May 2019 15:20:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190502143323.397051088@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/2/19 9:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.116 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 04 May 2019 02:32:06 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.116-rc1.gz
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
