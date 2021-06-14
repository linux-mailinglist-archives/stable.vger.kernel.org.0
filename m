Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A9A3A666F
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 14:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbhFNMZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 08:25:30 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:24750 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233030AbhFNMZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 08:25:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623673407; x=1655209407;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EmkJF251q5BpNnfYoK2Qo9HmkF8k38XQfapdRw/2Gmg=;
  b=SeG+3el93Ovf0bxkBToHD+rG3tf7rukaxrVvYz9qzXzn1ng05wTHSpRN
   uD6rRrokX6cX+Jhv8h7Hvp8ZDhrQvzd/KFvYy77SuyxcJ/KIUJZUUtDfe
   o8RsKrE/rQPBV7bhTGxbM12nFKpLEpM3LtEn8j9PpPcfO2BYXFxgGl/47
   hKgjGaYE5bQ3Aj/5D6p59divmSWBh8LaN1V295j3jiFief4mu0Lhhm3qE
   iTXnetP4a2twE/WSCk8lGPWYV2FmRhR+d/lzjMXrsEtt7nZDNhHUeb2RN
   G7rHVYqwLbicfFsaDBvPPqvz53YZYwQUa38jZ+wGgLtuakFPh0O9094NK
   w==;
IronPort-SDR: xBSf/XyKr+7zkNus1gEegPxo4d8zXxJgigAnW1yMYd//MK5WHvQzLuAjAU/03Bnjx77XOY57d6
 Gka5Sh1el4HuU7k60zEauzTSJmr4fpQt2aTQeSiJxWt/8CKnADOsk2KrN9wtn1wlV99CX5J6UJ
 7wpj/h2DVc1ZYBGppGS2tSUTYgCZuxpp7FJegfLr+jq1IRs94fNiSpJ9G1iG5hq6b5qPRanzGK
 womO3ApC47t461q+ktgWixt+6DJxYDco3M4dwawT5CQPmvhAyezIeG1VTdxDS2kyhA2SDKsYje
 v3s=
X-IronPort-AV: E=Sophos;i="5.83,273,1616428800"; 
   d="scan'208";a="172386408"
Received: from mail-bn8nam11lp2176.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.176])
  by ob1.hgst.iphmx.com with ESMTP; 14 Jun 2021 20:23:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KXidY4ewGq5zIJAhQdot5lE8m7bjpzzBwS1LmOLFs5Xd7R+csEYyeN+ZOuHJjxIkcQ1447exdcF4CSH07ebbdnlJQLHCbELDB1230jY3IWPexB99/ZWDEyu7yYwKkI/kX/VVnZP5Gy8HBCPs3+bXZ0R6pLduLEqDpdtnhbqSM0MCd//c6H3B96ZLfcPkRoHdnXA00MlhrfMM5sog89Sbd4T+Xa8cEq4nufXyspYnW6LqI1mt5P7Jcjn6HLUqMf24J1f79p5ZSuwHoMFnQLYTtORLBKiL1u5zSeNgkJ+Q9u1SWIVqHe1kk9oHLJG8+qC21pm+N2K0vuF70fa5RyJXzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eWlh6+gvAAe/AD/wu11wJd+idxjqvlzYjZ2Tg52DPIY=;
 b=LG7EOmKSzKN43O3srPUvKFPaOUGyRmlfnTIBZnHsgJBbFbc8XBunKuxVR0wRXrDaWBLK63sDd/653pYzIi7TFxYdS3Qm3yR38k/JaKUecOvGphHW54RO23Kd9eY6n7fHo88ibnaPfh5uBVo89qsxusx4DwdCyqoKqBxrFp2o6oLIjSsJj45pFercEEaLj7qRt6KLQ7b2ifVwm7x2JNGxJgzOHYsG6no3hCASCeWzB9aso/fywCY7WWekW/JHPuUW2D7DUzsCdsy+JIhANPiGmIIvZOrwCZyRR1o9REH0N6Fiyeic2glih4bFNlN70QfeGQCbQv/3WpfWxXqQjRR4jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eWlh6+gvAAe/AD/wu11wJd+idxjqvlzYjZ2Tg52DPIY=;
 b=q9MokEHuwnmVkq0eHSaQvlT4i/OCLoEwNJYx3cdnPVLXdg75ThINKiNJSdd02G04nT8dKUVRDtDZ04AzaW6p8YVDNdqZvWe6rgReh5zJKonK0P9iyWFERl+6J+xrxI5M8kUdrA2sduO1UHMUTwklzfQdY2Bk0A1YhOaoHa4Oafg=
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
Subject: [PATCH v3 1/2] blk-zoned: allow zone management send operations
 without CAP_SYS_ADMIN
