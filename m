Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423A12920BF
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 02:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730119AbgJSAzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 20:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbgJSAzO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Oct 2020 20:55:14 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E2EC061755;
        Sun, 18 Oct 2020 17:55:13 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id w21so4992582pfc.7;
        Sun, 18 Oct 2020 17:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=JHG5gkaTCfmlQwgu3xnC1XiFHki9A3JmHZQkuRih3Ao=;
        b=ia1lb/riOd8HGHXvq3sX55y8nybmkwuSdL1i6HJjvuipZJC7fPQAVWbE2gWXH3cC/0
         n5F5eG80N2ppcrKZcaQMY+uXlUVqtZ7my6jYKiPUSGciNJ+GJZHXDwigbG7197C60IJP
         FMWfXPf8KkGJ08RQIJ8ck7QLdkmhHqPVKgbiyl2YLIEYyF0BmTVH27wJJeOhcXkICKiO
         ZBH0QfTEhnar67ZRwPVDf0NWmCfTccQ2mIFoBOfR9kr4/Oq6T7pfWRljS8kZ8dw6gZg+
         L0742g9phJq3UJjRD2zXAvnLusnWHUdQzFarbzZMNcTFNCPd5ItLILzIIAk4ooE2o0IT
         fiIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=JHG5gkaTCfmlQwgu3xnC1XiFHki9A3JmHZQkuRih3Ao=;
        b=sxZkWuKVyg1gWiq9a2PEn4QwtQ967GVSvg/UPCVjeOAiDZsmedFOwkHTB+QIXfQN4/
         feSSjSnQgj9qDAbXdmMBfjBJmNcblHnVikAlO++BeDFFvdVDjRgnOw8RhSyVxF9MQsuC
         4QmRgOXiiwX7kU7W8VC0IczjKHrpC9iiE3WV8wnXJI62CvwqCt3/srEPoTDf6JX/h548
         aPt6CylHG7hLyPR3Mu/SkIJBy9Qjrys/Gp+obRYKxeCion9kuC5NT34NBGp5hKC14R8u
         l2tNO9OemGFhOCjeif+ub96ji5oymX5VAxLILGhg4dPLmmh9QhsLDjpvTJ0rrDYzFEcZ
         jhvQ==
X-Gm-Message-State: AOAM532o55hBBgiq+y4G7wHfkZD1U5qGco7teAnoLKF2QUsndTC/b7Dj
        cyGGwFXZi6Jp9FNPudnmWJs=
X-Google-Smtp-Source: ABdhPJxctJEGi2HcUpdXJUQiwyFl6eE6rypnrHkdUrkQC8aeqGlKmizLevMbjCYScLEsXjC7beAvNg==
X-Received: by 2002:a63:ff5b:: with SMTP id s27mr12342594pgk.383.1603068912816;
        Sun, 18 Oct 2020 17:55:12 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id l199sm9905982pfd.73.2020.10.18.17.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 17:55:12 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Mon, 19 Oct 2020 08:54:12 +0800
To:     =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Cc:     "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Helmut Stult <helmut.stult@schinfo.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] HID: i2c-hid: add polling mode based on connected
 GPIO chip's pin status
