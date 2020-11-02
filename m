Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453C22A2BDD
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 14:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725789AbgKBNor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 08:44:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24205 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725797AbgKBNor (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 08:44:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604324685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pxp2Nj1H/5tlJcYtXlgneoQlHOclOYbhbDQvMkea8qo=;
        b=X1O7RuCh/vs3K+RImQfVSnZFnBm80bY6kq/rlWALCVuIVofA2yfBD0WknYQubRAHWbcV4F
        4aWDMxDwf+Bzv/9Np9VbXvCpPSW9F53ZR+C0MKV1hzsA4pneidIw0cQgYZnWetuTAAvXp0
        IaPbCC50fiYaADcHMMkJsvlmC1i6anY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-W0TONqfwMmWb5RbGe1hrxw-1; Mon, 02 Nov 2020 08:44:43 -0500
X-MC-Unique: W0TONqfwMmWb5RbGe1hrxw-1
Received: by mail-ed1-f71.google.com with SMTP id t7so6204644edt.0
        for <stable@vger.kernel.org>; Mon, 02 Nov 2020 05:44:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pxp2Nj1H/5tlJcYtXlgneoQlHOclOYbhbDQvMkea8qo=;
        b=rG3/7tcDBcTBGAtAARfU9ON0asVr6N9RyeA/IFjk+IcF9pvKK3cKge2t3LXw6XFeCs
         adpyWL1l1qsmPUuGWXRWuoG1zYnDO0Y0cFRkwzqnpYFumGxlSYkgLDkzPTkViAVzzEZa
         OIcZ6NX7H5w70Pqxe43YrRRwPpvEfB1yHbh12AZN3uQ6oOxqTeujpEcKIRxYdcC/1gUc
         xPvdi7Zsh12XTIqVm+Qpn8IuFlgotJ+z6+uAEJ9I5ri0WV7o2Dd0yvI2kBHVh80FOlrh
         x1o0JH4FVSd3GU7UjtDkMYqdHzFs5DMAaB7Fuk/qIENFwQempFKckySpSZoa6CY8SD+r
         Tv+A==
X-Gm-Message-State: AOAM532bFsUq6j0KBnKjrtwEBoU1PA0nmSBYhPZSSPue8PoFTztn6Vqm
        6TawkHkP4QCJQaa1Uy+vWlNwjdPDZ+A4Nrfsr7M4bD1NflD/sSOIvbfBb++GzC2Wr8E19QRx1ap
        2YQLu8lW9InRg+uBE
X-Received: by 2002:a17:906:e24a:: with SMTP id gq10mr15113757ejb.552.1604324681375;
        Mon, 02 Nov 2020 05:44:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwWvO2wOXIHG0WcqBr0VvVt9fW3W+FD7pcZxHVRYOLbpg31aIOWkejywOf8MCHBM6hkRjxM/g==
X-Received: by 2002:a17:906:e24a:: with SMTP id gq10mr15113746ejb.552.1604324681151;
        Mon, 02 Nov 2020 05:44:41 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-6c10-fbf3-14c4-884c.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:6c10:fbf3:14c4:884c])
        by smtp.gmail.com with ESMTPSA id y12sm7314695ejj.95.2020.11.02.05.44.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 05:44:40 -0800 (PST)
Subject: Re: [PATCH 1/3] HID: logitech-dj: Handle quad/bluetooth keyboards
 with a builtin trackpad
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     linux-input@vger.kernel.org, stable@vger.kernel.org
References: <20201102133658.4410-1-hdegoede@redhat.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <3f645eea-31a0-d1a9-7e70-54e766bab9c2@redhat.com>
Date:   Mon, 2 Nov 2020 14:44:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201102133658.4410-1-hdegoede@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 11/2/20 2:36 PM, Hans de Goede wrote:
> Some quad/bluetooth keyboards, such as the Dinovo Edge (Y-RAY81) have a
> builtin touchpad. In this case when asking the receiver for paired devices,
> we get only 1 paired device with a device_type of REPORT_TYPE_KEYBOARD.
> 
> This means that we do not instantiate a second dj_hiddev for the mouse
> (as we normally would) and thus there is no place for us to forward the
> mouse input reports to, causing the touchpad part of the keyboard to not
> work.
> 
> There is no way for us to detect these keyboards, so this commit adds
> an array with device-ids for such keyboards and when a keyboard is on
> this list it adds STD_MOUSE to the reports_supported bitmap for the
> dj_hiddev created for the keyboard fixing the touchpad not working.
> 
> Using a list of device-ids for this is not ideal, but there are only
> very few such keyboards so this should be fine. Besides the Dinovo Edge,
> other known wireless Logitech keyboards with a builtin touchpad are:
> 
> * Dinovo Mini (TODO add its device-id to the list)

