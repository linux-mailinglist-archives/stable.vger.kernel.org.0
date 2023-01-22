Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13172677524
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 07:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbjAWGjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 01:39:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjAWGje (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 01:39:34 -0500
X-Greylist: delayed 369 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 22 Jan 2023 22:39:33 PST
Received: from phoenix.flosstools.org (phoenix.flosstools.org [185.15.229.223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D79DBF4
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 22:39:32 -0800 (PST)
Received: from turnagra.localnet (adsl-84-226-16-207.adslplus.ch [84.226.16.207])
        by phoenix.flosstools.org (Postfix) with ESMTPSA id 13715D8BC5C;
        Mon, 23 Jan 2023 07:33:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=debian.org;
        s=flosstools.odyx.user; t=1674455599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cYfj5w5AvKZDq7wbkVExi9uw24Z6F3TMhV4+dEf1v94=;
        b=hUK2dlS530nveWt258t31SgzhUOZ75GSQgzfesbygOf7lkvIUaEb4S08pxFwLBaRAJoiNo
        +YEnNIZCH8Aszq9LjR1yudffN9MlMPcxbzkkWNKBRR7WpeLrsMmkB4BsXOmqGulJaoYgmS
        DS1ocUr676FZugm0w2m2thrhoyWsvik=
From:   Didier 'OdyX' Raboud <odyx@debian.org>
To:     amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Harry Wentland <harry.wentland@amd.com>
Cc:     ville.syrjala@linux.intel.com, stanislav.lisovskiy@intel.com,
        bskeggs@redhat.com, jerry.zuo@amd.com, mario.limonciello@amd.com,
        lyude@redhat.com, stable@vger.kernel.org, Wayne.Lin@amd.com,
        Harry Wentland <harry.wentland@amd.com>
Subject: Re: [PATCH 0/7] Fix MST on amdgpu
Date:   Sun, 22 Jan 2023 20:12:57 +0100
Message-ID: <4499220.LvFx2qVVIh@turnagra>
Organization: Debian - The Universal OS
In-Reply-To: <20230119235200.441386-1-harry.wentland@amd.com>
References: <20230119235200.441386-1-harry.wentland@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2311774.ElGaqSPkdT";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--nextPart2311774.ElGaqSPkdT
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; protected-headers="v1"
From: Didier 'OdyX' Raboud <odyx@debian.org>
Subject: Re: [PATCH 0/7] Fix MST on amdgpu
Date: Sun, 22 Jan 2023 20:12:57 +0100
Message-ID: <4499220.LvFx2qVVIh@turnagra>
Organization: Debian - The Universal OS
In-Reply-To: <20230119235200.441386-1-harry.wentland@amd.com>
References: <20230119235200.441386-1-harry.wentland@amd.com>
MIME-Version: 1.0

=46or the whole series, as rebased on v6.1.7. Tested on this Thinkpad X13 A=
MD=20
Gen2:

Tested-By: Didier Raboud <odyx@debian.org>

Le vendredi, 20 janvier 2023, 00.51:53 h CET Harry Wentland a =E9crit :
> MST has been broken on amdgpu after a refactor in drm_dp_mst
> code that was aligning drm_dp_mst more closely with the atomic
> model.
>=20
> The gitlab issue: https://gitlab.freedesktop.org/drm/amd/-/issues/2171
>=20
> This series fixes it.


=2D-=20
    OdyX

--nextPart2311774.ElGaqSPkdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTjpQ0b6NokWkvBQbzqgwvGpoTNfAUCY82KuQAKCRDqgwvGpoTN
fGdzAQDkKemGCY1aSI+/GyRfJUtLZgXXylk8Tg36JH4RRGAR4wEA5//nKnCu/FpM
O88czFy7eTo+6saQtOcDKoHmp8JHowk=
=1KOM
-----END PGP SIGNATURE-----

--nextPart2311774.ElGaqSPkdT--



