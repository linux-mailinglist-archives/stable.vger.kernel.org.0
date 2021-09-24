Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767EF417165
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 13:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245303AbhIXMAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245273AbhIXMAH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 08:00:07 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552B9C061574;
        Fri, 24 Sep 2021 04:58:34 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id r43-20020a05683044ab00b0054716b40005so5907895otv.4;
        Fri, 24 Sep 2021 04:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l6AwaPqrmW+gQUvFl7RM/Ev8GqbFQ1KL/qy37HA9sEY=;
        b=d+c6BKURhDjKntMYaLv/yTwoA+3XE09C8Ytnrrr8il8M/IU0uMrvnr7LrNbrU2ahZq
         WqBdFevYLH8vd3oKF+lJs9PuHnGuE5jWM8txyQCcprWsbk++M6XGFHLxPWX6zmK9/bFg
         AhBu1tb2lOBsJCS3ffGWf/iQoIQSoCzkYAUWhPL5zhJLVxUQdh8vyZqIFrQCN7xYnwmf
         qOi5W/8iI14yIXH+1tLU8HwsnHvrw0XhC4tg1y39Oj3pzOFvPfAjp+B80KiHqVaUCfz4
         c7vHrx0ESJks9W/VCdMWb1qBlLMIvqMqMyBUOMK67ARdiUI2uKpTlbbXsPU73Vb+bRPS
         wuLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=l6AwaPqrmW+gQUvFl7RM/Ev8GqbFQ1KL/qy37HA9sEY=;
        b=xy53nmKcv7kppG4uXWhUDSiw/Qg85xbEFoKd2dJAMqalI532sVfMQcWWeq59CuZqee
         HzbvJg+pnD104GDEEPc2VXbZ0l/oVFI/870YMGDM6P29k9LGWE7HHe2qcttMu7WAvD2Y
         lPCcmFKc3Kswc6y/yEUxJ3kuIm337pNpU6p0owtawMxGFsjfOHQIzYOxA2knxvBnsIon
         XdPTAHK/bFzMMVLYf1FrCkz2zHwhh/GBQo0RKguWzAaDTQI76HgF4tuO8H6yryHDWHhT
         Ls89dza6p+wZUvvmI432yoPvGlBIdOeSo77z/iXK7jlGIpsgiHzy1VF1pD2pQi8epv6B
         od8w==
X-Gm-Message-State: AOAM533syrBPBRxzY1SWOeXfORvZB99GSWFQ0Me2qpUv3hrziof1qI2v
        TlyVZA29jTso0KMACdYmPAdM/xJgmYc=
X-Google-Smtp-Source: ABdhPJw0kFXfbe6u/G5ac+M9nSxcDyOiFBhdXP40cIkv5Xwuyhnqz5cMN3xmDH/gjPozEBU78pQ/VA==
X-Received: by 2002:a9d:6143:: with SMTP id c3mr3566086otk.124.1632484713730;
        Fri, 24 Sep 2021 04:58:33 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k23sm2130435ood.12.2021.09.24.04.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 04:58:33 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 24 Sep 2021 04:58:31 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Paul Fertser <fercerpav@gmail.com>
Cc:     linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/3] hwmon: tmp421: handle I2C errors
Message-ID: <20210924115831.GA2695099@roeck-us.net>
References: <20210924022020.GA3032273@roeck-us.net>
 <20210924093011.26083-1-fercerpav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924093011.26083-1-fercerpav@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 24, 2021 at 12:30:09PM +0300, Paul Fertser wrote:
> Function i2c_smbus_read_byte_data() can return a negative error number
> instead of the data read if I2C transaction failed for whatever reason.
> 
> Lack of error checking can lead to serious issues on production
> hardware, e.g. errors treated as temperatures produce spurious critical
> temperature-crossed-threshold errors in BMC logs for OCP server
> hardware. The patch was tested with Mellanox OCP Mezzanine card
> emulating TMP421 protocol for temperature sensing which sometimes leads
> to I2C protocol error during early boot up stage.
> 
> Fixes: 9410700b881f ("hwmon: Add driver for Texas Instruments TMP421/422/423 sensor chips")
> Cc: stable@vger.kernel.org
> Signed-off-by: Paul Fertser <fercerpav@gmail.com>

Applied.

Thanks,
Guenter

> ---
> 
> Changes from v2:
>  - Do not change data->valid type as that's an unrelated cleanup
>  - Add Fixes: tag
>  - Remove clutter from the commit message
> 
> Changes from v1:
>  - Reorganise code following excellent suggestion by Guenter Roeck
>    to use tagged errors consistently
> 
>  drivers/hwmon/tmp421.c | 41 +++++++++++++++++++++++++++++++----------
>  1 file changed, 31 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/hwmon/tmp421.c b/drivers/hwmon/tmp421.c
> index ede66ea6a730..e6b2b31d17c8 100644
> --- a/drivers/hwmon/tmp421.c
> +++ b/drivers/hwmon/tmp421.c
> @@ -119,38 +119,59 @@ static int temp_from_u16(u16 reg)
>  	return (temp * 1000 + 128) / 256;
>  }
>  
> -static struct tmp421_data *tmp421_update_device(struct device *dev)
> +static int tmp421_update_device(struct tmp421_data *data)
>  {
> -	struct tmp421_data *data = dev_get_drvdata(dev);
>  	struct i2c_client *client = data->client;
> +	int ret = 0;
>  	int i;
>  
>  	mutex_lock(&data->update_lock);
>  
>  	if (time_after(jiffies, data->last_updated + (HZ / 2)) ||
>  	    !data->valid) {
> -		data->config = i2c_smbus_read_byte_data(client,
> -			TMP421_CONFIG_REG_1);
> +		ret = i2c_smbus_read_byte_data(client,
> +					       TMP421_CONFIG_REG_1);
> +		if (ret < 0)
> +			goto exit;
> +		data->config = ret;
>  
>  		for (i = 0; i < data->channels; i++) {
> -			data->temp[i] = i2c_smbus_read_byte_data(client,
> -				TMP421_TEMP_MSB[i]) << 8;
> -			data->temp[i] |= i2c_smbus_read_byte_data(client,
> -				TMP421_TEMP_LSB[i]);
> +			ret = i2c_smbus_read_byte_data(client,
> +						       TMP421_TEMP_MSB[i]);
> +			if (ret < 0)
> +				goto exit;
> +			data->temp[i] = ret << 8;
> +
> +			ret = i2c_smbus_read_byte_data(client,
> +						       TMP421_TEMP_LSB[i]);
> +			if (ret < 0)
> +				goto exit;
> +			data->temp[i] |= ret;
>  		}
>  		data->last_updated = jiffies;
>  		data->valid = 1;
>  	}
>  
> +exit:
>  	mutex_unlock(&data->update_lock);
>  
> -	return data;
> +	if (ret < 0) {
> +		data->valid = 0;
> +		return ret;
> +	}
> +
> +	return 0;
>  }
>  
>  static int tmp421_read(struct device *dev, enum hwmon_sensor_types type,
>  		       u32 attr, int channel, long *val)
>  {
> -	struct tmp421_data *tmp421 = tmp421_update_device(dev);
> +	struct tmp421_data *tmp421 = dev_get_drvdata(dev);
> +	int ret = 0;
> +
> +	ret = tmp421_update_device(tmp421);
> +	if (ret)
> +		return ret;
>  
>  	switch (attr) {
>  	case hwmon_temp_input:
