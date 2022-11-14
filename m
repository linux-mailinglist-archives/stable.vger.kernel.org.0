Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B028627B0F
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 11:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235468AbiKNKvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 05:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236005AbiKNKvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 05:51:39 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B52FACD
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 02:51:37 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id p141so7827268iod.6
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 02:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LTektZpt/h6MwJ9d9wM9hL9FrK6wC7Nsfy9XbJFEifk=;
        b=WZY4hCSmDJ/MGHyCfrebqgsyq2x0L9hbbN59dxGL+0ZK58P5rWRzxXHGU0AK+N0kfg
         GSMRdZN4+SIBNBtXKIBItSmAPuizHK8Pc8VjHJlkNKl3Je/1t6Xgv6jSJMfqm6H7/nfi
         LvyH1KbpThJoJzTjDMN17FGG9vk8jb2NJRZH8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LTektZpt/h6MwJ9d9wM9hL9FrK6wC7Nsfy9XbJFEifk=;
        b=lY5rrvMRnjRgEvNP+jyleP2hf3txif5KwlUKtz1ApaTmRyJPFrSQQW6UeF4V0IzrwM
         YkzdG6yVBKT6YE8MtSGPgX1Qg3mYZXcCGRM1ptEkFFLWIP1XCs/6a3ZXoC38I7n6NdtF
         SF6DempO1rZuhH6dyaIhOptWXBY218+OBHl52UmOkXiPtrgsC41b1Q/7R6pGetCyi7v8
         vfx58ybcNCyxdO1EssKYKIogjTyVxBvHKGWsLoOa3GDU6Ro+rf1CZotsvPjZtd2kkm4h
         F9Hi/adJR/teMxDkVJq/p6m7nIz9mKyIwtYDRRSHvA33pdE8pazEen4D5d4438hLUc7D
         JCsQ==
X-Gm-Message-State: ANoB5pluxJZrCDvmSsbLPH0eHzDGHmcpu0tZEEd0TkJ8Zm57uEWsTvi4
        oeg8xLdUClM1BBpx2X1ZA1Qr5o1+J2hG/Q==
X-Google-Smtp-Source: AA0mqf7fCJ1Vl+IugGqLftCCHSpEFKFoaWryvNNmGgziX8WXhmy4rAlI6Ge5GbZawJC1/+3Xnv4Znw==
X-Received: by 2002:a02:c054:0:b0:363:ab01:e25f with SMTP id u20-20020a02c054000000b00363ab01e25fmr5318287jam.167.1668423097068;
        Mon, 14 Nov 2022 02:51:37 -0800 (PST)
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com. [209.85.166.48])
        by smtp.gmail.com with ESMTPSA id z6-20020a056638214600b003640f27d82esm3494758jaj.21.2022.11.14.02.51.35
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 02:51:36 -0800 (PST)
Received: by mail-io1-f48.google.com with SMTP id h206so7821034iof.10
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 02:51:35 -0800 (PST)
X-Received: by 2002:a05:6638:30b:b0:375:7eda:8c7e with SMTP id
 w11-20020a056638030b00b003757eda8c7emr5582885jap.27.1668423095130; Mon, 14
 Nov 2022 02:51:35 -0800 (PST)
MIME-Version: 1.0
References: <20221109-i2c-waive-v5-0-2839667f8f6a@chromium.org>
 <20221109-i2c-waive-v5-1-2839667f8f6a@chromium.org> <Y3AA7hZFvoI9+2fF@shikoro>
 <Y3IZdrwwfiolSjB4@black.fi.intel.com>
In-Reply-To: <Y3IZdrwwfiolSjB4@black.fi.intel.com>
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Mon, 14 Nov 2022 11:51:24 +0100
X-Gmail-Original-Message-ID: <CANiDSCvmcZ32PBZbrLWfZXvEjSPdxYJcWn6V00wR+W2stThBdg@mail.gmail.com>
Message-ID: <CANiDSCvmcZ32PBZbrLWfZXvEjSPdxYJcWn6V00wR+W2stThBdg@mail.gmail.com>
Subject: Re: [PATCH v5 1/1] i2c: Restore initial power state when we are done.
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     Wolfram Sang <wsa@kernel.org>, Tomasz Figa <tfiga@chromium.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Hidenori Kobayashi <hidenorik@google.com>,
        stable@vger.kernel.org, linux-i2c@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mika

Thanks for your review!

