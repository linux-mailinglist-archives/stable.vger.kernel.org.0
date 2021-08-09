Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32B93E4369
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 11:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbhHIJ6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 05:58:07 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:23694 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233578AbhHIJ6G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 05:58:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628503064; x=1660039064;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=C5mtkcaRApnW8a7P9jsxTGtJXJoZrclTT61RaZhidkY=;
  b=bki7SLBjb8uR557vBwHcxN+Jr8SfmUJz4fcSGLcnRY8xf9SCdi3S53Gd
   Xwb9eLWJvYjlOGgEsy1eLmYYvt1KHriyPyNK0XiE/AlApWhbcKpd4qRQk
   S3ooTlAcoUkZ7tKbfGKAXLHVcsHqX0HOHCC+fu2a3+XCuMzgkTb5V2U+z
   /cIUqTSxkTg9xy3sxzhaNhZ3dBpSdxeahMzL37aF6vMKpH1IicRdPuC6f
   a5c9E+ngVu3qCArKpk8RDIWXxG9VFhrqPawYCIo0V2P8AzwI3m9yxj7dP
   N03xssqD9CYKvntDwCnFK22+kQG+Lrj+kcyhLcFYSpPBizkdKbCsrM1RL
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,307,1620662400"; 
   d="scan'208";a="181484784"
Received: from mail-dm6nam10lp2103.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.103])
  by ob1.hgst.iphmx.com with ESMTP; 09 Aug 2021 17:57:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K3iRusGrYSemw5kplGuO31GlRr+cMwrb9yRSYrySJB0cNeAEFW0B3AmN9mCwLsk8oxQYmisx9kkLV/en51T9QwsjG8yOCyWTfDBxgM68faCScqoIUEFKSoUtwpsr5srFTtR0N9Y//dzKHuozszxM3/7jbO0NhWdXpZvXlJnakoehOFnEFsmcy/KmTkLidXcoSMD+BQ0K/UbWHLWNYQdK6EWP4tWj8gzLp/OA8FtdgKSZL038c/J3eFtoxgBifLHv4HxYL8lsD4Kiz2l/5uxerIDQ+vz3k86RGxDwIVjVuf892aZuSmdsgk2hlF28JzMjlGj1ICtJc0kN7mDbbuo66g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5mtkcaRApnW8a7P9jsxTGtJXJoZrclTT61RaZhidkY=;
 b=MH7EJffU/8fkGzlATfwV21d2dCA7oIrP1zNF6gldlMZinBJz55AiInes3SyFZoC5Qx3zDC3XuJA7IEtFr2TP7JH7vH8ZqZ7vbxqmhEOEnjg235n7tJt+ZGyxqWN3NdmA3h0DF9DwLOO+5hu2nWokdEUXlWka7w1pvrmPBImuk7Wu6GU5w6LAs7OMOX9LNOemCzbPPG0mqsSEhcS8Q/gAo1GY5gC4ecsNutOm0QJYxGrSguheFiavZEw+JM/w2J4rwofS9ZIYH6yKaSFjTq9YPymMu3CHae2BVuaEwg1IpOLdhCxWtmLhLvhl5Swcfr0ZmjBfNbBy1k9aAfW3QyX+jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5mtkcaRApnW8a7P9jsxTGtJXJoZrclTT61RaZhidkY=;
 b=sAz44v/AJNzedxaXBwrNbc2ZqtK0BELzhx9zT7cEK5PZxdIEk+VodjmmuRpWnCgBTVGTspVsUJaq19kbX8b0U+Z88E7Fm2zJhh6of0FagnmAN+BjSXqhZmzSpAAsfIWBgidpZPRaLQONuMq7viFj1OfMse9zIwtNak7KM3ILEnU=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7160.namprd04.prod.outlook.com (2603:10b6:510:9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Mon, 9 Aug
 2021 09:57:44 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::f1f1:286c:f903:3351]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::f1f1:286c:f903:3351%5]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 09:57:44 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Shaun Tancheff <shaun@tancheff.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
CC:     Aravind Ramesh <Aravind.Ramesh@wdc.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jens Axboe <axboe@fb.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] blk-zoned: allow zone management send operations
 without CAP_SYS_ADMIN
Thread-Topic: [PATCH v4 1/2] blk-zoned: allow zone management send operations
 without CAP_SYS_ADMIN
