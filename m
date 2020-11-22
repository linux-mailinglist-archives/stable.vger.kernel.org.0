Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4407F2BC4EF
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 11:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbgKVKQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 05:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727330AbgKVKQN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 05:16:13 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484A6C0613CF;
        Sun, 22 Nov 2020 02:16:13 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id k7so7351478plk.3;
        Sun, 22 Nov 2020 02:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Z9n5G7taQiggVfZdvcm3H/Ix8V7vg3F715wMU5mLxc0=;
        b=YcBxF4vGIc/9lc6q/oZwWuDvrF7dlqT5/+GxX+I0a+k00OkVdCIFm23wf951jCNn0r
         XT02SZDHoqJ7QsKDEvMbrWVL9/ldJ4Uo/P115vQI6kt2WX5Gv8tGfW0Ne6XJuDrRcjVV
         ABF+VMtvX0voFuOeGhLsKOvrn50RcgnrXRtg6w5LKxO4QYLn9oeewT0B7y6tkojU6r6O
         9VmBez0Q4maXYeXNa4BlCIcCgjx8mWfotEZcQsjhIMdtm37lEhsa5UbOXX6QKiNyuYWL
         uSnNuzdXl68zXloigy3qnvSocAsKpKU5R1vUL3VRf4ThUCyq2TcotETNyZlhV9l7jAp3
         lBBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Z9n5G7taQiggVfZdvcm3H/Ix8V7vg3F715wMU5mLxc0=;
        b=Q7uqk8iSWR8tW7C59CMGUU9cagc73PrzeQbfMy6QMvLKiv6Dk0Wz7yWFJw2OMb6123
         /THqHNZSB0xvBrGbgkflqeB6Xh1qZfz4xcxgDtfkQB1B9ne+pHi/bNXK3Ylg/OBrpSMp
         uLM2CJt3YCzX4GcuWN1eyDE/SC+7KZgIcUrmdpHSOy8uFiFwd+rGA5S7HxS+MdFRNWir
         1IGB2ATxifkkOwFnSSqv+yS6FXXK/G+noxOlS6euzcMetWDGiz4wRTWG/7gNOpz8NARn
         24dqUdYJ1Qm+R/n9Q/P99NRSaH1oXuKuZb71mnAjIJN69XnmGhHCUSA0Gf568pkfIFyB
         1FSQ==
X-Gm-Message-State: AOAM533qYI3MRhrVbwLXqJWjdchsp83qy7MJS6cOTp+so0zZR02KbsHo
        8BDI0HPdJYZRyh1DywHLl0Ux62qtfdq7pA==
X-Google-Smtp-Source: ABdhPJyCUaZuT+TBKQ5GCgxV1gRbDOIg4IKBgwUWvNRUOLxddnAJj+RhU7EO32Y3JKvmRBUR/4Y5bg==
X-Received: by 2002:a17:902:7e88:b029:d6:74c4:7a82 with SMTP id z8-20020a1709027e88b02900d674c47a82mr19264697pla.64.1606040172215;
        Sun, 22 Nov 2020 02:16:12 -0800 (PST)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id f6sm7945119pgi.70.2020.11.22.02.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 02:16:11 -0800 (PST)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Sun, 22 Nov 2020 18:15:25 +0800
To:     =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Cc:     "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Helmut Stult <helmut.stult@schinfo.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] HID: i2c-hid: add polling mode based on connected
 GPIO chip's pin status
Message-ID: <20201122101525.j265hvj6lqgbtfi2@Rk>
References: <20201021134931.462560-1-coiby.xu@gmail.com>
 <qo0Y8DqV6mbQsSFabOaqRoxYhKdYCZPjqYuF811CTdPXRFFXpx7sNXYcW9OGI5PMyclgsTjI7Xj3Du3v4hYQVBWGJl3t0t8XSbTKE9uOJ2E=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <qo0Y8DqV6mbQsSFabOaqRoxYhKdYCZPjqYuF811CTdPXRFFXpx7sNXYcW9OGI5PMyclgsTjI7Xj3Du3v4hYQVBWGJl3t0t8XSbTKE9uOJ2E=@protonmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Thu, Oct 22, 2020 at 02:22:51PM +0000, Barnabás Pőcze wrote:
