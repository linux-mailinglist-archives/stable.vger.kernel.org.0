Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7956B5AA3
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 11:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjCKKpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 05:45:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjCKKpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 05:45:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DF52684B;
        Sat, 11 Mar 2023 02:45:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8893960B10;
        Sat, 11 Mar 2023 10:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D050CC433EF;
        Sat, 11 Mar 2023 10:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678531503;
        bh=gof2yisp2HtIDZbA1b8gnwkujtd93p2xrNzrWdFyZOM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mlM4pNEFTwMj2dn1dA+/ugfFAURJZEmy8ECzi/Kz+seqLUChYsWhwutj6U/AOUpPD
         3Jb8pNGpMZy1vflOLHZ49pHOetaz5HFTJVHzIR3XOc8jEsY3obFxjtX2xAjDhun68J
         IzrEfEgEPp4pSy9y+TIpG1GIOg07t8zRTGefhuwHDgF3/AuGKWGPhXDm60bCxZnUQO
         +2P/OSLkQcOZ8eurIwucG4UdzcUQTf7P7koyyCT8LaWdNl43wJRYOvZmaBCevdCFY6
         7getoEeE1IXzgQbkYzuksArx+n1L8NLyBGmWB6dLPp4IExZQXqDPdjDPaSIUIU8ur9
         uq+ZiDh5pY8hQ==
Date:   Sat, 11 Mar 2023 10:44:58 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/211] 6.2.4-rc1 review
Message-ID: <7ea166cd-6ee7-4e37-9c1b-651af74b3485@spud>
References: <20230310133718.689332661@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZPlgujJ53LLPEV6A"
Content-Disposition: inline
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ZPlgujJ53LLPEV6A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 10, 2023 at 02:36:20PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.4 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No complaints from my CI :)
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--ZPlgujJ53LLPEV6A
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZAxbqgAKCRB4tDGHoIJi
0hiBAP9QwqvVjlZXm79qpbUfDTsT84TD6XWWDhiiRuTh/d3eQgD/ebZnfcCZm5cP
PK6W0EseZ/LzoK58QbYn1ygqlBTwKwM=
=s0fh
-----END PGP SIGNATURE-----

--ZPlgujJ53LLPEV6A--
