Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F93347E7C0
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 19:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349890AbhLWSsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 13:48:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44063 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349863AbhLWSsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Dec 2021 13:48:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640285280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yA57few3f6tSjdsufvGnJgK9V8OGmZJcp6eJoOPkJr0=;
        b=XiuI5dh1jWoOpKuGScV2hNJorcnzDaimEwswzXegjV0GEeSftL/oE82nnXfTfPjmyHDCan
        kv7HYXH6JIiu771cjYwXJKYFfQ4R+q73TGjHbiafoggci4h6ci0RfYuny28XWs/gdqfXsu
        K2dg9jSKkKePqfz3VsLUu18Mjj7N8pw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-49-qhjQUSKANvKHVS5B4qVM-w-1; Thu, 23 Dec 2021 13:47:59 -0500
X-MC-Unique: qhjQUSKANvKHVS5B4qVM-w-1
Received: by mail-ed1-f72.google.com with SMTP id f20-20020a056402355400b003f81df0975bso5084356edd.9
        for <stable@vger.kernel.org>; Thu, 23 Dec 2021 10:47:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yA57few3f6tSjdsufvGnJgK9V8OGmZJcp6eJoOPkJr0=;
        b=SltTMgI5+mKAxw70fizK5esI5CMcisQQsPneOJJin6CKUsRmS2FqzJ/TsB+/TyBJsc
         1wP1R8xafkQK1NWHYcKNpODc31fyCWXwt9AALPxGd9ZSki8k0GaJFK0P4N4DMG0V716S
         8q0ytrDrJ7PE43AJrMcsUff0r0YsuJy2rCuf17N6wKGubrijqOV/NX5vhgUfvOlLfcNv
         hmUpxB9S980luWpgs0sEKbMYPk/NF0aY9JU1XmkxIxMdfg0+KFkxPwS1aLnqPcYDE6UB
         2J1DHLCuFDCiSuOPWBMk8NA6oU1kM0NdCFPdw3Q8g0JX8TT+2cUNAXMZr41PfJZq8KSn
         Ch5Q==
X-Gm-Message-State: AOAM531yTWsbZfrOhINSccQx0LCPJB57atSGPqWShbIDw+hm4ElOl5Q4
        020nR65N7MBTIZe/NhNE9QdJ+v9bs3UlPG6K90e84CnkfkQbDxa4RWL3gY0JK3eeZjTmXOgK6la
        M2Tt1BjxetaYc3CGd
X-Received: by 2002:a17:907:9718:: with SMTP id jg24mr2884535ejc.621.1640285278316;
        Thu, 23 Dec 2021 10:47:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwLj3Q95ZXvQgGzi+c46JIGWosBY7rxtPaJg64hB/Fu20F/lDeeGqVgOJtfAqpWbB04AGr8Jw==
X-Received: by 2002:a17:907:9718:: with SMTP id jg24mr2884515ejc.621.1640285278050;
        Thu, 23 Dec 2021 10:47:58 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1? (2001-1c00-0c1e-bf00-1db8-22d3-1bc9-8ca1.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1])
        by smtp.gmail.com with ESMTPSA id b4sm1976103ejl.206.2021.12.23.10.47.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Dec 2021 10:47:57 -0800 (PST)
Message-ID: <117383d0-6bc7-4093-53b8-e90e86c29db7@redhat.com>
Date:   Thu, 23 Dec 2021 19:47:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] platform/x86: intel_pmc_core: fix memleak on registration
 failure
Content-Language: en-US
To:     Johan Hovold <johan@kernel.org>,
        Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
        David E Box <david.e.box@intel.com>
Cc:     Mark Gross <markgross@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20211222105023.6205-1-johan@kernel.org>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20211222105023.6205-1-johan@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 12/22/21 11:50, Johan Hovold wrote:
> In case device registration fails during module initialisation, the
> platform device structure needs to be freed using platform_device_put()
> to properly free all resources (e.g. the device name).
> 
> Fixes: 938835aa903a ("platform/x86: intel_pmc_core: do not create a static struct device")
> Cc: stable@vger.kernel.org      # 5.9
> Signed-off-by: Johan Hovold <johan@kernel.org>

Thank you for your patch, I've applied this patch to my review-hans 
branch:
https://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git/log/?h=review-hans

Note it will show up in my review-hans branch once I've pushed my
local branch there, which might take a while.

Once I've run some tests on this branch the patches there will be
added to the platform-drivers-x86/for-next branch and eventually
will be included in the pdx86 pull-request to Linus for the next
merge-window.

Regards,

Hans



> ---
>  drivers/platform/x86/intel/pmc/pltdrv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/platform/x86/intel/pmc/pltdrv.c b/drivers/platform/x86/intel/pmc/pltdrv.c
> index 73797680b895..15ca8afdd973 100644
> --- a/drivers/platform/x86/intel/pmc/pltdrv.c
> +++ b/drivers/platform/x86/intel/pmc/pltdrv.c
> @@ -65,7 +65,7 @@ static int __init pmc_core_platform_init(void)
>  
>  	retval = platform_device_register(pmc_core_device);
>  	if (retval)
> -		kfree(pmc_core_device);
> +		platform_device_put(pmc_core_device);
>  
>  	return retval;
>  }
> 

