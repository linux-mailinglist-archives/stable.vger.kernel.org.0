Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562C82A5A9D
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 00:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbgKCXhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 18:37:24 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:19017 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727921AbgKCXhY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 18:37:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604446642; x=1635982642;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=0xZ+QXX7Nr+ul5VwTrsIJVu6P416Pz/c7tDGl+FYAm8=;
  b=mxEjDXz3wOVTOz1sdaVZbFLybcJJPOMtOz3XeOvwnPSJ03mJ6DDIxwhc
   Y27ID7RNEzrjaPewMBZ7LLbVyOg5izCVRejWtLpRZytdO9PXX++rgkBBa
   gmPHjtFGE4wkeBESUEnv3ecigX7kFQtBv87Lf0U2n5v1ELdJpJxjMC+dX
   Hfv5JSdauQ4FHBLFPd0FMlvNCmORoKUVL9XQV/eGPlk1dDvtMB3ttczvi
   Lao2mD0UVAUTXgcjVUXeOWyg/TZvXK2ndm1WjTNjXfnkf0fxICMRX0QYf
   kgrMn/qRYp/6A6460XGz4CI8ZHKZ5c2p5nG+FDp4SJdFXHM9gAaNTGjyQ
   Q==;
IronPort-SDR: zPN7tyoBvcTl0Y5/ho4SqUcrE+PosvgyeEhf2HSSZGlfCjTxzEGU6wahLgjNSPVH3gJNeKMOrQ
 TJ3+Cri8T1k0TubBGUT1ldAN3BD5xtCE3HErVoGuuFSreLAbF2l5BcW2ov+3znhf6exZpDihg3
 HRP2eFvIp1uL9mcQNFX8altUWpOCWaBLkSUpDqKXuhtkCdITxlo3/WWaDsNIUK1ECJXYj708lc
 8uFZnXwahnHmDQAWvElRZKu59a+pZJztKS2fiFxS05D7bHO8FGL+Jn4bl0xt3T6vs9FSNdmVF9
 /IY=
X-IronPort-AV: E=Sophos;i="5.77,449,1596470400"; 
   d="scan'208";a="156202773"
Received: from mail-bn7nam10lp2109.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.109])
  by ob1.hgst.iphmx.com with ESMTP; 04 Nov 2020 07:37:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DjAXDrYzrjbRfVllN8PTNsaMSQm9yPkbOKWWYkBTPZI7VPwowmab7cBUDv/Y2C/cwRy5McrXtgI2HQua4PRsMIGHEuEk6kuAnJRbaOxjpz8jOAp5EYNZM+0Ej5VFeFqCQDVo+AjjcB6cxoJjk7+4GcYbmP7HSFbvbN3SI6QlOGGBn2sNEKZvEo7ElTGophXtmPJIRTFeLtGbuMF6uwz60YmR8meV8ERpv58p2pG+pCxf692IBWTg+7SQH1DmHf2E0jvRYrVPFm5gGSwv6N4dSdnN+Y+2D83C3GddFizhsaLkAYMnakr1PFYNR124kJ3WrRjzpfvNH4sVhtewDHQmGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uJLg8awuBQ9TrjlituHAmvkFZKgSS1uUO24dKxvLjiY=;
 b=EKgC36/baXlV7OLHdFn4ZaBJRlu1u1t2ZkeqhXW0dWwfsBQpP5NbjJjfJTx0Wqwznp0M0rN2w+F5t4i/SeFJot04dZrLkfSjnvkzzrtZFtHHzNKNUMP0umGB4e2ESCtlem5oTY2JlnweMalixQ+aO/PRynrgfY0XA8ljNDO1AH0gfPZjPCvC+sycoNAsrZCsmsBJcxlck+cXJ2kkbocYCm51LnDXfvhMqAR36fgcgocku+jXLw3iwln11u1E2oJurn5VIUiFtQY7+Ja2d1Z0RCTkrKpi56mntLwOU6yBPTOLndHHXl5Wj/bRm7TBNDHuYbNIlznVm6DT9hKOClg6/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uJLg8awuBQ9TrjlituHAmvkFZKgSS1uUO24dKxvLjiY=;
 b=aTsqdzUKPNxeWqqg/EXDkqFYqBX+dCruG0sRyYIidFRdFYWIrgUkp6nVZMNdt9aR/bvNbBRouJcHVSijsgM5tF6wcG2HOk5zx3GGTRoimLAHzA2wmzpzQ8nt90RD2NLs0cPiMCTRkAbauIOtVOZ+ddV78cjw/b8DPVfI7R2h5UY=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by BL0PR04MB5092.namprd04.prod.outlook.com (2603:10b6:208:55::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 3 Nov
 2020 23:37:20 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::4c3e:2b29:1dc5:1a85]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::4c3e:2b29:1dc5:1a85%7]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 23:37:20 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] null_blk: Fix zone reset all tracing"
 failed to apply to 5.9-stable tree
