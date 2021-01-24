Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80FB301D44
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 16:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbhAXPoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 10:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbhAXPoD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 10:44:03 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13B1C061573;
        Sun, 24 Jan 2021 07:43:22 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id m13so4066817oig.8;
        Sun, 24 Jan 2021 07:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Bo6kUYO3pwMFgdIFXAmNR9K4yJpzflY5EGuS3YrSaNE=;
        b=kMXRZz+/sr1wWgKfH06UtjqxWu19ELlJCGf/IWQv7EVdle9Z+WRXAOjcU5/zjYRUeP
         nWtyEDzIhBA6mNTcxhoRKVmYSzPtcdgB7v3urpepg+Xeqv+IAPadx5jOPT1ghfrDgf3h
         R05HyI2DkrejsdKEkuN8ab9liJYMDu5EcH1Hy3iG+t/Uw9afOlfjd5eksWq44LjZlzOA
         DEPI8AbI2N6NRZtU1e6XzB5aiZ2n9GvBcfqaouNpNT8WDTeYaGN/hqqEnosY434gP0d9
         qRGF3qS8GT68bLg5E/SqK03UI2Y+T4pc+8LOejwWIIcAs1U4NfzVs8WMlrKiLFBJ2j+k
         yELg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Bo6kUYO3pwMFgdIFXAmNR9K4yJpzflY5EGuS3YrSaNE=;
        b=Qh08bpi8ZmPENwO2mOTCBP1MS23fDlK9hOrVEfNWhq+x9pKcqtNdL9KL+8KnPUyfie
         ngt5CZmesBxPwxWvrwtDMVs79YQ40aagnBUeMgYkhnTcZflSwdr6fThaJiGYGAZRphxu
         dZok687KYdMXq+iih1pe8OT3noaZTr+Y57NXQ+/9UBYgSgpV1sYd5GnaK/n2HGw+ktrH
         hdtGvyJSXSvXuUHnpXvwrTPhhQeI5i5A4FfSjlGynL/VrF6yvAPk6eaw5FXMzoq7DePk
         CbhcalXf8lcHANUcyiyH9dyeFJNrJs2XokQ7ayCFuHVM5lAoDa0oi9Aq60xsUSvkJ+eS
         ruYA==
X-Gm-Message-State: AOAM531o7tJOt2Sd9BC1J+GhjH+IctGF4HDK+ghKm+51UF6zMsudtt+L
        k2M3dgwx+wxpOdzAME/7p/euI92rsWw=
X-Google-Smtp-Source: ABdhPJyK/JuUxjpH4Fs3hS3HTu2O2/giVK5KHSiCASjvyFE42mAAza1So48xqtpEBvrDhyIpRGKpQg==
X-Received: by 2002:aca:5bd4:: with SMTP id p203mr8872682oib.108.1611503002098;
        Sun, 24 Jan 2021 07:43:22 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h127sm2942263oia.28.2021.01.24.07.43.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 24 Jan 2021 07:43:21 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sun, 24 Jan 2021 07:43:20 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Tomas Winkler <tomas.winkler@intel.com>
Cc:     Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        stable@vger.kernel.org
Subject: Re: [watchdog v2] watchdog: mei_wdt: request stop on unregister
Message-ID: <20210124154320.GA131753@roeck-us.net>
References: <20210124114938.373885-1-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210124114938.373885-1-tomas.winkler@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 24, 2021 at 01:49:38PM +0200, Tomas Winkler wrote:
> From: Alexander Usyskin <alexander.usyskin@intel.com>
> 
> The MEI bus has a special behavior on suspend it destroys
> all the attached devices, this is due to the fact that also
> firmware context is not persistent across power flows.
> 
> If watchdog on MEI bus is ticking before suspending the firmware
> times out and reports that the OS is missing watchdog tick.
> Send the stop command to the firmware on watchdog unregistered
> to eliminate the false event on suspend.
> This does not make the things worse from the user-space perspective
> as a user-space should re-open watchdog device after
> suspending before this patch.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
> V2: Update the commit message with better explanation
> 
>  drivers/watchdog/mei_wdt.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/watchdog/mei_wdt.c b/drivers/watchdog/mei_wdt.c
> index 5391bf3e6b11..c5967d8b4256 100644
> --- a/drivers/watchdog/mei_wdt.c
> +++ b/drivers/watchdog/mei_wdt.c
> @@ -382,6 +382,7 @@ static int mei_wdt_register(struct mei_wdt *wdt)
>  
>  	watchdog_set_drvdata(&wdt->wdd, wdt);
>  	watchdog_stop_on_reboot(&wdt->wdd);
> +	watchdog_stop_on_unregister(&wdt->wdd);
>  
>  	ret = watchdog_register_device(&wdt->wdd);
>  	if (ret)
> -- 
> 2.26.2
> 