>Hi,
>
>I think this looks a lot better than the first version, the issues around
>suspend/resume are sorted out as far as I can see. However, I still have a couple
>comments, mainly minor ones.
>
Thank you for reviewing this patch!
>
>> [...]
>> +/* polling mode */
>> +#define I2C_HID_POLLING_DISABLED 0
>> +#define I2C_HID_POLLING_GPIO_PIN 1
>> +#define I2C_HID_POLLING_INTERVAL_ACTIVE_US 4000
>> +#define I2C_HID_POLLING_INTERVAL_IDLE_MS 10
>> +
>> +static u8 polling_mode;
>> +module_param(polling_mode, byte, 0444);
>> +MODULE_PARM_DESC(polling_mode, "How to poll - 0 disabled; 1 based on GPIO pin's status");
>> +
>
>Minor thing, but maybe the default value should be documented in the parameter
>description?
>
>
>> +static unsigned int polling_interval_active_us = I2C_HID_POLLING_INTERVAL_ACTIVE_US;
>> +module_param(polling_interval_active_us, uint, 0644);
>> +MODULE_PARM_DESC(polling_interval_active_us,
>> +		 "Poll every {polling_interval_active_us} us when the touchpad is active. Default to 4000 us");
>> +
>> +static unsigned int polling_interval_idle_ms = I2C_HID_POLLING_INTERVAL_IDLE_MS;
>
>Since these two parameters are mostly read, I think the `__read_mostly`
>attribute (linux/cache.h) is justified here.
>
>
>> +module_param(polling_interval_idle_ms, uint, 0644);
>> +MODULE_PARM_DESC(polling_interval_idle_ms,
>> +		 "Poll every {polling_interval_idle_ms} ms when the touchpad is idle. Default to 10 ms");
>
>This is minor stylistic thing; as far as I see, the prevalent pattern is to put
>the default value at the end, in parenthesis:
>E.g. "some parameter description (default=X)" or "... (default: X)" or something similar
>
>Maybe __stringify() (linux/stringify.h) could be used here and for the previous
>module parameter?
>
>E.g. "... (default=" __stringify(I2C_HID_POLLING_INTERVAL_IDLE_MS) ")"
>
Thank you for the above three suggestions! Will be applied in v4.
>
>> [...]
>> +static int get_gpio_pin_state(struct irq_desc *irq_desc)
>> +{
>> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(&irq_desc->irq_data);
>> +
>> +	return gc->get(gc, irq_desc->irq_data.hwirq);
>> +}
>> +
>> +static bool interrupt_line_active(struct i2c_client *client)
>> +{
>> +	unsigned long trigger_type = irq_get_trigger_type(client->irq);
>
>Can the trigger type change? Because if not, then I think it'd be better to store
>the value somewhere and not query it every time.
>
The irq trigger type is obtained from ACPI so I don't think it won't
change.
>
>> +	struct irq_desc *irq_desc = irq_to_desc(client->irq);
>
>Same here.
>
Thank you for the reminding!
>
>> +	ssize_t	status = get_gpio_pin_state(irq_desc);
>
>`get_gpio_pin_state()` returns an `int`, so I am not sure why `ssize_t` is used here.
>

I used `ssize_t` because I found gpiolib-sysfs.c uses `ssize_t`

     // drivers/gpio/gpiolib-sysfs.c
     static ssize_t value_show(struct device *dev,
     		struct device_attribute *attr, char *buf)
     {
     	struct gpiod_data *data = dev_get_drvdata(dev);
     	struct gpio_desc *desc = data->desc;
     	ssize_t			status;

     	mutex_lock(&data->mutex);

     	status = gpiod_get_value_cansleep(desc);
         ...
     	return status;
     }

According to the book Advanced Programming in the UNIX Environment by
W. Richard Stevens,
     With the 1990 POSIX.1 standard, the primitive system data type
     ssize_t was introduced to provide the signed return value...

So ssize_t is fairly common, for example, the read and write syscall
return a value of type ssize_t. But I haven't found out why ssize_t is
better int.
>
>> +
>> +	if (status < 0) {
>> +		dev_warn(&client->dev,
>> +			 "Failed to get GPIO Interrupt line status for %s",
>> +			 client->name);
>
>I think it's possible that the kernel message buffer is flooded with these
>messages, which is not optimal in my opinion.
>
Thank you! Replaced with dev_dbg in v4.
>
>> +		return false;
>> +	}
>> +	/*
>> +	 * According to Windows Precsiontion Touchpad's specs
>> +	 * https://docs.microsoft.com/en-us/windows-hardware/design/component-guidelines/windows-precision-touchpad-device-bus-connectivity,
>> +	 * GPIO Interrupt Assertion Leve could be either ActiveLow or
>> +	 * ActiveHigh.
>> +	 */
>> +	if (trigger_type & IRQF_TRIGGER_LOW)
>> +		return !status;
>> +
>> +	return status;
>> +}
>> +
>> +static int i2c_hid_polling_thread(void *i2c_hid)
>> +{
>> +	struct i2c_hid *ihid = i2c_hid;
>> +	struct i2c_client *client = ihid->client;
>> +	unsigned int polling_interval_idle;
>> +
>> +	while (1) {
>> +		if (kthread_should_stop())
>> +			break;
>
>I think this should be `while (!kthread_should_stop())`.
>
This simplifies the code. Thank you!
>
>> +
>> +		while (interrupt_line_active(client) &&
>> +		       !test_bit(I2C_HID_READ_PENDING, &ihid->flags) &&
>> +		       !kthread_should_stop()) {
>> +			i2c_hid_get_input(ihid);
>> +			usleep_range(polling_interval_active_us,
>> +				     polling_interval_active_us + 100);
>> +		}
>> +		/*
>> +		 * re-calculate polling_interval_idle
>> +		 * so the module parameters polling_interval_idle_ms can be
>> +		 * changed dynamically through sysfs as polling_interval_active_us
>> +		 */
>> +		polling_interval_idle = polling_interval_idle_ms * 1000;
>> +		usleep_range(polling_interval_idle,
>> +			     polling_interval_idle + 1000);
>
>I don't quite understand why you use an extra variable here. I'm assuming
>you want to "save" a multiplication? I believe the compiler will optimize it
>to a single read, and single multiplication regardless whether you use a "temporary"
>variable or not.
>
>
>> +	}
>> +
>> +	do_exit(0);
>
>Looking at other examples, I don't think `do_exit()` is necessary.
>
According to the doc of kthread_create_on_node,
     @threadfn() can either call do_exit() directly if it is a
     * standalone thread for which no one will call kthread_stop(), or
     * return when 'kthread_should_stop()' is true (which means
     * kthread_stop() has been called).

do_exit is not necessary. Thank you for raising up this issue and
looking at other examples for me!
>
>> +	return 0;
>> +}
>> +
>> +static int i2c_hid_init_polling(struct i2c_hid *ihid)
>> +{
>> +	struct i2c_client *client = ihid->client;
>> +
>> +	if (!irq_get_trigger_type(client->irq)) {
>> +		dev_warn(&client->dev,
>> +			 "Failed to get GPIO Interrupt Assertion Level, could not enable polling mode for %s",
>> +			 client->name);
>> +		return -EINVAL;
>> +	}
>> +
>> +	ihid->polling_thread = kthread_create(i2c_hid_polling_thread, ihid,
>> +					      "I2C HID polling thread");
>> +
>> +	if (!IS_ERR(ihid->polling_thread)) {
>> +		pr_info("I2C HID polling thread created");
>> +		wake_up_process(ihid->polling_thread);
>> +		return 0;
>> +	}
>> +
>> +	return PTR_ERR(ihid->polling_thread);
>
>I would personally rewrite this parts as
>
>```
>if (IS_ERR(...)) {
>  dev_err(...);
>  return PTR_ERR(...);
>}
>....
>return 0;
>```

Thank you! This style is consistent with other functions in this file.
>
>
>> +}
>> [...]
>
>
>Regards,
>Barnabás Pőcze

--
Best regards,
Coiby