Benjamin, you have a Dinovo Mini, right ?

It looks like that is using the same quad/bluetooth combo receiver
as the Dinovo Edge, but then with slightly different USB ids, which
means that atm we are not using the logitech-dj driver for it.

But the dongles appear to be interchangeable I can pair the Dinovo
Edge with both the MX5000 and the MX5500 dongles which I have, so
someone who mixes up dongles (or gets a spare one) could end up
using the Dinovo Mini with a dongle which is already handled by
the logitech-dj driver.

As such it would be good if you can add the Dinovo Mini to the
device-id list this patch introduces (or if you tell me the device-id
I can do a v2 adding it depending on the timing).

Also I think you should probably add the USB-ids for your
Dinovo dongle to the logitech-dj driver. This will allow you
to verify that adding the device-id is necessary and also
will give you battery status reporting while used in USB HID
proxy mode.

Last you may want to check battery-status reporting in Bluetooth
mode, and maybe also make the logitech-hidpp driver handle the
Dinovo Mini in bluetooth mode, as at least on the Dinovo Edge
the standard HID battery reporting done in bluetooth mode
(and not in HID proxy mode interesting enough) seems to be
broken.

Regards,

Hans



> * K400 (uses a unifying receiver so is not affected)
> * K600 (uses a unifying receiver so is not affected)
> 
> Cc: stable@vger.kernel.org
> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1811424
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/hid/hid-logitech-dj.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
> index ea1e40530f85..9ed7260b9593 100644
> --- a/drivers/hid/hid-logitech-dj.c
> +++ b/drivers/hid/hid-logitech-dj.c
> @@ -867,11 +867,23 @@ static void logi_dj_recv_queue_notification(struct dj_receiver_dev *djrcv_dev,
>  	schedule_work(&djrcv_dev->work);
>  }
>  
> +/*
> + * Some quad/bluetooth keyboards have a builtin touchpad in this case we see
> + * only 1 paired device with a device_type of REPORT_TYPE_KEYBOARD. For the
> + * touchpad to work we must also forward mouse input reports to the dj_hiddev
> + * created for the keyboard (instead of forwarding them to a second paired
> + * device with a device_type of REPORT_TYPE_MOUSE as we normally would).
> + */
> +static const u16 kbd_builtin_touchpad_ids[] = {
> +	0xb309, /* Dinovo Edge */
> +};
> +
>  static void logi_hidpp_dev_conn_notif_equad(struct hid_device *hdev,
>  					    struct hidpp_event *hidpp_report,
>  					    struct dj_workitem *workitem)
>  {
>  	struct dj_receiver_dev *djrcv_dev = hid_get_drvdata(hdev);
> +	int i, id;
>  
>  	workitem->type = WORKITEM_TYPE_PAIRED;
>  	workitem->device_type = hidpp_report->params[HIDPP_PARAM_DEVICE_INFO] &
> @@ -883,6 +895,13 @@ static void logi_hidpp_dev_conn_notif_equad(struct hid_device *hdev,
>  		workitem->reports_supported |= STD_KEYBOARD | MULTIMEDIA |
>  					       POWER_KEYS | MEDIA_CENTER |
>  					       HIDPP;
> +		id = (workitem->quad_id_msb << 8) | workitem->quad_id_lsb;
> +		for (i = 0; i < ARRAY_SIZE(kbd_builtin_touchpad_ids); i++) {
> +			if (id == kbd_builtin_touchpad_ids[i]) {
> +				workitem->reports_supported |= STD_MOUSE;
> +				break;
> +			}
> +		}
>  		break;
>  	case REPORT_TYPE_MOUSE:
>  		workitem->reports_supported |= STD_MOUSE | HIDPP;
> 

