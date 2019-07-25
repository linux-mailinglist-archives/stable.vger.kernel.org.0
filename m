Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6B774C6B
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 13:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388173AbfGYLF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 07:05:28 -0400
Received: from mail-eopbgr150104.outbound.protection.outlook.com ([40.107.15.104]:8516
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388070AbfGYLF1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 07:05:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GjZlEYAwkQuOHpggvgLSPz5qkfEifGxUwD1cpHGPbiy5WtdXQs2dxi2KyVqy9fj01/MgF1wL5Yyd5V873UpF+NIjBYRlVGFH5NEXPpf+QXW3efEZpDodyMj/rZYGJKSzfsq2uLaapfZYQPGGGzjEtIlLjRqD032oR2sPVWjETBDEiSb+SVPZTz9SG5ZJ1g8S3P/x+YJRGdzxMu4C7kPzMkPynJJu+iDPiOB7Bv4+QpaELU8egcbcf7lT+p2fmgSxF6FZIyBFvVpkapGn3ZOP9ExAL6Urc4wuFefxxNItP0/3NHqXo+7Xt36WUYNWzzLdwDWO9KQxkZZXVY8hCPwSmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/SiP3mH5gYMkwediWUa1vnzvQioFDVFNGJQWCRQGu4=;
 b=mb7bhGqTNFlFuy+K6w+b0nayMBddVjx2RW+rH77Bs60gg8jxk1OjtZcRCFT5d2oQCeOz9KAXADJksVLNtFrtG7ulUR1SvfAinMITRtVArqhR4TLQWlEiarFus7NpAaZCr+rfkLgbuorKAKX/4NMi8NH70N/IAwaPLHMuxW5oMzwFaf7fUsBlYKhs+3F192cVgqjnTcZGMw1nqqoY+RWDU/PmBh6NnIekWM/IoPt+35pTACJNBCvF/m0uFDFYZp11nrRgO0axHw+OPgTUHaoiDJKIXLnSxFgEuBq/ATX3+lfocn/C6AulXI350g8d8suRWAlk9g42qDbVdQMFapUKAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=toradex.com;dmarc=pass action=none
 header.from=toradex.com;dkim=pass header.d=toradex.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/SiP3mH5gYMkwediWUa1vnzvQioFDVFNGJQWCRQGu4=;
 b=j/5k05zxNqWcoTXoJr/KHlpKxXTBxFiYGQVtNx3vldqxBV1FrDj58WtcRQ/UUnIOpN8pOa5+PcjQL4d7EJAjVDWL0/aiSYvIqRgMIAmzo6X5GN46Bhe3PQxeh0ljJ1N4XygKD8mNysDy/TpXPb8y130iPMhDhDtyh3ZKpdkUVOQ=
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com (20.179.18.16) by
 AM6PR05MB5553.eurprd05.prod.outlook.com (20.177.119.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Thu, 25 Jul 2019 11:05:23 +0000
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c860:b386:22a:8ec9]) by AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c860:b386:22a:8ec9%6]) with mapi id 15.20.2094.017; Thu, 25 Jul 2019
 11:05:23 +0000
From:   Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
To:     Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        David Airlie <airlied@linux.ie>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: [PATCH 0/1] This patch fixes connection detection for monitors w/o
 DDC.
Thread-Topic: [PATCH 0/1] This patch fixes connection detection for monitors
 w/o DDC.
Thread-Index: AQHVQtjbQmQDpUU8tU2AbrHFyIUWgw==
Date:   Thu, 25 Jul 2019 11:05:23 +0000
Message-ID: <20190725110520.26848-1-oleksandr.suvorov@toradex.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM3PR07CA0136.eurprd07.prod.outlook.com
 (2603:10a6:207:8::22) To AM6PR05MB6535.eurprd05.prod.outlook.com
 (2603:10a6:20b:71::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=oleksandr.suvorov@toradex.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [194.105.145.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7cf54cad-5795-4259-90bb-08d710effd82
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR05MB5553;
x-ms-traffictypediagnostic: AM6PR05MB5553:
x-microsoft-antispam-prvs: <AM6PR05MB55532DB02B97E0C07D0105BCF9C10@AM6PR05MB5553.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(346002)(376002)(366004)(39850400004)(136003)(199004)(189003)(4326008)(44832011)(3846002)(305945005)(14444005)(14454004)(486006)(68736007)(1076003)(256004)(66066001)(5660300002)(6486002)(66446008)(64756008)(66556008)(66476007)(186003)(7416002)(54906003)(50226002)(110136005)(25786009)(26005)(478600001)(316002)(86362001)(6436002)(66946007)(52116002)(99286004)(36756003)(6506007)(386003)(53936002)(2906002)(6116002)(71190400001)(81166006)(81156014)(7736002)(102836004)(476003)(6512007)(8936002)(8676002)(2616005)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR05MB5553;H:AM6PR05MB6535.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: toradex.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pCCpK+e3AKs/jz6rRBxi2F+7SZLcaM6kTIKhtrik+KfrdPfi/AUOKurLLiTAI0ce4FXcG6LUeEzl72Hy9mCuCwn84g5o8ScJ3dm8mA18kmpjWrWhKq3wq227Jn3rI2bbGgVCzdE8vBYyUcFnpA2huDd7SCSA2H7BcbkL3R6Eil2sAPo/Ap1jjn+yjXGAaebMNyEVS7IZxhvsUWIrjQ4wRm2p6zmtijIrUBqFsNX0tiJieR/3m6UwQIdpKYpxJPw9DeR7BjMlTcsJNN3AHgw4pwT7yyoNRxwQ2r6zOZGhcEkXMIouPmzYf2j0pYQFBqFhBwPIQnreLbEwaQ4o5UVd2D3TyWKwDUyZdaNEtlR0EuXWeGNvGjmeh3FEPYkGpQQOK3coIysGJPZ0Go85mumpVkEFA3hQo82aaihlAHbBESU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cf54cad-5795-4259-90bb-08d710effd82
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 11:05:23.4274
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oleksandr.suvorov@toradex.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5553
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Even in source code of this driver there is an author's description:
    /*
     * Even if we have an I2C bus, we can't assume that the cable
     * is disconnected if drm_probe_ddc fails. Some cables don't
     * wire the DDC pins, or the I2C bus might not be working at
     * all.
     */

That's true. DDC and VGA channels are independent, and therefore
we cannot decide whether the monitor is connected or not,
depending on the information from the DDC.

So the monitor should always be considered connected.
Thus there is no reason to use connector detect callback for this
driver: DRM sub-system considers monitor always connected if there
is no detect() callback registered with drm_connector_init().

How to reproduce the bug:
* setup: i.MX8QXP, LCDIF video module + gpu/drm/mxsfb driver,
  adv712x VGA DAC + dumb-vga-dac driver, VGA-connector w/o DDC;
* try to use drivers chain mxsfb-drm + dumb-vga-dac;
* any DRM applications consider the monitor is not connected:
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  $ weston-start
  $ cat /var/log/weston.log
      ...
      DRM: head 'VGA-1' found, connector 32 is disconnected.
      ...
  $ cat /sys/devices/platform/5a180000.lcdif/drm/card0/card0-VGA-1/status
  unknown
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


Oleksandr Suvorov (1):
  drm/bridge: vga-dac: Fix detect of monitor connection

 drivers/gpu/drm/bridge/dumb-vga-dac.c | 18 ------------------
 1 file changed, 18 deletions(-)

--=20
2.20.1

