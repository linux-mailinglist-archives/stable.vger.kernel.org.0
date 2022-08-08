Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A89958C183
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 04:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241894AbiHHCXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 22:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233305AbiHHCXS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 22:23:18 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3E32F3AA;
        Sun,  7 Aug 2022 19:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1659924020; x=1691460020;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KWc9M9OajIlzqTq9MqxEERamV0PcKnKs8Sz+9Qm/Wg4=;
  b=mbdvj4J4RNsi6l0pIHkjdyE55nFzeub/RywrNFeqWvg94xXe4u9g8oO8
   NKn0W7wIir/HrhhZ1lzTeMWB005FKch9rz+8Q5HlL/uiDXUcR6SzatYMI
   1Db1d+1OOn7BVN4pDSuQCODYVy5I0xereRhPkJy8MFRyA6zA3tUqCmKI0
   irblQrw60llT4ys4hEtCT346i/yrNXR/OTLkYULXckuxfIz1srMDta6wb
   NY1jhtSZnkyWQSWSyAkIq/Ec5ScRZOWVrXwJq1YQULT3MttsxACd1uOx9
   i9mSu//GStQA+X8WszIS8z2dBwQaIqekycDMm+LnXJ7yyEl53XxOFBZBw
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,221,1654531200"; 
   d="scan'208";a="206590294"
Received: from mail-bn8nam04lp2047.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.47])
  by ob1.hgst.iphmx.com with ESMTP; 08 Aug 2022 10:00:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dpea/beaXhUSkdG0IIlmUehMY2GFFIRYZRyIcIjNlggkcOoCtEXfeWetPI0o4KSPTvieeXUH+WSUmUXyhFBCI5TG52X6hfC8Bjg3h5JT99Y2OJpNQV2vt9fqtqBmD0a+Gn3nf8ya97mXxVUO8vfc2eDDr5cbXSozDWvWhjvDGI8O5o1S9qDdzh5j1n9x/eBXyBnsQuSr8QB9syPXTHcVbvPHR1bn1aZ77euz7ZcoxEROd4nPAA1IwjIiLH/k63MdU5HfZFsgGx8Ujc2JGwktehBEWqdLaIOA2Yq5IRLgySwCEJ8ZIWHfe+Ja9E4oEAU2oXtzIIBVVp6wVBhyu1L7lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j9HEpthF3j6wBOxHGjWHFai4z1c7iQ7DTy9P4NuUrMQ=;
 b=hG1MnghziNoG60RcKfid+lmSX4yBp6j3FPa6A81DWjDmjRIoBSt37QPBPZRdoy9B3Pw0D7A1jib6M8iT3xnV3YG5xQZoZNZTBY8FvM9Gi42C9JnWLCiLgzhTX+CC2dPQIO4jx3nwyh+NgwdfOo26LtuNDJdvpNFbmBpwrDjKY6UL2E5tWHXhyuembgPKczlNUsVthu5jUcHzwyim9ep+uaoZM/CWTW0bw0lquYqxBB9g4dslp0FX+0ZYkpQ/Go1sOVpUK/su5wpLzhv6iv3DfHIoUZyv8Usgky5FV5NUnY1EL98DxpaCkU0j7GAKqkLI83BcAVMyvZBQBRnMNr2H0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9HEpthF3j6wBOxHGjWHFai4z1c7iQ7DTy9P4NuUrMQ=;
 b=f8fKI62IccboA+qlgOC0aeHvxJBBBKBxRKmobZehbSKBZou3pbkP9nkM61pWKQVMKJXeOSsFQf49k2y5EZKfeTyWxdZrDehRk9eNzZMiVJe8AW33JHIjVJ+t1ebf3Dw8Z0dQefdzanlo2EH/eykV1T3LtWu4edkhaD6OYw1GKss=
