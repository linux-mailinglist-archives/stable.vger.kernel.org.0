Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02E731B115
	for <lists+stable@lfdr.de>; Sun, 14 Feb 2021 17:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhBNQCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 11:02:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53308 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229798AbhBNQCU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Feb 2021 11:02:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613318452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zJnCD65xbRWMUMjLE2t5rjUv7RyeHohz4SCngFSrsYU=;
        b=GdDR7NTthrWxCv1Q7KBs6OeyB7JKUXhX/4G55YrAVWyJ5DZvztYL0sru0Pzutv1D3jJ8/+
        vV4+Aq8Y9Op4dwtaTvOXvI4UbnZCrLGsejnB46CxAl5AyAAoGdAx4dqlbK6Q8pMCv8mm71
        nhNQOu91UkrkRDDwamVNr6AxhurpaLk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-B_zbzZsVPeSYL366AUWQWA-1; Sun, 14 Feb 2021 11:00:48 -0500
X-MC-Unique: B_zbzZsVPeSYL366AUWQWA-1
Received: by mail-ed1-f70.google.com with SMTP id i4so3485146edt.11
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 08:00:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zJnCD65xbRWMUMjLE2t5rjUv7RyeHohz4SCngFSrsYU=;
        b=B2bj39KqAPzi9yQU+GhYU6DhB2eaSN7PC6NjZ/lsq5VJr23GCR220jSzS2L1HkUcRO
         lSeBxiyMaRz9rLK7FvD2/R5cTYWL2yiKiYe3qKKqfFu7h4QvIMVaVGLveV98C97cJtyn
         x8BqLV5n+qCp5iNduxMpNAULi/2QvvmHnS191EsVhZRo75hF8b8ZF/yZwY4Er7CaNLvb
         yMehGDlx3DUBVUcC4vwXsOvSlLrTq6u2BwIWkK0JxmYaXgaLmyhT2wFC7BjPOEECDklU
         1aFRi+XZLIJ17EwgivMswd9u8siUa7I0CjNRyjp3hCBNzgpLA2YsjARa1uS2rDu3CnZp
         vOOw==
X-Gm-Message-State: AOAM530Jr5SPWU4mGqanr5oXDFXeIgru9K6NvwJMQMbGEwsYFVtLnXm0
        GmwOXgvgPAS8gBdgRGrWuVUmj6UXuycXrCxSVgWCkhePNn2gcy+ylp5GKHTQ69eFJmZjRmPWHLL
        GN3mzunvEy2VxlR3fPtw9XQz4OYgtqdWVf6zCGDBggKD42+TKLuirp3hsDai+LAXmLCTd
X-Received: by 2002:a17:906:33c5:: with SMTP id w5mr12025821eja.319.1613318446595;
        Sun, 14 Feb 2021 08:00:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzDn4q+tUxPm+eyE2w8xwHUQPqEK3mZPRTE2swFRpEF2RA0C9I0NzGmfqVGZ8PDW0uSv2oWjg==
X-Received: by 2002:a17:906:33c5:: with SMTP id w5mr12025801eja.319.1613318446337;
        Sun, 14 Feb 2021 08:00:46 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id q13sm9482813ejy.20.2021.02.14.08.00.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Feb 2021 08:00:45 -0800 (PST)
Subject: Re: [Intel-gfx] [5.10.y regression] i915 clear-residuals mitigation
 is causing gfx issues
From:   Hans de Goede <hdegoede@redhat.com>
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
 <e00f5813-37c6-52e7-4fd3-691be9d062d9@redhat.com>
