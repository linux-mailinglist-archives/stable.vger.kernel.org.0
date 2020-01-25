Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3505149735
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 19:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgAYShH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jan 2020 13:37:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29290 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726300AbgAYShH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jan 2020 13:37:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579977426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JFT3buwsDHilRidy9DdVxUMO6CwAHjVI733OjaznBgI=;
        b=FOMpgJfSuIDyfDjlcg3/rwK3DYQ24PiTZ68CjVdXWHdDdKA0hWwkGP3r1DeoUpOuv4cEvQ
        l3N2PJOGWTXg0iXtuNzjybjzFIAHSMBexthFHchU1zYTL/1PcSlhsKJHaAVzl8e6IovU/g
        d/Of5wzP++qOOEdC88mh8swub0UGo8o=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-LmkIh6lrOse-vbAvHEUXRg-1; Sat, 25 Jan 2020 13:37:04 -0500
X-MC-Unique: LmkIh6lrOse-vbAvHEUXRg-1
Received: by mail-wr1-f72.google.com with SMTP id z15so3377948wrw.0
        for <stable@vger.kernel.org>; Sat, 25 Jan 2020 10:37:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JFT3buwsDHilRidy9DdVxUMO6CwAHjVI733OjaznBgI=;
        b=Dez1rEnWabsYstKj1N7W+QRY6RdU5NpVkjQP74Nsi6efnUoO+x/m2q6fmPFUMrfWjh
         4lrMjBnbtC0Yeul6N9UoBPDyXKEH8M+Z6DHTIfQWi4Xpi/sOEDWa8IDNCZGoqietlyXy
         i2ROB2hTpPz1ICfQJxelHcK9SqbA2YN+/jkCcYwhzFYHf0XL34ijfq7jAKLrkftrFu5u
         YRGUV8Wwh+z/g+oxQgrRo4kx7H6/ZiV6RcKvKR5EzEXIKqrMDZAnc8XhxGKhwgy985SF
         Q1EeoIhLCSQmXWQu0lrtFKOptzwdHH1TQ3mlP28SX7ktY5NvS8ZqEBFbz3B0nvfmIVmx
         cS1A==
X-Gm-Message-State: APjAAAX2b4xErBYt9wNvp4uDbYFep1zXEuMUoaox+n3BD57KWJ7QdzcP
        jqiZfvdD0Bkr5YJIazo++y+OKsG7uJvywO7g/8ts1NSaMLAQPv08IZsiOe7sv65b8hmiQ5DJsdH
        5Cg74kIp15q+xnLmT
X-Received: by 2002:adf:f288:: with SMTP id k8mr12155748wro.301.1579977423425;
        Sat, 25 Jan 2020 10:37:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqxyKXb/IHb/Bmj8rtpUpHFjt3gUQWbfOgudeoOGgCvqXdstE5UJ9DaEKk4dhxwDrj6PGdU4cQ==
X-Received: by 2002:adf:f288:: with SMTP id k8mr12155734wro.301.1579977423229;
        Sat, 25 Jan 2020 10:37:03 -0800 (PST)
Received: from dhcp-44-196.space.revspace.nl ([2a0e:5700:4:11:6eb:1143:b8be:2b8])
        by smtp.gmail.com with ESMTPSA id y185sm5902841wmg.2.2020.01.25.10.37.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jan 2020 10:37:02 -0800 (PST)
Subject: Re: [PATCH v2] USB: uas: Add the no-UAS quirk for JMicron JMS561U
To:     Tim Schumacher <timschumi@gmx.de>
Cc:     stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
References: <20200125064838.2511-1-timschumi@gmx.de>
 <20200125170030.25331-1-timschumi@gmx.de>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <fccf2105-d415-7f44-e111-729d2d517ea7@redhat.com>
Date:   Sat, 25 Jan 2020 19:37:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200125170030.25331-1-timschumi@gmx.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 1/25/20 6:00 PM, Tim Schumacher wrote:
> The JMicron JMS561U (notably used in the Sabrent SATA-to-USB
> bridge) appears to have UAS-related issues when copying large
> amounts of data, causing it to stall.
> 
> Disabling the advertised UAS (either through a command-line
> quirk or through this patch) mitigates those issues.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Tim Schumacher <timschumi@gmx.de>

Hmm, this is a quiete popular usb2sata bridge and disabling uas
is quite bad for performance.

I notice that there is no link to a bug report and AFAIK we have
no one else reporting this issue.

So this feels like a much too big hammer for the problem which you
are seeing.

When you say "stall" what exactly happens? Do you see any errors
in dmesg for example?

Also note that using UAS, since it has much better performance,
will often expose bugs which are not caused by it. One typical
example is bus-powered devices where the USB port does not deliver
enough power (typically the driver draws more then the port
guanrantees). Copying large amounts of data on a fast device is
a good way to make the current consumption go up and thus
trigger these kind of issues.  Does the driver enclosure
you see this on use a separate power supply, or is it
bus-powered?

Regards,

Hans



> ---
> v2: Fixed entry order. Also, CCing the correct people now.
> ---
>   drivers/usb/storage/unusual_uas.h | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
> index 1b23741036ee..a590f4a0d4b9 100644
> --- a/drivers/usb/storage/unusual_uas.h
> +++ b/drivers/usb/storage/unusual_uas.h
> @@ -73,6 +73,13 @@ UNUSUAL_DEV(0x152d, 0x0578, 0x0000, 0x9999,
>   		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>   		US_FL_BROKEN_FUA),
> 
> +/* Reported-by: Tim Schumacher <timschumi@gmx.de> */
> +UNUSUAL_DEV(0x152d, 0x1561, 0x0000, 0x9999,
> +		"JMicron",
> +		"JMS561U",
> +		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
> +		US_FL_IGNORE_UAS),
> +
>   /* Reported-by: Hans de Goede <hdegoede@redhat.com> */
>   UNUSUAL_DEV(0x2109, 0x0711, 0x0000, 0x9999,
>   		"VIA",
> --
> 2.25.0
> 

