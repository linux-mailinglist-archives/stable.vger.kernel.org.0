Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5D42E9411
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 12:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbhADL1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 06:27:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24411 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726026AbhADL1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 06:27:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609759571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nKgwCm2zSAXKJd/iEKhOToFdsR0fsLags0563ZkdwVY=;
        b=VePab/o/YB6uD4gGxHB/S+Mp5OwcGMDxGlXf8jkkqKz75FTKAn4zybj/CDKJK9EwpVs+5t
        W4P+Ik5jg08HqKSV1DNS5oyJrr31vlAb8aRycBbvjti4zG+kqPv/L1cQl0YctWcVErcKPX
        ZT1mGVH4sqhBeOdBvdwlhvebmYYrq/A=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-NI2_xpg4P52oA65B6ijHlg-1; Mon, 04 Jan 2021 06:26:10 -0500
X-MC-Unique: NI2_xpg4P52oA65B6ijHlg-1
Received: by mail-ed1-f69.google.com with SMTP id d12so12113816edx.23
        for <stable@vger.kernel.org>; Mon, 04 Jan 2021 03:26:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nKgwCm2zSAXKJd/iEKhOToFdsR0fsLags0563ZkdwVY=;
        b=iLQilW19ZLsCYYfZm9gFDY/IxQ0CWQroTjoA8y4FeT7wc+2dl52x2YMTzdCSCQdL8v
         gith1DNhio/85aow+WwsLgctPqrxvwr75I+zp3bsHVk71zUWRYrK1lJDaEZzihbJQV/J
         ZXIonnwQN3gmW6UVCdRFEFbQBZPMol//XsFJ5V6in40da7EES6XPgnHD3U5Z95VXf/qK
         tAgCTuVhKgOrhEGpZwsyhez2WYaxHmaaVMsVvGW9wSm3a5C7elPQzcQ0a2Xa1mrz7tF/
         F8Y8bMHURnhkOl+S/AkVFvHabZ+SOcrCIYaSx0Yz5ZF6pR3EYr0OkuIHCH1rGUj86hjU
         j/ww==
X-Gm-Message-State: AOAM533jbFhhmSa4iqOL6vkKTG+n2iXIk5Hz7BIUtRkKjEtpPtX8AEF6
        ZT994hVzzqjDvw358R7M8t6BpezrLbmSHOMJNi9ZKts6BmW8x//sh6rDnds3JNhLhATnqbNwkgc
        D48Blyi6lIpQf9hfN
X-Received: by 2002:a17:906:f8d4:: with SMTP id lh20mr67294163ejb.442.1609759568852;
        Mon, 04 Jan 2021 03:26:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyzs1JhTYmWn2stYW6SCyG0HhOE1Myk+vcUFday74cPQV4R9ww1OTGd3Y4DADB3KzBKkTRPwg==
X-Received: by 2002:a17:906:f8d4:: with SMTP id lh20mr67294142ejb.442.1609759568631;
        Mon, 04 Jan 2021 03:26:08 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-37a3-353b-be90-1238.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:37a3:353b:be90:1238])
        by smtp.gmail.com with ESMTPSA id r11sm43466767edt.58.2021.01.04.03.26.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 03:26:07 -0800 (PST)
Subject: Re: [PATCH fixes v3] platform/x86: ideapad-laptop: Disable
 touchpad_switch for ELAN0634
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        platform-driver-x86@vger.kernel.org
Cc:     stable@vger.kernel.org, Ike Panhc <ike.pan@canonical.com>,
        Mark Gross <mgross@linux.intel.com>,
        linux-kernel@vger.kernel.org
