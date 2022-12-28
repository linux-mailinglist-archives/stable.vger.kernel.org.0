Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0C265786C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbiL1Oua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233118AbiL1OuU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:50:20 -0500
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E125011A20;
        Wed, 28 Dec 2022 06:50:17 -0800 (PST)
Received: (Authenticated sender: didi.debian@cknow.org)
        by mail.gandi.net (Postfix) with ESMTPSA id E288C240007;
        Wed, 28 Dec 2022 14:50:13 +0000 (UTC)
From:   Diederik de Haas <didi.debian@cknow.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        LABBE Corentin <clabbe@baylibre.com>
Subject: Re: crypto-rockchip patches queued for 6.1
Date:   Wed, 28 Dec 2022 15:50:04 +0100
Message-ID: <3207903.aeNJFYEL58@bagend>
Organization: Connecting Knowledge
In-Reply-To: <Y6w/O6zY3Jfe8ZKv@kroah.com>
References: <2236134.UumAgOJHRH@prancing-pony> <2589096.039tgBz4BG@prancing-pony> <Y6w/O6zY3Jfe8ZKv@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3214052.44csPzL39Z"; micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--nextPart3214052.44csPzL39Z
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Diederik de Haas <didi.debian@cknow.org>
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: crypto-rockchip patches queued for 6.1
Date: Wed, 28 Dec 2022 15:50:04 +0100
Message-ID: <3207903.aeNJFYEL58@bagend>
Organization: Connecting Knowledge
In-Reply-To: <Y6w/O6zY3Jfe8ZKv@kroah.com>
MIME-Version: 1.0

On Wednesday, 28 December 2022 14:06:03 CET Greg KH wrote:
> > These commands will show them too:
> > git log --oneline -25 d1b5749687618d969c0be6428174a18a7e94ebd2 --reverse
> > git log --oneline -1 b136468a0024ea90c1259767c732eed12ce6edba
> > git log --oneline -2 8c701fa6e38c43dba75282e4d919298a5cfc5b05 --reverse
> > git log --oneline -5 9dcd71c863a6f6476378d076d3e9189c854d49fd --reverse
> > 
> That's a lot, I'll look at them in a week or so after catching up with
> the rest of the stable queue.

Ok.

> Any reason why you all didn't properly mark these for the stable tree
> beforehand?

Insofar as this was (also) directed at me: I don't know how this works (yet).

I'm an interested 'bystander' who is interested in kernel 6.1 as that'll likely
be Debian Bookworm's kernel and rockchip/Pine64 devices.

As such I regularly look at the (6.1) queue and found those rockchip crypto
patches. I also tested this whole patch set to see whether it does what it
claimed; which it does.

> > And this is the hotfix, planned for 6.2 (unwrapped):
> > https://git.kernel.org/pub/scm/linux/kernel/git/mmind/linux-rockchip.git/c
> > ommit?id=53e8e1e6e9c1653095211a8edf17912f2374bb03
> fix for what?  

Rob Herring noted a mismatch between the dt-bindings of the "reset-names" 
property and the implementation in rk3399.dtsi in commit 8c701fa6e38c here:
https://lore.kernel.org/all/CAL_JsqJkHR+iccEf=5SU40Qq+cQpGZRq26TLzec-_Nr-Buu2KQ@mail.gmail.com/
("lave" -> "slave" and "crypto" -> "crypto-rst")

I may have used the word 'hotfix' incorrectly.

> When will it be sent to Linus?

I don't know, but I've seen several "Merge tag 'vX.Y-rockchip-dtsfixes' ..."
commits by Arnd Bergmann around rc6 or rc7 in the past.
--nextPart3214052.44csPzL39Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCY6xXnAAKCRDXblvOeH7b
bvumAQCVSW0pjA28k2oEaGYaBbcqflVBNzr3K++A4sFmyVp9CgEAv2MAg80l3HSv
aF+1E/hRSbniPDnhSvVPD/ew4xnLxg8=
=MwMk
-----END PGP SIGNATURE-----

--nextPart3214052.44csPzL39Z--



