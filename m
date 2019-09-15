Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 845DAB2D79
	for <lists+stable@lfdr.de>; Sun, 15 Sep 2019 02:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbfIOAtg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Sep 2019 20:49:36 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46593 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbfIOAtg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Sep 2019 20:49:36 -0400
Received: by mail-pg1-f195.google.com with SMTP id m3so17200549pgv.13;
        Sat, 14 Sep 2019 17:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wBnwMEJx+PEZA7JM/vwWY64MaNrTvo1uguBqSdFStAc=;
        b=dCAi/s+yyaNA4eqFert3ae70OzSYXOUoZOU2hvbsdsd5CsvSe4EP9eblaLpBU6FIeA
         kIJiSa8IONs2c4sNt0t7K2swBq9wsFZ/qiXr7hLSYHDHNDaQtXVXHAId1d/U3NtDRpJF
         YxqCtnkLFsFAOmNCqrap6QbOHh8fBeNKlaxDVOzZGyi8EIknbsbaIARNJG9bOd64G+5U
         EOs4g39xTzt5z0NwGrTnN+yO0kKh98RjeTM93K3Bp9P47l2vzsdwTqwyKSovqhwWKZFW
         Nz8g1hoRE89TiqwaC9h181DVCktnN3BEi170KQIzoSZ9KW2owfuQ0+vHlIyAkjkM2Fki
         yz8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wBnwMEJx+PEZA7JM/vwWY64MaNrTvo1uguBqSdFStAc=;
        b=GUEvpBpcuM8D0Ksnx5uLvgFj7eU6TdLjYQhvUXViUAiAft+9CgpVQbLO4Pib6Yirwl
         VzymJ0PxHiXVNNykyAmaC66zXy5cU+BLwyrxHeZEZJTANbz8NtiWrEOL3kqxMTNgN8sO
         1nEC1hfeTz1k45heKC1D4sSfhd6cgjEBFnXdijF6raQbjm4S5IOlWNdDDzocCP3pdRus
         L4EFGrg5ApgQ+R27GM3JFAU+tul8MjIaZtzHTLNA4pY4/1KXA2TKYdpQPQgc9DXcEaIq
         EyUrhXh7IoV47EIs/Ay7W8Q8ON1/SoQYMcCBxCvOSRWYL8egNTumrTNzKwNPlmfRqdrr
         CuMg==
X-Gm-Message-State: APjAAAX1Ypl5YylRGe8ztX0Ofe3ii8QiEP4JnQa5nWsZPlikTr9ano9Y
        MQO5HtVpib6doJotA3AXRolXEJaN
X-Google-Smtp-Source: APXvYqwkLHwZlWW5sGPEhhJBL97BHjBAICasaR63wnFysP0NS7/dBjFOId1IYvek/ubSplVfA+rsXw==
X-Received: by 2002:a63:fa13:: with SMTP id y19mr3333276pgh.262.1568508575720;
        Sat, 14 Sep 2019 17:49:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q13sm18946928pfn.150.2019.09.14.17.49.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 Sep 2019 17:49:34 -0700 (PDT)
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
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <353c2b75-290e-c796-4cc6-88681936210f@roeck-us.net>
Date:   Sat, 14 Sep 2019 17:49:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190914083126.GA523517@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 9/14/19 1:31 AM, Greg Kroah-Hartman wrote:
> On Sat, Sep 14, 2019 at 01:28:39AM -0700, Guenter Roeck wrote:
>> On 9/13/19 6:06 AM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 4.9.193 release.
>>> There are 14 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sun 15 Sep 2019 01:03:32 PM UTC.
>>> Anything received after that time might be too late.
>>>
>>
>> Is it really only me seeing this ?
>>
>> drivers/vhost/vhost.c: In function 'translate_desc':
>> include/linux/compiler.h:549:38: error: call to '__compiletime_assert_1879' declared with attribute error: BUILD_BUG_ON failed: sizeof(_s) > sizeof(long)
>>
>> i386:allyesconfig, mips:allmodconfig and others, everywhere including
>> mainline. Culprit is commit a89db445fbd7f1 ("vhost: block speculation
>> of translated descriptors").
> 
> Nope, I just got another report of this on 5.2.y.  Problem is also in
> Linus's tree :(
> 

Please apply upstream commit 0d4a3f2abbef ("Revert "vhost: block speculation
of translated descriptors") to v4.9.y-queue and later to fix the build problems.
Or maybe just drop the offending commit from the stable release queues.

Thanks,
Guenter
