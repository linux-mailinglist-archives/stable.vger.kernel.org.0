Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 931ECB9BDB
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 03:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730700AbfIUBfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 21:35:33 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37715 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730577AbfIUBfd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 21:35:33 -0400
Received: by mail-pg1-f193.google.com with SMTP id c17so4836350pgg.4;
        Fri, 20 Sep 2019 18:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cG6pK6g8mILCzIeCbPb83Sm/c/ST2SxJA3L6TFupHl0=;
        b=NKu9iWsOkkBwgHTLaSBHWNDWLV9++0u0BS489h3vpsGDnao600EqYfdRM/8b8YoYpq
         71cXRyNlzG1OX/km32DK9qa2WjqW15uvViB5GOS/9p1da+1Jg+CIpUw5k1juH8WHBXxp
         QXEtzqlZarOkF3H3xMXaXYiIsNTkuCwvGGwBabWX9v4qJQ6IYgN4jXQKdr5EBPbZ3eaB
         No/yV3ZGtih53Yt+Eb66iKxtSa4M0UlI5BCSAI0oKdPswNgABm7zu1AB9GwJX/StUyGG
         7nrBu+AQSXf7g+hB3tJJhiyl75Hs/bTn0UUwcp5LVI5EmgriZr3uSGQUP7hBM+696NZi
         1iLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cG6pK6g8mILCzIeCbPb83Sm/c/ST2SxJA3L6TFupHl0=;
        b=MBhmTEYJGo1SMX+c+pYSjmVxV94vFmLOhQUlSF6VkI7d/YMKznYdNTMd5v/ALohi6S
         +udYJN/BCMmLQXxWYbNlqbcfDBux1oDVP1ooKrfNvgaAV4Yd9m6dv2+sk2HZin3aM5Om
         kf0MxR6SPoVN2tJrb/00hVbV9WloPwOOE7P/fMGnjtWwjGBYQk2babiE1I7FOehNxKsF
         KA/8+WF++K7eW6FsLn2HWQUjZ7so6neHlf2z3O3MZ7rh7d+gtl9Ssqkye3edH89XkvFM
         zir1XOWZtH9rnrCfODgLxXipXqVqYKL/KU9LFKMDM8UCwZleYyhyEBzQ9DAp3JEClGT/
         EJgw==
X-Gm-Message-State: APjAAAVQ6spjIIVWu9vnZw9rzHUM4Dyvjkjr0y5sIuFmvR0redBb1QB5
        NP2Y2p/SrdlkpgZ8sO8gbNM=
X-Google-Smtp-Source: APXvYqyPlEP4WZSv/rpR6LZ9eXZKEP1/q7+IhkP5qRwObubTv846muFCmkT+juqInEAsfUlnz1M+ng==
X-Received: by 2002:aa7:8d4b:: with SMTP id s11mr21137720pfe.132.1569029732581;
        Fri, 20 Sep 2019 18:35:32 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w6sm6339926pfj.17.2019.09.20.18.35.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Sep 2019 18:35:31 -0700 (PDT)
Subject: Re: [PATCH 3.16 000/132] 3.16.74-rc1 review
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
References: <lsq.1568989414.954567518@decadent.org.uk>
 <20190920200423.GA26056@roeck-us.net>
 <8dbced01558cd8d4a1d4f058010e7d63e5f6810e.camel@decadent.org.uk>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <63537eba-48f6-a394-f220-45b4ad543dee@roeck-us.net>
Date:   Fri, 20 Sep 2019 18:35:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <8dbced01558cd8d4a1d4f058010e7d63e5f6810e.camel@decadent.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/20/19 2:16 PM, Ben Hutchings wrote:
> On Fri, 2019-09-20 at 13:04 -0700, Guenter Roeck wrote:
>> On Fri, Sep 20, 2019 at 03:23:34PM +0100, Ben Hutchings wrote:
>>> This is the start of the stable review cycle for the 3.16.74 release.
>>> There are 132 patches in this series, which will be posted as responses
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Mon Sep 23 20:00:00 UTC 2019.
>>> Anything received after that time might be too late.
>>>
>>
>> Build results:
>> 	total: 136 pass: 135 fail: 1
>> Failed builds:
>> 	arm:allmodconfig
>> Qemu test results:
>> 	total: 229 pass: 229 fail: 0
>>
>> Build errors in arm:allmodconfig are along the line of
>>
>> In file included from include/linux/printk.h:5,
>>                   from include/linux/kernel.h:13,
>>                   from include/linux/clk.h:16,
>>                   from drivers/gpu/drm/tilcdc/tilcdc_drv.h:21,
>>                   from drivers/gpu/drm/tilcdc/tilcdc_drv.c:20:
>> include/linux/init.h:343:7: error: 'cleanup_module'
>> 	specifies less restrictive attribute than its target 'tilcdc_drm_fini': 'cold'
>>
>> In addition to a few errors like that, there are literally thousands
>> of similar warnings.
> 
> It looks like this is triggered by you switching arm builds from gcc 8
> to 9, rather than by any code change.
> 

After reverting to gcc 8.3.0 for arm, I get:

Build results:
	total: 136 pass: 136 fail: 0
Qemu test results:
	total: 229 pass: 229 fail: 0

Sorry for the noise.

Guenter
