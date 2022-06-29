Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4404560D14
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 01:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiF2XSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 19:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiF2XSk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 19:18:40 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A622D220CC
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 16:18:37 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 73-20020a17090a0fcf00b001eaee69f600so985383pjz.1
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 16:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WCZ9XmbAa/JAaxeY8vzw1f1J/PDv98SAx+RwG4qaGQk=;
        b=C1KyJQUYnz02b4RXDHNAvvaFDVfmkjh0FZyapJ//Hk32EKNpWSoI4dsCbp7qtx/HjF
         fGtYM34+ke+USyOn/O4kr7ePGw/Glq/xc89kSuVYmAq63cNR3Vn4PXOKbwUAvn4JONuI
         ANuXFQp1YAvtghzJEQO/Dawt3234kthqcqYGcDAETkcjDUlo5sEIgqK5D7JG8Qpb7ITq
         wX28a0JIk34aRJnrulRoqMNR4ASTf4mdFG4Vm7PO/SV8+IZwHCnvMc9lMEEXjJuiFMeA
         YEmDFNaPZpAoLmLagn16yb8qoR0rseYVni/T4dNThyT0l4vdf+51+B9pC1PpXBwVmiG7
         vy/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WCZ9XmbAa/JAaxeY8vzw1f1J/PDv98SAx+RwG4qaGQk=;
        b=vnK46dOBa7mWnggG5Tlcikg22qrAHrp6SnpU3o7bdHOQPtvyZJEIJ2mVqyvOJz7v8L
         JAf9vTXaP7w+FZRe+y31f4Zz5Ucs/ZktpluzUa7fNozkc2c5VEgBJtHsu/OZpIcv+AyQ
         avaCfynscSZRSAxb4ZD8m7B0svli9SJNlSY0E6nh1iq8WVx+Di8c11f+XuJuxzxdUyqv
         C8iFXQl8hw/t2lirwBB1FXslBdc5jEUdaKq8a0rLelnb0lGh7llwelrPM1UDpFHUuNZ4
         s8Rj+5Duoe2z9/8EBj4sC9seKu9zXuKwjz2PgKw0ooWClifUPB1mQ4XjEbO5YZRAO/9t
         hz4g==
X-Gm-Message-State: AJIora8nGIXRy+z4Z+ZDT4xlT0RCFFQETGZOFp5uG5h8ZAlcoRJ34n7h
        JuXAxdgsGNi1HG16Us7UKKyc6w==
X-Google-Smtp-Source: AGRyM1sSEsY/MmnYvfXLmBXPUMl+8nOa0/dAqS9qoVWFguDNOEdCu3wU0KNwoxXIKifvIu3ekKqGIg==
X-Received: by 2002:a17:90a:5509:b0:1ec:caf4:b327 with SMTP id b9-20020a17090a550900b001eccaf4b327mr8333381pji.129.1656544717040;
        Wed, 29 Jun 2022 16:18:37 -0700 (PDT)
Received: from google.com (249.189.233.35.bc.googleusercontent.com. [35.233.189.249])
        by smtp.gmail.com with ESMTPSA id p26-20020a634f5a000000b0040dfb0857a0sm6688974pgl.78.2022.06.29.16.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 16:18:36 -0700 (PDT)
Date:   Wed, 29 Jun 2022 23:18:33 +0000
From:   William McVicker <willmcvicker@google.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        kernel-team@android.com, linux-hwmon@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J . Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 4.19 v1 1/2] hwmon: Introduce
 hwmon_device_register_for_thermal
Message-ID: <YrzdyUm/xlJPldwP@google.com>
References: <20220629225843.332453-1-willmcvicker@google.com>
 <20220629225843.332453-2-willmcvicker@google.com>
 <d4a85598-af50-541a-9632-8d0343e8082d@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4a85598-af50-541a-9632-8d0343e8082d@roeck-us.net>
X-Spam-Status: No, score=-15.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/29/2022, Guenter Roeck wrote:
> On 6/29/22 15:58, Will McVicker wrote:
> > From: Guenter Roeck <linux@roeck-us.net>
> > 
> > [ upstream commit e5d21072054fbadf41cd56062a3a14e447e8c22b ]
> > 
> > The thermal subsystem registers a hwmon driver without providing
> > chip or sysfs group information. This is for legacy reasons and
> > would be difficult to change. At the same time, we want to enforce
> > that chip information is provided when registering a hwmon device
> > using hwmon_device_register_with_info(). To enable this, introduce
> > a special API for use only by the thermal subsystem.
> > 
> > Acked-by: Rafael J . Wysocki <rafael@kernel.org>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> 
> NACK. The patch introducing the problem needs to be reverted.

I'm fine with that as well. I've already verified that fixes the issue. I'll go
ahead and send the revert.

Thanks,
Will

> 
> Guenter
> 
> > ---
> >   drivers/hwmon/hwmon.c | 25 +++++++++++++++++++++++++
> >   include/linux/hwmon.h |  3 +++
> >   2 files changed, 28 insertions(+)
> > 
> > diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
> > index c4051a3e63c2..412a5e39fc14 100644
> > --- a/drivers/hwmon/hwmon.c
> > +++ b/drivers/hwmon/hwmon.c
> > @@ -725,6 +725,31 @@ hwmon_device_register_with_info(struct device *dev, const char *name,
> >   }
> >   EXPORT_SYMBOL_GPL(hwmon_device_register_with_info);
> > +/**
> > + * hwmon_device_register_for_thermal - register hwmon device for thermal subsystem
> > + * @dev: the parent device
> > + * @name: hwmon name attribute
> > + * @drvdata: driver data to attach to created device
> > + *
> > + * The use of this function is restricted. It is provided for legacy reasons
> > + * and must only be called from the thermal subsystem.
> > + *
> > + * hwmon_device_unregister() must be called when the device is no
> > + * longer needed.
> > + *
> > + * Returns the pointer to the new device.
> > + */
> > +struct device *
> > +hwmon_device_register_for_thermal(struct device *dev, const char *name,
> > +				  void *drvdata)
> > +{
> > +	if (!name || !dev)
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	return __hwmon_device_register(dev, name, drvdata, NULL, NULL);
> > +}
> > +EXPORT_SYMBOL_GPL(hwmon_device_register_for_thermal);
> > +
> >   /**
> >    * hwmon_device_register - register w/ hwmon
> >    * @dev: the device to register
> > diff --git a/include/linux/hwmon.h b/include/linux/hwmon.h
> > index 8fde789f2eff..5ff3db6eb9f1 100644
> > --- a/include/linux/hwmon.h
> > +++ b/include/linux/hwmon.h
> > @@ -390,6 +390,9 @@ hwmon_device_register_with_info(struct device *dev,
> >   				const struct hwmon_chip_info *info,
> >   				const struct attribute_group **extra_groups);
> >   struct device *
> > +hwmon_device_register_for_thermal(struct device *dev, const char *name,
> > +				  void *drvdata);
> > +struct device *
> >   devm_hwmon_device_register_with_info(struct device *dev,
> >   				const char *name, void *drvdata,
> >   				const struct hwmon_chip_info *info,
> 
