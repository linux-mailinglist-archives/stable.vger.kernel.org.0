Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9222C4102
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 14:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbgKYNSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 08:18:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgKYNSw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 08:18:52 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9E8C0613D4;
        Wed, 25 Nov 2020 05:18:52 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id w6so2323538pfu.1;
        Wed, 25 Nov 2020 05:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=79RWkpKphmzqYVCpzmqSL8/KyVEPYndRctK3cRSHXF0=;
        b=SKhhwrD7MQ5UEyysdYYHPwpieO1jtBnCmu6+laLdkKpJ6HtaU+y/iluFXabR15rUSj
         aE/+b1vSBpso3mO2oqJwnsONXkuIIkJKlKhIZOtFfyp9+0vX8g6WWz4Q8dgTuV3A8vmd
         slNNdS+1Yxa5bNNwPR+TKVwAlQ5gq9CiMKOX6FHBIzyBqG4ogPCIHyX1aP0OoS8zUR3e
         7LM15LflZalT+E+V0Rg0ZpeI+FI08rNgytEPEuayn2hmcCOhuGcn8U/xFtOXmS+ntbfM
         F1QjsHzEh1+ST8lYFK2Gsuyu+b2O8LP9lXGoG+8iRcDLG2OlYLhNjaKhbndYuaXZ2owy
         hkVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=79RWkpKphmzqYVCpzmqSL8/KyVEPYndRctK3cRSHXF0=;
        b=fgH0w9nN4oeuQalmQVwjoAgDpW0FMCVKCh5r28b85zyC72Jyzu7YZyWRJD4jDKaotq
         rnFwsgv0Tc1iYhtfUHIYjPmppaF8AV6oakuXheNv470sgA/Zp7yBpWLQ1oBi84ZAELPJ
         mqBam7EACSG3DvImq+rAGQ4JatdtKA7aJRlbWQ3vMM3q53KAtbosNHSNUNwGcqFiXY8o
         yztWMzR9UVWU3wh1n9DbIqTGjIyhstDJn9YddPZ5VONod35vclKKSuHX/FUXwrtVwwoV
         1cxwG9A/Iyv0Mf1NJ9cpTEy9bR6NpBWmi4VQ5VOfW90cgkS6bWwe0o/MsS7DCNDv6794
         nJdA==
X-Gm-Message-State: AOAM533zqCp6wMerLPU/PxOtzg6lbz7UJ/2teWKWkGU4M+2oGhCfLxRE
        aTHp8/kMmVZvDIOPuiFtJ1U=
X-Google-Smtp-Source: ABdhPJxSa/iAK5J2IyokOJjsf8k6Wg0N/77RypifbymDr+b3ERA2HhoMVTh0nHW8yZLF3d5hyHThxg==
X-Received: by 2002:a63:34c:: with SMTP id 73mr3049308pgd.172.1606310331717;
        Wed, 25 Nov 2020 05:18:51 -0800 (PST)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id w196sm2033501pfd.177.2020.11.25.05.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 05:18:51 -0800 (PST)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Wed, 25 Nov 2020 21:18:14 +0800
To:     =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Cc:     "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Helmut Stult <helmut.stult@schinfo.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] HID: i2c-hid: add polling mode based on connected
 GPIO chip's pin status
Message-ID: <20201125131814.qkaqidk7mdavr2nd@Rk>
References: <20201021134931.462560-1-coiby.xu@gmail.com>
 <qo0Y8DqV6mbQsSFabOaqRoxYhKdYCZPjqYuF811CTdPXRFFXpx7sNXYcW9OGI5PMyclgsTjI7Xj3Du3v4hYQVBWGJl3t0t8XSbTKE9uOJ2E=@protonmail.com>
 <20201122101525.j265hvj6lqgbtfi2@Rk>
 <xsbDy_74QEfC8byvpA0nIjI0onndA3wuiLm2Iattq-8TLPy28kMq7GKhkfrfzqdBAQfp_w5CTCCJ8XjFmegtZqP58xioheh7OHV7Bam33aQ=@protonmail.com>
 <20201123143613.zzrm3wgm4m6ngvrz@Rk>
 <1FeR4cJ-m2i5GGyb68drDocoWP-yJ47BeKKEi2IkYbkppLFRCQPTQT4D6xqVCQcmUIjIsoe9HXhwycxxt5XxtsESO6w4uVMzISa987s_T-U=@protonmail.com>
 <20201125105720.xatyiva7psrfyzbi@Rk>
 <_1j4GSFZpZ-rAOrhM2TQwyID7K4XCCkKwLeIcFMxQ1vlFg6wr544L5Lcrp7BvpsMmkhMYsTUT3yTTM61J7aVTYmGMSddkrz244_uV0gg9mU=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <_1j4GSFZpZ-rAOrhM2TQwyID7K4XCCkKwLeIcFMxQ1vlFg6wr544L5Lcrp7BvpsMmkhMYsTUT3yTTM61J7aVTYmGMSddkrz244_uV0gg9mU=@protonmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 25, 2020 at 12:39:02PM +0000, Barnabás Pőcze wrote:
