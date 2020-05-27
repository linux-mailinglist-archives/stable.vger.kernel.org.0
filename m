Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EFC1E38EE
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 08:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgE0GSU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 27 May 2020 02:18:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47641 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbgE0GSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 02:18:18 -0400
Received: from mail-pf1-f198.google.com ([209.85.210.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jdpOK-0004W8-28
        for stable@vger.kernel.org; Wed, 27 May 2020 06:18:16 +0000
Received: by mail-pf1-f198.google.com with SMTP id r3so18753165pfg.12
        for <stable@vger.kernel.org>; Tue, 26 May 2020 23:18:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=vyY8c2L/LhgRPKf+Jdno0CTyY7OpU2lIFU0hqsnB65Y=;
        b=rpLkgr4FdrAZQtCNBTczgYfJ+aDJoNV4d+Ib5fAWkJwb2zqrLr9o/NOMUhOUGgdNwt
         f8Xeelr2Y7X/8lZqBlh0iq9I88IFFzrKLZ7rLXzaPaUouoxgSWNAzo5+oJTbmWkWRKee
         vcGC/pjGjOrcTD3+G2lK342SsC1UJQma0lDXGHd4cK8tvunQUZvuyDt4I5nSC2H5EzjP
         GUmKroquIH+Y5mc8Zt2OU34q0YhU4KKqSkyyn/CVzMYtOISRfOefRAuAs6s2WJ9008lc
         MidefsPeFMNsvT5zbzIe1u4oRFij94Evp39tqdeKNUjadj0b009l15O1ygXjEsidZ3zl
         He4g==
X-Gm-Message-State: AOAM533JQ8OjynWvvaONztpAG9vqDG+cY415tRKE3omfCl7W1pTyPI5t
        E06E0+S/i+khcIgGCz7P1hK8iQKtsCTOdjBYgckn/C/lrHdNUVBnHc2AU+Q7U833nzy2BOldvXY
        9VC8oiPtjYdE2OEaist/z/htgqPi7aiaVqQ==
X-Received: by 2002:a17:902:82c9:: with SMTP id u9mr4462419plz.179.1590560294556;
        Tue, 26 May 2020 23:18:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwazWv37SfcUrKOPhNN5aIAaxE6SHyIu4E4zHD4p5MX3syOTTwgsYE/LwqAmCBsDBLgEfTX2Q==
X-Received: by 2002:a17:902:82c9:: with SMTP id u9mr4462406plz.179.1590560294200;
        Tue, 26 May 2020 23:18:14 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id v22sm1195350pfu.172.2020.05.26.23.18.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 May 2020 23:18:13 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] HID: multitouch: enable multi-input as a quirk for some
 devices
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <20200526150717.324783-1-benjamin.tissoires@redhat.com>
Date:   Wed, 27 May 2020 14:18:10 +0800
Cc:     Jiri Kosina <jikos@kernel.org>,
        "open list:INTEL INTEGRATED SENSOR HUB DRIVER" 
        <linux-input@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <27B6F419-A68E-459D-AB6B-7BF2D935C6E0@canonical.com>
References: <20200526150717.324783-1-benjamin.tissoires@redhat.com>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On May 26, 2020, at 23:07, Benjamin Tissoires <benjamin.tissoires@redhat.com> wrote:
> 
> Two touchpad/trackstick combos are currently not behaving properly.
> They define a mouse emulation collection, as per Win8 requirements,
> but also define a separate mouse collection for the trackstick.
> 
> The way the kernel currently treat the collections is that it
> merges both in one device. However, given that the first mouse
> collection already defines X,Y and left, right buttons, when
> mapping the events from the second mouse collection, hid-multitouch
> sees that these events are already mapped, and simply ignores them.
> 
> To be able to report events from the tracktick, add a new quirked
> class for it, and manually add the 2 devices we know about.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=207235
> Cc: stable@vger.kernel.org
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

> ---
> drivers/hid/hid-multitouch.c | 26 ++++++++++++++++++++++++++
> 1 file changed, 26 insertions(+)
> 
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 03c720b47306..39e4da7468e1 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -69,6 +69,7 @@ MODULE_LICENSE("GPL");
> #define MT_QUIRK_ASUS_CUSTOM_UP		BIT(17)
> #define MT_QUIRK_WIN8_PTP_BUTTONS	BIT(18)
> #define MT_QUIRK_SEPARATE_APP_REPORT	BIT(19)
> +#define MT_QUIRK_FORCE_MULTI_INPUT	BIT(20)
> 
> #define MT_INPUTMODE_TOUCHSCREEN	0x02
> #define MT_INPUTMODE_TOUCHPAD		0x03
> @@ -189,6 +190,7 @@ static void mt_post_parse(struct mt_device *td, struct mt_application *app);
> #define MT_CLS_WIN_8				0x0012
> #define MT_CLS_EXPORT_ALL_INPUTS		0x0013
> #define MT_CLS_WIN_8_DUAL			0x0014
> +#define MT_CLS_WIN_8_FORCE_MULTI_INPUT		0x0015
> 
> /* vendor specific classes */
> #define MT_CLS_3M				0x0101
> @@ -279,6 +281,15 @@ static const struct mt_class mt_classes[] = {
> 			MT_QUIRK_CONTACT_CNT_ACCURATE |
> 			MT_QUIRK_WIN8_PTP_BUTTONS,
> 		.export_all_inputs = true },
> +	{ .name = MT_CLS_WIN_8_FORCE_MULTI_INPUT,
> +		.quirks = MT_QUIRK_ALWAYS_VALID |
> +			MT_QUIRK_IGNORE_DUPLICATES |
> +			MT_QUIRK_HOVERING |
> +			MT_QUIRK_CONTACT_CNT_ACCURATE |
> +			MT_QUIRK_STICKY_FINGERS |
> +			MT_QUIRK_WIN8_PTP_BUTTONS |
> +			MT_QUIRK_FORCE_MULTI_INPUT,
> +		.export_all_inputs = true },
> 
> 	/*
> 	 * vendor specific classes
> @@ -1714,6 +1725,11 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
> 	if (id->group != HID_GROUP_MULTITOUCH_WIN_8)
> 		hdev->quirks |= HID_QUIRK_MULTI_INPUT;
> 
> +	if (mtclass->quirks & MT_QUIRK_FORCE_MULTI_INPUT) {
> +		hdev->quirks &= ~HID_QUIRK_INPUT_PER_APP;
> +		hdev->quirks |= HID_QUIRK_MULTI_INPUT;
> +	}
> +
> 	timer_setup(&td->release_timer, mt_expired_timeout, 0);
> 
> 	ret = hid_parse(hdev);
> @@ -1926,6 +1942,11 @@ static const struct hid_device_id mt_devices[] = {
> 		MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
> 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_C002) },
> 
> +	/* Elan devices */
> +	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT,
> +		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
> +			USB_VENDOR_ID_ELAN, 0x313a) },
> +
> 	/* Elitegroup panel */
> 	{ .driver_data = MT_CLS_SERIAL,
> 		MT_USB_DEVICE(USB_VENDOR_ID_ELITEGROUP,
> @@ -2056,6 +2077,11 @@ static const struct hid_device_id mt_devices[] = {
> 		MT_USB_DEVICE(USB_VENDOR_ID_STANTUM_STM,
> 			USB_DEVICE_ID_MTP_STM)},
> 
> +	/* Synaptics devices */
> +	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT,
> +		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
> +			USB_VENDOR_ID_SYNAPTICS, 0xce08) },
> +
> 	/* TopSeed panels */
> 	{ .driver_data = MT_CLS_TOPSEED,
> 		MT_USB_DEVICE(USB_VENDOR_ID_TOPSEED2,
> -- 
> 2.25.1
> 