Thread-Index: AQHXjQQDdEnEDRd9FE+0H1SDMaa+rg==
Date:   Mon, 9 Aug 2021 09:57:43 +0000
Message-ID: <PH0PR04MB74168FFA5B2B108429077E829BF69@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210809094855.6226-1-Niklas.Cassel@wdc.com>
 <20210809094855.6226-2-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a9ef5dcf-eeba-47c7-7b37-08d95b1c223b
x-ms-traffictypediagnostic: PH0PR04MB7160:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7160DDD4DCE6FCCE08635E489BF69@PH0PR04MB7160.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NyZEczHdZltaDu6Ier8SZiOZecyk7XeZAhazyU+C0oa+A3xVgGanuvV2xkTc/vAlHK6sz4/fE4nV0c8kk1mcvFbQnguIkSxdOqw2kBvEA+s6Y8m61hneqXBzuLuErrg9ZmPiCN4Myy11679r3WgelJ8bwZfnoXfqVlX7vGCHPPUgXrTajP8VhBZyJA9uO4FZze0FizKHDB8uitqGhdsrHcK+Rkz44O/a9a3FjzK/OXzcbbmPJs69NrLG2kG8ETAZ/KHtILxahf2ji6AVI9B/wlheBuvB0y1IarjO4TnRZWPPU5L6MDC7k5z7hTIKPukU2WitEkn13LQhJgOyDln+S90QKt1f86WlzbUdzy2R9giXXfRM9aPO84fhwRoRuQt1r+ggOPvDHd3XKRvaoJ8vLDhN+1yh92RKHNFoCJl8Ki7eWeoITA7PkOnlnbAvKOLqbN/opv4NxFBfOY7i5BobNjxQOKZI9whqbGisvuk48hS0XdcE9t7/rNTIXkYeqo4/mgE4dZx5r3F293ZEUGheGnO7DEZcGybT1ogVc5ocsTUfA6q9i2lXT97ucjB16O57O9c2l1SaoymlbuCzVTMwN6Hd7MsPX/OQj3ARfwaWjqAW897MJonY11gbqTXzCA1Kwp9A7oXytPsei+mAK+VP7eJqC6Zq3mqW1ySP3sKRGAj/HNcH1ajJJaNveeW1hv6uoD8EhBNcRn197Ey8ew4upA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(66476007)(66556008)(66946007)(64756008)(76116006)(4326008)(2906002)(66446008)(52536014)(5660300002)(7416002)(53546011)(33656002)(8936002)(6506007)(6636002)(8676002)(186003)(38070700005)(478600001)(55016002)(7696005)(122000001)(9686003)(71200400001)(316002)(110136005)(38100700002)(83380400001)(54906003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LJdEK1QY/JDbvhuOm6DCCWC5veGUCWhaP+JpVe/XU47KHmR1T8eDyMG5N8f4?=
 =?us-ascii?Q?3+dy9q04NdvjmlPgxHUvyjE10I52MymvVH1JD+8C/pI21RlYm/nEyXYjCVLu?=
 =?us-ascii?Q?eeV9mtILK+Dm9Yykedtn+GaXHRzRUpRTrd4RuNkOdyrVkhxov6Be5g0t3cZT?=
 =?us-ascii?Q?y8d6c6I1zzRiwOTDE1siXCWdsniDMx1rW0eS2bX1y6Xn9oEMN5LgEiDbUs68?=
 =?us-ascii?Q?Xf2mA4IOAAjRp7G+F2GM2kCu2X0gV5KH8egSjHOf5BTI4dTblLeE1gFqf82V?=
 =?us-ascii?Q?4sVTcFLJ9M1kB6rQYPZX99EroZKc5yK0TigVxt0+b11JO9TGrRj1EbHbgnid?=
 =?us-ascii?Q?15pnSgk6FBzsfXVUcLUE1AuHCLoVv2D5ZIeVqfUisCqVsLcT7umzwqnfkyyG?=
 =?us-ascii?Q?bZpp2YnBo7Dk8tndUUhyFgu+V7uzbkYpHwGwcxJbUzejfnD6DjTsd6Ko54bq?=
 =?us-ascii?Q?BZ1plH8jvEEnoxBPQs0LAR1c7u0rMxqnWJl3N+Fjib7SKi9kkzee23+RBcJG?=
 =?us-ascii?Q?1O7Vsclh78s2pc+NC5R0PCLIauWqd640hWSSIzREOrO47ajV4o+RfMHkQS5o?=
 =?us-ascii?Q?Hk1wBya1Hxoe+1lRyBt1GXxS19MhOcs7HsfZME+D9f1TesLGbcKGVSJqIuCB?=
 =?us-ascii?Q?hqjuHcnP56vqZLGape7F2tO7ZmUCVwSodlZ0M43cHVsTrnpxI1pE1m8A9wLL?=
 =?us-ascii?Q?bUQ09/4pSlUFo9fMCxH/fwfYg3u9P0vP/eFoLn2dJeG21nCWBdaEzsTm98YV?=
 =?us-ascii?Q?5Oy/nthMRJBkiS4TQoT1ToCPT0CP1bnv1stKB9iUYiojKWvEW9JlaYug4S9r?=
 =?us-ascii?Q?YHSfwCVNaL7lfvTESPM74tlCTqUQGe8s/DQiFrD1y5UzkOXuhIPuaWy+uXQr?=
 =?us-ascii?Q?P0fYFtDix/eT6NgebT3ityw3awI/NrGIc9Vz47Q+tdy4L2RRI67HLquq4WCi?=
 =?us-ascii?Q?xNnlyff0FD9DB78Zt5uND/w/i20VokfTyjntpPI3xxWpOaC1BAwtuDay23eF?=
 =?us-ascii?Q?NZpHld6rxGz6h3hLjk9b1RqxX4j9AzS3HhuXWb6AOBtuqn36xHE48lkS+MB9?=
 =?us-ascii?Q?ZmaMUoiu/j1MrCUYqbKp7jQb+T23Vds1wnqUpYfWp4ZLUOyg/ZS6i229wlmt?=
 =?us-ascii?Q?piq06aV5vJjXRcXajw36VkebVM7DpY5gPEihkp11SB0ysDKMyxTAZnvs31+3?=
 =?us-ascii?Q?aYl1gMYAu20a4moEJC/lfNOeCJ9eAbIv7lx99US81QxVSLPk45RHKRIZnKVm?=
 =?us-ascii?Q?Hogc6gz1f7LEao7o6pLncaN4Y1wuX3UxJgSQXGLxNg+mL6kfO1ZhVvcYwmcI?=
 =?us-ascii?Q?Qoc9s0JSS5o+MuwFoEWChN66MCICxp7B7D3fOXYVvWUneklAtqCGpbDfNS5r?=
 =?us-ascii?Q?387PAKAMF3Hd/zWGdnph25gIWXVq0Vs7yjeA4vHQEPrH6tvklw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9ef5dcf-eeba-47c7-7b37-08d95b1c223b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2021 09:57:44.0026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W/2EitU8tgSMcGIOVZZq2W06Noyza0RzvIslWa657B3XCfeeFpu5iLOJR1Eh/pnPcbC0xNaZMTDG1h/n5ZWBq+CvAogfhMF8u2nH96tcWqo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7160
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/08/2021 11:50, Niklas Cassel wrote:=0A=
> From: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> =0A=
> Zone management send operations (BLKRESETZONE, BLKOPENZONE, BLKCLOSEZONE=
=0A=
> and BLKFINISHZONE) should be allowed under the same permissions as write(=
).=0A=
> (write() does not require CAP_SYS_ADMIN).=0A=
> =0A=
> Additionally, other ioctls like BLKSECDISCARD and BLKZEROOUT only check i=
f=0A=
> the fd was successfully opened with FMODE_WRITE.=0A=
> (They do not require CAP_SYS_ADMIN).=0A=
> =0A=
> Currently, zone management send operations require both CAP_SYS_ADMIN=0A=
> and that the fd was successfully opened with FMODE_WRITE.=0A=
> =0A=
> Remove the CAP_SYS_ADMIN requirement, so that zone management send=0A=
> operations match the access control requirement of write(), BLKSECDISCARD=
=0A=
> and BLKZEROOUT.=0A=
> =0A=
> Fixes: 3ed05a987e0f ("blk-zoned: implement ioctls")=0A=
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Reviewed-by: Aravind Ramesh <aravind.ramesh@wdc.com>=0A=
> Reviewed-by: Adam Manzanares <a.manzanares@samsung.com>=0A=
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>=0A=
> Cc: stable@vger.kernel.org # v4.10+=0A=
> ---=0A=
=0A=
Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
