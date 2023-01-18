Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515B36712A4
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 05:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjAREep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 23:34:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjAREem (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 23:34:42 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB08853E62
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 20:34:41 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id b10so3078503pjo.1
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 20:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ekepBrhxl/81ZRjhtoKyLZ9/J5n/6wX9lCeCLJRBaSE=;
        b=YQ5PyRSx66ogTt9Tp2mO1vQ2MrDl2Q5uaq6ppSXcklktAEngikxSoLX51hsoXwaThi
         C+U2ULT5tBnfQkCocHuubK7A8KB8d93I29dfVwGhzr4+UQFjZC4rw1M4vIyr8SFxNZhS
         8sikRHGq81Yi+atqwIFU4pJA+t3/GouDFOzud1ORWdMMLWGcgHhF8sUSbqQYZvz52icN
         Cp5YvrjQO3GBdfhhMkQnkulD12S+a37LcQ13p+RumJaqpIyaoO9hrOu+Zu3Gsl8brQym
         CkrJt+v30vgfViPI8y0nUDlAteY9WBqSQP7zZXZ6LRfLnYbrhtpcaYW2DMrNzTo4QeSG
         bgpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ekepBrhxl/81ZRjhtoKyLZ9/J5n/6wX9lCeCLJRBaSE=;
        b=GBg2jSYytA2iEAwyf8pdEklWi2BXOI/gSAkPbPwj0+D22X2NsANQs55qDj9Mfx1wxT
         gpxp1q35XmJ2x/nYFAq6yDSd8t6DZydYz7jEZR0KH9VFqS1eOHfN40MwyA1+zzuLHR62
         g9zQVep9/Kuf4oB4av8TxOiZtSbv+/uYqZEVCkFQHKFATp8kTtoSbOVCw/BeIRaxWG1t
         hYYxoRHWfx6PT0SGKsWfwMZ4vNTyrDSDhvDtRbE8vN2iqD/VY+jiOIJTnNKjpl1MBtWE
         TswjhI6WGEZbuPfO3TdXhs9OwEg5/0hJw1mc6L4JMGG0vgPl9ArFmhcQWPlI/mFGyXAN
         IXCA==
X-Gm-Message-State: AFqh2koFr1AFN2XlyOBX+xQJe3GQn8ufL5fsNTadozGkRWLyY7At0DYy
        Zw8YcolFwARaT2kvs0Od81tFwg==
X-Google-Smtp-Source: AMrXdXs6+ewPotUsgsdS6utrX52/DIDc2wtC3Qc4fuM1RpmPsQ829ZBmtYSv9fGVDjQiJuJIlTRhlg==
X-Received: by 2002:a05:6a20:c183:b0:b8:ca86:f3ab with SMTP id bg3-20020a056a20c18300b000b8ca86f3abmr495506pzb.2.1674016480682;
        Tue, 17 Jan 2023 20:34:40 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:f51a:aa8f:95e9:9c5])
        by smtp.gmail.com with ESMTPSA id x73-20020a62864c000000b0058d8f23af26sm5960782pfd.157.2023.01.17.20.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 20:34:39 -0800 (PST)
Date:   Tue, 17 Jan 2023 20:34:34 -0800
From:   Benson Leung <bleung@google.com>
To:     Prashant Malani <pmalani@chromium.org>
Cc:     linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        bleung@chromium.org, stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: Re: [PATCH] usb: typec: altmodes/displayport: Update active state
Message-ID: <Y8d22ssmBmbITHyD@google.com>
References: <20230118031514.1278139-1-pmalani@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Vjp3LjpA+ox3SLFy"
Content-Disposition: inline
In-Reply-To: <20230118031514.1278139-1-pmalani@chromium.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Vjp3LjpA+ox3SLFy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Prashant,

On Wed, Jan 18, 2023 at 03:15:15AM +0000, Prashant Malani wrote:
> Update the altmode "active" state when we receive Acks for Enter and
> Exit Mode commands. Having the right state is necessary to change Pin
> Assignments using the 'pin_assignment" sysfs file.
>=20
> Fixes: 0e3bb7d6894d ("usb: typec: Add driver for DisplayPort alternate mo=
de")
> Cc: stable@vger.kernel.org
> Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Signed-off-by: Prashant Malani <pmalani@chromium.org>

Reviewed-by: Benson Leung <bleung@chromium.org>


> ---
>  drivers/usb/typec/altmodes/displayport.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/usb/typec/altmodes/displayport.c b/drivers/usb/typec=
/altmodes/displayport.c
> index 06fb4732f8cd..bc1c556944d6 100644
> --- a/drivers/usb/typec/altmodes/displayport.c
> +++ b/drivers/usb/typec/altmodes/displayport.c
> @@ -277,9 +277,11 @@ static int dp_altmode_vdm(struct typec_altmode *alt,
>  	case CMDT_RSP_ACK:
>  		switch (cmd) {
>  		case CMD_ENTER_MODE:
> +			typec_altmode_update_active(alt, true);
>  			dp->state =3D DP_STATE_UPDATE;
>  			break;
>  		case CMD_EXIT_MODE:
> +			typec_altmode_update_active(alt, false);
>  			dp->data.status =3D 0;
>  			dp->data.conf =3D 0;
>  			break;
> --=20
> 2.39.0.314.g84b9a713c41-goog
>=20

--=20
Benson Leung
Staff Software Engineer
Chrome OS Kernel
Google Inc.
bleung@google.com
Chromium OS Project
bleung@chromium.org

--Vjp3LjpA+ox3SLFy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQCtZK6p/AktxXfkOlzbaomhzOwwgUCY8d22AAKCRBzbaomhzOw
woPJAP9ZTCTrrDZa2Ve5dXDZPWih4kCSyO5wiZh1+UeRL/JQFwEA4tGtERuBhDXJ
NLBK6pJtLyLmVo/1vXVSeeqS1hjyjAY=
=Ih/e
-----END PGP SIGNATURE-----

--Vjp3LjpA+ox3SLFy--
