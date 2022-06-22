Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5DD1554E39
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 17:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358083AbiFVPCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 11:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357713AbiFVPCh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 11:02:37 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71833E5E4;
        Wed, 22 Jun 2022 08:02:36 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id y6so15653086plg.0;
        Wed, 22 Jun 2022 08:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6XKT2yRLpXAFgg00OhHQODIi4J+mvjZocFIkdkO2JKc=;
        b=fBKfmFPNTuYhfK/6HbBpNVZFguH0ROateoxvjVG+tS/Qm3lCxhEXaXZsqbBaxF2Bpr
         qEKFbkKb5rfp8FFiBRuFyC6kxGfWmrM/0fpgN+PHjq2QCFBBsBC1dYX/3YkZAtJcl03u
         TJhY+9VA8dKOJVYvzGeY/kUhbPBIesE6Z/VpkrNpqM46a6Ud1c9fI2W95lIqT+oj0iAq
         K+j1J0r3xQPMFnaj/hE/Kmwam3tsJzRNpy8SVxGKOk0E/6TbhWFtoyerDJsXKg6QGG0J
         578QEMIYYIN6O5oEYLq/7r/p+rA0HGhnyZaNCzARLrNiattau0xIcku98Ynzl6PML2z6
         uBZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=6XKT2yRLpXAFgg00OhHQODIi4J+mvjZocFIkdkO2JKc=;
        b=mN7a7rJYmTEYj19bXroUZ6Wkg037sE+Y29cEiEVAsL6RUcgHYG1nmay12FGnojVyIH
         AH2Gr+r+iYF2unUpXuhe2EOHPal1JyDekMy/rnyAOF11guLMvifdkzdrahkNBs6DSDvx
         OEBCEta3zoF1Me2RJtG2xbkGRUNr0p6zf7HXduNNSWS9Y0MB9RTjDiyxLtGMT+P6V/OM
         oehgGy2X0k/ycpS55/EIpC3nf4l5Kix1HdIdA6GTGDh1XtwSubZBGjwpugjz3Ex+Unxx
         CDnlzLfdTrs8/Enkathog3Qw8DjQqbHIZY1nLoqggnuIxV5/Sd/P2pC4VVngTvCI5r9A
         Fuqw==
X-Gm-Message-State: AJIora9IutTqWhWx2WKSkwiOFoKsO+pd8K9d8BxaQ5d2w28LCX7lFj9U
        EICMWslWLfrCnZ2T9XssEZj42SEfUR4=
X-Google-Smtp-Source: AGRyM1tzygIs8C7i9YEhquVpu9F4J7C9GpO+z5b89jgZWuV5RIAbX44m8sdcGQs/5aApMliYzqoJNw==
X-Received: by 2002:a17:902:6b42:b0:15d:3603:6873 with SMTP id g2-20020a1709026b4200b0015d36036873mr34450008plt.30.1655910156152;
        Wed, 22 Jun 2022 08:02:36 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g4-20020a17090a708400b001df4c5cab51sm12241103pjk.15.2022.06.22.08.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 08:02:34 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 22 Jun 2022 08:02:34 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Julian Haller <julian.haller@philips.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Rafael J . Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 5.4 1/2] hwmon: Introduce
 hwmon_device_register_for_thermal
Message-ID: <20220622150234.GC1861763@roeck-us.net>
References: <20220622144902.2954712-1-jhaller@bbl.ms.philips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622144902.2954712-1-jhaller@bbl.ms.philips.com>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 22, 2022 at 04:49:01PM +0200, Julian Haller wrote:
> From: Guenter Roeck <linux@roeck-us.net>
> 
> [ upstream commit e5d21072054fbadf41cd56062a3a14e447e8c22b ]
> 
> The thermal subsystem registers a hwmon driver without providing
> chip or sysfs group information. This is for legacy reasons and
> would be difficult to change. At the same time, we want to enforce
> that chip information is provided when registering a hwmon device
> using hwmon_device_register_with_info(). To enable this, introduce
> a special API for use only by the thermal subsystem.
> 
> Acked-by: Rafael J . Wysocki <rafael@kernel.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

What is the point of applying those patches to the 5.4 kernel ?
This was intended for use with new code, not for stable releases.

Guenter

> ---
>  drivers/hwmon/hwmon.c | 25 +++++++++++++++++++++++++
>  include/linux/hwmon.h |  3 +++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
> index c73b93b9bb87..e8a9955e3683 100644
> --- a/drivers/hwmon/hwmon.c
> +++ b/drivers/hwmon/hwmon.c
> @@ -743,6 +743,31 @@ hwmon_device_register_with_info(struct device *dev, const char *name,
>  }
>  EXPORT_SYMBOL_GPL(hwmon_device_register_with_info);
>  
> +/**
> + * hwmon_device_register_for_thermal - register hwmon device for thermal subsystem
> + * @dev: the parent device
> + * @name: hwmon name attribute
> + * @drvdata: driver data to attach to created device
> + *
> + * The use of this function is restricted. It is provided for legacy reasons
> + * and must only be called from the thermal subsystem.
> + *
> + * hwmon_device_unregister() must be called when the device is no
> + * longer needed.
> + *
> + * Returns the pointer to the new device.
> + */
> +struct device *
> +hwmon_device_register_for_thermal(struct device *dev, const char *name,
> +				  void *drvdata)
> +{
> +	if (!name || !dev)
> +		return ERR_PTR(-EINVAL);
> +
> +	return __hwmon_device_register(dev, name, drvdata, NULL, NULL);
> +}
> +EXPORT_SYMBOL_GPL(hwmon_device_register_for_thermal);
> +
>  /**
>   * hwmon_device_register - register w/ hwmon
>   * @dev: the device to register
> diff --git a/include/linux/hwmon.h b/include/linux/hwmon.h
> index 72579168189d..104c492959b9 100644
> --- a/include/linux/hwmon.h
> +++ b/include/linux/hwmon.h
> @@ -408,6 +408,9 @@ hwmon_device_register_with_info(struct device *dev,
>  				const struct hwmon_chip_info *info,
>  				const struct attribute_group **extra_groups);
>  struct device *
> +hwmon_device_register_for_thermal(struct device *dev, const char *name,
> +				  void *drvdata);
> +struct device *
>  devm_hwmon_device_register_with_info(struct device *dev,
>  				const char *name, void *drvdata,
>  				const struct hwmon_chip_info *info,
> -- 
> 2.25.1
> 
