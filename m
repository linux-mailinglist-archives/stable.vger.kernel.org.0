Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 323E46ABFBF
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 13:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjCFMlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 07:41:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjCFMlO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 07:41:14 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79552B2B4
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 04:41:12 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id w23so10215674qtn.6
        for <stable@vger.kernel.org>; Mon, 06 Mar 2023 04:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678106472;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6XrdgZjMDlRLFUbyVPxJfBpwx76lgBG7lHXmFXxIIe0=;
        b=U92togDggQfebFB+oCNSCcXsZbxpGePUFP3ikADRG6yzR7syMch4sYx3BcPbAHkflT
         XK1Kj+4jKssvq/kJJq1e8naG9O8KHAnyfxBVzOBoFkIpBEWAh9DPnvxr05kI8FLpl0aj
         kumC2G3oTOFIk7cWg3iIQjO12DUpbeZ27eyh+PD142mAqUYXfI6XQc2bQW16b7Dm6Anl
         iVr8ApM5YTEDLOSpsYjlxQZKpKvTHphg2oAtc/e1B3uZ5iiD/PjC8O0R6RyChc+SzMqS
         e4Wfc2RpqIbpxMTo2MpTDso63NBC9hYdfTUUs4kRyuvJG7E97nsjdO5rurLS0Myq7xaF
         4vvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678106472;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6XrdgZjMDlRLFUbyVPxJfBpwx76lgBG7lHXmFXxIIe0=;
        b=3Uzdwx8UAjHQTHwQx7k9/DXu7HXMi9+QZFxo1FgV2+5WtMT4mcsFwByPeIzZV4AC4X
         my7d/MfWZME3lBep7WIFexYAjC/sQBSQfnGnUB4mQ0lF6B5b+5JTd06DHyuzYsgBrKU9
         0HNXhfoOTXS40bfQy0l44tYAAdMqazJth5ikbn6htwVi0ynLWWem34op86hXCwFHnLgQ
         q9E/duhG6Xf1iVqHzXmrn222kiIPBWfx/tZrmg4ZyA1cBa1D2DdrYUuNG8hFdF0teBas
         RspiBvxq4Q69h2qVct5DzRcX8PWl6nhlMK7UW8KNz9c/sb3qoPZjh30lbofmYM1mVKyK
         L/zg==
X-Gm-Message-State: AO0yUKWFshEuTKmWlnnL+dWC1n7pG9Rss0puzVtfDkrWLqPCqurjRYfW
        1A5woUE+KF9/J9kl/zsLFxicZXGfk3ievoIC2ZU=
X-Google-Smtp-Source: AK7set9TfEy2X1DOujpMKIH+igyL2YEO/hoGzriXXAWSRxRsb3UHkcR/L6n7Onm7AHa1lQCQR1vI8g==
X-Received: by 2002:a05:622a:34b:b0:3b8:6ca4:bb23 with SMTP id r11-20020a05622a034b00b003b86ca4bb23mr15273152qtw.15.1678106471798;
        Mon, 06 Mar 2023 04:41:11 -0800 (PST)
Received: from fedora (69-109-179-158.lightspeed.dybhfl.sbcglobal.net. [69.109.179.158])
        by smtp.gmail.com with ESMTPSA id l19-20020a05620a211300b007423c122457sm7340219qkl.63.2023.03.06.04.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 04:41:11 -0800 (PST)
Date:   Mon, 6 Mar 2023 07:41:09 -0500
From:   William Breathitt Gray <william.gray@linaro.org>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     linus.walleij@linaro.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, techsupport@winsystems.com,
        stable@vger.kernel.org,
        Paul Demetrotion <pdemetrotion@winsystems.com>
Subject: Re: [RESEND] gpio: ws16c48: Fix off-by-one error in WS16C48 resource
 region extent
Message-ID: <ZAXfZbywWOo2pg4L@fedora>
References: <20230228081724.94786-1-william.gray@linaro.org>
 <CAMRc=MfD3=ifo9EJf=5_HZKLXnbASi=ehYm=Zs4WQA+YxfffQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zqx7Ofl6bIpHu7bU"
Content-Disposition: inline
In-Reply-To: <CAMRc=MfD3=ifo9EJf=5_HZKLXnbASi=ehYm=Zs4WQA+YxfffQw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zqx7Ofl6bIpHu7bU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 06, 2023 at 10:23:30AM +0100, Bartosz Golaszewski wrote:
> On Thu, Mar 2, 2023 at 11:30=E2=80=AFPM William Breathitt Gray
> <william.gray@linaro.org> wrote:
> >
> > The WinSystems WS16C48 I/O address region spans offsets 0x0 through 0xA,
> > which is a total of 11 bytes. Fix the WS16C48_EXTENT define to the
> > correct value of 11 so that access to necessary device registers is
> > properly requested in the ws16c48_probe() callback by the
> > devm_request_region() function call.
> >
> > Fixes: 2c05a0f29f41 ("gpio: ws16c48: Implement and utilize register str=
uctures")
> > Cc: stable@vger.kernel.org
> > Cc: Paul Demetrotion <pdemetrotion@winsystems.com>
> > Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
> > ---
>=20
> Why did you need to resend this? Anything changed?
>=20
> Bart

No changes in code, just added the stable@ver.kernel.org Cc tag.

William Breathitt Gray

--zqx7Ofl6bIpHu7bU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSNN83d4NIlKPjon7a1SFbKvhIjKwUCZAXfZQAKCRC1SFbKvhIj
K5j3AQCDDi/opSFAVX095eZN7sUZr/Nq6/HOpDiRxrg0Da27EAD+Ir3Vs4hMQ8ik
dvGD/xKnfiuEDHex5yeQzjHChNUO6Qo=
=d1q2
-----END PGP SIGNATURE-----

--zqx7Ofl6bIpHu7bU--