Message-ID: <96614fc1-c92d-1532-fd92-beb19e490075@redhat.com>
Date:   Sun, 14 Feb 2021 17:00:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <e00f5813-37c6-52e7-4fd3-691be9d062d9@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2/11/21 1:26 PM, Hans de Goede wrote:
> Hi,
> 
> On 2/11/21 11:49 AM, Chris Wilson wrote:
>> Quoting Hans de Goede (2021-02-11 10:36:13)
>>> Hi,
>>>
>>> On 2/10/21 1:48 PM, Chris Wilson wrote:
>>>> Quoting Hans de Goede (2021-02-10 10:37:19)
>>>>> Hi,
>>>>>
>>>>> On 2/10/21 12:07 AM, Chris Wilson wrote:
>>>>>> Quoting Hans de Goede (2021-02-09 11:46:46)
>>>>>>> Hi,
>>>>>>>
>>>>>>> On 2/9/21 12:27 AM, Chris Wilson wrote:
>>>>>>>> Quoting Hans de Goede (2021-02-08 20:38:58)
>>>>>>>>> Hi All,
>>>>>>>>>
>>>>>>>>> We (Fedora) have been receiving reports from multiple users about gfx issues / glitches
>>>>>>>>> stating with 5.10.9. All reporters are users of Ivy Bridge / Haswell iGPUs and all
>>>>>>>>> reporters report that adding i915.mitigations=off to the cmdline fixes things, see:
>>>>>>>>
>>>>>>>> I tried to reproduce this on the w/e on hsw-gt1, to no avail; and piglit
>>>>>>>> did not report any differences with and without mitigations. I have yet
>>>>>>>> to test other platforms. So I don't yet have an alternative.
>>>>>>>
>>>>>>> Note the original / first reporter of:
>>>>>>>
>>>>>>> https://bugzilla.redhat.com/show_bug.cgi?id=1925346
>>>>>>>
>>>>>>> Is using hsw-gt2, so it seems that the problem is not just the enabling of
>>>>>>> the mitigations on ivy-bridge / bay-trail but that there actually is
>>>>>>> a regression on devices where the WA worked fine before...
>>>>>>
>>>>>> There have been 3 crashes uploaded related to v5.10.9, and in all 3
>>>>>> cases the ACTHD has been in the first page. This strongly suggests that
>>>>>> the w/a is scribbling over address 0. And there's then a very good
>>>>>> chance that
>>>>>>
>>>>>> commit 29d35b73ead4e41aa0d1a954c9bfbdce659ec5d6
>>>>>> Author: Chris Wilson <chris@chris-wilson.co.uk>
>>>>>> Date:   Mon Jan 25 12:50:33 2021 +0000
>>>>>>
>>>>>>     drm/i915/gt: Always try to reserve GGTT address 0x0
>>>>>>     
>>>>>>     commit 489140b5ba2e7cc4b853c29e0591895ddb462a82 upstream.
>>>>>>
>>>>>> in v5.10.14 is sufficient to hide the issue.
>>>>>
>>>>> That one actually is already in v5.10.13 and the various reportes of these
>>>>> issues have already tested 5.10.13. They did mention that it took longer
>>>>> to reproduce with 5.10.13 then with 5.10.10, but that could also be due to:
>>>>>
>>>>> "drm/i915/gt: Clear CACHE_MODE prior to clearing residuals"
>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.10.y&id=520d05a77b2866eb4cb9e548e1d8c8abcfe60ec5
>>>>
>>>> Started looking for scratch page overwrites, and found this little gem:
>>>> https://patchwork.freedesktop.org/patch/420436/?series=86947&rev=1
>>>>
>>>> Looks promising wrt the cause of overwriting random addresses -- and
>>>> I hope that is the explanation for the glitches/hangs. I have a hsw gt2
>>>> with gnome shell, piglit is happy, but I suspect it is all due to
>>>> placement and so will only occur at random.
>>>
>>> If you can give me a list of commits to cherry-pick then I can prepare
>>> a Fedora 5.10.y kernel which those added for the group of Fedora users
>>> who are hitting this to test.
>>
>> e627d5923cae ("drm/i915/gt: One more flush for Baytrail clear residuals")
>> d30bbd62b1bf ("drm/i915/gt: Flush before changing register state")
>> 1914911f4aa0 ("drm/i915/gt: Correct surface base address for renderclear")
> 
> Thanks, the test-kernel is building now. I will let you know when I have
> heard back from the Fedora users (this will likely take 1-2 days).

I've heard back from 2 of the reporters who were seeing issues with 5.10.9+

And I'm happy to report 5.10.15 + the 3 commits mentioned above cherry-picked
on top fixes the graphics glitches for them.

So if we can get these 3 commits into 5.10.y and 5.11.y then this should be
resolved.

Regards,

Hans

