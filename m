Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A659BD4381
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 16:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbfJKO4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 10:56:06 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36667 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726332AbfJKO4F (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 10:56:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570805765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FiDA3QBts5KfCGtUBop3Hw/Oo24dQFtETwEmLErKTH4=;
        b=UQq0okW5fJ9nM/xjDeRWpTdBrPL6edweLbxbyXgl8O8+QFfS3Hq9hyaF8Ls8aGkJXuoSoV
        bSLkWh/OGfbApjzvGz4z0unCtbPoDHnDOSvqJ7anaez5EyWnoB95ldcri3D5wUXwS0IN6+
        ignD2g3eMZK63GyS6v8MkIYIVM25mN8=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-V41k6ef3OCaxnthDm-WQMA-1; Fri, 11 Oct 2019 10:56:03 -0400
Received: by mail-qt1-f200.google.com with SMTP id 59so9688617qtc.5
        for <stable@vger.kernel.org>; Fri, 11 Oct 2019 07:56:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JATZHH1NgtP8u5fFJewNDLUv2TCv4ss7bPRKEHICbr0=;
        b=YH7FlxxgK78k7xGONDVhJ3uaBFfwOKVRs+Tc3bfVJj656nCxGwpVQh7T+DKHLIb4Qv
         4+YR6tfda/icjKb1x8oDFZPJhsGhuxP2ZfM3ZlxBOaqnPWBKjqd9kT4OELyBWbEmEBN3
         11p7CJNrJHCztfgF62DTfnk93ykbmQKGUSh3VTyMeBw/nt9Zd6ETeQir5E9ITJ2fSnnr
         U4OUVcPkmdCEGNNdgB0cjPjYMGTxpGap/igHszMQ3RA5HFmrrcEZLFXBggHo902B6rgc
         bk/Y3v1zfELVOY8wRk71xEW+QbgPmM18jfSmCvdUqiLy7hl/6BvjuTF7uDS7dthkLRBI
         eWKw==
X-Gm-Message-State: APjAAAUOgICPVB81OB2zZLDZ0cE/sbZnw8avwv4ebZDMjrHHiCSSo/xf
        0A7Lz9EaAjhk/bfE7qMvuI/H5UE5uO2bO0F3oYllWJHj+ux03GQ3ankrmsrhTqXg67NocR+02+2
        08Nao1MaOZuY+W+omOOjKzjocimcO2WVx
X-Received: by 2002:ae9:f306:: with SMTP id p6mr16089648qkg.169.1570805763038;
        Fri, 11 Oct 2019 07:56:03 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyhRxyO1bcuIfWi9+9ILjcQeYiWIMiW4HueiZFd7MJiAIFazyIv6uqj4C9dxgo9WNAj6xf5SxYEm9R5x2IqA4c=
X-Received: by 2002:ae9:f306:: with SMTP id p6mr16089632qkg.169.1570805762825;
 Fri, 11 Oct 2019 07:56:02 -0700 (PDT)
MIME-Version: 1.0
References: <20191007051240.4410-1-andrew.smirnov@gmail.com> <20191007051240.4410-4-andrew.smirnov@gmail.com>
In-Reply-To: <20191007051240.4410-4-andrew.smirnov@gmail.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Fri, 11 Oct 2019 16:55:51 +0200
Message-ID: <CAO-hwJJ8tp4Rqte-umv9e=S5evR5oJTErsNR0Wk-z8wcbtR0wg@mail.gmail.com>
Subject: Re: [PATCH 3/3] HID: logitech-hidpp: add G920 device validation quirk
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Sam Bazely <sambazley@fastmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Henrik Rydberg <rydberg@bitmath.org>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Austin Palmer <austinp@valvesoftware.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>
X-MC-Unique: V41k6ef3OCaxnthDm-WQMA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 7, 2019 at 7:13 AM Andrey Smirnov <andrew.smirnov@gmail.com> wr=
ote:
>
> G920 device only advertises REPORT_ID_HIDPP_LONG and
> REPORT_ID_HIDPP_VERY_LONG in its HID report descriptor, so querying
> for REPORT_ID_HIDPP_SHORT with optional=3Dfalse will always fail and
> prevent G920 to be recognized as a valid HID++ device.
>
> Modify hidpp_validate_device() to check only REPORT_ID_HIDPP_LONG with
> optional=3Dfalse on G920 to fix this.
>
> Fixes: fe3ee1ec007b ("HID: logitech-hidpp: allow non HID++ devices to be =
handled by this module")
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D204191
> Reported-by: Sam Bazely <sambazley@fastmail.com>
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> Cc: Jiri Kosina <jikos@kernel.org>
> Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Cc: Henrik Rydberg <rydberg@bitmath.org>
> Cc: Sam Bazely <sambazley@fastmail.com>
> Cc: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
> Cc: Austin Palmer <austinp@valvesoftware.com>
> Cc: linux-input@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
>  drivers/hid/hid-logitech-hidpp.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-=
hidpp.c
> index cadf36d6c6f3..f415bf398e17 100644
> --- a/drivers/hid/hid-logitech-hidpp.c
> +++ b/drivers/hid/hid-logitech-hidpp.c
> @@ -3511,6 +3511,12 @@ static bool hidpp_validate_report(struct hid_devic=
e *hdev, int id,
>
>  static bool hidpp_validate_device(struct hid_device *hdev)
>  {
> +       struct hidpp_device *hidpp =3D hid_get_drvdata(hdev);
> +
> +       if (hidpp->quirks & HIDPP_QUIRK_CLASS_G920)
> +               return hidpp_validate_report(hdev, REPORT_ID_HIDPP_LONG,
> +                                            HIDPP_REPORT_SHORT_LENGTH, f=
alse);
> +

with https://patchwork.kernel.org/patch/11184749/ we also have a need
for such a trick for BLE mice.

I wonder if we should not have a more common way of validating the devices

This can probably be handled later, as your patch fixes the current devices=
.

Cheers,
Benjamin

>         return hidpp_validate_report(hdev, REPORT_ID_HIDPP_SHORT,
>                                      HIDPP_REPORT_SHORT_LENGTH, false) &&
>                hidpp_validate_report(hdev, REPORT_ID_HIDPP_LONG,
> --
> 2.21.0
>

