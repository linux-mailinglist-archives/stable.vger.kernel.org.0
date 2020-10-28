Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B65329D8FF
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 23:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731446AbgJ1Wlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731262AbgJ1WjJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 18:39:09 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C39AC0613CF
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 15:39:08 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id j18so682827pfa.0
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 15:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4qQTutAxJUIrOL9lIlnr8WfxtfCzcr5gMv7GAyN7wjo=;
        b=G7G8LR3UmATpw9riJF5YJAKEoS6HKZ5Ma4CixsIzy0ehFCG+OTg5qTJB0phxP1rZWM
         ppHxyo3g/eVv2JF8pR9sqedJu823Y+gEUx96BET0dbzy0FjBWNvig/5E8Zg0CFaBa8Qu
         Qyg12HmTbs4umYc87QMy5PNDQ3/k4vp3kkk3b4HSwObbe+zCCCGq6aIkLd48vA+sa3kK
         +wr/08meWvO0nAx+1vnPOayE19PqywFUBj1Om3OHmMYcNTPrPwOB0eKWWb0E5Ie8R9xz
         ZAptqaAatWYPhKeDAT1fEqQl1oB1eH2hrzT7m50DaTKBFvBnNLzWqlj12HBbxHaqBd/l
         FJMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4qQTutAxJUIrOL9lIlnr8WfxtfCzcr5gMv7GAyN7wjo=;
        b=sRvTvOWLTzd0z9HXVD1Bz3RmnWeWTeQMeQGtiXR21SgcE6nhTL04jQ9/UuoRr6rAGx
         tD31sVqXMVJjfzq5e67ZGUBFUWPGoCeHWIZg2V6tzKxUlGLiV0tME7UD16XH0TSZVCDc
         C0LwQqrYntR1JJvv1L6MOMSTkX3XMj6Tl7wpmsLXfbP97A+SZMafTtHPymossrkFHfEy
         u10oJueBhtFZAMh+J96stCsZ29+2zzSzCgQZGu9374CQAh1G/6hu0HpurbSB+TJe6M4b
         n12rwU1zVGnUTQSU/TQGhY3FEdJvA9kuORgTJTNomF+OnNzvd9cvMG9ckhoVAERpovX0
         a8zQ==
X-Gm-Message-State: AOAM531JW475DvTmIyy4TXo+FTLPeIsMlq9NNSfoWKJL+zakG+0IhJho
        52EUV1t/qxoAK+1RCrmAhd2Cf8xeJbc=
X-Google-Smtp-Source: ABdhPJxAk3OAOfD0/sdfbg5wHgdPFdbvgpurVk7nnnsBJGCvUFfc4Q9sGX5FN0zafPG5TVwsOcglKg==
X-Received: by 2002:a63:160b:: with SMTP id w11mr370599pgl.110.1603905195113;
        Wed, 28 Oct 2020 10:13:15 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:a6ae:11ff:fe11:fcc3])
        by smtp.gmail.com with ESMTPSA id jy19sm9292pjb.9.2020.10.28.10.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 10:13:13 -0700 (PDT)
Date:   Wed, 28 Oct 2020 10:13:11 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Chris Ye <lzye@google.com>
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Mark Brown <broonie@kernel.org>, stable@vger.kernel.org
Subject: Re: HID : Add devices for HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE
Message-ID: <20201028171311.GL444962@dtor-ws>
References: <CAFFudd+V62a35zZ4Lw06NRwrH=uUsfYL0-Uu523Ua+teN29_tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFFudd+V62a35zZ4Lw06NRwrH=uUsfYL0-Uu523Ua+teN29_tg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Chris,

On Tue, Oct 27, 2020 at 12:57:51PM -0700, Chris Ye wrote:
> Add devices for HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE
> 
> Kernel 5.4 introduces HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE, devices need
> to be set explicitly with this flag.
> Signed-off-by: Chris Ye <lzye@google.com>
> 

This is still line-wrapped and still is in HTML. It also is not
formatted so that maintainers scripts can process it properly. Please
follow Documentation/process/suubmitting-patches.rst "Canonical format
patch" section. I recommend using "git format-patch ..." to generate it
and git send-email for sending it.

Thanks.

> diff -uprN -X linux-vanilla/Documentation/dontdiff
> linux-vanilla/drivers/hid/hid-ids.h linux/drivers/hid/hid-ids.h
> --- linux-vanilla/drivers/hid/hid-ids.h 2020-10-26 22:16:49.930361683 -0700
> +++ linux/drivers/hid/hid-ids.h 2020-10-26 22:20:02.811994573 -0700
> @@ -443,6 +443,10 @@
> #define USB_VENDOR_ID_FRUCTEL  0x25B6
> #define USB_DEVICE_ID_GAMETEL_MT_MODE  0x0002
> 
> +#define USB_VENDOR_ID_GAMEVICE 0x27F8
> +#define USB_DEVICE_ID_GAMEVICE_GV186   0x0BBE
> +#define USB_DEVICE_ID_GAMEVICE_KISHI   0x0BBF
> +
> #define USB_VENDOR_ID_GAMERON          0x0810
> #define USB_DEVICE_ID_GAMERON_DUAL_PSX_ADAPTOR 0x0001
> #define USB_DEVICE_ID_GAMERON_DUAL_PCS_ADAPTOR 0x0002
> diff -uprN -X linux-vanilla/Documentation/dontdiff
> linux-vanilla/drivers/hid/hid-quirks.c linux/drivers/hid/hid-quirks.c
> --- linux-vanilla/drivers/hid/hid-quirks.c      2020-10-26
> 22:16:49.930361683 -0700
> +++ linux/drivers/hid/hid-quirks.c      2020-10-26 22:20:02.811994573 -0700
> @@ -84,6 +84,8 @@ static const struct hid_device_id hid_qu
>        { HID_USB_DEVICE(USB_VENDOR_ID_FREESCALE,
> USB_DEVICE_ID_FREESCALE_MX28), HID_QUIRK_NOGET },
>        { HID_USB_DEVICE(USB_VENDOR_ID_FUTABA, USB_DEVICE_ID_LED_DISPLAY),
> HID_QUIRK_NO_INIT_REPORTS },
>        { HID_USB_DEVICE(USB_VENDOR_ID_GREENASIA,
> USB_DEVICE_ID_GREENASIA_DUAL_USB_JOYPAD), HID_QUIRK_MULTI_INPUT },
> +       { HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_GAMEVICE,
> USB_DEVICE_ID_GAMEVICE_GV186), HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_GAMEVICE,
> USB_DEVICE_ID_GAMEVICE_KISHI), HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
>        { HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_DRIVING),
> HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
>        { HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FIGHTING),
> HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
>        { HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FLYING),
> HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },

-- 
Dmitry
