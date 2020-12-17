Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64AB92DCA4A
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 02:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730913AbgLQBJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 20:09:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35686 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388773AbgLQBJH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Dec 2020 20:09:07 -0500
Received: from mail-ej1-f71.google.com ([209.85.218.71])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <ian.may@canonical.com>)
        id 1kphmL-0000UD-Lb
        for stable@vger.kernel.org; Thu, 17 Dec 2020 01:08:25 +0000
Received: by mail-ej1-f71.google.com with SMTP id u25so8024170ejf.3
        for <stable@vger.kernel.org>; Wed, 16 Dec 2020 17:08:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Lcm/8c06igsmsZgb4Xwrf2Z6LK3MaXdD3n0L9QX8FWk=;
        b=rTtiY2a6PPZj33JLzym5iqicKb8tYIhc/iAxcITmw036TPYPj1ER4ZgRM8/IPO8bQ3
         wbowte8qUwMm6zB4ieKR0r9+cb/9JUYviQJCArkR86y4U9wAWikNQZTalQJfpO0Ps15Y
         8C8cLQl/tmhO7fk93HGLI9DmlgS5frQ64S4uqb/a0yBQFbe2T6Zd7aslXUlYyj6N+A0Z
         M+3r4cikuZewBrpm7x/V15eP2niHgMNgJBlYurNXJ6NVrLpt0Wc0Eb35dYzPsNnoCCaQ
         VjZQod9Sgv7HEp9TlNjT96oqkX6RK62becfA9T8TmrE/49MyUSsdzefjgsAxn0UDKZQ2
         rlQA==
X-Gm-Message-State: AOAM5330ZyHFCaHg06I1LJmCQAbqZGzO0qOUdCxu0n80V7hWXdHA8ATZ
        6c8z4FBbEX+FUL8NF9q5OyYYqCLGzxrVyRBdrINqttGj8TNtnVNnubDunr/By/GuofIldmEglO1
        qt1jJB/S3LJTKu8V25NT2iu7Yz1wmu2Txxg==
X-Received: by 2002:a17:906:8151:: with SMTP id z17mr33559936ejw.48.1608167305261;
        Wed, 16 Dec 2020 17:08:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxVunPiz/rg+9ifBQykI+MLHKhPaMml9aQyJHMuqh1+0z2hSr3+8Dq0InYdP+5I13LH/TeQ0Q==
X-Received: by 2002:a17:906:8151:: with SMTP id z17mr33559920ejw.48.1608167305007;
        Wed, 16 Dec 2020 17:08:25 -0800 (PST)
Received: from uws ([2001:67c:1562:8007::aac:44bb])
        by smtp.gmail.com with ESMTPSA id b9sm2570973eju.8.2020.12.16.17.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 17:08:24 -0800 (PST)
Date:   Wed, 16 Dec 2020 19:08:21 -0600
From:   Ian May <ian.may@canonical.com>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     kernel-team@lists.ubuntu.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        stable@vger.kernel.org
Subject: APPLIED[X/B/F/G]: [X/B/F/G/H/Unstable][SRU][PATCH 1/1] Input: i8042
 - add ByteSpeed touchpad to noloop table
Message-ID: <20201217010821.GA2453520@uws>
References: <20201210061415.35591-1-po-hsu.lin@canonical.com>
 <20201210061415.35591-2-po-hsu.lin@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210061415.35591-2-po-hsu.lin@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Applied to:
  xenial/linux
  bionic/linux
  focal/linux
  groovy/linux

Thanks,
Ian

On 2020-12-10 14:14:15 , Po-Hsu Lin wrote:
> BugLink: https://bugs.launchpad.net/bugs/1906128
> 
> It looks like the C15B laptop got another vendor: ByteSpeed LLC.
> 
> Avoid AUX loopback on this touchpad as well, thus input subsystem will
> be able to recognize a Synaptics touchpad in the AUX port.
> 
> BugLink: https://bugs.launchpad.net/bugs/1906128
> Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
> Link: https://lore.kernel.org/r/20201201054723.5939-1-po-hsu.lin@canonical.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> (cherry picked from commit a48491c65b513e5cdc3e7a886a4db915f848a5f5)
> Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
> ---
>  drivers/input/serio/i8042-x86ia64io.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
> index 82ff446..1f45010 100644
> --- a/drivers/input/serio/i8042-x86ia64io.h
> +++ b/drivers/input/serio/i8042-x86ia64io.h
> @@ -223,6 +223,10 @@ static const struct dmi_system_id __initconst i8042_dmi_noloop_table[] = {
>  			DMI_MATCH(DMI_SYS_VENDOR, "PEGATRON CORPORATION"),
>  			DMI_MATCH(DMI_PRODUCT_NAME, "C15B"),
>  		},
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "ByteSpeed LLC"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "ByteSpeed Laptop C15B"),
> +		},
>  	},
>  	{ }
>  };
> -- 
> 2.7.4
> 
> 
> -- 
> kernel-team mailing list
> kernel-team@lists.ubuntu.com
> https://lists.ubuntu.com/mailman/listinfo/kernel-team
