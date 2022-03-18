Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B8A4DDDB4
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238633AbiCRQHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238551AbiCRQHV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:07:21 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324F910780E;
        Fri, 18 Mar 2022 09:05:25 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id p9so12301624wra.12;
        Fri, 18 Mar 2022 09:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=DcA4sJmL1QB2BCHWjNUio1zxaNFvTCw7JphHxVAAEoA=;
        b=JJHvdmaVym95g2UhAg4NBJbDDWm/Zebay9zZCSUFhMjFa2hqua//t51YUGRvjkKfCq
         sQ2M++r9mVsNbctEurLszZpw8XXIpVlVwVq3z5qF/K/DHCY8jwtfIFzziAwr77FGyFWf
         EdEUr21cOi39LRKa89SWa1Wm8tvaqMBCGsgllw9x+Lg3mycoiUHIJUWGVwsAwCaux2fd
         HcDRWOYSEBLqZDPBdUFOl+JR084a5gzO8qkoCfTbhoWBjematobV8y5omZs6cb7W9ys0
         TTGBNHppseBhKuasDsIMysdrKU+88K86BjAz5BxLybkF8E/5iT/tbdrFCKktPyLHev3u
         k/Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=DcA4sJmL1QB2BCHWjNUio1zxaNFvTCw7JphHxVAAEoA=;
        b=v4ZIzXd8hfPOfp+viEa5BEl6UPl9k3kfZpgkHdDleg1c3icJ6HsdhAgJEv8VyxjJhs
         aYggxaFUo73YGfaT5D9CioZoQBenSB3irScxajo3u9h1zLSIKjbN/VQDyNuaLw5LBPHU
         Rof10G9VbwP5e+GWSosqmNpWNsmK3lEwCoSi4KeVfN6dIcCqSJswLC3K2jEEF6Ask8s4
         4G+e8bfhuHLCbMCD6o6PwBeUab8JPKTCbZpHjP6NujW8pzrlX8DVpsRkeYIfSX33OYVu
         wpn+ckAYHRXgaARcnJgkSaLX5TBxFYxA9dDc64aH10RjOCHjWv64K81kahGS40kDA931
         j1sA==
X-Gm-Message-State: AOAM530SGmm54nDF0m1d1jlRTyJv9hOD9KoEuol9k0jOGMDlz8s6qV9K
        JBMmj6Wc2OFUFow5jRTi3BEnglMgTvNWLA==
X-Google-Smtp-Source: ABdhPJwn9UVxOqp4FnLXXmD7jsk7zJUPQN6z4kSBqRl7+VCzvzQ4fKhcOMU+6m7D14IhOfWd6AIPZg==
X-Received: by 2002:adf:a507:0:b0:203:f522:c01a with SMTP id i7-20020adfa507000000b00203f522c01amr3745533wrb.282.1647619522130;
        Fri, 18 Mar 2022 09:05:22 -0700 (PDT)
Received: from elementary ([94.73.33.246])
        by smtp.gmail.com with ESMTPSA id 14-20020a5d47ae000000b00203f9af38f2sm1582990wrb.94.2022.03.18.09.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:05:21 -0700 (PDT)
Date:   Fri, 18 Mar 2022 17:05:18 +0100
From:   =?iso-8859-1?Q?Jos=E9_Exp=F3sito?= <jose.exposito89@gmail.com>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Jiri Kosina <jkosina@suse.cz>, stable@vger.kernel.org,
        regressions@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] Right touchpad button disabled on Dell 7750
Message-ID: <20220318160518.GA2950@elementary>
References: <s5htubv32s8.wl-tiwai@suse.de>
 <20220318130740.GA33535@elementary>
 <s5hlex72yno.wl-tiwai@suse.de>
 <CAO-hwJK8QMjYhQAC8tp7hLWZjSB3JMBJXgpKmFZRSEqPUn3_iw@mail.gmail.com>
 <s5hh77v2uov.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s5hh77v2uov.wl-tiwai@suse.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 18, 2022 at 03:37:20PM +0100, Takashi Iwai wrote:
