Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A4D4E2347
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 10:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345757AbiCUJ1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 05:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345865AbiCUJ1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 05:27:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A2E214F466
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 02:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647854734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GzohBbkrXG4LXx7mo3/JLEha1Z8wnON9GrcgVqSwS/Y=;
        b=XSiR2lrypObqS1j/YrnLDcvhpqfFaIrVuqSZDJ2KptvbTcYN7PH1vIdlxeUiOlEawHo+Ip
        ANWEnvBJXTZ8PgkRB789T7bI6BYLL1u8n4GOkY9di4QA57SArbxbThLrPyJJEh/f1Rgigw
        2zK8SmXc9OmLmVbXlRDbqiu/RW6r43I=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-211-tMzWxqOmNYWne_DsUR5Pag-1; Mon, 21 Mar 2022 05:25:33 -0400
X-MC-Unique: tMzWxqOmNYWne_DsUR5Pag-1
Received: by mail-pf1-f199.google.com with SMTP id x29-20020aa7941d000000b004fa7e7f232fso3777959pfo.7
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 02:25:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GzohBbkrXG4LXx7mo3/JLEha1Z8wnON9GrcgVqSwS/Y=;
        b=dqe2U+9Z6cCWhoW0bRCCZ9kSPHddS8T68YxFLifoOjXB6qJMZ4ZFrNX0kGSoNpsjug
         /XUlftFzWleEun8wpEE3wLLkVV64ZYfuMeNbHdnqqPnh5cAEfqNsNCrJShRRRKu1w0DU
         0/DbTd1NZyPAifaqdCS+Pk8DWH7PdYp12fbDwncDxT5Knt5tAsHgTPg3XnFHKhPiUuzr
         pkvfNnRCSAYIMYrArAr/weh4Yph+cUj7o2/TcWfgNpDkUvl0QQCViWEv903lUzEfVWfg
         wXfPOKg6pyjmRTTqcxyteYsBnItHKKMez4Rk3aVO4Bz6zJmjkzoTQxSR0IdYr1Zek18Z
         naaQ==
X-Gm-Message-State: AOAM530ataGS6r3y3BKOf+gxMY2udDBh7Jz4hA8pQdShspoS278jvkrb
        zGs/Z/QaAkily3KNkXYnVgLyLtdhk1SADgKWaHPUlrcwEmgv29ndu2JB1s+jOqb9L88MHtwjpUa
        d4++mTVhyGOz709cVYCFihIc7dzoVe7h9
X-Received: by 2002:a05:6a00:2182:b0:4fa:6d20:d95d with SMTP id h2-20020a056a00218200b004fa6d20d95dmr16423574pfi.83.1647854732191;
        Mon, 21 Mar 2022 02:25:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy5GIeW+QMX4U4V2zHohKqElMK7B6VgQJYnzw3N7Tv/o+8SUhfr7/r1sr09VsGyUW1SRSGOo/l09OeZwZL0rvE=
X-Received: by 2002:a05:6a00:2182:b0:4fa:6d20:d95d with SMTP id
 h2-20020a056a00218200b004fa6d20d95dmr16423547pfi.83.1647854731876; Mon, 21
 Mar 2022 02:25:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220320190602.7484-1-jose.exposito89@gmail.com>
In-Reply-To: <20220320190602.7484-1-jose.exposito89@gmail.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Mon, 21 Mar 2022 10:25:20 +0100
Message-ID: <CAO-hwJKZUSTaWUpE_vsvAs-MNoZ8UJLgxiCyQ6OzwHYFZszf2w@mail.gmail.com>
Subject: Re: [PATCH] HID: multitouch: fix Dell Precision 7550 and 7750 button type
To:     =?UTF-8?B?Sm9zw6kgRXhww7NzaXRv?= <jose.exposito89@gmail.com>
Cc:     jkosina@suse.cz, tiwai@suse.de, regressions@leemhuis.info,
        peter.hutterer@who-t.net, linux-input@vger.kernel.org,
        stable@vger.kernel.org, regressions@lists.linux.dev,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jos=C3=A9,

