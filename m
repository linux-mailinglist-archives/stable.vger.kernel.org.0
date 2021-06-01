Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B14396F19
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 10:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbhFAIlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 04:41:12 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:23924 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbhFAIlL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 04:41:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1622536769; x=1654072769;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=g8DOLjJsGvggNAXe88Wq/Zkih2F0lulpgW/ocCC60y8=;
  b=ZSNV63VBsTifWBXOtuQAtuef3HNnXwmRYIGpAivj1XeDGag1MDA3gEOw
   1GeJgs1bnBJmZ/ebVYvPlvtIqO8P1ycsSWc4MQaHBQvriXde1TVVho7LL
   1fOJ9egDr36QRtUwaR5RMuP15+/MLHRseV629bwSoNPvfY2sP5MjgDcxB
   5kkOITBN7KPm9s8rCJSz5VQZNP8TjlLhS9iEGmEMkkvnb6plt52WXos/G
   iYj3JN2+iiZ6CkmnoOHhLodGsHeRzQCgLjtm/qSRcqKzZff3Exkshphj3
   xSES5SCaQ+nfeCEwl+3dvmcg8N2AlwOCSlQl/K5ZR4D63V+8HhIAQQbnX
   w==;
IronPort-SDR: ldjpW0tAoS6f3szGLnVqrAkkgK1CpVwffkCZcK52jkSi8qr17aBEp9VswHG0OIDNkE5J3AVU39
 fpBqgU1bxkR92XEDo7SR9tWTAIdm5zqXIfIwdJHsv2BabY9fgJMrtlkJdJfUTJ4ADjPcx1GOi7
 ilRixybwTNZuXXEgdyk2arI2Fw6sZ94XbKF+khKUGcCA/4K9Cqq1ikosz4vPTMLWn43K/w9aJw
 OxAummh1LLUeZQlZB5/e5C9OWYkbDedqVaR1p6g0g+YL0XST7npeJSItCoDUXLAJ9hWAnl35Yk
 0tU=
X-IronPort-AV: E=Sophos;i="5.83,239,1616428800"; 
   d="scan'208";a="170253883"
Received: from mail-mw2nam08lp2176.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.176])
  by ob1.hgst.iphmx.com with ESMTP; 01 Jun 2021 16:39:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tl0m5UHhUtZmvvn+9sTlgcRP26Xe6AC+TVnfXkRFG3prztdRHP+nbOQiRC2A/vMRvyGpk4Irj4m8qB35pmVOKXIbpvLA1Yk4kNQhKmXYQlmhTkbe8Dg2D9DyIl14QE4Dl2TGwwKlJCA+uhN+ZAlgOpjX5/h+MHrb+2VlX3dHmHbZae0tSRgeEeDGPZ7sAfuaZpxdrhVE6medyUR5HDCp3vdXncXse3FfeH01lyFANiEzNgKmnKnBJ4LVGkNpdLsfZmZCDZVu/kbZOiSYNyowo9g1cqy4TNnhNslwftHCoBylVqoRRYV+uNaktCx+nBKVJENuS68fuvRVziYpYPgd8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U8B7uvb3iWhUns9LtiFlTeHbenNK/Rt3GDDkNTgoJeA=;
 b=ZjkGdMpskO7LYuBqC0UysHAB/18D1QPzkZrvfH+ANr4ImUgVl71ofW2jPyhX63qh0d10e1IfeVUBl9hGbYuTbld9SJuPDufdLeMMt2GUjqSxPFZ4Z3XWTfybVL02tIU/26TL7Z/JRt5/X22Kqe8KSw//eC9kAp9IJ6GpwPpTGZAvMx8KpZQfT7aYdgYyvoSELXsdbSeOYwgxnlxK/hGCZ74RHV+Az1zpboJxEU5USfV5NvmsB+lMTqVXqw/zSwDXZZb4y/hqqshzf6cY/053ULQkLsW1sjyHpTxrXj+ibwsnD5KcnTMPiYqHMvDSROmhuTqq1AHIjjPXtpA54xq9gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U8B7uvb3iWhUns9LtiFlTeHbenNK/Rt3GDDkNTgoJeA=;
 b=zrZtb9U+PAh1d6GfGE1kkd9uoUCN8RjuPbaFuTHKJ03uCi5lHKpi3wc3S8WlOFvKiSnMHATBtrqlyuI+erkWs/scsA59ohtFQnOZ8hssFS9t7eqXLN4Ay7gcR8Qd4VHVTOtcHmBSr194KS+3R0GW5Qga3/1ipil4P/AIf2Kcd7M=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7317.namprd04.prod.outlook.com (2603:10b6:510:1e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Tue, 1 Jun
 2021 08:39:28 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::45d7:388e:5cbb:ae1e]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::45d7:388e:5cbb:ae1e%6]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 08:39:28 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Shaun Tancheff <shaun@tancheff.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>
