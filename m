Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 401789C097
	for <lists+stable@lfdr.de>; Sat, 24 Aug 2019 23:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbfHXVtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Aug 2019 17:49:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727956AbfHXVtd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 24 Aug 2019 17:49:33 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FA312133F;
        Sat, 24 Aug 2019 21:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566683372;
        bh=AEi9xsN3Xx/abMEbB13bCDWDcwoVz1r6hZ6AC4FqEgY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=td9MUgrzMnGqZn8/N5xZvEi0gIOVZV3AvIn1KQJ7zBX8PGr99ohGoM4Wt75d2ETHb
         JfeTD51UFPo3o0k2Wna5faSJehIXN1pHRJfeIbMUl4G0okK/vKCivoABjEbf62EQqC
         AL8/GEPjceVscqgtEAvoQ3ezoWLbWhj55F2dvvXI=
Subject: Re: [PATCH 5.2 000/135] 5.2.10-stable review
To:     Greg KH <greg@kroah.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, shuah <shuah@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
 <00216731-a088-7d47-eafb-70409f876bda@kernel.org>
 <20190824023829.GE9862@kroah.com>
 <e4d5ba59-8e38-a267-8a14-3c6bc03f77bd@kernel.org>
 <20190824153348.GA27505@kroah.com>
 <93850e40-7df9-b5db-bda4-5b4354d2c3f3@kernel.org>
 <20190824181445.GA10804@kroah.com>
From:   shuah <shuah@kernel.org>
Message-ID: <bf9b854f-0144-1260-9bab-d9d2ea455864@kernel.org>
Date:   Sat, 24 Aug 2019 15:49:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190824181445.GA10804@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/24/19 12:14 PM, Greg KH wrote:
> On Sat, Aug 24, 2019 at 11:01:19AM -0600, shuah wrote:
>> On 8/24/19 9:33 AM, Greg KH wrote:
>>> On Sat, Aug 24, 2019 at 09:21:53AM -0600, shuah wrote:
>>>> On 8/23/19 8:38 PM, Greg KH wrote:
>>>>> On Fri, Aug 23, 2019 at 12:41:03PM -0600, shuah wrote:
>>>>>> On 8/22/19 11:05 AM, Sasha Levin wrote:
>>>>>>>
>>>>>>> This is the start of the stable review cycle for the 5.2.10 release.
>>>>>>> There are 135 patches in this series, all will be posted as a response
>>>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>>>> let me know.
>>>>>>>
>>>>>>> Responses should be made by Sat 24 Aug 2019 05:07:10 PM UTC.
>>>>>>> Anything received after that time might be too late.
>>>>>>>
>>>>>>> The whole patch series can be found in one patch at:
>>>>>>>             https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.2.10-rc1.gz
>>>>>>
>>>>>> I am seeing "Sorry I can't find your kernels". Is this posted?
>>>>>
>>>>> Ah, Sasha didn't generate the patch but it was still listed here, oops.
>>>>> He copied my format and we didn't notice this, sorry about that.
>>>>>
>>>>> As the thread shows, we didn't generate this file this time to see what
>>>>> would happen.  If your test process requires it, we can generate it as I
>>>>> don't want to break it.
>>>>>
>>>>
>>>> It will make it lot easier for me to have continued support for patch
>>>> generation. My scripts do "wget" to pull the patch and apply.
>>>
>>> Ok, we will get this back and working, sorry about that.
>>>
>>
>> Great. Thanks for accommodating my workflow.
> 
> I have uploaded it to kernel.org now, should show up on the "public
> side" in 15 minutes or so.
> 

Great. Downloaded successfully.

thanks,
-- Shuah

