Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE88611ED8D
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 23:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfLMWIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 17:08:34 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:43102 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbfLMWIe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Dec 2019 17:08:34 -0500
Received: by mail-pj1-f67.google.com with SMTP id g4so292309pjs.10;
        Fri, 13 Dec 2019 14:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7dzeTGvEWaXwCU0pEGUFfZrs2Lez7D5h842KFDNW1lY=;
        b=AfTTzL4+Pfly5/oyA+zs0bpgNWCC+IfQnj7pVlLHTGYHfsphcN/66SjHPiqJighlRE
         +R7fcOJsOI5p/d7EnMl8DuINrzOavP6ivjoxZcuSD0jnGa+LvOQBSOqdDkrq5QcNIC8F
         2iAjkDrXtl4pU7MrBdltfMxBiKVV5sUSm1icEPhWjzJcP7UEWFSa7d0x/D4Z0PJawLGy
         zHNSJZpWCZsrRxS2JyLh4WRm6VuuHYQ5iFnlS+eMfpUPldUrkekGjCB5UvHiFyxHcieb
         1rLTL9saeJ6ee+cTsFq8nxJJtE2k8bN0qexVO9uPb1OD5bdG/Ae9vQVVdOFsGecxKRrD
         lOkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7dzeTGvEWaXwCU0pEGUFfZrs2Lez7D5h842KFDNW1lY=;
        b=UIKTbpKYyBX3xWjQOb+9QXK2jiOYIZmSZW06eWVRqkiMo58myvwodB+MullO99/OHJ
         CLl8KbFwuzHWolFyrRShrlmfjNcFMz5WKInFXBYzRclxjeG9YAmkwvk3LFPTN3CibhQv
         nBGhpio3mxlaSEYQ8tHUvE3nDoI6hpT4FrFFs4s4nDyw4TL5nAEYsHeSirXsq73Yyh8d
         WC7fA+3MkZC86ThQzJcZFHPMQX/dXHFMbU6VxJ9NbI10cu9XRQk3h5GosHyeZJ9in/5p
         vP13gEzsQqbCMJsmJYOOPmD9iEmOyqQUxjD6cdcEvRTvnjuhk19EOXSP9UZPLNdCTXkV
         bzcQ==
X-Gm-Message-State: APjAAAVMeJYRTMfrZl3xhcApug81qlwDjoas2x2ylAOEEu9O8RTCjdfQ
        erXpnfl0znwmMIGNe+rmcY8=
X-Google-Smtp-Source: APXvYqyufZ9wIZF7dBSTY7R7BxUMfmNLG0jNaqfyjVA7RjnVzIW1aX6yFfHII9/k4TPLH5FZrUb1yQ==
X-Received: by 2002:a17:90a:3702:: with SMTP id u2mr1869026pjb.112.1576274913259;
        Fri, 13 Dec 2019 14:08:33 -0800 (PST)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id e1sm12984954pfl.98.2019.12.13.14.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 14:08:32 -0800 (PST)
Date:   Fri, 13 Dec 2019 14:08:30 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        sparclinux@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lubomir Rintel <lkundrak@v3.sk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v2 01/24] Input: input_event: fix struct padding on
 sparc64
Message-ID: <20191213220830.GK101194@dtor-ws>
References: <20191213204936.3643476-1-arnd@arndb.de>
 <20191213204936.3643476-2-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213204936.3643476-2-arnd@arndb.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 13, 2019 at 09:49:10PM +0100, Arnd Bergmann wrote:
> Going through all uses of timeval, I noticed that we screwed up
> input_event in the previous attempts to fix it:
> 
> The time fields now match between kernel and user space, but
> all following fields are in the wrong place.
> 
> Add the required padding that is implied by the glibc timeval
> definition to fix the layout, and use a struct initializer
> to avoid leaking kernel stack data.
> 
> Cc: sparclinux@vger.kernel.org
> Cc: "David S. Miller" <davem@davemloft.net>
> Fixes: 141e5dcaa735 ("Input: input_event - fix the CONFIG_SPARC64 mixup")
> Fixes: 2e746942ebac ("Input: input_event - provide override for sparc64")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied, thank you.

> ---
>  drivers/input/evdev.c       | 14 +++++++-------
>  drivers/input/misc/uinput.c | 14 +++++++++-----
>  include/uapi/linux/input.h  |  1 +
>  3 files changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index d7dd6fcf2db0..f918fca9ada3 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -224,13 +224,13 @@ static void __pass_event(struct evdev_client *client,
>  		 */
>  		client->tail = (client->head - 2) & (client->bufsize - 1);
>  
> -		client->buffer[client->tail].input_event_sec =
> -						event->input_event_sec;
> -		client->buffer[client->tail].input_event_usec =
> -						event->input_event_usec;
> -		client->buffer[client->tail].type = EV_SYN;
> -		client->buffer[client->tail].code = SYN_DROPPED;
> -		client->buffer[client->tail].value = 0;
> +		client->buffer[client->tail] = (struct input_event) {
> +			.input_event_sec = event->input_event_sec,
> +			.input_event_usec = event->input_event_usec,
> +			.type = EV_SYN,
> +			.code = SYN_DROPPED,
> +			.value = 0,
> +		};
>  
>  		client->packet_head = client->tail;
>  	}
> diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
> index fd253781be71..2dabbe47d43e 100644
> --- a/drivers/input/misc/uinput.c
> +++ b/drivers/input/misc/uinput.c
> @@ -74,12 +74,16 @@ static int uinput_dev_event(struct input_dev *dev,
>  	struct uinput_device	*udev = input_get_drvdata(dev);
>  	struct timespec64	ts;
>  
> -	udev->buff[udev->head].type = type;
> -	udev->buff[udev->head].code = code;
> -	udev->buff[udev->head].value = value;
>  	ktime_get_ts64(&ts);
> -	udev->buff[udev->head].input_event_sec = ts.tv_sec;
> -	udev->buff[udev->head].input_event_usec = ts.tv_nsec / NSEC_PER_USEC;
> +
> +	udev->buff[udev->head] = (struct input_event) {
> +		.input_event_sec = ts.tv_sec,
> +		.input_event_usec = ts.tv_nsec / NSEC_PER_USEC,
> +		.type = type,
> +		.code = code,
> +		.value = value,
> +	};
> +
>  	udev->head = (udev->head + 1) % UINPUT_BUFFER_SIZE;
>  
>  	wake_up_interruptible(&udev->waitq);
> diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
> index f056b2a00d5c..9a61c28ed3ae 100644
> --- a/include/uapi/linux/input.h
> +++ b/include/uapi/linux/input.h
> @@ -34,6 +34,7 @@ struct input_event {
>  	__kernel_ulong_t __sec;
>  #if defined(__sparc__) && defined(__arch64__)
>  	unsigned int __usec;
> +	unsigned int __pad;
>  #else
>  	__kernel_ulong_t __usec;
>  #endif
> -- 
> 2.20.0
> 

-- 
Dmitry