CC:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jens Axboe <axboe@fb.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/2] blk-zoned: allow BLKREPORTZONE without CAP_SYS_ADMIN
Thread-Topic: [PATCH v2 2/2] blk-zoned: allow BLKREPORTZONE without
 CAP_SYS_ADMIN
Thread-Index: AQHXVsGgyVhYWBzsdE+J29N7kj8+jQ==
Date:   Tue, 1 Jun 2021 08:39:25 +0000
Message-ID: <20210601083915.156476-3-Niklas.Cassel@wdc.com>
References: <20210601083915.156476-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20210601083915.156476-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.31.1
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [85.226.244.4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 86975a09-efc9-406a-fda9-08d924d8c4f0
x-ms-traffictypediagnostic: PH0PR04MB7317:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB731730202E5A2BF6680D4CECF23E9@PH0PR04MB7317.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wXXnEp8qxE5K4sKY5Bo/H5eEkIAr7Dxce2acn9dFUFnCRhjtx3kD4erQ7cIZwXZ6uid1EqsvUOtyBLROKboVMACewKYH3q1gO8BYd3lH9NbJkP1M6eR5v3Kw/q82KQJPXJivl7AkPH80kQh625d+uxhLlcACIF2UhUFzye9+ThoM/Nt/2BR5/CDhEHOaLUMBFrMIKEIg3p5mYzW51FuYX6JAp0/plV9wl+KQq6Nq7cwJxWPJ1y483nXDs+n4Jdvjy70s3pikJfy2E7W3SEPL5YkGr55vs1DgXTzW0ncdDskypRdep+v3HZ9417Wy3HFxSCA5FfSye5Y3e8DsykWNmpIwVI8G86FZqvSqGeUcT4xwSqGoxe+ig+Jm24i608u0ris7BfVXDX8Gr9Be83v4oYkqpXMby3JSv1uPbKgnC3zdq+55Gmk3Vhn8fsrryvbm2o6o4nbvIaJAF1+DXLNT+AMfrrFgbkpG0ujPMbL6OgEZwQLjFQaRGnjQGdSC4bcO4ZD/Q1iNpeB/si2zDv0GH77kJ9aHF8svWpTVpsfAfH+UG/WTO+B+kpiSidp/D6yGZJHDSUOMDPQWdhsCdtGLOYgBUV/CK1hYYlkwXG4YuDM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(122000001)(110136005)(186003)(54906003)(38100700002)(66446008)(6666004)(4326008)(64756008)(316002)(478600001)(36756003)(5660300002)(76116006)(2616005)(66476007)(66946007)(91956017)(8936002)(6512007)(86362001)(26005)(8676002)(1076003)(83380400001)(2906002)(6486002)(71200400001)(6506007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?Q+2SRiYPrUgSyrsTLSfMqdSya2gWeA44zKOf+TvsTvsdw/IIHgowcvJN1Z?=
 =?iso-8859-1?Q?A2kci1Svwxe0fB4J0Nxf1xGkvDfBCFXs+vuPL3Ct0orQib9aTe8IEuARJi?=
 =?iso-8859-1?Q?ln6NnxVfsimo7tW7vYJfP6ugijTiAhQIGnsCyNR0+TPk/WG2+ZZ04ZPHdr?=
 =?iso-8859-1?Q?RcDBPHIiOUiKeGW6XjhpM/+CzF9g8FiNhoC6ZvXB44LhJv8d4cUTIWYtyt?=
 =?iso-8859-1?Q?mOE2DxwJsCoTpFm9GP3EIqCCA/yhvV8qpMAc3MzwUUuYe9zzGdt7BeTG2u?=
 =?iso-8859-1?Q?bji8tU0ePIZmVrhzO5sM9szOJ/BKksd9lbxd4tmAcgsjei0eu0XP65cZEX?=
 =?iso-8859-1?Q?UnxIU3qI8BSzkCYt3qUx+XFyq26JdKoZ9iGFovCcnadnEQ+Fe2JyHWsUdF?=
 =?iso-8859-1?Q?QfyRYxbJMiUtfOb2X8MnU9gAtR2DGfUy44AjPnUODaRHFVntDWBU0B3Ft/?=
 =?iso-8859-1?Q?FPcldh+Cm/Pmrj8ynEpUklF2BiCXoaj4bMSZVeJDBtwMExzmdfPa+z8KHP?=
 =?iso-8859-1?Q?jtMaZwLxJeWBvApjLkD/Mi02R9+nMZ5qKbzAkAdLYi3bpyPpr4ZqWc1+uh?=
 =?iso-8859-1?Q?6gS85dmlBN5kQnyKOPKpEg/VjxN/EWoPIznmGRb/6gpbmRl+xpI4AO8Kir?=
 =?iso-8859-1?Q?lgEHk08nIjh2gtOUHeCGO7v5/XEqMFlEAhOA2WYfL99rWptsc404RWdWNU?=
 =?iso-8859-1?Q?5TYm66RnhbwaJ7UzXXr3/zClXeT6b0+FXlqCZHLCFXgP8zxhEdNkULGAXQ?=
 =?iso-8859-1?Q?EkkFrofI5ScXf2Ldn//rEzmqGqD8K6hoOeFZSrRCc8cs5FNg/1k3BPzdMO?=
 =?iso-8859-1?Q?sOkFNybnHtpNFmJGDf/0tNia6NLDukaWjSXnD+aJlTjeJX6K+mFTKslR3i?=
 =?iso-8859-1?Q?/iGV9Xqf7YaZDopWE/mRqbCAzYAaAEw+YHs34ZL7ZHynqKQcQlKiNVubgx?=
 =?iso-8859-1?Q?BBd9fXP1dN3+Jww9VCDlNZVdlFoWfvOm7AHivXSIrLSwQwmC5lBUfhqWLz?=
 =?iso-8859-1?Q?35IUZhi2YXo+b4fyrmGrU2YHaEOW9JVOK6zshBc1HkeaRuU34Hf9NqmE2j?=
 =?iso-8859-1?Q?GhsE1kN+z+CLsI5MWlvEn8mPlyG5ge5x3mP+DlLmKIBmdlTeruBwHYKON9?=
 =?iso-8859-1?Q?16+LR/KjkALvumPpEUmK6Fc+555NBNEgatd6wDea+jp9gOLwXKn9kX7zzN?=
 =?iso-8859-1?Q?rHBLc29pxNR3cS6tUGrdR7WQACcNJpmWuN76JTXqU9D3sjTQ702c8UAqFf?=
 =?iso-8859-1?Q?8Uu7y9A6ppQPH2L+8/o61gxbY3/9v5XMnrF5Sfpii8RHRZuvyov0rseciB?=
 =?iso-8859-1?Q?OVIX0q+DpzpH6YxsLf55LNlaUtOuTyjcf5KD5L/TY8SyS8T6Pu7gZ8sRfy?=
 =?iso-8859-1?Q?BREOmJQG++?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86975a09-efc9-406a-fda9-08d924d8c4f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2021 08:39:25.9642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jM3vC04ByR1H9a6zZa8nv1297ndDm9Q0nunnKOQtVqu74pzWbVgE+PdviZjHDs0MVtouyG9UJds+t1aWDVkmhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7317
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Performing a BLKREPORTZONE operation should be allowed under the same
permissions as read(). (read() does not require CAP_SYS_ADMIN).

Remove the CAP_SYS_ADMIN requirement, and instead check that the fd was
successfully opened with FMODE_READ. This way BLKREPORTZONE will match
the access control requirement of read().

Fixes: 3ed05a987e0f ("blk-zoned: implement ioctls")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Cc: stable@vger.kernel.org # v4.10+
---
Changes since v1:
- Pick up tag from Damien.
- Add fixes tag and CC stable.

 block/blk-zoned.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 0789e6e9f7db..e05fe8dbb06d 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -288,8 +288,8 @@ int blkdev_report_zones_ioctl(struct block_device *bdev=
, fmode_t mode,
 	if (!blk_queue_is_zoned(q))
 		return -ENOTTY;
=20
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
+	if (!(mode & FMODE_READ))
+		return -EBADF;
=20
 	if (copy_from_user(&rep, argp, sizeof(struct blk_zone_report)))
 		return -EFAULT;
--=20
2.31.1
