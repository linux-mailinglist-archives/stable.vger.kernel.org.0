Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B60F4B938E
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388556AbfITO65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:58:57 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46001 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388416AbfITO65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:58:57 -0400
Received: by mail-wr1-f65.google.com with SMTP id r5so7048281wrm.12;
        Fri, 20 Sep 2019 07:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YWSKJigIWyYHoT79ZbcIUltwc9MAequwzDfGlnQbW5U=;
        b=uVhp6vt+uznQ0uQ4BVjgiwDmBVR4W6a/fPzdJTsheAFQRNKsE/4BCDBpdjJ7z+jL7E
         94lJkoNWV2BmHAa2UHw0kAk0UKWZzvKHwfeL84aHU6Ah3RkjEn4hXXzfTRv/w4HCb5v8
         PSnMPBQOtm5ANSeKWvGEZ31bMd/clPHtcCwGQOBuQ11+X75qYtqQDHamiM/3jnqHH5KE
         rf8u+swWQeTJGeJE30jJ+xoLpgfSABdBiz4v9wg3Y2JDMh7r+/Uzmz54ieNa3NZJiA6s
         nVQlfZ/xWXc9OozjIU6KJGx1nqslCpkCKPf0ulcRtMUfeq/RGXiBuRR4n1xYJdzoukf3
         1w7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YWSKJigIWyYHoT79ZbcIUltwc9MAequwzDfGlnQbW5U=;
        b=q1OH3qdWTfnAw3ODShG4LnJqD4661N5iL3qdY+ox0sNvOV94JRugKZKh9eVPiVcOwC
         73euZx7tArTBSFugwa7TVkdbCGrU2kKEPaI0zX18B3LsOyL4pphe8vxSiLezQqzpBK2I
         PGkkO32IJ+5uhx268UBbY9H5tBn4GBkpedqWnkbiaJ15jz3DuY9ynzA0Q96p8hMYOUHn
         TDCF22dSlvjvSxrB28fMco4Z8lGATMabdOKtxpcXcNIv8BUqWPS9O+LsnWYvpngMEL5l
         hnu9ej/zR3O6Tn2+GMe9UrmegASpdlsk5MCjz7TbhZI6tK5NBdGTe3Cd8buViZREhc9r
         v39g==
X-Gm-Message-State: APjAAAW54U//hyEhDR2kI2ErH8opf1iGraAUaUEpnnNm7ylRqsULctjK
        gwoZ7CwxBNOWGXhgmY/q0Ng=
X-Google-Smtp-Source: APXvYqzLyvmfe7qpco90UOMZEgel6sIS3gbWfhbSHxmPnAQ7e84rS2QeY7RN5brumlGiWzjv6fN73Q==
X-Received: by 2002:a5d:6451:: with SMTP id d17mr5255339wrw.260.1568991535483;
        Fri, 20 Sep 2019 07:58:55 -0700 (PDT)
Received: from localhost (p2E5BE2CE.dip0.t-ipconnect.de. [46.91.226.206])
        by smtp.gmail.com with ESMTPSA id b22sm2576487wmj.36.2019.09.20.07.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 07:58:54 -0700 (PDT)
Date:   Fri, 20 Sep 2019 16:58:53 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>
Cc:     dri-devel@lists.freedesktop.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Martin Bugge <marbugge@cisco.com>,
        Thierry Reding <treding@nvidia.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] video/hdmi: Fix AVI bar unpack
Message-ID: <20190920145853.GA10973@ulmo>
References: <20190919132853.30954-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <20190919132853.30954-1-ville.syrjala@linux.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 19, 2019 at 04:28:53PM +0300, Ville Syrjala wrote:
> From: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>=20
> The bar values are little endian, not big endian. The pack
> function did it right but the unpack got it wrong. Fix it.
>=20
> Cc: stable@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: Martin Bugge <marbugge@cisco.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Thierry Reding <treding@nvidia.com>
> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Fixes: 2c676f378edb ("[media] hdmi: added unpack and logging functions fo=
r InfoFrames")
> Signed-off-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> ---
>  drivers/video/hdmi.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Reviewed-by: Thierry Reding <treding@nvidia.com>

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl2E6SkACgkQ3SOs138+
s6HXNA/+KeSBAey7HOIxjXzG1ATuVyYPEjR0QhVdOB5wRLb6n4mq2VmoGOuHWOET
qJ5letIjaBdJvsBNrg/OTlPhUU+KrYSu22z7q6zmfPt6jF5qSWhSyd0X8TQsguGc
Ga+J2EQkTnU7rRVXAMkTc9ZQuF8EpM993lbJLafeLvoEdJDmkABt5V2/TkfuqehU
9FkyH+eLg/ScFkGzV/A0j/F+2nNEbLXsCn2ChxgDGI2NiUMBrz9VWRrrbp9P+RMl
ZHoXFBLEp8CYXe9CzLiTnHpObuE6HEh1Rls1KDB7ol0FDF+JoJEs+jTzV90X83jW
hGffs6RMV3ZndyL/lUEEhTTPqCnrpWH4Z2X0DtuH/HLGgkyPZ8MyRdNrlapi4Ffb
uUYR8yotEMIXpxIm5hHGIu+uBaFNx33BQFd0cB2IecANMHctudR/Tik+0a6oqzPV
B3OqVW4XQ2T4Fa1DlkcBowkynyWW9J4vIeZTxjudK6uQ9D0W2Fz4wZcYJPprdex6
kMDsspZ3vCzQH2iURcnK6joImUcOQOckveO1XaEJ8OCs0zZch18wTBIy4Aog72mY
aE3Nt45YatvxYZhpEq6L7G7i4dW5sMwtNxNraCAk4H6jO4HFmQCCG0D7kWe4KCno
zU2QjNprjt06iyWQR+sjxcuKG0DFdwefaNjqBycCKynOgh6N2Y4=
=6tSc
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
