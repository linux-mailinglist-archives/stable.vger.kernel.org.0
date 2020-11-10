Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5CA2AD146
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 09:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgKJI1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 03:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgKJI1E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 03:27:04 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2BC3C0613CF;
        Tue, 10 Nov 2020 00:27:03 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id z1so6102960plo.12;
        Tue, 10 Nov 2020 00:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VHvZq+1i+j8F3ka+fOLiHMulFjfSWEGkZ+qzd1JrFt4=;
        b=QEhHIvJuM98Lv5k05G1YlZZTCNfdDq6g4Dosu/Dwh1F8nPsMDbKWk2WFiyG+bxdZmV
         GKOM1n5vVVxi8MxVlpEmkzI/5EKbcei2LDGWT2tjewhELK4OdUlF1q0pGJ7NN/3u3JMc
         pT5ASn+uVY1xs4haEsAjlI/oAB8aA6YZ96fXjng1S8KumETOLx4btq6jD6WCKGP016Ty
         H5CQ0icsnuXEau8svD+BHG6yKbYQs0llg6uOX9JvnFbp7NlmQkHLNTi3mt91+PVGYJ9I
         sdJEsRgFQutMjJjX3zn7TviGREdkmZMsuE47wZm/Od5NpZPMiolpXTi8UJxWImJdZo0e
         U+Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VHvZq+1i+j8F3ka+fOLiHMulFjfSWEGkZ+qzd1JrFt4=;
        b=IqAC766uHZCSRnzNgNhPg+9mf6R6v1+j1thg5oepd6eN8e0e5qWbkMFqL9DY2k59fV
         kViLCWogI36nJeNHOv39tWSEluYhTBDC/qoI7RbqgRrA5aQ8NAicOvS/85/QFiBowD8j
         5oCqdp90pwxKNkv9cL8khEyi/RMWs/ubDSYSzPhoVPsI0HHWppchnfuTZOYjzdixT9od
         vRlT/1LlW3++WGD6Alm/Qip4xXJDpgFIDjFBGdyO3KlVKPleux6UuuieDN7AiWkCb70f
         p8fk7pAHp+1q+PgOzfIREzJR2viAQ1wH7XMudwO6gaebIqQeyW51fDfBEuJb5szNvaYS
         Yz3w==
X-Gm-Message-State: AOAM531C8D5XwQkNRoWHG6C6BHbMf6E+BcpgUHKXmKcNgmsgcLVHEwyU
        uBsz+iVYvvkguNtj3y1yVtE=
X-Google-Smtp-Source: ABdhPJxG7MPB+D2es1tMszuqTdm3CgsFOcniZgYCfgHMMH7sHkmsyWTxW7atzbQEGm0qllWpOdP02A==
X-Received: by 2002:a17:902:fe18:b029:d6:991c:6379 with SMTP id g24-20020a170902fe18b02900d6991c6379mr12947929plj.20.1604996823497;
        Tue, 10 Nov 2020 00:27:03 -0800 (PST)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id g85sm13534958pfb.4.2020.11.10.00.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 00:27:02 -0800 (PST)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Tue, 10 Nov 2020 16:26:33 +0800
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-gpio@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        stable@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/4] pinctrl: amd: remove debounce filter setting in
 IRQ type setting
Message-ID: <20201110082633.2rtmegilva2hgst4@Rk>
References: <20201105231912.69527-1-coiby.xu@gmail.com>
 <20201105231912.69527-5-coiby.xu@gmail.com>
 <fa67aa70-2a14-35af-632b-b0e86dc4b436@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <fa67aa70-2a14-35af-632b-b0e86dc4b436@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 09, 2020 at 02:52:17PM +0100, Hans de Goede wrote:
>Hi,
>
>On 11/6/20 12:19 AM, Coiby Xu wrote:
>> Debounce filter setting should be independent from IRQ type setting
>> because according to the ACPI specs, there are separate arguments for
>> specifying debounce timeout and IRQ type in GpioIo() and GpioInt().
>>
>> This will fix broken touchpads for laptops whose BIOS set the debounce
>> timeout to a relatively large value. For example, the BIOS of Lenovo
>> Legion-5 AMD gaming laptops including 15ARH05 (R7000) and R7000P set
>> the debounce timeout to 124.8ms. This led to the kernel receiving only
>> ~7 HID reports per second from the Synaptics touchpad
>> (MSFT0001:00 06CB:7F28). Existing touchpads like [1][2] are not troubled
>> by this bug because the debounce timeout has been set to 0 by the BIOS
>> before enabling the debounce filter in setting IRQ type.
>>
>> [1] https://github.com/Syniurge/i2c-amd-mp2/issues/11#issuecomment-721331582
>> [2] https://forum.manjaro.org/t/random-short-touchpad-freezes/30832/28
>>
>> Cc: Hans de Goede <hdegoede@redhat.com>
>> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
>> Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>> Cc: stable@vger.kernel.org
>> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
>> BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1887190
>> Link: https://lore.kernel.org/linux-gpio/CAHp75VcwiGREBUJ0A06EEw-SyabqYsp%2Bdqs2DpSrhaY-2GVdAA%40mail.gmail.com/
>> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
>
>I'm not entirely sure about this patch. This is consistent with how we
>already stopped touching the debounce timeout setting during init, so
>that speaks in favor of this change.
>
>Still I'm worried a bit that this might have undesirable side effects.
>
Now I can only confirm this patch won't affect the mentioned touchpads.
I'll see if other distributions like Manjaro are willing to test it
through the unstable channel.

