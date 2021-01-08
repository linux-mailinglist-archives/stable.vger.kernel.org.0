Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05272EEA2E
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 01:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbhAHAM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 19:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbhAHAM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 19:12:58 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA60C0612FD;
        Thu,  7 Jan 2021 16:12:18 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id w3so8054793otp.13;
        Thu, 07 Jan 2021 16:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7awMrrXbbRZlFjELQblbcca5XJ2hq7NWilko+Rp2Mb0=;
        b=DGXV5RV9l4jRJAp6xgVc3M1ccE0Leq67iocEPUPYLDgXKV3gfw9D/Uq9oFmxEy8/IO
         vzBizd3qtlCblnryvaMOzgesGExCF1JPvNAEqEoIFCRJMrpSz5uvZpLGK1nlR0JqINUC
         rzn4XUDxNEItNY5nK+uFpih/5r6RCuZQ2OGdyKDlgFlt4ArYvbRmSN6Rm8bHrcrnRSDq
         rEgajVQYzGeyCKXvvkAa8bR1H3SNPywOPi0cTLJEepv3WRMRPh+8LhB7W2DqunJNdU84
         2inBVmSxMRgRP0iedGmcZfdfE9rxDwnuUPfGDq4IsTIxI8kXpNDYfWOK3epLMz9Ykgg1
         NIxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=7awMrrXbbRZlFjELQblbcca5XJ2hq7NWilko+Rp2Mb0=;
        b=ntDTEXtUD1UXmGhcchQCN2YKY+uWMJlNgjs2rdOkaSb/GREb7T+XN43RXS92mPEx6S
         tmOQPfy8119Ac39MX5c0HUqegY+VXioIaCO2XwoMQ0xW1DEJkM0Ja+x1chUBR/a9j8qv
         75lcNvRxKOLVXkQk2fBL/XyiAGfw4gnxtW4e02a3r+pe5EKiuks50qrKc3/eIZS6fP9t
         ffxcT3RyW/qYaw/3v4YLGan7r9SfszpPBY8ZzsnKzfnqJPEcvy7B4mJ6UhS3PEujpb2L
         SUXN7Ayv82LPBH/II6Olso0IA8Tz2DDkpf+zhNAF5Ls2nERBvegWL/sGDo6Wkeae1pUl
         8BLg==
X-Gm-Message-State: AOAM5305r2407JX5SEl6crFWpncL/sEKw0xUqmyVINzlaLdGfvSAxnsl
        zsKXyGoEX6dcvfALYY2ZdtU=
X-Google-Smtp-Source: ABdhPJxBsX6DvU7jdYpHuJXQiBlJAgmVofzXk61M+Gm5CKWUf9GQ4YtLGlxNffvdrchFTTZPYkM0PQ==
X-Received: by 2002:a05:6830:403a:: with SMTP id i26mr741161ots.111.1610064737867;
        Thu, 07 Jan 2021 16:12:17 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g3sm1423611ooi.28.2021.01.07.16.12.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 Jan 2021 16:12:16 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 7 Jan 2021 16:12:15 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Tomas Winkler <tomas.winkler@intel.com>
Cc:     Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        stable@vger.kernel.org
Subject: Re: [watchdog] watchdog: mei_wdt: request stop on unregister
Message-ID: <20210108001215.GA58926@roeck-us.net>
References: <20210107195730.1660449-1-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107195730.1660449-1-tomas.winkler@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Thu, Jan 07, 2021 at 09:57:30PM +0200, Tomas Winkler wrote:
> From: Alexander Usyskin <alexander.usyskin@intel.com>
> 
> Send the stop command to the firmware on watchdog unregister
> to eleminate false event on suspend.
> 

Normally the watchdog driver would not be expected to unregister
during suspend, only when the driver is manually unloaded.
To support suspend/resume, other watchdog drivers implement
suspend/resume functions to stop the watchdog on suspend and
to restart it on resume. Unloading a watchdog driver on suspend
would also have odd implications for userspace watchdog daemons.

On top of that, it should not actually be possible to unregister
a watchdog while it is in use (because it is open in that case
and should be marked as busy). watchdog_stop_on_unregister()
only serves as backup in case someone actually manages to unload
the driver while the watchdog is running. The function was
implemented to avoid calls to stop the watchdog in the remove
function because I can not mathematically prove that there are
no situations where the watchdog is unloaded while running.
However, I have not actually been able to do that.

Are you sure this patch is doing what you expect it to do ?

Thanks,
Guenter

> Cc: <stable@vger.kernel.org>
> Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
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
