Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806CB2ABDE1
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730380AbgKINw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:52:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47016 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730221AbgKINw0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 08:52:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604929944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5QdziHwnq2/sfnnSdLOUcvlJNqFq0ug8vC4I8a9Gu94=;
        b=blFL8SjngwWBNIc3+F43fOeNZqoJ93+em4qb+P2JscldXKM0ONGrVFRS65bfLo1viLUMzk
        DAmSY6AeAzepa15cmcZDrYdIa+XTudByB8zAcYu0zUVsOTR3pVVDDXtMj7tDtGLr4bP2wj
        jxn6+Rkxn8xOIGAelSmN6LsPVVpKe4w=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-VIrdsse1MKyhON72b0w1bQ-1; Mon, 09 Nov 2020 08:52:19 -0500
X-MC-Unique: VIrdsse1MKyhON72b0w1bQ-1
Received: by mail-ej1-f70.google.com with SMTP id b17so3449383ejb.20
        for <stable@vger.kernel.org>; Mon, 09 Nov 2020 05:52:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5QdziHwnq2/sfnnSdLOUcvlJNqFq0ug8vC4I8a9Gu94=;
        b=CEdTZsVd7g4S/q1GuqZW6xCuDxyUB95901+KyqXW0YkmhM44ly/41IqQN4fdHVoYdF
         j/0kF9f0KIQ2jFrN32nf7uLAlNpqZpTKHMsNpZ2eFitzFt8omqOqloYZ429m0F6tYbI2
         pvmHJnmi5Mk5uUukA+GooO2IdLzs9clE2fX0WCPIhTFs2JpmTA6C355ze9njrI1due0S
         fze2UxGguaB3CGDhIyjTtBLPVEK/GL6E3CJV4ApMbVxHcg3IWwifhK6iBAYUlQMjuVq7
         yPhrMj7SnUcNLFXysxDx7+J7reACxiC1aUW9KoDyrU31Y+aNHMhLyO/r0tKFiFl64q2r
         BE8A==
X-Gm-Message-State: AOAM5302tnfkTf/x4Tlm3KQiR8Z75dmmGVqEBTNVnhssFamAOCsluVg9
        3TGzqFFnq7cj1+qMUtKGxn2u990FjQ9062IgIaHBZXEAQ1J/JyctC1Uc39CiIa/ImJTZpIOKu1X
        I2nv4OdXw2ek9iq81
X-Received: by 2002:a17:906:3547:: with SMTP id s7mr7195179eja.70.1604929938485;
        Mon, 09 Nov 2020 05:52:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJydsmeHAllJRZIOYN+4WiR1WT7Rcr/2EBEiuscrFSmgornlU1JN5JhQ+Z+/adDV3r0/Jcn47Q==
X-Received: by 2002:a17:906:3547:: with SMTP id s7mr7195162eja.70.1604929938254;
        Mon, 09 Nov 2020 05:52:18 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-6c10-fbf3-14c4-884c.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:6c10:fbf3:14c4:884c])
        by smtp.gmail.com with ESMTPSA id w3sm8853104edt.84.2020.11.09.05.52.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 05:52:17 -0800 (PST)
Subject: Re: [PATCH v3 4/4] pinctrl: amd: remove debounce filter setting in
 IRQ type setting
To:     Coiby Xu <coiby.xu@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-gpio@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        stable@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
References: <20201105231912.69527-1-coiby.xu@gmail.com>
 <20201105231912.69527-5-coiby.xu@gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <fa67aa70-2a14-35af-632b-b0e86dc4b436@redhat.com>
Date:   Mon, 9 Nov 2020 14:52:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201105231912.69527-5-coiby.xu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 11/6/20 12:19 AM, Coiby Xu wrote:
> Debounce filter setting should be independent from IRQ type setting
> because according to the ACPI specs, there are separate arguments for
> specifying debounce timeout and IRQ type in GpioIo() and GpioInt().
> 
> This will fix broken touchpads for laptops whose BIOS set the debounce
> timeout to a relatively large value. For example, the BIOS of Lenovo
> Legion-5 AMD gaming laptops including 15ARH05 (R7000) and R7000P set
> the debounce timeout to 124.8ms. This led to the kernel receiving only
> ~7 HID reports per second from the Synaptics touchpad
> (MSFT0001:00 06CB:7F28). Existing touchpads like [1][2] are not troubled
> by this bug because the debounce timeout has been set to 0 by the BIOS
> before enabling the debounce filter in setting IRQ type.
> 
> [1] https://github.com/Syniurge/i2c-amd-mp2/issues/11#issuecomment-721331582
> [2] https://forum.manjaro.org/t/random-short-touchpad-freezes/30832/28
> 
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1887190
> Link: https://lore.kernel.org/linux-gpio/CAHp75VcwiGREBUJ0A06EEw-SyabqYsp%2Bdqs2DpSrhaY-2GVdAA%40mail.gmail.com/
> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>

