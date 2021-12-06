Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F16246AA74
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349749AbhLFVde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:33:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50347 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349674AbhLFVdd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:33:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638826204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p53Oezk+1OSj1lIwb4tUAgq9sOSOpWc8DC+JVKBLVzU=;
        b=Cu6hGakJ8xdoCgTE4rHplfoZZGuNhohU18Y/3NPdXxmzEJHSkoP47or228bhBY1xwb+wrc
        3TXgiMUTj87fp1wfWn+t2WvJSOqBvCIbQtevdzFzqjteWb56GeRP3yKqBJabNjfxGkLtYP
        YrBXkFPpbethdZeM8Vx4jx2zU7smyaI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-zWO973SxOoSuJ81wWXm5fg-1; Mon, 06 Dec 2021 16:30:02 -0500
X-MC-Unique: zWO973SxOoSuJ81wWXm5fg-1
Received: by mail-ed1-f72.google.com with SMTP id c1-20020aa7c741000000b003e7bf1da4bcso9372182eds.21
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 13:30:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=p53Oezk+1OSj1lIwb4tUAgq9sOSOpWc8DC+JVKBLVzU=;
        b=SA6/25kRz04sVH8vVWRu29/eUBW1h4pwxuujKxjHLD9TM8Gc5YZxMzKlBXzAT1ifGm
         m3YuBRiWbtS6xtm0FD1I7qmZIgPd+Difbcp33okncsJ4jTQw1jQUl+/XoIyFngKmTiDf
         62i55sAImPxKt8B6eNniN0LSjzWoukDGCzlUph0pUrv5egdKdhjkrxXxr3/zYveq7oSF
         UWg/H2J6lxhfReC8h8N62qKkB7W0cHwDHUBCXtHEwpp+zUpD9KfjYVCfPa6XyVIHRnz1
         05EECQA01ZYbXfzRQrkqnndo6QXL4RUfyuMCqkSPBPo3MWDzh1eBCr2YxV5Qs/wWYo+l
         kQfg==
X-Gm-Message-State: AOAM530i9nxCiqIa3Aookep6QQv7QjRrLBXQOmo7LV0AjiXwq7m4T20O
        VKCD06FTGBCafArI0RWJ4Y8KmbWLrejhVOxeQP+snQ317oHXP0mS36kiEHOCHiIB/Gt1OG2O0G6
        YujGQAxuT7zKeyqPR
X-Received: by 2002:a17:906:fcbb:: with SMTP id qw27mr47382574ejb.320.1638826200907;
        Mon, 06 Dec 2021 13:30:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzuUvSXjWJL6H/9MMTz/nsEtjTv40TckCVGyIdz4xyLwFEflF9jGzxbEBhtYQRLgBPLfOA6lw==
X-Received: by 2002:a17:906:fcbb:: with SMTP id qw27mr47382557ejb.320.1638826200752;
        Mon, 06 Dec 2021 13:30:00 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:1054:9d19:e0f0:8214? (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id e8sm9681219edz.73.2021.12.06.13.30.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 13:30:00 -0800 (PST)
Message-ID: <63bfe091-ef07-8747-745d-11d5aacab847@redhat.com>
Date:   Mon, 6 Dec 2021 22:29:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] platform/x86/intel: hid: add quirk to support Surface Go
 3
Content-Language: en-US
To:     Alex Hung <alex.hung@canonical.com>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20211203212810.2666508-1-alex.hung@canonical.com>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20211203212810.2666508-1-alex.hung@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 12/3/21 22:28, Alex Hung wrote:
> Similar to other systems Surface Go 3 requires a DMI quirk to enable
> 5 button array for power and volume buttons.
> 
> Buglink: https://github.com/linux-surface/linux-surface/issues/595
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Alex Hung <alex.hung@canonical.com>

Thank you for your patch, I've applied this patch to my review-hans 
branch:
https://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git/log/?h=review-hans

Note it will show up in my review-hans branch once I've pushed my
local branch there, which might take a while.

I will also include this in my next fixes pull-req for 5.16.

Once I've run some tests on this branch the patches there will be
added to the platform-drivers-x86/for-next branch and eventually
will be included in the pdx86 pull-request to Linus for the next
merge-window.

Regards,

Hans



> ---
>  drivers/platform/x86/intel/hid.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
> index 08598942a6d7..13f8cf70b9ae 100644
> --- a/drivers/platform/x86/intel/hid.c
> +++ b/drivers/platform/x86/intel/hid.c
> @@ -99,6 +99,13 @@ static const struct dmi_system_id button_array_table[] = {
>  			DMI_MATCH(DMI_PRODUCT_FAMILY, "ThinkPad X1 Tablet Gen 2"),
>  		},
>  	},
> +	{
> +		.ident = "Microsoft Surface Go 3",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go 3"),
> +		},
> +	},
>  	{ }
>  };
>  
> 

