Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344BA1CE203
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 19:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbgEKRtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 13:49:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgEKRtH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 13:49:07 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7586206D7;
        Mon, 11 May 2020 17:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589219347;
        bh=hAMVqWBjyLV3nWm3Je7DHAFzlAVeVx9EPwxdRkkE0Oc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=PJlwgjW4o15eOpGfmwAHGURNVdLup0NdgDSgCP5x1mY8rm3VPLRqwTJsfMtaqo803
         jPYRe51e5tP3Zcj4vayfSbHRbTBLYRs62KpfpR0YdC09hqHG/i1umhsV1zgA7DinMA
         5aH5euLMv6+BqbYjq1LFyQPIHRMaXvdpAi0hw5zc=
Subject: Re: [PATCH 5.4 00/50] 5.4.40-rc1 review
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        shuah <shuah@kernel.org>
References: <20200508123043.085296641@linuxfoundation.org>
 <e090d5ed-3e18-333e-221b-197a30c102e8@kernel.org>
 <6a43d9b82e321aef0324d10a5e2f3dc4961a7fe9.camel@codethink.co.uk>
From:   shuah <shuah@kernel.org>
Message-ID: <136f7e48-08ec-bb3f-8642-cba71cca9b96@kernel.org>
Date:   Mon, 11 May 2020 11:49:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <6a43d9b82e321aef0324d10a5e2f3dc4961a7fe9.camel@codethink.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/11/20 11:21 AM, Ben Hutchings wrote:
> On Mon, 2020-05-11 at 10:35 -0600, shuah wrote:
>> On 5/8/20 6:35 AM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.4.40 release.
>>> There are 50 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sun, 10 May 2020 12:29:44 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.40-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
>> Compiled and booted on my test system. I am seeing the following
>> regression in dmesg and with a new emergency message.
>>
>> Initramfs unpacking failed: Decoding failed
>>
>> I don't know why yet. I will debug and let you know.
> 
> At a guess: you upgraded to Ubuntu 20.04, and the default initramfs
> compression changed to lz4.  Or something like that.
> 

Right, I remembered I ran into a similar problem after upgrading to
19.10 and went looking for info. instead of doing bisect.

That is what I found in the following thread:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1835660

Oddly it started showing up before I upgraded on Ubuntu 19.10.

thanks,
-- Shuah

thanks,
-- Shuah

