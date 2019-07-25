Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51C0C74C6D
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 13:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391518AbfGYLFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 07:05:31 -0400
Received: from mail-eopbgr20121.outbound.protection.outlook.com ([40.107.2.121]:59302
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388070AbfGYLFb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 07:05:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NgMcx9JgKAwmTEHB3YX+6ZE/9mTtvzSzRZcntsWDjENKAsGjAlnmX2u6W75DWIaZYPxnTYfHrxc3mf/AxdJWd3Rp1zZdtS/MjsC9DNOvL13luZvB6R861f2ESRjjwAv4M2NAr8htkIGziVKXkLud5G4zck6uKZaqtstJU0+T5F+wuoDkGbnJcp8o2L4IbHYi/j9Ov8pH00lAY8DceZH3on+O2ZMETbc8ytBIzJHzYDC5mGa3LrHxVAY1g3GrFBwL/thbXX8nEIMDQjAadb6pQCScfsvup5CM717ydoHqi3K8XvFRYuUXPWggZFENzhJeiOsX+10UlPS30LmJ6/2Khg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRcXUpf4uIYFEL9fgZ8SDY54LsOYeAmHh5gNyiFNMvA=;
 b=IX6djHgbkaRzkd05vdyTTibmU8ba2C0rpg14KuS0r/jVDripxogc+iKszoXuTLp43lAakv9qcZ37tpSrN0hacqu/yXtTxY9G5SQ2zVa6qmw89kGCDuXOD8p1gqd7mu83VcoVbPRnw7uw7xvl+ND/yLGvnWSljB6iuHkzPLuvoX3UbA6coebTnqxxSxppFZGoyljv9OdALsNLx9mCvJ9wrMTAlJkiYKWoK7lpJExJenv0hj7autofwvJxu6rZUqgAGGW+vCphq7hUrEdrjLqAv2iMaafoAj7aNlPBw7ahnA0c4HxvWppJqly46aYlBqhMkwFxelS6JXt6z4RDaazk6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=toradex.com;dmarc=pass action=none
 header.from=toradex.com;dkim=pass header.d=toradex.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRcXUpf4uIYFEL9fgZ8SDY54LsOYeAmHh5gNyiFNMvA=;
 b=eK+t2Z8rHysT+V043gYsS5vwQSWPDOgs7BW26yD/g5+T/TXnt+AaaFHFwqsVDQ1CvWKqJYYptlIz9UEpQEoOHiHLmD3ZttbTMkKBqe5zHlDtbRw+qloospQrGMH6Uuwb7LzKgAywchmFNYkqAkw2We4tD4t3sf8wXu0kWsHT6Ts=
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com (20.179.18.16) by
 AM6PR05MB6406.eurprd05.prod.outlook.com (20.179.6.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Thu, 25 Jul 2019 11:05:25 +0000
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c860:b386:22a:8ec9]) by AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c860:b386:22a:8ec9%6]) with mapi id 15.20.2094.017; Thu, 25 Jul 2019
 11:05:25 +0000
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
Subject: [PATCH 1/1] drm/bridge: vga-dac: Fix detect of monitor connection
Thread-Topic: [PATCH 1/1] drm/bridge: vga-dac: Fix detect of monitor
 connection
