Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F97C3A6671
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 14:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbhFNMZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 08:25:31 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:24750 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbhFNMZa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 08:25:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623673408; x=1655209408;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4HdD3/z15OzZSrSi2L+H9iyFWFtsZeiYQRP/aqExL5c=;
  b=LNcPtVR2CxkGkMvuY625JB3sLTXVWAKvnIPhOfIR8RrpRypbCOq24mmx
   tSwlaJHmwnx1+HdwW24POnlHbJVZVpF2KMT2qXiZGZUYNQng/IP1bNkGx
   eAUXAUgjxgZyq72567bXW3QDSm7oKH89Hlo0t1Dthw0hp6F6/ZeVOjKSU
   nYPoc9bABLQhYErumbZhhwtgUSZGkGP0ywQAAXYiL8vsFZQFvd8iZZPiW
   CrX++PBUg4xhnD/s4izaxlxh7FMMuLFTc/pCcAGMoc8o6WRPuzuqKYgI0
   /GEZMWCAWDLlhpgyt2a4igsNueWI8NimJjtpmT8wNpM2yHMzpQ1McRnwE
   g==;
IronPort-SDR: I/MjTrOgRPoRqLrrqh6u0OLgZKOhfQaBw9I3aVYXZqrLStocL7CGgzSkiyRbmNH9d3WZDCPMrd
 p4YdVwl5c+5i48yEXeS2WlIJLdI2ciQfbHzgdGbAGgCk/09eMM9VkZ/ZMHoenbnU9zWG3mfTZb
 PfaODEvSNzYBWd61bvWYuKoRvPecoSkWrZBXysjxFfEAv22z38lLuJBUBufGMT8SvZPN2D37jT
 QRd+FfnyZ1LINBkF1h0nvBJYnrtZsjQEsVUlFI1fOaAvNeask2IAHZuWUzdBbWbwaQTo57jCd3
 050=
X-IronPort-AV: E=Sophos;i="5.83,273,1616428800"; 
   d="scan'208";a="172386412"
Received: from mail-bn8nam11lp2176.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.176])
  by ob1.hgst.iphmx.com with ESMTP; 14 Jun 2021 20:23:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BhSlYWbaENVEDJvlhP36VCEkBzCKkH0phzvyBdrf7gfSk63AZJTc8QrRCw0IblqvAKyMi99mXhRLBw5IThgLpbQxuLKu7bwbztlpFshzwr2U63JxuPrtuUVOUrmAx/LGVltYLU7TZqSD94nZZ5sfT4GP5JP3nw4JZWa5115zDn5aFuQ47fp9OIDs/+djiI37XzCS6NPkl7h9prfYAxncO5hGdFJGQVpyUw+xC3odjJLvyoJGynEBRNlZe/Y7XSYdZk/3UeREGqJfNzAae1ebofrIUyBFR9R7Fu5aK7NQ5K8zLrC1h7rNxzmphR6R9Tray7fkXCzUFnaYzuhpVMpblg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2rVbzgN+XL9RpMPdMgKvn6f+EwJOo6D5DUm5l54frQ8=;
 b=KPuJ1eKHzxVbB1i2kCpZBMO797oAQqK2yyJcBTjAdM935hS9qkFRiWkG1IiR4qjnr50DI4PFNsIRyh6iWCpEjBrXFF+ZAExHJ9zm516ZEUZ6YvCHg1LOq47UdAQFU5Kd0GzjTQ/72pMdjuHQTa2z/CY9LXBW9+2zh1CX8y5sx9C2fj2OXpvlxdLF0zQSbQ5/3/YA980t91TqbkTrjJqlzc9YCIO4AwWqOMsG1IW5lhl2ENu376Ecue5Ha6ii2q5W0XVqZ37pIPLDwLL/I9dx75jIw4Ev+ciMq6uqXXibiHlLpHuKa5WDyUCCdvwOp8OIoJ7USYHXs3KQEESfv6iFOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2rVbzgN+XL9RpMPdMgKvn6f+EwJOo6D5DUm5l54frQ8=;
 b=XeeNrl6RdDZytZrnD/JUlf93TOkMkK27AO5m9Shu1RZ2104SK5KftX68gB6ohc6vaLKf3oZWgJHk2yJQ8WkMPoQBW2lyKxIeVW4I+naZDxC5uYAVeCGl4xjehSoNgn/RZX0qi4YMOK9C5uIzI1Z/PB110YxMY7Bj8J6P/u5QR6o=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7365.namprd04.prod.outlook.com (2603:10b6:510:d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.24; Mon, 14 Jun
 2021 12:23:24 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::45d7:388e:5cbb:ae1e]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::45d7:388e:5cbb:ae1e%6]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 12:23:24 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Shaun Tancheff <shaun@tancheff.com>
