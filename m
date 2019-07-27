Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3D5C77603
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 04:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfG0Cfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 22:35:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbfG0Cfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 22:35:45 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 675FB2084D;
        Sat, 27 Jul 2019 02:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564194945;
        bh=e+x+syFw3dy9WkhyBY2TKrYzZKh5oqtUT6blMfUKxIg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=AwwtxnvSY6mBDtuymRx1EUUKHVR8H80csvMyfMo2IU/RH+Aw07u4zZ/NzmaYCm/KT
         unHi5XoOkbQquT8NH0FsqhEwB81AgDE7r1xBa9XYTYf+U5q5LVmsRCAgXpjYqsy53X
         qMxEEsaIpfFiSnZxpHUQz09Ta9xkRH4tb01Z1kuA=
Subject: Re: [PATCH 4.19 00/50] 4.19.62-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190726152300.760439618@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <308bd1a9-1077-2ff9-9c91-d580b5faac0e@kernel.org>
Date:   Fri, 26 Jul 2019 20:35:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190726152300.760439618@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/26/19 9:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.62 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 28 Jul 2019 03:21:13 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.62-rc1.gz
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

