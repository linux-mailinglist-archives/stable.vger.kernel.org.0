Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB3B1D4389
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 04:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgEOCbG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 14 May 2020 22:31:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34474 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727969AbgEOCbG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 22:31:06 -0400
Received: from mail-pf1-f198.google.com ([209.85.210.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jZQ7r-0007iZ-Kb
        for stable@vger.kernel.org; Fri, 15 May 2020 02:31:03 +0000
Received: by mail-pf1-f198.google.com with SMTP id t22so593380pfe.3
        for <stable@vger.kernel.org>; Thu, 14 May 2020 19:31:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=s8tcOcdPYeTodwqSl1QkZZy/pKZuDq5Dfiay8LkuQI4=;
        b=uY4G3ZKO2X8NLk9F4WBCOjr4CLNb1EQvyOSiiDl6uPYF3ctQRhjew+Zwo4Z0yMMQSI
         I2Q4w5djsnCi1O7l90bSycFbqxLOjUUecjH5ZhNIxjQq5oOdZxK7GKapjUEgzrl7KOpF
         YnUfv+07N93uUK3TyeoEZB6KKoShfuhA2bwUHkyqota4hedEGygRLWFTmrX17D06yMHO
         BB5ig5OO1zGw18DjThymlJ+2gIsBvjQ1e+7V3Rgjq4GfIPNM4iL+Q5/ZyClizpxjOONh
         VznSPxBVq6k2WEGAHOE5svW9zmLG+4hfOxJnRhR8ZcDSA6r1VcwaONwRzZfSox9yS7DR
         Q0vw==
X-Gm-Message-State: AOAM533HdcWUY5PL4hFt3dloRsDyi2yqdu24ULaJyPgR7yyoYanw9dcN
        M07312Fs09i7V3FNVv7zU7wTqdKdq0uZ3lJQYxZ8MB7WQtpDGvoqGv+7jWmixHJHIGjk1M0WFSN
        UnDtfKULcqU3TimpGo1JVDcKnGT0ogPGJtA==
X-Received: by 2002:a17:902:b401:: with SMTP id x1mr1530867plr.334.1589509862028;
        Thu, 14 May 2020 19:31:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxbeP3r9puf7vMybibvhliGHuQC/LsBElDPmuxYS58JCZt6ir1uAtpEWJco+HN6Kzp8W3KFFQ==
X-Received: by 2002:a17:902:b401:: with SMTP id x1mr1530832plr.334.1589509861600;
        Thu, 14 May 2020 19:31:01 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id c22sm459697pfc.127.2020.05.14.19.30.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 May 2020 19:31:00 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] usb: core: hub: limit HUB_QUIRK_DISABLE_AUTOSUSPEND to
 USB5534B
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <20200514220246.13290-1-erosca@de.adit-jv.com>
Date:   Fri, 15 May 2020 10:30:57 +0800
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Hardik Gajjar <hgajjar@de.adit-jv.com>,
        linux-renesas-soc@vger.kernel.org, linux-usb@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <FB436128-70A8-4558-808C-E068834EBF4F@canonical.com>
References: <20200514220246.13290-1-erosca@de.adit-jv.com>
To:     Eugeniu Rosca <erosca@de.adit-jv.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On May 15, 2020, at 06:02, Eugeniu Rosca <erosca@de.adit-jv.com> wrote:
> 
> On Tue, May 12, 2020 at 09:36:07PM +0800, Kai-Heng Feng wrote [1]:
>> This patch prevents my Raven Ridge xHCI from getting runtime suspend.
> 
> The problem described in v5.6 commit 1208f9e1d758c9 ("USB: hub: Fix the
> broken detection of USB3 device in SMSC hub") applies solely to the
> USB5534B hub [2] present on the Kingfisher Infotainment Carrier Board,
> manufactured by Shimafuji Electric Inc [3].
> 
> Despite that, the aforementioned commit applied the quirk to _all_ hubs
> carrying vendor ID 0x424 (i.e. SMSC), of which there are more [4] than
> initially expected. Consequently, the quirk is now enabled on platforms
> carrying SMSC/Microchip hub models which potentially don't exhibit the
> original issue.
> 
> To avoid reports like [1], further limit the quirk's scope to
> USB5534B [2], by employing both Vendor and Product ID checks.
> 
> Tested on H3ULCB + Kingfisher rev. M05.
> 
> [1] https://lore.kernel.org/linux-renesas-soc/73933975-6F0E-40F5-9584-D2B8F615C0F3@canonical.com/
> [2] https://www.microchip.com/wwwproducts/en/USB5534B
> [3] http://www.shimafuji.co.jp/wp/wp-content/uploads/2018/08/SBEV-RCAR-KF-M06Board_HWSpecificationEN_Rev130.pdf
> [4] https://devicehunt.com/search/type/usb/vendor/0424/device/any
> 
> Fixes: 1208f9e1d758c9 ("USB: hub: Fix the broken detection of USB3 device in SMSC hub")
> Cc: stable@vger.kernel.org # v4.14+
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Hardik Gajjar <hgajjar@de.adit-jv.com>
> Cc: linux-renesas-soc@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
> Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>

Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

> ---
> drivers/usb/core/hub.c | 6 +++++-
> 1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index 2b6565c06c23..fc748c731832 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -39,6 +39,7 @@
> 
> #define USB_VENDOR_GENESYS_LOGIC		0x05e3
> #define USB_VENDOR_SMSC				0x0424
> +#define USB_PRODUCT_USB5534B			0x5534
> #define HUB_QUIRK_CHECK_PORT_AUTOSUSPEND	0x01
> #define HUB_QUIRK_DISABLE_AUTOSUSPEND		0x02
> 
> @@ -5621,8 +5622,11 @@ static void hub_event(struct work_struct *work)
> }
> 
> static const struct usb_device_id hub_id_table[] = {
> -    { .match_flags = USB_DEVICE_ID_MATCH_VENDOR | USB_DEVICE_ID_MATCH_INT_CLASS,
> +    { .match_flags = USB_DEVICE_ID_MATCH_VENDOR
> +                   | USB_DEVICE_ID_MATCH_PRODUCT
> +                   | USB_DEVICE_ID_MATCH_INT_CLASS,
>       .idVendor = USB_VENDOR_SMSC,
> +      .idProduct = USB_PRODUCT_USB5534B,
>       .bInterfaceClass = USB_CLASS_HUB,
>       .driver_info = HUB_QUIRK_DISABLE_AUTOSUSPEND},
>     { .match_flags = USB_DEVICE_ID_MATCH_VENDOR
> -- 
> 2.26.2
> 

