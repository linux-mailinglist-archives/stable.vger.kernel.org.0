Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45CB78032C
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 01:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbfHBXWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 19:22:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:32942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbfHBXWd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 19:22:33 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7121B20679;
        Fri,  2 Aug 2019 23:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564788152;
        bh=1+OEXJUFkEGSCdGeiYuZjgdyMF6/oxUGrsUxYyhH+AU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ZLmj01zWMZxk0kSs+AJrgzS+4wdIVnzv2NSf2B8CR5E63tsd6g8M6WOWOiw3+v2VA
         JbcQDrJRECSz88ai9YFTW7S0RvHWd6qWvcWTaZJNq0g1xcBiJ9agMw9RYZDJGzgWWF
         6U8c6PGz73aMriTe52F99BdbZw1GA072BrGn/hfA=
Subject: Re: [PATCH 4.19 00/32] 4.19.64-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190802092101.913646560@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <aee9e88f-d8b4-cbf7-e684-0e791ab7d9f5@kernel.org>
Date:   Fri, 2 Aug 2019 17:22:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190802092101.913646560@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/2/19 3:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.64 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 04 Aug 2019 09:19:34 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.64-rc1.gz
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
