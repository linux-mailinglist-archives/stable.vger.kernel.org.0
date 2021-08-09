Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712DD3E436B
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 11:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbhHIJ6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 05:58:42 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:62241 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233578AbhHIJ6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 05:58:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628503101; x=1660039101;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Bp88pRpfMr5oWSmnkCZEZ38Q8vAW6Xfkw4GT+DZu2Tk=;
  b=Ep3Aq2RI2xI+HDavauvn8ij/20b5rYjuADtBzmfEdVX90T3x+T69J5ez
   Q123B2JxI0Y7joewY1FaaZtU68NuM4bY9+icS9tZAgXu/y4/mWM+9iLmK
   hqN7ODU7kiymCs0DPq5OXgXD4yPesxy1MdKcL54PsQMmdudpl6OwAiXIJ
   IbAD0Jm3vMITMh54U/ZbghRkPQ6MSol+jBT9XASe2fP4temdE/Xkpjjx7
   JyHgIZFO7QtzFUsy7AL79wmVwhXucpRWZJhrqaHmNN4cL77P1X55mqEH+
   n5m8nJT7UrCVZ2NvB1Y4tUwvrK0Li7Wsns+DjMVFvUBrxe1YgWD+BA5sr
   A==;
X-IronPort-AV: E=Sophos;i="5.84,307,1620662400"; 
   d="scan'208";a="280515236"
Received: from mail-co1nam11lp2177.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.177])
  by ob1.hgst.iphmx.com with ESMTP; 09 Aug 2021 17:58:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g0LvNCzgL9FPPjPPvDw36BkV9+T720tvG61RjsWNfSVM/zaGz3Ae4nWHr2y9AP/eF+E75y139Z9pjBPTNk+lsrFTI/T3I9UPUkNzrQgsyZ2J2/M1x6hzGLJ/zOnCLor7zTl7xy9nDcdZ8FmTdurMKlqSyaeCMyNKejlg6a7p7Y97rg/vE7r3HIIIWi3KrJOMtV1jjPj0gaagaKATmA2gPzJikR8H/EJ9+WBjRbLBO4Lm7NskqLjggGsyLu4NQJt3Glz0N8nty+tYlpSf4nZIq2NxU4R8k1+PxiPvPDe5sXny/PCj2GZbU7CiTkH6ePupS4SGy86ryrIX3HYJNTck1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bp88pRpfMr5oWSmnkCZEZ38Q8vAW6Xfkw4GT+DZu2Tk=;
 b=F4kUZidKO9jsmDm/5B2aq5rErhRj20lvDUAHBoObQ/cIw58u+6BRcEuRVWHNjdl5n/R7D+uXXgzVR+nSGn6eF8O0MUdCfN+KHBc2bNQgwtBIC2jwYA8mtO08S9yQT7q5/Sp968XL+h3pypCtb8c5Im+y32qMBq+j8PaPauEOkTv4NkX2zHH3V4HzjA6LD7MuYx1zoFu872BKTwgdOGv6Kiho1XQzJLF+VbgA8S/Yo/rqjFO83mh4+z77l2Id4QpPk7NKz2YOKpIj96/N+xQiQpanU7HZpr5NFEsXLl3oY361LqkB7P/YDqe0YgHmnHWot21JOuCamwEN8hSlefdqhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bp88pRpfMr5oWSmnkCZEZ38Q8vAW6Xfkw4GT+DZu2Tk=;
 b=vfIMUeEkGbm9B4THY0wTABx7BRXbmXHpfTbAJomquBRSN3S2Lsy10nHLQXf2zEwxDq3KlOTaNLjB5+n8JOfY5yV7tfYq0wyspwDxkGdOik1xWs+YNzxCmJc2SNVXOwh8EKKWLh40fDd5dBvKHHxcjFBa3PuirnAPYIxLUh7mHZw=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7671.namprd04.prod.outlook.com (2603:10b6:510:5a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Mon, 9 Aug
 2021 09:58:17 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::f1f1:286c:f903:3351]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::f1f1:286c:f903:3351%5]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 09:58:17 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Hannes Reinecke <hare@suse.com>,
        Shaun Tancheff <shaun@tancheff.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Damien Le Moal <damien.lemoal@dc.com>,
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
Thread-Index: AQHXjQQDlOGMT4pK+Eu3d6/OWUdW7A==
Date:   Mon, 9 Aug 2021 09:58:17 +0000
Message-ID: <PH0PR04MB7416400F3559116FA3192A5F9BF69@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210809094855.6226-1-Niklas.Cassel@wdc.com>
 <20210809094855.6226-3-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ec174e5-6cb2-4c85-cf23-08d95b1c360a
