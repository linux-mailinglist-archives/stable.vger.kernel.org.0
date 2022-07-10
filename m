Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1801A56CF38
	for <lists+stable@lfdr.de>; Sun, 10 Jul 2022 15:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiGJNC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jul 2022 09:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGJNC5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jul 2022 09:02:57 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17337642F
        for <stable@vger.kernel.org>; Sun, 10 Jul 2022 06:02:56 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id sb34so4694322ejc.11
        for <stable@vger.kernel.org>; Sun, 10 Jul 2022 06:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yIAlSZFV4Kkp/tVYHAMUc1S88tixQEXBDlhbWfpHaV8=;
        b=PLt6FKllA9PGhfn2AxAguySa9occ1uE16gXwmwzDWf8zXZza7zPVUxQu59DmFzBJBA
         kfg1mQy4yZRfFcsyde3BvEGyq6rJ1OtrEuMk2W+4LGMHrInhy9lRQK+tRWyQPlZpvbFU
         6Ly9n+lRU0hlunrT4omIVO5X6FdfW9vwIAQeVLTrbTRISfkkDQtrR3Uq7YJ4Bda7l7Tc
         2RMfPVkQPrTf/1mbxh2bHuasb7XdQEK51b0rU1hOIPoSPtF7U9vJBelM7lpIA3sl77wh
         k4S54/e2QdS5ZgHQ3SlTj09R6i2rfbGzofS0Ife/yP3FUiqe9vKZS0lG0YVZnxxmxI46
         ms3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yIAlSZFV4Kkp/tVYHAMUc1S88tixQEXBDlhbWfpHaV8=;
        b=kwyh9ZfmjQLv166vx58oPXhS4bWtWRJtxUl+nCNfslE6haT37v0DP2iM/LXaMzrkSX
         +46x5Sib+4Z9NJqQCrJ6aQpO4YdDUC+gYCbNaLGt9Lug4lX2xFQB5MmxK1LsK4bJSB8W
         EuH3jJg0j63r3jFqeOBuZNsT4CkxPoACxvTkLnYwh57DHZ5q4102nN72tw1gTEm08eYS
         plJL/jKwxt0FqydqB8X9pES9hjbCZ1GhBsPQDzDObDERnlN4nonkrxSorKY7Y3GZ5e7C
         P9aWZZfgKhXTSNqxhZdohQMJ+iW7LUVr+QRZD5YVR15en+UMgo4RZUtQJNgI2A4S2Agb
         YdoQ==
X-Gm-Message-State: AJIora9cfiGCYWNWfT8o5TeDfniLiROp1flybHKs7N/XrAKehBvEcTl8
        sPq8u0OHR9TN7mbArQM6ZZg=
X-Google-Smtp-Source: AGRyM1uT0EjVAww60q9LKmOo5GR1itUUE/9Rql5aDyDlyyiC0R9BEs/zCfRA/tsYa5KZGag9QKDDuw==
X-Received: by 2002:a17:907:6287:b0:6e1:6ac:c769 with SMTP id nd7-20020a170907628700b006e106acc769mr13719528ejc.388.1657458174603;
        Sun, 10 Jul 2022 06:02:54 -0700 (PDT)
Received: from ?IPV6:2003:f6:af42:a000:bd65:5b56:da6a:a3d? (p200300f6af42a000bd655b56da6a0a3d.dip0.t-ipconnect.de. [2003:f6:af42:a000:bd65:5b56:da6a:a3d])
        by smtp.gmail.com with ESMTPSA id l17-20020a1709063d3100b0072b1c21ce65sm1557108ejf.150.2022.07.10.06.02.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jul 2022 06:02:53 -0700 (PDT)
Message-ID: <077a6d7d-e0a0-fab1-12df-871baa9be765@gmail.com>
Date:   Sun, 10 Jul 2022 15:02:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [GIT 4.9] LSM,security,selinux,smack: Backport of LSM changes
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <4230dd79-b64f-14e6-3614-02e4acb3f284@gmail.com>
 <YslxiluWV9YnPPAY@kroah.com> <81f96354-cbed-26e4-9f3f-5287095ccece@gmail.com>
 <YsqyxydY1kbufgng@kroah.com> <1c9e8498-0621-4466-bfbc-4f166c633727@gmail.com>
 <YsrKlIEV2ytKcWb8@kroah.com>
From:   Alexander Grund <theflamefire89@gmail.com>
In-Reply-To: <YsrKlIEV2ytKcWb8@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10.07.22 14:48, Greg KH wrote:
>>> What 4.4.y Android devices are still supported by their vendors?  And
>>> are they still getting kernel updates?
>>
>> Actually the issue is that those devices are not supported by their vendors anymore, so they may only get updates through LineageOS.
>> That is a third-party Android build where maintainers rely on proprietary binaries from the original phone which are tied to a specific kernel.
>> Hence when the device falls out of support having a 4.4 kernel in the last release there is no way for those maintainers to switch to a newer kernel.
>> That's the situation e.g. I am in right now: Providing (mostly) security updates for a good phone that fell out of vendor support
>> by using LineageOS for an updated Android system and e.g. the CIP maintained SLTS 4.4 kernel.
>> And I know of at least 2 other devices using the same kernel as they share the platform.
> 
> All of those devices that wish to keep working should just forward port
> their tree to newer kernel versions so that they can stay secure and
> working properly.  It is far easier to do that than to attempt to keep
> older kernel trees alive over time.  I've done both in the past and it's
> always simpler to move forward.
> 
> So why not just do that instead of attempting to keep these old kernels
> alive?  Do the effort once and then you can rely on the community's
> help.  Otherwise you are stuck on your own for forever.

Because forward porting is not possible.
As mentioned the original device vendor does no longer support those devices
so what the community has is a blob of binaries compiled against a specific
kernel version with no access to their sources.
As those binaries (mostly hardware "drivers") are required to use the device,
recompilation isn't possible and they are likely coupled to the kernel version
specific API/ABI "we" (me and maintainers of similar devices) have to stick to that kernel.
And given that a community supported/maintained 4.4 kernel exists
(as a SLTS kernel maintained under CIP) the situation seems to be common.

So I'm already relying on the community's help, CIP in this case.
And they rely on the 4.9 stable kernel and suggested that they only accept changes already present in 4.9.
So here I am with work I did for a specific 4.4 kernel giving that back to the wider community (4.9 and all downstream kernels).

Alex
