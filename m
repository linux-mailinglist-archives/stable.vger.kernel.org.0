Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED8537A5E6
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 13:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhEKLlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 07:41:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36776 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230501AbhEKLln (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 07:41:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620733237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ncq1izqydNckE7NiVEP46RrlkQeeb/1vqOvW8nfMruE=;
        b=caWueLgNf68bUHa9SPMotjSEQVlfOcmZgkAhwdXiBvW+FmByzYCblEC7TfEQIk3g0RCY5+
        FESYVXJ/oHsmTYMlB0XXTdG369buGwV54Brg/YCZVl1LVia/LQn5IF254Sjbv6ajRpOGB5
        FbDPJy9Uu/tqfQVGSgVnWb6oYwwOXEs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-z_Hx_T6WMouPCENNj63-Nw-1; Tue, 11 May 2021 07:40:34 -0400
X-MC-Unique: z_Hx_T6WMouPCENNj63-Nw-1
Received: by mail-ed1-f71.google.com with SMTP id g7-20020aa7c5870000b02903888f809d62so10816369edq.23
        for <stable@vger.kernel.org>; Tue, 11 May 2021 04:40:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ncq1izqydNckE7NiVEP46RrlkQeeb/1vqOvW8nfMruE=;
        b=FLRr2jBBoeVF9CugdwCv9OfsKbq4m2PfDSkoMxr1qUOfaJzIg47Y9zb8tdM/0cISMT
         tLKg/voc3hXOXVkWlF7WtyfaWafeaXmggBoe1X8zGqS3EOabwwmWzdV9mm93tmsvsESB
         0n4mA3bwPQs/UQhSr5TpwJooDP+vCUOSWSTnKkgz9M135gEd5Dhso/FeNlGMecoik5YX
         DC/GxP1dIM1v5UixRfJOdGbfSnGZATG8RjJJZUqAvemW6eJ3KZ1oFYfyFoqGqLvQwsjz
         EE8p3orHu1CVeEqrUywAZ70LcrXSyVgkx04hpUux0hNWEgcj1BW4g4b6THOt6q2XdIa0
         fbqQ==
X-Gm-Message-State: AOAM532+cR+FdWtW1N/2c4PI0RxxNhgnd1YRN7fyzWA8SB5hRbATPcXX
        LMmny8UntxoTJOXLJ4yMW5sm77dCIJua1XlpQM+DeNjPdY6pIwvrMDlGt+Xr3VCOzrnbu96WfD8
        OE4476lnO3bfKEEvhu+3jDgfPEiOPCmcHNBQiu3eOgukNjGdrSzq+YYfOlgjMqMWqjFks
X-Received: by 2002:a17:906:251a:: with SMTP id i26mr31417258ejb.367.1620733233328;
        Tue, 11 May 2021 04:40:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPx/RS9hDStJjMK8lRD4A5gKLEotw8heDtcm657cpEnwLGimqD245wNLkvMCbltzDgIPu64Q==
X-Received: by 2002:a17:906:251a:: with SMTP id i26mr31417233ejb.367.1620733232993;
        Tue, 11 May 2021 04:40:32 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id 20sm5803517ejm.72.2021.05.11.04.40.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 04:40:32 -0700 (PDT)
Subject: Re: [PATCH] platform/x86: ideapad-laptop: fix method name typo
To:     =?UTF-8?Q?Barnab=c3=a1s_P=c5=91cze?= <pobrn@protonmail.com>,
        mgross@linux.intel.com, ike.pan@canonical.com,
        platform-driver-x86@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20210507235333.286505-1-pobrn@protonmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <28b37604-856f-d65e-af49-a5b505678461@redhat.com>
Date:   Tue, 11 May 2021 13:40:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210507235333.286505-1-pobrn@protonmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 5/8/21 1:53 AM, Barnabás Pőcze wrote:
> "smbc" should be "sbmc". `eval_smbc()` incorrectly called
> the SMBC ACPI method instead of SBMC. This resulted in
> partial loss of functionality. Rectify that by calling
> the correct ACPI method (SBMC), and also rename
> methods and constants.
> 
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=212985
> Fixes: 0b765671cb80 ("platform/x86: ideapad-laptop: group and separate (un)related constants into enums")
> Fixes: ff36b0d953dc ("platform/x86: ideapad-laptop: rework and create new ACPI helpers")
> Cc: stable@vger.kernel.org # 5.12
> Signed-off-by: Barnabás Pőcze <pobrn@protonmail.com>

Thank you I've added this to my review-hans branch.
I'll also add this to my fixes branch and include it in
a future pdx86 fixes pull-req for Linus for 5.13.

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
>  drivers/platform/x86/ideapad-laptop.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
> index 6cb5ad4be231..8472aa4c5017 100644
> --- a/drivers/platform/x86/ideapad-laptop.c
> +++ b/drivers/platform/x86/ideapad-laptop.c
> @@ -57,8 +57,8 @@ enum {
>  };
> 
>  enum {
> -	SMBC_CONSERVATION_ON  = 3,
> -	SMBC_CONSERVATION_OFF = 5,
> +	SBMC_CONSERVATION_ON  = 3,
> +	SBMC_CONSERVATION_OFF = 5,
>  };
> 
>  enum {
> @@ -182,9 +182,9 @@ static int eval_gbmd(acpi_handle handle, unsigned long *res)
>  	return eval_int(handle, "GBMD", res);
>  }
> 
> -static int exec_smbc(acpi_handle handle, unsigned long arg)
> +static int exec_sbmc(acpi_handle handle, unsigned long arg)
>  {
> -	return exec_simple_method(handle, "SMBC", arg);
> +	return exec_simple_method(handle, "SBMC", arg);
>  }
> 
>  static int eval_hals(acpi_handle handle, unsigned long *res)
> @@ -477,7 +477,7 @@ static ssize_t conservation_mode_store(struct device *dev,
>  	if (err)
>  		return err;
> 
> -	err = exec_smbc(priv->adev->handle, state ? SMBC_CONSERVATION_ON : SMBC_CONSERVATION_OFF);
> +	err = exec_sbmc(priv->adev->handle, state ? SBMC_CONSERVATION_ON : SBMC_CONSERVATION_OFF);
>  	if (err)
>  		return err;
> 
> --
> 2.31.1
> 
> 

