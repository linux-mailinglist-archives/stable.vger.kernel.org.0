Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3767C9BF0F
	for <lists+stable@lfdr.de>; Sat, 24 Aug 2019 19:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfHXRve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Aug 2019 13:51:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbfHXRve (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 24 Aug 2019 13:51:34 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 030352146E;
        Sat, 24 Aug 2019 17:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566669093;
        bh=ncwvc5nmk2FoFnoZ+9xEzHh/gYayCluvZ+VxDuLhMhU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=sOavPHTspQ6C4XeJTNhCLFVk0WplCioXTW91lpolpaGEhuWfSn9N9rJE30Oa1xsWl
         XrNRZgvEUDp8zl5t8/2Ct6KtyG5D/mf5fGCUqm9x80dGTq2dmMGBhvrNTTxbdyIvI2
         tBcvCa70jOg6H8U7cgEEhxyKxby3KMAEmvF/f96U=
Subject: Re: [PATCH 4.19 00/85] 4.19.68-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190822171731.012687054@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <759662ef-8e9a-4107-feb3-2102ecd159ea@kernel.org>
Date:   Sat, 24 Aug 2019 11:51:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/22/19 11:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.68 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 24 Aug 2019 05:15:49 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.68-rc1.gz
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

