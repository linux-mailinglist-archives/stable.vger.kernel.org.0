Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44F4719B6E7
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 22:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732904AbgDAUVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 16:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732385AbgDAUVk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 16:21:40 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BECC920784;
        Wed,  1 Apr 2020 20:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585772500;
        bh=CvBMEziJK6QTVlRs8WBNAwTidyoTQln1TJB/ijH5s8M=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ClLciJ4wwJ2Bi9vwk8jX59vF6SEUrkYu/yLIiIegCQVjYryjiMv7fXJhloDT5ngah
         cphVBEf+77zGu3G0k8acW0GKXB1EOWMOBG2YT2Qt7kVCoW4WdEf7d/AtQ788wn9/GI
         2i+SohRFRH3bs9NCYu2mID0Ds7WpuMF0B0EfAyDw=
Subject: Re: [PATCH 5.6 00/10] 5.6.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable <stable@vger.kernel.org>,
        shuah <shuah@kernel.org>
References: <20200401161413.974936041@linuxfoundation.org>
 <CAHk-=wiVBvO1b5UzfcHm6y4KLHOp3huFfGMdW21F6g25oUePLw@mail.gmail.com>
 <20200401172242.GA2582092@kroah.com>
From:   shuah <shuah@kernel.org>
Message-ID: <e335c0cf-640a-31a9-54fe-45493e006f3e@kernel.org>
Date:   Wed, 1 Apr 2020 14:21:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200401172242.GA2582092@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/1/20 11:22 AM, Greg Kroah-Hartman wrote:
> On Wed, Apr 01, 2020 at 10:06:47AM -0700, Linus Torvalds wrote:
>> On Wed, Apr 1, 2020 at 9:19 AM Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>>
>>> This is the start of the stable review cycle for the 5.6.2 release.
>>
>> Good. You made 5.6.1 so quickly that I didn't have time to react and
>> say that it makes little sense without the 802.11 fix, but you're
>> obviously making 5.6.2 quickly, so..
> 

wifi issue I was seeing on my laptop with 5.6.0 is now resolved.
Thanks for pulling this in quickly.

thanks,
-- Shuah
