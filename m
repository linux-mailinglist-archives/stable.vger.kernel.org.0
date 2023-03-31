Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 286556D1D01
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 11:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbjCaJxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 05:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbjCaJwr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 05:52:47 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01562172D;
        Fri, 31 Mar 2023 02:51:34 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id x17so28173295lfu.5;
        Fri, 31 Mar 2023 02:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680256293;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BXReCcBo1WbUETuBVZjz7y3hQ/ozmgJyxoB/np9lJeY=;
        b=OeNQnwSP7M/FO3mV8Qz0JC5+bT51sq782QepPrBHK7XZq+JFz349dos+sM47UiNtW7
         75U9vL9naHWdTT9mvohomFY5xuxeNleaPyVl/7ZlE9vGg+oDETA74QdUhnj759BzoCiG
         DvdCR4SMrLsB+oastdHenvkcC3xnIK2Wlp7F8WZB7Yqwb1Mw7pMAooehVIdG60YfmO8z
         2TnI1kAJ8jZ4KIfu4Pu9Xcnifm45dLCgjazGRtCSwwL/Xw+bMAiy6x9FYv70RIOtu8jV
         Bs32u2l6A/5z/KBRVnZ9v5IeHdWbPja6723Jf/qpBvt+vs9dj05yq3DNXkBRGBsxd3xH
         xilA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680256293;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BXReCcBo1WbUETuBVZjz7y3hQ/ozmgJyxoB/np9lJeY=;
        b=IM61Ma1B2DO0Q5CNqto70d84bsh+EMy6EnLtSgdVbGZ4mjyQF/YkwV8f1kmGDwqrD4
         RqwlCdAvTKqiHrE9YaGxHoehpp3fAV9MfPMEk0QCIfb/WoDo7kCNNn+9tOFlVZ4qbzih
         n3yO2/O5Cvcau9LRk6nqfmFgP1wsCvmjhEkZ7yE6TXiYGJnmqhwAyOH7X54irfbX9Wn2
         3Gn/DkYEj4H5Gu5Y5tN6Na8H0w7viG7mMU+odY4aNEviWU2h6cjHHW4ZRMaUw9o3DwTn
         AtE3NGMgkNOStkvAOzzh0h6HZMEB7rU9YEnKXQKaqHQgtCJhFEbC+8zkplzEj3hsIvgr
         ZV/A==
X-Gm-Message-State: AAQBX9dxfWkgeDXmkMMKSOYKDQYABaX3B6L3UJ4bskABKoJIPbc49qh1
        evvnCfXDw4QSdmHXv33nvsE=
X-Google-Smtp-Source: AKy350bWHSCgCfD42dONrxStM6Lq4UQVV0IKwy3trFL7KuQFRRQ8IZdlg7t3TLq3dvhT6Er5fSZzkA==
X-Received: by 2002:ac2:55b9:0:b0:4eb:c3c:ce20 with SMTP id y25-20020ac255b9000000b004eb0c3cce20mr5482881lfg.22.1680256293080;
        Fri, 31 Mar 2023 02:51:33 -0700 (PDT)
Received: from localhost ([23.154.177.24])
        by smtp.gmail.com with ESMTPSA id v2-20020ac25922000000b004e1b880ba20sm309055lfi.292.2023.03.31.02.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 02:51:32 -0700 (PDT)
Date:   Fri, 31 Mar 2023 12:51:30 +0300
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Mark Gross <markgross@kernel.org>,
        Andy Shevchenko <andy@kernel.org>,
        =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>,
        Kai Heng Feng <kai.heng.feng@canonical.com>,
        GOESSEL Guillaume <g_goessel@outlook.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Manyi Li <limanyi@uniontech.com>,
        Eray =?iso-8859-1?Q?Or=E7unus?= <erayorcunus@gmail.com>,
        Philipp Jungkamp <p.jungkamp@gmx.net>,
        Arnav Rawat <arnavr3@illinois.edu>,
        Kelly Anderson <kelly@xilka.com>, Meng Dong <whenov@gmail.com>,
        Felix Eckhofer <felix@eckhofer.com>,
        Ike Panhc <ike.pan@canonical.com>,
        platform-driver-x86@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] platform/x86: ideapad-laptop: Stop sending
 KEY_TOUCHPAD_TOGGLE