I'm not entirely sure about this patch. This is consistent with how we
already stopped touching the debounce timeout setting during init, so
that speaks in favor of this change.

Still I'm worried a bit that this might have undesirable side effects.

I guess this should be landed together with Andy's series to apply
the debounce setting from the ACPI GPIO resources.

Regards,

Hans




> ---
>  drivers/pinctrl/pinctrl-amd.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
> index e9b761c2b77a..2d4acf21117c 100644
> --- a/drivers/pinctrl/pinctrl-amd.c
> +++ b/drivers/pinctrl/pinctrl-amd.c
> @@ -468,7 +468,6 @@ static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
>  		pin_reg &= ~BIT(LEVEL_TRIG_OFF);
>  		pin_reg &= ~(ACTIVE_LEVEL_MASK << ACTIVE_LEVEL_OFF);
>  		pin_reg |= ACTIVE_HIGH << ACTIVE_LEVEL_OFF;
> -		pin_reg |= DB_TYPE_REMOVE_GLITCH << DB_CNTRL_OFF;
>  		irq_set_handler_locked(d, handle_edge_irq);
>  		break;
>  
> @@ -476,7 +475,6 @@ static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
>  		pin_reg &= ~BIT(LEVEL_TRIG_OFF);
>  		pin_reg &= ~(ACTIVE_LEVEL_MASK << ACTIVE_LEVEL_OFF);
>  		pin_reg |= ACTIVE_LOW << ACTIVE_LEVEL_OFF;
> -		pin_reg |= DB_TYPE_REMOVE_GLITCH << DB_CNTRL_OFF;
>  		irq_set_handler_locked(d, handle_edge_irq);
>  		break;
>  
> @@ -484,7 +482,6 @@ static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
>  		pin_reg &= ~BIT(LEVEL_TRIG_OFF);
>  		pin_reg &= ~(ACTIVE_LEVEL_MASK << ACTIVE_LEVEL_OFF);
>  		pin_reg |= BOTH_EADGE << ACTIVE_LEVEL_OFF;
> -		pin_reg |= DB_TYPE_REMOVE_GLITCH << DB_CNTRL_OFF;
>  		irq_set_handler_locked(d, handle_edge_irq);
>  		break;
>  
> @@ -492,8 +489,6 @@ static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
>  		pin_reg |= LEVEL_TRIGGER << LEVEL_TRIG_OFF;
>  		pin_reg &= ~(ACTIVE_LEVEL_MASK << ACTIVE_LEVEL_OFF);
>  		pin_reg |= ACTIVE_HIGH << ACTIVE_LEVEL_OFF;
> -		pin_reg &= ~(DB_CNTRl_MASK << DB_CNTRL_OFF);
> -		pin_reg |= DB_TYPE_PRESERVE_LOW_GLITCH << DB_CNTRL_OFF;
>  		irq_set_handler_locked(d, handle_level_irq);
>  		break;
>  
> @@ -501,8 +496,6 @@ static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
>  		pin_reg |= LEVEL_TRIGGER << LEVEL_TRIG_OFF;
>  		pin_reg &= ~(ACTIVE_LEVEL_MASK << ACTIVE_LEVEL_OFF);
>  		pin_reg |= ACTIVE_LOW << ACTIVE_LEVEL_OFF;
> -		pin_reg &= ~(DB_CNTRl_MASK << DB_CNTRL_OFF);
> -		pin_reg |= DB_TYPE_PRESERVE_HIGH_GLITCH << DB_CNTRL_OFF;
>  		irq_set_handler_locked(d, handle_level_irq);
>  		break;
>  
> 

