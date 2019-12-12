Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF8D011C60C
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 07:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbfLLGmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 01:42:50 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:42808 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727891AbfLLGmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 01:42:49 -0500
Received: by mail-lf1-f66.google.com with SMTP id y19so785186lfl.9;
        Wed, 11 Dec 2019 22:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=uQ206WOQq64Fdf3LJ8rukM4KOcp8+6OnnCYj0s71WsU=;
        b=JMnJUdtfnC6gW0b+T1SUYjlfCALRrRtoR+NsJZfX3fYKusP7YC4gok4V0ZNtPSrdOQ
         s+M1VVTlT8DoTQlPUDcQ9VhPBNFvP7zvd6Nt9s5XdteWQx6W2gUIZ3J2mAEyQ1yjdIBj
         HG2u/BAoslZvYnZte1prNSkLDTDLYwvTbHbO9PNC5zuAP67CS22bxry3TSBkO0rPxH2M
         iHIC7mQg/VhLWLzoF2VnOzOca9y5OMrQsrbuEIpnsRXn43yhcjlHcC0GHSlWKHuCSGbx
         /9qk6UbzV4B1+BDUzvMcygU3mtDmczunI+2MfJruEvpo0LBwfZteTcs9fsmx/Uhc+Ol+
         gHOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=uQ206WOQq64Fdf3LJ8rukM4KOcp8+6OnnCYj0s71WsU=;
        b=GsNKQHQSxQren9hXaV0wJfv+78OI1rmdKTN3DqzlJqFOHwNM7HOIJgtXAwD5tponj7
         q9884TuyIXbLFEvGJ56mKAHnc4+B3XpVgMy3kpcXhE0miZYfRvpRO9rpHXYlJg2kCl4N
         /XVklMr+g7nTO18VkYnVLPxqHg84i0mco7onAFEqK+mr/jVCUE1PkGacu+IWO/Jdxva4
         rpRrduKKnVIpHedGX/Sptm8pjfc1ze59qKZfRjN+WdQXibgQ1wqMu9s545IPGK2xGjpg
         MyoOQz/oT7MpiudgpcwCDnaPIqHwqAcU4yB2NiwYcf+TG060QELgacSELryvYqTqcI1t
         ibkg==
X-Gm-Message-State: APjAAAXll17p8/UfEVLk5oOn3DgqN0D+zCVdzIr1sewQIwMXEpFekmR2
        zUu18j6ABdKovlqoClpkwxZiX0WmVKQ=
X-Google-Smtp-Source: APXvYqwQ8SqfYhra65s+2dls8XstCuSXhs/PzPceZmxHxNbA9nBD0N9fE55fyGvj9uyOOGTT+O6IWA==
X-Received: by 2002:ac2:5468:: with SMTP id e8mr4611282lfn.113.1576132967394;
        Wed, 11 Dec 2019 22:42:47 -0800 (PST)
Received: from saruman (88-113-215-33.elisa-laajakaista.fi. [88.113.215.33])
        by smtp.gmail.com with ESMTPSA id v26sm2390759lfq.73.2019.12.11.22.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 22:42:46 -0800 (PST)
From:   Felipe Balbi <balbi@kernel.org>
To:     Peter Chen <peter.chen@nxp.com>
Cc:     linux-usb@vger.kernel.org, linux-imx@nxp.com,
        Peter Chen <peter.chen@nxp.com>, Jun Li <jun.li@nxp.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/1] usb: gadget: f_fs: set req->num_sgs as 0 for sync io mode
In-Reply-To: <1576123160-28931-1-git-send-email-peter.chen@nxp.com>
References: <1576123160-28931-1-git-send-email-peter.chen@nxp.com>
Date:   Thu, 12 Dec 2019 08:43:31 +0200
Message-ID: <878snixcvg.fsf@kernel.org>
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

Peter Chen <peter.chen@nxp.com> writes:
> The UDC core uses req->num_sgs to judge if scatter buffer list is used.
> Eg: usb_gadget_map_request_by_dev. For f_fs sync io mode, the request
> is re-used for each request, so if the 1st request->length > PAGE_SIZE,
> and the 2nd request->length is < PAGE_SIZE, the f_fs uses the 1st
> req->num_sgs for the 2nd request, it causes the UDC core get the wrong
> req->num_sgs value (The 2nd request doesn't use sg).
>
> We set req->num_sgs as 0 for each request at non-sg transfer case to
> fix it.

The patch, however, is *removing* initialization to 0...

> Cc: Jun Li <jun.li@nxp.com>
> Cc: stable <stable@vger.kernel.org>
> Fixes: 772a7a724f69 ("usb: gadget: f_fs: Allow scatter-gather buffers")
> Signed-off-by: Peter Chen <peter.chen@nxp.com>
> ---
>  drivers/usb/gadget/function/f_fs.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/func=
tion/f_fs.c
> index eedd926cc578..b5a1bfc2fc7e 100644
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c
> @@ -1106,7 +1106,6 @@ static ssize_t ffs_epfile_io(struct file *file, str=
uct ffs_io_data *io_data)
>  			req->num_sgs =3D io_data->sgt.nents;
>  		} else {
>  			req->buf =3D data;
> -			req->num_sgs =3D 0;

... this doesn't seem to match your commit log. Care to explain?

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl3x4ZMACgkQzL64meEa
mQaKsBAAutlQjaGU3lf/c5YVRk40GA55jQgyRQK1eGLZwYQyT306gT8xzNeCQvWw
wrwZJ5BnbRDjKiPDwMZhODyrOUfOteu+VU1bML4ZIPq5znVUa51wZjZP7OyeAuL6
ryDxMLwB94BqikcJylb4mCN3ig+g3h+EC74gB0kknLgZHn806QOHaZl24iGp2a0E
NMvlU1Z5yOslV/IZcsgJB3BqaD5wleZObhkCmNAJRJmQtLVaV3oR6U+4FQ7ps/nc
YMLrYUDY/wDzh2eOdA/bWyk2sESOO8OLagoceU+D2vpjwFxuYQQb6sq3V07A8VrR
oKTSO14csDVMfTlP+PAwLgDzjN2pb1gIpwNM7w52IlCdHY2BRe+ykEEREyPr/8Hv
z1toNv9awHX55sduwXpnLCE31BSkzxD9eEnEkMVAAa1Lu6lpFMBk0pyPHM8SyJRX
1Q3bO9HjAL3JzvwE97yS201nanXb8ZnUMaMjEFkOrSMSQXK0BfZT+OAyz1qiWHg0
gXAmpFiWljjdT3bJYSB0NbRLpBltcheQWz90/3ZyEPuecXtOmiLShDahr0M7/jgy
5/m/QZg8BHn2zhaT6V5bZWu6fvUrZGgc/U4q2NOhLGCOVX/oOXMhAF9WcgeCmmXr
jfR5NHlqZFOyveU6r4pTOMORSrIbRTuwUezFGr7EmzoOHDAV8dA=
=J9Kl
-----END PGP SIGNATURE-----
--=-=-=--
