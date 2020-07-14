Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D765D21ECED
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 11:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgGNJdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 05:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725952AbgGNJdB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 05:33:01 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5681C061755;
        Tue, 14 Jul 2020 02:33:00 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id dm19so16325682edb.13;
        Tue, 14 Jul 2020 02:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4hx30PqqoaKCTO0tMV5MXPy9WV4JOGXHT29cx4BAmGo=;
        b=PUZRD7ZoJoGcBKUQ//Po15bwuf7dQgrMkN+LsH1vGn+Wu+CPT+g+1ecewCvcnztIQ2
         Zr4cI4eZ1MrETF11GT/frURS9Hw9hMFiEj2RVZWvs6sjop4lrpEk2ap67NUS7n4q4MpM
         h7PLhp82Z1DnvX9DQTD3RXo88dBx8f2W4Kjtsawk/okiXD48p9YZzZh4vRdRY7aZUE+t
         o+oc98a4PzwjA3FoDxNMWnWOrcgD9r1tvaUb2zAGaNFrfsZ4sISFsSkh6zgDFEDdY7UH
         dIafe65vWNWVDgvxDX5icgA06I7IMkr7Ob2/N82waLw2dR23WPdSpOMrvbWH8pwKsQGr
         5uwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4hx30PqqoaKCTO0tMV5MXPy9WV4JOGXHT29cx4BAmGo=;
        b=iH9KBas7rVwtE5c2ouz1GWQ9+jV8L+q7S89moTnS5nN5a+kAJXDC4N6N8D4qkjxzJe
         PhQmvdJ6RSBnjUtkVGpJHMKTyJNhsonkmz/iv+IiyJTq/giPpiiSEey5iS3pNFFI/DJg
         87zuZSY+8LoA/PpDIJWZ+TJG1QQLhq5VB4cb/njCcyH6hdR1Ffo2lcFzMPQXertlH1fD
         xXc61XWbcdSuDqa3j1k9EAJ9wyU8pH07hW201nY62CigwsiFzl0vlNmDQ7N4ZI5JASz6
         wJ6dSKmz4fF/qvzFgPNkpw40HafOEfwyXzjDwFLjfr8VveNu1dPtD5VcD+xXf10Auyz4
         dmeQ==
X-Gm-Message-State: AOAM5326K1wRGXarjQDrb8+RHiQJYzrz8Il8FEtV837Tm5DHIVtTs5dz
        uWgNJIQV8OBEx1qcZxOKw7E=
X-Google-Smtp-Source: ABdhPJxQMpKEO/TmGr4t3/ZxNmff8nGv0ouAGV0vHWdU8pzoRUZBJ8ps7/OmisdmObnGZ/BxXqvGAw==
X-Received: by 2002:a05:6402:1592:: with SMTP id c18mr3741523edv.258.1594719179492;
        Tue, 14 Jul 2020 02:32:59 -0700 (PDT)
Received: from localhost ([62.96.65.119])
        by smtp.gmail.com with ESMTPSA id t6sm12170365ejc.40.2020.07.14.02.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 02:32:57 -0700 (PDT)
Date:   Tue, 14 Jul 2020 11:32:56 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] usb: tegra: Fix zero length memory allocation
Message-ID: <20200714093256.GG141356@ulmo>
References: <20200712102837.24340-1-jonathanh@nvidia.com>
 <20200712102837.24340-2-jonathanh@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DNUSDXU7R7AVVM8C"
Content-Disposition: inline
In-Reply-To: <20200712102837.24340-2-jonathanh@nvidia.com>
User-Agent: Mutt/1.14.4 (2020-06-18)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--DNUSDXU7R7AVVM8C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 12, 2020 at 11:28:37AM +0100, Jon Hunter wrote:
> After commit cad064f1bd52 ("devres: handle zero size in devm_kmalloc()")
> was added system suspend started failing on Tegra186. The kernel log
> showed that the Tegra XHCI driver was crashing on entry to suspend when
> attemptin the save the USB context. The problem is caused because we
> are trying to allocate a zero length array for the IPFS context on
> Tegra186 and following commit cad064f1bd52 ("devres: handle zero size
> in devm_kmalloc()") this now causes a NULL pointer deference crash
> when we try to access the memory. Fix this by only allocating memory
> for both the IPFS and FPCI contexts when required.
>=20
> Cc: stable@vger.kernel.org
>=20
> Fixes: 5c4e8d3781bc ("usb: host: xhci-tegra: Add support for XUSB context=
 save/restore")
>=20
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> ---
>  drivers/usb/host/xhci-tegra.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)

Actually it would seem to me that this is no longer a bug after your fix
in patch 1. We only ever access tegra->context.ipfs if
tegra->soc->ipfs.num_offsets > 0, so the special ZERO_SIZE_PTR case will
not actually cause an issue anymore.

The reason why this was crashing was because tegra->context.fpci was
allocated with a zero size (because of the bug that you fixed in patch
1) and then that zero-size pointer was dereferenced because the code was
correctly checking for tegra->soc->fpci.num_offsets > 0 in the context
save and restore.

So I don't think there's a bug here. It's not wrong to allocate a zero-
size buffer. It's only a bug to then go and dereference it. Are you
still seeing the issue if you leave out this patch and only apply patch
1?

Thierry

--DNUSDXU7R7AVVM8C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl8Ne8YACgkQ3SOs138+
s6FDDg/8CEz3TwFQZ66rzYhrJ454N+7L/iQDGUFwOVWDItvRGvKT/b6mGVa/CA1g
mAm1dcSUr15ALz9ktJVS1kYlzUQ3XV8gLDtTQz3DPL3IULc75ykyWb6l5P0VMvQH
s0kPu6SLZE/tLhApcoO3jzoq/m0aj0U1oBm4iDRlh9EbCZip8l4Er6Lcd0j4cRdY
skYD09DG3v+WW2TVc97nfaWrf+J4e00a+96K/0tuw3WDFMO9CPuHOkAJ+RLVbVbF
Ct3GDkQcrSeZ2J+ajbwXMPnRED493BJXLBAGfPGCvXh+r3gPCOVWWzFfnaXjs1mt
m558IaWk5LRlxcKgzVY0L+vXDqBNa4oR5t9KszRosbUXqlg3sbJfIcAT4thelP9x
1GHPrRmAlb9/Mw0zNsFaJK+O4WqLPMyms0nDHuY8Tcxhckr+vFuqZCdGW3GNI+ON
fAL+UIr8BHjJ/pBInLe5fwAJImtLpI6o2G7sRlMtOYgnURCZAT/5ZFxlhGH/ShWL
VVVYvf/M1oExnK4Y8kODARu9cgy1bCzvAMPFYT+Gec+TEECd2YWsPJYmFw91LiDO
o3TnsA6g2LZmLzDsFfpp/TB+Bn0GcBz2znyncuZJltshMtVPbI4Ai/HXUIfXUMn7
Ktl/q2KzH5cOrfyVAcn/4cNyOlNt/d9Fq7hU0kJzcooZCLxAgzs=
=qqmM
-----END PGP SIGNATURE-----

--DNUSDXU7R7AVVM8C--
