Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5C92E9462
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 12:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbhADL4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 06:56:07 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:23462 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbhADL4G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 06:56:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1609761365; x=1641297365;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=7H+ObSFbRMWwfndvYEqkYamlBwr+S+72TAA9srKJTJY=;
  b=YOv9Z9WQk8xQ8ua4E+t8RfaA/2GDtGTuwkXk7SFyzipFqdXSY92CdG85
   nlCVqt6YL0ltAidHDpepe4E425VMsX4XKgk42Rha7PGWtvl4IWus20ufh
   ufQ6gVWdCpLUSHzpMLRW6ELylxC7iMWSdIoAS5hZ+J1ijiqcthlI77J2W
   4ZCm0BO9CwGdamZq6sxkVKLEENymX+8fwrgdkXB0HN7ZNdD0iS6xrmZQ/
   mZn0+/Zo4laKKd/xlBgBtir6110gyFQbh0JPB8CvopZleZgQ+jbnFEzMT
   cKUIJbBn1oRCkrs2uCvBa+RCmd3F3GC2JVdsdPvcCVbeSGW0Gp+Ig4Uxu
   w==;
IronPort-SDR: ac9sZBTT0Chh0W9Sqf4p1Dew3yKDTGEtJtaqd4QkOKFxCUNwH6zHyCBBmYZqLA12mueti3cvPZ
 x4xFk5Zz/NdwnemVHeASDEAWvd2aAZsWyvdUPIDneYvjGCvUNk9eiQ+MyukYKJmkW4tOFP3MnK
 z6EvyvpOS9XYJgeerT7EQqqPPdILfCpfDZmS9x0RhMJVMjqT9Gj19v4ocrrp3wMSHOPYxq3MpF
 1Gdc9fY393QqGNsANLpMFR4EReNDflMnhLtKXtvzmJ8h0bqYMjJLykhGs0DhPXW3zqkMddhRCN
 hvo=
