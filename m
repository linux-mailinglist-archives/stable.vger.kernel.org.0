Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0835E2AD746
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 14:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbgKJNRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 08:17:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34206 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726721AbgKJNRG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 08:17:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605014225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1K0/9t07XeI3A9sIGRsqTXdnwR9LxbNUogT0ZewH2/g=;
        b=TvcGDE/tzlUgD6tXmJI79jMZDjNjRRAaEUuaQvZrhHpQ+/ka2zpAq1T6bw+qMtjpMyE/f1
        ZnsmGWud6s14RIWdmEZR7ACwc/pXl9TXKWS+m2hrWrbCcCVQOTc4iyrbMg+U/2n8rDAb2S
        qvJUA/gAC1gkFLTvCYiAiUDaCKtlq54=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-oy87q8U6PcKO052C9rIw4g-1; Tue, 10 Nov 2020 08:17:03 -0500
X-MC-Unique: oy87q8U6PcKO052C9rIw4g-1
Received: by mail-ed1-f70.google.com with SMTP id h6so4162592edt.12
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 05:17:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1K0/9t07XeI3A9sIGRsqTXdnwR9LxbNUogT0ZewH2/g=;
        b=L2O5QmkXjdzf5tiwW07mvDb2GLqiChCQcz87WCOsOjQ/k2bUZMOfhzqkB2/UPQIjGs
         32cVuXGr1UX+nTB62xREKhakBYr/OUob/xoltc3TEZ6wssdKUYz/5pAUZ0hQFwRcpOGv
         PSEmyfu3p6Pf9GhESXPPVmkpGLemxi9drH6r79DdoyloJxgqUSsGC4MJoy6WGfFhAcuR
         086aV43EBnzJYzVmtQpw+XkTyO4YxhKFOXdZBBs6ZSl97tySMIo+6FG4rIuM7Y8bTc3l
         fnTUs2UBJjTCUPgVER2vTvsBDndHThyuDqqXSgA7OggQCvM25PrCxm40hIOQr4jTqQjj
         TBTQ==
X-Gm-Message-State: AOAM5316lOZp5QwVT9Xk+33mzNFzi0XZLS/65mKBAS3XPd+l0AkgaR+/
        tQu+PWUDoXHQgMILB/hwV2k7Ufkmi6W9FGkQ4Odjt0zIOqjzFM35KhGPLPfciQpvesSzc6YMXZR
        wT7uK7ckiGtMbtCYfS2SQs+1XwPpPCGgLojUcHT+uf6v0UybW5w8Q8BwBNMejcFPT2LeH
X-Received: by 2002:aa7:c90d:: with SMTP id b13mr21613603edt.136.1605014221485;
        Tue, 10 Nov 2020 05:17:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwYeJ6LQFw2ruqmflr3urpBvtEdEKtl29tAmqGB/LrlFrwp8PGNEjpn3FGbEJe1U7Q0AmicAA==
X-Received: by 2002:aa7:c90d:: with SMTP id b13mr21613571edt.136.1605014221191;
        Tue, 10 Nov 2020 05:17:01 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-6c10-fbf3-14c4-884c.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:6c10:fbf3:14c4:884c])
        by smtp.gmail.com with ESMTPSA id c8sm10782927edr.29.2020.11.10.05.17.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 05:17:00 -0800 (PST)
Subject: Re: [PATCH 1/3] HID: logitech-dj: Handle quad/bluetooth keyboards
 with a builtin trackpad
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     linux-input@vger.kernel.org, stable@vger.kernel.org
References: <20201102133658.4410-1-hdegoede@redhat.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <e3817ab8-906e-cb98-91db-ffb4cc821788@redhat.com>
Date:   Tue, 10 Nov 2020 14:16:59 +0100
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

Hi All,

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
> * K400 (uses a unifying receiver so is not affected)
> * K600 (uses a unifying receiver so is not affected)
> 
> Cc: stable@vger.kernel.org
> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1811424
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

ping? This is a bug fix for a regression caused by:

Commit f2113c3020ef ("HID: logitech-dj: add support for Logitech Bluetooth Mini-Receiver")

Specifically that commit caused the builtin touchpad to stop working on Logitech Dinovo
Edge keyboards and this fixes this.

I realize now that I forgot to add a:

Fixes: f2113c3020ef ("HID: logitech-dj: add support for Logitech Bluetooth Mini-Receiver")

Tag, let me know if you want a v2 for that.

Regardless since this is a bug fix, it would be good if we can get this
merged into one of the upcoming 5.10-rc#s. Even without the Dinovo Mini
id added this is still worthwhile to get the reported regression fixed
and we can add the Dinovo Mini id later.

Regards,

Hans




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

