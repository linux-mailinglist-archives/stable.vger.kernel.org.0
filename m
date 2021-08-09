Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E8F3E433E
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 11:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234747AbhHIJuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 05:50:50 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:58993 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233267AbhHIJus (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 05:50:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628502629; x=1660038629;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=V0eg2AndzzF5Q5EZFxjDCJAHXcseIiV4VB7KIJ+t7bw=;
  b=PjorLXjPWtU7OnW2LSwnetHdKczPKH8jwjv/6TiNZJpY/xugj/MTTsYh
   shTwVefqnmr+cJZm7Dg57wZgWAA96QPFdu5hgDSNoCtrt8ww2SK5Dw9HW
   eOv69xc3uGsNpRUpdxE7As2UlP5PBWB8gQqW45ewtC5BTbcqwYW1ZQafO
   SvPvjQHdArsG/e8KbtiiM1fRUe5OFHLop08VGrHEnyyEgs25BqKP6uT98
   w9QdXrBdj97Suw51mv6UzDou0PXkRuRpOOQOKy/s+VedrKgm+kvHgwL/k
   U4wpTVs4DSYXhHO96L3KqV1pBibGTJR/kvyldDYsuR2s6MokNC4WXKojC
   A==;
X-IronPort-AV: E=Sophos;i="5.84,307,1620662400"; 
   d="scan'208";a="177231222"
Received: from mail-dm6nam12lp2171.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.171])
  by ob1.hgst.iphmx.com with ESMTP; 09 Aug 2021 17:50:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGb/LbmyMW320ZgaP3PScf2q2K/ZnMmTqd1pJ2RMbuG7maJgvzgLPcafTVOnMKmU+4HxyCBUR4I4O7J2W+3cv0FkxQsw0mCh1/nrLygVZkLtaLKRBK0lFBTzqMAfJLXLACyewxHSlbJQFfQtzmHrYizGm69oENhE6ONV5myW2weVqBMNG2uX7tm3K8uWpGE5thd5i0lXlRwSQBzz27S6E0MqWOF2WABa1ehuCmRaVAZ0bQHrZTUdbiEJXv6I5+t0PUsoQ1K58Hk1tRmMjunzwFCAXhYJBTmI+b0reSImhuMIJ4/oMzXspLhfe/xWlOOQDxYCi1BSC6kBxJtHEZlkPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wU2XoX/8tLv5nfSqOsE538TpQz/S8qDDFXkXMpdeUFg=;
 b=GSEikCuGqGElkyuJcfp2gc/htw1xodb5prN/6EjlF9PFBb87Wn9zGVFWySPkAOBjpGXCup8g8rVwqMReLxJJYeVnansokCktQW3OT9EjraqKBaG31gauiPVTqzdW8/yL88HhaSw6LwRajchMHp61wmAb/ZUgFsVH++2AtVUhtLEEt2OnvKbJ9SaM3avxlp6/tv4a3pmSZDxHbG50ypEfV3yyEc1TMh4a+rTCT/gbSg7x6nAB6kAUWsBhdXGONWPTuhCrk0kgsFRv/El0W0CCQaNvU2nnfhenFYy3HGlTX0T9y0peGWP1Q6ozgJqxPy5BEmU7BTg1eI1x+aAYdgmXeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wU2XoX/8tLv5nfSqOsE538TpQz/S8qDDFXkXMpdeUFg=;
 b=Wm8sOH6HWnRIqn+R4n61diEH7o3psKqB5mjDUzS1zFM1lH6jILsBau1RqAwgk/oe77ImwgrrZDYUpuPc8jCS/dKKHl+XNf7N8jW/vT2Py6jsff0JeJ0tP401W426IcIHndx9PWFX6QNCfQILPjApYKn34rPkk7zs8AVskbGoBYk=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7558.namprd04.prod.outlook.com (2603:10b6:510:54::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Mon, 9 Aug
 2021 09:50:24 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad69:c016:10d5:a3e9]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad69:c016:10d5:a3e9%7]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 09:50:24 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Hannes Reinecke <hare@suse.com>,
        Shaun Tancheff <shaun@tancheff.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@dc.com>,
        Aravind Ramesh <Aravind.Ramesh@wdc.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jens Axboe <axboe@fb.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 2/2] blk-zoned: allow BLKREPORTZONE without CAP_SYS_ADMIN
