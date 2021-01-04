Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA2E2E9497
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 13:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbhADMO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 07:14:57 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:17504 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbhADMO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 07:14:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1609762779; x=1641298779;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=rSHlWqP16fIGS7E/tMuxTgACZxl5w6wHdLvutsjWNrY=;
  b=m7xS46pBejtqy6KI3VB7ss/jClFtxCk8jBngIr3rY0hT68SEDY5zZAwF
   9aFdcZfRKLauJ+Ss8c4jF24fBCqCOAhEfVhQAwXHQfDhbZz1pwpYqKsR5
   ZkteIGX3jWm2NQqHw22CPZD0JJjsK2xIp8ccxiUpx9wAHe2I3VdrOr/J2
   lhxdHp5MFuSMO2wfp88OkIikD2Z31bYe8gE/vHyGx6zTziAZD6BL9Mu20
   kDp5lS/sO+Uslhm7b1480MTxiPYzOui85lbez5q1+2ZkJ00m73DCywmAu
   2gQdKMmzMfTV2P8FOkIT1y2z5aHpEFGinjcc7G6spwgIq84D/nsaTc0fT
   w==;
IronPort-SDR: z5jsyal/SW1e53dNrqL9JR4GvOjtxB5rQP9ToLcMgKY+I94ye3ZkKm1R3SKB0QENzATUobgPr0
 iSduklbgRlIJGhm5MA/jBhah1wpByOIrmcaCkEKv5TusJZFJIe0FKxa8mtRg/I0rXOjUIHz8VM
 oDSlzyo4sBEXLaZvlIvwYEck3mQs5LsOOA9W37m1qX5LQVtrlX65VY9qMgAzVkxEBtlSnbNcnq
 A86XyTbMQb8yycwqgWeguaWECLogLdGEN5GXUUOseYzGo5ja5KGWCrclbpmfpSHuh7fbHCCfss
 f/g=
X-IronPort-AV: E=Sophos;i="5.78,473,1599494400"; 
   d="scan'208";a="260343050"
Received: from mail-bn8nam12lp2171.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.171])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jan 2021 20:18:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FsbK2urUXXNNCzIhuV94J7daj/o14B8bqzUmYfQDv2lCSaxQHFupTt5mp+1+hcDMvcG5V90kcnKITpBfnSZ1qsfHbkk2qW1OV8XmNPuN+fwKhQ92dx6TvN+SnIbsCwWasgnYxw5GOBXkPSlztTNBk5KLbBcgLqe5zFil1e1eKPAg5kC2MbYorZDa36Z17PQmHJTGNOgFBt2rmPmt6fKl41cZk2tjZge3nb36Eeh/y+7cilIxYWnVQ05sqxmihJXs2DDBQQJAzZLYWos75AZ07D6yko+604uLoyofj0aVy+StMhKiYLy3h5YcnjSZ9PHLJhS8zE0b9JRsEQ2uDu0Q5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sS0jsu4NDDa/IREAihLreiVau/cm85/FUmmvLcaDZqI=;
 b=TnOs30co3WhuXmkMAAg7g/+y9aGMhOvsJI9dtVGhbnxJoOg/YJZEevijN6nEsz5CI3wN3Y2n3BCqXi1tJN+EChqhtjvtptNBDmVHIHIHRHeMvsxMSC+D3RmpkV7R8rc9Bkkv/I583drizcAJZb6E3/s/oRFKxpl6fRuWj108+MSn5DLv28xWAH9ayUCWAbZoD2ZFInZ3o83hCGvjOzVNVHoRz4Mi9/MO/0TL68NQ2TaIShc3dj3ipTQEnJdTydZoXPPzD1Vk+/ll9SZBa37ElN2Kin5t8xZHMHbsUnJvXjdt8cM2sBR4plKjoMI/RU/vA7Mn2GuWoU2Cdls+T5GW1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sS0jsu4NDDa/IREAihLreiVau/cm85/FUmmvLcaDZqI=;
 b=f6BMzPXtmJTuw7dTIrXIJIoV1LRMGSw3dPOlFKANNnqwoIW49pszURe1KZQJ6dMzVZdwho45JcFYiL69dnySJsp7Qc21rCJ06heSVsj6ZHQkX8yrXJpgFF/5gtMy4NmDADrlkJqlNbmFKAPU1Di1QKx9CKPE+oQCLqkfiz2Whx8=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by MN2PR04MB6734.namprd04.prod.outlook.com (2603:10b6:208:1eb::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Mon, 4 Jan
 2021 12:13:49 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::2dbb:7e01:f076:eca0]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::2dbb:7e01:f076:eca0%9]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 12:13:49 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "hch@lst.de" <hch@lst.de>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Naohiro Aota <Naohiro.Aota@wdc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] null_blk: Fix zone size initialization"
 failed to apply to 4.19-stable tree
