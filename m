Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F78747067F
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 17:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbhLJRBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 12:01:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48376 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229821AbhLJRBA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 12:01:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639155445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rzeV8e563ubww0RTTrR8TIH1th19UWmc6oPCR1FYHig=;
        b=hFBvp31FtXXoLHbqjk+emEPC5SrYXBCVZdW4XPRPlsHC0KEBRht6LZ2JaHhCmsh/Y3D0qC
        eGjpv9gSmO8oy1kXIJe27kYW6Ap3QsWSGbXXaxVt0el8fNpdtMS8Ym11+Vb4QfY6sBux8H
        DTwWeq9NLfgyv9560wFsKHuvQxxFwzs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-300-PcWQMZ1uO3-yxsQdw8_kCg-1; Fri, 10 Dec 2021 11:57:22 -0500
X-MC-Unique: PcWQMZ1uO3-yxsQdw8_kCg-1
Received: by mail-wr1-f71.google.com with SMTP id b1-20020a5d6341000000b001901ddd352eso2535299wrw.7
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 08:57:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rzeV8e563ubww0RTTrR8TIH1th19UWmc6oPCR1FYHig=;
        b=Qw9hZsCS9WUXZyqy9mb/iMqtmmFh3jsldfgKYLIA0bOpie3GIYu91n4G3VH9Se0Dui
         evF/bl40+/SYVPP2lDKaIe/69Cggg8JaSeiHUjCH+g+eBj3eDmgxcbfesj2ebjqjMpwC
         fAnch0NIK1HxdRtJzWKa1ZtZe6x2A3WMaz50z5RP0xQnpEu3wb7O9cX4PdeAWn5FOvf7
         GRIGKYSOSSHMeRyetuAh/DVSVyo+mS/PYAldO0wxsqgtCnwE/ad8lGfnd5QvHV6teFtY
         +k4MTpuwhDVI2hYsIwy+1HFQHSPWb5Um6zqmCShJOzABGFLZZ66aZa7yVw5sdHkS610U
         PUiA==
X-Gm-Message-State: AOAM530r00pO/NqlKGUTt+xqW7mOg/ND9BeaV+duhZ5AzEasMmzd1eU0
        lGibvaKz/4MDGqRUHbKnGzQFKKxtXxQVq39S6TvskVLPQDnqi8gpWBRPkImA3kOfGKQZRZu+DP3
        hc6NeJyv6I9AYU6dF
X-Received: by 2002:adf:e0d0:: with SMTP id m16mr15214313wri.74.1639155440858;
        Fri, 10 Dec 2021 08:57:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz2gK/oWWEW4wGM6US1FC/izLejsINm4hcPUJh6i717fxzUPBKpCLbtPe0RbzOpYqE/WQdjqw==
X-Received: by 2002:adf:e0d0:: with SMTP id m16mr15214300wri.74.1639155440700;
        Fri, 10 Dec 2021 08:57:20 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:1054:9d19:e0f0:8214? (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id l5sm12104083wms.16.2021.12.10.08.57.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 08:57:20 -0800 (PST)
Message-ID: <5070829f-fe15-b7c7-f461-83122c0fa9c6@redhat.com>
Date:   Fri, 10 Dec 2021 17:57:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] platform/x86: amd-pmc: only use callbacks for suspend
Content-Language: en-US
To:     Mario Limonciello <mario.limonciello@amd.com>,
        Mark Gross <mgross@linux.intel.com>,
        "open list:X86 PLATFORM DRIVERS" 
        <platform-driver-x86@vger.kernel.org>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc:     stable@vger.kernel.org
References: <20211210143529.10594-1-mario.limonciello@amd.com>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20211210143529.10594-1-mario.limonciello@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mario,

On 12/10/21 15:35, Mario Limonciello wrote:
> This driver is intended to be used exclusively for suspend to idle
> so callbacks to send OS_HINT during hibernate and S5 will set OS_HINT
> at the wrong time leading to an undefined behavior.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>

I notice that there are no [Bug]Link tags here ?  It would be helpful
to have some links to tickets / forum-posts from people who are actually
hitting issues because of this. Both so that people with similar issues
can then compare the symptoms as described in the links, as well as for
me to get an idea of how urgent of a fix this is.

Regards,

Hans




> ---
>  drivers/platform/x86/amd-pmc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/platform/x86/amd-pmc.c b/drivers/platform/x86/amd-pmc.c
> index 841c44cd64c2..230593ae5d6d 100644
> --- a/drivers/platform/x86/amd-pmc.c
> +++ b/drivers/platform/x86/amd-pmc.c
> @@ -508,7 +508,8 @@ static int __maybe_unused amd_pmc_resume(struct device *dev)
>  }
>  
>  static const struct dev_pm_ops amd_pmc_pm_ops = {
> -	SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(amd_pmc_suspend, amd_pmc_resume)
> +	.suspend_noirq = amd_pmc_suspend,
> +	.resume_noirq = amd_pmc_resume,
>  };
>  
>  static const struct pci_device_id pmc_pci_ids[] = {
> 

