Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68476A6CAE
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 17:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729641AbfICPO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 11:14:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15433 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728860AbfICPOx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 11:14:53 -0400
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3BD11C04B946
        for <stable@vger.kernel.org>; Tue,  3 Sep 2019 15:14:53 +0000 (UTC)
Received: by mail-qk1-f200.google.com with SMTP id q62so19500934qkd.3
        for <stable@vger.kernel.org>; Tue, 03 Sep 2019 08:14:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ejcHLZCIGB0+l1juCzkjIEZbgLC/qCu2LLXQois6BYM=;
        b=YikIPm6JdU53rhPG2Er8IaW6PFh/3fYM56JvLjsiM5ojcZke0ZCsfPg7s42LuEtJCn
         F4ryLv1v/pvPEE3TSjZhjR9PvO4gDBo958p5si42s9WQBiYVFJ6jl7tHqq7ct7UmHMXa
         ynqlLFvO1GjaLhuoenTHZ8lhvyjgvX+RxXq0D4INIgkwPOlilAgrIUy9URsuZOt6g8FO
         wIEXwISu3aGNhWtSezoJq9ETaAF5iDbglz28QEF1Uz6/rCLZ3Jlrpim2KlwJXdfnerQe
         LB7Pmrn/s303Jesf4Q20EWOe6Be5WrtSwJWiuJjLnxoWZIr7yfKJL8zIWfV2frUTlRtU
         3NOg==
X-Gm-Message-State: APjAAAVB1pGK8RarAUUE7a17iuV86MQT42lxrOXNSkJAVpFKhgmm+Uk+
        rqMTyfRlUg1pQ5UY+c/QukRcgvZcZl5dChplg0Z/aoJMHSVcgi1sBqs5yqBsZn+ydcT53TfyIg3
        NHuyx9D7NudT+bGjOHH9Roqs5JlKioPG4
X-Received: by 2002:a37:4c4d:: with SMTP id z74mr7349819qka.459.1567523692388;
        Tue, 03 Sep 2019 08:14:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxq5H3cSLUEi5b0CYc80xXax0JKsTI+nmRD1EDsw8jIbyR9AKN6MQpwKv/SCElmJ7UkRZF9y68w2zHDAei3TtY=
X-Received: by 2002:a37:4c4d:: with SMTP id z74mr7349804qka.459.1567523692253;
 Tue, 03 Sep 2019 08:14:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190902103930.9004-1-s.parschauer@gmx.de>
In-Reply-To: <20190902103930.9004-1-s.parschauer@gmx.de>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Tue, 3 Sep 2019 17:14:41 +0200
Message-ID: <CAO-hwJ+PG6jxV7MbBcsAuP0cF_ROLcSbov4+k7wKkJPcu+KLZw@mail.gmail.com>
Subject: Re: [PATCH] HID: Add quirk for HP X500 PIXART OEM mouse
To:     Sebastian Parschauer <s.parschauer@gmx.de>
Cc:     Jiri Kosina <jikos@kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 2, 2019 at 12:41 PM Sebastian Parschauer
<s.parschauer@gmx.de> wrote:
>
> The PixArt OEM mice are known for disconnecting every minute in
> runlevel 1 or 3 if they are not always polled. So add quirk
> ALWAYS_POLL for this one as well.
>
> Ville Viinikka (viinikv) reported and tested the quirk.
> Reference: https://github.com/sriemer/fix-linux-mouse issue 15
>
> Signed-off-by: Sebastian Parschauer <s.parschauer@gmx.de>
> CC: stable@vger.kernel.org # v4.16+
> ---

thanks!

Applied to for-5.4/core

Cheers,
Benjamin

>  drivers/hid/hid-ids.h    | 1 +
>  drivers/hid/hid-quirks.c | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 0a00be19f7a0..e4d51ce20a6a 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -568,6 +568,7 @@
>  #define USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OPTICAL_MOUSE_0B4A  0x0b4a
>  #define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE         0x134a
>  #define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_094A    0x094a
> +#define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_0941    0x0941
>  #define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_0641    0x0641
>
>  #define USB_VENDOR_ID_HUION            0x256c
> diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
> index 166f41f3173b..c50bcd967d99 100644
> --- a/drivers/hid/hid-quirks.c
> +++ b/drivers/hid/hid-quirks.c
> @@ -92,6 +92,7 @@ static const struct hid_device_id hid_quirks[] = {
>         { HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OPTICAL_MOUSE_0B4A), HID_QUIRK_ALWAYS_POLL },
>         { HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE), HID_QUIRK_ALWAYS_POLL },
>         { HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_094A), HID_QUIRK_ALWAYS_POLL },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_0941), HID_QUIRK_ALWAYS_POLL },
>         { HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_0641), HID_QUIRK_ALWAYS_POLL },
>         { HID_USB_DEVICE(USB_VENDOR_ID_IDEACOM, USB_DEVICE_ID_IDEACOM_IDC6680), HID_QUIRK_MULTI_INPUT },
>         { HID_USB_DEVICE(USB_VENDOR_ID_INNOMEDIA, USB_DEVICE_ID_INNEX_GENESIS_ATARI), HID_QUIRK_MULTI_INPUT },
> --
> 2.16.4
>