Thread-Topic: [PATCH v3 1/2] blk-zoned: allow zone management send operations
 without CAP_SYS_ADMIN
Thread-Index: AQHXYRgQMteA58G2kEuU7Azlx40Z/g==
Date:   Mon, 14 Jun 2021 12:23:20 +0000
Message-ID: <20210614122303.154378-2-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 23f26f28-96cb-4088-e6a5-08d92f2f347b
x-ms-traffictypediagnostic: PH0PR04MB7365:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB73651A454DDE1E0434ED54C4F2319@PH0PR04MB7365.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bj7pp1uT46rSQ6Xa2p2obaOBNUusZtGpwPKc61cv6o0tzhBpILNUF47hV2QiDJm/4LxO1AQ6vgeOoZMFRTwIAHmr8+D3FAnLWLJIbuWWoysxY7mQEH0rafq1QbGr67vdnbiMHHjSRlFUi99emykuBBi5Ga1ye91BcgrJknbqDV/IYmXcvJ326ioXSq9i39fSgO/h/MHgwJkjEqf8dA2renUA63zF8bOxoS50H6JRpB0/kSBfKCqtVBUxOKjbu3IUmanePOmMR9mcdvJx5d9yYExIc2AT767HV12QRbCL269eGdwQOmj20TT9ZUwu6GtbaAaj3vVH7B71dGXm9tj3pJJrNDh0xfmz2YgX7zkPtzyOm/TOZFehCBKrCxggN9FawbU5Ey9BSng1mRHY7ZO5dpncKEtAl2mJ6Pc0XOw3Ivjt154DmBvi/LN+VPBtVO3VaoqlBwgEAJIkTFI5b+mkmEtvYW/OB6XILOGVKee65mbFSEE7SZPfSA2R7dMMAjXoE4R1O0AZ3Vjp1k5GXqPHT4Wqu57AA1dk7AZ717xnFC19xtLxVBBFTQ+B+WqW+ZNAXV1NomMOOJMHBsbFF2LVH5rxB1Lx3TOl0u0Y8CyJ/8c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(366004)(396003)(2616005)(5660300002)(6666004)(6486002)(1076003)(86362001)(66446008)(122000001)(186003)(66476007)(8676002)(64756008)(66556008)(26005)(8936002)(6506007)(71200400001)(38100700002)(2906002)(76116006)(316002)(6512007)(54906003)(66946007)(36756003)(110136005)(83380400001)(4326008)(478600001)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?+486XYRypT97P4dm1lisSz2eyAQ9mzEinhd09Z/VB1x0HqqgKASRBeC7bK?=
 =?iso-8859-1?Q?VAv++hJGHpJ+lJvsim5t8h6MOSWu9rTqLky9xopdBNX1DHJhIhV619X1Es?=
 =?iso-8859-1?Q?VToiCU+0JfuNsNUa9UXcN1Lkxi1ismM2IJdqlz6EOxUGiUVURIJr940rPd?=
 =?iso-8859-1?Q?23NZeLh7XEr5Mwzma6vD3oaC8HaydfLQFeWS4RybOkkn1tV8E9BjXBfJ3E?=
 =?iso-8859-1?Q?furxAhxjQoHdWmb+XBdiVxJtD3xHLJYxIWvpu+hZ9Zh7jW2ELxcuETJPKZ?=
 =?iso-8859-1?Q?IK1fPyebkVuOk829xkKyouUfyTlNYXyLuMUbROQy6oNeRZ1yPbSC7pRv18?=
 =?iso-8859-1?Q?VqgLoaToiax+ANcGAeQ7Hgyb5xyXQmJuTnvsn+BOrEUWixocI3HISAxAF5?=
 =?iso-8859-1?Q?rf1258SdYb0sDgpyqJeIegX7sA24DiLkW1JirHwHz1fScPtiw4VfDMb5hB?=
 =?iso-8859-1?Q?TrD7GjTIOgChvEMdwK7bEqoQlp1RAoVRo/Qde9Q2UIXQJxkBo+9UdkzDZI?=
 =?iso-8859-1?Q?YcQusFqBAVyb8WQhowSg36GHOvmL++egi0cfkDJHiU1qd/56kENEsyKu/F?=
 =?iso-8859-1?Q?lRUJNKKztviANAPxpY7/iyKFtzJtxGp0LpmCAn3IHS1Zz6cnhdR80ai57D?=
 =?iso-8859-1?Q?M1aGJE0SZSRGkgtoXndphoSpSWpbpCSCzD+vPHB+z81Yf7bl+cEJo/Aenp?=
 =?iso-8859-1?Q?43qz7PIqEcMH2mmrjQ3hXBf8s/rcq6BjHtNKcVMa9FFDvQqcgWUSO1Nxjv?=
 =?iso-8859-1?Q?7oWfR6STOuARc8Yd7sIy9DiBH9B/dD/Cp1XM4eUw70fLm8ov8NtZPTgVKq?=
 =?iso-8859-1?Q?2Z8Y1ppDF8+3PTXQc8rALr+pTqNUGiHlaQUsC6vwizjidwAmgoJPD9vnYC?=
 =?iso-8859-1?Q?aVMPz17BQTV/rgBkCzvWhZ07s/jSIz6ENv5AfkOR4u2WiMGc8Op5LWDf0Z?=
 =?iso-8859-1?Q?cEyjs2KBx/wZ/6VjzBwLJNE0P8SpAnWvNwUusl+eA7GY7w9Lziz2TwPdF/?=
 =?iso-8859-1?Q?O5PEibELoMj7jixmGrPDCBCY5Ag9adqGb8ndt/4se46ZdHK4aKgMfEsFZy?=
 =?iso-8859-1?Q?40gPV4MOgA7y1WHtNkQNHtrvHNdWmGrKUsklbEQR2C3e34nid3E72k+Zmh?=
 =?iso-8859-1?Q?lOowL3RyU/NqeUiqr1806KdI8qNT/9IUcMHgOtJUuyDGIcJuGxZERzXfQZ?=
 =?iso-8859-1?Q?d7EntB4DpkgsEkBoIbXtVpFbloz1/yffgzUpbMCG4LM/fMzu0dx1eNXbfp?=
 =?iso-8859-1?Q?60LhB3sSrjWtFPEcqCQJvnb4uf8UR0Re4fm0YoqEUTkmXEXGYrR/3HJLjI?=
 =?iso-8859-1?Q?A/CJ6uYnChbr516jQ+ggSliySde/AaOXvSLu6QOqxSmeeZrCM8LfNwaLdP?=
 =?iso-8859-1?Q?CJONT3zgXZ?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23f26f28-96cb-4088-e6a5-08d92f2f347b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2021 12:23:20.8199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mTfpY2bKaH+4M/gvL3r9vA/lIWE9HQIhEgD0NW/8PlMZK3CYXyURH7vfKGFskYiyCkIq7KO+aFlK/T5trBFw2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7365
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
Cc: stable@vger.kernel.org # v4.10+
---
Changes since v2:
-None

Note to backporter:
Function was added as blkdev_reset_zones_ioctl() in v4.10.
Function was renamed to blkdev_zone_mgmt_ioctl() in v5.5.
The patch is valid both before and after the function rename.

 block/blk-zoned.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 250cb76ee615..0789e6e9f7db 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -349,9 +349,6 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, f=
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
