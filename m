Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48581A91B3
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 06:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgDOEBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 00:01:00 -0400
Received: from mail-eopbgr50052.outbound.protection.outlook.com ([40.107.5.52]:44096
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725294AbgDOEA6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 00:00:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=diQvblsI4sOS5LckU9uonWCqY8MD8Wm3MdLOtOANv36f/lyh5bKCfiIPFgEcQB7nAGql9K27YfJ+IFvCgwJmr7IbV9sCwb8cJCiFWCeyx48DDXEp7/EAak9VQ8mvKtJ1emCuiHcQyYLJwcc/8mWE9nIFGigrYbe4/YgbSAESzUW1D3Wm9C4MI7Rrwb3EX6WE4hn3Yn8BVCCnLtPLMf0xTFnq19XCPAq8ETBgrlTsF+BibdIHq7f4duse9Ysp0LvX7t+UrZ/GpeVtWxaHkaetY+SCoxqDbi0FM6x4SWyLp/7ONB4IeOzkbVjx+P9n35pHAtc9mxCn13Syzi91N/bWjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OuLlHx6GkWrJSxFF+AUk/uVGgZvxf/3w0C/cajZvj+I=;
 b=DhnuEW5z8zcVSQclaFNzLo+Gv5TKkEIXHsOzFGcQGo7Y7OrqpUeH1zVbz5OPDOa8i3GC2fy9SKCZzjZ90OSNghSGV3zlcPWVMz13lehBf8Aj3EmGF74PrmZIoNWrzhyihuWD1bnFBuIr10lzpHf0Gne/op3N8BTjTTyH3+6pH09THhlikVeLzJS8Dtsp4E0xI4lqzhjtMxYTL7WsIt0qyXtzT/Rx9qkA1GcxjQ3wXyj0I++kWxypPuAzWFyZHrGSEjHFB3+ByFC9IIB+1j0uIoIsy5v+F1TsAk8dH9C0uTtkTkXwI4AEK+VG66XMOqt0AcIZGmzJ/x3eBwk7qUBJyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OuLlHx6GkWrJSxFF+AUk/uVGgZvxf/3w0C/cajZvj+I=;
 b=EqIEfWdPf+lbRIHtathw/cthuOh8eSKmJGW+naFRaurBDHEJ/CS/mWF2FogHz+57K73PuSbR8nEUKvvkICw2D36xp3QzHGFsNi6cjre7jev/XRoMpuVZqbG4nLxvNzVmcZoY1TeKdH9jwCQ1/XV/oU3nWpSXIh48nfYVJbcf/is=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
 by AM7PR04MB6936.eurprd04.prod.outlook.com (2603:10a6:20b:106::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.24; Wed, 15 Apr
 2020 04:00:55 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::fdc0:9eff:2931:d11b]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::fdc0:9eff:2931:d11b%5]) with mapi id 15.20.2900.028; Wed, 15 Apr 2020
 04:00:55 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Daniel Walker <danielwa@cisco.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: RE: [v5.4] Fix up eSDHC issue on P2020
