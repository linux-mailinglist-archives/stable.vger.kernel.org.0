Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F272E10FF86
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 15:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfLCOCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 09:02:16 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43130 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfLCOCP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 09:02:15 -0500
Received: by mail-lj1-f193.google.com with SMTP id a13so3907629ljm.10;
        Tue, 03 Dec 2019 06:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=cHiS/FbZQzsCpieuLGlFhhSrCK9YldyDVPMTDtcb+yg=;
        b=UQeJE4kPw237MqS3oerNUE3PVx5HxaDZNwBwn9lFAnqr6bAyRppV012PCLrCdsxU+K
         I/zApjecFz7+oKveHmuf5EVUaFm3DPn0+L2c25Ec7cmW99lhpbH8SSFaon7AlrrtbIV7
         Eu53zrwFrM6y+qiUAXyTcvF4oQ86uc1vyTGvxTOWnLT45Tk5EIbt5H26NnPYJhAULKen
         VC20rDzR8JnFDV87totLulxdCS4DdsiiVpVuD4LYmrXm4ayi8NDu+awmhEoORFGfiBFl
         uCYFLODuwRXrW/xqxEo1vZH/uHvhQR+XuYP55hwNC53LyTLyJQjnlpKfsBeTe7ylRvjY
         cNTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=cHiS/FbZQzsCpieuLGlFhhSrCK9YldyDVPMTDtcb+yg=;
        b=EhO8O7eGWb/ka2YJugNWOYaDlDsoZy0KRHQqNl8Pd5GmDyZi4/iSeo+j+DIr/DYPgJ
         1R1KG205VANE0HX0PeE55UORP8+7S8XLB9z5GEJOI4/KvjRXo9/9Dus5AgaN5VilE3DN
         9d/BsOaT8Y0LzMw9b+8pJMJhXPPq0C/+uif63XdGxCVbDbuylyacIVRngjAC6lEtX99W
         DHEkPVEGxkzdhA2m2Oj2X2E2Xo4PujM96Ov+xskIGV5sW1HNMhRHBEB/tNunoOs2Rru8
         N+W9UUNd0c1i+L1J9BXl+1GIdPVYTtDWIo+JnRLIk+8MBnoMvIcorDIFYDKJgKiydZU5
         8uQw==
X-Gm-Message-State: APjAAAVYQ6ZssT7/TXsbJeweNC69cq9iU4HQFfegVORRbmcgDm6gl5wV
        i9YopoI6n6iA1/zmXU3KoH+QQ1HZYjsBmQ==
X-Google-Smtp-Source: APXvYqyzleHJ2r7HNpeW6zP7VzDwIWCEDSzid3iowpZE5e3d2tLhnYoe1XGzSsuaSxRKgYMdFmyR4A==
X-Received: by 2002:a2e:894b:: with SMTP id b11mr2706564ljk.118.1575381733386;
        Tue, 03 Dec 2019 06:02:13 -0800 (PST)
Received: from saruman (88-113-215-33.elisa-laajakaista.fi. [88.113.215.33])
        by smtp.gmail.com with ESMTPSA id a11sm1459569lfg.17.2019.12.03.06.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 06:02:12 -0800 (PST)
From:   Felipe Balbi <balbi@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: dwc3: gadget: Check for NULL descriptor
In-Reply-To: <bbb1564aa649a6b5b97160ec3ef9fefdd8c85aea.1574891043.git.thinhn@synopsys.com>
References: <bbb1564aa649a6b5b97160ec3ef9fefdd8c85aea.1574891043.git.thinhn@synopsys.com>
Date:   Tue, 03 Dec 2019 16:03:06 +0200
Message-ID: <87sgm18q1x.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Thinh Nguyen <Thinh.Nguyen@synopsys.com> writes:

> The function driver may try to enable an unconfigured endpoint. This
> check make sure that we do not attempt to access a NULL descriptor and
> crash.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
> ---
>  drivers/usb/dwc3/gadget.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 7f97856e6b20..00f8f079bbf2 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -619,6 +619,9 @@ static int __dwc3_gadget_ep_enable(struct dwc3_ep *de=
p, unsigned int action)
>  	u32			reg;
>  	int			ret;
>=20=20
> +	if (!desc)
> +		return -EINVAL;

I would rather have a dev_WARN() (and return -EINVAL) added to
usb_ep_enable() so we catch those doing this. That way we don't have to
patch every UDC.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl3maxoACgkQzL64meEa
mQZhbhAArVjF7LTle+O9TBRhqPkPIoRSDRw4YvAf+wzRur5vChjcJHZwgkSwyxMY
Gex4TtcP4MvqkyiGy4QyiW0N/UasdgvPFooiaUWCxKp+wxBS03oyw1wkik13D3vZ
KStY+uXEEyF3/sXNjiDM1mdcPBzExqIRN95H6pnEMB3RMqiJMi5fBIaPu0W3BhI9
60hUe62H39B8cG5wYeBOW/ZC8o5Sf9OZEj2bUd7o4An/ginhQkDeRfyRfh/Ifw6x
jzZCMJdQsKoywKkXFH8q+QpmKZMRuVUM6fILnMYnPmSoq/+prbN5mp9rHxAv4j2d
e4xeYSeixcCFdRoN3IXpRaCh7/JctEgVbwU3rTcqD29lyHK72owyc7A5hmaTvfog
KsFNr+4XI8tZkVmjmCbM4KtFf5a2CoI0XEfhY57aqQUzQUBkSRf0d4ATpNgU7/bc
BundayicA8XVv3GH6OTGZPoxFte4yWQGzr2U5S6KJVyB5MNQlTfgpzAsSCqy1WfL
mJqVet2LN86FR01XnEBgcuS4E8qkPN6mXFEsSyOPWQedXgd+VUFEFkCIYd9BUs3z
qBxiXJ5eWbEihnX7LzPXUr+iq15pctUtYSmsojrK2skgHlvPipHu4m/oHe2UlwNF
812mX6/9BEZdwIqov+ZePdRkDPbfidKaH4CoEO4lI2bXfGAUiyY=
=jcr6
-----END PGP SIGNATURE-----
--=-=-=--