x-ms-traffictypediagnostic: PH0PR04MB7671:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB767197BD68F30D92B8C2E84F9BF69@PH0PR04MB7671.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2HXU2909Brn/BP/u+dyp/Mw3NtfnMqmuT3bYu9xNPWOeBNO/UhczrE8JST0ZrceW2BHViCyEM2/8fdE6IMFQ/RX45gYe1MvSHfNL9cTmQDVakH84dYNpWObSW+1NK7t3SmlxCaDHxf8zBYUPHlce7UeYp6PAyXMqLbskWmOqMzRNmcaY9qS2DtW+mPmrfqXJydY8LF7ZtyQmn2q8FR3M/gggE/07z/YZyQxXrJjcSqH1oE1kZ/yWeCucj6QfvAMwItbZl6H2M5giO2ZandGFsay9arf22fFtnwfTkj4AF0QQlnd70tUAmoYBS8ySMjbd9VyxuCR6ktginwAhKtihWtgJyc8CCfkAgZRNK5+s/+tohJhBelv7FoMULgaIwpksIoXcQUgWNhg7bpayRkZXuerZWpZickekD8HHGhz2EcHhoSBPL/3OUtqIZrsiO8uDWmBUlNRmzONpKVcXYj8GUORygXKZtbcVIRU/heTHODXzrMwtw1Wk8e1ZNCSM2khL3mKvrImZX+bKr++3yptQtpK9M7qQhO5QaFgi3s03RCz+c1QxMM+wwM+o9xlHFupAk0xm3pLJ3+T8V0PDcGP99wS6M6kaUplLuNYosDAyWwOpP36k7ZcLemAcRQ+Rttri6suIFgvuY5srEb/oEt1mpC8KmOZL4JrqWlVNNpUVK23fK164zuIV+VOmNNnKpdmiaZHlwhqGkYIJ3qs1qqILSg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(39860400002)(346002)(396003)(76116006)(5660300002)(66476007)(64756008)(66946007)(52536014)(53546011)(66556008)(66446008)(83380400001)(316002)(110136005)(186003)(7696005)(6506007)(4744005)(2906002)(54906003)(38070700005)(4326008)(478600001)(122000001)(38100700002)(86362001)(33656002)(8676002)(8936002)(9686003)(55016002)(7416002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?30rvB+ASGdiVUkFvgdedf7jmamjkcn2PmSJ7P2CC83J+Qeotbu1Ql7rfzd5b?=
 =?us-ascii?Q?5PeoQskGjXs4a3T+HedfQmQNlYM9m4h5r647+u7hJCittEgznCsKsPZ+NYG1?=
 =?us-ascii?Q?R+uEVXDyQhGB6Ig7Z3RxbhDea3vFXBF+Htv9ExblQ1cPIhhmGTnm1zStKt2N?=
 =?us-ascii?Q?7QGJMZBw6cHnya0Qf/wnQRS5An/1m+bGA+AcTXr0Zbkrhp0mxCMg1dGhn7jN?=
 =?us-ascii?Q?LlU9uPx/qcsEpsHgTAh11OiWjT3J0nFGm75wIsF5NfSF5i1wf/sZgf24VM6N?=
 =?us-ascii?Q?jEVg+uV2h2NYV0z17xwxyUz0HUK13N8yluAmGtUDpycLqjTRetUZOj8/IJT9?=
 =?us-ascii?Q?ZRDLb7J4+7qRx2gPbqY0+Ht2eZ6miV3Zpj4VkNhOi5JvaKQyi1ZLV7tFeEoi?=
 =?us-ascii?Q?PdppTfKDe4FrjcETqOUzIydrj0/xYQcJorQlyE+5tqnpyLZWt2UM8+PiIBKS?=
 =?us-ascii?Q?6ihymnd4ukAZgv2A32R8FgnBw0mHjGvWdCoBZbF/waZwVQZQSO1qkLgHo8Sh?=
 =?us-ascii?Q?6YpCXBW7bOb8T/YWAwUyY9ZJgB9jVO/PODo8YMgI5emD/bV0nSRJeyNOulwq?=
 =?us-ascii?Q?HH7QvE2nsFSu541YCtUjPoYExVoOcIMzhfV1PQBnQ1+jd9m49iqK16621Sr3?=
 =?us-ascii?Q?jt7wrWzLHu+8NfxMgaZZJ0rtIVKRdygiXaBK+cvSWpQ0RUp3OM0eKze3/ssB?=
 =?us-ascii?Q?C33NRUdrxoXzkD+JO98hoDvaHRWubodNIoWroV3ZlGF2+SN5ufJgfaW679i6?=
 =?us-ascii?Q?pmUVtvBwiYeNkjdjveUprnRuhz7/DKhjq+nFPnEE9ninLMQOVC7yBujv6FwP?=
 =?us-ascii?Q?baPJVOXiqg4DuqIuBvG45S5O9J7B/PlCh5BOKBmhaR4zN/ukc7Yf6OA4RalD?=
 =?us-ascii?Q?WgjWkSzNZW2XB4vWUwNlEza6iu9wxxqj63+vQ2z80IJd941Thvlpj5CPnvX2?=
 =?us-ascii?Q?fceyLsIol4+HR6+0eXPH2Z0U7sP29Xlya2meReBEdqzzHosEkWY8+rKBJ8lu?=
 =?us-ascii?Q?LvrRTeaop58rkK+oOnApBwVl+LtI2t8pooaCRwDyu20A2LZezNBaBngZVMij?=
 =?us-ascii?Q?YYkl7WSRcmc64Txlely79dEDYIR427XRoAQSkkImQyNZPG/NngPvFlP5qQan?=
 =?us-ascii?Q?eojT3GluOr2DsRc0t9N2tZeXnIQwPhcEWu9q+rxYuaAGLitrXN08LGoOv3Hp?=
 =?us-ascii?Q?0qvGJCgvmSAM+MhGzu12J2Bf6Njn7aKnQjJxLKQKkq6+mj359uaP3tmF6teh?=
 =?us-ascii?Q?qB/LxTKOyZj43u7Sfgt8G1drMHqZF6DCNt1TTVRJeKJFaaiTYQxMEr4Yge95?=
 =?us-ascii?Q?PRMb9qCli2z4MCEshSdX2vnxkQKSqsRCXsDQW5EWJJWIlotRzdqk0VNtpLPL?=
 =?us-ascii?Q?mdPOTBBNPvfLrk7rbUMcL+RbgUb90N4p5QmkpwasPIZT20O1Tg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ec174e5-6cb2-4c85-cf23-08d95b1c360a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2021 09:58:17.2012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9g/C+TurVBYKiOAp+FHRbC1mKQ5uaUN6kBkbKRdXCZLhR5TpCGNu/bqJ/3Dg/CfVjofF96cqoSc7eNENCZs85a+PYmA8XK/WicUJxJ1+uR0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7671
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/08/2021 11:50, Niklas Cassel wrote:=0A=
> From: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> =0A=
> A user space process should not need the CAP_SYS_ADMIN capability set=0A=
> in order to perform a BLKREPORTZONE ioctl.=0A=
> =0A=
> Getting the zone report is required in order to get the write pointer.=0A=
> Neither read() nor write() requires CAP_SYS_ADMIN, so it is reasonable=0A=
> that a user space process that can read/write from/to the device, also=0A=
> can get the write pointer. (Since e.g. writes have to be at the write=0A=
> pointer.)=0A=
> =0A=
> Fixes: 3ed05a987e0f ("blk-zoned: implement ioctls")=0A=
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> Reviewed-by: Damien Le Moal <damien.lemoal@dc.com>=0A=
Nit: Missing 'w'=0A=
> Reviewed-by: Aravind Ramesh <aravind.ramesh@wdc.com>=0A=
> Reviewed-by: Adam Manzanares <a.manzanares@samsung.com>=0A=
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>=0A=
> Cc: stable@vger.kernel.org # v4.10+=0A=
> ---=0A=
Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
=0A=
