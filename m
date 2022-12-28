Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0881657560
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 11:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbiL1Khd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 05:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbiL1Khc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 05:37:32 -0500
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7269F1142;
        Wed, 28 Dec 2022 02:37:30 -0800 (PST)
Received: (Authenticated sender: didi.debian@cknow.org)
        by mail.gandi.net (Postfix) with ESMTPSA id D2969E0008;
        Wed, 28 Dec 2022 10:37:27 +0000 (UTC)
From:   Diederik de Haas <didi.debian@cknow.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     LABBE Corentin <clabbe@baylibre.com>
Subject: crypto-rockchip patches queued for 6.1
Date:   Wed, 28 Dec 2022 11:37:16 +0100
Message-ID: <2236134.UumAgOJHRH@prancing-pony>
Organization: Connecting Knowledge
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4633592.hJsWa3VWUR"; micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--nextPart4633592.hJsWa3VWUR
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Diederik de Haas <didi.debian@cknow.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: LABBE Corentin <clabbe@baylibre.com>
Subject: crypto-rockchip patches queued for 6.1
Date: Wed, 28 Dec 2022 11:37:16 +0100
Message-ID: <2236134.UumAgOJHRH@prancing-pony>
Organization: Connecting Knowledge
MIME-Version: 1.0

Hi,

I couldn't find an existing mail with "[PATCH AUTOSEL 6.1 N/M] XYZ" to reply 
to, so I'm just sending an email like this. Hope that's ok.

In https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/
tree/queue-6.1 there are a number of patches which start with:
crypto-rockchip- like crypto-rockchip-add-fallback-for-ahash.patch

I guess they were (auto) selected as they contain a "Fixes: <commitid>" line. 
Those 7 patches are actually part of a larger patch set, see here:
https://lore.kernel.org/all/20220927075511.3147847-1-clabbe@baylibre.com/

All those patches have been merged into Linus' tree for 6.2 and there's a 
hotfix planned to be submitted for 6.2 here:
https://git.kernel.org/pub/scm/linux/kernel/git/mmind/linux-rockchip.git/
commit/?h=v6.2-armsoc/dtsfixes&id=53e8e1e6e9c1653095211a8edf17912f2374bb03

Wouldn't it make more sense to queue the whole patch set for 6.1?
Or (at least) the whole crypto rockchip part as mentioned here:
https://lore.kernel.org/all/Y5mGGrBJaDL6mnQJ@gondor.apana.org.au/ 
under the "Corentin Labbe (32):" label?

Cheers,
  Diederik
--nextPart4633592.hJsWa3VWUR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCY6wcXAAKCRDXblvOeH7b
btqqAP4iLSE6PpPqVvUKFVUQelSXQCv1a27fo1L7BjYB6PBaJgD/QixSqe6Ap5fh
kPYJw+GTqH5AjTXDFQ2FaC8e6R6pSwk=
=Rj7+
-----END PGP SIGNATURE-----

--nextPart4633592.hJsWa3VWUR--



