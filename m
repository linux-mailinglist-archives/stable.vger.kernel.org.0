Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74BF06289BC
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 20:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237392AbiKNTsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 14:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237393AbiKNTsQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 14:48:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE6A22503;
        Mon, 14 Nov 2022 11:47:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82959B8121C;
        Mon, 14 Nov 2022 19:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2B1C433D6;
        Mon, 14 Nov 2022 19:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668455270;
        bh=gc9A5nj2R6mNJZ7b2bJwX609pNXszLURKRE2NYuQFt8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vQuxY3uXHey+wBOxJUaZ9NdOn71uWj81VuEkhVHuiZO4Lxne7uFgFYu2Y2X/s33su
         gGjJGmACuLypkOM85cmLs3VES85A9gglMIXxlGo4O7rCKZL2X57KUdB1Dk89B9E0bT
         vnaqrICHk9mS+vX9uS/Ejdpa2H4ZQbEigJxLuJ+Xvd8vohEOE/TybROmx9Vk91lYlm
         KZjUsg7R1QbDt+DvFcWkutCNml3R4vKhnXpPHPOqgZUd5Hg2k4D7YZjgHW1vb/MR3Q
         4ct388zDi2owQbqpg91TmpUtaquW0BVEwc4ytilBZhPce5Bwx3XWjKHgd4yKRoEspD
         9o6lIyp2idQjQ==
Date:   Mon, 14 Nov 2022 20:47:44 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Hidenori Kobayashi <hidenorik@chromium.org>,
        stable@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        linux-kernel@vger.kernel.org,
        Hidenori Kobayashi <hidenorik@google.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v6 1/1] i2c: Restore initial power state if probe fails
Message-ID: <Y3KbYLSFLUuVnSIa@shikoro>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Ricardo Ribalda <ribalda@chromium.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Hidenori Kobayashi <hidenorik@chromium.org>, stable@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        linux-kernel@vger.kernel.org,
        Hidenori Kobayashi <hidenorik@google.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-i2c@vger.kernel.org
References: <20221109-i2c-waive-v6-0-bc059fb7e8fa@chromium.org>
 <20221109-i2c-waive-v6-1-bc059fb7e8fa@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qv6denHYt0WD4nxL"
Content-Disposition: inline
In-Reply-To: <20221109-i2c-waive-v6-1-bc059fb7e8fa@chromium.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qv6denHYt0WD4nxL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

wOn Mon, Nov 14, 2022 at 01:20:34PM +0100, Ricardo Ribalda wrote:
> A driver that supports I2C_DRV_ACPI_WAIVE_D0_PROBE is not expected to
> power off a device that it has not powered on previously.
>=20
> For devices operating in "full_power" mode, the first call to
> `i2c_acpi_waive_d0_probe` will return 0, which means that the device
> will be turned on with `dev_pm_domain_attach`.
>=20
> If probe fails the second call to `i2c_acpi_waive_d0_probe` will
> return 1, which means that the device will not be turned off.
> This is, it will be left in a different power state. Lets fix it.
>=20
> Reviewed-by: Hidenori Kobayashi <hidenorik@chromium.org>
> Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: stable@vger.kernel.org
> Fixes: b18c1ad685d9 ("i2c: Allow an ACPI driver to manage the device's po=
wer state during probe")
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>

Applied to for-current, thanks!


--qv6denHYt0WD4nxL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmNym1wACgkQFA3kzBSg
KbYxLxAAmxOGLCEUVGi4wIh35Mh/wHx3+QiIhPMBmv4OOoAh5iVxbeW01GOdSXYf
BwuyzxaiuQHsnl1JWnn9RDEnSjeSM2xKIdk3nA9HXpUGt42W5OzV2+HaDOee/7tg
oWD2gV5ikgNCqvTl8usOgCrxZTW6RFtYPVNFDgI8a38LAPdDfyhda5v1Mq7vGJBi
RIuNLRbHErZB70X0gzBV6YFbm8LBRHkWRTMQVHoOQgN3208BRtCjlkIafKnDbh6j
Ws+7l3g83Epe7M+ExEK/RhStAxYmpayTu/Jv52SjHE/i8cUF0ipntrGrnuAmqnxb
FYExcs9jhCp8AuyN6UwvIlYS4hi0bch/YV9utG4ZMMiBsrvP2z1wjRc+b1mnxhb2
YjzvLKlzqN84ZtoeqrC7F0wrwR5ZJg781cULsIskEpi7l+2DvbMXCHBpwH+1rwLk
gKc30l4JsarA6S5eCyA57ESdB5PuQ9w/6c6wD5KSKFVuF5/wksLyVrm3l75Q/HfL
JCQhUNc9ka4BpFtXpHxHs+UZnYn3aDAobnhzDa0bl1HDS93b1IRr8ETKiMFALgTo
cTMcajw+JU6BBNnaiRlhVxlfKSb/H/fz632R93slQU7+Av0p9SC5/xnUuvL/BSto
VpsepytfbcVTUVy4c4Sjk5Ccw0Kb7RF4XeMmowF9fTt3RBt5gUg=
=wZMu
-----END PGP SIGNATURE-----

--qv6denHYt0WD4nxL--
