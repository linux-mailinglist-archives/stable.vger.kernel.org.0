Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26879498187
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237378AbiAXN4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:56:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30482 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237371AbiAXN4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:56:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643032609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YSqLQTi0kpug+gxLseY0EO7WdkGc2b3LlDQDn6WfK9k=;
        b=R6XP12qv4pk3MQnZXLoGx72kqdigQ3CAY+b+dTZb4qY6V47ro7yU/R9edHWVz6z+dK3c/M
        hmIRkBhrZXHpjD1LtJSSbh23097DwNE79ivOtYjB6Zcs++fNZ2f25Qn7D2/V/vXQVkEJAr
        Z9d55qJl5NVszGCNdK3Hp9zzWy4/Vfw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-580-2EsrRd9oMySrh1yFX6DUDQ-1; Mon, 24 Jan 2022 08:56:48 -0500
X-MC-Unique: 2EsrRd9oMySrh1yFX6DUDQ-1
Received: by mail-wr1-f70.google.com with SMTP id a6-20020adfbc46000000b001d7370ace6eso1912449wrh.9
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 05:56:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=YSqLQTi0kpug+gxLseY0EO7WdkGc2b3LlDQDn6WfK9k=;
        b=tUYLaHRlZxvKr13qKDb0HIQ/sGcrVMegImqohPwjcFZw+zE3lciahy5WGul6QmCBdO
         MXuR7l5DwJwhZgMwE5NDYFPfnn9I81CiDCROSDKWC64A3+ULJg8iJJJ49AVhiWJmET6k
         sc8lcHSp1UD9NWN8sTQdgflC06DpP3Zbi7GK1AfBoB7U7JHsMrBhRPQxz3fMbbFyFKPQ
         l2j967Kc3zWLOljnsuNs6U09CX2KOs+CKqhzN4BVKbZKaA+qA5G1IN6PPb2otCiipwDI
         YCCk8VaJ9mAI1vIcmwwBNVzfzajAj0BFTeS35T6KQYK3gunktIKdccK7+TrMNamPi0Eh
         2tLA==
X-Gm-Message-State: AOAM530lbnpI7dqTKH4EksG66H7ntTML7dCKRJPfBWhNN9BWG4ir2qeU
        tj03LJNxjY7PvFYogQrbhcidCwF/RuKwAwRlMQiccOxHHtvMMMjLTuwkKKeUf+rT068S4r8H/uj
        85pEkAL8N1lolTSF6
X-Received: by 2002:a5d:61c6:: with SMTP id q6mr7199316wrv.667.1643032606856;
        Mon, 24 Jan 2022 05:56:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJypkYfrulJD9zvGIs/3jSlnpWz+2/2XmXFRuwYQuHQ2tcE8GsQEKRgQ0vh9JaRMpuCjkZXoOA==
X-Received: by 2002:a5d:61c6:: with SMTP id q6mr7199304wrv.667.1643032606631;
        Mon, 24 Jan 2022 05:56:46 -0800 (PST)
Received: from [192.168.1.102] ([92.176.231.205])
        by smtp.gmail.com with ESMTPSA id l13sm20189582wmq.22.2022.01.24.05.56.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 05:56:46 -0800 (PST)
Message-ID: <b88309c2-7c22-3bcb-3f37-ade3e7d89617@redhat.com>
Date:   Mon, 24 Jan 2022 14:56:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 1/5] fbdev: Hot-unplug firmware fb devices on forced
 removal
Content-Language: en-US
From:   Javier Martinez Canillas <javierm@redhat.com>
To:     Thomas Zimmermann <tzimmermann@suse.de>, zackr@vmware.com,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        airlied@linux.ie, daniel@ffwll.ch, deller@gmx.de,
        hdegoede@redhat.com
Cc:     dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        stable@vger.kernel.org
References: <20220124123659.4692-1-tzimmermann@suse.de>
 <20220124123659.4692-2-tzimmermann@suse.de>
 <508e6735-d5f0-610c-d4ca-b1abc093f63c@redhat.com>
In-Reply-To: <508e6735-d5f0-610c-d4ca-b1abc093f63c@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/24/22 14:52, Javier Martinez Canillas wrote:

[snip]

>> @@ -1898,9 +1917,13 @@ EXPORT_SYMBOL(register_framebuffer);
>>  void
>>  unregister_framebuffer(struct fb_info *fb_info)
>>  {
>> -	mutex_lock(&registration_lock);
>> +	bool forced_out = fb_info->forced_out;
>> +
>> +	if (!forced_out)
>> +		mutex_lock(&registration_lock);
>>  	do_unregister_framebuffer(fb_info);
>> -	mutex_unlock(&registration_lock);
>> +	if (!forced_out)
>> +		mutex_unlock(&registration_lock);
>>  }
> 
> I'm not sure to follow the logic here. The forced_out bool is set when the
> platform device is unregistered in do_remove_conflicting_framebuffers(),
> but shouldn't the struct platform_driver .remove callback be executed even
> in this case ?
> 
> That is, the platform_device_unregister() will trigger the call to the
> .remove callback that in turn will call unregister_framebuffer().
> 
> Shouldn't we always hold the mutex when calling do_unregister_framebuffer() ?
> 

Scratch that, I got it now. That's exactly the reason why you skip the
mutext_lock(). After adding the check for dev, feel free to add:

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>

Best regards,
-- 
Javier Martinez Canillas
Linux Engineering
Red Hat

