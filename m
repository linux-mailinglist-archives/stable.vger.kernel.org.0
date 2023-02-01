Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 561F16871C7
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 00:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbjBAXTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 18:19:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjBAXTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 18:19:13 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303C35264;
        Wed,  1 Feb 2023 15:19:13 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id z1so10721008pfg.12;
        Wed, 01 Feb 2023 15:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZCpAfT76lyu9WSQ8sHNsBdoZYA3P4hVoZekbvfvR1LI=;
        b=DKHC7S+NYDvR4NW+8PEjb/MU79hC8oKcJFX6OpxY7ehBmP2ocp7y+KJg7cqy0SHCZv
         omO9170g0ssDa4dEFGw1TN2wgFzAbkyhFtiqFSIpIE5ixMKn79/wN9ptKO2su2NwXmvC
         P/bT5nT6WZNvOiFUSBe+V2hkWA24bU3UoB4SqpXoggFtdWlz2q6ZsA+/vfu9DPs4wKVF
         na8a78DjHv9JlpoU8b2tdm1avKm9NRm7+jM8YSt/1oTMZ4W/WpIK5liGa7dMYN5vdkoA
         R5b8WQFNNkd40WVX2IchxWbP59iflE9VcoOM4dL1E+y37eF12tjyS7B7PZE1rxVmMcYB
         ymvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZCpAfT76lyu9WSQ8sHNsBdoZYA3P4hVoZekbvfvR1LI=;
        b=wIoU4jESJPlWJGv2T/dQdw8AcMy6KmLWZ3cX7tAtjz7r5np+pTnUeUQXgdXaMd8/mq
         cAB6RTr+RsetQiXm8BVE7KStnLddievraIChn6HuNecA8gzAqxIMzpJzbNhJul1O9jGc
         812bh4s6WUnZuONxcT+k6yruCboKkfuZVG+vMj9gWsnKcI8lOgJmtXw60UZYHYpy0U8W
         AEWn77AWc/xMc6b2aulWTJPUe6iFAnZm9jdGkCJQ+yxCB5QsrNmyl7j+hpix7gy9I81N
         gAPXEqRb92mc+DEqmXsH38bnoylAieChzGAS7nBk3serjSlsWQAuey7HXYz4QnMuTXdh
         UDxA==
X-Gm-Message-State: AO0yUKU3DwdKU+QPejThRox861YbX684TFi4fvVVsk7GJXdyMrssqJ7E
        Ic3M7DU23g+wn5tR4KGTII3naXRZj77++g==
X-Google-Smtp-Source: AK7set/IcQBUvBSZs+t3KuIOdX+M9J7f1R/17y/44RT9X902YXrEf+YxcSqNcfX5+eeMHnFaOhVb5g==
X-Received: by 2002:a05:6a00:1818:b0:58d:b8f8:5e2f with SMTP id y24-20020a056a00181800b0058db8f85e2fmr5249624pfa.10.1675293552489;
        Wed, 01 Feb 2023 15:19:12 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g62-20020a625241000000b00580fb018e4bsm6336137pfb.211.2023.02.01.15.19.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Feb 2023 15:19:10 -0800 (PST)
Message-ID: <319ebea0-61dc-2e08-f48b-4555b8fb894a@gmail.com>
Date:   Wed, 1 Feb 2023 15:19:08 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH stable 5.4] usb: host: xhci-plat: add wakeup entry at
 sysfs
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Matthias Kaehlcke <mka@chromium.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        "open list:USB XHCI DRIVER" <linux-usb@vger.kernel.org>
References: <20230201174404.32777-1-f.fainelli@gmail.com>
 <20230201174404.32777-3-f.fainelli@gmail.com> <Y9qsZysFUFnq7VQW@kroah.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <Y9qsZysFUFnq7VQW@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/1/23 10:16, Greg Kroah-Hartman wrote:
> On Wed, Feb 01, 2023 at 09:44:04AM -0800, Florian Fainelli wrote:
>> From: Peter Chen <peter.chen@nxp.com>
>>
>> commit  4bb4fc0dbfa23acab9b762949b91ffd52106fe4b upstream
>>
>> With this change, there will be a wakeup entry at /sys/../power/wakeup,
>> and the user could use this entry to choose whether enable xhci wakeup
>> features (wake up system from suspend) or not.
>>
>> Tested-by: Matthias Kaehlcke <mka@chromium.org>
>> Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
>> Signed-off-by: Peter Chen <peter.chen@nxp.com>
>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>> Link: https://lore.kernel.org/r/20200918131752.16488-6-mathias.nyman@linux.intel.com
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>   drivers/usb/host/xhci-plat.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Why is this new feature needed on these older kernels?  What does it fix
> that is broken?

It fixes the inability to make the XHCI controller a wake-up device 
since there is no /sys/*/*xhci/power/wakeup sysfs entry to manipulate 
unless this patch is applied.

> 
> And why not just use a newer kernel release if you want to use this
> feature?

Because I maintain multiple version streams so I have always have a way 
to compare an older with a newer kernel and ensure they all behave properly.

This should have been flagged with a Fixes: tag IMHO in the first place.
-- 
Florian

