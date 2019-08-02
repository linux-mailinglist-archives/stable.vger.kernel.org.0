Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBB480331
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 01:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389351AbfHBXZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 19:25:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389345AbfHBXZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 19:25:42 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E8BB20880;
        Fri,  2 Aug 2019 23:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564788341;
        bh=moP7yGELMRVCRSa3TC3FlTzQYEhiVNu9R5lupCR9Qn8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=vKQMlmDU3AM3YsVYf14Jv5x0wb4ORtK0ZFCcsAv9tD+15ls53oK1ynatJvV8ZPfpw
         KuAFnhzUqiGpz/Hhw2WUrGoF7E1/fftL+/Zm2HDMZHzgos+X1Fa74onMLrHSKM6imN
         cLi3gf105PZKdcfUisx3LPivd0bSi8pdfawNiJbg=
Subject: Re: [PATCH 5.2 00/20] 5.2.6-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190802092055.131876977@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <3245056b-0437-72d8-6aeb-749e6bce8793@kernel.org>
Date:   Fri, 2 Aug 2019 17:25:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190802092055.131876977@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/2/19 3:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.6 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 04 Aug 2019 09:19:34 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