Thread-Topic: [v5.4] Fix up eSDHC issue on P2020
Thread-Index: AQHWEtnBO74JUS7/6Um0BC852gwW5Kh5joJA
Date:   Wed, 15 Apr 2020 04:00:55 +0000
Message-ID: <AM7PR04MB68858D5EED468C6233BB06EAF8DB0@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200415035146.19086-1-yangbo.lu@nxp.com>
In-Reply-To: <20200415035146.19086-1-yangbo.lu@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.68.129]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a849e6b5-033e-4825-beda-08d7e0f19908
x-ms-traffictypediagnostic: AM7PR04MB6936:
x-microsoft-antispam-prvs: <AM7PR04MB693648B87FC89FCC5BA9170CF8DB0@AM7PR04MB6936.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0374433C81
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(396003)(366004)(346002)(376002)(39860400002)(186003)(52536014)(8936002)(26005)(33656002)(2906002)(5660300002)(64756008)(81156014)(54906003)(7696005)(53546011)(4326008)(316002)(8676002)(6506007)(478600001)(71200400001)(6916009)(966005)(86362001)(66446008)(9686003)(66556008)(66946007)(76116006)(66476007)(55016002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q2cjh3poV7kwx9BzBT+LQuoxQJBlUdCSs7mhDDbp7Jj/dF1wzV1oyQE+2Q/gX8k7zjr9KQdfYEDkan7P10uziBYcF85y4HL10mZSZio+40XM2P81B4QKPnYNGTBe3brELDIIQIoCXsl3FsKju58Q6BWCNvZqLKVRozrR4eDtEvfW1Ep9LyJyrYalzwuvT3Kjy7xhJOqp2Pign1asJZIM+4WdihA55wViMRLaeWmu86HKqB7mBKbtBrlKNHdPbcJwEV8M5G11djGYYV2yUABtwmSytO7kgfrvIsuc0m4+HoxlLsE/46zKbBzqnRA34R5CPxpnsgV4qIM3vHMb01Kv4vQV7MkIYtbXI87uOzTuOSF4a9/sRwzpEkOz0B3OkkiKKUH8inJsztKQNLW1eBLqY1yLux/iSk0FG8Wz6SGBL9/IIOk52bOn1wnG0iy9a090gW5PDalkuiNhfBCY3AkrB5pZM9BoOR0I8qR7gSbiIu9piZ3aeq2CoJ6o0e1rDB/ELYOStlVIhQZtFXUzPTzETA==
x-ms-exchange-antispam-messagedata: 07bL/nWZiIUWujpnyAa1pZ93BtxMEBITDcOzgrToun9YbyZT93C+dPPUCsPaUx62ngffbVXTxMnaNtqGfRvLiNR2K9Uxo5C7fy0f0RNp+mhkxfOHreCjJRzW4gEJzVMt/DjWNxy+VsDtPqaFuFz7eA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a849e6b5-033e-4825-beda-08d7e0f19908
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2020 04:00:55.4466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q6+7tMEyMUpnLcxqhg9jD7suKTUwIp+HgWz1wTl+kSw0+/GCw7e7ycVYFv11zNTsaItmqGgbCfhZ56PyEftW9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6936
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> -----Original Message-----
> From: Yangbo Lu <yangbo.lu@nxp.com>
> Sent: Wednesday, April 15, 2020 11:52 AM
> To: stable@vger.kernel.org
> Cc: Y.b. Lu <yangbo.lu@nxp.com>; Greg Kroah-Hartman
> <gregkh@linuxfoundation.org>; Sasha Levin <sashal@kernel.org>; Daniel
> Walker <danielwa@cisco.com>; Ulf Hansson <ulf.hansson@linaro.org>
> Subject: [v5.4] Fix up eSDHC issue on P2020
>=20
> The upstream commit broke P2020 eSDHC.
> fe0acab mmc: sdhci-of-esdhc: fix P2020 errata handling
>=20
> While the issue was fixed by later commit.
> 2aa3d82 mmc: sdhci-of-esdhc: fix esdhc_reset() for different controller
> versions
>=20
> The commit fe0acab had been applied to stable kernel 5.5, 5.4,
> 4.19, 4.14, 4.9, and 4.4 without that fix-up.
>=20
> To fix up P2020 eSDHC on the stable kernels, backport the fix-up 2aa3d82
> kernel 5.4 and 5.5.
>=20
> Please help to revert fe0acab on 4.19, 4.14, 4.9 and 4.4, since there are
> many conflicts to cherry-pick the fix-up, and fe0acab is actually not str=
ongly
> required for handling errata which is hardly triggered.
>=20
> The email thread for the issue discussion.
> https://www.spinics.net/lists/stable/msg375823.html
>=20
> Yangbo Lu (4):
>   mmc: sdhci-of-esdhc: fix esdhc_reset() for different controller
>     versions
>   mmc: sdhci-of-esdhc: fix clock setting for different controller
>     versions
>   mmc: sdhci-of-esdhc: fix transfer mode register reading
>   mmc: sdhci-of-esdhc: fix serious issue clock is always disabled
>=20
>  drivers/mmc/host/sdhci-of-esdhc.c | 174
> +++++++++++++++++++++++++-------------
>  1 file changed, 114 insertions(+), 60 deletions(-)
>=20

Sorry, please ignore the wrong patch list and changes here in cover letter.
It is to backport only fix-up 2aa3d82.

> --
> 2.7.4