Received: from SJ0PR04MB7776.namprd04.prod.outlook.com (2603:10b6:a03:300::11)
 by BN8PR04MB5858.namprd04.prod.outlook.com (2603:10b6:408:a7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Mon, 8 Aug
 2022 02:00:03 +0000
Received: from SJ0PR04MB7776.namprd04.prod.outlook.com
 ([fe80::9865:ab44:68b:5d5e]) by SJ0PR04MB7776.namprd04.prod.outlook.com
 ([fe80::9865:ab44:68b:5d5e%6]) with mapi id 15.20.5504.020; Mon, 8 Aug 2022
 02:00:03 +0000
From:   Naohiro Aota <Naohiro.Aota@wdc.com>
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH STABLE 5.18 3/3] btrfs: zoned: drop optimization of zone
 finish
Thread-Topic: [PATCH STABLE 5.18 3/3] btrfs: zoned: drop optimization of zone
 finish
Thread-Index: AQHYqsa1HGayv7/dg0WhaQi3VdXzr62kP5YA
Date:   Mon, 8 Aug 2022 02:00:03 +0000
Message-ID: <20220808020002.t4hyniy5d4lwxvle@naota-xeon>
References: <20220808013210.646680-1-naohiro.aota@wdc.com>
 <20220808013210.646680-4-naohiro.aota@wdc.com>
