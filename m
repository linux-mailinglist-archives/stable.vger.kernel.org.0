Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8766950BC06
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 17:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358425AbiDVPuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 11:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233213AbiDVPuC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 11:50:02 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2A95D666;
        Fri, 22 Apr 2022 08:47:08 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id w19so14973355lfu.11;
        Fri, 22 Apr 2022 08:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qZ1iKOWejQmCTdi0PJCvl5WKNY0DydrHfyTlkB3tubg=;
        b=BB1ySnH7FPuAdxwD3/Q2LbcCF/8aoJEQz6O6CL3KXyPaZVqqmTRNg7FM6fqLNBU/6E
         ZgZT1+axzJrlIJ2c56atI4S0K3VyHupvxg3zoHMcOW3X312vDvlxSgWHdRAWsgogKNxH
         k3TRTY75AwaNBjpmRd0EEm/2qQg71cd6wuxexDYhb2jZ56VLV71IRGWijBcqxWvvznib
         MiKkKkIQZfUGAUd20Sz65dYCWJ6ITTwL+daMZyugJ2x3TXE17b89xHCyVOLqUnRDFq3I
         tgxvJfnAEOaxqjaCE4i+bqOdXinB03XG/+6NDsGt5xHJYm3i5TzlCQ2RgtJty1xixUAw
         vRuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qZ1iKOWejQmCTdi0PJCvl5WKNY0DydrHfyTlkB3tubg=;
        b=4wCZ9ZEHDhUh/nMWZBze31YGJHGw3bIt11TLfYfndsRCVlJPMtLgMAerVdJKua5EGJ
         SSKVguN6p130upaUsa8JmxPPUomdXnxB+rIxag70PTql5AJVo361qXHuyhkFnBRzujG8
         0btTPJn9wSGCV6LrH97fWC6r9hyk3Ly4Ejb/bxi/ffJ43tvbqlDreeD+m0bjOekX0naW
         cVqE1YwRqclH35HubQCxozi1e0RUcBABzzLjoExVQv2K31Miw6gyWXmxct9WJvNJ+uoU
         mPH30tU9qAmagqI+AX570wQNKS7l/ANUYEfcMk7MJ+rDhuiWrHWoYnPaZ6q2RA/r7NWd
         /Ytw==
X-Gm-Message-State: AOAM531ff+ZvU3sFGKW91YRlWavMdsLM8fopmgZixqKbfyuZ9QppUhy3
        6zAAOCPeRiPEwPz6cCJkolw=
X-Google-Smtp-Source: ABdhPJyVXYQcSohXYjuO/DCvdMk0mu20HEY/56MN7dJ7k5Hu9huyBeItnSsHrZHYhEKDWw4/Lz0UQw==
X-Received: by 2002:a05:6512:1398:b0:448:bda0:99f2 with SMTP id p24-20020a056512139800b00448bda099f2mr3564545lfa.681.1650642426140;
        Fri, 22 Apr 2022 08:47:06 -0700 (PDT)
Received: from orome ([62.96.65.119])
        by smtp.gmail.com with ESMTPSA id n2-20020a19d602000000b0046d150c112dsm262551lfg.234.2022.04.22.08.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 08:47:04 -0700 (PDT)
Date:   Fri, 22 Apr 2022 17:47:02 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Max Kellermann <max.kellermann@gmail.com>
Cc:     linux-pwm@vger.kernel.org, u.kleine-koenig@pengutronix.de,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        andrey@lebedev.lt, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] pwm-sun4i: convert "next_period" to local variable
Message-ID: <YmLN9mZ9O58F/e1q@orome>
References: <20220125123429.3490883-1-max.kellermann@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HISICXV0FqZNY31B"
Content-Disposition: inline
In-Reply-To: <20220125123429.3490883-1-max.kellermann@gmail.com>
User-Agent: Mutt/2.2.1 (c8109e14) (2022-02-19)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--HISICXV0FqZNY31B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 25, 2022 at 01:34:27PM +0100, Max Kellermann wrote:
> Its value is calculated in sun4i_pwm_apply() and is used only there.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Max Kellermann <max.kellermann@gmail.com>
> ---
>  drivers/pwm/pwm-sun4i.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)

Patches applied, though I dropped the Cc: stable on patches 1 and 2.

Thanks,
Thierry

--HISICXV0FqZNY31B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmJizfYACgkQ3SOs138+
s6EFThAAhoicE6orGW9RTkMBtQor7rH90WjIVP9VZBgJv+VNLaWneoRnfMjihVtw
hmF2ZNnQVvQnMOHKMGziE89tSPNM0juNl68v3E6IzkSNJDj4lI1pE3AxWGVb8ZgY
/0DpY+2tQ68o18Fl+yU2qidINiGRaYuvBehqeLyfIKQf7g7208IanyA63hs+OGny
KPkJwztcbBbdSqDDlvHS2XQgI+6GoaJtokz1c7WIjEDqRaong027x/3sFJ76K/N1
Eb0HgQGfI7N7We7Xw59aD7pYAOuL7YYAp6bZTz69S1zwJeLJpU/vscvJHT24fVjy
BlngF1KoMhd67nziTenSKIBp5sU3vwtltnTmBkNmLWhrNDJ27lsFnr5GgsgLKJ0k
DBuco4Cnwnqb0e1hY1HUMTnyiyxXGcRGZXSjSmCYzwVFp0NJ7UsaEooxSRynw9PO
pdzZNJ4UGzbvf0zBZNmXE4BVNop3JpQpK1QEcO0R3t5a0RiZSwbCVQQtgRbe4uSz
+44YBsE00gA9/n15GjacMK5Bwgmev+RbWRCOSodL6b18aQyWDxdrbx422dDNLDxd
ci52ANa3s15aEih6DCZLiet5WzI390gatD3j4VrrwxD5+WjVzvG2oWT+vVRs5YxC
eHTFSqFxQekr/MT/CNIXeAP3Io2a4h2okh1kqHVrhX2miHeHzxs=
=EMSF
-----END PGP SIGNATURE-----

--HISICXV0FqZNY31B--