References: <20210103033651.47580-1-jiaxun.yang@flygoat.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <60493709-e0f6-2079-7007-67e85445d2dc@redhat.com>
Date:   Mon, 4 Jan 2021 12:26:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210103033651.47580-1-jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 1/3/21 4:36 AM, Jiaxun Yang wrote:
> Newer ideapads (e.g.: Yoga 14s, 720S 14) come with ELAN0634 touchpad do not
> use EC to switch touchpad.
> 
> Reading VPCCMD_R_TOUCHPAD will return zero thus touchpad may be blocked
> unexpectedly.
> Writing VPCCMD_W_TOUCHPAD may cause a spurious key press.
> 
> Add has_touchpad_switch to workaround these machines.
> 
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Cc: stable@vger.kernel.org # 5.4+
> --
> v2: Specify touchpad to ELAN0634
> v3: Stupid missing ! in v2
> ---
>  drivers/platform/x86/ideapad-laptop.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
> index 7598cd46cf60..427970b3b0da 100644
> --- a/drivers/platform/x86/ideapad-laptop.c
> +++ b/drivers/platform/x86/ideapad-laptop.c
> @@ -92,6 +92,7 @@ struct ideapad_private {
>  	struct dentry *debug;
>  	unsigned long cfg;
>  	bool has_hw_rfkill_switch;
> +	bool has_touchpad_switch;
>  	const char *fnesc_guid;
>  };
>  
> @@ -535,7 +536,9 @@ static umode_t ideapad_is_visible(struct kobject *kobj,
>  	} else if (attr == &dev_attr_fn_lock.attr) {
>  		supported = acpi_has_method(priv->adev->handle, "HALS") &&
>  			acpi_has_method(priv->adev->handle, "SALS");
> -	} else
> +	} else if (attr == &dev_attr_touchpad.attr)
> +		supported = priv->has_touchpad_switch;
> +	else
>  		supported = true;
>  
>  	return supported ? attr->mode : 0;
> @@ -867,6 +870,9 @@ static void ideapad_sync_touchpad_state(struct ideapad_private *priv)
>  {
>  	unsigned long value;
>  
> +	if (!priv->has_touchpad_switch)
> +		return;
> +
>  	/* Without reading from EC touchpad LED doesn't switch state */
>  	if (!read_ec_data(priv->adev->handle, VPCCMD_R_TOUCHPAD, &value)) {
>  		/* Some IdeaPads don't really turn off touchpad - they only
> @@ -989,6 +995,9 @@ static int ideapad_acpi_add(struct platform_device *pdev)
>  	priv->platform_device = pdev;
>  	priv->has_hw_rfkill_switch = dmi_check_system(hw_rfkill_list);
>  
> +	/* Most ideapads with ELAN0634 touchpad don't use EC touchpad switch */
> +	priv->has_touchpad_switch = !acpi_dev_present("PNP0C50", "ELAN0634", -1);
> +

That is not how acpi_dev_present works:

/**
 * acpi_dev_present - Detect that a given ACPI device is present
 * @hid: Hardware ID of the device.
 * @uid: Unique ID of the device, pass NULL to not check _UID
 * @hrv: Hardware Revision of the device, pass -1 to not check _HRV
 *
 * Return %true if a matching device was present at the moment of invocation.
...
 */
bool acpi_dev_present(const char *hid, const char *uid, s64 hrv);

The second argument tests for the UID, which is typically "1", "2", "3",
etc. and which is used when there are multiple devices with the same HID.

For example the GPIO controllers on many Intel chipsets have so called south
and north islands, which are separate devices with the same HID, but one
has a UID of "1" and the other of "2".

If you want to check for a device with a HID or CID of "ELAN0634" then you
should do:

	priv->has_touchpad_switch = !acpi_dev_present("ELAN0634", NULL, -1);

Regards,

Hans




>  	ret = ideapad_sysfs_init(priv);
>  	if (ret)
>  		return ret;
> @@ -1006,6 +1015,10 @@ static int ideapad_acpi_add(struct platform_device *pdev)
>  	if (!priv->has_hw_rfkill_switch)
>  		write_ec_cmd(priv->adev->handle, VPCCMD_W_RF, 1);
>  
> +	/* The same for Touchpad */
> +	if (!priv->has_touchpad_switch)
> +		write_ec_cmd(priv->adev->handle, VPCCMD_W_TOUCHPAD, 1);
> +
>  	for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++)
>  		if (test_bit(ideapad_rfk_data[i].cfgbit, &priv->cfg))
>  			ideapad_register_rfkill(priv, i);
> 