Message-ID: <ZCatIn7ok4jRrXS9@mail.gmail.com>
References: <20230330194644.64628-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330194644.64628-1-hdegoede@redhat.com>
X-Spam-Status: No, score=3.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 30 Mar 2023 at 21:46:44 +0200, Hans de Goede wrote:
> Commit 5829f8a897e4 ("platform/x86: ideapad-laptop: Send
> KEY_TOUCHPAD_TOGGLE on some models") made ideapad-laptop send
> KEY_TOUCHPAD_TOGGLE when we receive an ACPI notify with VPC event bit 5 set
> and the touchpad-state has not been changed by the EC itself already.
> 
> This was done under the assumption that this would be good to do to make
> the touchpad-toggle hotkey work on newer models where the EC does not
> toggle the touchpad on/off itself (because it is not routed through
> the PS/2 controller, but uses I2C).
> 
> But it turns out that at least some models, e.g. the Yoga 7-15ITL5 the EC
> triggers an ACPI notify with VPC event bit 5 set on resume, which would
> now cause a spurious KEY_TOUCHPAD_TOGGLE on resume to which the desktop
> environment responds by disabling the touchpad in software, breaking
> the touchpad (until manually re-enabled) on resume.

Oh gosh, the touchpad toggle on Ideapads is so much broken, I wonder how
the Windows driver deals with all this variety of different behaviors
(unless it's broken too :D).

I'll test the patch on Z570, but as I see, it shouldn't change anything
for Z570.

> It was never confirmed that sending KEY_TOUCHPAD_TOGGLE actually improves
> things on new models and at least some new models like the Yoga 7-15ITL5
> don't have a touchpad on/off toggle hotkey at all, while still sending
> ACPI notify events with VPC event bit 5 set.
> 
> So it seems best to revert the change to send KEY_TOUCHPAD_TOGGLE when
> receiving an ACPI notify events with VPC event bit 5 and the touchpad
> state as reported by the EC has not changed.
> 
> Note this is not a full revert the code to cache the last EC touchpad
> state is kept to avoid sending spurious KEY_TOUCHPAD_ON / _OFF events
> on resume.
> 
> Fixes: 5829f8a897e4 ("platform/x86: ideapad-laptop: Send KEY_TOUCHPAD_TOGGLE on some models")
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=217234
> Cc: stable@vger.kernel.org
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/platform/x86/ideapad-laptop.c | 23 ++++++++++-------------
>  1 file changed, 10 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
> index b5ef3452da1f..35c63cce0479 100644
> --- a/drivers/platform/x86/ideapad-laptop.c
> +++ b/drivers/platform/x86/ideapad-laptop.c
> @@ -1170,7 +1170,6 @@ static const struct key_entry ideapad_keymap[] = {
>  	{ KE_KEY,  65, { KEY_PROG4 } },
>  	{ KE_KEY,  66, { KEY_TOUCHPAD_OFF } },
>  	{ KE_KEY,  67, { KEY_TOUCHPAD_ON } },
> -	{ KE_KEY,  68, { KEY_TOUCHPAD_TOGGLE } },
>  	{ KE_KEY, 128, { KEY_ESC } },
>  
>  	/*
> @@ -1526,18 +1525,16 @@ static void ideapad_sync_touchpad_state(struct ideapad_private *priv, bool send_
>  	if (priv->features.ctrl_ps2_aux_port)
>  		i8042_command(&param, value ? I8042_CMD_AUX_ENABLE : I8042_CMD_AUX_DISABLE);
>  
> -	if (send_events) {
> -		/*
> -		 * On older models the EC controls the touchpad and toggles it
> -		 * on/off itself, in this case we report KEY_TOUCHPAD_ON/_OFF.
> -		 * If the EC did not toggle, report KEY_TOUCHPAD_TOGGLE.
> -		 */
> -		if (value != priv->r_touchpad_val) {
> -			ideapad_input_report(priv, value ? 67 : 66);
> -			sysfs_notify(&priv->platform_device->dev.kobj, NULL, "touchpad");
> -		} else {
> -			ideapad_input_report(priv, 68);
> -		}
> +	/*
> +	 * On older models the EC controls the touchpad and toggles it on/off
> +	 * itself, in this case we report KEY_TOUCHPAD_ON/_OFF. Some models do
> +	 * an acpi-notify with VPC bit 5 set on resume, so this function get
> +	 * called with send_events=true on every resume. Therefor if the EC did
> +	 * not toggle, do nothing to avoid sending spurious KEY_TOUCHPAD_TOGGLE.
> +	 */
> +	if (send_events && value != priv->r_touchpad_val) {
> +		ideapad_input_report(priv, value ? 67 : 66);
> +		sysfs_notify(&priv->platform_device->dev.kobj, NULL, "touchpad");
>  	}
>  
>  	priv->r_touchpad_val = value;
> -- 
> 2.39.1
> 
