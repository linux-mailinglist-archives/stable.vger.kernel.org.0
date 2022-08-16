Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7795953CA
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 09:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbiHPHaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 03:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbiHPH3q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 03:29:46 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B97D31F7;
        Mon, 15 Aug 2022 21:05:30 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id q9-20020a17090a2dc900b001f58bcaca95so16256949pjm.3;
        Mon, 15 Aug 2022 21:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=XXFxUvBcCEQW6aq/xzjSaHd+5yvV496WeWx3Xhu7LQ4=;
        b=XIVhEq81zbCHt7kzA+a/fmmn4Q6sYPYZs9RFIBiRYHoUh54jOPqD50z5+U61aUGf0u
         V9ePXU1R7/PQCiMqxoxQ7PjqsEb0D/n8JEHu+Vp+tB0Mcyi8zpTTphTB3hIY9IY2LVM/
         LTZJAfn5gJkiXK0pdD0jxaAtUkLf2khm+KugO0BCNtg+M6zpjAA7EhLRYfh/eVSX7qrw
         h05ajRZ1OARHjwYDaMuJ74WLyvgro3hC4/CbGyDQUN8fscFlGmaWslxtOBIloCqEmcVg
         1YhPsLaMAUx2YKjqzJTXUy96lmKpMvxqzaAE5jB4afUU+23KwbBx/F/bORycui8zZtP2
         A1nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=XXFxUvBcCEQW6aq/xzjSaHd+5yvV496WeWx3Xhu7LQ4=;
        b=IqgtDBpeX7aKkHHqwdXIXpi/nZWhQIFuHxjusjihzI28tP3otfB6HJCEy1OZqd4I47
         DN6voWMBaCzHhy5DofsB7AWuFG+wxjt1zu4+xLQiC0LNpEKR9y7Hu6+FWeOr251vtaEv
         eBj2vXB5esodqRiFUM76VvyxyjqPJwGyX3pcvfTIrAxf98Hsn8VDdapQ7lFKxYDz5J56
         0Jv9ej04no7BCfJ0TtlVijwW+ShB12+oG8xwtbhl/e3+UEC5sT/Ohyy05vt5Shp3E0dS
         JCh1D1B3lzB52f5o7TE6BppsNmS3tty7dBBQhjnp8PN81xFJkzStzlqHmKdv+C1L35vx
         YD0A==
X-Gm-Message-State: ACgBeo1a+4jF8aSfI0CtcTU8mOYVrgusVlpEE67eXVuRlQ0flYuUXaV0
        SEtDqaFo+iLGKzCVbjmtaSc6fRQVqXQ=
X-Google-Smtp-Source: AA6agR6Gf51589WorFB0MTsn1nnGC1HAgAfVmEvLPxicT5nqTJMQdPocSM4o92aLNGMjG6+CvSK2gA==
X-Received: by 2002:a17:902:e805:b0:16f:4a25:b5bd with SMTP id u5-20020a170902e80500b0016f4a25b5bdmr19876672plg.85.1660622730176;
        Mon, 15 Aug 2022 21:05:30 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x17-20020a1709027c1100b00172751a2fa4sm1687195pll.80.2022.08.15.21.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 21:05:29 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 15 Aug 2022 21:05:27 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1] usb: typec: tcpm: Return ENOTSUPP for power supply
 prop writes
Message-ID: <20220816040527.GA1108868@roeck-us.net>
References: <20220816033355.1259400-1-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816033355.1259400-1-badhri@google.com>
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

On Mon, Aug 15, 2022 at 08:33:55PM -0700, Badhri Jagan Sridharan wrote:
> When the port does not support USB PD, prevent transition to PD
> only states when power supply property is written. In this case,
> TCPM transitions to SNK_NEGOTIATE_CAPABILITIES
> which should not be the case given that the port is not pd_capable.
> 
> [   84.308251] state change SNK_READY -> SNK_NEGOTIATE_CAPABILITIES [rev3 NONE_AMS]
> [   84.308335] Setting usb_comm capable false
> [   84.323367] set_auto_vbus_discharge_threshold mode:3 pps_active:n vbus:5000 ret:0
> [   84.323376] state change SNK_NEGOTIATE_CAPABILITIES -> SNK_WAIT_CAPABILITIES [rev3 NONE_AMS]
> 
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/usb/typec/tcpm/tcpm.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
> index ea5a917c51b1..904c7b4ce2f0 100644
> --- a/drivers/usb/typec/tcpm/tcpm.c
> +++ b/drivers/usb/typec/tcpm/tcpm.c
> @@ -6320,6 +6320,13 @@ static int tcpm_psy_set_prop(struct power_supply *psy,
>  	struct tcpm_port *port = power_supply_get_drvdata(psy);
>  	int ret;
>  
> +	/*
> +	 * All the properties below are related to USB PD. The check needs to be
> +	 * property specific when a non-pd related property is added.
> +	 */
> +	if (!port->pd_supported)
> +		return -EOPNOTSUPP;
> +
>  	switch (psp) {
>  	case POWER_SUPPLY_PROP_ONLINE:
>  		ret = tcpm_psy_set_online(port, val);
> -- 
> 2.37.1.595.g718a3a8f04-goog
> 
