Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E627C274DE1
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 02:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgIWAey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 20:34:54 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:20819 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgIWAex (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 20:34:53 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Sep 2020 20:34:52 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1600821292; x=1632357292;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=F4CZK/JuOSq9IWHN8+/h7kv/igPrBlwEmNb6BSXPVm8=;
  b=kFkxuy/LMcLw/T3lfjlg1iq01WF1HPtM2bX9kc97BUpGTb4CDV9eyMrQ
   ngGAKJ/7EIeAL8R17RC/xMLL3/WibywdxsYaKoz5vQ35jkN7f4cO773pC
   2G3jv484mG7eXa5GVsTLjqL/20cS3o+/Ewvb3yS5dnX+d1B6BJNqsxpAg
   bUaNlQKDK/X4wbBfGQ1t1OMnJPaswSMO0s784tRcxN8x+PrdBDqzD6MQV
   QOKDpk76Q7sdex0pSzArDXkTCcCk8M2g6YBRi8+tMyhdPJRZF0XZxik4o
   46cfisYknCJZc06KGxlGFZc0fxNTE1/a9oWaBZtfJtgiapk8CfunYv/mK
   g==;
IronPort-SDR: pi0alN4S+u2c4lzqRoOSEevoVYcQ2eltmlI7eUp2haEPTJhObtcVeTNcuojzz9cS1MTUWUkdDp
 yh3eEXJXgWupcIzod3xsB0AXksUYexh317dOHj27vVoepFnH+pBqNJtIRlbeo7gGyUrkk0b8In
 W3C3qk5mTFMVx02gE8epLRqjTsTuaSZwt//EgimesmanbAqRTYSAYOLBJ/gV685aGwDokRFaO9
 Frj6SobiI+uNdtMMw2XhfAzOrqL1zzWt/zdFSmYotncK2HR9m3u5hPIIlFiMtyk0nX1VVfivu1
 kLk=
X-IronPort-AV: E=Sophos;i="5.77,292,1596470400"; 
   d="scan'208";a="152405983"
Received: from mail-bn8nam12lp2169.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.169])
  by ob1.hgst.iphmx.com with ESMTP; 23 Sep 2020 08:27:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DzHhkM12F3ml2mOVCsXf1Pm9RxSdWFmumw0JQGsZ9MTdGoFj0MUXgbLBYokFK998cq5omzH9qlVYCJ+zSTats9HHL45e87/r9ALJ7wYfboSYDjaRKMCpgSlO/w9gDRXELQNn/d9VJRHNUMjHJ6vwgtJ22dE8zDlDq6Kf5tgzrcP7SHLAWTv4YFnc6NKz/9XSfcmxLOgd7M6z+61ekoZVLRpM0M9WFnDhJJgOhTTbr5Ws5/dYd+zwwL1v9nklOamwV1GrknqwyQ7/NCxs/b8aZE1RbFbG+8ttfjEnGugmOvdUivCmGzz5rP/Y8hVMxFlX8TbWbjbuiL8pNxEZa7cSTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/UhHn0L3JF0bFKT1wRUHHPOe89fnDUItWqnpJUMKe0=;
 b=jf5t1AS+Oy5kKHD0XsJ9UNnHK16M53R3PT5AGfO7/1ZtEuQzuisS16FNaf+orZikwyUbPwqIBuKrGXAtwnz4qOAFGuC8nKFPa2UtFG6wu5E3k7NTDZ2kdHJVFHDcX7LGwHY3uRb09WHAec4dLVy/9eK6eoft1FZQEy6zWnYRQcKJez9xBwyK0RIXodc10rJQwYK59ELJt1PqyxVLRxRrOZjfGI4rNPFRgRuS0eNchq/M1dh70yARNGA4T1n78AEHWyYFB+djGUdVMVfg3DF3t3cOiGO9VCnbXp7M8mQEq/tTVGlzGEVgV0VAADFMICBptstSIo1WfiYofRLRMTcavA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/UhHn0L3JF0bFKT1wRUHHPOe89fnDUItWqnpJUMKe0=;
 b=OfF/ZP8SBDJpIdgHcrpVXCSlte6yIxdjOHsoAHrhvSJfbg0PQC25vLUuDO4PJv+icYbIUO9a8ocjr1JvkpzJ3X4b1GCOZNj7ZjPzPQqtMtQv9efbxkwacLG4Ty0HWkM8vodBmDnYcPjZVnOdb45HwNLZqrnc2huhggcJtdaLElo=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0968.namprd04.prod.outlook.com (2603:10b6:910:51::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Wed, 23 Sep
 2020 00:27:43 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7%12]) with mapi id 15.20.3391.024; Wed, 23 Sep 2020
 00:27:42 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Palmer Dabbelt <palmerdabbelt@google.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH AUTOSEL 5.8 20/20] riscv: Fix Kendryte K210 device tree
