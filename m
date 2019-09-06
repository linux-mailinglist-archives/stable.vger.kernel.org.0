Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11C71AC2A2
	for <lists+stable@lfdr.de>; Sat,  7 Sep 2019 00:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392542AbfIFWkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 18:40:15 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36465 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728997AbfIFWkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Sep 2019 18:40:14 -0400
Received: by mail-pf1-f194.google.com with SMTP id y22so5526448pfr.3;
        Fri, 06 Sep 2019 15:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MsAQeZ5AYD+kZhfXC2gyG2pV1eCsEpoHL7tP+VvH2Tc=;
        b=hjkDrjTb2hf+jyXpZaZWnf85yEpBPvZ4VuTCVrHB+rrO4f9sdj3cR9jZnpjMOhF118
         9DAuUNMQ3rAhLfOAHFW4NXC5o07VIvLSBOclGzlsoS8mM7QmJhZ6MwbH86mG/3a2Fuwe
         hfGJVXOE3zZ31rca7gfqUZCIum2sg1hoCT46ypVX+lJBN1F1ekImakM9CHjdFeQsr8vs
         TSQ+D+340ImkmxS88KmsbLQl+HcnVJd17P4Pvb/X+INlhfAlfPKSgqFnaiM0GlUviyAF
         sJl2T+41CXA7UXbMQTNiEDxbca7uRwuNnG4qeRRwV4GXWQYkqYiTOvbzjUSx636UdQna
         GTOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MsAQeZ5AYD+kZhfXC2gyG2pV1eCsEpoHL7tP+VvH2Tc=;
        b=dOXZ9BtQpsx3TBTlPR0qH9TOgbVdJgtBemoFivGiYLg7G6POMIs8hga0VKTnPcFLVG
         ybPGaFSUkgWmwLkTrLO9XNvuWNhq/PYkA7XD8G1ac5xP5RjBUk8c1Un3ALdBjC0PC4g/
         lFKM+SiHm7e/u+umuVAFGT/bBKQ8FQTEuhHYTmDakU8thZAV/ZolRFZN5lDhllYT+Ad+
         Nbpj0n0FIcQ2k3UJldEjH8pmu7rsjseamSrwSaHA4OEg69FFerO4W0Mu6f2WeIqIm7Hl
         6j5yx2WyZZKczyZ3y+ldva58Q796+IpuGqAFnop7jH7Kca11syVQRm5hi6tapL8TfRGb
         nbxw==
X-Gm-Message-State: APjAAAUX0dxR+K7dWH99PfKOlrYYYkmHEP/ZZlvy9/eBsgDzy1TVl0V0
        q0b5RyacpcmnZE2RMdMJwSw=
X-Google-Smtp-Source: APXvYqyQGP1ApD5xPHT/cIwKDEn18HTgHnThb4//YCMQYVfOhAIrFFpjlzTo2bY96DP3TkHif9TE2g==
X-Received: by 2002:aa7:8ad7:: with SMTP id b23mr11110390pfd.99.1567809614021;
        Fri, 06 Sep 2019 15:40:14 -0700 (PDT)
Received: from Gentoo ([103.231.91.70])
        by smtp.gmail.com with ESMTPSA id 185sm7714089pfd.125.2019.09.06.15.40.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 15:40:12 -0700 (PDT)
Date:   Sat, 7 Sep 2019 04:08:32 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.2.13
Message-ID: <20190906223828.GA31917@Gentoo>
References: <20190906134925.GA7628@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <20190906134925.GA7628@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 15:49 Fri 06 Sep 2019, Greg KH wrote:
>I'm announcing the release of the 5.2.13 kernel.
>
>Only users of the elantech driver need to update to fix a regression in
>a previous release.
>
>The updated 5.2.y git tree can be found at:
>	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.2.y
>and can be browsed at the normal kernel.org git web browser:
>	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
>
>thanks,
>
>greg k-h
>
>------------
>
> Makefile                       |    2 -
> drivers/input/mouse/elantech.c |   54 ++++++++++++++++++++++-------------------
> 2 files changed, 30 insertions(+), 26 deletions(-)
>
>Benjamin Tissoires (1):
>      Revert "Input: elantech - enable SMBus on new (2018+) systems"
>
>Greg Kroah-Hartman (1):
>      Linux 5.2.13
>

Thanks, a bunch Greg! :)

Thanks,
Bhaskar

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl1y3+AACgkQsjqdtxFL
KRUEbwf/Zsb6jxrbvQRwWtlsQHWn63vGKRRoYxfAh9fmbVBKpjj9pE0DmVrXcpER
x9bBdlewEo9YyczeZPEfkperL8Foec6D02QShYkwPz9oJIo61kQQuFFdTUf5qOVZ
Djki8GsiGsd4Qi/nJUryaCDHFudOZ2tXXW1iDFYC7maAZ2Un1iA1+4g7KEniqY1l
nyK5TfAhvgnaP4eN6eOR1xqFUu5go+fn9Vb1eBHRfhjdHbhsQz85wMcmlRRFMEko
P1cWFxwDOaHFYLGaiteOunTXiDbCjLcTtKhCIqIBveHJ48TR29uPmus6UJ9IfkUh
p9m44Iwqa+nb13s969sDhbcyobTLqw==
=DJv5
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
