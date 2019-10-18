Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E73CCDC7DA
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 16:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634262AbfJROyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 10:54:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43880 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2634249AbfJROyY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 10:54:24 -0400
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5243451EF6
        for <stable@vger.kernel.org>; Fri, 18 Oct 2019 14:54:24 +0000 (UTC)
Received: by mail-qk1-f198.google.com with SMTP id d25so5732158qkk.17
        for <stable@vger.kernel.org>; Fri, 18 Oct 2019 07:54:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qcaI7zIpK9SuPKQNV9gKeRsG/9O1qHYAgHXML14no4g=;
        b=PTBZ9R1FoTpLs6cmyO0MFT07624H51neV6AMsczC6l//bBLDz78TcNmMTScOrbwXQu
         4oYCejhQGv7I/DC9uW/3VHN3BOEnenv9pliywqAvOCrgA8dVxVYqc6KG9NYAYOxRmN+X
         jBART94PUm0pZV1CBnGAAjnbLbGRsnBH35LyBKiOV3hnShYOg5O8dLnBnkoAKSmPk/O4
         LA+gRupvNZnxOOvio2ZdLZ71uvLxe5W0hR4GMwD4HkypRbN7UrrMy2/52NzX4Zo+bTBO
         TA/ESm5q7ZEvT1Hw2ReI7okn5c5oJlStrtPe5X4hVJPKR9Pdd2+K96mT5d+QeDy2xsc4
         lFNw==
X-Gm-Message-State: APjAAAVzo8ciyWf7vPTB/rBP8D6esJfr/EubQrq2TgDG8Woa0hbHFE/h
        Df455zd9hgFQ8eYT3ps4bl8Mbb18y20X30CswZfuqMNSd+Afx6sGt3tDadTb4uRUzxdE6Sf2/aZ
        v+ivAHZFkjokxsUge3WhRAnOVcZa8qaE4
X-Received: by 2002:ac8:550d:: with SMTP id j13mr7513026qtq.260.1571410463635;
        Fri, 18 Oct 2019 07:54:23 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy3ELLoeoYcLXuRgtoXts+oXqWSLPdN2EXhotCIFdfniMF+ZbWjpVl3dXCWV80Dea2w0Fe54Xcz4dDyaDb+co8=
X-Received: by 2002:ac8:550d:: with SMTP id j13mr7513016qtq.260.1571410463450;
 Fri, 18 Oct 2019 07:54:23 -0700 (PDT)
MIME-Version: 1.0
References: <20191007185626.247959-1-hdegoede@redhat.com>
In-Reply-To: <20191007185626.247959-1-hdegoede@redhat.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Fri, 18 Oct 2019 16:54:12 +0200
Message-ID: <CAO-hwJLeSLQSyi7yV1ch4vXOSfL-SS9-3iZf0fzP-EhNW=Qf8A@mail.gmail.com>
Subject: Re: [PATCH] HID: i2c-hid: add Trekstor Primebook C11B to descriptor override
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 7, 2019 at 8:56 PM Hans de Goede <hdegoede@redhat.com> wrote:
>
> The Primebook C11B uses the SIPODEV SP1064 touchpad. There are 2 versions
> of this 2-in-1 and the touchpad in the older version does not supply
> descriptors, so it has to be added to the override list.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---

Thanks!

Applied to for-5.4/upstream-fixes

Cheers,
Benjamin

>  drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>
> diff --git a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
> index 75078c83be1a..d31ea82b84c1 100644
> --- a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
> +++ b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
> @@ -322,6 +322,25 @@ static const struct dmi_system_id i2c_hid_dmi_desc_override_table[] = {
>                 },
>                 .driver_data = (void *)&sipodev_desc
>         },
> +       {
> +               /*
> +                * There are at least 2 Primebook C11B versions, the older
> +                * version has a product-name of "Primebook C11B", and a
> +                * bios version / release / firmware revision of:
> +                * V2.1.2 / 05/03/2018 / 18.2
> +                * The new version has "PRIMEBOOK C11B" as product-name and a
> +                * bios version / release / firmware revision of:
> +                * CFALKSW05_BIOS_V1.1.2 / 11/19/2018 / 19.2
> +                * Only the older version needs this quirk, note the newer
> +                * version will not match as it has a different product-name.
> +                */
> +               .ident = "Trekstor Primebook C11B",
> +               .matches = {
> +                       DMI_EXACT_MATCH(DMI_SYS_VENDOR, "TREKSTOR"),
> +                       DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Primebook C11B"),
> +               },
> +               .driver_data = (void *)&sipodev_desc
> +       },
>         {
>                 .ident = "Direkt-Tek DTLAPY116-2",
>                 .matches = {
> --
> 2.23.0
>
