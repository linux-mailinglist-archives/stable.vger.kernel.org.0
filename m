Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B43D3E8F3E
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 13:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237216AbhHKLFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 07:05:46 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:7795 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbhHKLFp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 07:05:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628679923; x=1660215923;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C3Miu+F/T0ou7xm7IZgpxanShTObdpQZYutFJVaTPkQ=;
  b=Rt7WbbYGpr8hKd2C0bB56xZrc/y9gs6tgcx/ZtY3iQNagxpXovQZ1BOq
   hCbQQRBtW9k3Dfgso9uHUGEBNbJXy1x3jy44co1WuJYxSLDpc2StCzxD3
   FAMZIPcwLzEJ3tu0joDDBgCz2NtP+mvr9zs55+vZwHfJ5ZxsOgm/IKdpo
   u8+k5oiYvJf3QQdUCGuoagLJMpw0r2ga11HtVrDW+PnkPFevobzvZVEF+
   IxEQIXImE5udyG8HDLRf5GHyuF3WhN8mVeeNQts+QYS8WQ6JMXghGMZt2
   BnPh2t3+ju5cu5w8Ti5+HwQLkfcvGKwiyUTUluec0PBXELRhICwwZaaz9
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,311,1620662400"; 
   d="scan'208";a="177488436"
Received: from mail-mw2nam10lp2109.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.109])
  by ob1.hgst.iphmx.com with ESMTP; 11 Aug 2021 19:05:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oIwx7aOUaCQt2uBqDAXL9iSqshrM7OeLf793ADrgoGj5x3rYMgX0VMkzweoIVb5uV8hJXYeVX2q/C8yEDLwmX3o38IznQIcsnA5D7y5dVaI7WqxI5/0oA/ar59iImEx5iKd53nd2s3/+xpi6g0kDZUKCk6WKZGKI7hHAEhhJ9z4TVzh2CSQ15vZp4rXmRfEUK3tAZ7Z6xxAalb9KGpGabU9CpCBO98z3HOhF5S1kgI0mxQiF7E+9tSBP7zmXsW7yjWz2FHnV75PuWkFzINgrLmerlcacfIuiba7wxkHXBoP906VmIU6sDCpK8+ateCboihgVPkOxN9ovO/SUb97F5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NL/OOTSFd97POG7ASQE7IGZwCKmbruS3qCoFFoWh5RA=;
 b=YCr4OUYOPsW2Im9z6pWQA3fpakaoM3Mgh0IwqSRXZk+3P5i+FzuHhDIsipGjlBoRr1UuoMQkK/8fi9lGBZwBCRR26ivkpDgONaMa0CSDLeWfMTaZppGu00VHhjGzLjEGs2bkwzGYxAWHiRu3Xt8PiyGKrNBkET9pLzEC/ugXutw0X40O5p0NawcZk34ZO7H9va9LPcvRlNBm2ZP9/OO9sGSvJ5IJGmqAXxYasmErl+OYRZr5ZP/24yFNaAekWE32jPKcF01TJM3aCOS+5r2TjQhV28fz1xOaVEuik0DS6J3jYl4LX3t0zvlMDoZJj0h0XZhSCwBsDyo/CSBnA7chIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NL/OOTSFd97POG7ASQE7IGZwCKmbruS3qCoFFoWh5RA=;
 b=L0eIddnMf96LOMoyJQnnzVf1uIurf+PFwh8oJ9fBOcTVzI5/uY2XunPGctBFUvzU4LDz0/tXPb0p4jctEe/FV61He63XlWiW11kfjvyVLqb07O5OdjmtYS3H+BUiFgmZvfs3iOcp0jr9pXrPe4LmI9RYABCBttPp1j6FBaRNOv0=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7719.namprd04.prod.outlook.com (2603:10b6:510:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Wed, 11 Aug
 2021 11:05:18 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad69:c016:10d5:a3e9]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad69:c016:10d5:a3e9%9]) with mapi id 15.20.4415.015; Wed, 11 Aug 2021
 11:05:18 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Shaun Tancheff <shaun@tancheff.com>
CC:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Aravind Ramesh <Aravind.Ramesh@wdc.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jens Axboe <axboe@fb.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 1/2] blk-zoned: allow zone management send operations
 without CAP_SYS_ADMIN
Thread-Topic: [PATCH v5 1/2] blk-zoned: allow zone management send operations
 without CAP_SYS_ADMIN