In-Reply-To: <20220808013210.646680-4-naohiro.aota@wdc.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a12f1ac-ad0b-47d2-6bfb-08da78e1b558
x-ms-traffictypediagnostic: BN8PR04MB5858:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 13ctpql3LoraTMSFA8j44dWFiToFOxBCeCvJ3gQqPX4LJNdGoT3oPglSRSbxmuYPiH5M365jSIKBnOu690d00ZpOB+h1ixcb0qO5oX8DWbOwjTz/Bw58S040USCM7LvY09qsrfbYf6556QaeJ5IC4PqqnUmHzev4GGPGNGk4MFfOxbyVlbUYijg1BfgdO75a4UhuNhs0rFvJt8V3YZZ18JQRazP5xweiB7d28i3W8Rt6W8libPsa6Z15uIB4Br4ClY0hGw8/bWkWXpvobCrLcq+DCEJ0Rtq7nezb8L3Mf5cA8g/Vk10jeTngOIW56BrP3iawIsL6DjnoDLuoOUUM9LIxjx7dIl4nBZkBBA8hs5EXXb1VugRJ/OCeqgRKAzsU7sIgc8uJ3Vf9mWfZJEctwEWYrWCAIwBPxnRG/bkEHaaq/DURowK6IQu86Rk+QUrgN06GivysFI4R+CVRU2UYxv1TQ/rnBYIz4uovRMs/QJAWgBG5KiLAiLg9VjmKig82GofD56xzc8h54C1q/q21bV4QBUhdb9ULtWIV9qL4mC73/nZRj0MyVa9Gd0/LJzS5W9gK/Q+MbWhBz112PphVLfAhXfNE1IGe9Gj+20JflszM4vsn18bYRX2j7g2vgPb3W0Q011Y7kjbzJ7gyZn2zh0t6IRUFzqqQPlvysLqzOsSItFun9DBfy0p2CCtvww7F2SD2g7FB3fftU0y/rb9akeuBAKINgNsxZJrcyprlXBg6L2coRblAYyZO7D6BqJHPEdCrrO0CMoGlRFIK+FXuXrfy00ivUMMOTv6Er0twp7MDEt3MUHbb+7NHbp7JeEYS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB7776.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(396003)(136003)(346002)(366004)(376002)(39860400002)(186003)(41300700001)(86362001)(1076003)(26005)(6506007)(6512007)(71200400001)(9686003)(122000001)(33716001)(8676002)(83380400001)(110136005)(64756008)(316002)(54906003)(91956017)(8936002)(66556008)(76116006)(66946007)(4326008)(2906002)(66446008)(478600001)(6486002)(5660300002)(38100700002)(82960400001)(66476007)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?74d59xrA5Z3OY6ko3vCiq8QHS7s3xFLaYSZZogDZhP7Uvd+4WTR3mcja1+i1?=
 =?us-ascii?Q?yAWFdFPER8KNKHoA8tCHB7AIjoijkXM1Mc6iu9Qg+g8vbcXsgozE3IO4xUAm?=
 =?us-ascii?Q?rW/VuNI4Z83vsDE9j2wLKQV5bUr/dnaoV3kgU19sJ1YW8A+yPy2/hltyCxIw?=
 =?us-ascii?Q?FLnhii7lyh8TYlqhfKBDqw+Iv8IJv8xsrgWh6NGEa7JLC96F+1oRjqbyEDcv?=
 =?us-ascii?Q?csrdRLpWuUagWLu6OJeeZOzX6cJm9hd06K4pYiGZ5DZIxqcr2ZfzsQCOgkPn?=
 =?us-ascii?Q?PStRbYcXahWXfEKeMF81FZYgtRzKls2zEnMJz/tBXQec0OZhCZkmuzmC4e88?=
 =?us-ascii?Q?uNZglKIqXCcZfta/8xXDxoCIZerKbhIMfOqYlTCgGQJHD1EvOnIKOERuJHU2?=
 =?us-ascii?Q?fVAJdtJV/ALfqGP8lizl1nlnVPVltQBOXQYfxITPuMPAxLOmAySSqsEDOfdQ?=
 =?us-ascii?Q?sRoYyrZ3ry9qKJ3SYbPj5PGUUpQSxApqu+Z7FBzM2ffqlGXHBuVUmsH3UbiM?=
 =?us-ascii?Q?/mc87qFytp+O4G5LZ3dJvAJ3ayR0QpLQefX27XhF2Cs4LWMkXlnCdTHfOM0R?=
 =?us-ascii?Q?fS0aMTsk4um+qZ+DDtAFEtmPlEZNhSxjXRY/sRx4b5hmX9/bnbpmYsOTyeSG?=
 =?us-ascii?Q?7ix3XiY4dGv64hXX4T4itZoRyeOPng/TlYuww3ntwewg3Q42lr4d2KTbg0ma?=
 =?us-ascii?Q?pPDsjcufuE7LLzOVOkJZmPKuOl7Ss1bJ9JdAkDhy5LvCsGVYBDOGyJ6E6gwd?=
 =?us-ascii?Q?PTJMspzuqoPHhhe1qI3T2BwDBDsxiYspZ4hzZbRp2ULcvKZgQco2mXxDhgAn?=
 =?us-ascii?Q?gFScKarbL4owcAuarNFuPIbUGaUYX+ANu8KKz0N2dgVn195wrk+4JYGdGUre?=
 =?us-ascii?Q?SeXhQ7GH7jBuibR8cLu3YRwQsQESSnr6YnTBpCJlWdETBkUTYF57imBu7FfP?=
 =?us-ascii?Q?HH3Fl/gtc0FTkuzPYaeZPSwKy4Un+0TfW3PTSxgq1bZYblOO7giqGOL14GYd?=
 =?us-ascii?Q?XY2141XCKSYsVmx3o8afTfex6uM+vudgVzMMx+J23n18nsa2kISXSeg4hi13?=
 =?us-ascii?Q?EiORgvogRvn9Kv4RDFub67tG4xwj83S9pynReo4euqZ6EUJtdhzmg0u0uLM2?=
 =?us-ascii?Q?Z64a5aiBzB9t1MeTdwKe/LoakaQBxOA9ohn2BeklrbzDWJ0YXe5Rbo619VlO?=
 =?us-ascii?Q?ziPjiAtC5lRgFYgfOR66v0xm8aBKGio6/douCpLZ+cwFUZ83gOmddRUJDrc1?=
 =?us-ascii?Q?M8TAV/nYFYI8pPjgb4a16+Vh+owj4CTTpEz39J45S8reqevQsk8uJRVfgjnK?=
 =?us-ascii?Q?/noaDfuhRjctfpVIFldHDGJnq+zqIf7eMWcVu49IdxU4U6shTZ56uAZqYLg+?=
 =?us-ascii?Q?hhMrDyUSc30BXKR4NiHC0gz42T3hTXfD9pQVEp3WMp0IbImNN/uEL3lsMjBW?=
 =?us-ascii?Q?6QMfoWt2Vwiaz8bdTbFtsMzioJhAiE96L4NI/8wFazKxF7B4z9BQdFXfAhEp?=
 =?us-ascii?Q?Va3n9LSOwwJ78hcJ4BTyCtDNR3eKaDCVy1A0pWPpIlpZogCLpH0zaAuYNS06?=
 =?us-ascii?Q?UaBKeL6TT0nu+PVH6vmpEI2heFKlEtcpgqq2yKBZQXQ/b7n3bQlT9qKSNM9Z?=
 =?us-ascii?Q?WQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B54DA94FDFD1A74EB8DED75381C326AB@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB7776.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a12f1ac-ad0b-47d2-6bfb-08da78e1b558
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2022 02:00:03.1166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vgmnEdukubEznnBw7r2d1PNb3NsJCbT1OfMguAsXOqEmMJFqeDC2DJuH+HUGnm3/K02GlTO0DEbnSsrcjzLNsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR04MB5858
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry. I forgot to amend a line adding "int i". I'll send v2.