CC:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jens Axboe <axboe@fb.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 2/2] blk-zoned: allow BLKREPORTZONE without CAP_SYS_ADMIN
Thread-Topic: [PATCH v3 2/2] blk-zoned: allow BLKREPORTZONE without
 CAP_SYS_ADMIN
Thread-Index: AQHXYRgQCVfFQ7HNWEWEcKzi48L9sg==
Date:   Mon, 14 Jun 2021 12:23:21 +0000
Message-ID: <20210614122303.154378-3-Niklas.Cassel@wdc.com>
References: <20210614122303.154378-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20210614122303.154378-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.31.1
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [85.226.244.4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 66bb170c-19cb-4a17-ae1f-08d92f2f34b1
x-ms-traffictypediagnostic: PH0PR04MB7365:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB73659C0EEDCDA851DDD39F42F2319@PH0PR04MB7365.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k/MeQ0zzZWNcYnO92M7bKCqJixWjYTnj0T50jwAdfkJoXJ8Cs82n1L/22eVSHT0G/wfKNOTNFu1B+jfE+Pjj+J35dYd6u+/yLBfKZZmGeyfxmcwRwaVNRyti0tAUTa7pK7k9jYZlkvqK0qIxRTEM8GTaUQIgk2QGPlle+Luq3K1CiZYGLbHC25F7rIJaSI7SuJKsr/+nlFChodkJ1uhHJRNDjGGHT0DlybX2u0lTQcXgkK9JROzLdCLG9Uqi8JrBabuHI8JZAmarUcHARe1mSnDChgrThKj3DU6llRGRmZIYP9kfBMnjfEg3CXHWS9sKCHODYYIFewozMugGOl4oVfjkn811nOWnjvDaMGHnwQ0EuKr/D4FU6y3NsP8Anm/hW5x20MMAv8LS1LoqfxTVK/yqVCR38Dy6u23hQLZBFlVk1Sn7lgTutAf2Ca6TNo5Jc1ACTRZuPZNSSlf0dgrPgmZmsinOWK2z/4w2es6Rd4dhuenafNfaXgq/rkD/W9Ejg7tx0AeWU1aGC5gY889c4JAcTVbU3hZQxHNDnBchBxhcjC8uxvdORdCdp6uBlUR20XYypYwJTCPQsMkvc2RSGjwQyrDFu5tRFes/8U1lXyc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(366004)(396003)(2616005)(5660300002)(6666004)(6486002)(1076003)(86362001)(66446008)(122000001)(186003)(66476007)(8676002)(64756008)(66556008)(26005)(8936002)(6506007)(71200400001)(38100700002)(2906002)(76116006)(316002)(6512007)(54906003)(66946007)(36756003)(110136005)(83380400001)(4326008)(478600001)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?R6+0rohg4+EOoAid6yIhSIVdejHd/9R6CsMWC3ZcP4BspyqpHZmn9aPajJ?=
 =?iso-8859-1?Q?RHcEIW0nsafeLqRAkjKWHSy+duTqCtamCsSt2XF0S1PCkEXi7RW7ufDVuv?=
 =?iso-8859-1?Q?/8AP/MeAisNXAO6DgKMGGTGiqxGPyHfvySaTT5SZ1nS7JxtP2X+GG9H7nQ?=
 =?iso-8859-1?Q?yx8QAw4xjrli8ORZQ/djTRjkt5EzVW8lU9+BTg+MvQqcuv2YFIv1iM9JuH?=
 =?iso-8859-1?Q?ajrjP5Zwwxr/XF6d1SwBGOmfGKgRPhexrsgwkIDcg6U+unsfORSYrnl6l7?=
 =?iso-8859-1?Q?/XIq9j898HT4fRrMn1dHKJydyhaoEsuXhEz7KYVUBRupIR2ic3jc+cXIAG?=
 =?iso-8859-1?Q?G0fbGR1e8aIc8TkX8souZsNcFY8v2avmWb7HwVW0jOrxabEZQja9vqGsFJ?=
 =?iso-8859-1?Q?mexx2HwG8VKQ/V+T+60Cq6SoquoHhQV5oPCWeD5vLsui6fQGybtbLZ7oYF?=
 =?iso-8859-1?Q?mrJ0t7gGqLbx8/6bHq3iKxrnavoCldMQMdAjiZP1087UviFV27m9YiNZZV?=
 =?iso-8859-1?Q?gVYcI8EiJPSo80aC9AUbiNmq6ieahWSO6RG886w/RlsWxLF7nVTN9AhLY7?=
 =?iso-8859-1?Q?56yiBydEgLYO2Dyz/0lJaSM84EAucPqJGaGi05C20JkfRBrqY2mOg5BhFg?=
 =?iso-8859-1?Q?/OOQmqR6PDakfkkpx/TwGt/D611fLuPB5s/z7ASibV6KveoznOOuu/Lc4M?=
 =?iso-8859-1?Q?z922HfxVNaaveaiKHd5pyeTUXG7NHrOkaHUEVF5RDm6djUlkHFOrumKvVP?=
 =?iso-8859-1?Q?kc20WRRq3OmQwCMDBgdD8ezPCXlUpHe48xHXKy4WFA/NQqdyYWBGHoXZF6?=
 =?iso-8859-1?Q?gsV04vQcAzlNERm30/X4QwAHpK/tMo5MQn6EscUJ5KY8ppIR/xYDxu8Az8?=
 =?iso-8859-1?Q?vfNHoDJkwq+fKGe8Q50BK5N4E200RayXXAJqxxySQkyyY3Fh3zH0Cv7AHr?=
 =?iso-8859-1?Q?6blrf0q+6rlRvgjfuPwlnPfNdBI87M+BvSis4Ujv59A0OfbyHlo9ZBN5Kc?=
 =?iso-8859-1?Q?Yh3BWi6KPHcdHnij4ME7dvRnxceksufiUvVyeeqpNLyOYZEdWf6fQjflR7?=
 =?iso-8859-1?Q?qaZZVylSNFHgYINMj/Qu5+zx3tVh7RV4uOJAl2L+/788thZlTtIc+VxGJf?=
 =?iso-8859-1?Q?c79gOQu0mNyp203wnDK87eiO0aEMAPJ9l9oGW2T4u4BCJD73NcvlryPDqd?=
 =?iso-8859-1?Q?zVOlnQLG06GD22E3F8I3BrN8djp+iaUVP4WAoxQeeHqv0gRS9Zg0yBU9aJ?=
 =?iso-8859-1?Q?WuFIQ2VcIhqthz9fMDEPWtfh2HJKARpinAQF1GRypc+trr4am5e1QlzA5E?=
 =?iso-8859-1?Q?HthkWUQwSaCZNNo+FHj+ea5t80FjqPRk2C0PxZXF/v2RLHq7T7928u82Hm?=
 =?iso-8859-1?Q?hRJczaTmSd?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66bb170c-19cb-4a17-ae1f-08d92f2f34b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2021 12:23:21.7957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ayHpFmtRVV1qBgjv7MOe9ZcMHY0FfX/vsdKE5AEQ/hnjKkdTAGsWR8VHEMHEwYzWHzTRanVNio+PsDPh6l+yrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7365
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
Cc: stable@vger.kernel.org # v4.10+
---
Changes since v2:
-Drop the FMODE_READ check. Right now it is possible to open() the device w=
ith
O_WRONLY and get the zone report from that fd. Therefore adding a FMODE_REA=
D
check on BLKREPORTZONE would break existing applications. Instead, just rem=
ove
the existing CAP_SYS_ADMIN check.

 block/blk-zoned.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 0789e6e9f7db..457eceabed2e 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -288,9 +288,6 @@ int blkdev_report_zones_ioctl(struct block_device *bdev=
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
