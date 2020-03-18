Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B076A189DB7
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 15:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgCROUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 10:20:15 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:44926 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbgCROUP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Mar 2020 10:20:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584541213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rqbf1uphHpvIp+gNZatDv7IiA5bn0SbXYx6jr50PS9M=;
        b=rDj05CR+CQNeSffVcB1bVrJd4/THfeGYWMNMCz/3GueqXbc/qj3s/KvwYTTog8ZvFRn33a
        MNJ2hpoMqWa6Tw6S8HjWkR2nSuVBxwBBCuaHGAyHV58A1muVS49tcE2KzTkkXAIiQ5QR46
        J6CwCurNwMLvo2ugULtBOTWEsofWm10=
From:   Sven Eckelmann <sven@narfation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, hdanton@sina.com,
        sw@simonwunderlich.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] batman-adv: Don't schedule OGM for disabled interface" failed to apply to 4.4-stable tree
Date:   Wed, 18 Mar 2020 15:20:11 +0100
Message-ID: <2953272.8TNtrSRRcZ@bentobox>
In-Reply-To: <20200318141750.GD4189@sasha-vm>
References: <158436631216439@kroah.com> <20200318141750.GD4189@sasha-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2191136.q8Sl6dnBIz"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--nextPart2191136.q8Sl6dnBIz
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Wednesday, 18 March 2020 15:17:50 CET Sasha Levin wrote:
> >From 8e8ce08198de193e3d21d42e96945216e3d9ac7f Mon Sep 17 00:00:00 2001
> >From: Sven Eckelmann <sven@narfation.org>
> >Date: Sun, 16 Feb 2020 13:02:06 +0100
> >Subject: [PATCH] batman-adv: Don't schedule OGM for disabled interface
> >
> >A transmission scheduling for an interface which is currently dropped by
> >batadv_iv_ogm_iface_disable could still be in progress. The B.A.T.M.A.N. V
> >is simply cancelling the workqueue item in an synchronous way but this is
> >not possible with B.A.T.M.A.N. IV because the OGM submissions are
> >intertwined.
> >
> >Instead it has to stop submitting the OGM when it detect that the buffer
> >pointer is set to NULL.
[...]
> Adjusted context and queued up for 4.4.

There are most likely patches missing again when you only added this single 
patch. See the 48 patches I've sent yesterday for batman-adv in 4.4.

Kind regards,
	Sven
--nextPart2191136.q8Sl6dnBIz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl5yLhsACgkQXYcKB8Em
e0bPgA/+NDugYxfQy+EopqHt3QivfqipEa7Ve0Qlygc7V0lpvlXDuNaV9QeGTp8G
+VaRrsfpoQbYNx85i4exiJrs0HbN3at7G1QhLig2BHGqT7TYl2qF/qqbn1JdAZxu
W4awAe/YACP/NvQjSxeC1eWGA7oPBqGK2PlgJSd6HW6rzGRFEMbGFRVxpt+Pk9KJ
9pk/fcutD0GJWaBrSmSwlWlKGK/65OMM2Dj0FkpNlyOLwj9bQ1qYJ4RX+6oMfGso
SUg/MwReBKX3nlN1Ye+eppP716yTYNOZM2ywypHX2wJngGz9r0qO7PH4yA/0tPTP
yHFNkp287d2YbdDfHrKnyCg7QEbB63h/X7e6nJvq9p//haGbuSWEl+NdT8tJ7BP9
ROt3qDCWqr7AISJ4El36pxdr6RbKeJZKqi/Jh9bAdGVX+ClE5KNi7f3K8xqk8Mug
ckTlN1v7163sJVN3xvaSrvnPWiD56Y2U6SnOKJnO5/0nRYel3O9nYymBABeJyyNj
Uf+jJBkiFPCvZKkJt8qwAkZciv+yd8Pb9vjnio9LNqHAP7QmamIgkiBA+xh4ZXj8
Xo0VZAIC7bUt5NR9hTx77rdGMSAcwQ70aA2G+m/5z+mJ+NBVrGOLP3lKCbDAXbBU
bLp1yguH+QaWgrQntDp5Rgh5mir6beBkgj6yGGHa8OuVU+8hEDY=
=yEjX
-----END PGP SIGNATURE-----

--nextPart2191136.q8Sl6dnBIz--



