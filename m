Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3582616A9C
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 20:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfEGSnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 14:43:55 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40461 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfEGSnz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 14:43:55 -0400
Received: by mail-lj1-f196.google.com with SMTP id d15so15269898ljc.7;
        Tue, 07 May 2019 11:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MTOHP6F/0obsnMO5RHpAHRXQRdtgQj1GXLteD8Q5aeo=;
        b=drZB7KzWbLddiQsxBcUFEHKdh6tdqgNqbFZOEs5rpArVKqFAquyNrigRYCaHfvIuqF
         cwK3TIboRmpdPXsasfJjJhffbsNHfjosuwQsbHRwcDFXFnAKTB6xcjudj+JKtJVDX0nx
         VZmyex/xSmkYgoaBrXoLnbiEjVrKn8jskWYGw1UetE9s/yS/rpHa99AlN0PPt/BfDE4N
         eMOBjlA3J7lYDcnBxpkB+hweXvQj+Zehj39BI6nLMfHgrAGs1IwLQYYKvD8Rs4V8nyG/
         D41xR45UViTnRk/2NZIB8s6HbIn8SWy0rtNvdZhNCGt5x1hdN9y1O5JCyRFddWYCU6nM
         kdng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MTOHP6F/0obsnMO5RHpAHRXQRdtgQj1GXLteD8Q5aeo=;
        b=aSvkZAqz/HvBDxzQYIs30gZ6/B9PQwvPEgT9dBsAcWwErJHBtOkTYrctTliltlwoSw
         tRAS5kZyr0Ju6H1+rDkvMYphGSVpOocv/wVAUM1dB3cC7ROKadseEt9Nc5uVS7aN3M8O
         VdK90mB74G/7i96oCWdiLS20YTS0EgRSwii+bM4jnxpz1x2XAWhOh9M/mBEylGtpo/ND
         PxpzhlqMpj/VDjZemhztuQpCKTlih7u+rMoXb06ReVtofiP2vWX6o97gRIe7i9idJg+e
         4HdeytSBbS3nIlgqnior7sor1N3INjaBPS1pq33/uP/H+6+5H8FaAfuuyhTOtUTtQFgw
         qtPQ==
X-Gm-Message-State: APjAAAUK5nziRoFQz/meY8jtRwnqtVafh2FkEoAia3c/xHPDqmI8IgVb
        p9Eck7JgMI4rjqEFGC2GXJvnk+U3N1kGQM9y02OYOA==
X-Google-Smtp-Source: APXvYqz77EQOkAasYxlchH/UHy2FA2xAuzpcZE2KK65BeR6tBSrLVPSCy+WLci8wP4QaflygEHw5Ojb9Y3JU5kqA010=
X-Received: by 2002:a2e:6e01:: with SMTP id j1mr17454402ljc.85.1557254632236;
 Tue, 07 May 2019 11:43:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190424221258.19992-1-jason.gerecke@wacom.com>
In-Reply-To: <20190424221258.19992-1-jason.gerecke@wacom.com>
From:   Jason Gerecke <killertofu@gmail.com>
Date:   Tue, 7 May 2019 11:43:40 -0700
Message-ID: <CANRwn3TcnEPASa_qqiKPgTR743uKBBX+cJ8uQecj_DsScAKJbg@mail.gmail.com>
Subject: Re: [PATCH 1/2] HID: wacom: Don't set tool type until we're in range
To:     Linux Input <linux-input@vger.kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        "# v3.17+" <stable@vger.kernel.org>,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Haven't heard anything back from you about this patch set, Benjamin.
Just making sure it doesn't get lost down a crack :)

Jason
---
Now instead of four in the eights place /
you=E2=80=99ve got three, =E2=80=98Cause you added one  /
(That is to say, eight) to the two,     /
But you can=E2=80=99t take seven from three,    /
So you look at the sixty-fours....


On Wed, Apr 24, 2019 at 3:13 PM Gerecke, Jason <killertofu@gmail.com> wrote=
:
>
> From: Jason Gerecke <jason.gerecke@wacom.com>
>
> The serial number and tool type information that is reported by the table=
t
> while a pen is merely "in prox" instead of fully "in range" can be stale
> and cause us to report incorrect tool information. Serial number, tool
> type, and other information is only valid once the pen comes fully in ran=
ge
> so we should be careful to not use this information until that point.
>
> In particular, this issue may cause the driver to incorectly report
> BTN_TOOL_RUBBER after switching from the eraser tool back to the pen.
>
> Fixes: a48324de6d ("HID: wacom: Bluetooth IRQ for Intuos Pro should handl=
e prox/range")
> Cc: <stable@vger.kernel.org> # 4.11+
> Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
> Reviewed-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
> ---
>  drivers/hid/wacom_wac.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
> index 747730d32ab6..4c1bc239207e 100644
> --- a/drivers/hid/wacom_wac.c
> +++ b/drivers/hid/wacom_wac.c
> @@ -1236,13 +1236,13 @@ static void wacom_intuos_pro2_bt_pen(struct wacom=
_wac *wacom)
>                 /* Add back in missing bits of ID for non-USI pens */
>                 wacom->id[0] |=3D (wacom->serial[0] >> 32) & 0xFFFFF;
>         }
> -       wacom->tool[0]   =3D wacom_intuos_get_tool_type(wacom_intuos_id_m=
angle(wacom->id[0]));
>
>         for (i =3D 0; i < pen_frames; i++) {
>                 unsigned char *frame =3D &data[i*pen_frame_len + 1];
>                 bool valid =3D frame[0] & 0x80;
>                 bool prox =3D frame[0] & 0x40;
>                 bool range =3D frame[0] & 0x20;
> +               bool invert =3D frame[0] & 0x10;
>
>                 if (!valid)
>                         continue;
> @@ -1251,9 +1251,24 @@ static void wacom_intuos_pro2_bt_pen(struct wacom_=
wac *wacom)
>                         wacom->shared->stylus_in_proximity =3D false;
>                         wacom_exit_report(wacom);
>                         input_sync(pen_input);
> +
> +                       wacom->tool[0] =3D 0;
> +                       wacom->id[0] =3D 0;
> +                       wacom->serial[0] =3D 0;
>                         return;
>                 }
> +
>                 if (range) {
> +                       if (!wacom->tool[0]) { /* first in range */
> +                               /* Going into range select tool */
> +                               if (invert)
> +                                       wacom->tool[0] =3D BTN_TOOL_RUBBE=
R;
> +                               else if (wacom->id[0])
> +                                       wacom->tool[0] =3D wacom_intuos_g=
et_tool_type(wacom->id[0]);
> +                               else
> +                                       wacom->tool[0] =3D BTN_TOOL_PEN;
> +                       }
> +
>                         input_report_abs(pen_input, ABS_X, get_unaligned_=
le16(&frame[1]));
>                         input_report_abs(pen_input, ABS_Y, get_unaligned_=
le16(&frame[3]));
>
> --
> 2.21.0
>
