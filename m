Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBFA66AF6F8
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 21:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjCGUyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 15:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjCGUyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 15:54:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A60A728F;
        Tue,  7 Mar 2023 12:54:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C64FB81A1D;
        Tue,  7 Mar 2023 20:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA67C433EF;
        Tue,  7 Mar 2023 20:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678222446;
        bh=+byuCQxzuxFlMv5oGxReuLmAyNw1zdYW+tZMtKemG3I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pdbTqMMRDmOFskBaWm0ECwOn944y/Loab9qSerg+kicphwignFtdAZx11Pa3CyvG4
         NJ3mc57SMdJFUkQ6unpDsPhz0oBZi9KpaJIEGDZ3R5tYL5Q/9oi+c00sqUcIBNjkPp
         4cVPJeyb1YYkfw9IGY+4ddRDE7gBaS66Yix5pLyj6JBpEJJh69/VR8xAt1dfCVgKcg
         rnaiN0a4CBFPL9jAupPCAkCRSES1xhFAaTKFNPjXx7+mABd8PIpFUevMGlhomiQjJv
         SEZ7wTJTSTAeXj2vY/1NBX8CEQZFrJqQ1226q+N/3iXeN0zksCXnPJ6hP9h1PPMAzK
         oaN2TuOo+OB6w==
Date:   Tue, 7 Mar 2023 20:54:01 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/885] 6.1.16-rc1 review
Message-ID: <fc007ffc-8a87-4419-84eb-9d246b01b51a@spud>
References: <20230307170001.594919529@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PTF7Vd9Y9N9VDtAR"
Content-Disposition: inline
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PTF7Vd9Y9N9VDtAR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 07, 2023 at 05:48:54PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.16 release.
> There are 885 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

My CI reports nothing untoward..
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--PTF7Vd9Y9N9VDtAR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZAekaAAKCRB4tDGHoIJi
0i2BAQDjthKpZP3ZGUnInJ7wY/glbj4nM915GmtgexP1sWpg9wEAyuN/n6hIFMt7
Fjoh8shICTTyvXNkv8mi1c1Q1VMbIws=
=l+1t
-----END PGP SIGNATURE-----

--PTF7Vd9Y9N9VDtAR--
