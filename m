Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1516E65155
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 07:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbfGKFE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 01:04:28 -0400
Received: from mail-eopbgr150089.outbound.protection.outlook.com ([40.107.15.89]:43843
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727874AbfGKFE2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jul 2019 01:04:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LSPuR28l3ofDQ3z0SOUE+WzxxlcZ6rRwP5jqd42xIWPHUf5KqeotlnUQm5CBcq+r4iutrDUfA1sPuVJNeNMXZ39Tff4OFwRS2q5IPBgXyIQIU6i1Ltzool+mD6KDTLdqyb5g9khrAT3bsZAIxkiUOiqopn4TXHupIAoeRFYZWHF0qtElX5O05GpQ6H9iLnEJFThMfw71Cte61V3h7+Lzl82uFcNn0yyUiziONYFLKv1gZfHRcWk2GVk4cA87tdLDGFeoqqtQoJSh/AuwYT4MzIZRkZrF7IPi6AFvYts2PCs+yK7MnJ3QHfrAyqhrO5tPL/s+eaTSxeeks/5WJ22RXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z83sYZqk2O9DenZ4DwcWHPJCV0wSkM683OltWOosMNw=;
 b=gp0i0o6qUZF2hvrsA8zb8IE4sR7Np5b9u93TtSAalIYMfDVESb2D0H2kZfhIJVLYUJqCGwve7e7dcVgd27c4CcSC+zRXP9Oe8Kq0FnGW7v3qq5MXF/NkByzycGY4bLyxR+vSJoJlI+rW4+xf8WTaqduJFsa8NG3+vVDzbumGpaBVywYq7bznGjaYUEoz/sMoQGBNmeztcmXQookf3kc1pJA4mcplCOhm9F+t6dMCNocYEcSf163XBMZ7+x/q9CXrWE1cesXGHAwZKXB83r9U76Djz6QSslElPYwU1FbLdX6p8LB8Jd99KgUPnE3iRfikbci8YhKpHG/IJeFIlOfDRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z83sYZqk2O9DenZ4DwcWHPJCV0wSkM683OltWOosMNw=;
 b=Vhqt5ttHTEf0Q+DjhGgST+3WfXljqdZYNGgeSjcK9JpOi7bIn83RY2UTDZYoEkp2LNB9ESySNuVY71M46s+QnnXm0ttUVn9FrGqKLbFA2CEc+X7EnAQr6BeKrA1AayHflV5e2NvQHRRtql2e1PQ/m8hWblDjOGcQG6rLawi8N+U=
Received: from DB8PR04MB6826.eurprd04.prod.outlook.com (52.133.240.82) by
 DB8PR04MB7035.eurprd04.prod.outlook.com (52.135.61.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Thu, 11 Jul 2019 05:04:24 +0000
Received: from DB8PR04MB6826.eurprd04.prod.outlook.com
 ([fe80::a5a4:22ca:7b9b:2d92]) by DB8PR04MB6826.eurprd04.prod.outlook.com
 ([fe80::a5a4:22ca:7b9b:2d92%2]) with mapi id 15.20.2073.008; Thu, 11 Jul 2019
 05:04:24 +0000
From:   Ran Wang <ran.wang_1@nxp.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Shawn Guo <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Xiaobo Xie <xiaobo.xie@nxp.com>
Subject: RE: [PATCH AUTOSEL 5.1 08/39] arm64: dts: ls1028a: Fix CPU idle fail.
Thread-Topic: [PATCH AUTOSEL 5.1 08/39] arm64: dts: ls1028a: Fix CPU idle
 fail.
Thread-Index: AQHVMUUufyAeHKyv8U6/zS4ZNHbUTabE4czg
Date:   Thu, 11 Jul 2019 05:04:24 +0000
Message-ID: <DB8PR04MB6826A4A8CE604F2570DC1EA7F1F30@DB8PR04MB6826.eurprd04.prod.outlook.com>
References: <20190703021514.17727-1-sashal@kernel.org>
 <20190703021514.17727-8-sashal@kernel.org>
In-Reply-To: <20190703021514.17727-8-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ran.wang_1@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e889ede0-7180-452b-a62e-08d705bd3df9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR04MB7035;
x-ms-traffictypediagnostic: DB8PR04MB7035:
x-microsoft-antispam-prvs: <DB8PR04MB7035A9EBDDB88F00515DBD48F1F30@DB8PR04MB7035.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:660;
x-forefront-prvs: 0095BCF226
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(199004)(189003)(13464003)(3846002)(14454004)(64756008)(8676002)(6116002)(2501003)(33656002)(6436002)(4326008)(7696005)(229853002)(8936002)(26005)(5660300002)(2906002)(25786009)(256004)(6246003)(14444005)(53936002)(55016002)(66446008)(76176011)(76116006)(66946007)(66556008)(66476007)(81156014)(9686003)(52536014)(81166006)(186003)(66066001)(71190400001)(71200400001)(110136005)(478600001)(102836004)(486006)(316002)(2201001)(68736007)(305945005)(74316002)(7736002)(11346002)(446003)(86362001)(53546011)(6506007)(476003)(54906003)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB7035;H:DB8PR04MB6826.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yF0BlUXJgMnAysfugLru/A66Z5W/NLYRwzUIKnogo4w2rnxt3xEIRvoD7jHJn/POQthHXEJLdYL02hzNSlMknAxpbQ7mK0VX4fJJEWdBnU/ugOA4ZnUBPNcpyd0BxeVG32YfukgiEelSXMRk+SAmTFI5ABtaoNyVyrl9g17pp1ho6R4jekHgDEnxTcbJl0UjOnzkiISGm+sbMQDqx0ymmmu1UyXdTJL/+JcngMzX1Z6GezS7iAesHTc4djg0si0TSiBTjTI055s/U8GDIh1MPJ9jMsgiHhvy1Px+uuUbLYRKnP4J4hrXZ+Pydmcx4soQkmDiYuEp2JQPeASRmwxXd4nrh+kAHQHWG/JqUDmR+MMcQ8OTuwctAA+XVg432cnfJKh0XeoVLHaK0ADH6BlSPGW+MDAVIXMIJbDyqkoa7X4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e889ede0-7180-452b-a62e-08d705bd3df9
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2019 05:04:24.1942
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ran.wang_1@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7035
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,=20

    Thanks for helping port this patch to stable.
    May I know if I can submit other bug fixes which has been accepted by u=
pstream to stable by myself?
    If yes, where I can find related process for reference?

Thanks & Regards,
Ran

> -----Original Message-----
> From: Sasha Levin <sashal@kernel.org>
> Sent: Wednesday, July 03, 2019 10:15
> To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
> Cc: Ran Wang <ran.wang_1@nxp.com>; Shawn Guo <shawnguo@kernel.org>;
> Sasha Levin <sashal@kernel.org>; devicetree@vger.kernel.org
> Subject: [PATCH AUTOSEL 5.1 08/39] arm64: dts: ls1028a: Fix CPU idle fail=
.
>=20
> From: Ran Wang <ran.wang_1@nxp.com>
>=20
> [ Upstream commit 53f2ac9d3aa881ed419054076042898b77c27ee4 ]
>=20
> PSCI spec define 1st parameter's bit 16 of function CPU_SUSPEND to indica=
te
> CPU State Type: 0 for standby, 1 for power down. In this case, we want to=
 select
> standby for CPU idle feature. But current setting wrongly select power do=
wn and
> cause CPU SUSPEND fail every time. Need this fix.
>=20
> Fixes: 8897f3255c9c ("arm64: dts: Add support for NXP LS1028A SoC")
> Signed-off-by: Ran Wang <ran.wang_1@nxp.com>
> Signed-off-by: Shawn Guo <shawnguo@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>=20
> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
> b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
> index 2896bbcfa3bb..228872549f01 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
> @@ -28,7 +28,7 @@
>  			enable-method =3D "psci";
>  			clocks =3D <&clockgen 1 0>;
>  			next-level-cache =3D <&l2>;
> -			cpu-idle-states =3D <&CPU_PH20>;
> +			cpu-idle-states =3D <&CPU_PW20>;
>  		};
>=20
>  		cpu1: cpu@1 {
> @@ -38,7 +38,7 @@
>  			enable-method =3D "psci";
>  			clocks =3D <&clockgen 1 0>;
>  			next-level-cache =3D <&l2>;
> -			cpu-idle-states =3D <&CPU_PH20>;
> +			cpu-idle-states =3D <&CPU_PW20>;
>  		};
>=20
>  		l2: l2-cache {
> @@ -53,13 +53,13 @@
>  		 */
>  		entry-method =3D "arm,psci";
>=20
> -		CPU_PH20: cpu-ph20 {
> -			compatible =3D "arm,idle-state";
> -			idle-state-name =3D "PH20";
> -			arm,psci-suspend-param =3D <0x00010000>;
> -			entry-latency-us =3D <1000>;
> -			exit-latency-us =3D <1000>;
> -			min-residency-us =3D <3000>;
> +		CPU_PW20: cpu-pw20 {
> +			  compatible =3D "arm,idle-state";
> +			  idle-state-name =3D "PW20";
> +			  arm,psci-suspend-param =3D <0x0>;
> +			  entry-latency-us =3D <2000>;
> +			  exit-latency-us =3D <2000>;
> +			  min-residency-us =3D <6000>;
>  		};
>  	};
>=20
> --
> 2.20.1

