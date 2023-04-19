Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94DDC6E76C4
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 11:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbjDSJv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 05:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbjDSJv0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 05:51:26 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36E64C15
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 02:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681897884; x=1713433884;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2++nSSrT5nniK9fpVTuV0DgPyzRh8rJXu8hMOLI8idU=;
  b=d9ZbFU351Fyo4YMqIoTKVAYR/PHPwkxvJt3+6qHd3cpg0Kt910EvwYvi
   /zIjYiABDdSfkodO25kd194RSjOTny3xHBds98NDoA1KJTnkDaB8jmwQ3
   M/53vNvNOv3nnBArTm1Yy2m9/oibt9zyNYHCVAkial70RQ+WleaLAdztE
   Ix1LX9CuBPwTObVW86He+Cl9W8Ztt/pmS7k4bDAiFlSKEdSlU6Dn7NJT7
   nEfxIi7XVg+TlQ5cMRKpuABzfeQIuQHTolq3e+wad6ie1FonDCTdWbfoV
   DpG3uL2daYBdgUuNF4ct4G46SEB6NK3KKlhoczrKWhfwWCuaRQKiKSrLu
   g==;
X-IronPort-AV: E=Sophos;i="5.99,208,1677567600"; 
   d="asc'?scan'208";a="147827089"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Apr 2023 02:51:23 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 19 Apr 2023 02:51:23 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 19 Apr 2023 02:51:22 -0700
Date:   Wed, 19 Apr 2023 10:51:05 +0100
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <patches@lists.linux.dev>,
        Alexandre Ghiti <alexghiti@rivosinc.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 129/134] riscv: Move early dtb mapping into the
 fixmap region
Message-ID: <20230419-unpeeled-squabble-986a9e40e4d5@wendy>
References: <20230418120313.001025904@linuxfoundation.org>
 <20230418120317.673170852@linuxfoundation.org>
 <20230418-tactile-cocoa-4242e87bf994@wendy>
 <2023041948-overthrow-debtor-289d@gregkh>
 <20230419-uninstall-fragile-51c326b1adbc@wendy>
 <2023041918-stammer-subgroup-fbd1@gregkh>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mUfhQeVO79oV2LO/"
Content-Disposition: inline
In-Reply-To: <2023041918-stammer-subgroup-fbd1@gregkh>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--mUfhQeVO79oV2LO/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2023 at 11:36:43AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Apr 19, 2023 at 08:55:34AM +0100, Conor Dooley wrote:

> > However, this patch ("riscv: Move early dtb mapping into the fixmap
> > region") did end up getting applied to 6.1.y and 6.2.y, despite what the
> > email I got said for 6.1.y!
>=20
> That's because Sasha backported the dependent patches to get it to
> apply.

Should probably send out a notification of success then, no?
At least, I didn't see one land in my inbox.

> Let me just drop all of them, that makes it simpler and then if anyone
> wants them applied, then they can send us an explicit set of patches.

Perfect, I should be able to do that.
Some time here might actually work in our favour, as I don't think this
stuff has been tested yet by anyone using XIP and I had expressed some
concerns that we would cause them issues.
I already owe you one set of non-urgent backports that I have yet to
get around to...

Cheers,
Conor.

--mUfhQeVO79oV2LO/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZD+5iQAKCRB4tDGHoIJi
0k8PAP9Ga8BokGT94OnNEo5zIe3wIG15iuTSZOPBTQU0v2hREAD/f6iO7wunKFqW
Mp64sgBtnDTckllraDvN0Zj8h06JeQE=
=ddbG
-----END PGP SIGNATURE-----

--mUfhQeVO79oV2LO/--