On Sun, Mar 20, 2022 at 8:06 PM Jos=C3=A9 Exp=C3=B3sito <jose.exposito89@gm=
ail.com> wrote:
>
> The touchpad present in the Dell Precision 7550 and 7750 laptops
> reports a HID_DG_BUTTONTYPE of type MT_BUTTONTYPE_CLICKPAD. However,
> the device is not a clickpad, it is a touchpad with physical buttons.
>
> In order to fix this issue, a quirk for the device was introduced in
> libinput [1] [2] to disable the INPUT_PROP_BUTTONPAD property:
>
>         [Precision 7x50 Touchpad]
>         MatchBus=3Di2c
>         MatchUdevType=3Dtouchpad
>         MatchDMIModalias=3Ddmi:*svnDellInc.:pnPrecision7?50*
>         AttrInputPropDisable=3DINPUT_PROP_BUTTONPAD
>
> However, because of the change introduced in 37ef4c19b4 ("Input: clear
> BTN_RIGHT/MIDDLE on buttonpads") the BTN_RIGHT key bit is not mapped
> anymore breaking the device right click button.
>
> In order to fix the issue, create a quirk for the device forcing its
> button type to touchpad regardless of the value reported by the
> firmware.
>
> [1] https://gitlab.freedesktop.org/libinput/libinput/-/merge_requests/481
> [2] https://bugzilla.redhat.com/show_bug.cgi?id=3D1868789
>
> Fixes: 37ef4c19b4 ("Input: clear BTN_RIGHT/MIDDLE on buttonpads")
> Signed-off-by: Jos=C3=A9 Exp=C3=B3sito <jose.exposito89@gmail.com>
> ---

Thanks for the patch.
However, I'd like to put this one on hold for a bit. I am discussing
it right now with Peter and we are trying to see what are the possible
implications of starting to fix those in the kernel one by one.

So Jiri, please hold on before applying this one.

Cheers,
Benjamin

>  drivers/hid/hid-ids.h        |  3 +++
>  drivers/hid/hid-multitouch.c | 20 ++++++++++++++++++++
>  2 files changed, 23 insertions(+)
>
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 78bd3ddda442..6cf7a5b6835b 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -287,6 +287,9 @@
>
>  #define USB_VENDOR_ID_CIDC             0x1677
>
> +#define USB_VENDOR_ID_CIRQUE_CORP              0x0488
> +#define USB_DEVICE_ID_DELL_PRECISION_7X50      0x120A
> +
>  #define USB_VENDOR_ID_CJTOUCH          0x24b8
>  #define USB_DEVICE_ID_CJTOUCH_MULTI_TOUCH_0020 0x0020
>  #define USB_DEVICE_ID_CJTOUCH_MULTI_TOUCH_0040 0x0040
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 99eabfb4145b..f012cf8e0b8c 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -71,6 +71,7 @@ MODULE_LICENSE("GPL");
>  #define MT_QUIRK_SEPARATE_APP_REPORT   BIT(19)
>  #define MT_QUIRK_FORCE_MULTI_INPUT     BIT(20)
>  #define MT_QUIRK_DISABLE_WAKEUP                BIT(21)
> +#define MT_QUIRK_BUTTONTYPE_TOUCHPAD   BIT(22)
>
>  #define MT_INPUTMODE_TOUCHSCREEN       0x02
>  #define MT_INPUTMODE_TOUCHPAD          0x03
> @@ -194,6 +195,7 @@ static void mt_post_parse(struct mt_device *td, struc=
t mt_application *app);
>  #define MT_CLS_WIN_8_FORCE_MULTI_INPUT         0x0015
>  #define MT_CLS_WIN_8_DISABLE_WAKEUP            0x0016
>  #define MT_CLS_WIN_8_NO_STICKY_FINGERS         0x0017
> +#define MT_CLS_BUTTONTYPE_TOUCHPAD             0x0018
>
>  /* vendor specific classes */
>  #define MT_CLS_3M                              0x0101
> @@ -302,6 +304,15 @@ static const struct mt_class mt_classes[] =3D {
>                         MT_QUIRK_CONTACT_CNT_ACCURATE |
>                         MT_QUIRK_WIN8_PTP_BUTTONS,
>                 .export_all_inputs =3D true },
> +       { .name =3D MT_CLS_BUTTONTYPE_TOUCHPAD,
> +               .quirks =3D MT_QUIRK_ALWAYS_VALID |
> +                       MT_QUIRK_IGNORE_DUPLICATES |
> +                       MT_QUIRK_HOVERING |
> +                       MT_QUIRK_CONTACT_CNT_ACCURATE |
> +                       MT_QUIRK_STICKY_FINGERS |
> +                       MT_QUIRK_WIN8_PTP_BUTTONS |
> +                       MT_QUIRK_BUTTONTYPE_TOUCHPAD,
> +               .export_all_inputs =3D true },
>
>         /*
>          * vendor specific classes
> @@ -1286,6 +1297,9 @@ static int mt_touch_input_configured(struct hid_dev=
ice *hdev,
>             (app->buttons_count =3D=3D 1))
>                 td->is_buttonpad =3D true;
>
> +       if (app->quirks & MT_QUIRK_BUTTONTYPE_TOUCHPAD)
> +               td->is_buttonpad =3D false;
> +
>         if (td->is_buttonpad)
>                 __set_bit(INPUT_PROP_BUTTONPAD, input->propbit);
>
> @@ -1872,6 +1886,12 @@ static const struct hid_device_id mt_devices[] =3D=
 {
>                 MT_USB_DEVICE(USB_VENDOR_ID_CHUNGHWAT,
>                         USB_DEVICE_ID_CHUNGHWAT_MULTITOUCH) },
>
> +       /* Cirque Corp (Dell Precision 7550 and 7750 touchpad) */
> +       { .driver_data =3D MT_CLS_BUTTONTYPE_TOUCHPAD,
> +               HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
> +                       USB_VENDOR_ID_CIRQUE_CORP,
> +                       USB_DEVICE_ID_DELL_PRECISION_7X50) },
> +
>         /* CJTouch panels */
>         { .driver_data =3D MT_CLS_NSMU,
>                 MT_USB_DEVICE(USB_VENDOR_ID_CJTOUCH,
> --
> 2.25.1
>

