Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF972C3E9C
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 12:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgKYK6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 05:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbgKYK6Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 05:58:16 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E3EC0613D4;
        Wed, 25 Nov 2020 02:57:57 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id s63so2122240pgc.8;
        Wed, 25 Nov 2020 02:57:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=R9jPt2NH0PK1K5G5eT5q3EFReOKpDq7B+jBKCFjohwc=;
        b=kNfN86rUCgkHBYEGXYY3KxiFEGCkN9x2OrS7GJ5DMpZhvENrmY6hPmOyoCnIPLgsyc
         UDeMXa2CCUbOzJzAN7uwGa1J6LObL4515ObltxkOsk9pTVHhAPsJboqC2wmCMrGmDRdA
         6C6+48OE6hYSgqW9p29YrWc9+3+ciEv/QaJ7efQojK1j5tW+l1PWGPURb9LvtR+ouLzb
         pFxwwKLMJ2AYnT1xQ3+3AVD1sERk27A93pUMIlrcKK3zM1lCwP3kygeK8ZNDgio6h82c
         Tn7Gu6p05noyjfa5Rpe2ZGCo8izkVwWWw8HljimpnRLAYIFDKCcF/JXe397UQHvO3zP2
         HdWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=R9jPt2NH0PK1K5G5eT5q3EFReOKpDq7B+jBKCFjohwc=;
        b=EOqsHRfwBhjP/JuRfyTeTIjHlazwU2kDPiTntVVchapGKB7aZfZ9Iqq9EtiJnQyNCO
         +g/YIduLYn9VjpxXZJmS1il6L2Yn7RkIVsT3jcmqAGI57KVcUJVAeqbBKVPOrU4Z285L
         yQcOPAG47/n6fa/TzBHlyae7OS7DyohfSx34CCdDkhohFq6CT4f/v19k2PH5TZA6k5E+
         IzwCg9xupsr+7u1GO0kvDYonz7Fattx0hRH8H7VCzDJzYEw24ddZ1S+wI6KfaTNwGW8c
         B/NTFkbUQN9UwP99Cc0a/ElyAGu60zppM4muBg5gkh1LjcOmP6zTZDP2vp4HdaryGt2o
         epqQ==
X-Gm-Message-State: AOAM5325ALV5TYsy+nzs7SEHHYseCw73lkgo+N5aPX2JQ+8Eu8qq6Phr
        BfhHmIGWWiDnabnJd6r3bArsShg0vK0QpFYn
X-Google-Smtp-Source: ABdhPJzsuDYQ6UoK81C2ACET8sZYWgiFM+HazP3c2EQv5tebpQTo0+d1gQzAQwaOCpeMzvenX4/pZw==
X-Received: by 2002:a17:90a:ec06:: with SMTP id l6mr3455086pjy.38.1606301877362;
        Wed, 25 Nov 2020 02:57:57 -0800 (PST)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id t128sm1673438pfb.111.2020.11.25.02.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 02:57:56 -0800 (PST)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Wed, 25 Nov 2020 18:57:20 +0800
To:     =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Cc:     "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Helmut Stult <helmut.stult@schinfo.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] HID: i2c-hid: add polling mode based on connected
 GPIO chip's pin status
Message-ID: <20201125105720.xatyiva7psrfyzbi@Rk>
References: <20201021134931.462560-1-coiby.xu@gmail.com>
 <qo0Y8DqV6mbQsSFabOaqRoxYhKdYCZPjqYuF811CTdPXRFFXpx7sNXYcW9OGI5PMyclgsTjI7Xj3Du3v4hYQVBWGJl3t0t8XSbTKE9uOJ2E=@protonmail.com>
 <20201122101525.j265hvj6lqgbtfi2@Rk>
 <xsbDy_74QEfC8byvpA0nIjI0onndA3wuiLm2Iattq-8TLPy28kMq7GKhkfrfzqdBAQfp_w5CTCCJ8XjFmegtZqP58xioheh7OHV7Bam33aQ=@protonmail.com>
 <20201123143613.zzrm3wgm4m6ngvrz@Rk>
 <1FeR4cJ-m2i5GGyb68drDocoWP-yJ47BeKKEi2IkYbkppLFRCQPTQT4D6xqVCQcmUIjIsoe9HXhwycxxt5XxtsESO6w4uVMzISa987s_T-U=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1FeR4cJ-m2i5GGyb68drDocoWP-yJ47BeKKEi2IkYbkppLFRCQPTQT4D6xqVCQcmUIjIsoe9HXhwycxxt5XxtsESO6w4uVMzISa987s_T-U=@protonmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 23, 2020 at 04:32:40PM +0000, Barnabás Pőcze wrote:
>> [...]
>> >> >> +static int get_gpio_pin_state(struct irq_desc *irq_desc)
>> >> >> +{
>> >> >> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(&irq_desc->irq_data);
>> >> >> +
>> >> >> +	return gc->get(gc, irq_desc->irq_data.hwirq);
>> >> >> +}
>> >> [...]
>> >> >> +	ssize_t	status = get_gpio_pin_state(irq_desc);
>> >> >
>> >> >`get_gpio_pin_state()` returns an `int`, so I am not sure why `ssize_t` is used here.
>> >> >
>> >>
>> >> I used `ssize_t` because I found gpiolib-sysfs.c uses `ssize_t`
>> >>
>> >>      // drivers/gpio/gpiolib-sysfs.c
>> >>      static ssize_t value_show(struct device *dev,
>> >>      		struct device_attribute *attr, char *buf)
>> >>      {
>> >>      	struct gpiod_data *data = dev_get_drvdata(dev);
>> >>      	struct gpio_desc *desc = data->desc;
>> >>      	ssize_t			status;
>> >>
>> >>      	mutex_lock(&data->mutex);
>> >>
>> >>      	status = gpiod_get_value_cansleep(desc);
>> >>          ...
>> >>      	return status;
>> >>      }
>> >>
>> >> According to the book Advanced Programming in the UNIX Environment by
>> >> W. Richard Stevens,
>> >>      With the 1990 POSIX.1 standard, the primitive system data type
>> >>      ssize_t was introduced to provide the signed return value...
>> >>
>> >> So ssize_t is fairly common, for example, the read and write syscall
>> >> return a value of type ssize_t. But I haven't found out why ssize_t is
>> >> better int.
>> >> >
>> >
>> >Sorry if I wasn't clear, what prompted me to ask that question is the following:
>> >`gc->get()` returns `int`, `get_gpio_pin_state()` returns `int`, yet you still
>> >save the return value of `get_gpio_pin_state()` into a variable with type
>> >`ssize_t` for no apparent reason. In the example you cited, `ssize_t` is used
>> >because the show() callback of a sysfs attribute must return `ssize_t`, but here,
>> >`interrupt_line_active()` returns `bool`, so I don't see any advantage over a
>> >plain `int`. Anyways, I believe either one is fine, I just found it odd.
>> >
>> I don't understand why "the show() callback of a sysfs attribute
>> must return `ssize_t`" instead of int. Do you think the rationale
>> behind it is the same for this case? If yes, using "ssize_t" for
>> status could be justified.
>> [...]
>
>Because it was decided that way, `ssize_t` is a better choice for that purpose
>than plain `int`. You can see it in include/linux/device.h, that both the
>show() and store() methods must return `ssize_t`.
>

Could you explain why `ssize_t` is a better choice? AFAIU, ssize_t
is used because we can return negative value to indicate an error. If
we use ssize_t here, it's a reminder that reading a GPIO pin's status
could fail. And ssize_t reminds us it's a operation similar to read
or write. So ssize_t is better than int here. And maybe it's the same
reason why "it was decided that way".

>What I'm arguing here, is that there is no reason to use `ssize_t` in this case.
>Because `get_gpio_pin_state()` returns `int`. So when you do
>```
>ssize_t status = get_gpio_pin_state(...);
>```
>then the return value of `get_gpio_pin_state()` (which is an `int`), will be
>converted to an `ssize_t`, and saved into `status`. I'm arguing that that is
>unnecessary and a plain `int` would work perfectly well in this case. Anyways,
>both work fine, I just found the unnecessary use of `ssize_t` here odd.
>
>
>Regards,
>Barnabás Pőcze

--
Best regards,
Coiby
