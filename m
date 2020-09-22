Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0097274D0B
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 01:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgIVXE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 19:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgIVXE2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 19:04:28 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA6FC0613D0
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 16:04:28 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id n2so22911825oij.1
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 16:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b+OgEzMUkGjWCFHFV+1RVeWmpSYekgLQnXYjYPaq2pY=;
        b=ACaUGC4E8+egqTuL9hbpmN5ggSfxqOesq09hLxKLwlqhESbe1utRJQhnVem1l1CJVk
         r50RFhlppCHD58WnvQmTYUHO22h3QcZ45mjhQckVJeY5M+phKavEzbAvCYS4s66X6RW/
         SjL4cjkUGCm0jRedFlSpo4bwsbE069vjbguPM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b+OgEzMUkGjWCFHFV+1RVeWmpSYekgLQnXYjYPaq2pY=;
        b=sIIXjA12q5/Ta+XOB32Yzp5EcR+ZE+YwM3F51WJTDkqI2H+LNvdks90sbMWwddCl6A
         5K5SGFxtk9JePaWsSAuS9UW6sht66SP5+vgGJZT3+n8ykrOOu9MNFWnWoVGJYZKAKtgv
         dKVenN96nEECIboGxRy56/5xY8FZK5iHvZQ04u7WpZswjE9PJCHPfX2x7qw4vj+nck9k
         lAoFZ543dTKMCELGCK3ec8MQ7H8aTkTm8dnGObpYMBHVup2/Z6gNt5UX4tJwFCTYZmHP
         8/sFTJtxSgTi2axrh1WJWd9/mJmC6hIBVAgON11O34TdTUP40E4exmNFNqq4DfOedwi0
         ap1w==
X-Gm-Message-State: AOAM532KQ2hxcxOpFkcyd+im37jOwZVQABrTSy8lGXuLHhedp36Yjc+v
        qqmx9GBxdik3XWd2yX/SUT3ifg==
X-Google-Smtp-Source: ABdhPJwLOhUdZOTrpTSOuEmswuNoFIWQpyB9ICF2AIWKubKWMl/+XhbFkh5pIIU7yAvvJlzAy5IfZw==
X-Received: by 2002:aca:ea44:: with SMTP id i65mr3857137oih.117.1600815867457;
        Tue, 22 Sep 2020 16:04:27 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id v20sm7705947oiv.47.2020.09.22.16.04.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 16:04:26 -0700 (PDT)
Subject: Re: [PATCH v3 4/4] usbcore/driver: Accommodate usbip
To:     "M. Vefa Bicakci" <m.v.b@runbox.com>, linux-usb@vger.kernel.org
Cc:     stable@vger.kernel.org, Bastien Nocera <hadess@hadess.net>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        syzkaller@googlegroups.com, Shuah Khan <skhan@linuxfoundation.org>
References: <20200922110703.720960-1-m.v.b@runbox.com>
 <20200922110703.720960-5-m.v.b@runbox.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <471ef25b-c2e8-0ffb-b1a0-1d9693ee3f7b@linuxfoundation.org>
