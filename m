Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB7A2C0DD2
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 15:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbgKWOjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 09:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726745AbgKWOjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 09:39:48 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B376CC0613CF;
        Mon, 23 Nov 2020 06:39:48 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id n137so5046568pfd.3;
        Mon, 23 Nov 2020 06:39:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=fM4j6RxSfo5XXrx0DZNKP61g+fXLGOf6UqMSA1kliTM=;
        b=n4arlp4WrfAdV9Al4lHHmjtOFo/jH6SuDDse9onYIq4yhjSioHU3iYpJwH138yPrzY
         LBZUQagNqnrgPF4JILY/I9bN9EEwTimM4alYTZYbk2J7o7tx2Xgskt9xYPnr1+FrnLKp
         SiJzWibdOTZyz6shXUuOmNzFNDbSef02QEkSNV8RSWiLgutHrLk7SROluh7zkmH4xAsd
         /qQ4syQ9U7CoiJml/LkXllebqwpPiavQl7hWJ+jgGXhxdbFXw035Vxdh51aj71Bnxu2k
         O3BvsEe3FSKebtpwF4efadGrMJwytMR6hvhcmH+TqvDJ89ntx2gZXmehfnE0H3ZviBLH
         b/hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=fM4j6RxSfo5XXrx0DZNKP61g+fXLGOf6UqMSA1kliTM=;
        b=RMoVH3Y7LOmBkDTED9TxiKLlkSP1k9WPIaSjohZsu0UnWFv8US4K/NbMudEqkV8qo+
         pAO86Wltwo7mu7ClE/TkzQzhwQONEObzULFNIoRy3qd4Wf/Kr/JTmjvQNus0nEsMWYtS
         E+HYw6qS7wCs9zusnnG0BTbwTUK5AijOqZe+MF5F6KMTw7dUxi43LOF7hNkJknQ9rbUu
         XTzPuMl/8SezouDMPCiYhLrr/C12jYOox4cGyuw/u0cP18M2FSNEia/DyrLxJpDtfyX3
         fEHf6YcsxZc4X77Ps1kE6JJmZFuYGBFAtW8Zxg+DgJ6ad57dnXOLrqyQ3WcboT8Jplr2
         fwCA==
X-Gm-Message-State: AOAM531jehvpL/xGrU8D93ziFz88cGt4bgbin0RXuP5Dktjip+UJpvZn
        ac8p0Q7i/E9JhfFy5zM2AVU=
X-Google-Smtp-Source: ABdhPJyjc1M3igO33p6Z7ggpwS0tjse9yx7d+DyT5lc9Di4y9VULB6f0m9+NCpQbWKBgfb704C0aJw==
X-Received: by 2002:a17:90b:a43:: with SMTP id gw3mr22pjb.189.1606142387596;
        Mon, 23 Nov 2020 06:39:47 -0800 (PST)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id m13sm2087797pfa.115.2020.11.23.06.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 06:39:46 -0800 (PST)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Mon, 23 Nov 2020 22:36:13 +0800
To:     =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Cc:     "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Helmut Stult <helmut.stult@schinfo.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] HID: i2c-hid: add polling mode based on connected
 GPIO chip's pin status
Message-ID: <20201123143613.zzrm3wgm4m6ngvrz@Rk>
References: <20201021134931.462560-1-coiby.xu@gmail.com>
 <qo0Y8DqV6mbQsSFabOaqRoxYhKdYCZPjqYuF811CTdPXRFFXpx7sNXYcW9OGI5PMyclgsTjI7Xj3Du3v4hYQVBWGJl3t0t8XSbTKE9uOJ2E=@protonmail.com>
 <20201122101525.j265hvj6lqgbtfi2@Rk>
 <xsbDy_74QEfC8byvpA0nIjI0onndA3wuiLm2Iattq-8TLPy28kMq7GKhkfrfzqdBAQfp_w5CTCCJ8XjFmegtZqP58xioheh7OHV7Bam33aQ=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <xsbDy_74QEfC8byvpA0nIjI0onndA3wuiLm2Iattq-8TLPy28kMq7GKhkfrfzqdBAQfp_w5CTCCJ8XjFmegtZqP58xioheh7OHV7Bam33aQ=@protonmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 22, 2020 at 01:33:01PM +0000, Barnabás Pőcze wrote:
>Hi
>
>
>2020. november 22., vasárnap 11:15 keltezéssel, Coiby Xu írta:
>
>> [...]
>> >> +static int get_gpio_pin_state(struct irq_desc *irq_desc)
>> >> +{
>> >> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(&irq_desc->irq_data);
>> >> +
>> >> +	return gc->get(gc, irq_desc->irq_data.hwirq);
>> >> +}
>> [...]
>> >> +	ssize_t	status = get_gpio_pin_state(irq_desc);
>> >
>> >`get_gpio_pin_state()` returns an `int`, so I am not sure why `ssize_t` is used here.
>> >
>>
>> I used `ssize_t` because I found gpiolib-sysfs.c uses `ssize_t`
>>
>>      // drivers/gpio/gpiolib-sysfs.c
>>      static ssize_t value_show(struct device *dev,
>>      		struct device_attribute *attr, char *buf)
>>      {
>>      	struct gpiod_data *data = dev_get_drvdata(dev);
>>      	struct gpio_desc *desc = data->desc;
>>      	ssize_t			status;
>>
>>      	mutex_lock(&data->mutex);
>>
>>      	status = gpiod_get_value_cansleep(desc);
>>          ...
>>      	return status;
>>      }
>>
>> According to the book Advanced Programming in the UNIX Environment by
>> W. Richard Stevens,
>>      With the 1990 POSIX.1 standard, the primitive system data type
>>      ssize_t was introduced to provide the signed return value...
>>
>> So ssize_t is fairly common, for example, the read and write syscall
>> return a value of type ssize_t. But I haven't found out why ssize_t is
>> better int.
>> >
>
>Sorry if I wasn't clear, what prompted me to ask that question is the following:
>`gc->get()` returns `int`, `get_gpio_pin_state()` returns `int`, yet you still
>save the return value of `get_gpio_pin_state()` into a variable with type
>`ssize_t` for no apparent reason. In the example you cited, `ssize_t` is used
>because the show() callback of a sysfs attribute must return `ssize_t`, but here,
>`interrupt_line_active()` returns `bool`, so I don't see any advantage over a
>plain `int`. Anyways, I believe either one is fine, I just found it odd.
>
I don't understand why "the show() callback of a sysfs attribute
must return `ssize_t`" instead of int. Do you think the rationale
behind it is the same for this case? If yes, using "ssize_t" for
status could be justified.

>
>> >> +
>> >> +	if (status < 0) {
>> >> +		dev_warn(&client->dev,
>> >> +			 "Failed to get GPIO Interrupt line status for %s",
>> >> +			 client->name);
>> >
>> >I think it's possible that the kernel message buffer is flooded with these
>> >messages, which is not optimal in my opinion.
>> >
>> Thank you! Replaced with dev_dbg in v4.
>> [...]
>
>Have you looked at `dev_{warn,dbg,...}_ratelimited()`?
>
Thank you for pointing me to these functions!
>
>Regards,
>Barnabás Pőcze

--
Best regards,
Coiby
