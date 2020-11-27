Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD152C6171
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 10:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgK0JQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 04:16:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22985 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726802AbgK0JQX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 04:16:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606468581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L4oGuEIK0Gpj9aJE+3p3d094JUSVxcQxkqhlPVa3P0k=;
        b=O+QCEdFAqde/GA13yeoxep3NMKd2Dyluxv3485BzuAko1TOWZyo3SLyi6kVpAjiZuNXRUU
        VCbFd94tzi97r1H6sfeZfno/IkVxhPju1iKSOP4EAaYk8SZDtYo9p/mEUTz0BhGUPUWqUj
        9HuaUyJxsTTem0Hw/J/nceGIsqz94dc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-oSgPvkLYPyyR7PZAzFEHOg-1; Fri, 27 Nov 2020 04:16:19 -0500
X-MC-Unique: oSgPvkLYPyyR7PZAzFEHOg-1
Received: by mail-ed1-f71.google.com with SMTP id y11so2190981edv.6
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 01:16:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L4oGuEIK0Gpj9aJE+3p3d094JUSVxcQxkqhlPVa3P0k=;
        b=iqLbB7I3mTm9kDWykRYi3zoXLDh6v/qVqNCrXi23faNbF7tj+lKOa0siJc+kFKISbU
         vTqT0eC44s/L6Jvp9QDnTTr5yayXDaPMc2cJmtEnfwG3fbAXrlfl/RNz35Pk2IOZVsPT
         JM0Qd0cZ6oYuVkb7g/qZexXx0bghwV84lPEgXRXrZJoyBa97rNiWjh6QHzXWV3boYBh3
         oXK2HIfxdbagU/yjmofYi1bxPPpaVdgYyz9gKxhH+VU6jm9+qgIpcKiZ2JA0KAdrOsDJ
         2As881xd7OhLwdrPAFemU5AwOSlfMBDQ8lGjdnZTCNwdzWUffRCRU+wDBhJ6Edfmgt8D
         Mvdg==
X-Gm-Message-State: AOAM531rOhzIHbDuWGsGPiFeCGoon5wK5ksjPXzp2njffwqVgAnrNogz
        dx0p0+OtGKFuOF3zcJDK4ayxXxquMRPGA3Cf2Xgwc0zL5u1nIfLlwkt8eVTpGLyha9bsmEmx+ih
        +p6BqFlwDIyIbdMBJfxtQshHQvVTkLaPZHexH2mHjtXE3FSjNNRZGuZgvA/FJm3XfAS4n
X-Received: by 2002:aa7:df82:: with SMTP id b2mr6443394edy.251.1606468577766;
        Fri, 27 Nov 2020 01:16:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwXFUEaK6sN9zt4x56qBqoTQA1/SevIRNDsNiIwLSvvnhd/hRQ7wNNn8wanFGKwB9jfQRClKA==
X-Received: by 2002:aa7:df82:: with SMTP id b2mr6443378edy.251.1606468577545;
        Fri, 27 Nov 2020 01:16:17 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id ci20sm460901ejc.26.2020.11.27.01.16.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2020 01:16:16 -0800 (PST)
Subject: Re: [PATCH] HID: i2c-hid: add Vero K147 to descriptor override
To:     Julian Sax <jsbc@gmx.de>, linux-input@vger.kernel.org
Cc:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        stable@vger.kernel.org
References: <20201126175158.1183879-1-jsbc@gmx.de>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <fa55d191-aa27-cb12-a0d7-3b3342fb3366@redhat.com>
Date:   Fri, 27 Nov 2020 10:16:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201126175158.1183879-1-jsbc@gmx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 11/26/20 6:51 PM, Julian Sax wrote:
> This device uses the SIPODEV SP1064 touchpad, which does not
> supply descriptors, so it has to be added to the override list.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Julian Sax <jsbc@gmx.de>

Thanks, patch looks good to me:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans

> ---
>  drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
> index 35f3bfc3e6f5..8e0f67455c09 100644
> --- a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
> +++ b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
> @@ -405,6 +405,14 @@ static const struct dmi_system_id i2c_hid_dmi_desc_override_table[] = {
>  		},
>  		.driver_data = (void *)&sipodev_desc
>  	},
> +	{
> +		.ident = "Vero K147",
> +		.matches = {
> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "VERO"),
> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "K147"),
> +		},
> +		.driver_data = (void *)&sipodev_desc
> +	},
>  	{ }	/* Terminate list */
>  };
> 
> --
> 2.29.2
> 

