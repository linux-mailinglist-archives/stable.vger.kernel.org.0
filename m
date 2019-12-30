Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA5212D1B8
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 17:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbfL3QHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 11:07:31 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42836 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727471AbfL3QHb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 11:07:31 -0500
Received: by mail-pg1-f194.google.com with SMTP id s64so18198829pgb.9;
        Mon, 30 Dec 2019 08:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QQifhEvd0qlOro5mq55/v6MzZxcRB/EQ8GzsSLDvKvQ=;
        b=NIqxuaZLjE0bnw2trLuyaKCZlOURs2/yVNquCgje//3TbuWs8CCcqgzfTuEQMYq5Gu
         IdC2MuXxAmVo7Ke2A8LTaJXUKNePtWGOW09awQrpPWIpUBYPlbd9OnRk4BPT8Hdd3vAc
         KrGMRAF+11XvtTWVQl1VOODUZuEv/qO/0lndaOrPSAaSuZF4DQ75WVukArcZmv2qaMXx
         SiRVh4bi0dIO96A2XKy1qYT4k8ODlb/W/zB+wBruI55Kdqz+/NHk9yb517H6OAKavRGp
         ww2lKDNMuyQwY1savCtFsgg1MlFNmm2FehvzRQvRXSn+vTBLRiGLxiNCFtNe9KV+5/CX
         sM8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=QQifhEvd0qlOro5mq55/v6MzZxcRB/EQ8GzsSLDvKvQ=;
        b=Wx9V8BfWuedfE2xTbAS/bFm/fjJq/5RKEeOUMxXd+EMGvRPEQ4rKvGKi3+PDsOzvSv
         UcwbBBmNGEUFuQKdYoP+uNNVFsgA8GAEbRXZRXx6jv5dmdQZjVJsfShMRC4TPxCJdH8z
         TgAhiOiI6f6Kgr3asCuoJsU39JlyTgxuCoY5WK4Z9Y1q2izVkdPtEKhTT6TFxZuDtUj2
         AiG+sZV2oOz6OpZiu461WOdJQ9VNtBYVx9C0MuTkfaR4bsaJOjh0cMu5mi/JXms5A1bd
         xffqlRiPq0kNvWPK4s+HBMiNyB5RvMZvNXzzsigBpDSNaXljlmP0V2Sl98RukZMeqUEd
         R1Pg==
X-Gm-Message-State: APjAAAVr2FJCjYRUdGaqVlq/SkNEjfkmx+UDfqZ208lAQDBUxOiPfYSV
        2uTcTJ+twExcvBns9/IcmqCX+msW
X-Google-Smtp-Source: APXvYqw5acYxqgdINUs+FyQDAeNUkty8IHAD+FtPNa+5uPBm42ipxImSwOPnn/wLQLHeIRF091ukpw==
X-Received: by 2002:a63:6fca:: with SMTP id k193mr75185418pgc.416.1577722050295;
        Mon, 30 Dec 2019 08:07:30 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t63sm52734279pfb.70.2019.12.30.08.07.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 30 Dec 2019 08:07:29 -0800 (PST)
Date:   Mon, 30 Dec 2019 08:07:27 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB-PD tcpm: bad warning+size, PPS adapters
Message-ID: <20191230160727.GA12958@roeck-us.net>
References: <20191230033544.1809-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191230033544.1809-1-dgilbert@interlog.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 29, 2019 at 10:35:44PM -0500, Douglas Gilbert wrote:
> Augmented Power Delivery Objects (A)PDO_s are used by USB-C
> PD power adapters to advertize the voltages and currents
> they support. There can be up to 7 PDO_s but before PPS
> (programmable power supply) there were seldom more than 4
> or 5. Recently Samsung released an optional PPS 45 Watt power
> adapter (EP-TA485) that has 7 PDO_s. It is for the Galaxy 10+
> tablet and charges it quicker than the adapter supplied at
> purchase. The EP-TA485 causes an overzealous WARN_ON to soil
> the log plus it miscalculates the number of bytes to read.
> 
> So this bug has been there for some time but goes
> undetected for the majority of USB-C PD power adapters on
> the market today that have 6 or less PDO_s. That may soon
> change as more USB-C PD adapters with PPS come to market.
> 
> Tested on a EP-TA485 and an older Lenovo PN: SA10M13950
> USB-C 65 Watt adapter (without PPS and has 4 PDO_s) plus
> several other PD power adapters.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/usb/typec/tcpm/tcpci.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/usb/typec/tcpm/tcpci.c b/drivers/usb/typec/tcpm/tcpci.c
> index c1f7073a56de..8b4ff9fff340 100644
> --- a/drivers/usb/typec/tcpm/tcpci.c
> +++ b/drivers/usb/typec/tcpm/tcpci.c
> @@ -432,20 +432,30 @@ irqreturn_t tcpci_irq(struct tcpci *tcpci)
>  
>  	if (status & TCPC_ALERT_RX_STATUS) {
>  		struct pd_message msg;
> -		unsigned int cnt;
> +		unsigned int cnt, payload_cnt;
>  		u16 header;
>  
>  		regmap_read(tcpci->regmap, TCPC_RX_BYTE_CNT, &cnt);
> +		/*
> +		 * 'cnt' corresponds to READABLE_BYTE_COUNT in section 4.4.14
> +		 * of the TCPCI spec [Rev 2.0 Ver 1.0 October 2017] and is
> +		 * defined in table 4-36 as one greater than the number of
> +		 * bytes received. And that number includes the header. So:
> +		 */
> +		if (cnt > 3)
> +			payload_cnt = cnt - (1 + sizeof(msg.header));
> +		else
> +			payload_cnt = 0;
>  
>  		tcpci_read16(tcpci, TCPC_RX_HDR, &header);
>  		msg.header = cpu_to_le16(header);
>  
> -		if (WARN_ON(cnt > sizeof(msg.payload)))
> -			cnt = sizeof(msg.payload);
> +		if (WARN_ON(payload_cnt > sizeof(msg.payload)))
> +			payload_cnt = sizeof(msg.payload);
>  
> -		if (cnt > 0)
> +		if (payload_cnt > 0)
>  			regmap_raw_read(tcpci->regmap, TCPC_RX_DATA,
> -					&msg.payload, cnt);
> +					&msg.payload, payload_cnt);
>  
>  		/* Read complete, clear RX status alert bit */
>  		tcpci_write16(tcpci, TCPC_ALERT, TCPC_ALERT_RX_STATUS);
> -- 
> 2.24.1
> 
