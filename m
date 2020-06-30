Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF1620EC53
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 06:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgF3ECc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 00:02:32 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:62931 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgF3ECb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 00:02:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593489755; x=1625025755;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=5tuWE27tRr6urZj1/Zj0VhZltC9K7Bp1rpUqp3vExP8=;
  b=XlLxS5ez0BmWnbHlAaeo8MrZPRG8UJN+i3TjkJgeISq6cpZ9QNXx5+9a
   7jiUbgQjFGJJJ0+GvV6rjbHuZhig3dxn5PdQoOBBEYCmdlv3ZWykuli5w
   XFmvCD56CF61JwfSdWIEZQZjQJkTAJnhcBvC+/30EdotIc4A+qVlqjwDr
   fmEMGzGrnlUpaehFQj4WOkO6aAD49AqFE0dyl+cxggmwzoZZTobhSLM0j
   4zmQ7eGy3qatRwvL97e8sCex1BT7hIg4NiU2CXf0Z2cUDP0tmLXGmQz4Z
   v+yxPmrsCtY5Q7ug+TOQkomXgE5bunrHMdX/811++eDe8g/ACfPXwwWhd
   w==;
IronPort-SDR: Yya1tli1Y8dQxm+Eov7d5XWwgcOy6+X1RNbiNocQsnb3Lg2tlmniJ714Na45mr1Ua1YXZHGE3p
 Gd9gonMC8kv47nnC8KRQ5KnMFrzkobNkH1BfffQjcXsyVH/2+yDfF7VkMppKZgGEQbD8sfzvtR
 lOD1jJeDy39QKFgH7zkGx5x/oteQAijX+V1vZKT7EcXjqmzb/lNVmXaYk81RgcoteJ7o1oNWVH
 +ACGZzby/eEmO+OT7uDlylKiHHdXqR5cRLqISLiNtN1Rx4rxIrmf/OFlxtuTAbNfcZBbcdGgbF
 DbI=
X-IronPort-AV: E=Sophos;i="5.75,296,1589212800"; 
   d="scan'208";a="244260985"
Received: from mail-bl2nam02lp2052.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.52])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jun 2020 12:02:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TGDDgeelWaLIfcB37Gzzbu6tUvQAGeRZ1VANbIcbHEt1vg/rjUKeSDoK1okC/tCxtD60lmddz764YqldjKc4WjR8MtB5PDLnUmSVt7r0BXsOH3YXWPvQS6xpXahd/cAkQCq9KBn2CuZyqDxrcIbZ3TDgXrERr5fiSULWvoo+YgOG1Y3D5cInETVRmsjbS71cTh35dTDc/DmzADRCjYFIVtXLPhPhRrHuh0M9f10zxZYaVDgr/EpJYxBBGPiVtZObUzxuS7P3gdh+/48vCRv4d1kEfWF9Bnfoz6j34VkFWa8HuOblW47uYiRrcHv1WCpOCQd2FUcptL0k9CGvzJznBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HOu/kVEb74LOeH0GnjZJKi+f/vnANVAoBPZCvYErhqg=;
 b=EwxgslVMWLAjk9ToStDIjA/VaVstV+abPc987XV1CL13g5vz4Q2on4qGuRTwhxCZ3NeymS0OvxmEXFMrh+sv/tUfmY0S91KGaFQBEDkgl5v1zxewDXXnCh4pCii9gn15pX3HxV8c4yVEqrchtvqiwLRF4pYR9zzFFt0Fj6hAlSCXb1Ua0q9r7ZTdRB1uEaYLc7/GBmwawY1u5z2DpNnx2xe4rAdP2MBbrqY/2DnNA+s0tzKrWY0yOH6k1N2yHU2f/3mJYIVITgLAkJDEBjeyB65YToc++1b2KL8IdgilcQiaOX+PvT5MCpWDJMFz0MZ9BsftoY6Nu/boF1jc51QdNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HOu/kVEb74LOeH0GnjZJKi+f/vnANVAoBPZCvYErhqg=;
 b=Eu2mbVVL00ORm6ViGypjOlw6udZmEXD54pJ1lH9ztFHFPx0hGNFmNjJ1OOvNLbpTQEsAiPIzBZZbL9cMECrSW5ME/PyFAoyvq3oGW8NbPxfdR1oL1HWg3/MaDvLJx9Oxkoc7p32+AcAbQuZ2vhXQ8c8rAqSLS3opHCsKnyfLSAg=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1048.namprd04.prod.outlook.com (2603:10b6:910:54::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Tue, 30 Jun
 2020 04:02:28 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3131.024; Tue, 30 Jun 2020
 04:02:28 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "houtao1@huawei.com" <houtao1@huawei.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] dm zoned: assign max_io_len correctly"
 failed to apply to 5.4-stable tree
Thread-Topic: FAILED: patch "[PATCH] dm zoned: assign max_io_len correctly"
 failed to apply to 5.4-stable tree