On Mon, Aug 08, 2022 at 10:32:10AM +0900, Naohiro Aota wrote:
> commit b3a3b0255797e1d395253366ba24a4cc6c8bdf9c upstream
>=20
> We have an optimization in do_zone_finish() to send REQ_OP_ZONE_FINISH on=
ly
> when necessary, i.e. we don't send REQ_OP_ZONE_FINISH when we assume we
> wrote fully into the zone.
>=20
> The assumption is determined by "alloc_offset =3D=3D capacity". This cond=
ition
> won't work if the last ordered extent is canceled due to some errors. In
> that case, we consider the zone is deactivated without sending the finish
> command while it's still active.
>=20
> This inconstancy results in activating another block group while we canno=
t
> really activate the underlying zone, which causes the active zone exceeds
> errors like below.
>=20
>     BTRFS error (device nvme3n2): allocation failed flags 1, wanted 52019=
2 tree-log 0, relocation: 0
>     nvme3n2: I/O Cmd(0x7d) @ LBA 160432128, 127 blocks, I/O Error (sct 0x=
1 / sc 0xbd) MORE DNR
>     active zones exceeded error, dev nvme3n2, sector 0 op 0xd:(ZONE_APPEN=
D) flags 0x4800 phys_seg 1 prio class 0
>     nvme3n2: I/O Cmd(0x7d) @ LBA 160432128, 127 blocks, I/O Error (sct 0x=
1 / sc 0xbd) MORE DNR
>     active zones exceeded error, dev nvme3n2, sector 0 op 0xd:(ZONE_APPEN=
D) flags 0x4800 phys_seg 1 prio class 0
>=20
> Fix the issue by removing the optimization for now.
>=20
> Fixes: 8376d9e1ed8f ("btrfs: zoned: finish superblock zone once no space =
left for new SB")
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/zoned.c | 22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 2c0851d94eff..b6b64da3422c 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -2039,13 +2039,25 @@ void btrfs_zone_finish_endio(struct btrfs_fs_info=
 *fs_info, u64 logical, u64 len
>  	spin_unlock(&block_group->lock);
> =20
>  	map =3D block_group->physical_map;
> -	device =3D map->stripes[0].dev;
> -	physical =3D map->stripes[0].physical;
> +	for (i =3D 0; i < map->num_stripes; i++) {
> +		int ret;
> =20
> -	if (!device->zone_info->max_active_zones)
> -		goto out;
> +		device =3D map->stripes[i].dev;
> +		physical =3D map->stripes[i].physical;
> =20
> -	btrfs_dev_clear_active_zone(device, physical);
> +		if (device->zone_info->max_active_zones =3D=3D 0)
> +			continue;
> +
> +		ret =3D blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
> +				       physical >> SECTOR_SHIFT,
> +				       device->zone_info->zone_size >> SECTOR_SHIFT,
> +				       GFP_NOFS);
> +
> +		if (ret)
> +			return;
> +
> +		btrfs_dev_clear_active_zone(device, physical);
> +	}
> =20
>  	spin_lock(&fs_info->zone_active_bgs_lock);
>  	ASSERT(!list_empty(&block_group->active_bg_list));
> --=20
> 2.35.1
> =