Thread-Topic: [PATCH v4 2/2] blk-zoned: allow BLKREPORTZONE without
 CAP_SYS_ADMIN
Thread-Index: AQHXjQP4aNCn2fw5YUWhEgczWRLRaw==
Date:   Mon, 9 Aug 2021 09:50:21 +0000
Message-ID: <20210809094855.6226-3-Niklas.Cassel@wdc.com>
References: <20210809094855.6226-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20210809094855.6226-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.31.1
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 63dae971-40ef-43dd-58b7-08d95b1b1c01
x-ms-traffictypediagnostic: PH0PR04MB7558:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB755831F5A6D2B4728F39607DF2F69@PH0PR04MB7558.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C7723HRfUXrekXsXIhRZCpIt+vFXh/Q1gBXjgSNUgg9l6+rPOO5ACi8wjbT2rKCGrXCyazb+bPKhyaBEKz0XPFuiK77tljHT98WF2SpQ4kVvyyQTLnLqIFOwZ7oT1YdYY7ZsBL7BBotRZO44TU19n//FBk5b8TG8v7RpJ+/ReoJryFz9rn7AJThPfj7zXztC6odkL7PFH8ttU3Hlmb03yfEpy8VGNlFn8CrexP63ln/Es1iygWzyjZBUKjM2OVzZgluAAFAOOnKX5o0ch8Aj3fc4g6h1Q65J6mSZkgdVZuUjkSvEdfIlIekU/TMDTPAH1jAMRHqWijr+IrEs//nXqxTk3+7dOOx1zJYo2vxlkuAu5AUvv/bV3VPPdHs9lmmtach1xVF9H7uPHZJmn648LqpBktxHcGKcgHtYczXb50djNRRDblxs8I5AJTTLiv4ksg1vn0YgphWPdIQYsVFcUWqTq6nMhP4MOQQBUKY1eziESihBUk+MIReSM1UKV2iYkxQDF0CiF1M4ip3qzYDHId5tdZnQ8P84g8P+Bn/zrKRHW0V58WH69TJZcwxjlcTDOt+pBvprc8T+rs52AT1aTcECnfXCxroW4hmiF27JJ/x803EwuymNr6qujWTRRPf8sgFRtVA9t6ayrLzIwJAKF3Cg+7YNvyNYCXw0vW4clC1jLVi48yaDZAboML3FuZwjrZmXEppky4ejMfNj3Gf9sg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(2616005)(38070700005)(7416002)(2906002)(6506007)(8676002)(1076003)(91956017)(76116006)(122000001)(186003)(26005)(38100700002)(8936002)(6512007)(4326008)(71200400001)(83380400001)(86362001)(66446008)(66946007)(66556008)(66476007)(6666004)(478600001)(64756008)(6486002)(5660300002)(110136005)(54906003)(36756003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?jzXj/YMya20Fb4wBZpYJS4GyCi8wuzrcc15ZveCz1F/fDRUHSlsSiisxBw?=
 =?iso-8859-1?Q?UwHAS4KBrCDeAV53xZRo/0LdKGApmA6BYmAeMBQuTnlls1r+LuO8hBrObz?=
 =?iso-8859-1?Q?icyKD7xmBlSbDeORLS0R2v6W0RZkG9+7WLNGjkCV7AeAts33fQscRqkCBf?=
 =?iso-8859-1?Q?s4at+C2SxKaJgzwi1fYRwNSKDIC+T98UXmowSiLbC7QLhDL+GZaK+9lg1M?=
 =?iso-8859-1?Q?pLKE77gmqieHsmLVO6wGknJqKPwawaSSjggioG0AcpqGdPyNmnBTaYAopk?=
 =?iso-8859-1?Q?+/2cpEdWXkPSxpnNocqzPlsC+EsA5Q5Ur9JP9drZFwgxJY6rH22isVez9e?=
 =?iso-8859-1?Q?r5GPUpoav+hypzXGFXDRw4lzsIdpeZToPOZkS1J7ndDz9byxPiDyclLv0G?=
 =?iso-8859-1?Q?lLtSIFUYmxQ0vcgn7EnpjvITLlMy6u0aXA7I5Whwgw7VN/rPYVbGLX2jgk?=
 =?iso-8859-1?Q?QRJLN6fugEhoOzFK1OvIn99j+opbLFD1ujbPs5Uwj/T+kXdnYRfDIiQkKg?=
 =?iso-8859-1?Q?paz8Pfp9yNDKjrJBYJAXEVcUrHST1KJSoKOc0YpZAAOd6otU+Mm3cwhGEy?=
 =?iso-8859-1?Q?1g+i1/fQXOovoewCqmFSn+lHP8E08ICgbDdDuKnLnhZdPIS/hMmXbEIe9H?=
 =?iso-8859-1?Q?4Cv+wsvkO35um77krE8If3U320n83HpYj0BHPrbomRlPDJ6wIL2fG6k/6H?=
 =?iso-8859-1?Q?9I7sdg/x1kgZaRH/zMQldK9HlbpIu2FUg6zAnspc1n1ShO5l7z0vPo2MKn?=
 =?iso-8859-1?Q?hXdp4DpV7lhPaxxhpolxNVy9onOwtEyS1FcdDBrXtQn1hY9Xr/AHSM7HJJ?=
 =?iso-8859-1?Q?jYJKUalSBAmPqW8703c01coiNqW9tcI6aSS27UHxD7CI8gqFb/qWqaY9GY?=
 =?iso-8859-1?Q?YkFMiftlmk1lvJ6jmWNBBV4SaxtwudrVj/6N8CcDWP1wyEmJHQDTRNbHBq?=
 =?iso-8859-1?Q?r1U7wiR+Q7jf5kF+0vcG81bELY8OaCiJYSG9AmltgxI2H5oV9D66EUu1Nc?=
 =?iso-8859-1?Q?+JpJ3uOvJYKtaLuzODBM3XLE+IqzvY137AOWrpbegJA5Mcpsl9nh9grqa1?=
 =?iso-8859-1?Q?qKJjeK+hFR7302e+PvkPKehwpOl1dRVmITpsRS2R+L0fm19gY9bwgXohLJ?=
 =?iso-8859-1?Q?+66OpIgUXuMtYrUkTu1db0HJ4pjzXAAp+oZ5uXX53lt4JZiLpMB+VCNCEK?=
 =?iso-8859-1?Q?DnvIxhkiiJABWb2r10zBXrAt+UQU+c6UjpxwHqIU3iEkq6tpU1JWXf15BY?=
 =?iso-8859-1?Q?ayelo3g0NYpwOCah8M3gU3eZq3M7qQUKcA1sLs8OPXW35Q/TE48dIYYoNm?=
 =?iso-8859-1?Q?IwrFzyqays7Lq/CdgU6Mtw1SvGty+cFQrE7LKGHB9CypBExcP/dXHpwgPh?=
 =?iso-8859-1?Q?l9oEaRgCn3?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63dae971-40ef-43dd-58b7-08d95b1b1c01
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2021 09:50:21.6700
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pfw5d+xjd19gyHFSWcdG1Rg2pIRS1tgX/+9G6qSPPQf+Lzq3AogUPcoxk0wwysMoDsOTtj4sKzdrxAorCX3XlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7558
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

A user space process should not need the CAP_SYS_ADMIN capability set
in order to perform a BLKREPORTZONE ioctl.

Getting the zone report is required in order to get the write pointer.
Neither read() nor write() requires CAP_SYS_ADMIN, so it is reasonable
that a user space process that can read/write from/to the device, also
can get the write pointer. (Since e.g. writes have to be at the write
pointer.)

Fixes: 3ed05a987e0f ("blk-zoned: implement ioctls")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@dc.com>
Reviewed-by: Aravind Ramesh <aravind.ramesh@wdc.com>
Reviewed-by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: stable@vger.kernel.org # v4.10+
---
Changes since v3:
-Picked up additional Reviewed-by tags.

 block/blk-zoned.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 8a60dbeb44be..1d0c76c18fc5 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -360,9 +360,6 @@ int blkdev_report_zones_ioctl(struct block_device *bdev=
, fmode_t mode,
 	if (!blk_queue_is_zoned(q))
 		return -ENOTTY;
=20
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
 	if (copy_from_user(&rep, argp, sizeof(struct blk_zone_report)))
 		return -EFAULT;
=20
--=20
2.31.1