Thread-Index: AQHXjqDFdLbKA5ZypU6CJovBECqU7g==
Date:   Wed, 11 Aug 2021 11:05:18 +0000
Message-ID: <20210811110505.29649-2-Niklas.Cassel@wdc.com>
References: <20210811110505.29649-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20210811110505.29649-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.31.1
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d8d747f-a983-41ae-490b-08d95cb7e7af
x-ms-traffictypediagnostic: PH0PR04MB7719:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB77193352BB1D7769942E71DFF2F89@PH0PR04MB7719.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tHU8/FQAtC6DnKkhAmT78K1pHs2nyYI9H3pSjAf49wwy641faLdh4XPAVk883XuIcMWcegNJxNPdDY6E7LR0kXv3za3URyFDN6HoghiLKCeGXwsty2GK/k6qnIry9PPiT8NMeCFTRWAk3WqXEb8TBirIvFSzK5sNdtPSC2T4+hO3y94RycL3fTkrOY7mtfq5MBuphoZR4t9lxu+Cwz12mi5z1QMYy9Gk47ddkNZJeGNwcL1L7t5RBEQ4NoHGer+dGIpjbmoaIXhR3wiycY1v4f2BRlDJNnjPC8B9sKzoIm7zoZBBz9BODdPKRYo/hj7+lehCdWUMQL71X83JYzf/Icq05/TuZI+dqbt+ReG2lxBI4hUY1OC0AKwDLhtRqYawJI7HLQ5ksRqxTWT/4rNqOAX6kj1/9gy2/wLSTGMt5qHLVvx6oj+PVRd6ArY4DSTktDjKoa9laytED/oyFRW7KhLC3JiVIyPiFhkGNnKDz6LboTW/9iCy0uXhGFCNrdBQgeejU8NDh7oRSQCuTkjwxg9kW1ed/2dY+gKmqsdv3Z3N/bqydeigomu7gNQdRojnYBTUHerHPKm4ONSCh+BkuS6MwdplsVSx9UWhb5aX1hYLZhNM68/83MJOrxi0Z1QFnGoVtDGw4+9+LN2HT3ERjb5MKjQswvaNdbGNaKwld8FONS9ELSncoTRz1f8WiBAZcrt29KpOE/qfSo5w3f7e5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(86362001)(7416002)(2906002)(5660300002)(6506007)(316002)(4326008)(83380400001)(6512007)(38070700005)(76116006)(66476007)(66556008)(64756008)(66446008)(66946007)(91956017)(26005)(2616005)(122000001)(38100700002)(478600001)(54906003)(1076003)(6486002)(8676002)(8936002)(71200400001)(110136005)(186003)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?pvuRH7q9NZnfW4Id9QehhSLRFSDLVsgFs8DVI2SFT+ycADsysftg/Ky1BP?=
 =?iso-8859-1?Q?GTIdP0ewLwF3s6w00fE6mcsHippQ3gVuEkYZjwzQmg9TzJ1wG0qIchSty8?=
 =?iso-8859-1?Q?NbW0neTwfQKrUZz+CaZ9vTarXVXxoQDwl8zTGI7XIDDbWSftywJryzh2h5?=
 =?iso-8859-1?Q?rqdtQ7Re06jMB/yRPBvUDBWgXLXMuDhwQHBa8qJRDFGZUwDDxZWc+yLc/W?=
 =?iso-8859-1?Q?sxxNhebYo2ptt7JYRfn/f8RHW2iUuy3WhhxPirNU+Yq0PCobkA3y/hnLTr?=
 =?iso-8859-1?Q?3zu8Hq4QwmuruGtA8ixUyFESijVBXD8VM9ovBLz5Ojgp7cBcGwUgj07j27?=
 =?iso-8859-1?Q?P9exRGFjf1m4spe72UmTTFUPnadnq38/3p1AeqRvZS/nxGgOv+N8XXc98q?=
 =?iso-8859-1?Q?U98m9B2uGWU8aiSPu/FI8vLhZ4YqQo8oXj07uliaenDOLiN/KA4yXoLu3n?=
 =?iso-8859-1?Q?FwUQfHtkXibJLobus3s6W4v/NwkeRUVvl9oAj0B/sqZFLUw2yRYULz9scB?=
 =?iso-8859-1?Q?7Qm04MawGUQuuQgnUaEEKGHwYgM6AILWp+zCaOE+ABn9LibbORPsWurdrL?=
 =?iso-8859-1?Q?G80pPe59c1UiTEBO3RHx+pfAkCz5XATcdjy+Obro3zTYPCIAEJg/Cu3r2+?=
 =?iso-8859-1?Q?MzMGWg8P4Lq6RNnOTszKgB62Hz4mifZ7hsZSH5GXXPwpfpiA3KsgCxjHLA?=
 =?iso-8859-1?Q?Qyj2ppxuly9DMIL56y7Ryk/narDvsWFQCG8t1lcW76FJ53AquzAQ25RRSE?=
 =?iso-8859-1?Q?tqEoBRqQeFAU5quhDBA6+gQWsMW+iT29ZuzGa7vjTnz+PtmsBRUhD9YeIn?=
 =?iso-8859-1?Q?sn0jPjOWKVWPUvx2n5PeWgfNcPk3cOeHGckfEeSmsWRVLBgrEeTVQYf8ko?=
 =?iso-8859-1?Q?+LH7A8A/WP6mE7QDP3nUg4UU2Z5/XfomFTJa9tYU9COQAdtWDRLcdYeOBs?=
 =?iso-8859-1?Q?iZBfazPOO4/EsN3YYfw6yxyAsD0iVZupShUasfOAkiY4QZzJ1VamWEUK+J?=
 =?iso-8859-1?Q?n2W3VpoLBQrx/qDWSPKRttYUjIK7Bl6kD1dGo8xR/eIQ9t/3XJ4D7NpUAu?=
 =?iso-8859-1?Q?1ESp8WIuikzhfCZy1WbA9BQu8rI6RyHaW98wqwaAG4WoX2HBHjzpwOuVW6?=
 =?iso-8859-1?Q?BYtYDd2L0S+NLQdzA0wGqQYml94JknuoEYLEmCT6TBLYjTYOYGzY32/ODS?=
 =?iso-8859-1?Q?nf6ufMm6grsZn+88JeayUMCFl72G423ROYHNkuEqM9eDzjFiZd+Y2WHwuj?=
 =?iso-8859-1?Q?VmynNMD0mCZ2YvlMDLR/Z9pLreslQik7ZFB4sVg75DgAQOB367M5CAzglb?=
 =?iso-8859-1?Q?bgSFpfaiS8hRD1MSdPAfMHwcx7Rd0bjXMCLJnjU4cPG3WEGi6RCN8eS5l8?=
 =?iso-8859-1?Q?iFU2hXeD9b?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d8d747f-a983-41ae-490b-08d95cb7e7af
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2021 11:05:18.3628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8s05pyETuI598J/wUWpjijWM1VzxwEPMZcxzVsKjvsJfz4u4efOWeHid9ql44H7TD3KlHW6tXzCEC2NVE7q7EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7719
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Zone management send operations (BLKRESETZONE, BLKOPENZONE, BLKCLOSEZONE
and BLKFINISHZONE) should be allowed under the same permissions as write().
(write() does not require CAP_SYS_ADMIN).

