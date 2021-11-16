Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460624538AA
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 18:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238947AbhKPRoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 12:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238906AbhKPRoK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 12:44:10 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D2DC061570
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 09:41:13 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id r11so27538915edd.9
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 09:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=balfug.com; s=gm;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=N/Ra6v55uwZlxh7ACKYeWMd/AkggmkAVuLy/+xLZBrU=;
        b=LQZ2+51Dn1/ZwP7zS+Fc6HKATPdLgZB6HmG1fmvwC7PdGmLYV4NRG3BhigbBjHJ95H
         5VeLu6S0UMKqmkSlEjLkMZ6Lwk361GE1zspkqok9cxwipqwTUx6q8o8xUxRbCLVX/mUn
         V4ZiE+oHtEO926V95peas4a/wrGwmC9/n/5XK5MA/UgPRvLESBxXG9A2MmKbtupBk7jD
         uX7G6p1mHPmFgdSbIhw4WgV6iFAzV8Ztw4hy0VzNrSx7rbQNuRDgMpTyFRawCb4MdtZd
         X5JNSOhueL13IRcX3G+vxAWUVJb9vRKJO7kGKDIZTuV39JQoRFLRZiCGY4HjtijeT9hA
         ltKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=N/Ra6v55uwZlxh7ACKYeWMd/AkggmkAVuLy/+xLZBrU=;
        b=E5lvsP0u2rYojKNtHaR3AjeWoXEUEQLCbR31I7ebMRiGeNkMCW8X4+0Q4HTsyu1/6H
         4e3XzTEnbBPswaqXIrklv/Q9o7JiT8k9cYZQMrQ2CuQ9zcZVKnTqF1WiGg/OzztVg7Hp
         zkDWqXstFbBjKig2f6uocKouspjLOoPS++6CbsYd4Uc8HZYTwhVTFma7aqT/BGYrBVky
         VXzTvMmDWfaAkPg9lR88iCqtDCfCfW/kCFShw71nOvRDOZ7US34SFuc/gAOnruTdSZJc
         K5MhHIAuXpmfhIhWsRCHYTbrKStuaC2zddGm7GonQ5q0CSTWbiKBSvE5EZxvoCsN+q4A
         efLA==
X-Gm-Message-State: AOAM5337jyhCFeMHR2rPCMLnEenkXnK9c43ctzE6ZDlJ3rO/HReRyXuP
        ggiFWOgS0/9cj0hubuWc7RHVqQ==
X-Google-Smtp-Source: ABdhPJx9MoUC1Up2HbYKGg5SUqOTqBrNMq4+nEuajLQGozJcYAlMcrW6fJWJOu9Y8ccVht1InuywPA==
X-Received: by 2002:a17:907:1b25:: with SMTP id mp37mr12050961ejc.140.1637084471331;
        Tue, 16 Nov 2021 09:41:11 -0800 (PST)
Received: from ?IPV6:2001:4c4e:1994:7801:617f:1593:5593:bc3e? (20014C4E19947801617F15935593BC3E.dsl.pool.telekom.hu. [2001:4c4e:1994:7801:617f:1593:5593:bc3e])
        by smtp.gmail.com with ESMTPSA id hs8sm8796200ejc.53.2021.11.16.09.41.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 09:41:11 -0800 (PST)
Message-ID: <62685363-e1b3-bc97-431e-a7c8faccb78d@balfug.com>
Date:   Tue, 16 Nov 2021 18:41:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] Bluetooth: btusb: Add support for TP-Link UB500 Adapter
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Marek Vasut <marex@denx.de>
References: <aa3f6986-1e9b-4aaa-e498-fd99385f4063@denx.de>
 <YWPrSHGbno3dODKr@kroah.com>
From:   Szabolcs Sipos <labuwx@balfug.com>
In-Reply-To: <YWPrSHGbno3dODKr@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/11/21 09:44, Greg Kroah-Hartman wrote:
> On Sun, Oct 10, 2021 at 10:59:06PM +0200, Marek Vasut wrote:
>> Hello everyone,
>>
>> The following new device USB ID has landed in linux-next recently:
>>
>> 4fd6d4907961 ("Bluetooth: btusb: Add support for TP-Link UB500 Adapter")
>>
>> It would be nice if it could be backported to stable. I verified it works on
>> 5.14.y as a simple cherry-pick .
> 
> A patch needs to be in Linus's tree before we can add it to the stable
> releases.  Please let us know when it gets there and we will be glad to
> pick it up.
> 
> thanks,
> 
> greg k-h

Hello Greg,

The patch has reached Linus's tree:
4fd6d4907961 ("Bluetooth: btusb: Add support for TP-Link UB500 Adapter")

Could you please add it to stable (5.15.y)?

Thanks,
Szabolcs

