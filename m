Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECBBF6D52DE
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 22:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbjDCUv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 16:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbjDCUv0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 16:51:26 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB6326B9;
        Mon,  3 Apr 2023 13:51:25 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id er13so81452214edb.9;
        Mon, 03 Apr 2023 13:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680555084;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oxpzfoN07dcJvSzaVP251bOO1U4HLehZS+CwOw8A66s=;
        b=CUVCenBYqcMqoSHRb+xeBW7MY7GCf6SVH486cCCw0Hlj5aQKoL+Dy3ggyxYmjcjBYZ
         pooM6iWEUB9PzRh5NG7vXBnfdNTvy4gKiZDmsURkH4sdcBsrLyYLv3dkIGXESlokpbMr
         l3PTWxsj5QaVnHRleFFdx+sRiAvPUfpdftnqGlrs3lbTxS3PH94g6gvcOYx0DNJFeTve
         2kVoy5Vge9fkipsFJjgz5gQRAIiWWZylCOBtKBXSsBtSiae76E2NlpwAiXbIcOFMrDr/
         /bdliEFsOnZTR71J7BPY4qLhAGeMQxOL38o3i0vc2HvHscHmLDksMHkPu//j1YT2DfEy
         Uqxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680555084;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oxpzfoN07dcJvSzaVP251bOO1U4HLehZS+CwOw8A66s=;
        b=7EFnT/uYzaI1WWL+D77RGCl4V1vRb4RCO7fmIKs85PQftb3wwXbJSgKNxWF9KZCZ3d
         gNq+MwTZ1wttv8glRcBdvJK22mGXCxhOz/vHJ54G0IiRGlnxKDPqDnd5aAiQh1IXU9lz
         7ASodsm1bdOUO6Lc79NddHnFEx4vTP5k+sBA4eMqZeeyrsT9cpcBsQ+g5MnEp0x+m9YS
         WWj0x87hNb2WrFiFRDiCYjPDqP5WbRRR8+x0kub5V1Ebbw73N+pDm0ySR90YZjRuAAg1
         uQy0nnRBMX0Gq3xv/PHNnO3FRCSttr3S/g9fviBNzpptKZ8dDQpuQxmdsgdt6zGVRdh2
         6y9g==
X-Gm-Message-State: AAQBX9c/EEDrHMBfA6Pe81flSzFq6ceXFkXmU+IuGtDiy1GoIckGdUCy
        xmX5Crl1u3eM/yw1o7zZIa8=
X-Google-Smtp-Source: AKy350b6D5fa6aAPhZkQjktNVmyFSIlHJ1UUwepZliWb1ykzAIRLJVQNQeM0MUn+SGRxr14T15DdHg==
X-Received: by 2002:a17:906:3a41:b0:931:8e8c:2db5 with SMTP id a1-20020a1709063a4100b009318e8c2db5mr37449774ejf.69.1680555083419;
        Mon, 03 Apr 2023 13:51:23 -0700 (PDT)
Received: from localhost (tor-exit-1.zbau.f3netze.de. [185.220.100.252])
        by smtp.gmail.com with ESMTPSA id j3-20020a170906050300b00947a40ded80sm4836191eja.104.2023.04.03.13.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 13:51:22 -0700 (PDT)
Date:   Mon, 3 Apr 2023 23:51:20 +0300
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
Message-ID: <ZCs8SA47vGCjVl1l@mail.gmail.com>
References: <20230330194644.64628-1-hdegoede@redhat.com>
 <ZCatIn7ok4jRrXS9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCatIn7ok4jRrXS9@mail.gmail.com>
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

