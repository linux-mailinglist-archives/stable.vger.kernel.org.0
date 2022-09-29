Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 289025EF6C7
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 15:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234999AbiI2Nl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 09:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbiI2Nl1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 09:41:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0871B2619;
        Thu, 29 Sep 2022 06:41:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9CA20CE2047;
        Thu, 29 Sep 2022 13:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02EFFC433D6;
        Thu, 29 Sep 2022 13:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664458880;
        bh=mxXXnA7AKPAULTlYNVPDjF57KXpljiAzFpErQ6L/1tY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kD99SUi9aD82aEpsa/ei1ebO1r29oG/ZVMDIk17nbHRVQGFi1N12sOp0DKTh0c8KA
         9G2SvprS9iyhYSZ+vDeqcHxx5odZX1HRwcCGbnI58ZvVF51Z2eJlwa0JiKoyy1HTNO
         mEj7/Vn/j+KGUuD1p+V8xQKSPgN5yY/+1vCMRAB+0S57fBePwVqLGkFfmRJTgs8bF0
         zucU8dz729hhgBqOx0xW34hWfFmMpMKgpw2XRTWUxDbRuSCWdFmLfgcFBWh9cB37U+
         iZdnhxMrK5OSmM4OTQ+VxPtvs34GHn1FZpsTw2iOB/U2rqEHvYW6OigptfWbQS9gmO
         oLUculB7hHbeg==
Date:   Thu, 29 Sep 2022 14:41:14 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Banajit Goswami <bgoswami@quicinc.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] ASoC: wcd-mbhc-v2: Revert "ASoC: wcd-mbhc-v2: use
 pm_runtime_resume_and_get()"
Message-ID: <YzWgescSJMKzYTAo@sirena.org.uk>
References: <20220929131528.217502-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="N7/RendiH0c6BA6h"
Content-Disposition: inline
In-Reply-To: <20220929131528.217502-1-krzysztof.kozlowski@linaro.org>
X-Cookie: Last week's pet, this week's special.
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--N7/RendiH0c6BA6h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 29, 2022 at 03:15:28PM +0200, Krzysztof Kozlowski wrote:

> Cc: <stable@vger.kernel.org>
> Fixes: ddea4bbf287b ("ASoC: wcd-mbhc-v2: use pm_runtime_resume_and_get()")

That commit isn't in a released kernel.

--N7/RendiH0c6BA6h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmM1oHkACgkQJNaLcl1U
h9BOwAf9GBA+KS/sN5rGBNQyJN6J5INLcsm4sQA5Xpy6cOd6HMSadJEAsuW65BOd
v/PwcFjX0g6TQwp7nz+RIOEJbyO3gpaOVYFniPMAnEc+79UzH+G4EYhIucoLpNGt
Xz68t5S8OT5AkBKFojx0h0hqeLrWRyUGwAc4q1ZjEWKC4By7Yqu3cjWFbKhFAFKz
iFl0jqVNkwzpEe/EFTnEBpF4s49xeDBf+wQPn3Bw6nPvCGEHi/cU0dB0YA/Zeiu9
w7nqe+tkL8oBj1qcvJtpEl2VOp9tSxbr9oT6z8TYOE7umzdTIKWOzx9fgfZWH1B5
zVc0fC8MrvnzwiscC2znHB//s6BoOg==
=hpEo
-----END PGP SIGNATURE-----

--N7/RendiH0c6BA6h--
