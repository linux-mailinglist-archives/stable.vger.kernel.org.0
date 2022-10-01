Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F9E5F2064
	for <lists+stable@lfdr.de>; Sun,  2 Oct 2022 00:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiJAWkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Oct 2022 18:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiJAWka (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Oct 2022 18:40:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE212AE3E;
        Sat,  1 Oct 2022 15:40:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB78960DD1;
        Sat,  1 Oct 2022 22:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B644C43470;
        Sat,  1 Oct 2022 22:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664664029;
        bh=SDeUau1NRrwHVnkDKLEDKqadUV11vVH8rM3Ts1FOf/8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C3DyGo20v4EL1/tSzgwddRYDMIVY6HC1KLAD+UuK2/wmBIF1WzJDfzo5faYlFIr1q
         sbPl5T6SuuhVFvuBqOHXRu+B6sXKlKza2fZvO6kuW/YGHIqNYJNlgSBsCQbK3B7ZDc
         66hZqDJQkXI7A7dTWcxVs1Kx92OrOs6gW9fzJTTXsn/mN4ay+LAmkQC8F60Or63gUQ
         z95IL/maox2CP/18vSoTeyh5UKIH1JBEof76LwBom8bNTsm5wdTxRrR915Tm3q6VnO
         UQTI8GW3T/wPrGcrZK8NK3KpUIfB6lFLZSrGmpNsEsPGw8NofdmEGdfJl6jr9oTdfs
         S2rCHFMkZ+XiA==
Date:   Sun, 2 Oct 2022 00:40:25 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-i2c@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jan Dabros <jsd@semihalf.com>,
        Samuel Clark <slc2015@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] i2c: designware: Fix handling of real but unexpected
 device interrupts
Message-ID: <YzjB2WSQfL7i4Teo@shikoro>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-i2c@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jan Dabros <jsd@semihalf.com>, Samuel Clark <slc2015@gmail.com>,
        stable@vger.kernel.org
References: <20220927135644.1656369-1-jarkko.nikula@linux.intel.com>
 <YzMKHf+aNKiGVkyn@smile.fi.intel.com>
 <31477388-b57b-5383-9c6a-18905c28253e@linux.intel.com>
 <5b8a4060-b800-6701-e0c9-cc8dfa0e6b67@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="CLyLKKq1hI7ip7Vj"
Content-Disposition: inline
In-Reply-To: <5b8a4060-b800-6701-e0c9-cc8dfa0e6b67@redhat.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--CLyLKKq1hI7ip7Vj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> I will let you know if I hit any issues, if you don't hear anything from
> me then you can assume I have not hit any issues :)

Ehrm, how long should I wait before applying the patch?


--CLyLKKq1hI7ip7Vj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmM4wdkACgkQFA3kzBSg
KbaGTA/+LjVJeCfOL9M037XFqvz6Z139BdGtnbvQDTPmNscohm4o4LQx5PuK7a8D
d1/ht1flvKW7mFfGrmJc6nP42wETNhCfRpvHCqsHNBjH+WTWjJS1hWOVw1eUoIxk
vn2phrKETo9pBFatXhuJWRVZ2KsdIOgtF7siEOmXA1qi20b8VtAQm8S6RqqslpCv
tQfvy4p4quZJqW4SYlQQuP/WBRA12NOKi06yeWkSTvJ2Vk23owICsCWgZfUM2pPa
bNy8lacY6wbU86EdeIq/KnI2ZAJf4ZMozpF3QxMLWPirocSnnPAVzssPRQaIU6M2
Dv8bwY1rZ4qAU6OLUN4yKOHxWTrOVFGuTcXnFOc8QPjZnFrm1RYOd3Y8v4SaG9/+
HWQ5SQPqmdWhxaKKWpR35JrGCFV0PdwqGPpVAkgmpwWotHQqkm7TV4akMIh5UP9t
mNbixPdx0YWPt0xAixH9o3QOaxQZbg2VSUKezDRhAURCKVyx+1BV4CEhO50ZHIx6
EJzyTVWTpX8YOx3L6HJXEpc74wX6543n5XnaAebFO2/Fy57kBVCGnCbiIBrnqi/O
nT9+A21SvYMf3R7FiaulppAv7I1mD34b4pQ1GRVf2kvNu27+iYyTLsuax+yodfHx
J7eIXbjEAeJcneYeExOdneR5/8VCxwYM0k8q0qcTwwKKRwbsfkk=
=y/YH
-----END PGP SIGNATURE-----

--CLyLKKq1hI7ip7Vj--