On Fri, 31 Mar 2023 at 12:51:30 +0300, Maxim Mikityanskiy wrote:
> On Thu, 30 Mar 2023 at 21:46:44 +0200, Hans de Goede wrote:
> > Commit 5829f8a897e4 ("platform/x86: ideapad-laptop: Send
> > KEY_TOUCHPAD_TOGGLE on some models") made ideapad-laptop send
> > KEY_TOUCHPAD_TOGGLE when we receive an ACPI notify with VPC event bit 5 set
> > and the touchpad-state has not been changed by the EC itself already.
> > 
> > This was done under the assumption that this would be good to do to make
> > the touchpad-toggle hotkey work on newer models where the EC does not
> > toggle the touchpad on/off itself (because it is not routed through
> > the PS/2 controller, but uses I2C).
> > 
> > But it turns out that at least some models, e.g. the Yoga 7-15ITL5 the EC
> > triggers an ACPI notify with VPC event bit 5 set on resume, which would
> > now cause a spurious KEY_TOUCHPAD_TOGGLE on resume to which the desktop
> > environment responds by disabling the touchpad in software, breaking
> > the touchpad (until manually re-enabled) on resume.
> 
> Oh gosh, the touchpad toggle on Ideapads is so much broken, I wonder how
> the Windows driver deals with all this variety of different behaviors
> (unless it's broken too :D).
> 
> I'll test the patch on Z570, but as I see, it shouldn't change anything
> for Z570.

Tested the kernel from your branch on Z570, the touchpad button still
works fine.

> > It was never confirmed that sending KEY_TOUCHPAD_TOGGLE actually improves
> > things on new models and at least some new models like the Yoga 7-15ITL5
> > don't have a touchpad on/off toggle hotkey at all, while still sending
> > ACPI notify events with VPC event bit 5 set.
> > 
> > So it seems best to revert the change to send KEY_TOUCHPAD_TOGGLE when
> > receiving an ACPI notify events with VPC event bit 5 and the touchpad
> > state as reported by the EC has not changed.
> > 
> > Note this is not a full revert the code to cache the last EC touchpad
> > state is kept to avoid sending spurious KEY_TOUCHPAD_ON / _OFF events
> > on resume.
> > 
> > Fixes: 5829f8a897e4 ("platform/x86: ideapad-laptop: Send KEY_TOUCHPAD_TOGGLE on some models")
> > Link: https://bugzilla.kernel.org/show_bug.cgi?id=217234
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> > ---
> >  drivers/platform/x86/ideapad-laptop.c | 23 ++++++++++-------------
> >  1 file changed, 10 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
> > index b5ef3452da1f..35c63cce0479 100644
> > --- a/drivers/platform/x86/ideapad-laptop.c
> > +++ b/drivers/platform/x86/ideapad-laptop.c
> > @@ -1170,7 +1170,6 @@ static const struct key_entry ideapad_keymap[] = {
> >  	{ KE_KEY,  65, { KEY_PROG4 } },
> >  	{ KE_KEY,  66, { KEY_TOUCHPAD_OFF } },
> >  	{ KE_KEY,  67, { KEY_TOUCHPAD_ON } },
> > -	{ KE_KEY,  68, { KEY_TOUCHPAD_TOGGLE } },
> >  	{ KE_KEY, 128, { KEY_ESC } },
> >  
> >  	/*
> > @@ -1526,18 +1525,16 @@ static void ideapad_sync_touchpad_state(struct ideapad_private *priv, bool send_
> >  	if (priv->features.ctrl_ps2_aux_port)
> >  		i8042_command(&param, value ? I8042_CMD_AUX_ENABLE : I8042_CMD_AUX_DISABLE);
> >  
> > -	if (send_events) {
> > -		/*
> > -		 * On older models the EC controls the touchpad and toggles it
> > -		 * on/off itself, in this case we report KEY_TOUCHPAD_ON/_OFF.
> > -		 * If the EC did not toggle, report KEY_TOUCHPAD_TOGGLE.
> > -		 */
> > -		if (value != priv->r_touchpad_val) {
> > -			ideapad_input_report(priv, value ? 67 : 66);
> > -			sysfs_notify(&priv->platform_device->dev.kobj, NULL, "touchpad");
> > -		} else {
> > -			ideapad_input_report(priv, 68);
> > -		}
> > +	/*
> > +	 * On older models the EC controls the touchpad and toggles it on/off
> > +	 * itself, in this case we report KEY_TOUCHPAD_ON/_OFF. Some models do
> > +	 * an acpi-notify with VPC bit 5 set on resume, so this function get
> > +	 * called with send_events=true on every resume. Therefor if the EC did
> > +	 * not toggle, do nothing to avoid sending spurious KEY_TOUCHPAD_TOGGLE.
> > +	 */
> > +	if (send_events && value != priv->r_touchpad_val) {
> > +		ideapad_input_report(priv, value ? 67 : 66);
> > +		sysfs_notify(&priv->platform_device->dev.kobj, NULL, "touchpad");
> >  	}
> >  
> >  	priv->r_touchpad_val = value;
> > -- 
> > 2.39.1
> > 
