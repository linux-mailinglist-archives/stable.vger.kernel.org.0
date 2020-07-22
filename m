Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8076D22971B
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 13:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgGVLFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 07:05:36 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45347 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbgGVLFg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jul 2020 07:05:36 -0400
Received: by mail-lj1-f194.google.com with SMTP id r19so1983098ljn.12;
        Wed, 22 Jul 2020 04:05:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iq6Vo6z/msbmEzHVNxTFhtS1vmtzmjZS4VrDHaSBsI8=;
        b=VGNwks4Q5LLUgY5NSbq/oUgps7plKGtK9PWKdZkMblpP/gopqNIUJgy664G/gUQGs1
         i6+gS1Fgfxk+9jpjUX4s5uqMnpuhfYT0AhS1T73z+HXjHTkJeS9DrT9tSINt8PHEzQJL
         TOAcjb+K8xMCirD1wqrD9UVtbmHO9H4hirWv+WB0VcV2bRXzplD08ykBF0pkeuJ1hZE+
         unrO4zG9gnHlql9lOvB8IvRnMK3b9HOW4LnRKwFvMZSGfhUGdBF2GjakyWI9jzAozoju
         /Efh1JMx1e6ubhoaCSKQ8FtoYGgpNO/NccbUxE9JrnIF3vySURUjZGszJ7cYA4t4Aep6
         u5yA==
X-Gm-Message-State: AOAM5339if3dNF1SX3EZPLgVNhhkycmZwXDU85cMWabtriRXL776vNFG
        HnBuHhecM/9458ap7rA1TYtsqiVs
X-Google-Smtp-Source: ABdhPJwMEu36zrem3wuSdeeZGqlZLf4Zh/Yl/jxyjW70gHv4UmxoNS0fUrbsPqbfZ9OvAbe+MCNDQw==
X-Received: by 2002:a2e:8043:: with SMTP id p3mr15580077ljg.469.1595415934020;
        Wed, 22 Jul 2020 04:05:34 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id m1sm7928782lfa.22.2020.07.22.04.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 04:05:33 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1jyCYy-0004Jt-NZ; Wed, 22 Jul 2020 13:05:28 +0200
Date:   Wed, 22 Jul 2020 13:05:28 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 094/133] USB: serial: iuu_phoenix: fix memory
 corruption
Message-ID: <20200722110528.GK3634@localhost>
References: <20200720152803.732195882@linuxfoundation.org>
 <20200720152808.264804020@linuxfoundation.org>
 <20200721113259.GB17778@duo.ucw.cz>
 <20200721115449.GE3634@localhost>
 <20200722105247.GA19938@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ieNMXl1Fr3cevapt"
Content-Disposition: inline
In-Reply-To: <20200722105247.GA19938@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ieNMXl1Fr3cevapt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2020 at 12:52:47PM +0200, Pavel Machek wrote:

> > > Ok, so... goto and label is unneccessary, memcpy will do the right
> > > thing with count =3D=3D 0.
> >=20
> > That's generally too subtle. Better to clearly mark the error/exception
> > path.
>=20
> We usually avoid subtle code by introducing comments, not by
> introducing extra (and confusing) code that can not be optimized out.

It's not confusing at all. Just drop it.

Johan

--ieNMXl1Fr3cevapt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQQHbPq+cpGvN/peuzMLxc3C7H1lCAUCXxgddQAKCRALxc3C7H1l
CNa3AQC+tA4tIat9SaMvrMWsbczEVWEDPq8NTqDXoQ+Uvy8mFQEAl6BAfr9JiEgC
JsK3h09zUKBjvsUX7scnVWou48p3NQM=
=uEXj
-----END PGP SIGNATURE-----

--ieNMXl1Fr3cevapt--
