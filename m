Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667F138384A
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244730AbhEQPvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245566AbhEQPsx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 11:48:53 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E39C07E5FC;
        Mon, 17 May 2021 07:38:31 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id ez19so3194294qvb.3;
        Mon, 17 May 2021 07:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uNcMlxmGe0/KHpC/yKgEws6zzml6blB7GcOty29DOBI=;
        b=kqLqC53Mu3wSLvV9gQtWSdGf6U/KsZd1lLq9SusTQeIg3BVK3J66/3F2eJtYNAQkzb
         22/9oIWqk+jx/Yy/UEYg/RkbCwVYCPKYxUohmwkjaR31UIPVa6hdKrnn6mACi961hlZX
         HxMYsE8jzKidtjb8LvWVmpLhS3YTaKjfJ3cFdV2NAgsnyiSECLLFzn0Mz/hVnKmzAbvb
         P///s1NE3EkQykKejmi0yShD9dfz8BFclJcpHTQgj4I2evBU2y0JfBJU/wtVa164SMXv
         eFKOouzbX2ktygTOzifMkrRCAeWB07KabKYeEB1yRGoLne0XRpS2scApgwRFVpMYj2km
         ZHmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=uNcMlxmGe0/KHpC/yKgEws6zzml6blB7GcOty29DOBI=;
        b=LshZ+S2fuOfeQHJzSuOXfy2zA8Ulhb39dpx0PDvNluLaaRtfEiEBNEEUzxFQicN8WF
         mh38nGXDOcFgmrGuVDf9/lB47hbFf/sCkEUKXt6J3bwG/NmucDe2tIhv0N8rOxS1Wbwc
         jyKKaDeWlNU3tqeDT2pm8XHS8gRuFDnZCyyCuzQ/8jxbNafciy7kqfzsUNe8iH0flY10
         eWZR16U9Fy7mbG1buhQ2bg3LXcZbFh+Q7WZmw3clOTyhbNG756g7CzdSSJj4I0Yypw5I
         sG7dZHs5q7TNoGPP4VgXZ3Ig7r0PlekWxNQEznPAvMQzE8YR1aXWj/IWcOx7PMe2W1/z
         hS/A==
X-Gm-Message-State: AOAM533Q0T8SRyGIqTuU8lVDFOlJrzHL03pBs2bJMfBTeNLDPOd46org
        7gQZjYXiGP6W7fg4bHIQAl+mgsYJmxU=
X-Google-Smtp-Source: ABdhPJw9LSemMfJJH/rTL2PbCi3+OqjPZ7U4FmtlxTu4RXABkFM4zki/rzxOuXL2kngcSpckwjhJ3Q==
X-Received: by 2002:a0c:9ccc:: with SMTP id j12mr60481248qvf.30.1621262310662;
        Mon, 17 May 2021 07:38:30 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c9sm4086104qke.8.2021.05.17.07.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 07:38:30 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 17 May 2021 07:38:28 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1 4/4] usb: typec: tcpci: Implement callback for apply_rc
Message-ID: <20210517143828.GC3434992@roeck-us.net>
References: <20210515052613.3261340-1-badhri@google.com>
 <20210515052613.3261340-4-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210515052613.3261340-4-badhri@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 14, 2021 at 10:26:13PM -0700, Badhri Jagan Sridharan wrote:
> APPLY RC is defined as ROLE_CONTROL.CC1 != ROLE_CONTROL.CC2 and
> POWER_CONTROL.AutodischargeDisconnect is 0. When ROLE_CONTROL.CC1 ==
> ROLE_CONTROL.CC2, set the other CC to OPEN.
> 
> Fixes: f321a02caebd ("usb: typec: tcpm: Implement enabling Auto Discharge disconnect support")
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/usb/typec/tcpm/tcpci.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/drivers/usb/typec/tcpm/tcpci.c b/drivers/usb/typec/tcpm/tcpci.c
> index 25b480752266..34b5095cc84f 100644
> --- a/drivers/usb/typec/tcpm/tcpci.c
> +++ b/drivers/usb/typec/tcpm/tcpci.c
> @@ -115,6 +115,32 @@ static int tcpci_set_cc(struct tcpc_dev *tcpc, enum typec_cc_status cc)
>  	return 0;
>  }
>  
> +int tcpci_apply_rc(struct tcpc_dev *tcpc, enum typec_cc_status cc, enum typec_cc_polarity polarity)
> +{
> +	struct tcpci *tcpci = tcpc_to_tcpci(tcpc);
> +	unsigned int reg;
> +	int ret;
> +
> +	ret = regmap_read(tcpci->regmap, TCPC_ROLE_CTRL, &reg);
> +	if (ret < 0)
> +		return ret;
> +
> +	/*
> +	 * APPLY_RC state is when ROLE_CONTROL.CC1 != ROLE_CONTROL.CC2 and vbus autodischarge on
> +	 * disconnect is disabled. Bail out when ROLE_CONTROL.CC1 != ROLE_CONTROL.CC2.
> +	 */
> +	if (((reg & (TCPC_ROLE_CTRL_CC2_MASK << TCPC_ROLE_CTRL_CC2_SHIFT)) >>
> +	     TCPC_ROLE_CTRL_CC2_SHIFT) !=
> +	    ((reg & (TCPC_ROLE_CTRL_CC1_MASK << TCPC_ROLE_CTRL_CC1_SHIFT)) >>
> +	     TCPC_ROLE_CTRL_CC1_SHIFT))
> +		return 0;
> +
> +	return regmap_update_bits(tcpci->regmap, TCPC_ROLE_CTRL, polarity == TYPEC_POLARITY_CC1 ?
> +				  TCPC_ROLE_CTRL_CC2_MASK << TCPC_ROLE_CTRL_CC2_SHIFT :
> +				  TCPC_ROLE_CTRL_CC1_MASK << TCPC_ROLE_CTRL_CC1_SHIFT,
> +				  TCPC_ROLE_CTRL_CC_OPEN);
> +}
> +
>  static int tcpci_start_toggling(struct tcpc_dev *tcpc,
>  				enum typec_port_type port_type,
>  				enum typec_cc_status cc)
> @@ -728,6 +754,7 @@ struct tcpci *tcpci_register_port(struct device *dev, struct tcpci_data *data)
>  	tcpci->tcpc.get_vbus = tcpci_get_vbus;
>  	tcpci->tcpc.set_vbus = tcpci_set_vbus;
>  	tcpci->tcpc.set_cc = tcpci_set_cc;
> +	tcpci->tcpc.apply_rc = tcpci_apply_rc;
>  	tcpci->tcpc.get_cc = tcpci_get_cc;
>  	tcpci->tcpc.set_polarity = tcpci_set_polarity;
>  	tcpci->tcpc.set_vconn = tcpci_set_vconn;
> -- 
> 2.31.1.751.gd2f1c929bd-goog
> 