Thread-Index: AQHVQtjc9EMAkuteLkuZ4bDgcKxYhw==
Date:   Thu, 25 Jul 2019 11:05:24 +0000
Message-ID: <20190725110520.26848-2-oleksandr.suvorov@toradex.com>
References: <20190725110520.26848-1-oleksandr.suvorov@toradex.com>
In-Reply-To: <20190725110520.26848-1-oleksandr.suvorov@toradex.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR0102CA0065.eurprd01.prod.exchangelabs.com
 (2603:10a6:208::42) To AM6PR05MB6535.eurprd05.prod.outlook.com
 (2603:10a6:20b:71::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=oleksandr.suvorov@toradex.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [194.105.145.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c189facf-cd15-4efd-ab54-08d710effe73
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR05MB6406;
x-ms-traffictypediagnostic: AM6PR05MB6406:
x-microsoft-antispam-prvs: <AM6PR05MB640639F565F8E4514DBB8F00F9C10@AM6PR05MB6406.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:510;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(199004)(189003)(81166006)(6512007)(66066001)(25786009)(71190400001)(2906002)(7736002)(305945005)(14444005)(4326008)(7416002)(498600001)(52116002)(99286004)(71200400001)(256004)(66446008)(64756008)(76176011)(14454004)(44832011)(6486002)(66946007)(68736007)(6436002)(2616005)(50226002)(476003)(186003)(446003)(386003)(102836004)(5660300002)(8676002)(6506007)(26005)(54906003)(3846002)(53936002)(81156014)(6116002)(8936002)(110136005)(1076003)(86362001)(36756003)(66476007)(66556008)(11346002)(486006);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR05MB6406;H:AM6PR05MB6535.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: toradex.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9sx3bRzoIwHGRTYe9Mut9UdPVq3Pprnz13VlerohJShlidAhougJ7JtWFM15JSX66/9FUGwVWlgoEzY0MYslyPF8mVaZx+w1kz+ojk7Qwnsxuvqv8ibhHVHnjvBLTgwFOBy5AZBkD6MAfw8fTpyUOHLjgxnbRJlCZihX6Xk7T1NYM2op5OgijWRY8GmilP7BK2Q0svs9YH9DmCa/shTF+9pDmOdLYlRhL35GK6N/tcoveahpUuJsdBWOPQpSREKIEaNKfQF8k50SjlsBpKEDDAPU0ePFKn1DpdjmatdzbrqAbI760HfjiuSovQiDzeCN1tdq8www6B178dhcL+XjilUZChUkUKv2m0yINBV+M1EY4miXh5rwIJkcyh2cfokkO089Hre0kGefwSz8pLN44K0vxkksKh5G0yxy0fWISv4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c189facf-cd15-4efd-ab54-08d710effe73
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 11:05:24.9995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oleksandr.suvorov@toradex.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6406
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DDC and VGA channels are independent, and therefore
we cannot decide whether the monitor is connected or not,
depending on the information from the DDC.

So the monitor should always be considered connected.
Thus there is no reason to use connector detect callback for this
driver.

Fixes DRM error of dumb monitor detection like:
...
DRM: head 'VGA-1' found, connector 32 is disconnected.
...

Cc: stable@vger.kernel.org
Fixes: 56fe8b6f4991 ("drm/bridge: Add RGB to VGA bridge support")
Signed-off-by: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
---

 drivers/gpu/drm/bridge/dumb-vga-dac.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/gpu/drm/bridge/dumb-vga-dac.c b/drivers/gpu/drm/bridge=
/dumb-vga-dac.c
index d32885b906ae..e37c19356d12 100644
--- a/drivers/gpu/drm/bridge/dumb-vga-dac.c
+++ b/drivers/gpu/drm/bridge/dumb-vga-dac.c
@@ -73,25 +73,7 @@ static const struct drm_connector_helper_funcs dumb_vga_=
con_helper_funcs =3D {
 	.get_modes	=3D dumb_vga_get_modes,
 };
=20
-static enum drm_connector_status
-dumb_vga_connector_detect(struct drm_connector *connector, bool force)
-{
-	struct dumb_vga *vga =3D drm_connector_to_dumb_vga(connector);
-
-	/*
-	 * Even if we have an I2C bus, we can't assume that the cable
-	 * is disconnected if drm_probe_ddc fails. Some cables don't
-	 * wire the DDC pins, or the I2C bus might not be working at
-	 * all.
-	 */
-	if (!IS_ERR(vga->ddc) && drm_probe_ddc(vga->ddc))
-		return connector_status_connected;
-
-	return connector_status_unknown;
-}
-
 static const struct drm_connector_funcs dumb_vga_con_funcs =3D {
-	.detect			=3D dumb_vga_connector_detect,
 	.fill_modes		=3D drm_helper_probe_single_connector_modes,
 	.destroy		=3D drm_connector_cleanup,
 	.reset			=3D drm_atomic_helper_connector_reset,
--=20
2.20.1

