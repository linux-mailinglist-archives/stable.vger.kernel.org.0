Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E656318A91
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 13:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhBKM3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 07:29:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58324 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230385AbhBKM1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 07:27:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613046375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mt+vMWhYR3R266BZ9fplZ+SW7dWjlgg0RCEaln+DNdA=;
        b=iET/paalZZWa2jpXdaStK8k7yuhveXcxPXtOD+kvScW3O+BNTrRLnonAYQYht7FQoNulZC
        0zfscLmwM+2+SjszzgJWJp0wfjHQ9KIlABGWCRZmocyjUbm7pNK6wz//ci2jG/CPC5zPPW
        hwazvKBSee16fbN1sPjSYXweCo5frqE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-0eVXnXP5PBOx65Wj4HsTxg-1; Thu, 11 Feb 2021 07:26:11 -0500
X-MC-Unique: 0eVXnXP5PBOx65Wj4HsTxg-1
Received: by mail-ed1-f69.google.com with SMTP id j10so207905edv.5
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 04:26:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mt+vMWhYR3R266BZ9fplZ+SW7dWjlgg0RCEaln+DNdA=;
        b=ZKLfPGWTW/5jxn7jUYo1JppLbbQA5JVsRy6ilPTmcEhB1mDvaUuvN7YdGBd5xSLh1u
         wzsDU0D+kHbkvTQayrGIva7OEh5Q3RHB1V5y/JeTgXG3JO//hc86SHwP8G8+5R2VEOZr
         +69wqUnMBa/bvsRHUmAHWXePB+zUKq9szPZ5e8CjfAaWCRzVHLf/XpjpAKcb2F/3diIQ
         YFptRsHs0c4hx3EqrXWowSjkYNqZY75Estz5jeuxXi2TN2Q6cVFbF2qXgS4fB8Uzc661
         fOmE4EcpsIGzBKCrBvFcXFRZO1Qqk8fj5PSOXDwz2p+NOXV2zRT+/pqIhrAqzJiBtb5F
         A9Rw==
X-Gm-Message-State: AOAM530uwjyWpUUZD+tmsVoOT7LiSisWiQOLMP5P0gfJsmFGKmOCGhGw
        g2p1nDbfn4NUkr/hJhT/9J4ROqq9A0GBBFAOWxv+NkQm92Y+1I8stzu1B8shwG6w5MvE8pV6elP
        6VKVGMtVbgvifEJwSRzPy9MiBo250AjooHMYU7yTtJmQ2+6yKcMSANe3GDH/aFFgq2qmx
X-Received: by 2002:a17:906:9ad3:: with SMTP id ah19mr8210172ejc.37.1613046370024;
        Thu, 11 Feb 2021 04:26:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxbKdxgY9aBKky0s6h/qDD6L6sXqRg8l/yYG9oi6m9p9fIFP+/VOTlJFanqKrc/lE4xfvjpTw==
X-Received: by 2002:a17:906:9ad3:: with SMTP id ah19mr8210154ejc.37.1613046369789;
        Thu, 11 Feb 2021 04:26:09 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id ec18sm4252199ejb.24.2021.02.11.04.26.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 04:26:09 -0800 (PST)
Subject: Re: [Intel-gfx] [5.10.y regression] i915 clear-residuals mitigation
 is causing gfx issues
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        stable@vger.kernel.org
References: <fe6040b5-72a0-9882-439e-ea7fc0b3935d@redhat.com>
 <161282685855.9448.10484374241892252440@build.alporthouse.com>
 <f1070486-891a-8ec0-0390-b9aeb03178ce@redhat.com>
 <161291205642.6673.10994709665368036431@build.alporthouse.com>
 <02fd493c-957f-890d-d0ad-ebd4119f55f2@redhat.com>
 <161296131275.7731.862746142230006325@build.alporthouse.com>
 <8f550b67-2c7c-c726-09d1-dc8842152974@redhat.com>
 <161304059194.7731.17263409378570191651@build.alporthouse.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <e00f5813-37c6-52e7-4fd3-691be9d062d9@redhat.com>
