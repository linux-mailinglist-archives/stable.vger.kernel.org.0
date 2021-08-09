Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CF63E438F
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 12:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234368AbhHIKFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 06:05:23 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:27936 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233772AbhHIKFX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 06:05:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628503503; x=1660039503;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=eGz6WMxkxt2k9RQwSP1AqrUbn0HuLhuBPCLJeiD+cZM=;
  b=boYqi/ZFUynCPntNCT87yE8tgqDBunjAY4W8w2bflxe3RYXs7uFfAYcK
   cyRZ+CAfq4NyB86Iy2IiScxGQzkgsN6IhoxGLMedPsTp7d5S788Z+ayJ7
   wqrEMBGrJHm35E7et21vSvVgxWq+VsUvGqXBdKGn0sRItVf843ty4i2xv
   f12lDnSQHNnqguGkwq9sMSGqCAe5okJzhluDtTuI0/qLkc42fPl27gQIR
   mycVmzSTdf4s7tR3bKkZUEohBQrFJyMVy+A1+emvt86NgmaGXOHBUro4k
   hb9C2XZlPgOiCwCPSzZD/shblUTJ9WBomM47fpLDebP5agoU/VyuYxsP8
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,307,1620662400"; 
   d="scan'208";a="288235775"
Received: from mail-mw2nam10lp2103.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.103])
  by ob1.hgst.iphmx.com with ESMTP; 09 Aug 2021 18:05:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVJ4rkGTu1Hpy4OT7gur8PXzFKwizsA3E/cM+l0HEFiu+jLHUxZ68NPkIz4TZy5ja400ryxQQO3WcnVHqiDp0Mvi56fJ2G+1QtnK0YqUGEfOp8aZhL+26h5FQmdqz1fxSeYGx3ZN+jnwIX+2muAmJozrJSeDjBh8Yznzm983hLsdIpl4UDcl9qsFBJm2hPTBvsbTD0/YQN5a5W7pgO6exvFjZur1hmaIXCMbFPsg3RpaYvJURdp1pY820nQ0cn5NzBt3OkSPqHfNw6Ln6xkmSzU56/ORiVriOG5V5AYDh+76aeIj5q51CurRp4PGM73LPdCniGchn5gPucOmIE3TfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eGz6WMxkxt2k9RQwSP1AqrUbn0HuLhuBPCLJeiD+cZM=;
 b=KwwUtIMsjxyQtfK80P1QjVVpYQFh5a74WISM38lqPrtnjnps/Toi+QlkucgcSYEpImLda4X30PfbRwXBenFsJSKLiU6SBmBXIucqYVZinizGiCYoJm6mUEQTCvNePYwpRADcf3LaMaPXBuILFtvj0U4VY1on9rjWJFc9m3XHM2kfWdYAq518/jyU//vVEuX2gtyF7yt+oPqeRSGgyTiKhagGPw9NbHFxVzEMJ9OK1nMGI6O80n7l05wfrW02F9FAvD5ihto0kf8uAEnfJHgDtKzIWO64vODH9ppDDqnCGdiPHeWavWeGmab+8wSyPaR3tNJOKmTPUJIyg+qZ4gvW5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eGz6WMxkxt2k9RQwSP1AqrUbn0HuLhuBPCLJeiD+cZM=;
 b=TgIz9rBpsUArBt+O3BJzo7l5KQvNfkaXvVCuWv1HXlizL/JuIhBTmFem5uCE5uQSiBIy0iH60v+nO8d7cGLApiSZ4b/LMTML8oKiDv0O1GTVtXu4NCAriYE2hYhdYctoMzRfmaT9fczvVeT5U+glN8B7e4Z3n+oi+9mterhvXYg=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7494.namprd04.prod.outlook.com (2603:10b6:510:5b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Mon, 9 Aug
 2021 10:04:56 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad69:c016:10d5:a3e9]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad69:c016:10d5:a3e9%7]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 10:04:56 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Hannes Reinecke <hare@suse.com>,
        Shaun Tancheff <shaun@tancheff.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@dc.com>,
        Aravind Ramesh <Aravind.Ramesh@wdc.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jens Axboe <axboe@fb.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/2] blk-zoned: allow BLKREPORTZONE without
 CAP_SYS_ADMIN
Thread-Topic: [PATCH v4 2/2] blk-zoned: allow BLKREPORTZONE without
 CAP_SYS_ADMIN