Message-ID: <20201019005412.rifxrvpdxu574jag@Rk>
References: <20201016131335.8121-1-coiby.xu@gmail.com>
 <T2SIcFVxZ81NUwKLDbSESA7Wpm7DYowEiii8ZaxTPtrdXZZeHLq5iZPkN5BLlp-9C6PLwUZOVwNpMdEdPSRZcAG4MmDt-tfyKZoQYJ0KHOA=@protonmail.com>
 <20201017004556.kuoxzmbvef4yr3kg@Rk>
 <FWsXxqGztJgszUpmNtKli8eOyeKP-lxFeTsjs2nQAxgYZBkT3JNTU3VdHF4GbQVS_PvKiqbfrZXI7vaUHA_lXTxjPX-WjkNEOdiMUetO8IQ=@protonmail.com>
 <20201017140541.fggujaz2klpv3cd5@Rk>
 <fRxQJHWq9ZL950ZPGFFm_LfSlMjsjrpG7Y63gd7V7iV647KR8WIfZ4-ljLeo0n4X3Gpu1KIEsMVLxQnzAtJdUdMydi_b0-vjIVb304Da1bQ=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fRxQJHWq9ZL950ZPGFFm_LfSlMjsjrpG7Y63gd7V7iV647KR8WIfZ4-ljLeo0n4X3Gpu1KIEsMVLxQnzAtJdUdMydi_b0-vjIVb304Da1bQ=@protonmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 17, 2020 at 02:58:13PM +0000, Barnabás Pőcze wrote:
