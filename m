Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842F849C228
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 04:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbiAZDeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 22:34:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiAZDeH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 22:34:07 -0500
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FA4C06161C;
        Tue, 25 Jan 2022 19:34:07 -0800 (PST)
Received: by mail-oo1-xc34.google.com with SMTP id v10-20020a4a860a000000b002ddc59f8900so7307559ooh.7;
        Tue, 25 Jan 2022 19:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cDDaOn0139gf1d2kxrxu8WODc1op+bzqijVLKsDNz4c=;
        b=CQP9KxEivo++r8gvNTVrG1sNqRa0kliRlCrPRF5Gunp08I6CX9YDiUJuq2VPrUiIlH
         7I52YRv1y6PjJ8WH/zmV1d8SeKuovc7Oe7UDZ4TSrFmdjILoINWflgQn/AnfK66IprG5
         eY2kZC2KFLPuP+EG+GPycrcc0bu1AYWgB9RMDBqnGrGaLU9aEK1/k+kFG/S+Ig3ecQHZ
         3ZzjzkPidwsUukA81xCL2JdYCnQOu6MUWfL2cU5e16Lhtd7TnKdFKAOVpY8+Qs1Pn1k6
         zuhmYFYTnxJ76Fc1X4xc9+Vrmbt8yM6yJjpkl13fKSCrtPuJSh7eYMWg8CBP7/0JNVIW
         n2Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cDDaOn0139gf1d2kxrxu8WODc1op+bzqijVLKsDNz4c=;
        b=HU9gKQJIn+ahTydAtUJX2nc+ECvoX/lEGyK4DTTS7INa+O29YA2Zj2DJB1r4bu603P
         8xFb/8AAlWeZV8F34dS4e2fObR/BZQtmiI9qU1IUTgEH8wsmoLttQ1DZgkBnfkg6tGOw
         4EV16x+YZW0Jbl+47EjyzbrN+JQdIMsWDpIb1GMiKk9uc4f1S+dnBBL7FfYMIBa7/SZ6
         78ARbgOvkjqbPi2uht5PvrkUArlP71hHxyq1S3pPspewnuiHsOQE3y8kdFWFPBnBVz0R
         eCnS7oJrmHKTTPmUvafKcKOw6RkXpW6KER4gAmGuZ4MiCFuPXIjo8dsigVdGcxr/HM52
         8B1A==
X-Gm-Message-State: AOAM530eB7ZMjGnT83y5pZgmjEHp4UnunHLWwlbX1W4cYGuSq/gqjxVK
        oq1/ZsA48Pf4swKvPjZdiXV5sF3zivA=
X-Google-Smtp-Source: ABdhPJxNPRnYL0Q8Wfxu5ZuLjlVdxIbPNN2/o7Px/pudcHuSVcybRydISukaNtv/vpH3kmQr+j56iQ==
X-Received: by 2002:a4a:ac0a:: with SMTP id p10mr14605962oon.96.1643168046699;
        Tue, 25 Jan 2022 19:34:06 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s12sm2701012ooi.46.2022.01.25.19.34.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 19:34:05 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <1c5777ae-d178-d1f7-b7a0-a60a7f58279e@roeck-us.net>
Date:   Tue, 25 Jan 2022 19:34:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 1/2] usb: typec: tcpm: Do not disconnect while
 receiving VBUS off
Content-Language: en-US
To:     Badhri Jagan Sridharan <badhri@google.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
References: <20220126020016.3159598-1-badhri@google.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220126020016.3159598-1-badhri@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/25/22 18:00, Badhri Jagan Sridharan wrote:
> With some chargers, vbus might momentarily raise above VSAFE5V and fall
> back to 0V before tcpm gets to read port->tcpc->get_vbus. This will
> report a VBUS off event causing TCPM to transition to SNK_UNATTACHED
> where it should be waiting in either SNK_ATTACH_WAIT or SNK_DEBOUNCED
> state. This patch makes TCPM avoid vbus off events while in
> SNK_ATTACH_WAIT or SNK_DEBOUNCED state.
> 
> Stub from the spec:
>      "4.5.2.2.4.2 Exiting from AttachWait.SNK State
>      A Sink shall transition to Unattached.SNK when the state of both
>      the CC1 and CC2 pins is SNK.Open for at least tPDDebounce.
>      A DRP shall transition to Unattached.SRC when the state of both
>      the CC1 and CC2 pins is SNK.Open for at least tPDDebounce."
> 
> [23.194131] CC1: 0 -> 0, CC2: 0 -> 5 [state SNK_UNATTACHED, polarity 0, connected]
> [23.201777] state change SNK_UNATTACHED -> SNK_ATTACH_WAIT [rev3 NONE_AMS]
> [23.209949] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @ 170 ms [rev3 NONE_AMS]
> [23.300579] VBUS off
> [23.300668] state change SNK_ATTACH_WAIT -> SNK_UNATTACHED [rev3 NONE_AMS]
> [23.301014] VBUS VSAFE0V
> [23.301111] Start toggling
> 
> Fixes: f0690a25a140b8 ("staging: typec: USB Type-C Port Manager (tcpm)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>

Why did you drop the Reviewed-by/Acked-by tags ?

Guenter

> ---
> Changes since v1:
> - Fix typos stated by Guenter Roeck.
> ---
>   drivers/usb/typec/tcpm/tcpm.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
> index 59d4fa2443f2..3bf79f52bd34 100644
> --- a/drivers/usb/typec/tcpm/tcpm.c
> +++ b/drivers/usb/typec/tcpm/tcpm.c
> @@ -5156,7 +5156,8 @@ static void _tcpm_pd_vbus_off(struct tcpm_port *port)
>   	case SNK_TRYWAIT_DEBOUNCE:
>   		break;
>   	case SNK_ATTACH_WAIT:
> -		tcpm_set_state(port, SNK_UNATTACHED, 0);
> +	case SNK_DEBOUNCED:
> +		/* Do nothing, as TCPM is still waiting for vbus to reach VSAFE5V to connect */
>   		break;
>   
>   	case SNK_NEGOTIATE_CAPABILITIES:

