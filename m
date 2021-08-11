Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90DCB3E8F41
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 13:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhHKLFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 07:05:48 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:7804 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237224AbhHKLFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 07:05:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628679924; x=1660215924;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6qiafo/6ho4COn/drTSbE6yo8Rchw2X7On9eph4G/Ek=;
  b=Fn4EPEFKKftJzUq1ZCCIsXYifOagyRaBoEjLXV9wHN3fOrcGT9ElCzML
   oPZnCnvpBWW6hVc6EEDr/V/s5GgGkZCp6BeMQG1/mhik7yhr25OiTYPwo
   7EzFBk39OnRQ+uhsOCt1402pcLOfLqaaYIXyTodoWg3bTFd3Sl71APxt3
   WlFqcGF/T7nVtf8kQgfvZ5BwgrMTNFjtklTzKmRBQoGHEp1T0KQ2n72hp
   mrsveX62AZv4nDfyazoVgl22xU/sKu4k3eAKuy/lyy9qzdrgGn9QAdQkM
   sRWDqCM7TeSKpCK2hT1fSX25SvSWakVHMCjDe8FPmc8bFy/1m95TMEK25
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,311,1620662400"; 
   d="scan'208";a="177488444"
Received: from mail-mw2nam10lp2109.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.109])
  by ob1.hgst.iphmx.com with ESMTP; 11 Aug 2021 19:05:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5ID3GWRw0h7L+OSDUWuJz5TgfkwATBbKEhLwGZFUk6M2HjN7ti50ph6p0n58b0UfR7/Q1D4M6+lhWdbchUMqD6Y4wKcWlB4gqnsHh5uELRrH2ilpdt4Q1dHXQViulw/KrZ+ISgPi53JcUeiKU6Yvuri/usP5IXe73nQeoDWXQ6aTAZZ/bXcWjsNNoCBqu72Mff+YXOpONzvSd0jLEJw8LwfqNJv9HyV+VybYEc62JUVyIwP6heTYZd+WYlb3tXrywioPGXET+94ZeJV9DL6IR7+/d8P1YopwxZRRUK8qEZ/5SvwzlYPLtiv0sEt0JiXKzPpGK4A+bYQdJIvrebhjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpokQdYYm5mimqi3RydbV5KuY9RKHh4z8jOG+Cw4tvQ=;
 b=At/oR032D2n3mr8fWjURhlgde4TsjQVxhmJqH1auc7alGtTR4PhaYoDaSKfZGqaqAU4nUqKTCPC/wdEgCRfV16RyNuBbDowCX54JQ0oQZQoW87h+jpyzcIWxjXUuQEtuhvDOEC8ckq4i6ttJMUJAYzLrII8AyE87rs0X8AijSUWGWL6EPTt1l2dwoWSJY0PHl9kzNdT2b1RTson9Vg50FXx7io8J9jgtvSfiKWHvLmDXhdY8VqYCaALynHr0ADANtf1XOR9e6I7og/bGOKaJ/9cT3yLAyMmafB7vqUOL8bcMxDI7WEqcDrdiRXC0V1DJ4HKJb6AfP43Id0JsX7e/Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpokQdYYm5mimqi3RydbV5KuY9RKHh4z8jOG+Cw4tvQ=;
 b=JbY+J1p2w/OFVvuGzDfeJaIVtajfGnmHZ3B8imd+Pxd4wahf2qo4J6tQ0xYa3R0hUna82qrNLVt+nwc2ZULJIIOlPebzFsqJIiezT9vDgKb+s2Enfa/WenieJURn0cJ5TRZ8mh7B1SCOXZuQIGiX4VP8mvGPMGaXbaYbKzc2ifA=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7719.namprd04.prod.outlook.com (2603:10b6:510:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Wed, 11 Aug
 2021 11:05:19 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad69:c016:10d5:a3e9]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad69:c016:10d5:a3e9%9]) with mapi id 15.20.4415.015; Wed, 11 Aug 2021
 11:05:19 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
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
Subject: [PATCH v5 2/2] blk-zoned: allow BLKREPORTZONE without CAP_SYS_ADMIN
Thread-Topic: [PATCH v5 2/2] blk-zoned: allow BLKREPORTZONE without
 CAP_SYS_ADMIN