On Mon, 14 Nov 2022 at 11:33, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
>
> Hi,
>
> On Sat, Nov 12, 2022 at 09:24:14PM +0100, Wolfram Sang wrote:
> > On Thu, Nov 10, 2022 at 05:20:39PM +0100, Ricardo Ribalda wrote:
> > > A driver that supports I2C_DRV_ACPI_WAIVE_D0_PROBE is not expected to
> > > power off a device that it has not powered on previously.
> > >
> > > For devices operating in "full_power" mode, the first call to
> > > `i2c_acpi_waive_d0_probe` will return 0, which means that the device
> > > will be turned on with `dev_pm_domain_attach`.
> > >
> > > If probe fails or the device is removed the second call to
> > > `i2c_acpi_waive_d0_probe` will return 1, which means that the device
> > > will not be turned off. This is, it will be left in a different power
> > > state. Lets fix it.
> > >
> > > Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > Cc: stable@vger.kernel.org
> > > Fixes: b18c1ad685d9 ("i2c: Allow an ACPI driver to manage the device's power state during probe")
> > > Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> >
> > Adding I2C ACPI maintainer to CC. Mika, could you please help
> > reviewing?
>
> Sure.
>
> > > diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
> > > index b4edf10e8fd0..6f4974c76404 100644
> > > --- a/drivers/i2c/i2c-core-base.c
> > > +++ b/drivers/i2c/i2c-core-base.c
> > > @@ -467,6 +467,7 @@ static int i2c_device_probe(struct device *dev)
> > >  {
> > >     struct i2c_client       *client = i2c_verify_client(dev);
> > >     struct i2c_driver       *driver;
> > > +   bool do_power_on;
> > >     int status;
> > >
> > >     if (!client)
> > > @@ -545,8 +546,8 @@ static int i2c_device_probe(struct device *dev)
> > >     if (status < 0)
> > >             goto err_clear_wakeup_irq;
> > >
> > > -   status = dev_pm_domain_attach(&client->dev,
> > > -                                 !i2c_acpi_waive_d0_probe(dev));
> > > +   do_power_on = !i2c_acpi_waive_d0_probe(dev);
> > > +   status = dev_pm_domain_attach(&client->dev, do_power_on);
>
> I think this is fine as the driver says it is OK to see the device in
> whatever power state (I assume this is what the
> i2c_acpi_waive_d0_probe() is supposed to be doing but there is no
> kernel-doc, though).
>
> > >     if (status)
> > >             goto err_clear_wakeup_irq;
> > >
> > > @@ -580,12 +581,14 @@ static int i2c_device_probe(struct device *dev)
> > >     if (status)
> > >             goto err_release_driver_resources;
> > >
> > > +   client->power_off_on_remove = do_power_on;
> > > +
> > >     return 0;
> > >
> > >  err_release_driver_resources:
> > >     devres_release_group(&client->dev, client->devres_group_id);
> > >  err_detach_pm_domain:
> > > -   dev_pm_domain_detach(&client->dev, !i2c_acpi_waive_d0_probe(dev));
> > > +   dev_pm_domain_detach(&client->dev, do_power_on);
> > >  err_clear_wakeup_irq:
> > >     dev_pm_clear_wake_irq(&client->dev);
> > >     device_init_wakeup(&client->dev, false);
> > > @@ -610,7 +613,7 @@ static void i2c_device_remove(struct device *dev)
> > >
> > >     devres_release_group(&client->dev, client->devres_group_id);
> > >
> > > -   dev_pm_domain_detach(&client->dev, !i2c_acpi_waive_d0_probe(dev));
> > > +   dev_pm_domain_detach(&client->dev, client->power_off_on_remove);
>
> However, on the remove path I think we should not call
> i2c_acpi_waive_d0_probe() at all as that has nothing to do with remove
> (it is for whether the driver accepts any power state on probe AFAICT)
> so this should stil be "true" here. Unless I'm missing something.

I guess the problem is that we would be undoing something (power-off),
that we did not do.


Sakari, can you think of a use-case where this can break something? If
not I can send a v6.

Regards!

>
> > >
> > >     dev_pm_clear_wake_irq(&client->dev);
> > >     device_init_wakeup(&client->dev, false);
> > > diff --git a/include/linux/i2c.h b/include/linux/i2c.h
> > > index f7c49bbdb8a1..eba83bc5459e 100644
> > > --- a/include/linux/i2c.h
> > > +++ b/include/linux/i2c.h
> > > @@ -326,6 +326,8 @@ struct i2c_driver {
> > >   * calls it to pass on slave events to the slave driver.
> > >   * @devres_group_id: id of the devres group that will be created for resources
> > >   * acquired when probing this device.
> > > + * @power_off_on_remove: Record if we have turned on the device before probing
> > > + * so we can turn off the device at removal.
> > >   *
> > >   * An i2c_client identifies a single device (i.e. chip) connected to an
> > >   * i2c bus. The behaviour exposed to Linux is defined by the driver
> > > @@ -355,6 +357,8 @@ struct i2c_client {
> > >     i2c_slave_cb_t slave_cb;        /* callback for slave mode      */
> > >  #endif
> > >     void *devres_group_id;          /* ID of probe devres group     */
> > > +   bool power_off_on_remove;       /* if device needs to be turned */
> > > +                                   /* off by framework at removal  */
> > >  };
> > >  #define to_i2c_client(d) container_of(d, struct i2c_client, dev)
> > >
> > >
> > > --
> > > b4 0.11.0-dev-d93f8
>
>


-- 
Ricardo Ribalda
