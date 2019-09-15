Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04A86B30CF
	for <lists+stable@lfdr.de>; Sun, 15 Sep 2019 18:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731594AbfIOQJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Sep 2019 12:09:29 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39933 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbfIOQJ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Sep 2019 12:09:28 -0400
Received: by mail-pg1-f195.google.com with SMTP id u17so17987225pgi.6;
        Sun, 15 Sep 2019 09:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0DMl3xfabznWMbO20Q56GEPZg/nB8mi+Jij8NmjzC/Y=;
        b=tGqwvjqxs8C7GM39r+zKPrXhjZpWw1awlsnR27TfVBRU8WzSA+Rg0Zou7Uza+qA7xn
         6grp2xDAkkFCV1yM3yl648y9KP+N4FZV6t46kXJd/J+WOyUjlak5YGvL4JwtLaiS5JoZ
         LwzqPzGfzRCTQgnXhMmJPJCgTjl4NhnAXexH09Xo4IFW1fNHvZq/nl118OQpMQleM0/P
         5bANb3zrmU14/xeCDtpmSVZ8Kkv5Z3o9RiMTFN38je7A0aiZwkyF/9qVNeu4+fw7u7uT
         ltNpctdCJMd1majvNq1z4w+XaqYeVJ2aQm5WruUylm1u0W0ViZHFAkhBxfh7XqFxd8XG
         eNTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0DMl3xfabznWMbO20Q56GEPZg/nB8mi+Jij8NmjzC/Y=;
        b=sQkqZFju3Oi+3CinlS0mpl2Tr1o1I7vBjSI5FJ6fBW8ChWbhH2lJTXJoC6hHbzR2RX
         oXwigUBUh44g4wh4i+tk949AzSzyXgTVjtldFGJGIIRmT1Bs9NOmkue9uFkIsYt6VRLK
         Regew5oTccv2v5TDCOrZ3leOurQDjMdl8Q3H9nPlj1WCL/fy2UXBg/If1mTa6I7TSm9W
         t1jcrKclCj5mdmY354yYpJxxZzz5iMhfpt+7phqGIpAR81R2SvfXNmaeiyvUdBwPNOMV
         q5I4bx3a8iazen7eJGoZk1wPUWyd3fjRygxRtB6NQNQ9/zhJznLgIqK7+nSKCF2ry3nT
         AWkA==
X-Gm-Message-State: APjAAAWc+4SQ3yW6uotOiPZqO0dRjaDyIzGcjwX8GO3FN3YDM6ix7kD4
        lm9pckoc7Io3lHHJEzNRt18=
X-Google-Smtp-Source: APXvYqxetOfZyWP9i75ttJPQgJHGGWIhpSLUfvlrjejlBjv89V2O0HxshkQGj3iYyG0z1cidZB+lPQ==
X-Received: by 2002:a17:90a:b282:: with SMTP id c2mr16277908pjr.135.1568563767975;
        Sun, 15 Sep 2019 09:09:27 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x20sm21828429pfa.153.2019.09.15.09.09.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Sep 2019 09:09:26 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/14] 4.9.193-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
References: <20190913130440.264749443@linuxfoundation.org>
 <aefa6832-073e-493c-8576-5b2f06e714fb@roeck-us.net>
 <20190914083126.GA523517@kroah.com>
 <353c2b75-290e-c796-4cc6-88681936210f@roeck-us.net>
 <20190915125824.GA528036@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <8f402489-c8e8-38b2-88d1-d5eafe491492@roeck-us.net>
Date:   Sun, 15 Sep 2019 09:09:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190915125824.GA528036@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/15/19 5:58 AM, Greg Kroah-Hartman wrote:
> On Sat, Sep 14, 2019 at 05:49:32PM -0700, Guenter Roeck wrote:
>> Hi Greg,
>>
>> On 9/14/19 1:31 AM, Greg Kroah-Hartman wrote:
>>> On Sat, Sep 14, 2019 at 01:28:39AM -0700, Guenter Roeck wrote:
>>>> On 9/13/19 6:06 AM, Greg Kroah-Hartman wrote:
>>>>> This is the start of the stable review cycle for the 4.9.193 release.
>>>>> There are 14 patches in this series, all will be posted as a response
>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>> let me know.
>>>>>
>>>>> Responses should be made by Sun 15 Sep 2019 01:03:32 PM UTC.
>>>>> Anything received after that time might be too late.
>>>>>
>>>>
>>>> Is it really only me seeing this ?
>>>>
>>>> drivers/vhost/vhost.c: In function 'translate_desc':
>>>> include/linux/compiler.h:549:38: error: call to '__compiletime_assert_1879' declared with attribute error: BUILD_BUG_ON failed: sizeof(_s) > sizeof(long)
>>>>
>>>> i386:allyesconfig, mips:allmodconfig and others, everywhere including
>>>> mainline. Culprit is commit a89db445fbd7f1 ("vhost: block speculation
>>>> of translated descriptors").
>>>
>>> Nope, I just got another report of this on 5.2.y.  Problem is also in
>>> Linus's tree :(
>>>
>>
>> Please apply upstream commit 0d4a3f2abbef ("Revert "vhost: block speculation
>> of translated descriptors") to v4.9.y-queue and later to fix the build problems.
>> Or maybe just drop the offending commit from the stable release queues.
> 
> I'm just going to drop the offending commit from everywhere and push out
> new -rcs in a bit...
> 

A quick rebuild of previously failed builds now passes, so looks like we are good.

Guenter