Thread-Topic: FAILED: patch "[PATCH] null_blk: Fix zone size initialization"
 failed to apply to 4.19-stable tree
Thread-Index: AQHW3Q9XO4No/1edTEqYNnXZ6UdbJQ==
Date:   Mon, 4 Jan 2021 12:13:49 +0000
Message-ID: <BL0PR04MB651487C540E0078275F4010CE7D20@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <160915617556175@kroah.com>
 <02237e37253bfffdc9f88dd72a7eccaf301a5b02.camel@wdc.com>
 <X/LzaLYN3k0JFJw3@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:4d2:96cc:b27d:4f9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 16b5e9ad-ff01-49dd-3287-08d8b0aa31ba
x-ms-traffictypediagnostic: MN2PR04MB6734:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB67343B5189F9C2EE7B07538DE7D20@MN2PR04MB6734.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d3NX4CuXdkheUMY+rdq9l4a3+DiEere+zjo9/STcB5RXbCyCu5vUElCCHcIujRU7nGLtCNaRwEF+DdLJ4WHqTVvrqTJof5dY0l369meJl9Gj1IDeEq2eNQjV0VAVU3gJnrncyoRi1aNopUZTYnoXGgy8DxUMod5gZzs7ieoWWuopECi6Q5MChH6y8z4K3ByFqTRz3jEcPkuXUffMbda2gIBk+uZsiymF68Fj6CbNbMz/yAAc2qAsudPsqQ5V9WthRKHQqeQKihNsfgy/qNmYlKWRDBcNv1148kbbUmqXJbqqEq1KqKXT/3BGPzpMQxEGfx+0859JF0GlXJVXpRHUoLxxK8nU1Yu3WSNvzf13SE5N3ldzZFxF8wW902pJW13+gAgAGrPT+5Cfi+UwoGYjhw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(52536014)(55016002)(4001150100001)(9686003)(6916009)(53546011)(7696005)(33656002)(4326008)(83380400001)(8936002)(71200400001)(6506007)(5660300002)(316002)(186003)(64756008)(66476007)(66556008)(66946007)(91956017)(76116006)(54906003)(86362001)(478600001)(2906002)(66446008)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?Windows-1252?Q?yifFceYmv78aumDxZziAEgkUaMiy7Cv445ylJkAvpGE/V4wLH0IE8V9o?=
 =?Windows-1252?Q?uQhs3wcbOBVRofrPsB80xyC180cAALIF+KopsZjcaNj5i+GwyZXQYHOh?=
 =?Windows-1252?Q?f9dFzj4qzo+1ViZe102SUL1BJXLwRxv7K6COPZeCT7RN69w0uMqu3S+X?=
 =?Windows-1252?Q?L/Ke+pupxoKXQR7Cp6wT8vG0Y388QKVVrycWmKlV4stYp6JbEvKh4Lnd?=
 =?Windows-1252?Q?DbcKs6K5V/PN75NUONAMTlYFhxPR6Y0XudbqLZJW97R/C71paryRvZ91?=
 =?Windows-1252?Q?lmsQJrbfYCdJXoKsVSBh7LEgC7+YmTWqFNyqatTOdBPkMIdXU4e41G43?=
 =?Windows-1252?Q?t33Ugn88aB7IdROsmhHClEEeS418MGmF0aXsyZPeVLpgQFpZVUE05d3A?=
 =?Windows-1252?Q?4z8fATdW/62AHK7Zy+vESdoJ9XMQC+qFgHT91tDJUC2EsMMCn+O6OWun?=
 =?Windows-1252?Q?qur/+mntQeCcRmGim/jJggFdHQwkIjrP/HtrA1t1qieZnVO7F4gkE9ht?=
 =?Windows-1252?Q?CdJyhE005GtI8yhnvKHXQGNw3AV0dSKP9JfC2njoU6pBsevHIwwb30Yw?=
 =?Windows-1252?Q?feOWPzLN9kLzhSc53OPP4hw6D1pzuOTvBbzNq4OJ4x/9gPzjb9XKe5jp?=
 =?Windows-1252?Q?bEOzNjbjunYaKjjGCaBKoxkZrzuBa/ySF7XHq4CV8hCB5NTjjQWwQauS?=
 =?Windows-1252?Q?+XqBp+ToCdj3azLfmaX/feYmsuLlGSqSniB1+nKH6q2SF54L//W4d1Oj?=
 =?Windows-1252?Q?WVdlbYkB2aSKzu9cWXhpIzkn7vuUk/Y/J+1yXifH9puOKPWnFifmR9bL?=
 =?Windows-1252?Q?FVxZ3IwHi4V9AQxhyBwWSOaQ1hf6kZXsZ1Uso6eJbX2YQEukSuM0/egg?=
 =?Windows-1252?Q?Q2wRUVt637ysMseRnYmLZ5x0bNEJpYgcSUbXciqftBn3WSotezZzshmP?=
 =?Windows-1252?Q?+el7f+Yayc0/wM9HRzQE83Nn4gSAebHnaeEsquH8PR61xi9WRJqF2h/X?=
 =?Windows-1252?Q?vzao5xIbpxfGtqq0sDT5g2kj+mNAT7vumW3Flb2lTNJ1zWt9KTiVRP5H?=
 =?Windows-1252?Q?nzzD7OPfR261QmcKLG6DImllfTV7sGuoeUpOTSH+c4ZE8i0qjBZsFjDw?=
 =?Windows-1252?Q?hevEv8LvC8g4kxKqu/8acAC1?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16b5e9ad-ff01-49dd-3287-08d8b0aa31ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2021 12:13:49.7194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9JVZFxf7phfYk8CgTUFGtdV8zekXZWnMuvScZnLgGGkjJSpqWIGHf/iw5Y+IeXMxRoGzowDMhdM5qpboVFFMpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6734
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/01/04 19:51, gregkh@linuxfoundation.org wrote:=0A=
> On Mon, Jan 04, 2021 at 06:14:41AM +0000, Damien Le Moal wrote:=0A=
>> On Mon, 2020-12-28 at 12:49 +0100, gregkh@linuxfoundation.org wrote:=0A=
>>> The patch below does not apply to the 4.19-stable tree.=0A=
>>> If someone wants it applied there, or to any other stable or longterm=
=0A=
>>> tree, then please email the backport, including the original git commit=
=0A=
>>> id to <stable@vger.kernel.org>.=0A=
>>>=0A=
>>> thanks,=0A=
>>>=0A=
>>> greg k-h=0A=
>>=0A=
>> Hi Greg,=0A=
>>=0A=
>> I sent a backported patch for 4.19-stable in reply to your email. The ba=
ckport=0A=
>> is identical to the one I sent separately for the 5.4-stable tree.=0A=
> =0A=
> It breaks the build:=0A=
> =0A=
> drivers/block/null_blk_zoned.c: In function =91null_zone_init=92:=0A=
> drivers/block/null_blk_zoned.c:5:42: error: =91SZ_1M=92 undeclared (first=
 use in this function)=0A=
