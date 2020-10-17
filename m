Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F722291229
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 16:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438229AbgJQOGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 10:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438227AbgJQOGg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 10:06:36 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C753AC061755;
        Sat, 17 Oct 2020 07:06:35 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id o9so2714176plx.10;
        Sat, 17 Oct 2020 07:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=QxCFWYbj1NhZqQc4h9ExLWXO4yGB5U4hjLtwgymRmUk=;
        b=ZjmHvDgt6FmTreyueP61zYXWSlppEX8mGLtUrcGhB8hYErnE37dvXNHjuj+/hJYnYk
         aFbdOW+t0TFGPHgJq9qKmK9inVUErE7QwQIt5d3KJsEl7OVh0evanexc05b1uQba80lq
         wF40c3Ta1GinQ6zW+PznOW1bdRxjZEfEO+bM9zDvmUH9+DAEWji2YN2suIq661XD60AZ
         frkIyhsYD2c+jKKAAQriwZFefnpnFutSDMShmuOzKSRERPhTZ6ZzmhBfw1Nyt/dH+5Je
         6AsGAv0R3LiiVkAh/5RDAQ/QwX92plxJ1ePCILbsInrzw6z74p/J2pNXeLxJ/NOdeCuF
         I8FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=QxCFWYbj1NhZqQc4h9ExLWXO4yGB5U4hjLtwgymRmUk=;
        b=IJd2kh7zElZTm3xK7/ONskgUTD5TqjofZ9i/mwY00x0I+k13YKvB6e0bjp9Pvzxkbi
         fKeyaGEZuVHJj9vASf/xfWMFsGQCQAm+WsrxYLSZtMgioQMAjyRFeqKowxmjHpoT76xj
         kQiN+zo9kc7Yn4PcRIsLbiIFmPG1YYdjtTRICp3D+KLlWjWWegFsPd/7mQOwc2G1uFvh
         DKuGagzfBVXZghpj6tp+/hVpxs2lX2dzdl/eWjos5eKdLZVLd0S7tDP/8jmjGGNe0ABV
         Td17BaVBaFM9CPjWV5yxRVlYSPvkIRoKGkbLrTeW4cxWAgVbtMycuoukOCtn0G+f3RxO
         pL/w==
X-Gm-Message-State: AOAM532UTAlWwMefU2iKvCbXqq3fdk2xSKF2CR8HCxNHVVSdwBskHio7
        0nBCefd1n/UHg9iVNUVBr3c=
X-Google-Smtp-Source: ABdhPJxPXaybuirVsPTkEF81+YdnQS6anDik0rIbF9ZCC89dj3lF7Gq6Wulr8SzLVWksWq9BGB9z0A==
X-Received: by 2002:a17:90a:6288:: with SMTP id d8mr9577924pjj.210.1602943595246;
        Sat, 17 Oct 2020 07:06:35 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id e16sm6452669pfh.45.2020.10.17.07.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2020 07:06:34 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Sat, 17 Oct 2020 22:05:41 +0800
To:     =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Cc:     "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Helmut Stult <helmut.stult@schinfo.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] HID: i2c-hid: add polling mode based on connected
 GPIO chip's pin status
Message-ID: <20201017140541.fggujaz2klpv3cd5@Rk>
References: <20201016131335.8121-1-coiby.xu@gmail.com>
 <T2SIcFVxZ81NUwKLDbSESA7Wpm7DYowEiii8ZaxTPtrdXZZeHLq5iZPkN5BLlp-9C6PLwUZOVwNpMdEdPSRZcAG4MmDt-tfyKZoQYJ0KHOA=@protonmail.com>
 <20201017004556.kuoxzmbvef4yr3kg@Rk>
 <FWsXxqGztJgszUpmNtKli8eOyeKP-lxFeTsjs2nQAxgYZBkT3JNTU3VdHF4GbQVS_PvKiqbfrZXI7vaUHA_lXTxjPX-WjkNEOdiMUetO8IQ=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <FWsXxqGztJgszUpmNtKli8eOyeKP-lxFeTsjs2nQAxgYZBkT3JNTU3VdHF4GbQVS_PvKiqbfrZXI7vaUHA_lXTxjPX-WjkNEOdiMUetO8IQ=@protonmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Sat, Oct 17, 2020 at 01:06:14PM +0000, Barnabás Pőcze wrote:
