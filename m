Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C043E433B
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 11:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbhHIJut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 05:50:49 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:58993 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbhHIJuq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 05:50:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628502627; x=1660038627;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vu6oQ8Xam24dhOX8kVoN1pC4n5WN3eQJ/ZQYm/9zUEs=;
  b=mSMzzVBZGl8djG50BNNqxWSvAOO1uu4+j1HxWMj5rDYTQnPiJAfEsbbj
   DieA8B7PWZjj4kq9rP8sX1IS3myfObjlTARjm9qDMqJu1r/E6lHch4lUe
   4L0TPt0ix5vcvmv9VmZVOBW8rCM992TFypPPOHghyQea1V3XvBSpebu+B
   P3zZu6TsqLl6QEFurUzSjNUH8d6lY62yecOZyeBQ/os07aSrIyirp9OJp
   rLYSz6PnmKm36hcwDNnIDQl6ORQiBIoCCvUdyBKo1wo++hq9fJvYphIyK
   3VULSdyKCBZ5XQsSryxvywc+Za4dnWxkU9mp7mKO7qnXQwXN8o90e7Svm
   A==;
X-IronPort-AV: E=Sophos;i="5.84,307,1620662400"; 
   d="scan'208";a="177231219"
Received: from mail-dm6nam12lp2171.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.171])
  by ob1.hgst.iphmx.com with ESMTP; 09 Aug 2021 17:50:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DnMCLNnNlsT/X3I0MzWAOJxm5Z0COHqVUTCnhA59Wi+DIP8XE9bDQzZCs7r5u/MK3nqf8oLQ7j4Szoo5bVvF8mDjQgCUCPsBRP+V14BdlUs4c/38Q2e4hBJdfmQfJAj4Tp4DheWqI41d9IPO8/Mt6Xo/wwlhRRVZhc9om1pjCir1o5n50bsZPVWVYyxHdEPWgAnBocH4L3VXGT9vi+pII1wCJdoIv5TSnKj2GC3EQZMyRFLsoRXz56u66U6ttHcd35QlZysRjWjQyNISYQqbfyNu9eOnUZgsTZDW8snxlOweCKLuUaDTwvCYQ9nBsDUmB0OLser12swzcrIny23yvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7W6QQkZ4HHcVc7lTzUAvNrVwYMDyWD0Wi/6hWRVQAzI=;
 b=ltC0zbWz75OOaq5hLPLb59c7XJextdOuthqJKBiWi6yA1X9QDCGKQmWzRyQX+BB6Y89Nmjc8yG83MrCosnwca9+swVuYxADJ14ufUmLL0h6fB0zcDwBbbxOgSgXcgk0EwHIk7ouJQA36DBIJNXmOjXs7lF7vz9YF9M58fv5cwZIL61OOtbN2Fic7fgw6kW376zANqrG25oSU6cHtI0puLdIZqlLHR9FylD4RZd5+1c8aRwJFh9rnlMnyOGEglB17M4vVhElYb0/8r+p0bmb2ZLHm+N72trx0Br7rSYeTBvDowP5oTZQPctC/QcUtXtiW81A4oryQtUB9MPGVonAuZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7W6QQkZ4HHcVc7lTzUAvNrVwYMDyWD0Wi/6hWRVQAzI=;
 b=c2rq2Od6o5S/1qjqH/R7FnCN8sEadsblbFDOjHO3/Eq8Eb1dmZyDlPVws0VsUZdRDNKWaHEPRmrdJvBupM6N8eccNa6WJwesEL1/zEjHYThuEKF6j30UFhqbILjF81AODWYcBhIO/BwM71kgL/K3nwiYnCTkrTCpJfyxDnPg2cE=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7558.namprd04.prod.outlook.com (2603:10b6:510:54::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Mon, 9 Aug
 2021 09:50:23 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad69:c016:10d5:a3e9]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad69:c016:10d5:a3e9%7]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 09:50:23 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Shaun Tancheff <shaun@tancheff.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
CC:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Aravind Ramesh <Aravind.Ramesh@wdc.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jens Axboe <axboe@fb.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 1/2] blk-zoned: allow zone management send operations
 without CAP_SYS_ADMIN
Thread-Topic: [PATCH v4 1/2] blk-zoned: allow zone management send operations
 without CAP_SYS_ADMIN
