Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6C82F4789
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 10:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbhAMJ0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 04:26:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51271 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725797AbhAMJ0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 04:26:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610529890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A9ksjDeyfuxGoy9asdFqUc8798GrLEWqzUIv9UWdtSg=;
        b=cGm+VwQfCJKo3exQiEE3KQj1NOg3XTg+oJPWN1Owr+BCBYGg8wq7kxBit4Sv7qY2UXkVFm
        vhszfbu/i5Ww1KRKToxNK9cwl038wddn1r2nTs0J+XzgccmEwr8UHsjzHQjI8ER8/8HXkN
        yA+krfIbisG4bXOEuhCBX/vmKm/ZSek=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-TIkQwfCgOyuD1F258u120Q-1; Wed, 13 Jan 2021 04:24:48 -0500
X-MC-Unique: TIkQwfCgOyuD1F258u120Q-1
Received: by mail-ej1-f72.google.com with SMTP id rl8so372440ejb.8
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 01:24:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A9ksjDeyfuxGoy9asdFqUc8798GrLEWqzUIv9UWdtSg=;
        b=Gvtn50Qq/oe9uPxOEGtlABUXHURchEzDFVW3vdY2/sT0cxo3uo5YwQJfqiw96aEV3F
         /bSYd26sHj93qLqwOOSxPN92wVoVCq8NwWCh8//VufKs5f+ZbOwzSEJojmfU5mvhq3OL
         ExzUBSqJEd4uQhap6SPR/pgFVbZJCZTQejwf2H+HXfpV86CmFy0j/o5djaNd0R3aVD24
         S+KiC/XAGHI3DIbKNDCG2DN3MjSow7dFyjDN+ZnMvZTMaz6cMnilVLbW+P5W+bVaotAa
         VJqf/d/fVQl2qazIgHROznY9Yb0mW3iwjGjYMIda8YEpWfJXZcMOGZJ3NuSE4HlOdjrD
         DSxA==
X-Gm-Message-State: AOAM531X/0YpBPzXiANfPw3SQ0bRq0WB8k6cMBLOw7BxWfZ0PzUSA+xX
        3EBrLIflvTgwjGZeu7kLjmW5LXVftEjKNFr4IrVqIKZwaNe5oQsoOK1V8cB85ugJXP4nC7CfPZN
        chiQCX0mJmemp7zd/
X-Received: by 2002:a17:906:4756:: with SMTP id j22mr913254ejs.353.1610529887241;
        Wed, 13 Jan 2021 01:24:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzr/Q3eR5rbgGFzsCsWj6QifS8PJJQr4SQXFTihkxnSILUE2KyVi+mMvDiJlpsTOlpvOWjqlg==
X-Received: by 2002:a17:906:4756:: with SMTP id j22mr913244ejs.353.1610529887047;
        Wed, 13 Jan 2021 01:24:47 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-37a3-353b-be90-1238.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:37a3:353b:be90:1238])
        by smtp.gmail.com with ESMTPSA id u19sm465252ejg.16.2021.01.13.01.24.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 01:24:46 -0800 (PST)
Subject: Re: [PATCH fixes v4] platform/x86: ideapad-laptop: Disable
 touchpad_switch for ELAN0634
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        platform-driver-x86@vger.kernel.org
Cc:     stable@vger.kernel.org, Ike Panhc <ike.pan@canonical.com>,
        Mark Gross <mgross@linux.intel.com>,
        linux-kernel@vger.kernel.org
References: <20210107144438.12605-1-jiaxun.yang@flygoat.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <dba9db5f-fa66-6003-382d-b35d5643d0d2@redhat.com>
Date:   Wed, 13 Jan 2021 10:24:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210107144438.12605-1-jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 1/7/21 3:44 PM, Jiaxun Yang wrote:
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

Thank you for your patch, I've applied this patch to my review-hans 
branch:
https://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git/log/?h=review-hans

Note it will show up in my review-hans branch once I've pushed my
local branch there, which might take a while.

Once I've run some tests on this branch the patches there will be
added to the platform-drivers-x86/for-next branch and eventually
will be included in the pdx86 pull-request to Linus for the next
merge-window.

I will also cherry-pick this into the fixes branch and include
it in a future fixes pull-req for 5.11 .

Regards,

Hans




> --
> v2: Specify touchpad to ELAN0634
> v3: Stupid missing ! in v2
> v4: Correct acpi_dev_present usage (Hans)
> ---
>  drivers/platform/x86/ideapad-laptop.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
> index 7598cd46cf60..5b81bafa5c16 100644
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
> +	priv->has_touchpad_switch = !acpi_dev_present("ELAN0634", NULL, -1);
> +
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