>Hi
>
>> [...]
>> >> +static int get_gpio_pin_state(struct irq_desc *irq_desc)
>> >> +{
>> >> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(&irq_desc->irq_data);
>> >> +
>> >> +	return gc->get(gc, irq_desc->irq_data.hwirq);
>> >> +}
>> >> +
>> >> +static bool interrupt_line_active(struct i2c_client *client)
>> >> +{
>> >> +	unsigned long trigger_type = irq_get_trigger_type(client->irq);
>> >> +	struct irq_desc *irq_desc = irq_to_desc(client->irq);
>> >> +
>> >> +	/*
>> >> +	 * According to Windows Precsiontion Touchpad's specs
>> >> +	 * https://docs.microsoft.com/en-us/windows-hardware/design/component-guidelines/windows-precision-touchpad-device-bus-connectivity,
>> >> +	 * GPIO Interrupt Assertion Leve could be either ActiveLow or
>> >> +	 * ActiveHigh.
>> >> +	 */
>> >> +	if (trigger_type & IRQF_TRIGGER_LOW)
>> >> +		return !get_gpio_pin_state(irq_desc);
>> >> +
>> >> +	return get_gpio_pin_state(irq_desc);
>> >> +}
>> >
>> >Excuse my ignorance, but I think some kind of error handling regarding the return
>> >value of `get_gpio_pin_state()` should be present here.
>> >
>> What kind of errors would you expect? It seems (struct gpio_chip *)->get
>> only return 0 or 1.
>> >
>
>I read the code of a couple gpio chips and - I may be wrong, but - it seems they
>can return an arbitrary errno.
>
I thought all GPIO chip return 0 or 1 since !!val is returned. I find
an example which could return negative value,

// drivers/gpio/gpio-wm8994.c
static int wm8994_gpio_get(struct gpio_chip *chip, unsigned offset)
{
	struct wm8994_gpio *wm8994_gpio = gpiochip_get_data(chip);
	struct wm8994 *wm8994 = wm8994_gpio->wm8994;
	int ret;

	ret = wm8994_reg_read(wm8994, WM8994_GPIO_1 + offset);
	if (ret < 0)
		return ret;

	if (ret & WM8994_GPN_LVL)
		return 1;
	else
		return 0;
}
>
>> >> +
>> >> +static int i2c_hid_polling_thread(void *i2c_hid)
>> >> +{
>> >> +	struct i2c_hid *ihid = i2c_hid;
>> >> +	struct i2c_client *client = ihid->client;
>> >> +	unsigned int polling_interval_idle;
>> >> +
>> >> +	while (1) {
>> >> +		/*
>> >> +		 * re-calculate polling_interval_idle
>> >> +		 * so the module parameters polling_interval_idle_ms can be
>> >> +		 * changed dynamically through sysfs as polling_interval_active_us
>> >> +		 */
>> >> +		polling_interval_idle = polling_interval_idle_ms * 1000;
>> >> +		if (test_bit(I2C_HID_READ_PENDING, &ihid->flags))
>> >> +			usleep_range(50000, 100000);
>> >> +
>> >> +		if (kthread_should_stop())
>> >> +			break;
>> >> +
>> >> +		while (interrupt_line_active(client)) {
>> >
>> >I realize it's quite unlikely, but can't this be a endless loop if data is coming
>> >in at a high enough rate? Maybe the maximum number of iterations could be limited here?
>> >
>> If we find HID reports are constantly read and send to front-end
>> application like libinput, won't it help expose the problem of the I2C
>> HiD device?
>> >
>
>I'm not sure I completely understand your point. The reason why I wrote what I wrote
>is that this kthread could potentially could go on forever (since `kthread_should_stop()`
>is not checked in the inner while loop) if the data is supplied at a high enough rate.
>That's why I said, to avoid this problem, only allow a certain number of iterations
>for the inner loop, to guarantee that the kthread can stop in any case.
>
I mean if "data is supplied at a high enough rate" does happen, this is
an abnormal case and indicates a bug. So we shouldn't cover it up. We
expect the user to report it to us.
>
>> >> +			i2c_hid_get_input(ihid);
>> >> +			usleep_range(polling_interval_active_us,
>> >> +				     polling_interval_active_us + 100);
>> >> +		}
>> >> +
>> >> +		usleep_range(polling_interval_idle,
>> >> +			     polling_interval_idle + 1000);
>> >> +	}
>> >> +
>> >> +	do_exit(0);
>> >> +	return 0;
>> >> +}
>> [...]
>> >Excuse my ignorance, but I do not understand why the following two changes are not enough:
>> >
>> >in `i2c_hid_suspend()`:
>> > if (polling_mode == I2C_POLLING_DISABLED)
>> >   disable_irq(client->irq);
>> >
>> >in `i2c_hid_resume()`:
>> > if (polling_mode == I2C_POLLING_DISABLED)
>> >   enable_irq(client->irq);
>> >
>> I think we shouldn't call enable/disable_irq_wake in polling mode
>> where we don't set up irq.
>
>I think I now understand what you mean. I'm not sure, but it seems logical to me
>that you can enable/disable irq wake regardless whether any irq handlers are
>registered or not. Therefore, I figure it makes sense to take the safe path,
>and don't touch irq wake when polling, just as you did.
>

Thank you for offering your understandings on this patch. When I'm going
to submit next version, I will add a "Signed-off-by" tag with your name
and email, does it look good to you?
>
>> [...]
>
>
>Regards,
>Barnabás Pőcze

--
Best regards,
Coiby
