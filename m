Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC2371358D2
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 13:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730111AbgAIMFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 07:05:54 -0500
Received: from mail-pg1-f182.google.com ([209.85.215.182]:35305 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728653AbgAIMFy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jan 2020 07:05:54 -0500
Received: by mail-pg1-f182.google.com with SMTP id l24so3146933pgk.2;
        Thu, 09 Jan 2020 04:05:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0ip4b34cghB4s4OCkst8mSaebMmcHXne3KKW6x6vu18=;
        b=KEtmxSsD9o+89Fy7PeYCQq4ROxzgpj05btDIBfRcem/LFlNGOEFHJH+6veE+WFvOK9
         nHv9bKRGTamg91cfuF8JtYcNHCQi0Jlf/lLV/wcps460Km2BaqPQSN15JAyaVoWFZbCj
         PUzBDGXiKa34Y3y4oQltujdc8hWRDncQN5wpFqirty4v28Y2Q6uhlO1r4SagHraWKKlL
         GuEVWSlPJzvowV+Gp40bHi50lTKxnqlelnzuYiKoh3SyBBLazM13/htfXCjgd9WzL0Pl
         bV69Cbj9pv8KyONtg4WpqQsZcl8HWpwED0xVfDax7x9oKn9Gew9T6qSD4blBVPCgEONZ
         1nvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=0ip4b34cghB4s4OCkst8mSaebMmcHXne3KKW6x6vu18=;
        b=LjUKRtdnQnMZnBbr69MmCHOQ2VErZ6h5YQsz1oFMapdZhwoFDbTLVwEepvtpPOBvfO
         wE3k+RQ9IBdV6WfV/rhLSJyDSILlteOCisCCTt9Qb31z+d7Q4kCg3vdHD4vijOGQrxHh
         x8uNkZv6djOflJyuBwhU4jD4PD3NmH9tBayXUZXrjB2U1xHDC/keaU660JKzkT3JIvnv
         CMtOk7rIMXO+DEMTlxdtW0p4/+F4BLkkYbq50GUDzIN5i0di8dpRbE/woUgLe3DCjHgV
         sIA96gHijkLgGWOIZp4xzHqSiTsGfUm7Pi4iNlIMlo4/jZAlJ8GuWGBNJhgC6038bquq
         BoKw==
X-Gm-Message-State: APjAAAU0/Bj3kdEMwmsuvimzakj2BQkHkrH4Dzrw0PdUskJ9T/5VarsG
        2PCl24bwALJgySEq6ePhX8HwY2IZ
X-Google-Smtp-Source: APXvYqx3DbQmHr1G07zCe4C2a7sHNW4r1ALAHpM+Qt6qaZIbcFQtiEF3EGE4M+AylUcOVHoPzHk+Tg==
X-Received: by 2002:aa7:8096:: with SMTP id v22mr10766726pff.240.1578571553764;
        Thu, 09 Jan 2020 04:05:53 -0800 (PST)
Received: from Gentoo ([103.231.90.173])
        by smtp.gmail.com with ESMTPSA id o19sm4205222pjr.2.2020.01.09.04.05.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Jan 2020 04:05:52 -0800 (PST)
Date:   Thu, 9 Jan 2020 17:35:40 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Christian Hesse <list@eworm.de>
Cc:     StableKernel <stable@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: What happend to 5.4.9??? Kernel.org showing 5.4.10!!
Message-ID: <20200109120537.GD19235@Gentoo>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Christian Hesse <list@eworm.de>,
        StableKernel <stable@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
References: <20200109114330.GC19235@Gentoo>
 <20200109125711.26b31965@leda>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NtwzykIc2mflq5ck"
Content-Disposition: inline
In-Reply-To: <20200109125711.26b31965@leda>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--NtwzykIc2mflq5ck
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12:57 Thu 09 Jan 2020, Christian Hesse wrote:
>Bhaskar Chowdhury <unixbhaskar@gmail.com> on Thu, 2020/01/09 17:13:
>> I am wondering, it might be lack of morning coffee for Greg  :)=20
>
>Just see what's in git:
>
>https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=3D=
linux-5.4.y
>
>Version 5.4.9 suffered a crash on powerpc. Not sure if coffee could have
>prevented. :-p
>--=20
>main(a){char*c=3D/*    Schoene Gruesse                         */"B?IJj;ME=
H"
>"CX:;",b;for(a/*    Best regards             my address:    */=3D0;b=3Dc[a=
++];)
>putchar(b-1/(/*    Chris            cc -ox -xc - && ./x    */b/42*2-3)*42)=
;}
=20
 :) ...thanks.

>-----BEGIN PGP SIGNATURE-----
>
>iQEzBAEBCAAdFiEEXHmveYAHrRp+prOviUUh18yA9HYFAl4XFRcACgkQiUUh18yA
>9HaOzgf/UQ3ItscDbzDqpZ9TTHCJafCB+Qox6x8emjr5LO0GZV5Nv4z1qpTPh8U9
>UkVr47YrP70SX6YlQT1Mnua8zuK9zkIyNnGVkC//4b8DDnPHexURSfk8rj1iijah
>G3SCUi//Ar58Fs4nERF6VNfise0bOAehW9ZH6t1YGqUmjQDImDCy8+NSD82Kyb5U
>Wdc+eYCaORMIBwnac3sn0grpP1F2XPb2T4DypTpn6m9VnJP6rfHT0TmbDjKEIyAg
>9vbJG7hosEEGgi/7/wuMxwZ6dOPt9IZv3I2bbpPKmI00LRgy8Vfshke9bWhNRRam
>fgZPOfVkxTSveDVlrx2Oj0wuRZL6ww=3D=3D
>=3DMn31
>-----END PGP SIGNATURE-----

--NtwzykIc2mflq5ck
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl4XFw4ACgkQsjqdtxFL
KRX1jQf+LKJbjvWPN4EeAYFNjCxsluvBVashu4m5CphL2Zt0lqGtchQATtwGpr7K
VC/HGHecPjUeYYwf2zEU6cWmVylZDTiuSIVJl4j/qJquev7SdETyemzpFi9mDGct
XTFpupxC2ZFaN43XMGfqVONKV4290IAu2VDpHA97ZqjmrYPHbl0JUaPOsYqrbJzj
+1SMNg8fOxxqTrjYljucAcEUx8WQxCjAwhhRykiH3XvmuvyvrkKdFVmM5pIZZf4r
Ztgkyz2WpCam/gD4gEl4dKXGGdcaQCvM2VapURUkZaLUJiZKxRKFO7q5ABRZuqAw
yHV+ak42DS8LpsvROXV3LIRLm4+jWA==
=daat
-----END PGP SIGNATURE-----

--NtwzykIc2mflq5ck--
