Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBC6FF036E
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 17:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390333AbfKEQv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 11:51:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:37910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390275AbfKEQv4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 11:51:56 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6002721928;
        Tue,  5 Nov 2019 16:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572972715;
        bh=qTZGep5Lv9b0TMShhRGJjX+mlz99RHwlP8ngyhOcgls=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Vz6Lsr1kJTX9OblGJ94GPA+oIR0w/SHADTdf0X8zagRgK7kU7sk/wemWhfoBGqCd5
         iP3MVrKiCEiRD64wVDhzu9Hw9ni+zp1wgHLQ2NdKDKP3AZ0/3eLWN+J7XlUGjwM6de
         0v6Tyao8uY01mcWW6kpAdqPjt4s+97dllMdJTAyg=
Subject: Re: [PATCH 5.3 000/163] 5.3.9-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191104212140.046021995@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <82ebb88b-6828-2c80-e4ac-891427e90f2a@kernel.org>
Date:   Tue, 5 Nov 2019 09:51:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/4/19 2:43 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.9 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 06 Nov 2019 09:14:04 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
