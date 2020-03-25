Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B08A6191EF6
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 03:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbgCYCX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 22:23:29 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:45352 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727253AbgCYCX2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 22:23:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585103007; x=1616639007;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=ogt87FFyUKj4vlLNQfa/tXCoRLXaYp6vbYtMAQ5o1AE=;
  b=KW9a4Oq099LXGQ3ujX+vIOb+wITQFZ9D5DxHpk+dl+cfuzDCVBu6VgBr
   01EWMfL6l6muyr0lkCgVOK86voHbMuZbARNUv5hwPxhmNPygbOgkIB1+S
   SdNp6Vdyyaj2dEpsITaP83e52XQIx/OAQAkbnnALRxVXY0ckXL8dlCmH0
   bmONsBL0KwulYH9WXikyIeKCUoJLmquY+ZLaYVcdxheLw68/jZ6/dUtRo
   KjYVZbZw/ZIsyPICvYLs7PU0iOfZ0SxB/3+umDN8S+FMjyubcA13aP4IS
   ry44B1yF+LxvNdHF70/orIExOW4dr/CLQf51dcJQzIBGjvNAyb9ciQt9e
   Q==;
IronPort-SDR: uqYqLkekC/pUNejQoIKVrWYwqsHzaTZ4J7Xy7Djf6gjKjfeiQHbuKyIPombWnmFAynRK9snmbW
 Hj4P+BO8EoI6vyxyVuVJ2eP3UDL0lEctWhb98V63i3gTUI8niwASrYOgWLtqkEIXycypGmRFce
 j3zAjL7zOKybaUnAn1j5Gohc2c6Vx/Uqb+Y+Y/szTHCOl6bjkEKIs/7opDmhTf1tJl3A1l8ss6
 yQEWIMsetK1AP30t8BGgEZoy6B2JtUfWKZT+gCObEnhkazlxqWgHDukuxz0NXqKJ3BZWGCzsy4
 XAU=
X-IronPort-AV: E=Sophos;i="5.72,302,1580745600"; 
   d="scan'208";a="133419834"
Received: from mail-dm6nam10lp2108.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.108])
  by ob1.hgst.iphmx.com with ESMTP; 25 Mar 2020 10:23:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7kqt4Cbv2DoiEd33Fhq8e5lyn4EtIdMIgD0gQZpwfbgaLtA8p6G64n+1QybK4n+r6apvwUlnZ9zaZBsl1mowfSwOh/LuatIu3ntfuZbLhTN2DwyGaGbTfmXQFJoOAGgLc2h2Rd5lEUiyLl7uzXvbpuZwPOY9dbVESe/aR5OUOETfqsWmPAJXg/fOh/hrd2dFUJmQZixUPbwrFZ3AUSYhrsRm5fsvIWfSYEgDz+ZdMosWjPv2r9WX7S/5Z5yxH9+UmFpOSQLD3uIE19hUZotM2iKYrecQEAKzfSoQYUqp7HLASIlhXApPju/+CDA/hHvFeU6z6T2Kvg6+XgSLwoNBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l3/yocq2CNftyzwGRicNPPcGiKD7Q3Tj7+tENvYupsE=;
 b=X9nwlg9ukhRNbepKEznOatwHTwCkAhi7u9/79//u+AH6F6OLPN8pS61Bwx5PDKmX8Nv7fy66qReFapqzP3KwQb/0liW27Dj8TNBrli3ngU0cL8K8aljiVsqBUKjJFKn46YicHo4T8UrmEZeEuDhJwsvPJyKikj6mCy6WvKcUg2CGHqJmg2VskysMk9GeHIjI5awafBiPe/Q3srUhlOJIh2ae8X1am8FBeEtvTUzRKvihvb6OA2/BmrLRFAIVWapMKK54oqReJsx/DQbGMbySBx+Y7PfTkgNTcVuWZJIfolLQOwl7KDrhFtYEGNLckejqV+hBttrEND7WH8he0Zw4bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l3/yocq2CNftyzwGRicNPPcGiKD7Q3Tj7+tENvYupsE=;
 b=iGh9yFv4IpzkWRDkphbwKFrDR3j6XJRWPJn+d7AcmklCzSCb9Gmtgo8bvVwi3wo/HfhTmVIVMIOCSQBym9Wg3xg82QleL2ruYyEmPfIflITOuDeCNPKVa0aGUHELx2labLe3cWiq2oevszQ0oGhateUoRLoggoVR6v+lx30zQUY=
Received: from CO2PR04MB2343.namprd04.prod.outlook.com (2603:10b6:102:12::9)
 by CO2PR04MB2359.namprd04.prod.outlook.com (2603:10b6:102:a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.22; Wed, 25 Mar
 2020 02:23:24 +0000
Received: from CO2PR04MB2343.namprd04.prod.outlook.com
 ([fe80::c1a:6c0f:8207:580b]) by CO2PR04MB2343.namprd04.prod.outlook.com
 ([fe80::c1a:6c0f:8207:580b%7]) with mapi id 15.20.2835.023; Wed, 25 Mar 2020
 02:23:24 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Sasha Levin <sashal@kernel.org>, Bob Liu <bob.liu@oracle.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH resend] dm zoned: remove duplicated nr_rnd_zones
 increasement
