Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 673264CFD56
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 12:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239049AbiCGLsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 06:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241975AbiCGLru (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 06:47:50 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0186166AC0
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 03:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646653612; x=1678189612;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version;
  bh=63lgLmUG04krbwRje6tgnHWyFUg1do60ZCOG+z5SVns=;
  b=jjc3LqMg/zVMI6RvS660JB7+nwR3DvEpwkStIrxCyb43JOKDk02lyGhg
   5Z2aZ1StkPxvQAsvaQvuMXcuQRxA5XiOteYi1HUbR47tvVHXgMA3ZHwUa
   Yii0lzs5xbbnRpZgrdn6O4bp7B8xrjv4UGyTXih5FhNoFc92xdXI92CTY
   SRjiCPXblenYYdNROZbiRvaeXZLzdJPCJYdPpPs+qIoiVpTbv2csoW/MW
   3ONIM4q3eTQ9VQC0OLPLeuTnBLHmxSnK0noycGCXfqpXXEzAia4qJn0C9
   b0PzEXN8VEDxqiJGZc4sVlt7SwbkhIlZb5sNquxwZPq4nP/U+2UqSaRFH
   A==;
X-IronPort-AV: E=Sophos;i="5.90,162,1643644800"; 
   d="scan'208,223";a="298795027"
Received: from mail-mw2nam12lp2046.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.46])
  by ob1.hgst.iphmx.com with ESMTP; 07 Mar 2022 19:46:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIPF1mSE1Jzww3g+hBb6/OGlsPODyDX8x0BWNNCU7T93xt6s0XtflWjKtReckNa6GLA4IlmMCw5gfeuC9bRGBnuQQ8KaOF08HXmjE0gzyxmP71scUqGxoYvib7Ehn0lufTmHN7HF57EHRrPex3JxTJvCHY8L0sGWQ4AI0FrRbQh5NezJDKOAsu4Wu5eCmxEYhdMq2q4gzWed2B6rizxbQrnO85ye3zX5o0VS8J/YgaW5Re2PteTUjbhZFSRT6UcP1ylZ1v8wrhS09LBhJIicTyYmbv9Jc2lTLjUreH8+GoyLo363QzR3sOfMGdBXerSVUUB4FRhjm9EH72flbJPLqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o4hhK35i9YK0fGFz/Asb13tKtQCeXBqpKGYrBKS2O9s=;
 b=mkBmgYOP5TPU/4C1Gmg5r/7S/pnNbDuzeYBXhgvp6kqhGO7norrHCGCVFpf01fSKTzd25NnFnulKV9+n+H40mD0NaALgqV/LzoxdlFyBlhrYjmq06Gke1kGZ4gTminacmXwNCuyk5wo3t96aM8q13F/e5N+UzzoFr8iiFCAfcGS/YDB9s4xG4PG445IaLKKH0Hbf29kjYyxRNXNKTJ3wC63jDih/wnRh8tB+6BtsqThzmCfRLoFuO53t5cwPZLbN2/2T3eZfL/008FAI3J1o8uPHYgqHP8b9F1KV8jGmklN07KZP6AqUh7kId/mcYraTJM2pznmk21bVRj6YMtfETw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4hhK35i9YK0fGFz/Asb13tKtQCeXBqpKGYrBKS2O9s=;
 b=pFtIVnh/59QRoBIZbmFzzw2eXFh+m2Clsu6kSOjyHRTPyZt+nFjrfE+4WqbPSfYRmsRKXWHUCnhOuVhCGSVff1v6CQxgJeRkTtu8NlVgXwisUD/kyFooX5UA+o+wYuDdyC97VqHmaU900LiJfWyfKJ14aJSic3G11MG/hXEfxiY=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by CY4PR04MB0359.namprd04.prod.outlook.com (2603:10b6:903:b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Mon, 7 Mar
 2022 11:46:49 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::f025:4f23:8e46:b2ed]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::f025:4f23:8e46:b2ed%2]) with mapi id 15.20.5038.027; Mon, 7 Mar 2022
 11:46:49 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "palmer@rivosinc.com" <palmer@rivosinc.com>
Subject: Re: FAILED: patch "[PATCH] riscv: dts: k210: fix broken IRQs on
 hart1" failed to apply to 5.15-stable tree
Thread-Topic: FAILED: patch "[PATCH] riscv: dts: k210: fix broken IRQs on
 hart1" failed to apply to 5.15-stable tree