Date:   Thu, 11 Feb 2021 13:26:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <161304059194.7731.17263409378570191651@build.alporthouse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2/11/21 11:49 AM, Chris Wilson wrote:
> Quoting Hans de Goede (2021-02-11 10:36:13)
>> Hi,
>>
>> On 2/10/21 1:48 PM, Chris Wilson wrote:
>>> Quoting Hans de Goede (2021-02-10 10:37:19)
>>>> Hi,
>>>>
>>>> On 2/10/21 12:07 AM, Chris Wilson wrote:
>>>>> Quoting Hans de Goede (2021-02-09 11:46:46)
>>>>>> Hi,
>>>>>>
>>>>>> On 2/9/21 12:27 AM, Chris Wilson wrote:
>>>>>>> Quoting Hans de Goede (2021-02-08 20:38:58)
>>>>>>>> Hi All,
>>>>>>>>
>>>>>>>> We (Fedora) have been receiving reports from multiple users about gfx issues / glitches
>>>>>>>> stating with 5.10.9. All reporters are users of Ivy Bridge / Haswell iGPUs and all
>>>>>>>> reporters report that adding i915.mitigations=off to the cmdline fixes things, see:
>>>>>>>
>>>>>>> I tried to reproduce this on the w/e on hsw-gt1, to no avail; and piglit
>>>>>>> did not report any differences with and without mitigations. I have yet
>>>>>>> to test other platforms. So I don't yet have an alternative.
>>>>>>
>>>>>> Note the original / first reporter of:
>>>>>>
>>>>>> https://bugzilla.redhat.com/show_bug.cgi?id=1925346
>>>>>>
>>>>>> Is using hsw-gt2, so it seems that the problem is not just the enabling of
>>>>>> the mitigations on ivy-bridge / bay-trail but that there actually is
>>>>>> a regression on devices where the WA worked fine before...
>>>>>
>>>>> There have been 3 crashes uploaded related to v5.10.9, and in all 3
>>>>> cases the ACTHD has been in the first page. This strongly suggests that
>>>>> the w/a is scribbling over address 0. And there's then a very good
>>>>> chance that
>>>>>
>>>>> commit 29d35b73ead4e41aa0d1a954c9bfbdce659ec5d6
>>>>> Author: Chris Wilson <chris@chris-wilson.co.uk>
>>>>> Date:   Mon Jan 25 12:50:33 2021 +0000
>>>>>
>>>>>     drm/i915/gt: Always try to reserve GGTT address 0x0
>>>>>     
>>>>>     commit 489140b5ba2e7cc4b853c29e0591895ddb462a82 upstream.
>>>>>
>>>>> in v5.10.14 is sufficient to hide the issue.
>>>>
>>>> That one actually is already in v5.10.13 and the various reportes of these
>>>> issues have already tested 5.10.13. They did mention that it took longer
>>>> to reproduce with 5.10.13 then with 5.10.10, but that could also be due to:
>>>>
>>>> "drm/i915/gt: Clear CACHE_MODE prior to clearing residuals"
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.10.y&id=520d05a77b2866eb4cb9e548e1d8c8abcfe60ec5
>>>
>>> Started looking for scratch page overwrites, and found this little gem:
>>> https://patchwork.freedesktop.org/patch/420436/?series=86947&rev=1
>>>
>>> Looks promising wrt the cause of overwriting random addresses -- and
>>> I hope that is the explanation for the glitches/hangs. I have a hsw gt2
>>> with gnome shell, piglit is happy, but I suspect it is all due to
>>> placement and so will only occur at random.
>>
>> If you can give me a list of commits to cherry-pick then I can prepare
>> a Fedora 5.10.y kernel which those added for the group of Fedora users
>> who are hitting this to test.
> 
> e627d5923cae ("drm/i915/gt: One more flush for Baytrail clear residuals")
> d30bbd62b1bf ("drm/i915/gt: Flush before changing register state")
> 1914911f4aa0 ("drm/i915/gt: Correct surface base address for renderclear")

Thanks, the test-kernel is building now. I will let you know when I have
heard back from the Fedora users (this will likely take 1-2 days).

Regards,

Hans

