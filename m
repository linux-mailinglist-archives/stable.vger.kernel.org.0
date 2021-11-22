Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7746045918B
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 16:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239930AbhKVPpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 10:45:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48453 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231697AbhKVPpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 10:45:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637595718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JpH0Jkovi9K+tAJod1tvkLzMmn8RBtpJbJgqMBgGJZI=;
        b=K7ZDfCFUVuH0UCrYf811yhClkVZAu2Udjq2H1wlq/Lz+5k8SXdY9xn+pFYdprheDJbPjtd
        OXjT07wC0tDB8i1pigeU3a6poKEhSaeCH2bsh+ZEYV1yGIxBGMxop4JQuu/VRUKqpQlF8/
        tVGGhhhfGlmUlpm18QXj++ZzBwyEP/s=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-utEiNgEvN9uetNqXR7e6pA-1; Mon, 22 Nov 2021 10:41:57 -0500
X-MC-Unique: utEiNgEvN9uetNqXR7e6pA-1
Received: by mail-ed1-f71.google.com with SMTP id b15-20020aa7c6cf000000b003e7cf0f73daso15106660eds.22
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 07:41:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JpH0Jkovi9K+tAJod1tvkLzMmn8RBtpJbJgqMBgGJZI=;
        b=4/lvlzuzDtok/ViHxGh6V9DGCrT5Fse59g04cJmkZLjUA6689QisUv5LowN7mpM+NL
         8ZEvwwK15h17O0xtRRrklGkV8L58lJuxgikrKjv+JoeDOeb5gF+R9DqqUmM9IHEa5P9n
         j0w9R/C6ykMhXHbajXUgrBWk+mzaC52q7BOOZFGMqxS9965fBZRjrVosjsThGLn3aBve
         7mcJK7GlvZDSsiVfj0cvLJDbhtVzsDaEI2UkoAG4YkL0/x//kE0EMrBNPHT4hUF1DH66
         a+WdcBIeIqr7bxMyFiFuyVAoDkn7LM4KfdV17hgAfl+YNTgdxz3EseKmE53NFIWULqgv
         haeg==
X-Gm-Message-State: AOAM533kvTH2+PiBtDZDcoEeOjgKVO0qcPJLDD6dZbXr26sT02IVdwWz
        6GG3zNw/NrVXf0ni4M5fKf9jwKlD25QTThhrq18iGRObiE4TvstrtIhq3llw01jtZQ2LTU+2wHF
        8AMQjYt9R0a77wcyf
X-Received: by 2002:a05:6402:289e:: with SMTP id eg30mr65889759edb.253.1637595716372;
        Mon, 22 Nov 2021 07:41:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx4ryiA+oOZhsMU1H219z3VLft5AYNHxxM6VNjWf4I+q6O5/5UD5vkKTKChWvUHWQDeIC5I9A==
X-Received: by 2002:a05:6402:289e:: with SMTP id eg30mr65889716edb.253.1637595716180;
        Mon, 22 Nov 2021 07:41:56 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:1054:9d19:e0f0:8214? (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id hr11sm3999873ejc.108.2021.11.22.07.41.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 07:41:55 -0800 (PST)
Message-ID: <132b6778-91e7-d758-2636-9561e5aa347f@redhat.com>
Date:   Mon, 22 Nov 2021 16:41:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [RFT PATCH] usb: hub: Fix locking issues with address0_mutex
Content-Language: en-US
To:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        m.szyprowski@samsung.com, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, kishon@ti.com
Cc:     chris.chiu@canonical.com, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
References: <1d6ef5ff-e5e2-b81e-42be-7876b5bcfd05@linux.intel.com>
 <20211122105003.1089218-1-mathias.nyman@linux.intel.com>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20211122105003.1089218-1-mathias.nyman@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 11/22/21 11:50, Mathias Nyman wrote:
> Fix the circular lock dependency and unbalanced unlock of addess0_mutex
> introduced when fixing an address0_mutex enumeration retry race in commit
> ae6dc22d2d1 ("usb: hub: Fix usb enumeration issue due to address0 race")
> 
> Make sure locking order between port_dev->status_lock and address0_mutex
> is correct, and that address0_mutex is not unlocked in hub_port_connect
> "done:" codepath which may be reached without locking address0_mutex
> 
> Fixes: 6ae6dc22d2d1 ("usb: hub: Fix usb enumeration issue due to address0 race")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

Oh, this is great, with this patch I can finally hot-plug my
thunderbolt dock (and thus a XHCI controller) without the XHCI
controller given a whole bunch of weird errors (and some USB
devices not working), which it does not when already connected at boot.

I also tried the hotplug thingy with the previous fix without
this locking fix and then I actually hit the deadlock and things
like lsusb would hang.

If we can get these 2 fixes together merged soon and also backported
to the stable series that would be great:

Acked-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans







> ---
>  drivers/usb/core/hub.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index 00c3506324e4..00070a8a6507 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -5188,6 +5188,7 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
>  	struct usb_port *port_dev = hub->ports[port1 - 1];
>  	struct usb_device *udev = port_dev->child;
>  	static int unreliable_port = -1;
> +	bool retry_locked;
>  
>  	/* Disconnect any existing devices under this port */
>  	if (udev) {
> @@ -5244,10 +5245,10 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
>  
>  	status = 0;
>  
> -	mutex_lock(hcd->address0_mutex);
> -
>  	for (i = 0; i < PORT_INIT_TRIES; i++) {
> -
> +		usb_lock_port(port_dev);
> +		mutex_lock(hcd->address0_mutex);
> +		retry_locked = true;
>  		/* reallocate for each attempt, since references
>  		 * to the previous one can escape in various ways
>  		 */
> @@ -5255,6 +5256,8 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
>  		if (!udev) {
>  			dev_err(&port_dev->dev,
>  					"couldn't allocate usb_device\n");
> +			mutex_unlock(hcd->address0_mutex);
> +			usb_unlock_port(port_dev);
>  			goto done;
>  		}
>  
> @@ -5276,13 +5279,13 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
>  		}
>  
>  		/* reset (non-USB 3.0 devices) and get descriptor */
> -		usb_lock_port(port_dev);
>  		status = hub_port_init(hub, udev, port1, i);
> -		usb_unlock_port(port_dev);
>  		if (status < 0)
>  			goto loop;
>  
>  		mutex_unlock(hcd->address0_mutex);
> +		usb_unlock_port(port_dev);
> +		retry_locked = false;
>  
>  		if (udev->quirks & USB_QUIRK_DELAY_INIT)
>  			msleep(2000);
> @@ -5372,11 +5375,14 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
>  
>  loop_disable:
>  		hub_port_disable(hub, port1, 1);
> -		mutex_lock(hcd->address0_mutex);
>  loop:
>  		usb_ep0_reinit(udev);
>  		release_devnum(udev);
>  		hub_free_dev(udev);
> +		if (retry_locked) {
> +			mutex_unlock(hcd->address0_mutex);
> +			usb_unlock_port(port_dev);
> +		}
>  		usb_put_dev(udev);
>  		if ((status == -ENOTCONN) || (status == -ENOTSUPP))
>  			break;
> @@ -5399,8 +5405,6 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
>  	}
>  
>  done:
> -	mutex_unlock(hcd->address0_mutex);
> -
>  	hub_port_disable(hub, port1, 1);
>  	if (hcd->driver->relinquish_port && !hub->hdev->parent) {
>  		if (status != -ENOTCONN && status != -ENODEV)
> 