Thread-Index: AQHXjQP4aNCn2fw5YUWhEgczWRLRa6tq8fmA
Date:   Mon, 9 Aug 2021 10:04:56 +0000
Message-ID: <YRD9x3+DOTFK82pr@x1-carbon>
References: <20210809094855.6226-1-Niklas.Cassel@wdc.com>
 <20210809094855.6226-3-Niklas.Cassel@wdc.com>
 <PH0PR04MB7416400F3559116FA3192A5F9BF69@PH0PR04MB7416.namprd04.prod.outlook.com>
In-Reply-To: <PH0PR04MB7416400F3559116FA3192A5F9BF69@PH0PR04MB7416.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f55cd8d5-bb1d-4984-d446-08d95b1d23f5
x-ms-traffictypediagnostic: PH0PR04MB7494:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB74947DD8AB8CF16F61452614F2F69@PH0PR04MB7494.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /7JjCkK+vel8RjuGV+0z7NIgIx3r1d84cmMAByZycV0Wf2q+adDGuzLAZ97hgQPwKhieUuEAvY20LjkoMszGgNZaX1EEq4uzGwiwb7Z6GHILuP/MaSkJyfETdJj3KtAvJZ/T3wv5XPKpSxN3iovM5LsDk3b7n8cs9z/SkRxkRobuZQ50n2Qs3IAMrZpMDTA0O9TAEa9mxspvxA7LT8An/I1euIAA6VLxSTBreJlEh1OhcH8jRQKnHcGZ8+OOwYUZI8eG74txiU82do4xUV7wDgwdri+tjVv7qJ5FH0F31ZmIyuCQu1clA+QUPpuVmUS2RfEDrDb33U9uLiRPPHJngv9an+4Bkm4n7WZsBysS83uZSIJlDctPU9laRVjWd0wzHdMtuwRWQuDpHSTSqwZjMMo1lffGcZN81RJ5V08axNJe84767sLF8+i2WvQ/qVJqMIG9Xhgf0ZjB0ir9ZJPoMBU9GjB4mk+K+XhUCo4cQDzj0VsDEe/A1hbitImpZG8X6DtfuMxmiKFn/LFPr9YPTFWs7075j2NmJsLhp6AcuoFtJGc+gZq32wO/zJS0Fzaci8N3dcbiMU/E48I89d/bKaKhnIEy/Fb9SbwEl0jkv2xzqQf5Uw1Y+ZtR7X6BLQ1N2F07/VcUp+7HzMgzQaZ1jdbdc2UtLy2fY+XXb9UQTBPWOGpR9dH9jsviQIA8ArLsB6voD6Hh1rzsRoZKXVEeIZNI42zFU02+/sSnpQ6LNRAVYMZBtHyYQrjbeLJVupVe4rWm3KMSLxIiR/Tj71Enybu/jVohpx3GeJw2YBk2DH3Kpxza0goAnaTCoszBWHUb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(376002)(366004)(39860400002)(346002)(136003)(396003)(71200400001)(38100700002)(83380400001)(122000001)(6486002)(86362001)(5660300002)(66476007)(38070700005)(66446008)(64756008)(66556008)(66946007)(76116006)(91956017)(6506007)(478600001)(53546011)(966005)(316002)(7416002)(54906003)(8936002)(9686003)(6512007)(2906002)(8676002)(6862004)(4326008)(6636002)(186003)(33716001)(26005)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?psQxS2FTxQWQMyGFWA5Vzmilmq27lHuBELZJKiSAO9zOh6W0ZVshZpF7j205?=
 =?us-ascii?Q?F8VxiVAjw8LUjKajGqh1uJ3hZlKjD7BJOI+Zd5YuXpyOlzY3ZsaE5hvvA3E6?=
 =?us-ascii?Q?LeQz/MFC6g/dJE8u03K1ETVFuujURhuDLqLGpEoABxzDgcwNDKyXYq2Sp+mz?=
 =?us-ascii?Q?H2xL2EgqrUfBKbtqkTvnCDMbe1/ZCW3uZk0eiKlHOuM31ke1GpIeHHVUDsvV?=
 =?us-ascii?Q?xm4UUZwpTXuyk/EmMG7zUne806IJ7ix6vGNQJgCAZiqFM67FLy75VU9c8IBO?=
 =?us-ascii?Q?tmNfUZE3ZryggbZv8iIRmwP+vG1HC9MIH/pDNQOsf+pQH8G07ssfRJvRcHG5?=
 =?us-ascii?Q?O0L5bHsP8jzoQT4kQQL/c2xVuE8vneTuOAaVfDnUgdr83PBberAV2exUXCox?=
 =?us-ascii?Q?z5c/W5sNX7/GHoUqVE5d7u0hUWZd1GnMD7AhocgXR7vsOxLJBOE6Ri94EP97?=
 =?us-ascii?Q?GsCkqzGKVRu+kxm+LiIClDjZj3urwAEueX6raGGlPXIwabUo6Vks0ogXL6NK?=
 =?us-ascii?Q?90LdqYRc1/hrT3gHUnGEOxuzxruX7+KEIA0hkKhnDfkJ+9EmWm/i22RWoV3J?=
 =?us-ascii?Q?NJwJL6FygO7M1ypIv38fomEmxm+Jsxq/2lNeZw+s2rbjHFdBSvuDi6xb78WU?=
 =?us-ascii?Q?eUiPQYZEn7tVTXKC3cB3pxejPazz5ZfN3wR1ytxgv+6P9IqPsUUtdo6gPEtP?=
 =?us-ascii?Q?7GdK0E1/Bo8reEZz8qVqS5ulyQpzlOSmVsEpayLJ6P94rx24BlpoTgRBBi22?=
 =?us-ascii?Q?zqkDP1Uune1l//+2Y1ak7/Aai+XHQSK7B+cO7cfjR2vXVeH8Q0YaU1mq9kwx?=
 =?us-ascii?Q?Ynd9N86LlgREQHGt71nEOZ6Fzcc85Jy+4dCfSnkYI1DAdUqxba/r5meNGTM1?=
 =?us-ascii?Q?t86Fn6iWXcb89lev1P2Tmh4PQw364PmSJ54yD7PliLPS0Iv4BjwRDQlHqJ2u?=
 =?us-ascii?Q?HqgJ/vy7aqK1StKzzDeT8qTQXxaF0oPWCfiM/kymrj+/H+g+4TRChplKsg8c?=
 =?us-ascii?Q?tucO5O01q8tzRIxCS5ixNJcPZc71nDI/RiGN9iR0hvG6OQ51quI6FsvOtTHh?=
 =?us-ascii?Q?c7Vunvh8BuLjvgo0WKskcMplUWaw0aO2yJT4SfyePRGlaQrZe1I8ueWKMkpG?=
 =?us-ascii?Q?v/1Nyc8l0barGDzX5L+LXnVhZ7HLIMtC57Bozj4JHlueH8DVoPIPo1wwcjmw?=
 =?us-ascii?Q?Vf8okMPg2Y7B/h1hwF/WHnHGd3o0ZikpsCgs6LkPvqB/nCy4bkLYso7knSMI?=
 =?us-ascii?Q?49xrV33j1xRYWX8zu5oHXc9E5Ivn4pXDtLgTiFBQaqzCmdZzLUa8Z/Rj3RtN?=
 =?us-ascii?Q?zRc4WOr6Gafre3haVg8dd+m8?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A524B31B99C0D54482FCCA8F37E498E3@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f55cd8d5-bb1d-4984-d446-08d95b1d23f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2021 10:04:56.3814
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5NV1EaKABB8/VPE/8KXPW6KO8q0Jzpwr754ObBqjAieYgRSw50Cbez1PV8Z8q1Ro2Ckv0cy7fuBamWam3njZSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7494
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 09, 2021 at 09:58:17AM +0000, Johannes Thumshirn wrote:
> On 09/08/2021 11:50, Niklas Cassel wrote:
> > From: Niklas Cassel <niklas.cassel@wdc.com>
> >=20
> > A user space process should not need the CAP_SYS_ADMIN capability set
> > in order to perform a BLKREPORTZONE ioctl.
> >=20
> > Getting the zone report is required in order to get the write pointer.
> > Neither read() nor write() requires CAP_SYS_ADMIN, so it is reasonable
> > that a user space process that can read/write from/to the device, also
> > can get the write pointer. (Since e.g. writes have to be at the write
> > pointer.)
> >=20
> > Fixes: 3ed05a987e0f ("blk-zoned: implement ioctls")
> > Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> > Reviewed-by: Damien Le Moal <damien.lemoal@dc.com>
> Nit: Missing 'w'

Seems like Damien's email had a typo in his original reply:

https://patchwork.kernel.org/project/linux-block/patch/20210614122303.15437=
8-3-Niklas.Cassel@wdc.com/#24252237

Surprised that he doesn't have a shortcut to paste his Reviewed-by tag,
considering the amount of patches that he reviews :)

> > Reviewed-by: Aravind Ramesh <aravind.ramesh@wdc.com>
> > Reviewed-by: Adam Manzanares <a.manzanares@samsung.com>
> > Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> > Cc: stable@vger.kernel.org # v4.10+
> > ---
> Looks good,
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>=20
> =