Thread-Index: AQHXjQP30Hf+JHmZnUepZZSsUIhsww==
Date:   Mon, 9 Aug 2021 09:50:20 +0000
Message-ID: <20210809094855.6226-2-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: f1fa41ba-84a1-410b-aeae-08d95b1b1bd4
x-ms-traffictypediagnostic: PH0PR04MB7558:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7558018B99CCD67735B73479F2F69@PH0PR04MB7558.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pxB4NvfTXYnTcBvJTcy/5UUu4t1KDMxhSnHpcoheBzjzhcS0r6L3HAExfnyQKPEe2c8AhB5fCv8MXe+EaRSRNkL707TfmIqd37DhvCB+obGKdLDEKC9HbM4/IF+v/HpXkpJY0qj8+ONIFuPWGClHpK3LwHdpSMKzXAoYTSDnoxMIkx5rGwatWNTjLk/qJDmXE8/k9tdpS9IPMeQ8xgwzmq0pAGWD1KuCGVDCRS/wMx4vvdfLPAB0u0BDF9tHHNNRMChTSa4iVNUQZyQi3X4mjOqiL53LLsPEXFUa85PIrcxKgz5XoSckMc1tFUm/dkb8dkHDFKRBvlviuycROVTRbIasBTEzX++YABzDvg9uDmOqqUphjR34+O6jC6kYbNZnS2s+NL+nvvacn2sTWpIhzBnT4kPi3z3dC8tE+Sdjyq0JBCGFMD8DQo2UUY7D+dggWBoqeioh0mA3/zEZRbOhbbA1oWjLd7ShZSvujZ9Kneggqs1v/pFCXFszRJ8/JAD2OfJk2Nk9FMVTXIYd99LbjwrSDDIuvNVdAeYfKlJo8c/Rk4hsHdp5pEi83ruc5L2om6ulVkNGIAErbKjMjxJ5IjRN9NlkihJ1/Kt6lnXk5jq6qFHgD0ru9uonmBeAWJuXB2pOlzZyGv6+HLtpGmpl5BVtsV2C+gXi6N5QZs26XZnD7CbhkDzb3ECTJJGb980nX9W/yNKA+94PMXBXOUiPnw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(2616005)(38070700005)(7416002)(2906002)(6636002)(6506007)(8676002)(1076003)(91956017)(76116006)(122000001)(186003)(26005)(38100700002)(8936002)(6512007)(4326008)(71200400001)(83380400001)(86362001)(66446008)(66946007)(66556008)(66476007)(478600001)(64756008)(6486002)(5660300002)(110136005)(54906003)(36756003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?hM+Zm1F1noi90Pb5IyA5SXGgX5CIqkcnmCOw1slsEACP+aPCxi04Nfd9sZ?=
 =?iso-8859-1?Q?yB96ct5OEELz7a7cKRs4DNbY8b7VX6vbl232ndWQguK8P6kNEQD2qwdcQO?=
 =?iso-8859-1?Q?lGiUontVwG6Rh1TreKlAV6zpRByIzej3w733L2QtDjbCznBdNzNZnjqYGP?=
 =?iso-8859-1?Q?GF8+dfcS11wNo8g3iLXyUZi64nPT5NA0B6X79Ka76TEs4vLtxb+bKkunhT?=
 =?iso-8859-1?Q?xQEO13VpM4SmEMNpXtazB7t0/CUYNl9ikTRVzD4bhZanri+pachprx9PB+?=
 =?iso-8859-1?Q?JSENvMsm9nFKQr4A4+Ies9j3om1U0Yfg0EhbNez0QcNlQc0rhGYNKsbP0Y?=
 =?iso-8859-1?Q?xGIf7HzNOaYGzXhGtOgKVB6j3O5SxbJFeiCvAEG9V6SC7PBIkXSMoRzI3M?=
 =?iso-8859-1?Q?uJ5J7Pt+kG6y2/Ze7T1rzA2C70pQHPm+cQ8vM47/dbHca4r+LCqlGRu5SK?=
 =?iso-8859-1?Q?VllVWZ8zQYzKII2/AiW0IWvJ6XL4o+b/N4NufHpzpU3LPbveCBjrn/RPHK?=
 =?iso-8859-1?Q?Vsm69EUsiMeH4H6AO8umLW9FDwQ+/W/cLsps77wkp2B7jtrM12h6KvU/Ge?=
 =?iso-8859-1?Q?SRTMbAEK2vJW92Vn0enQntEsGJT2ajOYvikeOHkE/FCd88EfcMAqHigRro?=
 =?iso-8859-1?Q?rM3vNobLGKvaWie1UnRUHD/oHzpCf08KaN7xjMCWDNJiR7u1VNfrRNg7bW?=
 =?iso-8859-1?Q?kfbWbt85IkU+HDoZq+coZXIjvXwDiupVDNjdLpOobHcByiNTyCLxyBm3Yy?=
 =?iso-8859-1?Q?8eIGgSRdfDwCFEUv5GZeR7DORmt5gdQ6Lp3yE3n3RA2QoKFYkvkAhMWNV8?=
 =?iso-8859-1?Q?Za7ONjZrkOekTK7eqfn3r/WOfB2USzUBmk2gJ9VGD9ZAux11SKdNRtXqxR?=
 =?iso-8859-1?Q?gr2uZtpRGfGRzF9g55K7yUhlsbUR/RwZ0BpQsDpjPm6AhnNtqF01echwj3?=
 =?iso-8859-1?Q?UfotHWLz/+JC9ops/nVbUaX3Pih9SL1ia9+W/QkmaBg3ig0NGuIBh92Z/R?=
 =?iso-8859-1?Q?+raCcDP5OYYbE2u6riXutpf2lbXzf/MtO+2Lf1jlhwENLphzC9JtANzSYC?=
 =?iso-8859-1?Q?0H+nJLWX/5F/zYHpHn03yzIwRsjS9LN9YS/c1NhV2p8Z7O0bsIK79PlWvc?=
 =?iso-8859-1?Q?eamupRBmL8N4mwX/Y1vyCJYWBjGStm1PHV9jwflZTwL4TQUQFRdSoYWFzm?=
 =?iso-8859-1?Q?9gk4ePdsqJ5emogu0DJZenluv1ldPAu4h2dYl5gSn0YQJRImuB6hTbJLsm?=
 =?iso-8859-1?Q?8NP/h0E5HIOoB1ldwbicltJdPKgX73sbH9+S1oCUTTJp+94Hly59P+9f3c?=
 =?iso-8859-1?Q?GWKUyRo5QxTW+JEuSYgFQGf7Y88WPohQVksQAEj+MezT36kJZOQRxuv73A?=
 =?iso-8859-1?Q?jciJcdVVXF?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1fa41ba-84a1-410b-aeae-08d95b1b1bd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2021 09:50:20.9193
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QK6+O1wL1IZv4BRP8C9cayZP5gTaRfWQo9UIeRe+P5paoKhNcfxx4ZeJz+lSSkBhr7ye0Fu0JqA1cXTceuHWAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7558
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
Cc: stable@vger.kernel.org # v4.10+
---
Changes since v3:
-Picked up additional Reviewed-by tags.

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