Thread-Index: AQHWTgnc1Yse01tcckSqYPfqBgjGpg==
Date:   Tue, 30 Jun 2020 04:02:28 +0000
Message-ID: <CY4PR04MB37519130802C03EB8FFD4A67E76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <15934307097203@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=wdc.com;
x-originating-ip: [199.255.47.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: aa5de79a-2633-4f0d-1760-08d81caa6809
x-ms-traffictypediagnostic: CY4PR04MB1048:
x-microsoft-antispam-prvs: <CY4PR04MB10485FECA2A478E480034A6FE76F0@CY4PR04MB1048.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0450A714CB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RxLVHN3Lv8NDH7vl1L+gm0LpbEDWjX6GSR8jdKpKpec980KZ4rMc4PQ5p+pMQUsXmF1zcjgWFfZXKVvS/29rCjIzb7Hd2NaSF97O9wJvJUbKH7gO6MCr/rlAav9gVMM+uqynq8Ar4gHEPKAqFh05e+rvoNdiYVeds596ra9PGXLUAfgHg2TShGKFWEk7jfF8+BHvUrSVBT8vEfcRIu7JsoFmfoLnUdWZfoKKqg/9Q8w/qCsW0vQ8ttkVuBZbgA2F5IIdYHZrnHQjp35lNIcKkWjYuTGlb0xXm69tnpFA+TlwzWvm6Aymop2r+GlfeUdKhD4Wih8VRMTOhVb5ZN33ww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(39860400002)(136003)(396003)(7696005)(4326008)(5660300002)(2906002)(6506007)(53546011)(76116006)(478600001)(83380400001)(66476007)(66556008)(64756008)(66446008)(186003)(110136005)(66946007)(26005)(91956017)(316002)(86362001)(52536014)(55016002)(33656002)(71200400001)(8936002)(9686003)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: WaqVSS0aSG8spL3qFs84CF5uNcTp9APH413qv92MYDMBijjkBYIhkOb8zg+SdKvnBFZqZ2DueXrl0dtXMacsXF1OmTvabgsRyEbIBtPIuxyhAjm0GYG+MX6soswh5x6w3gzwMN7ra/+C4gSsPq9+ssvMvt7gfuCxVuNpyxklUDU3WvfuEDsVEO9pi41Bct0UyQB6ubtCrW2kAlgCSe1YULpPqFlATmCh4WEBOg2B5gLiC/9uHcwh3mAmExZn6dTL+1tpHarrlxq2LayklCuZnmAa0sENqDUjb2Ka2p8PyOVWS6X/EGdO7SiLXZMYG7nluuzh/NxAwMMaf+EBF5LraIvTQ9t4A2KnfSDSkEvyYSoV3zL5PcjUgibxgLedyufPyOGrf/94z9/KdaCtPHz8wmYL8b8DyiiDf4Nj9HMTQpJr2wyKbPr/ISMu0UBA+DbKKM8eRggCYIu9vn8nxgIoqhU3VkV6protuA33tkn18vk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa5de79a-2633-4f0d-1760-08d81caa6809
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2020 04:02:28.6430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FOtgPMz6VFbcvH2LyUqubxYoU+FaNEcyVwrgv+5hKWSIT9fbHRc7hroqaH8tryq7mBdu+aCmIxAVVuZ4+7G+Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1048
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/06/29 20:38, gregkh@linuxfoundation.org wrote:=0A=
> =0A=
> The patch below does not apply to the 5.4-stable tree.=0A=
> If someone wants it applied there, or to any other stable or longterm=0A=
> tree, then please email the backport, including the original git commit=
=0A=
> id to <stable@vger.kernel.org>.=0A=
> =0A=
> thanks,=0A=
=0A=
Greg,=0A=
=0A=
I just sent to you and stable@vger.kernel.org a fixed patch that cleanly ap=
plies=0A=
to 5.7.y, 5.4.y, 4.19.y and 4.14.y.=0A=
=0A=
Thanks !=0A=
=0A=
> =0A=
> greg k-h=0A=
> =0A=
> ------------------ original commit in Linus's tree ------------------=0A=
> =0A=
> From 7b2377486767503d47265e4d487a63c651f6b55d Mon Sep 17 00:00:00 2001=0A=
> From: Hou Tao <houtao1@huawei.com>=0A=
> Date: Mon, 15 Jun 2020 11:33:23 +0800=0A=
> Subject: [PATCH] dm zoned: assign max_io_len correctly=0A=
> =0A=
> The unit of max_io_len is sector instead of byte (spotted through=0A=
> code review), so fix it.=0A=
> =0A=
> Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")=
=0A=
> Cc: stable@vger.kernel.org=0A=
> Signed-off-by: Hou Tao <houtao1@huawei.com>=0A=
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>=0A=
> =0A=
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c=
=0A=
> index a907a9446c0b..cf915009c306 100644=0A=
> --- a/drivers/md/dm-zoned-target.c=0A=
> +++ b/drivers/md/dm-zoned-target.c=0A=
> @@ -890,7 +890,7 @@ static int dmz_ctr(struct dm_target *ti, unsigned int=
 argc, char **argv)=0A=
>  	}=0A=
>  =0A=
>  	/* Set target (no write same support) */=0A=
> -	ti->max_io_len =3D dmz_zone_nr_sectors(dmz->metadata) << 9;=0A=
> +	ti->max_io_len =3D dmz_zone_nr_sectors(dmz->metadata);=0A=
>  	ti->num_flush_bios =3D 1;=0A=
>  	ti->num_discard_bios =3D 1;=0A=
>  	ti->num_write_zeroes_bios =3D 1;=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