Thread-Topic: [PATCH resend] dm zoned: remove duplicated nr_rnd_zones
 increasement
Thread-Index: AQHWAd9y7bntyyl1FkW2/iZtyzwrUw==
Date:   Wed, 25 Mar 2020 02:23:24 +0000
Message-ID: <CO2PR04MB2343A87740F1201B0DA3EAE2E7CE0@CO2PR04MB2343.namprd04.prod.outlook.com>
References: <20200324132245.27843-1-bob.liu@oracle.com>
 <20200325010157.62A0220719@mail.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5a250248-a74d-4408-092e-08d7d0637f0b
x-ms-traffictypediagnostic: CO2PR04MB2359:
x-microsoft-antispam-prvs: <CO2PR04MB23595F1BF676E0CA2DB6C589E7CE0@CO2PR04MB2359.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 0353563E2B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(66446008)(64756008)(53546011)(4326008)(66946007)(91956017)(9686003)(66556008)(55016002)(7696005)(66476007)(76116006)(6506007)(316002)(5660300002)(478600001)(52536014)(2906002)(71200400001)(8936002)(33656002)(186003)(81156014)(81166006)(110136005)(8676002)(26005)(54906003)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO2PR04MB2359;H:CO2PR04MB2343.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G2kP1dbEmGURN3XgAFDCDPD1jLwb+M7kPew31GI34s03WzKux0rpeu1dW1/hb5WSUhU85ZRzkgfJzREShG6RFkf6mERC41NMKdDJpTIc1zL7my6G3iw3sBuTgwzslFl2mjbJ9MrDf2YI7/r8JEZdlhbunCElboCgsk0J5iqoc+W+ktrEt5zUpsjhkZIahV9Yq23/QlwKZYadABiPf+RUQAJbZFRJbVOCtfgQRy9negdHq6afDM/Bt5KD00Xl2vxoJidcN5n5vuwKWU+3ytUQBjxzWdodkihbaOzI3Z3id4L3NVCrKcN6YREkRs2YuD6BhAfGWWi4YmGFNNmHk1E7EEr72NLApagAgXkfe5FOW6yjuZGQ/qInF3zMQHQe3KrRIxsnPIaxA67x/DGqqBUW2L0RW5mn5XulmPlMdO7SVLBGo2Mz9Fks/MCUkJa5oXiS
x-ms-exchange-antispam-messagedata: +cbFIS8LnhZ7WdD6tZoA4NExgQ4jZZt/yZwQoH2DRGZ9B+YSkba6SRdF1U+tudsQiB+SRwUsVIe0GYCBwsQZZTaLNIYwVQAJn8v8++M/tPY+Q8OcPrKD6lq3TbtImYo1Remt5IR2ecGAmM9bmVMSWQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a250248-a74d-4408-092e-08d7d0637f0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2020 02:23:24.6714
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0T3VnvaeYRorgXaXGUoyrseV9G/A/3eAXFc0/fMHzSg54WQfUoVBkNdX5zJT0A/jdoejbdar5bfjyaXR4BMGsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR04MB2359
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/03/25 10:02, Sasha Levin wrote:=0A=
> Hi=0A=
> =0A=
> [This is an automated email]=0A=
> =0A=
> This commit has been processed because it contains a "Fixes:" tag=0A=
> fixing commit: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device =
target").=0A=
> =0A=
> The bot has tested the following trees: v5.5.11, v5.4.27, v4.19.112, v4.1=
4.174.=0A=
> =0A=
> v5.5.11: Build OK!=0A=
> v5.4.27: Failed to apply! Possible dependencies:=0A=
>     5eac3eb30c9a ("block: Remove partition support for zoned block device=
s")=0A=
>     6c1b1da58f8c ("block: add zone open, close and finish operations")=0A=
>     7fc8fb51a143 ("null_blk: clean up report zones")=0A=
>     ad512f2023b3 ("scsi: sd_zbc: add zone open, close, and finish support=
")=0A=
>     c7a1d926dc40 ("block: Simplify REQ_OP_ZONE_RESET_ALL handling")=0A=
>     c98c3d09fca4 ("block: cleanup the !zoned case in blk_revalidate_disk_=
zones")=0A=
>     ceeb373aa6b9 ("block: Simplify report zones execution")=0A=
>     d41003513e61 ("block: rework zone reporting")=0A=
>     d9dd73087a8b ("block: Enhance blk_revalidate_disk_zones()")=0A=
>     dd85b4922de1 ("null_blk: return fixed zoned reads > write pointer")=
=0A=
>     e3f89564c557 ("null_blk: clean up the block device operations")=0A=
> =0A=
> v4.19.112: Failed to apply! Possible dependencies:=0A=
>     515ce6061312 ("scsi: sd_zbc: Fix sd_zbc_report_zones() buffer allocat=
ion")=0A=
>     5f832a395859 ("scsi: sd_zbc: Fix sd_zbc_check_zones() error checks")=
=0A=
>     a2d6b3a2d390 ("block: Improve zone reset execution")=0A=
>     a91e138022bc ("block: Introduce blkdev_nr_zones() helper")=0A=
>     bd976e527259 ("block: Kill gfp_t argument of blkdev_report_zones()")=
=0A=
>     bf5054569653 ("block: Introduce blk_revalidate_disk_zones()")=0A=
>     d2e428e49eec ("scsi: sd_zbc: Reduce boot device scan and revalidate t=
ime")=0A=
>     d41003513e61 ("block: rework zone reporting")=0A=
>     e76239a3748c ("block: add a report_zones method")=0A=
> =0A=
> v4.14.174: Failed to apply! Possible dependencies:=0A=
>     08e18eab0c57 ("block: add bi_blkg to the bio for cgroups")=0A=
>     30e5e929c7bf ("nvme: don't pass struct nvme_ns to nvme_config_discard=
")=0A=
>     5238dcf4136f ("block: replace bio->bi_issue_stat with bio-specific ty=
pe")=0A=
>     53cfdc10a95d ("blk-throttle: fix null pointer dereference while throt=
tling writeback IOs")=0A=
>     5d47c89f29ea ("dm: clear all discard attributes in queue_limits when =
discards are disabled")=0A=
>     8b904b5b6b58 ("block: Use blk_queue_flag_*() in drivers instead of qu=
eue_flag_*()")=0A=
>     a2d6b3a2d390 ("block: Improve zone reset execution")=0A=
>     b889bf66d001 ("blk-throttle: track read and write request individuall=
y")=0A=
>     bd976e527259 ("block: Kill gfp_t argument of blkdev_report_zones()")=
=0A=
>     bf5054569653 ("block: Introduce blk_revalidate_disk_zones()")=0A=
>     c8b5fd031a30 ("mmc: block: Factor out mmc_setup_queue()")=0A=
>     d41003513e61 ("block: rework zone reporting")=0A=
>     d70675121546 ("block: introduce blk-iolatency io controller")=0A=
>     e447a0151f7c ("zram: set BDI_CAP_STABLE_WRITES once")=0A=
>     ed754e5deeb1 ("nvme: track shared namespaces")=0A=
> =0A=
> =0A=
> NOTE: The patch will not be queued to stable trees until it is upstream.=
=0A=
> =0A=
> How should we proceed with this patch?=0A=
> =0A=
=0A=
Fixing the conflict is simple. Bob or I can do it when Greg processes=0A=
the patch once it is upstream ? Usually Greg sends a notice for such=0A=
patches that do not apply cleanly.=0A=
=0A=
For reference, the fixed up patch for 4.19 is below.=0A=
=0A=
commit 48414897d7fde2c2a561a9f6d4b58b62ccb63e68 (HEAD -> linux-4.19.y)=0A=
Author: Bob Liu <bob.liu@oracle.com>=0A=
Date:   Tue Mar 24 21:22:45 2020 +0800=0A=
=0A=
    dm zoned: remove duplicated nr_rnd_zones increasement=0A=
=0A=
    zmd->nr_rnd_zones was increased twice by mistake.=0A=
    The other place:=0A=
    1131                 zmd->nr_useable_zones++;=0A=
    1132                 if (dmz_is_rnd(zone)) {=0A=
    1133                         zmd->nr_rnd_zones++;=0A=
                                            ^^^=0A=
=0A=
    Cc: stable@vger.kernel.org=0A=
    Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target=
")=0A=
    Signed-off-by: Bob Liu <bob.liu@oracle.com>=0A=
    Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.=
c=0A=
index 086a870087cf..53eb21343b11 100644=0A=
--- a/drivers/md/dm-zoned-metadata.c=0A=
+++ b/drivers/md/dm-zoned-metadata.c=0A=
@@ -1105,7 +1105,6 @@ static int dmz_init_zone(struct dmz_metadata *zmd, st=
ruct dm_zone *zone,=0A=
=0A=
        if (blkz->type =3D=3D BLK_ZONE_TYPE_CONVENTIONAL) {=0A=
                set_bit(DMZ_RND, &zone->flags);=0A=
-               zmd->nr_rnd_zones++;=0A=
        } else if (blkz->type =3D=3D BLK_ZONE_TYPE_SEQWRITE_REQ ||=0A=
                   blkz->type =3D=3D BLK_ZONE_TYPE_SEQWRITE_PREF) {=0A=
                set_bit(DMZ_SEQ, &zone->flags);=0A=
=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
