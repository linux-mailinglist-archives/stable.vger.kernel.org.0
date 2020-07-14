Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC5521F67B
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 17:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgGNPwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 11:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbgGNPwE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 11:52:04 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F8BC061755;
        Tue, 14 Jul 2020 08:52:04 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id dp18so22539046ejc.8;
        Tue, 14 Jul 2020 08:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8ma385S9XtvllyPFqZZyWkLBqNuOCBNLKQ/FFZ13ZKw=;
        b=pSDC/jbE+Qa0bij2n1SZrZmVpg9S6LwvxnLh8cKVELNbEfqqnBg1g0sb7cWiw45Ili
         9NfqiIVYzTQxp4PwLkPetUL7ssZxBPXftfuwMu3nCJ3pQ+Sc3tbiJ+RFBuW8+D99ApOb
         9qlBKMj1iDEagnxzceho9tnGWc4p/h5HhcHnP9sZqt4/f8zFsNEMCow/vTNuGw39GLoC
         zmPo4f7R8/MdI2StVEceJ9S/oWm6fR4wGdPOmS57gcDkZ3iTNMpN2l5Pns34KMkmflW2
         fkRTZiGPvJ0gYbF75MCd8CH2ZrSGAWZYmSzYFVrV9EgqHw3dW+62+eFVJ7GgN4025KxT
         zTZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8ma385S9XtvllyPFqZZyWkLBqNuOCBNLKQ/FFZ13ZKw=;
        b=iygjFQRx7H8khHHHsMWFlffoqa6YIc0sCA7Y3pMOn+9J4xRtCnynPEP6i+hdbmx+V4
         9+xCexrRp2dORRQ3wAPMozwKM/QNUZ6YkPb0lgXW0D/PqDkijJ2CKaYYiFERt+joIykk
         CVE82P7qXWsTq4NUKG+Xdsj1E+Nll52yPoNUOiDwGOAzley2bGFa0aLHqmYdvUU9APSK
         wuJ4AoXVveqGPfN5YLXiw6F0FdSxXGqip8Jor7KPGa7Cwl2/By4xUe3eEPdIi/ZlW3dD
         VtX6kFInFN17Si8E+0pxU1PsVq00H2Xg+q/XttA4kHQpnWn+8rW3G1LzjTPJ0ATp2RDH
         asDQ==
X-Gm-Message-State: AOAM532Yz9J4SRGZ13yVlSX8ofcIPttLp4AJJ9sMYchcYgJXoXMyty+7
        DXKdBFEE2gwH8ItyiR+SW30=
X-Google-Smtp-Source: ABdhPJwVwWy+mYhcQbMzIwAsrvhXC5qyNxh45YEnq3DASdGc4ydc2Fij/VqDYPXLeulhFsshSe1GpQ==
X-Received: by 2002:a17:906:26c7:: with SMTP id u7mr4988154ejc.13.1594741923259;
        Tue, 14 Jul 2020 08:52:03 -0700 (PDT)
Received: from localhost ([62.96.65.119])
        by smtp.gmail.com with ESMTPSA id cq7sm14958442edb.66.2020.07.14.08.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 08:52:01 -0700 (PDT)
Date:   Tue, 14 Jul 2020 17:52:00 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     Laxman Dewangan <ldewangan@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-serial@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Shardar Shariff Md <smohammed@nvidia.com>,
        Krishna Yarlagadda <kyarlagadda@nvidia.com>
Subject: Re: [PATCH 1/2] serial: tegra: fix CREAD handling for PIO
Message-ID: <20200714155200.GB251696@ulmo>
References: <20200710135947.2737-1-johan@kernel.org>
 <20200710135947.2737-2-johan@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8GpibOaaTibBMecb"
Content-Disposition: inline
In-Reply-To: <20200710135947.2737-2-johan@kernel.org>
User-Agent: Mutt/1.14.4 (2020-06-18)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--8GpibOaaTibBMecb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 10, 2020 at 03:59:46PM +0200, Johan Hovold wrote:
> Commit 33ae787b74fc ("serial: tegra: add support to ignore read") added
> support for dropping input in case CREAD isn't set, but for PIO the
> ignore_status_mask wasn't checked until after the character had been
> put in the receive buffer.
>=20
> Note that the NULL tty-port test is bogus and will be removed by a
> follow-on patch.
>=20
> Fixes: 33ae787b74fc ("serial: tegra: add support to ignore read")
> Cc: stable <stable@vger.kernel.org>     # 5.4
> Cc: Shardar Shariff Md <smohammed@nvidia.com>
> Cc: Krishna Yarlagadda <kyarlagadda@nvidia.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/tty/serial/serial-tegra.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

Looks good to me:

Acked-by: Thierry Reding <treding@nvidia.com>

--8GpibOaaTibBMecb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl8N1KAACgkQ3SOs138+
s6E5wxAAh7iJ8sJY9GOfgRgH+TfVpaOx9vthw1a+YaDJkl8WT7Y7pz9YaEru4OIJ
eBLvyt+pMPkx7Tl495j7EbFwUmZGy7F+4pse9vx686+bAwsc9+SgYRgnQzMvwsY1
UX6Kfaj+pfWcGvYz/Gq5zQEi23ZH6QrIkEZGWm408gXMz+NzRKxABTDJx5+FRdtu
uB2b6BNnrQ/em1dY2NTtFoNbKZpoHRm5aDXiAb/9NO4sgmJHaKB4UpNdtMBe2mHA
uCkPzhytPCl6gzyl+EMLsrkPZQpPRDEcCoeHj/Gv01F5FRXILUUb8dhCIvhQpXZ/
vKiHVCN7o7IfMp+CVRDSwRrcLZ4D1hQl/wDw+k4ZSAhE5InotN6nDrpJIR4kDxII
KWEkyWkrf8buSpdCFCY6XBPtC7FAHn/W28RaD4LDE9fpXFJWawxe0ebtH+M/bRxk
CVbjYU6NxjpdbK0YCKNUzPNQJwBU1HWErGkMU7cnPdc+04t/jVx7023JrYaRzYak
6+2O96GdpQEa97PthXw6xVamIwWjA3383/+inuztYSXduWajpx3A1RA38ihcU04I
stG3Ft3FHvDjEu/iE8i/8k5nvs0S/s+lJYKkdyVaJcvUAwQt2kO24x8WPkV4tdvz
w1AIMxx54zoT9n4CHdVhc3EINKoWirt8QgAfw37VSSa2vboL4yg=
=0eYi
-----END PGP SIGNATURE-----

--8GpibOaaTibBMecb--
