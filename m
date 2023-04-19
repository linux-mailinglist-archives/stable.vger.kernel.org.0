Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0764E6E8198
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 21:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjDSTCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 15:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjDSTCA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 15:02:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941E94200;
        Wed, 19 Apr 2023 12:01:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2226A63591;
        Wed, 19 Apr 2023 19:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5626FC433EF;
        Wed, 19 Apr 2023 19:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681930918;
        bh=nS7IFsIQ2XE5KxPoADp1jJAGBFdtwfc5+1V0uHGj770=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RQEuLsbkICXzngP+VJ/NUhbu3gwoyyw6fHEJL/Ok2FLtt48WmvSz7RsxGrz9OiuxP
         QdC97ckOt2nosMVrVnC4+Ry1eGu6bhYPRKhWG6lLi7asYtBBYNolOP4b7K42YonLB6
         txiwL5cGuA8Kyo20GDHkISj6G/6MD3QNLGQMrQdTbQ/riZ0L7LWBz7HnaBaHurSwzz
         2rLLUBjdaLv+eez5dYug0AMbdxVpOo4EOc5gd5ETg0YdjbE89iCA3HmuZcwNIVGTmY
         w8XkQtyz/4omj3YxZcK0H+5uYYhcpIU664BC1obBP0DLCU8S6yxUpWdYOViQ9oWCKZ
         ID638eebQPqfQ==
Date:   Wed, 19 Apr 2023 20:01:52 +0100
From:   Conor Dooley <conor@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/135] 6.2.12-rc3 review
Message-ID: <20230419-tribesman-evergreen-c7a48a28395e@spud>
References: <20230419132054.228391649@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vuZoD0rnACbXX0ef"
Content-Disposition: inline
In-Reply-To: <20230419132054.228391649@linuxfoundation.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vuZoD0rnACbXX0ef
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2023 at 03:22:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.12 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 21 Apr 2023 13:20:25 +0000.
> Anything received after that time might be too late.

Finally one that I am happy with! Thanks Greg.

Tested-by: Conor Dooley <conor.dooley@microchip.com>


--vuZoD0rnACbXX0ef
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZEA6oAAKCRB4tDGHoIJi
0q5bAP9yJODA/0JlCTNvUJsAQGfdj5WmyKOFqtzFZqpF/Sbk6gD+OqImbclqqoM0
hIgnUYoUJXHqHl7Xtq1wwPG+Uz9+pwA=
=Dv0t
-----END PGP SIGNATURE-----

--vuZoD0rnACbXX0ef--
