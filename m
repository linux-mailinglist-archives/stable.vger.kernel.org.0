Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1766A63CC6A
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 01:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbiK3AON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 19:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbiK3ANo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 19:13:44 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374D873B94;
        Tue, 29 Nov 2022 16:13:39 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id w26-20020a056830061a00b0066c320f5b49so10233364oti.5;
        Tue, 29 Nov 2022 16:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KvHrrkFT/sm8lmNMi6in5CtlQ/OAaknEj2gVEu/Raao=;
        b=HV31q5r/lH0jnz39TFGK0pxbFdiAdDKUPE93n8U3+QbuJZtEPLhymq4ZuuxNtK4XBC
         GgAgCPEFQO0/Yt1lLj5jQW31nFYuML56u33qJkGZKTMi+ShT787jJNKt3Jnu3a6RywOI
         nXW2kZgy+/rrfrRLmQ+UR0MggZU79azFctA2rrqG39i3Lbr4CyvIItvI0M+knX+7w71M
         7Y1RryZWLR8yy+WdHLmWSbhSvQHeg0EN4giX+j/qbhGlRwYURZif6EAgBnhxbedeaJcF
         Y0LBMeH9VcWIMUQN7plUUpMpJexbwvANHRDbvwpOXS9LKM537PVkoO/Kq0YMAeWOloPE
         kNAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KvHrrkFT/sm8lmNMi6in5CtlQ/OAaknEj2gVEu/Raao=;
        b=36PTI74UojXup93nyEY3j86AyHQpPFXcfl3yIG+w9OUaywK6ev+CBPN1IAh4YNpw+5
         gLE+1fzX0VV4NtW2EGfas25LCcUamXcpspC24Tf3fxBZoDVOXQSmzng4gbdlnsh4gJZY
         pdI8/QKN6pPHDNfkrFHmnu3Vaogbuze2R6go93Q8fQ7NxZurMEG1CgQynRVW4mRdeo5b
         BnyQ85+VnMyn9brRCgAhcKxyqLzM7sIwdo1BfxIwgwhB1cGg1lKC7DbLjxDl0jln1vmH
         Q54bc8V4JaSN2uQ5NpVWTbxG83CH5Qrq2S+0vpIGASL5nKPwKjYQz3DpavHVjmNfDmzR
         /1+w==
X-Gm-Message-State: ANoB5pnobixcSalzGPO+YCbl9Y3RRJvaqjJLdYJSF+WWSp8qmQqMlrxU
        JUxaF2hDCHHClpdShdY4fGo=
X-Google-Smtp-Source: AA0mqf48lKa8NdKeQq8VKLANdbo3RPeNcH5CSCT76CNpXboH13ixzW9lXE70pkGBpQQ66eBIQBOvLw==
X-Received: by 2002:a05:6830:61a:b0:661:9dc0:75a0 with SMTP id w26-20020a056830061a00b006619dc075a0mr20701161oti.327.1669767218973;
        Tue, 29 Nov 2022 16:13:38 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o16-20020a056870969000b001428eb454e9sm151277oaq.13.2022.11.29.16.13.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Nov 2022 16:13:38 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <6bede7bd-81b9-846b-3f7f-9235a3abeaf5@roeck-us.net>
Date:   Tue, 29 Nov 2022 16:13:36 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     Rob Clark <robdclark@gmail.com>
Cc:     dri-devel@lists.freedesktop.org,
        Rob Clark <robdclark@chromium.org>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Eric Anholt <eric@anholt.net>,
        =?UTF-8?Q?Noralf_Tr=c3=b8nnes?= <noralf@tronnes.org>,
        Thomas Zimmermann <tzimmermann@suse.de>
References: <20221129200242.298120-3-robdclark@gmail.com>
 <20221129203205.GA2132357@roeck-us.net>
 <CAF6AEGuK4jv25cQ4p-rrytx9Qn4JZdRRfkVJn9T3nf7vJmG5VQ@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [2/2] drm/shmem-helper: Avoid vm_open error paths
In-Reply-To: <CAF6AEGuK4jv25cQ4p-rrytx9Qn4JZdRRfkVJn9T3nf7vJmG5VQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/29/22 12:47, Rob Clark wrote:
> On Tue, Nov 29, 2022 at 12:32 PM Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> On Tue, Nov 29, 2022 at 12:02:42PM -0800, Rob Clark wrote:
>>> From: Rob Clark <robdclark@chromium.org>
>>>
>>> vm_open() is not allowed to fail.  Fortunately we are guaranteed that
>>> the pages are already pinned, and only need to increment the refcnt.  So
>>> just increment it directly.
>>
>> I don't know anything about drm or gem, but I am wondering _how_
>> this would be guaranteed. Would it be through the pin function ?
>> Just wondering, because that function does not seem to be mandatory.
> 
> We've pinned the pages already in mmap.. vm->open() is perhaps not the
> best name for the callback function, but it is called for copying an
> existing vma into a new process (and for some other cases which do not
> apply here because VM_DONTEXPAND).
> 
> (Other drivers pin pages in the fault handler, where there is actually
> potential to return an error, but that change was a bit more like
> re-writing shmem helper ;-))
> 

Maybe add a bit of that (where the pinning happened) to the commit description
and to the patch itself ?

> BR,
> -R
> 
>>>
>>> Fixes: 2194a63a818d ("drm: Add library for shmem backed GEM objects")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Rob Clark <robdclark@chromium.org>
>>> ---
>>>   drivers/gpu/drm/drm_gem_shmem_helper.c | 14 +++++++++++---
>>>   1 file changed, 11 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
>>> index 110a9eac2af8..9885ba64127f 100644
>>> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
>>> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
>>> @@ -571,12 +571,20 @@ static void drm_gem_shmem_vm_open(struct vm_area_struct *vma)
>>>   {
>>>        struct drm_gem_object *obj = vma->vm_private_data;
>>>        struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
>>> -     int ret;
>>>
>>>        WARN_ON(shmem->base.import_attach);
>>>
>>> -     ret = drm_gem_shmem_get_pages(shmem);
>>> -     WARN_ON_ONCE(ret != 0);
>>> +     mutex_lock(&shmem->pages_lock);
>>> +
>>> +     /*
>>> +      * We should have already pinned the pages, vm_open() just grabs
>>
>> should or guaranteed ? This sounds a bit weaker than the commit
>> description.
>>
like ... the pages were already pinned in (mmap function).

>>> +      * an additional reference for the new mm the vma is getting
>>> +      * copied into.
>>> +      */
>>> +     WARN_ON_ONCE(!shmem->pages_use_count);

If the code can't be trusted and still needs the warning, how about
something like the following ?

	if (WARN_ON_ONCE(!shmem->pages_use_count)) {
		mutex_unlock(&shmem->pages_lock);
		return;
	}

Thanks,
Guenter

>>> +
>>> +     shmem->pages_use_count++;
>>> +     mutex_unlock(&shmem->pages_lock);
>>
>> The previous code, in that situation, would not increment pages_use_count,
>> and it would not set not set shmem->pages. Hopefully, it would not try to
>> do anything with the pages it was unable to get. The new code assumes that
>> shmem->pages is valid even if pages_use_count is 0, while at the same time
>> taking into account that this can possibly happen (or the WARN_ON_ONCE
>> would not be needed).
>>
>> Again, I don't know anything about gem and drm, but it seems to me that
>> there might now be a severe problem later on if the WARN_ON_ONCE()
>> ever triggers.
>>
>> Thanks,
>> Guenter
>>
>>>
>>>        drm_gem_vm_open(vma);
>>>   }