Additionally, other ioctls like BLKSECDISCARD and BLKZEROOUT only check if
the fd was successfully opened with FMODE_WRITE.
(They do not require CAP_SYS_ADMIN).

Currently, zone management send operations require both CAP_SYS_ADMIN
and that the fd was successfully opened with FMODE_WRITE.

Remove the CAP_SYS_ADMIN requirement, so that zone management send
operations match the access control requirement of write(), BLKSECDISCARD
and BLKZEROOUT.

Fixes: 3ed05a987e0f ("blk-zoned: implement ioctls")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Aravind Ramesh <aravind.ramesh@wdc.com>
Reviewed-by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: stable@vger.kernel.org # v4.10+
---
Changes since v4:
-Picked up additional Reviewed-by tag.

Note to backporter:
Function was added as blkdev_reset_zones_ioctl() in v4.10.
Function was renamed to blkdev_zone_mgmt_ioctl() in v5.5.
The patch is valid both before and after the function rename.

 block/blk-zoned.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 86fce751bb17..8a60dbeb44be 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -421,9 +421,6 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, f=
mode_t mode,
 	if (!blk_queue_is_zoned(q))
 		return -ENOTTY;
=20
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
 	if (!(mode & FMODE_WRITE))
 		return -EBADF;
=20
--=20
2.31.1
