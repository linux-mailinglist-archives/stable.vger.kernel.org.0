Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12507290F51
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 07:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411758AbgJQFeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 01:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411742AbgJQFem (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 01:34:42 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E73C0613A6;
        Fri, 16 Oct 2020 17:46:31 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t18so2145437plo.1;
        Fri, 16 Oct 2020 17:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=dn9cdPHWGuAfcbl3He2BFEACXq6BvONvKiWXbCjohRk=;
        b=CIIZEr6gQxn5JEsE0dyJ3QU4JgFlq8/H1DJ32sNozMPqljGJtBUjIYdLDQJFd8B5h6
         kHYftEVJgRQGebLEwwDWBiLaF9mIgLuy2OILeubg2YgandHJx079+cw4w9m9b2DEKNIx
         Wuc2KSZlMOzFH6N6sFIkt0inqK6TRYgbiqAzx62isyUbwUeoB4M7SXQOEHVhqfwfZkM6
         PHfdNGyLpwy8LzUkk30q9mGtx9FpzOH9ZXcja47jOhuxTRzUmApTGVEstqL67O4aKLU4
         8dqe8StmOzOgeeolwuBkpPSzMwnVqmgDBWgXfo4RuO8x5BRAovIyPaxRJsLMwzi8E1AE
         OB1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=dn9cdPHWGuAfcbl3He2BFEACXq6BvONvKiWXbCjohRk=;
        b=gZAUwndG4iz5N5cJCr7KTjw8R95sLaJSG3pEMosso0/Y4XAow9Zr+mqm6f3MimKB4Q
         h1yCFWVdiVNeE5bp1QrZQS8K5W0LhG52LeQhoN1vBYy36a18UlhjM23aA9fWgG7ZkwLj
         cLFjqqoLuC9XMIUxDS4/3rCh2TB/Si7//yH/QvulfiVyDzzf+QSg2TCPqHgWwpVzi1sg
         NYwRKQSwDy2jx3+VY6kOHOItcwMQtiRtn5WhSMXLRHgxjv7UETrrNdU6IYxr0/K6toCf
         mAQp/iwahDj5H81AmbecLaWuAsQz2oZZzpzvq9VAGu7UkBsZHLc555lzAACBZxC53ZDq
         fvhA==
X-Gm-Message-State: AOAM5326x3M0LUEDPot6zZ66E+0+9LH/ReQvMCPJHIdcI7pTYZHuKMDM
        THLu8/yh0mt5oYRhEmkjke4=
X-Google-Smtp-Source: ABdhPJx0+GPjjDU4pEHz/lc2slf4aU35ky3MUeRVFEHRJPWqG4/iwOFHikynZEJaQx32WxMH/Jh6iw==
X-Received: by 2002:a17:902:7c93:b029:d4:e1c3:bde0 with SMTP id y19-20020a1709027c93b02900d4e1c3bde0mr6425873pll.85.1602895590795;
        Fri, 16 Oct 2020 17:46:30 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id b142sm3892091pfb.186.2020.10.16.17.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 17:46:30 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Sat, 17 Oct 2020 08:45:56 +0800
To:     =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Cc:     "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Helmut Stult <helmut.stult@schinfo.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] HID: i2c-hid: add polling mode based on connected
 GPIO chip's pin status
Message-ID: <20201017004556.kuoxzmbvef4yr3kg@Rk>
References: <20201016131335.8121-1-coiby.xu@gmail.com>
 <T2SIcFVxZ81NUwKLDbSESA7Wpm7DYowEiii8ZaxTPtrdXZZeHLq5iZPkN5BLlp-9C6PLwUZOVwNpMdEdPSRZcAG4MmDt-tfyKZoQYJ0KHOA=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <T2SIcFVxZ81NUwKLDbSESA7Wpm7DYowEiii8ZaxTPtrdXZZeHLq5iZPkN5BLlp-9C6PLwUZOVwNpMdEdPSRZcAG4MmDt-tfyKZoQYJ0KHOA=@protonmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thank you for examine this patch in such a careful way!

On Fri, Oct 16, 2020 at 03:00:49PM +0000, Barnabás Pőcze wrote:
>Hi,
>
>I still think that `i2c_hid_resume()` and `i2c_hid_suspend()` are asymmetric and
>that might lead to issues.
>

Do you think this commit message is relevant to your concern?

$ git show d1c48038b849e9df0475621a52193a62424a4e87
commit d1c48038b849e9df0475621a52193a62424a4e87
     HID: i2c-hid: Only disable irq wake if it was successfully enabled during suspend

     Enabling irq wake could potentially fail and calling disable_irq_wake
     after a failed call to enable_irq_wake could result in an unbalanced irq
     warning. This patch warns if enable_irq_wake fails and avoids other
     potential issues caused by calling disable_irq_wake on resume after
     enable_irq_wake failed during suspend.

So I think all cases about irq have been handled. But for the regulator
part, you are right. I made a mistake.
>
>> [...]
>> When polling mode is enabled, an I2C device can't wake up the suspended
>> system since enable/disable_irq_wake is invalid for polling mode.
>>
>
>Excuse my ignorance, but could you elaborate this because I am not sure I understand.
>Aren't the two things orthogonal (polling and waking up the system)?
>
Waking up the system depends on irq. Since we use polling, we don't set
up irq.
>
>> [...]
>>  #define I2C_HID_PWR_ON		0x00
>>  #define I2C_HID_PWR_SLEEP	0x01
>>
>> +/* polling mode */
>> +#define I2C_POLLING_DISABLED 0
>> +#define I2C_POLLING_GPIO_PIN 1
>
>This is a very small detail, but I personally think that these defines should be
>called I2C_HID_.... since they are only used here.
>
Thank you! This is absolutely a good suggestion.
>
>> +#define POLLING_INTERVAL 10
>> +
>> +static u8 polling_mode;
>> +module_param(polling_mode, byte, 0444);
>> +MODULE_PARM_DESC(polling_mode, "How to poll - 0 disabled; 1 based on GPIO pin's status");
>> +
>> +static unsigned int polling_interval_active_us = 4000;
>> +module_param(polling_interval_active_us, uint, 0644);
>> +MODULE_PARM_DESC(polling_interval_active_us,
>> +		 "Poll every {polling_interval_active_us} us when the touchpad is active. Default to 4000 us");
>> +
>> +static unsigned int polling_interval_idle_ms = 10;
>
>There is a define for this value, I don't really see why you don't use it here.
>And if there is a define for one value, I don't really see why there isn't one
>for the other. (As far as I see `POLLING_INTERVAL` is not even used anywhere.)
>
Thank you for spotting this leftover issue after introducing two
parameters to control the polling interval.

Another issue is "MODULE_PARM_DESC(polling_interval_ms" should be
"MODULE_PARM_DESC(polling_interval_idle_ms" although this won't cause
real problem.
>
>> +module_param(polling_interval_idle_ms, uint, 0644);
>> +MODULE_PARM_DESC(polling_interval_ms,
>> +		 "Poll every {polling_interval_idle_ms} ms when the touchpad is idle. Default to 10 ms");
>>  /* debug option */
>>  static bool debug;
>>  module_param(debug, bool, 0444);
>> @@ -158,6 +178,8 @@ struct i2c_hid {
>>
>>  	struct i2c_hid_platform_data pdata;
>>
>> +	struct task_struct *polling_thread;
>> +
>>  	bool			irq_wake_enabled;
>>  	struct mutex		reset_lock;
>>  };
>> @@ -772,7 +794,9 @@ static int i2c_hid_start(struct hid_device *hid)
>>  		i2c_hid_free_buffers(ihid);
>>
>>  		ret = i2c_hid_alloc_buffers(ihid, bufsize);
>> -		enable_irq(client->irq);
>> +
>> +		if (polling_mode == I2C_POLLING_DISABLED)
>> +			enable_irq(client->irq);
>>
>>  		if (ret)
>>  			return ret;
>> @@ -814,6 +838,86 @@ struct hid_ll_driver i2c_hid_ll_driver = {
>>  };
>>  EXPORT_SYMBOL_GPL(i2c_hid_ll_driver);
>>
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
>> +	struct irq_desc *irq_desc = irq_to_desc(client->irq);
>> +
>> +	/*
>> +	 * According to Windows Precsiontion Touchpad's specs
>> +	 * https://docs.microsoft.com/en-us/windows-hardware/design/component-guidelines/windows-precision-touchpad-device-bus-connectivity,
>> +	 * GPIO Interrupt Assertion Leve could be either ActiveLow or
>> +	 * ActiveHigh.
>> +	 */
>> +	if (trigger_type & IRQF_TRIGGER_LOW)
>> +		return !get_gpio_pin_state(irq_desc);
>> +
>> +	return get_gpio_pin_state(irq_desc);
>> +}
>
>Excuse my ignorance, but I think some kind of error handling regarding the return
>value of `get_gpio_pin_state()` should be present here.
>
What kind of errors would you expect? It seems (struct gpio_chip *)->get
only return 0 or 1.
>
>> +
>> +static int i2c_hid_polling_thread(void *i2c_hid)
>> +{
>> +	struct i2c_hid *ihid = i2c_hid;
>> +	struct i2c_client *client = ihid->client;
>> +	unsigned int polling_interval_idle;
>> +
>> +	while (1) {
>> +		/*
>> +		 * re-calculate polling_interval_idle
>> +		 * so the module parameters polling_interval_idle_ms can be
>> +		 * changed dynamically through sysfs as polling_interval_active_us
>> +		 */
>> +		polling_interval_idle = polling_interval_idle_ms * 1000;
>> +		if (test_bit(I2C_HID_READ_PENDING, &ihid->flags))
>> +			usleep_range(50000, 100000);
>> +
>> +		if (kthread_should_stop())
>> +			break;
>> +
>> +		while (interrupt_line_active(client)) {
>
>I realize it's quite unlikely, but can't this be a endless loop if data is coming
>in at a high enough rate? Maybe the maximum number of iterations could be limited here?
>
If we find HID reports are constantly read and send to front-end
application like libinput, won't it help expose the problem of the I2C
HiD device?
>
>> +			i2c_hid_get_input(ihid);
>> +			usleep_range(polling_interval_active_us,
>> +				     polling_interval_active_us + 100);
>> +		}
>> +
>> +		usleep_range(polling_interval_idle,
>> +			     polling_interval_idle + 1000);
>> +	}
>> +
>> +	do_exit(0);
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
>> +		return -1;
>> +	}
>> +
>> +	ihid->polling_thread = kthread_create(i2c_hid_polling_thread, ihid,
>> +					      "I2C HID polling thread");
>> +
>> +	if (ihid->polling_thread) {
>
>`kthread_create()` returns an errno in a pointer, so this check is incorrect. It should be
>
> if (!IS_ERR(ihid->polling_thread))
>
Thank you for correcting my mistake!

>I think it's a bit inconsistent that in this function you do:
>
> if (err)
>   bail
>
> if (!err)
>   return ok
>
> return err
>
I'm not sure if I get you, but current pattern is

if (err)
   return err;

if (!err)
   return ok

return err

>moreover, I think the errno should be propagated, so use
>
> return PTR_ERR(ihid->polling_thread);
>
>for example, when bailing out.
>

This a good advice! Thank you
>
>> +		pr_info("I2C HID polling thread");
>> +		wake_up_process(ihid->polling_thread);
>> +		return 0;
>> +	}
>> +
>> +	return -1;
>> +}
>> +
>> [...]
>>  #ifdef CONFIG_PM_SLEEP
>> @@ -1183,15 +1300,16 @@ static int i2c_hid_suspend(struct device *dev)
>>  	/* Save some power */
>>  	i2c_hid_set_power(client, I2C_HID_PWR_SLEEP);
>>
>> -	disable_irq(client->irq);
>> -
>> -	if (device_may_wakeup(&client->dev)) {
>> -		wake_status = enable_irq_wake(client->irq);
>> -		if (!wake_status)
>> -			ihid->irq_wake_enabled = true;
>> -		else
>> -			hid_warn(hid, "Failed to enable irq wake: %d\n",
>> -				wake_status);
>> +	if (polling_mode == I2C_POLLING_DISABLED) {
>> +		disable_irq(client->irq);
>> +		if (device_may_wakeup(&client->dev)) {
>> +			wake_status = enable_irq_wake(client->irq);
>> +			if (!wake_status)
>> +				ihid->irq_wake_enabled = true;
>> +			else
>> +				hid_warn(hid, "Failed to enable irq wake: %d\n",
>> +					 wake_status);
>> +		}
>>  	} else {
>>  		regulator_bulk_disable(ARRAY_SIZE(ihid->pdata.supplies),
>>  				       ihid->pdata.supplies);
>> @@ -1208,7 +1326,7 @@ static int i2c_hid_resume(struct device *dev)
>>  	struct hid_device *hid = ihid->hid;
>>  	int wake_status;
>>
>> -	if (!device_may_wakeup(&client->dev)) {
>> +	if (!device_may_wakeup(&client->dev) || polling_mode != I2C_POLLING_DISABLED) {
>>  		ret = regulator_bulk_enable(ARRAY_SIZE(ihid->pdata.supplies),
>>  					    ihid->pdata.supplies);
>>  		if (ret)
>> @@ -1225,7 +1343,8 @@ static int i2c_hid_resume(struct device *dev)
>>  				wake_status);
>>  	}
>>
>> -	enable_irq(client->irq);
>> +	if (polling_mode == I2C_POLLING_DISABLED)
>> +		enable_irq(client->irq);
>> [...]
>
>Before this patch, if a device cannot wake up, then the regulators are disabled
>when suspending, after this patch, regulators are only disabled if polling is
>used. But they are enabled if the device cannot wake up *or* polling is used.
>
Thank for analyzing what's wrong for me!

>Excuse my ignorance, but I do not understand why the following two changes are not enough:
>
>in `i2c_hid_suspend()`:
> if (polling_mode == I2C_POLLING_DISABLED)
>   disable_irq(client->irq);
>
>in `i2c_hid_resume()`:
> if (polling_mode == I2C_POLLING_DISABLED)
>   enable_irq(client->irq);
>
I think we shouldn't call enable/disable_irq_wake in polling mode
where we don't set up irq.
>
>Regards,
>Barnabás Pőcze

--
Best regards,
Coiby