Thread-Topic: [PATCH AUTOSEL 5.8 20/20] riscv: Fix Kendryte K210 device tree
Thread-Index: AQHWkCU53Yt83wGZ7keUFBY/2Egj+g==
Date:   Wed, 23 Sep 2020 00:27:42 +0000
Message-ID: <CY4PR04MB3751BE40C3EC0BD2F392E9EEE7380@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200921144027.2135390-1-sashal@kernel.org>
 <20200921144027.2135390-20-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:dc1c:cac6:da47:3b6b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 16895b07-74c7-49cf-dc1a-08d85f577c8b
x-ms-traffictypediagnostic: CY4PR04MB0968:
x-microsoft-antispam-prvs: <CY4PR04MB09684CDCB73D40D098B39EDCE7380@CY4PR04MB0968.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:644;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VrVsM8C9eoXaahcQCUDzYo+cksumtuWEmFC5bOklNZX1J/gYUeGCBQczlbzaG2GGV/WwqWhAXPjaAEkzIJkneHJrLKsZpCcg7srYiu5Clr5jHoRG2fmuk1p2eVIB+Rx3pFmMYNVJF2ibbbRdGBAdkTQ4ZsjSYfx/KtfoE12XbmwowVJFIjzkrHFu0s9RoGQEAwjJMzTSaELvkkGaegh3DMt3HIL2/VJ0viUjHbjSU9oqnA7ACHpBsmpJMuHT2SpoqNX6rI42Nkh2RCp2PvTtwkk0BvRrzEtsDI+8Slf8XGVA08KPvZLvaPKkoHGFzPyxV46GubY2uz24Y6NmwjWouGAgIAIsEpx8pXHitE8pXso3DkhTslCbIcvrOEIhxFQB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(76116006)(66556008)(66446008)(9686003)(66946007)(64756008)(2906002)(52536014)(5660300002)(55016002)(33656002)(53546011)(86362001)(478600001)(91956017)(66476007)(8936002)(7696005)(83380400001)(6506007)(4326008)(110136005)(54906003)(316002)(8676002)(186003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: QfKBrDPUKPFASs1Yi9neGRTgMxBXHCF2hR0Ba2xrWHEMSV0kAsqpzCNyaGl/40oP2+WsBZsPodPSFw/QGg4uCnm7lT8kyvsRriQmtQMTeK4arLiAZwPZDJqI+LWJyELZ/91PL4YCBsKqhD8kaY7eRTXlUi0n0LIz5zJjCErQJE6Fk/Z7jHzEM8S8oYbioE3aZvJQK5JmA4+PmbIoGEBiO84mhVyLUPlh7XKHRy+R5ITPXYCuQsccw79/w/3RBu1T5R4ghuAd85iF9uA+mMeFS1AHTWC5KIZomA4LnGwLtumtqfy+kZkTA3wie0s1seQJmiHALZMvF5CHRH+jSvzEvOidkFxGGI7dpbv2jqDMeYHomJ9lyvXGD2Q9SPuV+ol5M/bhPwZKdwhyDJa8ZdvdsCkB5I4kRGsaTbKFoSxIVqT4WBlF3e5Uovoq2voMwtzWOZeqtFnMj8WzrhHNHOh7B5LCi1LwUOD3SSkcSWnBBGiQDnyupeKZi3vQvkLFJHLXhMFn+Sw9/ZE0M5C9e6jlWqW4intGw9uFk2r/wy/Xi/lxvP6d6tXnjrXPgknsgIRMi8wikyPB/V8tq/AQsiMfaAI07l7dEmYTAQYucyp0Xa2xGSi6GTANHzm9EyxQjVDtZh2Xr8Uo/gWHpXBuObKwiFrriP/ZkYHTdzdd67eGy6PtqXFwkf0D8VvMsA3FoOwuVNf9D9gfq9PmFCRVWxVgzQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16895b07-74c7-49cf-dc1a-08d85f577c8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 00:27:42.6230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2wDChNX9KNFM0OWBSh35Ua8GXznxxyW6IRsgTOL7MRStf8ZQ/g6IyU/+1KUEJt3tjXjcSQ1Zuj1fPEo2ysb+Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0968
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/09/21 23:41, Sasha Levin wrote:=0A=
> From: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> =0A=
> [ Upstream commit f025d9d9934b84cd03b7796072d10686029c408e ]=0A=
> =0A=
> The Kendryte K210 SoC CLINT is compatible with Sifive clint v0=0A=
> (sifive,clint0). Fix the Kendryte K210 device tree clint entry to be=0A=
> inline with the sifive timer definition documented in=0A=
> Documentation/devicetree/bindings/timer/sifive,clint.yaml.=0A=
> The device tree clint entry is renamed similarly to u-boot device tree=0A=
> definition to improve compatibility with u-boot defined device tree.=0A=
> To ensure correct initialization, the interrup-cells attribute is added=
=0A=
> and the interrupt-extended attribute definition fixed.=0A=
> =0A=
> This fixes boot failures with Kendryte K210 SoC boards.=0A=
> =0A=
> Note that the clock referenced is kept as K210_CLK_ACLK, which does not=
=0A=
> necessarilly match the clint MTIME increment rate. This however does not=
=0A=
> seem to cause any problem for now.=0A=
> =0A=
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>=0A=
> Signed-off-by: Sasha Levin <sashal@kernel.org>=0A=
> ---=0A=
>  arch/riscv/boot/dts/kendryte/k210.dtsi | 6 ++++--=0A=
>  1 file changed, 4 insertions(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/arch/riscv/boot/dts/kendryte/k210.dtsi b/arch/riscv/boot/dts=
/kendryte/k210.dtsi=0A=
> index c1df56ccb8d55..d2d0ff6456325 100644=0A=
> --- a/arch/riscv/boot/dts/kendryte/k210.dtsi=0A=
> +++ b/arch/riscv/boot/dts/kendryte/k210.dtsi=0A=
> @@ -95,10 +95,12 @@ sysctl: sysctl@50440000 {=0A=
>  			#clock-cells =3D <1>;=0A=
>  		};=0A=
>  =0A=
> -		clint0: interrupt-controller@2000000 {=0A=
> +		clint0: clint@2000000 {=0A=
> +			#interrupt-cells =3D <1>;=0A=
>  			compatible =3D "riscv,clint0";=0A=
>  			reg =3D <0x2000000 0xC000>;=0A=
> -			interrupts-extended =3D <&cpu0_intc 3>,  <&cpu1_intc 3>;=0A=
> +			interrupts-extended =3D  <&cpu0_intc 3 &cpu0_intc 7=0A=
> +						&cpu1_intc 3 &cpu1_intc 7>;=0A=
>  			clocks =3D <&sysctl K210_CLK_ACLK>;=0A=
>  		};=0A=
>  =0A=
> =0A=
=0A=
Sasha,=0A=
=0A=
This is a fix for a problem in 5.9 tree. 5.8 kernel is fine without this pa=
tch.=0A=
And I think applying it to 5.8 might actually break things since the proper=
=0A=
clint driver was added to kernel 5.9 and does not exist in 5.8.=0A=
=0A=
Best regards.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
