Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70BE6135847
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 12:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgAILnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 06:43:47 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:32858 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728273AbgAILnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jan 2020 06:43:47 -0500
Received: by mail-pj1-f66.google.com with SMTP id u63so888480pjb.0;
        Thu, 09 Jan 2020 03:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:user-agent;
        bh=k+CxAu0VDmJBfyM0W8hIIm9rZiwUPX2eTvUTzZyDrRQ=;
        b=YAGqtuiXmrVRygS5Xiz/pKNOd7/HCEK0KrnYzrNgj33GyCzaIeZhvy9kRpPOGaGFTt
         hyUh66HLQYGVQoHEbovH+bWGvprqYEjXw4Uy7NTuzoFCfehrVwCJgZkl7+UQYVPM42EJ
         sBSiTRJPrlF6ag5cqC1WoZtdcFDYEUlrwcaOUGC7HPR7mbkzQTpv5UvwKxIVdMyZZWte
         W2LzFFDMYfrlrZPPZCTzApeygirDxQqj/NfGx62uRe/603F3AwrxFTqctNyo4g18/r7d
         PLvs/jgj3AyaDKspPtOzQ0eo2Zqxbdr6bnzNVn2cb84ZItAFlz0h+9ceZMhpe5HM9szb
         ORmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition:user-agent;
        bh=k+CxAu0VDmJBfyM0W8hIIm9rZiwUPX2eTvUTzZyDrRQ=;
        b=kV7iVohF32TDWMmgDLJBdBM6KPEev3LZEiuQH37Jk4nUu6VO+JbptccbHfC45XL/4h
         eioFOWi4YAtotW08KkUxIvlgfp3kXagY3JcwLmOg4EsbS6Peaguef3KgBJ31D0am+IsT
         +n4zWOvcVOoICduR0fJx8DPUetVveejFoSMPZR3FXFt+R8Wxwv/tELdWW9sWRwJ4ZC5r
         7pjVJOnXynfRfSViOCDaN5rmFwzCjGoUUioW3WtOITR/AiXWo5yHJaSU+C/tHglTsYfk
         qRL+JxC3tNJ9H+w18+53DuUzu1yE8QahJZxEAsO5p3uAr53G/fjcS87lgJpdZX7LZykW
         mZGQ==
X-Gm-Message-State: APjAAAV2HQpjf1AXmoT0vFK2gGPJ6jDDY3iQ+7quRE/pyoEVuswhSufv
        ijciSDvwICun4GxOIHSafNhXYhg9
X-Google-Smtp-Source: APXvYqw8hABGGJOgCw9/2qfVSTvUBKdLcQBUxNSlYbHEVNlFpmyDuGK4LuzaCcLJ8qHR5c4IO42l6A==
X-Received: by 2002:a17:90a:7345:: with SMTP id j5mr4541891pjs.69.1578570225935;
        Thu, 09 Jan 2020 03:43:45 -0800 (PST)
Received: from Gentoo ([103.231.90.173])
        by smtp.gmail.com with ESMTPSA id k1sm2915637pjl.21.2020.01.09.03.43.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Jan 2020 03:43:45 -0800 (PST)
Date:   Thu, 9 Jan 2020 17:13:32 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     StableKernel <stable@vger.kernel.org>, linux-kernel@vger.kernel.org
Cc:     Greg KH <gregkh@linuxfoundation.org>
Subject: What happend to 5.4.9??? Kernel.org showing 5.4.10!!
Message-ID: <20200109114330.GC19235@Gentoo>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        StableKernel <stable@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tqI+Z3u+9OQ7kwn0"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tqI+Z3u+9OQ7kwn0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I am wondering, it might be lack of morning coffee for Greg  :)=20

--tqI+Z3u+9OQ7kwn0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl4XEd4ACgkQsjqdtxFL
KRV4AQf/b8ZPX1KUHTRB2kblZjjQl5aEj7TBrxc9cseW7ERXvoEvNKE9ZjxoBQIg
ZdDLba9BquWHoIeJ8hE8A8gJRt19BCUJq/2Qyt333u5v37jZVAAKLX5gWlWR814M
zc2gFItH6BxZ4Kys7Zgya6Vg/awwpmF1GcJiXEu4Og741RasudsZhKaUbYLL5lHi
TS8KwisPScUWZBl6RSQ1siV3tFDYx2z+BTdQO4AFUYVnKIIsKodhbjY05vK5x1NG
n9DcsU5ZC5EtzyTrwdDeRJBjW44G8NdaktBTFKxQu9T5Q1jPjYVIvLURBk+CJ69+
A69CcbYoJsgcIG1qtgnuGBl+jN/z6Q==
=x1ZM
-----END PGP SIGNATURE-----

--tqI+Z3u+9OQ7kwn0--
