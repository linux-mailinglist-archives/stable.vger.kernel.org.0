Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A04E32AEEB
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbhCCAIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:08:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1577828AbhCBJzz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 04:55:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C547364F09;
        Tue,  2 Mar 2021 09:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614678913;
        bh=OzPPIQdrjrgGMYXG2lfqYI46l3thN55RjyGYT0nUeZo=;
        h=Date:From:To:Cc:Subject:From;
        b=uMYhGc/LYWrAd/u9MXYlGt8udEGu+2XoATnHv6jD52WRDflogDw/DqYydhiSnMqQ9
         nEThSr4zsO2zmU2RS3FkCzJ+c5u41HlnxDe6xDGmeIx5Aw2KzRosLvmU7rPHPZD2Mt
         sFti6IB5+8iK66UYRPxM5ZZZVAEayRGWezXgumzAQl3T0Uf5hknTec1WVs436FR9yF
         G1uUu6HN/1I42zjr/ODC9/ob2W+gVancy/TToadPbuzTfkUxXcWdan4cdVQNcntOED
         BnNd/nJExLq0Ao8uVTIIB3Whl9YSCrwLLsmLIeKaj8c9n1BiXAua/K+DrGe3CwAgdD
         xaWVbb8NXbG6g==
Date:   Tue, 2 Mar 2021 15:25:09 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Linux Phy <linux-phy@lists.infradead.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Commits for 5.11 stable
Message-ID: <YD4LfQEXWawk2b4C@vkoul-mobl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="v+XQyuDVIc/t+ilV"
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--v+XQyuDVIc/t+ilV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Please include these commits for 5.11 stable series

9a8b9434c60f phy: mediatek: Add missing MODULE_DEVICE_TABLE()
25e3ee590f62 phy: phy-brcm-sata: remove unneeded semicolon
6b46e60a6943 phy: USB_LGM_PHY should depend on X86
36acd5e24e30 phy: lantiq: rcu-usb2: wait after clock enable
c188365402f6 phy: rockchip: emmc, add vendor prefix to dts properties
88d9f40c4b71 devicetree: phy: rockchip-emmc optional add vendor prefix
aaf316de3bba phy: cpcap-usb: remove unneeded conversion to bool
39961bd6b70e phy: rockchip-emmc: emmc_phy_init() always return 0

Please note that below commit is applicable for 5.7+
36acd5e24e30 phy: lantiq: rcu-usb2: wait after clock enable

Thanks
--=20
~Vinod

--v+XQyuDVIc/t+ilV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+vs47OPLdNbVcHzyfBQHDyUjg0cFAmA+C30ACgkQfBQHDyUj
g0ciDRAAictXR70UR2JkSKLskHOxJkYiK4Ma7YkyG54+eBE36+jE14p3T2GmuCyE
oU7nOQffauoyqdONOnhBRxinNg41hGQbxIuTTreS92CWD53+6VgU0ka+CB0thsuA
+HfM8oTtMs0FDlXcVd6D1QXZEKaEyii//V4XSHNC8VwtdqadKXusl0oKnJDrEkeC
hWCj8woroGOYaXiAfBvtv/OMgcGQ5FJRqXw6dZEEdBMxKjkgw6sVDdOmylvmBpin
4ppZhTERP3iWmMoyezgagXMJRPDxS0wvMU9ID9NegDQuMsrVG9YwxzOeelbVPTQe
PNXfID/GS919TEoaYZkizJsl9REWz2KlREXrHYzeBUZxPUuPB3QV6aJl37uoDJSX
SIIC0A0mLeK8kRkGcFDK3E4koCt8fqfmPxtOPbiK6iPTSDpR+QjUrpSCsrrXAJZZ
FRrzoBqFoDfAlrdQjmp4pxz8a4fCO8xlaeYeYe+6QL7XyaiiPydhGV8raLCg1oJv
mOheNafQ5CsClzohZtWlfO2ZmqGwASnRGFPsAGnUfneRzm5eHkjXAxoeWdPkocX3
H1du1jv2tYKr5//Ck4/gtsYg0aWDR6tzZMazVyb2ehxmbfDRP34+ENAn2tAUCDoz
+mqj3+rW1Gk9NVZcHAUdP+1nSMufQJITEn7/XS0fiL0pFeEelz0=
=Vqll
-----END PGP SIGNATURE-----

--v+XQyuDVIc/t+ilV--
