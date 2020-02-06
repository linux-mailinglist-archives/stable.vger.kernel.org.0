Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4342715437D
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 12:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgBFLuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 06:50:12 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43889 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727575AbgBFLuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 06:50:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580989810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r0m6hUgjurvubbH9fgcIpOSpOggrFujmjO/VSj3cDIk=;
        b=FgFHw5uYkQ1i8V2lIHY9tLfYRdo8NBQ7MOkzzUZfP6a9iYeP0nJn9U0xruPDlJtMSCqufY
        /U/Ul6zCbnowsm9taqA6i/+NNJXRz88HoPVeXa+haKel5UnqzMYPH0BnTF8WVa/z3jC74B
        AKG+htH6OMiF2OYHV1H3J4W6mccZX00=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-HiDkZNILOzCDkUmwOVlccw-1; Thu, 06 Feb 2020 06:50:09 -0500
X-MC-Unique: HiDkZNILOzCDkUmwOVlccw-1
Received: by mail-wr1-f69.google.com with SMTP id v17so3230612wrm.17
        for <stable@vger.kernel.org>; Thu, 06 Feb 2020 03:50:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r0m6hUgjurvubbH9fgcIpOSpOggrFujmjO/VSj3cDIk=;
        b=OTBqsIU7B2xVBIx9kVQF1VHarIRyx+ihYy8WMKcMrM+e5NI3yxntERTb+hwwurxPya
         L4NUrVoE9ZjVs+R4eHrgXA8XVCG+rmLtv0v4z2NWDVTsMTxKjzCvyb6EaYSqcsilVsq9
         8ShxYPvpxvS3F7htKmKDoqp/SoyZWQ/tthcHKKSnD38LAd6wbHYR+v4u/2CE+0yEwqxu
         HsP11ORYaRkFmkN4ZTVHPUJq7AX5zp0l2ozD6wn0ZMsJvIaxZYQa0sOtbBQYUMe690LJ
         A+nHvUjTFjRhTggFqpEkOi5LAD33sNw/g2rZHA96hp/Pa5yDZoWZrn5rXYbCFGAjKm+e
         MstQ==
X-Gm-Message-State: APjAAAWKA4HNjrbq4o77eTRYkog73HqX2OWtiXiCCTpsOpVQ8TQhWXU+
        lXEsnYqzxMtSK3usU2qeH/mlCRAVKot+NSoF6wU2hhE3rSDbK3la1kJpciiV7OfelkQ4DGFDMFa
        rUl547avlCLYLAaqG
X-Received: by 2002:a7b:c407:: with SMTP id k7mr4321215wmi.46.1580989807703;
        Thu, 06 Feb 2020 03:50:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqw5VYfjKfZRYNlahF2fKL5l7AV53TsvDCkTeqFBD04fnQO77xZw5rTWNGzIdfV/0AK88uogXA==
X-Received: by 2002:a7b:c407:: with SMTP id k7mr4321199wmi.46.1580989807494;
        Thu, 06 Feb 2020 03:50:07 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-fc7e-fd47-85c1-1ab3.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:fc7e:fd47:85c1:1ab3])
        by smtp.gmail.com with ESMTPSA id s139sm3479456wme.35.2020.02.06.03.50.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 03:50:06 -0800 (PST)
Subject: Re: [PATCH] ata: ahci_platform: add 32-bit quirk for dwc-ahci
To:     Roger Quadros <rogerq@ti.com>, axboe@kernel.dk
Cc:     vigneshr@ti.com, nsekhar@ti.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200206111728.6703-1-rogerq@ti.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <d3a80407-a40a-c9e4-830f-138cfe9b163c@redhat.com>
Date:   Thu, 6 Feb 2020 12:50:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200206111728.6703-1-rogerq@ti.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2/6/20 12:17 PM, Roger Quadros wrote:
> On TI Platforms using LPAE, SATA breaks with 64-bit DMA.
> Restrict it to 32-bit.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>   drivers/ata/ahci_platform.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
> index 3aab2e3d57f3..b925dc54cfa5 100644
> --- a/drivers/ata/ahci_platform.c
> +++ b/drivers/ata/ahci_platform.c
> @@ -62,6 +62,9 @@ static int ahci_probe(struct platform_device *pdev)
>   	if (of_device_is_compatible(dev->of_node, "hisilicon,hisi-ahci"))
>   		hpriv->flags |= AHCI_HFLAG_NO_FBS | AHCI_HFLAG_NO_NCQ;
>   
> +	if (of_device_is_compatible(dev->of_node, "snps,dwc-ahci"))
> +		hpriv->flags |= AHCI_HFLAG_32BIT_ONLY;
> +

The "snps,dwc-ahci" is a generic (non TI specific) compatible which
is e.g. also used on some exynos devices. So using that to key the
setting of the 32 bit flag seems wrong to me.

IMHO it would be better to introduce a TI specific compatible
and use that to match on instead (and also adjust the dts files
accordingly).

Regards,

Hans



>   	port = acpi_device_get_match_data(dev);
>   	if (!port)
>   		port = &ahci_port_info;
> 