Thread-Index: AQHYMM0Brq88SLjpF02hfiifwq9eoayz0HKA
Date:   Mon, 7 Mar 2022 11:46:49 +0000
Message-ID: <YiXwp6Yx7bmRaAin@x1-carbon>
References: <16465109854128@kroah.com>
In-Reply-To: <16465109854128@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 785c6d84-09d0-4eaf-9c7d-08da00302a24
x-ms-traffictypediagnostic: CY4PR04MB0359:EE_
x-microsoft-antispam-prvs: <CY4PR04MB03590D90C53A88CCDBC74E32F2089@CY4PR04MB0359.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qpk+T08xvR174U1gqtgYI9KGSe9MPiQTlqfzMoOs7zbx6ngN1iK1lAP7cfxmWR6bbc2Lj54zzrYRqgKSeVFoKv/cgJcWWqt4XpsKQ4yj0LR4LqMdUobabZovaDn01edqhAegGuGFAZttnMT7eyN9pAxZM1M9EkB7gIendvfpSSz4lAMRjEX5nKKdPZhiButhOoeUyB37tR2X/wNbfM2z/ifvv8UoeciIiL3snuyEBZPMdrdeXlGW6gvCuAzjyYxXyOcqBVRz7IKoCiATynPmCyZYbxgyj4p+WMADfxWQ0Q8crYwnqsU00bvl8dTEDujzGnajx5sXC2FvdrAdeHtWPkS9u0MChXcGi9RMDPtDSPHb+yTsm2hVnIS5hipLOxS6Xb1/QSkytfrvFdnfYpZ2VBWYEO6GDjFh+5nQPl0MxNBw7c8Huz+YaITUu9ewGIsosjFLcw+I5K6mNI6ZG09EGF+lz9r3ppP0fTngkIRWMYV7JGvG7bzc0sTmP3Scfv1n23s2nytyBgCUuExjUD7nmD1DvSkh2f0EpiRfPjCqtcBZBB3E9TycbwgKQj5Qb4YX+ZA/JEurL/p2R1T8GipKPwmZ/qAiUz/3iDjAWn2bLtMLVNj4SUuQRs8dHyNaQi0/jDZHIUwWFA67tA1ve8zPkTBdxxRoiBZybnsDgjEqEfCZgjnO1ep6cWcU8WVYjjqUMAXHEX4ifg3ocQKkvPbpwA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(8936002)(6486002)(66946007)(66446008)(8676002)(9686003)(64756008)(6916009)(316002)(66556008)(99936003)(6512007)(66476007)(76116006)(53546011)(6506007)(71200400001)(4326008)(38100700002)(91956017)(38070700005)(122000001)(26005)(33716001)(5660300002)(2906002)(82960400001)(508600001)(86362001)(83380400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KiCpBmPGrRK3wPu8I9/kb79p5WCBm8u/leI+SNaV0ZcZ20TYZhzfnWR6LKEH?=
 =?us-ascii?Q?gNteSDtXLA7VA1gM3p1rDMcyatekmy/nLmEVxDCds1TFOntUTx8MGt82YMii?=
 =?us-ascii?Q?N4QfGpsOfWf2QNDF2/Pc7hm2o8ypaVlcaar4Db5F8fjJyhpqm/UjlOiByNqh?=
 =?us-ascii?Q?SGQJB52OQAg/31rowV+mZ2EpmlsAAtc8PZe4gYvqcOT0stbyDZMI+uL2bzls?=
 =?us-ascii?Q?//WVP452Kvlk3gzNfPnlMhkx7ag0Wf+3BOe/urx+euRaaqUrz1lf/0gluKnW?=
 =?us-ascii?Q?E7kG4FiBEmDmKODMffAIVRV0eVAQaHgrUHaw1zuF1ZWvNkM7PUsBbhnakjG4?=
 =?us-ascii?Q?zyD3b5ufgC5knoukD9jdTrbMip1V46qj0uNLso3313zj+K7fyL/IF2ijIPcQ?=
 =?us-ascii?Q?qfBmyifoqV4gOJcRHDO0UUpGNh4TBIcQcY7XMcBi16nMABZiGAJlfv5/K2zi?=
 =?us-ascii?Q?43FYlGzgY1rFlu8/zQEIxpYHNnhxp6138l1FjPBk+RC2swTOFZx84Wb7P31i?=
 =?us-ascii?Q?4bSBN/bm02qZS6z0tF5Clr251UHm26ME71YEM1myeRC1vfD1IaULHcszZGJW?=
 =?us-ascii?Q?6j3disvIjXpHavwGUxrSO+knARLH9MWcjvnVNn7HSFgxWKQviDpmJCLelxyH?=
 =?us-ascii?Q?9s3IQ1PT3fm0VlB5S3WqDTcSI2h9N6wLNzdh/EDr3p6g+p1ZTyV5yZ3UJ4Vb?=
 =?us-ascii?Q?hXiB6C5xRnwNi0G148nTa+mRQzz79dEaIxM5th7pZUY1d8bA6cJpmXtmrc0Y?=
 =?us-ascii?Q?NzIKKGTijsQ6npSd2bw3Pj26Rdnq1mrfr5aFf4OEjJ/P71FOdwWI4nQUIiVP?=
 =?us-ascii?Q?2C/tLKGWEWzjCnRMngZvLxhllsKiICo5Uppqd4Q7KoBDs5sURTzbjARIVpJY?=
 =?us-ascii?Q?DIN1OUNQ6L1WLac1GxE2EPz+W1RdK4372+dfjY00AgbEktR+vSYQfx9F6gNZ?=
 =?us-ascii?Q?YN7otqTyzMfaK68lVXtbXLTmddUh/pZ+HBHkoO6K1leBRRQ9Tpay3JTeZ6jo?=
 =?us-ascii?Q?8cLYFtPXrPWWRen4rb3HqODWK6LxJDF0rYevOzPCNnhREMQfedn/O/yu9GDS?=
 =?us-ascii?Q?AXrB3eBd9XBdhgqwPNyDk+Q1e6H9HATkfoqgkO5uKJ9078JvWcW3NP+Xk2at?=
 =?us-ascii?Q?b6PSpBfKhpph1YUDYDwAXdHNjs27Xn0oulKcKI201ZI4z+amtni8bjH1ZD8X?=
 =?us-ascii?Q?iV7P6SV4NyKxWEfcYI8V4aQYXcn3e+LJQfTxSXNT1IZ7aeAYSQq0t17KQciN?=
 =?us-ascii?Q?0z8R9FOA6jHNaTqxKVDcXIwNQ+GTN+5GvcNqFchkPmU4MabTX5/vwvr3bpVs?=
 =?us-ascii?Q?F0NlNkI7mM8T8d+CEH6CMTw+ISSQkjtg0KzQOdwfYZBg4aMBYtzu5pU1H9Go?=
 =?us-ascii?Q?g5aLrzGNOBENJbtQ/M3hcwvxBB+JR6/OQPv/JdAyrxiu42u4In0PEHPT6kwi?=
 =?us-ascii?Q?uDrdC+TIWbteQ+BZUKFv3geKbrWDba52d2VoYtpMGg6vdR26KNBn+joGf4CG?=
 =?us-ascii?Q?JOSoF7YSj/d9AcEkq6LCvHrSXKb7o4Sp5EablLbmX1qgQdReqEmqLabtrlRQ?=
 =?us-ascii?Q?L2SbzsdK/I7NQQ5Jzq7DNjiABIblEIX8djYW+YDdN7MgtT29GrWjFsw3yrLn?=
 =?us-ascii?Q?s1aeeJN6QIEtl8EZZiP12tA=3D?=
Content-Type: multipart/mixed; boundary="_002_YiXwp6Yx7bmRaAinx1carbon_"
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 785c6d84-09d0-4eaf-9c7d-08da00302a24
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 11:46:49.0413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WXgE4tyYBMKCosO+svyOdHii8aR3pxDGGhRw7QVybYQUzHIF3kGE2KsBW063d3QtIjIxhVFHcfOcuz2spVodvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0359
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--_002_YiXwp6Yx7bmRaAinx1carbon_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <26D7B64ADDB6534392E58F8F4E248A7A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 05, 2022 at 09:09:45PM +0100, gregkh@linuxfoundation.org wrote:
>=20
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>=20
> thanks,
>=20
> greg k-h

Hello Stable (Greg),

Original commit in Linus tree:
74583f1b92cb3bbba1a3741cea237545c56f506c

Attaching a patch that will apply for 5.15 and 5.16.


Kind regards,
Niklas


>=20
> ------------------ original commit in Linus's tree ------------------
>=20
> From 74583f1b92cb3bbba1a3741cea237545c56f506c Mon Sep 17 00:00:00 2001
> From: Niklas Cassel <niklas.cassel@wdc.com>
> Date: Tue, 1 Mar 2022 00:44:18 +0000
> Subject: [PATCH] riscv: dts: k210: fix broken IRQs on hart1
>=20
> Commit 67d96729a9e7 ("riscv: Update Canaan Kendryte K210 device tree")
> incorrectly removed two entries from the PLIC interrupt-controller node's
> interrupts-extended property.
>=20
> The PLIC driver cannot know the mapping between hart contexts and hart id=
s,
> so this information has to be provided by device tree, as specified by th=
e
> PLIC device tree binding.
>=20
> The PLIC driver uses the interrupts-extended property, and initializes th=
e
> hart context registers in the exact same order as provided by the
> interrupts-extended property.
>=20
> In other words, if we don't specify the S-mode interrupts, the PLIC drive=
r
> will simply initialize the hart0 S-mode hart context with the hart1 M-mod=
e
> configuration. It is therefore essential to specify the S-mode IRQs even
> though the system itself will only ever be running in M-mode.
>=20
> Re-add the S-mode interrupts, so that we get working IRQs on hart1 again.
>=20
> Cc: <stable@vger.kernel.org>
> Fixes: 67d96729a9e7 ("riscv: Update Canaan Kendryte K210 device tree")
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
>=20
> diff --git a/arch/riscv/boot/dts/canaan/k210.dtsi b/arch/riscv/boot/dts/c=
anaan/k210.dtsi
> index 56f57118c633..44d338514761 100644
> --- a/arch/riscv/boot/dts/canaan/k210.dtsi
> +++ b/arch/riscv/boot/dts/canaan/k210.dtsi
> @@ -113,7 +113,8 @@ plic0: interrupt-controller@c000000 {
>  			compatible =3D "canaan,k210-plic", "sifive,plic-1.0.0";
>  			reg =3D <0xC000000 0x4000000>;
>  			interrupt-controller;
> -			interrupts-extended =3D <&cpu0_intc 11>, <&cpu1_intc 11>;
> +			interrupts-extended =3D <&cpu0_intc 11>, <&cpu0_intc 9>,
> +					      <&cpu1_intc 11>, <&cpu1_intc 9>;
>  			riscv,ndev =3D <65>;
>  		};
> =20
>=20

--_002_YiXwp6Yx7bmRaAinx1carbon_
Content-Type: text/plain;
	name="0001-riscv-dts-k210-fix-broken-IRQs-on-hart1.patch"
Content-Description: 0001-riscv-dts-k210-fix-broken-IRQs-on-hart1.patch
Content-Disposition: attachment;
	filename="0001-riscv-dts-k210-fix-broken-IRQs-on-hart1.patch"; size=2108;
	creation-date="Mon, 07 Mar 2022 11:46:48 GMT";
	modification-date="Mon, 07 Mar 2022 11:46:48 GMT"
Content-ID: <D23DC59757AE2D42A761F9F1602F50CA@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64

RnJvbSA3NDU4M2YxYjkyY2IzYmJiYTFhMzc0MWNlYTIzNzU0NWM1NmY1MDZjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogTmlrbGFzIENhc3NlbCA8bmlrbGFzLmNhc3NlbEB3ZGMuY29t
Pg0KRGF0ZTogVHVlLCAxIE1hciAyMDIyIDAwOjQ0OjE4ICswMDAwDQpTdWJqZWN0OiBbUEFUQ0hd
IHJpc2N2OiBkdHM6IGsyMTA6IGZpeCBicm9rZW4gSVJRcyBvbiBoYXJ0MQ0KDQpjb21taXQgNzQ1
ODNmMWI5MmNiM2JiYmExYTM3NDFjZWEyMzc1NDVjNTZmNTA2YyB1cHN0cmVhbS4NCg0KQ29tbWl0
IDY3ZDk2NzI5YTllNyAoInJpc2N2OiBVcGRhdGUgQ2FuYWFuIEtlbmRyeXRlIEsyMTAgZGV2aWNl
IHRyZWUiKQ0KaW5jb3JyZWN0bHkgcmVtb3ZlZCB0d28gZW50cmllcyBmcm9tIHRoZSBQTElDIGlu
dGVycnVwdC1jb250cm9sbGVyIG5vZGUncw0KaW50ZXJydXB0cy1leHRlbmRlZCBwcm9wZXJ0eS4N
Cg0KVGhlIFBMSUMgZHJpdmVyIGNhbm5vdCBrbm93IHRoZSBtYXBwaW5nIGJldHdlZW4gaGFydCBj
b250ZXh0cyBhbmQgaGFydCBpZHMsDQpzbyB0aGlzIGluZm9ybWF0aW9uIGhhcyB0byBiZSBwcm92
aWRlZCBieSBkZXZpY2UgdHJlZSwgYXMgc3BlY2lmaWVkIGJ5IHRoZQ0KUExJQyBkZXZpY2UgdHJl
ZSBiaW5kaW5nLg0KDQpUaGUgUExJQyBkcml2ZXIgdXNlcyB0aGUgaW50ZXJydXB0cy1leHRlbmRl
ZCBwcm9wZXJ0eSwgYW5kIGluaXRpYWxpemVzIHRoZQ0KaGFydCBjb250ZXh0IHJlZ2lzdGVycyBp
biB0aGUgZXhhY3Qgc2FtZSBvcmRlciBhcyBwcm92aWRlZCBieSB0aGUNCmludGVycnVwdHMtZXh0
ZW5kZWQgcHJvcGVydHkuDQoNCkluIG90aGVyIHdvcmRzLCBpZiB3ZSBkb24ndCBzcGVjaWZ5IHRo
ZSBTLW1vZGUgaW50ZXJydXB0cywgdGhlIFBMSUMgZHJpdmVyDQp3aWxsIHNpbXBseSBpbml0aWFs
aXplIHRoZSBoYXJ0MCBTLW1vZGUgaGFydCBjb250ZXh0IHdpdGggdGhlIGhhcnQxIE0tbW9kZQ0K
Y29uZmlndXJhdGlvbi4gSXQgaXMgdGhlcmVmb3JlIGVzc2VudGlhbCB0byBzcGVjaWZ5IHRoZSBT
LW1vZGUgSVJRcyBldmVuDQp0aG91Z2ggdGhlIHN5c3RlbSBpdHNlbGYgd2lsbCBvbmx5IGV2ZXIg
YmUgcnVubmluZyBpbiBNLW1vZGUuDQoNClJlLWFkZCB0aGUgUy1tb2RlIGludGVycnVwdHMsIHNv
IHRoYXQgd2UgZ2V0IHdvcmtpbmcgSVJRcyBvbiBoYXJ0MSBhZ2Fpbi4NCg0KQ2M6IDxzdGFibGVA
dmdlci5rZXJuZWwub3JnPg0KRml4ZXM6IDY3ZDk2NzI5YTllNyAoInJpc2N2OiBVcGRhdGUgQ2Fu
YWFuIEtlbmRyeXRlIEsyMTAgZGV2aWNlIHRyZWUiKQ0KU2lnbmVkLW9mZi1ieTogTmlrbGFzIENh
c3NlbCA8bmlrbGFzLmNhc3NlbEB3ZGMuY29tPg0KU2lnbmVkLW9mZi1ieTogUGFsbWVyIERhYmJl
bHQgPHBhbG1lckByaXZvc2luYy5jb20+DQotLS0NCiBhcmNoL3Jpc2N2L2Jvb3QvZHRzL2NhbmFh
bi9rMjEwLmR0c2kgfCAzICsrLQ0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEg
ZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2FyY2gvcmlzY3YvYm9vdC9kdHMvY2FuYWFuL2sy
MTAuZHRzaSBiL2FyY2gvcmlzY3YvYm9vdC9kdHMvY2FuYWFuL2syMTAuZHRzaQ0KaW5kZXggNTZm
NTcxMThjNjMzLi40NGQzMzg1MTQ3NjEgMTAwNjQ0DQotLS0gYS9hcmNoL3Jpc2N2L2Jvb3QvZHRz
L2NhbmFhbi9rMjEwLmR0c2kNCisrKyBiL2FyY2gvcmlzY3YvYm9vdC9kdHMvY2FuYWFuL2syMTAu
ZHRzaQ0KQEAgLTExMyw3ICsxMTMsOCBAQCBwbGljMDogaW50ZXJydXB0LWNvbnRyb2xsZXJAYzAw
MDAwMCB7DQogCQkJY29tcGF0aWJsZSA9ICJjYW5hYW4sazIxMC1wbGljIiwgInNpZml2ZSxwbGlj
LTEuMC4wIjsNCiAJCQlyZWcgPSA8MHhDMDAwMDAwIDB4NDAwMDAwMD47DQogCQkJaW50ZXJydXB0
LWNvbnRyb2xsZXI7DQotCQkJaW50ZXJydXB0cy1leHRlbmRlZCA9IDwmY3B1MF9pbnRjIDExICZj
cHUxX2ludGMgMTE+Ow0KKwkJCWludGVycnVwdHMtZXh0ZW5kZWQgPSA8JmNwdTBfaW50YyAxMT4s
IDwmY3B1MF9pbnRjIDk+LA0KKwkJCQkJICAgICAgPCZjcHUxX2ludGMgMTE+LCA8JmNwdTFfaW50
YyA5PjsNCiAJCQlyaXNjdixuZGV2ID0gPDY1PjsNCiAJCX07DQogDQotLSANCjIuMzUuMQ0KDQo=

--_002_YiXwp6Yx7bmRaAinx1carbon_--