>2020. november 25., szerda 11:57 keltezéssel, Coiby Xu írta:
>
>> On Mon, Nov 23, 2020 at 04:32:40PM +0000, Barnabás Pőcze wrote:
>> >> [...]
>> >> >> >> +static int get_gpio_pin_state(struct irq_desc *irq_desc)
>> >> >> >> +{
>> >> >> >> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(&irq_desc->irq_data);
>> >> >> >> +
>> >> >> >> +	return gc->get(gc, irq_desc->irq_data.hwirq);
>> >> >> >> +}
>> >> >> [...]
>> >> >> >> +	ssize_t	status = get_gpio_pin_state(irq_desc);
>> >> >> >
>> >> >> >`get_gpio_pin_state()` returns an `int`, so I am not sure why `ssize_t` is used here.
>> >> >> >
>> >> >>
>> >> >> I used `ssize_t` because I found gpiolib-sysfs.c uses `ssize_t`
>> >> >>
>> >> >>      // drivers/gpio/gpiolib-sysfs.c
>> >> >>      static ssize_t value_show(struct device *dev,
>> >> >>      		struct device_attribute *attr, char *buf)
>> >> >>      {
>> >> >>      	struct gpiod_data *data = dev_get_drvdata(dev);
>> >> >>      	struct gpio_desc *desc = data->desc;
>> >> >>      	ssize_t			status;
>> >> >>
>> >> >>      	mutex_lock(&data->mutex);
>> >> >>
>> >> >>      	status = gpiod_get_value_cansleep(desc);
>> >> >>          ...
>> >> >>      	return status;
>> >> >>      }
>> >> >>
>> >> >> According to the book Advanced Programming in the UNIX Environment by
>> >> >> W. Richard Stevens,
>> >> >>      With the 1990 POSIX.1 standard, the primitive system data type
>> >> >>      ssize_t was introduced to provide the signed return value...
>> >> >>
>> >> >> So ssize_t is fairly common, for example, the read and write syscall
>> >> >> return a value of type ssize_t. But I haven't found out why ssize_t is
>> >> >> better int.
>> >> >> >
>> >> >
>> >> >Sorry if I wasn't clear, what prompted me to ask that question is the following:
>> >> >`gc->get()` returns `int`, `get_gpio_pin_state()` returns `int`, yet you still
>> >> >save the return value of `get_gpio_pin_state()` into a variable with type
>> >> >`ssize_t` for no apparent reason. In the example you cited, `ssize_t` is used
>> >> >because the show() callback of a sysfs attribute must return `ssize_t`, but here,
>> >> >`interrupt_line_active()` returns `bool`, so I don't see any advantage over a
>> >> >plain `int`. Anyways, I believe either one is fine, I just found it odd.
>> >> >
>> >> I don't understand why "the show() callback of a sysfs attribute
>> >> must return `ssize_t`" instead of int. Do you think the rationale
>> >> behind it is the same for this case? If yes, using "ssize_t" for
>> >> status could be justified.
>> >> [...]
>> >
>> >Because it was decided that way, `ssize_t` is a better choice for that purpose
>> >than plain `int`. You can see it in include/linux/device.h, that both the
>> >show() and store() methods must return `ssize_t`.
>> >
>>
>> Could you explain why `ssize_t` is a better choice? AFAIU, ssize_t
>> is used because we can return negative value to indicate an error.
>
>ssize_t: "Signed integer type used for a count of bytes or an error indication."[1]
>
>And POSIX mandates that the return type of read() and write() be `ssize_t`,
>so it makes sense to keep a similar interface in the kernel since show() and store()
>are called as a direct result of the user using the read() and write() system
>calls, respectively.
>
>
>> If
>> we use ssize_t here, it's a reminder that reading a GPIO pin's status
>> could fail. And ssize_t reminds us it's a operation similar to read
>> or write. So ssize_t is better than int here. And maybe it's the same
>> reason why "it was decided that way".
>> [...]
>
>I believe it's more appropriate to use ssize_t when it's about a "count of elements",
>but the GPIO pin state is a single boolean value (or an error indication), which
>is returned as an `int`. Since it's returned as an `int` - I'm arguing that -
>there is no reason to use `ssize_t` here. Anyways, both `ssize_t` and `int` work fine
>in this case.
>
So value_show in gpiolib-sysfs.c is a kind of being forced to use
ssize_t. I'll use int instead to avoid confusion in v4. Thank you for
the explanation!
>
>[1]: https://pubs.opengroup.org/onlinepubs/9699919799/functions/V2_chap02.html#tag_15_12
>
>
>Regards,
>Barnabás Pőcze

--
Best regards,
Coiby
