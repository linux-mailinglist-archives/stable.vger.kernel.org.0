Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B323D0B5A
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 11:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbfJIJfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 05:35:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49467 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725935AbfJIJfj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 05:35:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570613737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wIiSU13TZ9jZ/7OA/RD49mIlEHsSk7raamqZN0rBDDk=;
        b=E/1OMMUuOzElkBnJiAfN4juycfEMlbX9OPxGO0axzktLaGZdo4PXPTq5I5NaWiClAAoLQA
        OQJ0NZOQMZ5e6JUU7FiLKZZFdw7PK9h+m9DUC/yaYPkk3ewpXz5nqSX5NmAfL340ckXyfH
        Kdlpo4rdzp9ndU+Vs8Z73+m9sC6blrg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-hdip20V6MdaAV36wFN0AJQ-1; Wed, 09 Oct 2019 05:35:36 -0400
Received: by mail-ed1-f72.google.com with SMTP id j8so1009805edl.11
        for <stable@vger.kernel.org>; Wed, 09 Oct 2019 02:35:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m+EOjV/VuUDotBWP2JnVujV9Hl44RjnHb49OdTmGiVo=;
        b=GXED+xjPAlsXYh32IqK0oQFpmOpxPV39S22/EVFFcv6lR5PN4y0XD0JWjBsOrqjpJY
         6Jat/6hQK40yWsHfj1rUHAtZ6Xu/0lawK/skzqC06VUbW9/eTdwlaxNSiLa/+pwpNrRk
         xmmwYqEKZBz6mlblxhLClXg8L/u1OVQ0I1/KHr3FayovErPo+0ow8KMLdGBEw8py32Ir
         jeR4y9XDz3oeATkbYdG7Hgt3UaJ9o43u54A2vikmF6MVNGROksR7qHIy0zBvrutxFLok
         sAJYHmJbJBfORalQkeG7I8RsyzZi6sWq+DGewPWy0NR17+7HcLAFg6DwoG9ZrBKOZ2mP
         L/Qg==
X-Gm-Message-State: APjAAAUq5vy7oug2MwQX+6c3csK2GYGXUZYNtP+kBbp0jyReQ9QpGlfI
        jhGfse+dvljUvfMF4VlGCYjsLpFb43B3xNMTUHXSRy6dbCWNfgnQFDnkzBKUGurUSoADop7wzve
        Z+4l5+aXq2iguxowY
X-Received: by 2002:a05:6402:88d:: with SMTP id e13mr1973734edy.246.1570613734708;
        Wed, 09 Oct 2019 02:35:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxZmm9V3I2YhZskIm1cKbboIQy+yXFRdaHYKIvjJsZB5tj/g9zi5Ehci5uDueRmNCpIZouewQ==
X-Received: by 2002:a05:6402:88d:: with SMTP id e13mr1973726edy.246.1570613734526;
        Wed, 09 Oct 2019 02:35:34 -0700 (PDT)
Received: from shalem.localdomain (2001-1c00-0c14-2800-ec23-a060-24d5-2453.cable.dynamic.v6.ziggo.nl. [2001:1c00:c14:2800:ec23:a060:24d5:2453])
        by smtp.gmail.com with ESMTPSA id l7sm271377edv.84.2019.10.09.02.35.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 02:35:33 -0700 (PDT)
Subject: Re: [PATCH] staging: rtl8723bs: hal: Fix memcpy calls
To:     Denis Efremov <efremov@linux.com>, devel@driverdev.osuosl.org
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bastien Nocera <hadess@hadess.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <jes.sorensen@gmail.com>, stable@vger.kernel.org
References: <20190930110141.29271-1-efremov@linux.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <94af475e-dd7a-6066-146a-30a9915cd325@redhat.com>
Date:   Wed, 9 Oct 2019 11:35:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20190930110141.29271-1-efremov@linux.com>
Content-Language: en-US
X-MC-Unique: hdip20V6MdaAV36wFN0AJQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Denis,

On 30-09-2019 13:01, Denis Efremov wrote:
> memcpy() in phy_ConfigBBWithParaFile() and PHY_ConfigRFWithParaFile() is
> called with "src =3D=3D NULL && len =3D=3D 0". This is an undefined behav=
ior.
> Moreover this if pre-condition "pBufLen && (*pBufLen =3D=3D 0) && !pBuf"
> is constantly false because it is a nested if in the else brach, i.e.,
> "if (cond) { ... } else { if (cond) {...} }". This patch alters the
> if condition to check "pBufLen && pBuf" pointers are not NULL.
>=20
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Bastien Nocera <hadess@hadess.net>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Jes Sorensen <jes.sorensen@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
> Not tested. I don't have the hardware. The fix is based on my guess.

Thsnk you for your patch.

So I've been doing some digging and this code normally never executes.

For this to execute the user would need to change the rtw_load_phy_file mod=
ule
param from its default of 0x44 (LOAD_BB_PG_PARA_FILE | LOAD_RF_TXPWR_LMT_PA=
RA_FILE)
to something which includes 0x02 (LOAD_BB_PARA_FILE) as mask.

And even with that param set for this code to actually do something /
for pBuf to ever not be NULL the following conditions would have to
be true:

1) Set the rtw_load_phy_file module param from its default of
    0x44 (LOAD_BB_PG_PARA_FILE | LOAD_RF_TXPWR_LMT_PARA_FILE) to something
    which includes 0x02 as mask; and
2) Set rtw_phy_file_path module parameter to say "/lib/firmware/"; and
3) Store a /lib/firmware/rtl8723b/PHY_REG.txt file in the expected format.

So I've come to the conclusion that all the phy_Config*WithParaFile functio=
ns
(and a bunch of stuff they use) can be removed.

I will prepare and submit a patch for this.

Regards,

Hans



>=20
>   drivers/staging/rtl8723bs/hal/hal_com_phycfg.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c b/drivers/sta=
ging/rtl8723bs/hal/hal_com_phycfg.c
> index 6539bee9b5ba..0902dc3c1825 100644
> --- a/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
> +++ b/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
> @@ -2320,7 +2320,7 @@ int phy_ConfigBBWithParaFile(
>   =09=09=09}
>   =09=09}
>   =09} else {
> -=09=09if (pBufLen && (*pBufLen =3D=3D 0) && !pBuf) {
> +=09=09if (pBufLen && pBuf) {
>   =09=09=09memcpy(pHalData->para_file_buf, pBuf, *pBufLen);
>   =09=09=09rtStatus =3D _SUCCESS;
>   =09=09} else
> @@ -2752,7 +2752,7 @@ int PHY_ConfigRFWithParaFile(
>   =09=09=09}
>   =09=09}
>   =09} else {
> -=09=09if (pBufLen && (*pBufLen =3D=3D 0) && !pBuf) {
> +=09=09if (pBufLen && pBuf) {
>   =09=09=09memcpy(pHalData->para_file_buf, pBuf, *pBufLen);
>   =09=09=09rtStatus =3D _SUCCESS;
>   =09=09} else
>=20

