Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D2FA03DD
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 15:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfH1N6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 09:58:07 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:40448 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbfH1N6G (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 09:58:06 -0400
Received: by mail-pf1-f175.google.com with SMTP id w16so1788689pfn.7;
        Wed, 28 Aug 2019 06:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=l000k2htpnRvRkCB+Wmu6cmx2Z5HU+VewOeFpWYlWGA=;
        b=ZMiIyKORcwyRCkC5rskiys0McHKqTG6xXs5uYLEbUDcCyb5Bz7U4KKNUwAL6GOweM9
         eSHEYDEhv7pZfxXSjdxLsL36zJOPM2AymiXilqkIsWBkcbw1du5j/rhKFGyWQkJhYU3i
         EiTW2/ja8zlr6D8LZVY0Brai/UhjujxLHv1g1FntCzVK74bjMztly9eoj1le96LE+vzx
         sra6Mv/HPiMD+0c9i/2NoTl4kQCF0Hd2NPuy5X4J+YYwz5IO44ExdIxUUjITRCNYzmOz
         41jGQmRaaRHyZt+Q8W8fSHqY1UEDY9Ddu7nHxwrn/23q1fvj+mKOJ5eQI6hSx19gZ735
         En5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=l000k2htpnRvRkCB+Wmu6cmx2Z5HU+VewOeFpWYlWGA=;
        b=hSjcGEPJeIhrbBgwBBNDklmZ9ysiFjleCSXJ1T7ZJYYQYe34yhKXagnauKLGVbMpgM
         G3xk4NlzwjTwSOCaOXUUmGlSzCLpLTHe4+BI+A5NksXQF+eGxsrwtqlZ8ExuIqEqOtTN
         S3EBlm3VE2NwplNgkHsqbNlvZ/VHuprmWaIJ+miSThfp5dF7uI/Gq0mV0A315YhuGi3o
         qvtxv6Xoo1NnOgtFagndcLP65pcuHHsBox9pBa0R5dNXLlpHz4XDKz5ckC7Rp69MgR4V
         mrqbrzG9NVhu7JZIVmsfN4fHSZcKWkwYLdpa16Ij7yFxr4pMRH3tsIGMU1pf0i7dmorO
         No5Q==
X-Gm-Message-State: APjAAAVvX96hvEPGOcUJ1av4Qsd5BT9cZqyf6DjUvj2YTR6LnY+71kG5
        FRlwdu4VqABT/iPCwbcbkNWgynw/
X-Google-Smtp-Source: APXvYqxS9p+J/DoFSHmH4vAstAnmsgeKT+r0UC+FdPrYN4o/q8gCAcnIKyY4jboh3PuRvFPYSyiGyg==
X-Received: by 2002:a17:90a:a46:: with SMTP id o64mr4389679pjo.90.1567000685593;
        Wed, 28 Aug 2019 06:58:05 -0700 (PDT)
Received: from Gentoo ([103.231.91.67])
        by smtp.gmail.com with ESMTPSA id e19sm2943723pfh.114.2019.08.28.06.58.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 06:58:04 -0700 (PDT)
Date:   Wed, 28 Aug 2019 19:27:53 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     StableKernel <stable@vger.kernel.org>
Cc:     LinuxKernel <linux-kernel@vger.kernel.org>
Subject: Latest kernel version no NOT reflecting on kernel.org
Message-ID: <20190828135750.GA5841@Gentoo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Am I the only one, who is not seeing it getting reflected on
kernel.org???

Well, I have tried it 2 different browsers.....cleared caches several
times(heck) .....3 different devices .....and importantly 3 different
networks.

Wondering!=20

Thanks,
Bhaskar

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl1miEMACgkQsjqdtxFL
KRWu0ggArttx+uKUPpICaT94nUAUQAgW1BZ8wFRqJWZTXg+108YXj+fbxEsw935h
CvFe3T75EMTeLEOoH1G0LbLZcUsIybWrBKM9Cd65KjDs0OPdkdlDHjcmQMRR1fAF
dETtrs0jm3iJvFFGJjef+cC//gvk/x8GmbTV+JiMQga1ei6s0Q9UOKeVjXLxY6Qw
tDL9lBcu8YeWkQeiyq60AOh7tX5wPJoTROwsi9rpReZSQVtxiK+nmJX5Pa/dotng
0rdAs7cKL2T2whzUBw68/y1dkIRwLSZV9lhkYe9YYb+aESC/KDUVW9eeYP+5/klK
A24CoquvyZAVS91PkYQNYpwBY7GhqA==
=BzVG
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