Thread-Topic: FAILED: patch "[PATCH] null_blk: Fix zone reset all tracing"
 failed to apply to 5.9-stable tree
Thread-Index: AQHWsezm7sY3moroREuF64NpAdGRHw==
Date:   Tue, 3 Nov 2020 23:37:19 +0000
Message-ID: <BL0PR04MB65144B8F266B12EED5DA6B5BE7110@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <16044134474538@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:830:5e48:69b5:9288]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 83e52de3-516a-430d-c45d-08d880516820
x-ms-traffictypediagnostic: BL0PR04MB5092:
x-microsoft-antispam-prvs: <BL0PR04MB50925B9F52DDA7F93FB2AB85E7110@BL0PR04MB5092.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fK/V2ck+rIMwWvKrL5obyu9UbXQl0okDIS5+LsCBWoiA/4rqYTg8x8QqC+TCoSEoU0KQaCXNj838Oawf/Xrv0qKO6ZHV0tDhqfKR4KvdDzrGrrLsqj+UFnyic7lHieLeMVhzuhCQToswcnXD/xevCvcPfZMzUqPT202SEw1Y5/SsbOCYj8CyPbDhxaO6sEyLTaDf9hmVCWc9RA33Bau7+6Utg605vcN7vZA6Fhw6l0agGZf+DQOeIkppuCEkbGicQy+73AOglSvASL3cZo9AJsRm97o0HOp64uycFZBSUkl7qKE2At6XNImj7L/Q3UYo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(91956017)(76116006)(316002)(64756008)(4326008)(5660300002)(71200400001)(55016002)(8676002)(110136005)(9686003)(33656002)(66556008)(7696005)(6506007)(53546011)(66476007)(66446008)(8936002)(66946007)(2906002)(52536014)(478600001)(186003)(83380400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: tF6clEC9tIXk9aUdNEsmPOOw/mtUNnM28VgvoIDXWWFhu7sXQY+yxpsOnpR6vUWORVOPfpkVkz+iU72/0IkNDai+OvIAH4pcKliNz8yUDQu/RMb78otsF/6AL2hpleFMXc+z3V4uunglQOJ4BZ5Rr7+YujQW3YgrQ6fvHNNvJHYN6dPxRuvDBhh0WOEUdCuex6j+QezMHEs/NDOVSLpu6YiPb52KDQ1m2iyAoJvAkKxb5zMHNqL0G7yz0UU/kNjtK3rYxPYOoxOOkQdK56v4YSlQOU+TLDD/ocJEeEfYNYZ/tY3hsZWHF9gb/+j2yx5nkBCQaS5qFXxzIFfbV6OrVHVM79etChX7B2r1/e415ibO4HDLO2Gxc6GqUT0HHuMVlfRNgvMVQaS1b3o2bQWGzbp8QFUyPiWGL41lH+f+bVVlbf5+djfcf2dKX4UJ6dd0II7mNUh0wDaaIVH6NMTxNpvewKfW+PTRDIowXYLVhJyB9+UYiZWmB8B3Nb3mBfWADH2UGuMjZcQZnInHhbmvnPD6waUROX88/drBvBnSIDAmJXWjEIUXwFhNE6civamvFZERVK1lGzEqvESYdVm8GZUGglnHJtxM7HeaFxi1pQE0A5kdPYdYEVa5NP9+OYXaE3d9bHY38QHG3tm3zsc43iTU8W2Tf3bBn9Nxrd13cG40tvCDMtou3+8HzqaIHUCwjuB601CFKjUgR80v1EncsA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83e52de3-516a-430d-c45d-08d880516820
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 23:37:19.7214
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y5pWvULcsiXL3fYXvlnRqHtm8TM4qWTG4MYfhDvyBaBITYbAAMD2GHd9emfcv7uE6uiAXe2Z2MuLNfjEUc1E/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB5092
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/11/03 23:23, gregkh@linuxfoundation.org wrote:=0A=
> =0A=
> The patch below does not apply to the 5.9-stable tree.=0A=
> If someone wants it applied there, or to any other stable or longterm=0A=
> tree, then please email the backport, including the original git commit=
=0A=
> id to <stable@vger.kernel.org>.=0A=
=0A=
I will send a backported patch shortly. Thanks.=0A=
=0A=
> =0A=
> thanks,=0A=
> =0A=
> greg k-h=0A=
> =0A=
> ------------------ original commit in Linus's tree ------------------=0A=
> =0A=
> From f9c9104288da543cd64f186f9e2fba389f415630 Mon Sep 17 00:00:00 2001=0A=
> From: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Date: Thu, 29 Oct 2020 20:04:59 +0900=0A=
> Subject: [PATCH] null_blk: Fix zone reset all tracing=0A=
> =0A=
> In the cae of the REQ_OP_ZONE_RESET_ALL operation, the command sector is=
=0A=
> ignored and the operation is applied to all sequential zones. For these=
=0A=
> commands, tracing the effect of the command using the command sector to=
=0A=
> determine the target zone is thus incorrect.=0A=
> =0A=
> Fix null_zone_mgmt() zone condition tracing in the case of=0A=
> REQ_OP_ZONE_RESET_ALL to apply tracing to all sequential zones that are=
=0A=
> not already empty.=0A=
> =0A=
> Fixes: 766c3297d7e1 ("null_blk: add trace in null_blk_zoned.c")=0A=
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Cc: stable@vger.kernel.org=0A=
> Signed-off-by: Jens Axboe <axboe@kernel.dk>=0A=
> =0A=
> diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zone=
d.c=0A=
> index 98056c88926b..b637b16a5f54 100644=0A=
> --- a/drivers/block/null_blk_zoned.c=0A=
> +++ b/drivers/block/null_blk_zoned.c=0A=
> @@ -475,9 +475,14 @@ static blk_status_t null_zone_mgmt(struct nullb_cmd =
*cmd, enum req_opf op,=0A=
>  =0A=
>  	switch (op) {=0A=
>  	case REQ_OP_ZONE_RESET_ALL:=0A=
> -		for (i =3D dev->zone_nr_conv; i < dev->nr_zones; i++)=0A=
> -			null_reset_zone(dev, &dev->zones[i]);=0A=
> -		break;=0A=
> +		for (i =3D dev->zone_nr_conv; i < dev->nr_zones; i++) {=0A=
> +			zone =3D &dev->zones[i];=0A=
> +			if (zone->cond !=3D BLK_ZONE_COND_EMPTY) {=0A=
> +				null_reset_zone(dev, zone);=0A=
> +				trace_nullb_zone_op(cmd, i, zone->cond);=0A=
> +			}=0A=
> +		}=0A=
> +		return BLK_STS_OK;=0A=
>  	case REQ_OP_ZONE_RESET:=0A=
>  		ret =3D null_reset_zone(dev, zone);=0A=
>  		break;=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
