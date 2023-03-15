Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96CB86BBB74
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 18:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbjCORx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 13:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbjCORxz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 13:53:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7802313C;
        Wed, 15 Mar 2023 10:53:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E1C2B81EBF;
        Wed, 15 Mar 2023 17:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB5DC433EF;
        Wed, 15 Mar 2023 17:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678902828;
        bh=b05E8T/0E1DSglwJiBTiu2cWAIBX0lf8tiMr4slZCYM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ru/qstPXSaHMSp30aD6Hc4sUaPNvjAscmuC5A7m5yB/8yj5qIhtGithvlfPqWhth9
         5BNaCmzXY5hphiFRtf0OPnPNrbkycg8G917i8P/Kwxvn7NanQZNgvShfRhvt28txOX
         zcDqCfAhG1U4pq05CQ7G+KH3SfiQnhaoPNZXAVKmcdzubAtWhnPo9NI9JuHMkCsicJ
         9J3rKx1ftN9idziUNyX4T9JRSXrw6Q8A8qA9JJ9i5i7yj5O+cRMIytEBxoW3GZr1kQ
         /x/XKVfURIOqqY8o0XLkSLmMVko/mLevsLV0YxWHjGy5YBgYchVZ6Rwjf08YKyptCx
         RatKlq3muOktA==
Date:   Wed, 15 Mar 2023 17:53:42 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/141] 6.2.7-rc1 review
Message-ID: <01ef81cf-ad20-478a-9ba4-a6e7ddab25e9@spud>
References: <20230315115739.932786806@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3TE21/gM/Hdcep51"
Content-Disposition: inline
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3TE21/gM/Hdcep51
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 15, 2023 at 01:11:43PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.7 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Other than the two commits I replied to individually,
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--3TE21/gM/Hdcep51
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZBIGJgAKCRB4tDGHoIJi
0vhhAP4stbGRxjYs09/KGkpDLBQpt6iPufGmlfvDtdl+T2Q0wwEA87IWQLAxyz6M
VuwKGZsyXj7aGA06eAQzLeThU5uxnwI=
=ArOo
-----END PGP SIGNATURE-----

--3TE21/gM/Hdcep51--