> So is it like below?  I'll build another kernel with that.
> 
> 
> Thanks!
> 
> Takashi
> 
> -- 8< --
> From: José Expósito <jose.exposito89@gmail.com>
> Subject: [PATCH] HID: multitouch: fix Dell Precision 7550 and 7750 button type
> 
> The touchpad present in the Dell Precision 7550 and 7750 laptops
> reports a HID_DG_BUTTONTYPE of type MT_BUTTONTYPE_CLICKPAD. However,
> the device is not a clickpad, it is a touchpad with physical buttons.
> 
> In order to fix this issue, a quirk for the device was introduced in
> libinput [1] [2] to disable the INPUT_PROP_BUTTONPAD property:
> 
> 	[Precision 7x50 Touchpad]
> 	MatchBus=i2c
> 	MatchUdevType=touchpad
> 	MatchDMIModalias=dmi:*svnDellInc.:pnPrecision7?50*
> 	AttrInputPropDisable=INPUT_PROP_BUTTONPAD
> 
> However, because of the change introduced in 37ef4c19b4 ("Input: clear
> BTN_RIGHT/MIDDLE on buttonpads") the BTN_RIGHT key bit is not mapped
> anymore breaking the device right click button.
> 
> In order to fix the issue, create a quirk for the device forcing its
> button type to touchpad regardless of the value reported by the
> firmware.
> 
> [1] https://gitlab.freedesktop.org/libinput/libinput/-/merge_requests/481
> [2] https://bugzilla.redhat.com/show_bug.cgi?id=1868789
> 
> [ modified MT_CLS_BUTTONTYPE_TOUCHPAD quirk bits to base on MT_CLS_WIN8
>   as suggested by Benjamin -- tiwai ]
> 
> Fixes: 37ef4c19b4 ("Input: clear BTN_RIGHT/MIDDLE on buttonpads")
> Signed-off-by: José Expósito <jose.exposito89@gmail.com>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> 
> ---
>  drivers/hid/hid-ids.h        |    3 +++
>  drivers/hid/hid-multitouch.c |   20 ++++++++++++++++++++
>  2 files changed, 23 insertions(+)
> 
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -285,6 +285,9 @@
>  
>  #define USB_VENDOR_ID_CIDC		0x1677
>  
> +#define USB_VENDOR_ID_CIRQUE_CORP		0x0488
> +#define USB_DEVICE_ID_DELL_PRECISION_7X50	0x120A
> +
>  #define USB_VENDOR_ID_CJTOUCH		0x24b8
>  #define USB_DEVICE_ID_CJTOUCH_MULTI_TOUCH_0020	0x0020
>  #define USB_DEVICE_ID_CJTOUCH_MULTI_TOUCH_0040	0x0040
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -71,6 +71,7 @@ MODULE_LICENSE("GPL");
>  #define MT_QUIRK_SEPARATE_APP_REPORT	BIT(19)
>  #define MT_QUIRK_FORCE_MULTI_INPUT	BIT(20)
>  #define MT_QUIRK_DISABLE_WAKEUP		BIT(21)
> +#define MT_QUIRK_BUTTONTYPE_TOUCHPAD	BIT(22)
>  
>  #define MT_INPUTMODE_TOUCHSCREEN	0x02
>  #define MT_INPUTMODE_TOUCHPAD		0x03
> @@ -194,6 +195,7 @@ static void mt_post_parse(struct mt_devi
>  #define MT_CLS_WIN_8_FORCE_MULTI_INPUT		0x0015
>  #define MT_CLS_WIN_8_DISABLE_WAKEUP		0x0016
>  #define MT_CLS_WIN_8_NO_STICKY_FINGERS		0x0017
> +#define MT_CLS_BUTTONTYPE_TOUCHPAD		0x0018
>  
>  /* vendor specific classes */
>  #define MT_CLS_3M				0x0101
> @@ -302,6 +304,15 @@ static const struct mt_class mt_classes[
>  			MT_QUIRK_CONTACT_CNT_ACCURATE |
>  			MT_QUIRK_WIN8_PTP_BUTTONS,
>  		.export_all_inputs = true },
> +	{ .name = MT_CLS_BUTTONTYPE_TOUCHPAD,
> +		.quirks = MT_QUIRK_ALWAYS_VALID |
> +			MT_QUIRK_IGNORE_DUPLICATES |
> +			MT_QUIRK_HOVERING |
> +			MT_QUIRK_CONTACT_CNT_ACCURATE |
> +			MT_QUIRK_STICKY_FINGERS |
> +			MT_QUIRK_WIN8_PTP_BUTTONS |,
> +			MT_QUIRK_BUTTONTYPE_TOUCHPAD,
> +		.export_all_inputs = true },
>  
>  	/*
>  	 * vendor specific classes
> @@ -1286,6 +1297,9 @@ static int mt_touch_input_configured(str
>  	    (app->buttons_count == 1))
>  		td->is_buttonpad = true;
>  
> +	if (app->quirks & MT_QUIRK_BUTTONTYPE_TOUCHPAD)
> +		td->is_buttonpad = false;
> +
>  	if (td->is_buttonpad)
>  		__set_bit(INPUT_PROP_BUTTONPAD, input->propbit);
>  
> @@ -1875,6 +1889,12 @@ static const struct hid_device_id mt_dev
>  		MT_USB_DEVICE(USB_VENDOR_ID_CHUNGHWAT,
>  			USB_DEVICE_ID_CHUNGHWAT_MULTITOUCH) },
>  
> +	/* Cirque Corp (Dell Precision 7550 and 7750 touchpad) */
> +	{ .driver_data = MT_CLS_BUTTONTYPE_TOUCHPAD,
> +		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
> +			USB_VENDOR_ID_CIRQUE_CORP,
> +			USB_DEVICE_ID_DELL_PRECISION_7X50) },
> +
>  	/* CJTouch panels */
>  	{ .driver_data = MT_CLS_NSMU,
>  		MT_USB_DEVICE(USB_VENDOR_ID_CJTOUCH,


Yes, that is the correct patch. The original reporter just emailed me
and confirmed that the patch works and that the class used by the
device is MT_CLS_WIN_8, as Benjamin pointed out.

I'll wait a couple of days before sending the patch to the mailing list
so the other users can test it as well.

Thanks for the quick response,
Jose