>I guess this should be landed together with Andy's series to apply
>the debounce setting from the ACPI GPIO resources.

Thank you for the reminding! You are right, Andy's patch
"gpiolib: acpi: Take into account debounce settings" is needed to
fix this kind of touchpad issues. Since that patch hasn't been
merged, is there a way to refer to it in the commit message?
>
>Regards,
>
>Hans
>
>
>
>
>> ---
>>  drivers/pinctrl/pinctrl-amd.c | 7 -------
>>  1 file changed, 7 deletions(-)
>>
>> diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
>> index e9b761c2b77a..2d4acf21117c 100644
>> --- a/drivers/pinctrl/pinctrl-amd.c
>> +++ b/drivers/pinctrl/pinctrl-amd.c
>> @@ -468,7 +468,6 @@ static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
>>  		pin_reg &= ~BIT(LEVEL_TRIG_OFF);
>>  		pin_reg &= ~(ACTIVE_LEVEL_MASK << ACTIVE_LEVEL_OFF);
>>  		pin_reg |= ACTIVE_HIGH << ACTIVE_LEVEL_OFF;
>> -		pin_reg |= DB_TYPE_REMOVE_GLITCH << DB_CNTRL_OFF;
>>  		irq_set_handler_locked(d, handle_edge_irq);
>>  		break;
>>
>> @@ -476,7 +475,6 @@ static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
>>  		pin_reg &= ~BIT(LEVEL_TRIG_OFF);
>>  		pin_reg &= ~(ACTIVE_LEVEL_MASK << ACTIVE_LEVEL_OFF);
>>  		pin_reg |= ACTIVE_LOW << ACTIVE_LEVEL_OFF;
>> -		pin_reg |= DB_TYPE_REMOVE_GLITCH << DB_CNTRL_OFF;
>>  		irq_set_handler_locked(d, handle_edge_irq);
>>  		break;
>>
>> @@ -484,7 +482,6 @@ static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
>>  		pin_reg &= ~BIT(LEVEL_TRIG_OFF);
>>  		pin_reg &= ~(ACTIVE_LEVEL_MASK << ACTIVE_LEVEL_OFF);
>>  		pin_reg |= BOTH_EADGE << ACTIVE_LEVEL_OFF;
>> -		pin_reg |= DB_TYPE_REMOVE_GLITCH << DB_CNTRL_OFF;
>>  		irq_set_handler_locked(d, handle_edge_irq);
>>  		break;
>>
>> @@ -492,8 +489,6 @@ static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
>>  		pin_reg |= LEVEL_TRIGGER << LEVEL_TRIG_OFF;
>>  		pin_reg &= ~(ACTIVE_LEVEL_MASK << ACTIVE_LEVEL_OFF);
>>  		pin_reg |= ACTIVE_HIGH << ACTIVE_LEVEL_OFF;
>> -		pin_reg &= ~(DB_CNTRl_MASK << DB_CNTRL_OFF);
>> -		pin_reg |= DB_TYPE_PRESERVE_LOW_GLITCH << DB_CNTRL_OFF;
>>  		irq_set_handler_locked(d, handle_level_irq);
>>  		break;
>>
>> @@ -501,8 +496,6 @@ static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
>>  		pin_reg |= LEVEL_TRIGGER << LEVEL_TRIG_OFF;
>>  		pin_reg &= ~(ACTIVE_LEVEL_MASK << ACTIVE_LEVEL_OFF);
>>  		pin_reg |= ACTIVE_LOW << ACTIVE_LEVEL_OFF;
>> -		pin_reg &= ~(DB_CNTRl_MASK << DB_CNTRL_OFF);
>> -		pin_reg |= DB_TYPE_PRESERVE_HIGH_GLITCH << DB_CNTRL_OFF;
>>  		irq_set_handler_locked(d, handle_level_irq);
>>  		break;
>>
>>
>

--
Best regards,
Coiby