Thread-Index: AQHXjqDFbqdVjmh3FESvxZ0E3nXwJA==
Date:   Wed, 11 Aug 2021 11:05:19 +0000
Message-ID: <20210811110505.29649-3-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 1a708f78-4e72-413c-7501-08d95cb7e83f
x-ms-traffictypediagnostic: PH0PR04MB7719:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7719CB47D0E5CAE3DD1C5224F2F89@PH0PR04MB7719.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S+9PE/RryqZ39QNAI+qnajTNnRF07FPMPHLSZYZW6obWh4yUuwXmOooj3LNdAWJx0K0DiHtW2ZTG2JgHWcDacH/TWHtXW2gJ/sh+UKjIHnaVirdvcJTy11W60Zy55wiDe72P8hvIZF4YegulL6uSwGFRytaj/8AYZvgs+YfTW9NJEBTXStBxVd1gkiyN5k7VOxkkmnLkS9GekWU0ujB1ItRYgUrJDQ+kjqPdlfsSoE2lOoWXYQs0+pVE2Lq4TNzaOeYcbIsCfBaOIkN9UsfwRXh+2asykG8E8Z9ReSoO6kSBeeWNqfB5FRUZeW9v8b78Mpxzm/7XmtRfs6OYHcffRmZNUlrNn8jjlWN/WlvyZFAyxiwNOIo2y7+faF2PiiwqC43APVRC7yCaucWm/2F07h1tpmYJZwg47OB8YxeJ7orfoYDdRZvmGqrw8Wdmzen9Bd811BRxXluobYeJ4SCpy98FVfNdXBGmOd4GQIsDFYCmFGQPZQv5HxyRkjCz9JZCZ/bsR3jnSRDgtohD8fsTZ8BUVH/AlUmMPr/5IUoH2oWMZ7XU3O3AZmttba85q/Olrpll3ExLxKLaY47mukzupNmkSVQ7vGcCVglktV2CLRCrBEupKA9AjPlPBdG+7Hyy8ADFRgZw9sdHW3qvlHONL7uFhkkfCzRISnKaLx9RG9TdeyeuzScs60Y2Jp4BAHD5AU88e/9MXRP03/ewU1ncIw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(86362001)(7416002)(2906002)(5660300002)(6506007)(316002)(4326008)(83380400001)(6512007)(38070700005)(76116006)(66476007)(66556008)(64756008)(66446008)(66946007)(91956017)(26005)(2616005)(122000001)(38100700002)(478600001)(54906003)(1076003)(6486002)(8676002)(8936002)(71200400001)(110136005)(186003)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?34Af3d3v78WlST+UI9NM1Ws+y/bNK0BTpTLDO7yMCcouOzzDPkmYNmRbXN?=
 =?iso-8859-1?Q?qwv/AETa80PXgcD1i344797f6UMasuSn4oqcjg5kSUP1KaNcy1n4+hrWjH?=
 =?iso-8859-1?Q?hgK60sQsiY4RPDKy2QU24utLP/FEHWzDrLNIwNNM32lLQrbEeA1AJU3cr5?=
 =?iso-8859-1?Q?7Rg8p0QlEMiSP+WgTV574gF9EbFKZJd00IWaW1LpVA2UbANBEbIqWUolOm?=
 =?iso-8859-1?Q?UvZ59T6KMCkCObVb8AN5Ouu+KMnHYyYq+7auo27EEvz87UhfoOJECU9GKB?=
 =?iso-8859-1?Q?hpMj/IeLPAVAX1/yyfP64a507N1MEzSM0p2gqwMZXGwhzn8SHb2OsxZXmo?=
 =?iso-8859-1?Q?mJyIZ//TzxQ/A55kLS6YK0mezRjJVh+Id2ERZ4Iy/M5+9mR1XuDZXmo2iq?=
 =?iso-8859-1?Q?grHgcrRs1P4rBOpd6rDmpb2cRHggenrDT2H+BOujeeEQEOkY2axyAMy7vb?=
 =?iso-8859-1?Q?okmRpCASGEO8yu8kzOjAFXToZ7oAKemmtdFNNq8UsV82NyjRVx8chN9VQx?=
 =?iso-8859-1?Q?BoHZu+K/98u+1Wlll8J2l2Jofa8FuPppD8ASFha0SMRKoMV2QHVABoFDHN?=
 =?iso-8859-1?Q?1CLMxMFVUGPRezwJ4vqJ+tVzEOFooe2r3FpqcGUtEyUfizvygt3QCm3bHY?=
 =?iso-8859-1?Q?+tAyAHZhAKDhrt0fY/i42bZd/ELB7QmYUuInWMUkN4Xb7QktgbXmoiZVfl?=
 =?iso-8859-1?Q?z9nD2l3A0QgC6plmIVVK+oOPfKrjtVWxlXwTuW0c/kM25AYeBOL9o2tdWp?=
 =?iso-8859-1?Q?9hEPznxdhdAdZBl3car6bayyWOXJoNfLBXjXxTgYrg/QKmHo3DPzuxp5CJ?=
 =?iso-8859-1?Q?fX2Jexw7+wdFTFggN30r+EkA+ihVS4mf5ZbcoEuCdVgHqrEhIb/9VtrKb0?=
 =?iso-8859-1?Q?GR2kXoatYbCpyYHhanoULtSsmF7cSmVEKGdyYpeahrOSPODMVLeYvB0Fut?=
 =?iso-8859-1?Q?zFX0ALHC1eHc+ConHQJzJrQpfTYHXnAowdogQeuR1qEkxYTwfiXe3xTGtu?=
 =?iso-8859-1?Q?cWhJVrhlVdtOcojJKyHtLuZq8E4Ya0TWQhPUyqZ0eDQ7wQZi/Wt3xp6EMU?=
 =?iso-8859-1?Q?zgyUxO/sODrZI7EpeyZF5pfVoQkS4UMYIcL6kR9E8ccxzgcD2HEIcE1efM?=
 =?iso-8859-1?Q?8TSaaZ7CahTADhbrxGuIPpbEF2NhIArTni+4EPzyxnOC9n+D2AnCRPFL6s?=
 =?iso-8859-1?Q?gxj4KgP2zOYV8o32ZC9dzrhoGPD8EY71HR3Q3/4mmk3RS4chRJwAYTV07n?=
 =?iso-8859-1?Q?pDflfGfoBmgr/CxoUPX20lOxzcUAA5Fc43jQv5llTXVQn7xykAeMdkiYtl?=
 =?iso-8859-1?Q?ZHvgdaYeTYVuhdip6M+j3R17zthTzE0H66z9PsXFWrH0PUiEOlIyKNahRk?=
 =?iso-8859-1?Q?XuS3yTKXWp?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a708f78-4e72-413c-7501-08d95cb7e83f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2021 11:05:19.3087
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q9JAmcR9AMaRWvemCuKs8Azp9DdrsTixUDMT3sNuXC3Ompp/fmHuKzGIzEjTXuLqxpFsBYAE9mLK319ayN1RhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7719
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
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Aravind Ramesh <aravind.ramesh@wdc.com>
Reviewed-by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: stable@vger.kernel.org # v4.10+
---
Changes since v4:
-Picked up additional Reviewed-by tag.
-Corrected Damien's email.

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