>> [...]
>> >> >> +static int get_gpio_pin_state(struct irq_desc *irq_desc)
>> >> >> +{
>> >> >> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(&irq_desc->irq_data);
>> >> >> +
>> >> >> +	return gc->get(gc, irq_desc->irq_data.hwirq);
>> >> >> +}
>> >> >> +
>> >> >> +static bool interrupt_line_active(struct i2c_client *client)
>> >> >> +{
>> >> >> +	unsigned long trigger_type = irq_get_trigger_type(client->irq);
>> >> >> +	struct irq_desc *irq_desc = irq_to_desc(client->irq);
>> >> >> +
>> >> >> +	/*
>> >> >> +	 * According to Windows Precsiontion Touchpad's specs
>> >> >> +	 * https://docs.microsoft.com/en-us/windows-hardware/design/component-guidelines/windows-precision-touchpad-device-bus-connectivity,
>> >> >> +	 * GPIO Interrupt Assertion Leve could be either ActiveLow or
>> >> >> +	 * ActiveHigh.
>> >> >> +	 */
>> >> >> +	if (trigger_type & IRQF_TRIGGER_LOW)
>> >> >> +		return !get_gpio_pin_state(irq_desc);
>> >> >> +
>> >> >> +	return get_gpio_pin_state(irq_desc);
>> >> >> +}
>> >> >
>> >> >Excuse my ignorance, but I think some kind of error handling regarding the return
>> >> >value of `get_gpio_pin_state()` should be present here.
>> >> >
>> >> What kind of errors would you expect? It seems (struct gpio_chip *)->get
>> >> only return 0 or 1.
>> >> >
>> >
>> >I read the code of a couple gpio chips and - I may be wrong, but - it seems they
>> >can return an arbitrary errno.
>> >
>> I thought all GPIO chip return 0 or 1 since !!val is returned. I find
>> an example which could return negative value,
>>
>
>Yes, when a function returns `int`, there is a very high chance that the return
>value may be an errno.
>
>
>> >
>> >> >> +
>> >> >> +static int i2c_hid_polling_thread(void *i2c_hid)
>> >> >> +{
>> >> >> +	struct i2c_hid *ihid = i2c_hid;
>> >> >> +	struct i2c_client *client = ihid->client;
>> >> >> +	unsigned int polling_interval_idle;
>> >> >> +
>> >> >> +	while (1) {
>> >> >> +		/*
>> >> >> +		 * re-calculate polling_interval_idle
>> >> >> +		 * so the module parameters polling_interval_idle_ms can be
>> >> >> +		 * changed dynamically through sysfs as polling_interval_active_us
>> >> >> +		 */
>> >> >> +		polling_interval_idle = polling_interval_idle_ms * 1000;
>> >> >> +		if (test_bit(I2C_HID_READ_PENDING, &ihid->flags))
>> >> >> +			usleep_range(50000, 100000);
>> >> >> +
>> >> >> +		if (kthread_should_stop())
>> >> >> +			break;
>> >> >> +
>> >> >> +		while (interrupt_line_active(client)) {
>> >> >
>> >> >I realize it's quite unlikely, but can't this be a endless loop if data is coming
>> >> >in at a high enough rate? Maybe the maximum number of iterations could be limited here?
>> >> >
>> >> If we find HID reports are constantly read and send to front-end
>> >> application like libinput, won't it help expose the problem of the I2C
>> >> HiD device?
>> >> >
>> >
>> >I'm not sure I completely understand your point. The reason why I wrote what I wrote
>> >is that this kthread could potentially could go on forever (since `kthread_should_stop()`
>> >is not checked in the inner while loop) if the data is supplied at a high enough rate.
>> >That's why I said, to avoid this problem, only allow a certain number of iterations
>> >for the inner loop, to guarantee that the kthread can stop in any case.
>> >
>> I mean if "data is supplied at a high enough rate" does happen, this is
>> an abnormal case and indicates a bug. So we shouldn't cover it up. We
>> expect the user to report it to us.
>> >
>
>I agree in principle, but if this abnormal case ever occurs, that'll prevent
>this module from being unloaded since `kthread_stop()` will hang because the
>thread is "stuck" in the inner loop, never checking `kthread_should_stop()`.
>That's why I think it makes sense to only allow a certain number of operations
>for the inner loop, and maybe show a warning if that's exceeded:
>
> for (i = 0; i < max_iter && interrupt_line_active(...); i++) {
>    ....
> }
>
> WARN_ON[CE](i == max_iter[, "data is coming in at an unreasonably high rate"]);
>
>or something like this, where `max_iter` could possibly be some value dependent on
>`polling_interval_active_us`, or even just a constant.
>

Thank you for suggesting this approach! It seems it would add a bit of
complexity to detect this situation which could introduce other bugs.

I did a experiment of creating a kthread that will loop forever and found
the rebooting process wasn't stalled. I don't expect user to load&unload
this module. So the end user could not notice this problem so  my rationale
is invalid.

Thus I would be prefer to check `kthread_should_stop()` in the inner
while loop instead.
>
>> >> >> +			i2c_hid_get_input(ihid);
>> >> >> +			usleep_range(polling_interval_active_us,
>> >> >> +				     polling_interval_active_us + 100);
>> >> >> +		}
>> >> >> +
>> >> >> +		usleep_range(polling_interval_idle,
>> >> >> +			     polling_interval_idle + 1000);
>> >> >> +	}
>> >> >> +
>> >> >> +	do_exit(0);
>> >> >> +	return 0;
>> >> >> +}
>> [...]
>> Thank you for offering your understandings on this patch. When I'm going
>> to submit next version, I will add a "Signed-off-by" tag with your name
>> and email, does it look good to you?
>> [...]
>
>I'm not sure if that follows proper procedures.
>
> "The sign-off is a simple line at the end of the explanation for the patch, which
>  certifies that you wrote it or otherwise have the right to pass it on as an
>  open-source patch."[1]
>
>I'm not the author, nor co-author, nor am I going to pass this patch on, so I don't
>think that's appropriate.
>
>Furthermore, please note that
>
> "[...] you may optionally add a Cc: tag to the patch. **This is the only tag which
>  might be added without an explicit action by the person it names** - but it should
>  indicate that this person was copied on the patch."[2]
>  (emphasis mine)
>
You have been directly contributing to this patch because several
improvements of next version are from you. I experienced a similar
situation when submitting patches for QEMU. The only difference is
that the feedbacks on the QEMU patches were also given in the format
of patch. Or do you think a reviewed-by tag from you after you think
the next version is of production quality is a better way to credit
you?
>
>Regards,
>Barnabás Pőcze
>
>
>[1]: https://www.kernel.org/doc/html/latest/process/submitting-patches.html#sign-your-work-the-developer-s-certificate-of-origin
>[2]: https://www.kernel.org/doc/html/latest/process/submitting-patches.html#when-to-use-acked-by-cc-and-co-developed-by

--
Best regards,
Coiby
