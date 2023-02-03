Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1011D68977C
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 12:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbjBCLJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 06:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbjBCLJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 06:09:15 -0500
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651C976407;
        Fri,  3 Feb 2023 03:09:14 -0800 (PST)
Received: (Authenticated sender: didi.debian@cknow.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 7BFF7FF807;
        Fri,  3 Feb 2023 11:09:11 +0000 (UTC)
From:   Diederik de Haas <didi.debian@cknow.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        LABBE Corentin <clabbe@baylibre.com>
Subject: Re: crypto-rockchip patches queued for 6.1
Date:   Fri, 03 Feb 2023 12:09:02 +0100
Message-ID: <2005805.CtlZUxCmk0@prancing-pony>
Organization: Connecting Knowledge
In-Reply-To: <Y9zU3KxsfMFGB/MF@kroah.com>
References: <2236134.UumAgOJHRH@prancing-pony> <Y6w/O6zY3Jfe8ZKv@kroah.com>
 <Y9zU3KxsfMFGB/MF@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart40039366.mi4ZS9bVxY";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--nextPart40039366.mi4ZS9bVxY
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Diederik de Haas <didi.debian@cknow.org>
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: crypto-rockchip patches queued for 6.1
Date: Fri, 03 Feb 2023 12:09:02 +0100
Message-ID: <2005805.CtlZUxCmk0@prancing-pony>
Organization: Connecting Knowledge
In-Reply-To: <Y9zU3KxsfMFGB/MF@kroah.com>
MIME-Version: 1.0

On Friday, 3 February 2023 10:33:16 CET Greg KH wrote:
> > That's a lot, I'll look at them in a week or so after catching up with
> > the rest of the stable queue.
> 
> I looked at this now, and some of the more obvious "fixes" are already
> in the 6.1.y tree (and older kernels).
> 
> So this series does not apply as-is, and it seems like there is a lot of
> extra stuff in this series that is not needed (like a MAINTAINER entry?)
> 
> Can you provide a patch series, that has been tested and with your
> signed-off-by for whatever you feel still needs to be applied to the
> 6.1.y tree to resolve any existing bugs in 6.1.y for this driver (note,
> that does NOT mean that you can add new functionality that was never
> there...)

I don't feel confident (enough) that I could 'pull that off', especially since 
it would effectively be a new patch set, which would likely not get the same 
level of review/testing as the original one got.
It would also (effectively) add new functionality as the crypto engine (at 
least on rk3328 and rk3399) did not work previously as among others they don't 
have the crypto node in the dts files.

So I think it's better that the (new) patch set does not get applied to the 
6.1 Stable release (series).

The reason I raised my initial question was because I did test (and provided 
my Tested-By to) the patch set as a whole, not any single patch in isolation.

Regards,
  Diederik
--nextPart40039366.mi4ZS9bVxY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCY9zrTgAKCRDXblvOeH7b
bncxAP4oJgfnuw/ign9I9D1JxgSRM2pvpEzxccLdivshWEoBCwEA2sqR6qvC3OfZ
IeFdNPY985xqqFc5KULPIbnG5OW6wgI=
=8vE/
-----END PGP SIGNATURE-----

--nextPart40039366.mi4ZS9bVxY--