X-IronPort-AV: E=Sophos;i="5.78,473,1599494400"; 
   d="scan'208";a="156455992"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jan 2021 19:55:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vxz/ZrhKTk6WodaYXCfJB3a/uinrIKlt5BomVgW9LWONPzXudjVYDcwdjvqFDTfROjA/GnkY5L23neBN+iQb9+lRrJK6VzCiEwGB7lSzje0HyhriHeD/3hkcBz2J20/jVPfz5I0v8HEZHwCux0EyjkSzIbbJfcPEiGZvYGMigbde0exUw21vKb/43gPwZOQJ7G2+wSSNPrXr2mcnWcjrhJzNtfOAyeu2042N0pBQGv2H+LLdbAZrMx0mlBP4oh2PkcHfcDJ1qyBCOXKya25ZBdbAtVmpI7u133hakToeyoiLXCUkoBNxwd/vJYrAmasW1do0oYvJrXjamqStAJtbfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V23ZPFnDU0xa+kLQiIUjZ6jmJCcO8LUQes2ywBwIksI=;
 b=LLvUwZT9ID4SLM59pJIDjQdGL7/VJ3FkBzhbeZdOqtxo3fDbLU1B705GC0BuEjZTnVhJ2gGJ9bvG8StVqIxod5RtDsPd8FhWvKA0vUOeqwV+gKTR8w59NNNz3Jy4XHLSESKe+8d43+gWy8z7RrDTWzHGgay0eyhtJFL5S0rFW0e14+GacjkkBTlfS83PWsD/33J57P7nXHKSUGWJnNc2Rn8wfzQCjp4mbORF6Wl2+q/39CeP8vm5x7cAnYn0Bq+GWxqTRWnkv34ydzLaaPRF8b1EvyrfacqsVlaPJ0IWju0lVknGRPcanMLogUVEq4MV6/eGHRCoAenXnn2I8fRYRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V23ZPFnDU0xa+kLQiIUjZ6jmJCcO8LUQes2ywBwIksI=;
 b=W0ZsILgo4fmkQGiSHQAM94jE+WryNYFGhlhx1eohhIH8SiSTrpntY/WvAUf4ly93zcneD85REdujW7FusmHWwdLmnQdBiRTwcWtiLQyx4Dw9iHgQz7eIxgLMoPQg33+AJUI1xk/w5xfEsuLe+fM0VOqBghF5XusELMi3L6MPL6Q=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by MN2PR04MB7040.namprd04.prod.outlook.com (2603:10b6:208:1e1::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.23; Mon, 4 Jan
 2021 11:54:58 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::2dbb:7e01:f076:eca0]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::2dbb:7e01:f076:eca0%9]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 11:54:58 +0000
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
Date:   Mon, 4 Jan 2021 11:54:58 +0000
Message-ID: <BL0PR04MB65145288E0F15A8D1CE4409AE7D20@BL0PR04MB6514.namprd04.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: 7e94b849-7354-4fc0-36e2-08d8b0a78f36
x-ms-traffictypediagnostic: MN2PR04MB7040:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB704095322DEC10D5B52FD5C0E7D20@MN2PR04MB7040.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VCCTm8+kyEOJrQNLCstyIIaGmxN15Wq2SHBvHqM8A1ZPedpF2CcqDyDEHCJZcMmGka/NRTXKXKiM3twipiD5fo4Rrw0BZhqB3+fsxcaVSaTgWdiVsXuBG1shJlhpAoD6gGbu33jcyPWuotZ+Hqt0KfE7/t2nf/RlT1hTJgNEWgtukzMADVFa+H0LNFFh6xL1HglnFMe3iSlpJlTV/jKAeXRwg5/3g5KCqAFPu06h5yhpE7n0QI3s9bXkgpc1ZtBNgRqXHcL8gdGAO7hk+pg7ZR2pDf/ho9Gg40zXOwbw3aPJ7QhB31K/+bVA04mz6s+AvJrq4t8b5xZCIDvPfbgmjGB5RlL9iNNIOwuBFsr47TbyNzlen6fJLIl493bl8bIP42CrmzRDLx9O7MVN2SIk8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(396003)(39860400002)(376002)(55016002)(4001150100001)(71200400001)(66446008)(64756008)(66556008)(66476007)(2906002)(8936002)(5660300002)(86362001)(316002)(9686003)(6916009)(54906003)(478600001)(7696005)(6506007)(53546011)(33656002)(66946007)(83380400001)(52536014)(8676002)(76116006)(186003)(4326008)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?Windows-1252?Q?v3aRhtv07gyfiZ02EDurhVlbQusMaUX7zei7XPHA4xSCMJyNZrrU12Qo?=
 =?Windows-1252?Q?SOIBbsv5BJc78JXrfXfNFbfr40n/Bccyz+yrwndb/dooWg5mQOvXOdb4?=
 =?Windows-1252?Q?3SkLO1m62+ihSd8bm4Qh98iJg3nhbs/Fzv/cKcFZ8I8KEvzVuVc2/08/?=
 =?Windows-1252?Q?R2iWCVh1u9LtCd6mtT7Nfzys4RKrRXDB6UzGL0CLMO3srFkNUIwfc+zv?=
 =?Windows-1252?Q?xoSKRdYpADXzOmSbNwWclL8KN/mj4XX10/r9nUa0bDQVLG5MS5jKj4CM?=
 =?Windows-1252?Q?aoFEqJOV0OniMoyXfkac1b6sZxvr61j1+PLBOl+WG3svd2HJSO2Bj5/k?=
 =?Windows-1252?Q?4d/+uWWeNtt4mmpmEmC3vm+mNev0BnCbywA03vDMAmS79PfIWWoII9Fw?=
 =?Windows-1252?Q?Fodi+nZTOY57j/hLvW53Ul17xosC3X5dEZ43a48XnCNuqEWZ3/Oh0P9V?=
 =?Windows-1252?Q?tXdXllgIXCUP40+MHijns9IDDaq2L2TJYTZfnhhOCSuwiWgr2DjVHcnu?=
 =?Windows-1252?Q?mGquwI1GTxXlECMnzwPp5agRC3/OmuWDwE6Pi3IF3YS3kxHxsRPdvxCK?=
 =?Windows-1252?Q?rz0d1DrbHJ8p73d2IaoxNk49Ka9Qph1mDE42BKF/kZ6oiVWgodw0/u76?=
 =?Windows-1252?Q?Qlr0h0JjWnwg7XYV7GoNl+V2RZryEDi86CGRX9pi5xGJ9Oh0g1cuycBc?=
 =?Windows-1252?Q?x27u5DR3N/58I1PetLz4ZgYT6oDNeMbuhFGpaeCIdBhLSq5UN/zmy+1+?=
 =?Windows-1252?Q?sH+rGliXer//fsM2Uaw3ao53UFzn5ekTxeaIzMJrqQZ6E52v9xISpBS5?=
 =?Windows-1252?Q?lXDOvP5REvOZwMVQpuqVUAOUrMeKhBUeEfljpvSdXECQ5JVeInH9TaKy?=
 =?Windows-1252?Q?bFU7aDtRnMDmld0/nd/KVaDuimiWuaCcemgLHkrLNAEfadeIsDDc2Hrl?=
 =?Windows-1252?Q?7FSzby1pbAgB02ezpyVXogmA4jYbyWZuAxcBW9JGBkQPJ7KXpKbZUPgn?=
 =?Windows-1252?Q?Ark2Ohvs8PT8WccGR5xR5yHErNCJHqYQyOScnREZUmCR5vcuFsajmdUj?=
 =?Windows-1252?Q?fhGv2rIVRhO/blf0ZXvgz0L8dQMuQwzuJkcgma/TQe6264i1QMIf5dqS?=
 =?Windows-1252?Q?NMQ+Dm3x5g+CLYs+9YXHeHJn?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e94b849-7354-4fc0-36e2-08d8b0a78f36
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2021 11:54:58.0243
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LS2WulEi8WYFlJXyydWYHsMAOSVK1Woo5rwi+P/4CQJOcj9x11j3+MFILjJ0dFHOqlvqYsO3PKU613OkAxa8DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7040
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
> =0A=
> =0A=
=0A=
Oops. Looks like I screwed up something with my tests. Sorry about that. Le=
t me=0A=
resend that.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