Date:   Tue, 22 Sep 2020 17:04:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200922110703.720960-5-m.v.b@runbox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/22/20 5:07 AM, M. Vefa Bicakci wrote:
> Commit 88b7381a939d ("USB: Select better matching USB drivers when
> available") inadvertently broke usbip functionality. The commit in
> question allows USB device drivers to be explicitly matched with
> USB devices via the use of driver-provided identifier tables and
> match functions, which is useful for a specialised device driver
> to be chosen for a device that can also be handled by another,
> more generic, device driver.
> 
> Prior, the USB device section of usb_device_match() had an
> unconditional "return 1" statement, which allowed user-space to bind
> USB devices to the usbip_host device driver, if desired. However,
> the aforementioned commit changed the default/fallback return
> value to zero. This breaks device drivers such as usbip_host, so
> this commit restores the legacy behaviour, but only if a device
> driver does not have an id_table and a match() function.
> 
> In addition, if usb_device_match is called for a device driver
> and device pair where the device does not match the id_table of the
> device driver in question, then the device driver will be disqualified
> for the device. This allows avoiding the default case of "return 1",
> which prevents undesirable probe() calls to a driver even though
> its id_table did not match the device.
> 
> Finally, this commit changes the specialised-driver-to-generic-driver
> transition code so that when a device driver returns -ENODEV, a more
> generic device driver is only considered if the current device driver
> does not have an id_table and a match() function. This ensures that
> "generic" drivers such as usbip_host will not be considered specialised
> device drivers and will not cause the device to be locked in to the
> generic device driver, when a more specialised device driver could be
> tried.
> 
> All of these changes restore usbip functionality without regressions,
> ensure that the specialised/generic device driver selection logic works
> as expected with the usb and apple-mfi-fastcharge drivers, and do not
> negatively affect the use of devices provided by dummy_hcd.
> 
> Fixes: 88b7381a939d ("USB: Select better matching USB drivers when available")
> Link: https://lore.kernel.org/linux-usb/CAAeHK+zOrHnxjRFs=OE8T=O9208B9HP_oo8RZpyVOZ9AJ54pAA@mail.gmail.com/
> Cc: <stable@vger.kernel.org> # 5.8
> Cc: Bastien Nocera <hadess@hadess.net>
> Cc: Valentina Manea <valentina.manea.m@gmail.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: <syzkaller@googlegroups.com>
> Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
> 
> ---
> v3: New patch in this patch set.
>      For reviewers' awareness, another option for usb_device_match would
>      be as follows. This allows the driver's match() function to act
>      as a fallback in case the driver has an id_table, but the id_table
>      does not include the device.
> 
> 	if (!udrv->id_table && !udrv->match) {
> 		/* Allow usbip and similar drivers to bind to
> 		 * arbitrary devices; let their probe functions
> 		 * decide.
> 		 */
> 		return 1;
> 	}
> 
> 	if (udrv->id_table &&
> 	    usb_device_match_id(udev, udrv->id_table) != NULL)
> 		return 1;
> 
> 	if (udrv->match && udrv->match(udev))
> 		return 1;
> 
> 	return 0;
> ---
>   drivers/usb/core/driver.c | 37 +++++++++++++++++++++++++++++++------
>   1 file changed, 31 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
> index 7d90cbe063ec..98b7449c11f3 100644
> --- a/drivers/usb/core/driver.c
> +++ b/drivers/usb/core/driver.c
> @@ -269,8 +269,30 @@ static int usb_probe_device(struct device *dev)
>   	if (error)
>   		return error;
>   
> +	/* Probe the USB device with the driver in hand, but only
> +	 * defer to a generic driver in case the current USB
> +	 * device driver has an id_table or a match function; i.e.,
> +	 * when the device driver was explicitly matched against
> +	 * a device.
> +	 *
> +	 * If the device driver does not have either of these,
> +	 * then we assume that it can bind to any device and is
> +	 * not truly a more specialized/non-generic driver, so a
> +	 * return value of -ENODEV should not force the device
> +	 * to be handled by the generic USB driver, as there
> +	 * can still be another, more specialized, device driver.
> +	 *
> +	 * This accommodates the usbip driver.
> +	 *
> +	 * TODO: What if, in the future, there are multiple
> +	 * specialized USB device drivers for a particular device?
> +	 * In such cases, there is a need to try all matching
> +	 * specialised device drivers prior to setting the
> +	 * use_generic_driver bit.
> +	 */
>   	error = udriver->probe(udev);
> -	if (error == -ENODEV && udriver != &usb_generic_driver) {
> +	if (error == -ENODEV && udriver != &usb_generic_driver &&
> +	    (udriver->id_table || udriver->match)) {
>   		udev->use_generic_driver = 1;
>   		return -EPROBE_DEFER;
>   	}
> @@ -831,14 +853,17 @@ static int usb_device_match(struct device *dev, struct device_driver *drv)
>   		udev = to_usb_device(dev);
>   		udrv = to_usb_device_driver(drv);
>   
> -		if (udrv->id_table &&
> -		    usb_device_match_id(udev, udrv->id_table) != NULL) {
> -			return 1;
> -		}
> +		if (udrv->id_table)
> +			return usb_device_match_id(udev, udrv->id_table) != NULL;
>   
>   		if (udrv->match)
>   			return udrv->match(udev);
> -		return 0;
> +
> +		/* If the device driver under consideration does not have a
> +		 * id_table or a match function, then let the driver's probe
> +		 * function decide.
> +		 */
> +		return 1;
>   
>   	} else if (is_usb_interface(dev)) {
>   		struct usb_interface *intf;
> 

Thank you for finding a solution that works for usbip case.

Acked-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
