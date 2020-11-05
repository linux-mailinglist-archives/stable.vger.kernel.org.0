Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098E52A848E
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 18:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731591AbgKERO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 12:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731560AbgKERO6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 12:14:58 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE0BC0613CF;
        Thu,  5 Nov 2020 09:14:56 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id c80so2436308oib.2;
        Thu, 05 Nov 2020 09:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=EzuCScXK34H+yxMS/8Khr1NXq0vtwjjjyKo8k88A88I=;
        b=SVzamyMb3BPqjuS8baLIgcy380+Kw/1UHngn/C6O5AUtKkyEG5lHNNV7WhoNeOumGk
         xfubRfWRwA9JqdNuoSEAthQfctwbNTVxQfFBY8nnzMWBJTspAwMVO+6V5Ow9wt9T1RHY
         pEgauAbO1Ao00Vn22llgU0QH+1r0rcLfThyvaJf0pec+6Xz1FAqUc5WRvz/3dOTpHyhs
         IJ8cq2OINcjt0A0hWXUb41uSZpHmcDVhLNQtXx/RxmA0JSRRvv1e+aagOV+1UInEtPJU
         L0URWSncR5vtoDB4KZwlYtILENl4/SvVA2132+f8aBUf6giKkLSZPeIAjDUMxGqaXMKt
         kuaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=EzuCScXK34H+yxMS/8Khr1NXq0vtwjjjyKo8k88A88I=;
        b=HYoezcLKvd9pRhU/3MU4u5htLuZxGp/abW/EBmj+OeXsh3DjewiUuSHXBrorw+DIaD
         0w4lzAi/2rYcTzya/JJgkdJRnHVgDuIZR6lwZywMFhwN7abHxr7yGSMykN6q3QafF9zd
         7xE3FpmLAmxUkTemjHJi8GJ//pO8/9KiCbeomSJ0meMp7f73zsJDhAh2ZOUKjoUEt5lu
         b6F89pWf38iHtagRzRn9eTQvr7hDx805fCnKNKZPjolqMYzcuNl/GBfeqnmkQgEC3iL4
         L0RUCUR5UH2dJcMcq+YbKih1fjyvp6f4AvhdHqj8ongqMhyfVgC0iHjS7xglvYcOruwy
         70ng==
X-Gm-Message-State: AOAM531jF7nSf1OiJJD9pVnYk6mkbcRADWqNwGgesCecwk/D2wzK92B4
        100eErXMIXmZtDiYcbNDK0lmXBZnj6UJB0cN
X-Google-Smtp-Source: ABdhPJwDYYft5XnQSGlXxCKn494KFWg020g+/5Ipo5J+kie3czUmtsRjvn6EkemPdixMNA2is5YvKQ==
X-Received: by 2002:a05:6808:496:: with SMTP id z22mr296547oid.2.1604596495674;
        Thu, 05 Nov 2020 09:14:55 -0800 (PST)
Received: from ?IPv6:2600:1700:4a30:eaf0::21? ([2600:1700:4a30:eaf0::21])
        by smtp.gmail.com with ESMTPSA id h4sm464985oot.45.2020.11.05.09.14.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 09:14:54 -0800 (PST)
Subject: Re: [PATCH v2] Input: Add devices for
 HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE
To:     Chris Ye <lzye@google.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     linux-kernel@vger.kernel.org, trivial@kernel.org,
        linux-input@vger.kernel.org, stable@vger.kernel.org
References: <20201101193452.678628-1-lzye@google.com>
From:   Chris Ye <linzhao.ye@gmail.com>
Message-ID: <8578ec06-34f5-1cf4-5f62-9cb05a0b6c08@gmail.com>
Date:   Thu, 5 Nov 2020 09:14:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201101193452.678628-1-lzye@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+stable@vger.kernel.org

On 11/1/20 11:34 AM, Chris Ye wrote:
> Kernel 5.4 introduces HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE, devices
> need to be set explicitly with this flag.
>
> Signed-off-by: Chris Ye <lzye@google.com>
> ---
>   drivers/hid/hid-ids.h    | 4 ++++
>   drivers/hid/hid-quirks.c | 4 ++++
>   2 files changed, 8 insertions(+)
>
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 74be76e848bf..cf55dca494f3 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -449,6 +449,10 @@
>   #define USB_VENDOR_ID_FRUCTEL	0x25B6
>   #define USB_DEVICE_ID_GAMETEL_MT_MODE	0x0002
>   
> +#define USB_VENDOR_ID_GAMEVICE	0x27F8
> +#define USB_DEVICE_ID_GAMEVICE_GV186	0x0BBE
> +#define USB_DEVICE_ID_GAMEVICE_KISHI	0x0BBF
> +
>   #define USB_VENDOR_ID_GAMERON		0x0810
>   #define USB_DEVICE_ID_GAMERON_DUAL_PSX_ADAPTOR	0x0001
>   #define USB_DEVICE_ID_GAMERON_DUAL_PCS_ADAPTOR	0x0002
> diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
> index 0440e2f6e8a3..36d94e3485e3 100644
> --- a/drivers/hid/hid-quirks.c
> +++ b/drivers/hid/hid-quirks.c
> @@ -84,6 +84,10 @@ static const struct hid_device_id hid_quirks[] = {
>   	{ HID_USB_DEVICE(USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28), HID_QUIRK_NOGET },
>   	{ HID_USB_DEVICE(USB_VENDOR_ID_FUTABA, USB_DEVICE_ID_LED_DISPLAY), HID_QUIRK_NO_INIT_REPORTS },
>   	{ HID_USB_DEVICE(USB_VENDOR_ID_GREENASIA, USB_DEVICE_ID_GREENASIA_DUAL_USB_JOYPAD), HID_QUIRK_MULTI_INPUT },
> +	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_GAMEVICE, USB_DEVICE_ID_GAMEVICE_GV186),
> +		HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_GAMEVICE, USB_DEVICE_ID_GAMEVICE_KISHI),
> +		HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
>   	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_DRIVING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
>   	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FIGHTING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
>   	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FLYING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