>     5 | #define MB_TO_SECTS(mb) (((sector_t)mb * SZ_1M) >> SECTOR_SHIFT)=
=0A=
>       |                                          ^~~~~=0A=
> drivers/block/null_blk_zoned.c:27:23: note: in expansion of macro =91MB_T=
O_SECTS=92=0A=
>    27 |  dev_capacity_sects =3D MB_TO_SECTS(dev->size);=0A=
>       |                       ^~~~~~~~~~~=0A=
> drivers/block/null_blk_zoned.c:5:42: note: each undeclared identifier is =
reported only once for each function it appears in=0A=
>     5 | #define MB_TO_SECTS(mb) (((sector_t)mb * SZ_1M) >> SECTOR_SHIFT)=
=0A=
>       |                                          ^~~~~=0A=
> drivers/block/null_blk_zoned.c:27:23: note: in expansion of macro =91MB_T=
O_SECTS=92=0A=
>    27 |  dev_capacity_sects =3D MB_TO_SECTS(dev->size);=0A=
>       |                       ^~~~~~~~~~~=0A=
> =0A=
> :(=0A=
=0A=
Unclear where I made a mistake before sending this. It was missing an inclu=
de.=0A=
I sent the proper patch, correctly tested this time, in reply to the above =
email.=0A=
=0A=
Thanks !=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
