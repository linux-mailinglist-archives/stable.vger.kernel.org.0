Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 840F2156D3C
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 01:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgBJAiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 19:38:51 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:8598 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbgBJAiv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 19:38:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1581295130; x=1612831130;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=t5XHYJaBMoQR9qV2HXO0EWI2TrzcW2Q7VfF5TgWBZU8=;
  b=QicvxkAEigvvp4zKiLIj+A5zx1c2/2w9mKPzL4wy1JNboXnfiR1wWQJ+
   Su3dagIbM28RFpCuJVNaWoaaw5Qy8LxLhv9exIZnr7gcV7PBm/867CB07
   oI6YHJwXqQStM4Mvkvk9kSDz6JfG3VOFsoFpPKS2VH4iTvGLDJM5mzqnR
   YVH5OKYFgu+SHJlT7c3SzfJY5tCvhMrVn+VaR5VAcPdNB6RP3bqM7HH5J
   Te9i4TU/+wtrzVp58Ppkg4W/m+1fDp7aZ30NFjbafVnxAcB0b7oelOJOB
   ZgUJ4i9OU3CjMQAFl1nE4dsuB6DK/6nJIpi9GU3hsuAtxswLKKkQzMITY
   Q==;
IronPort-SDR: pn5ety1LfOAQkE8hW5nWELbikQAJYf4mhzjtJr4jC4to3TwkpnmCeAqe1vppTgPutlZtnYgYjg
 /zMKCqg0TDZLrpoHV5CbIXXM2cEW/RTPxa6l2Xn6IonKFWtKOmFIVB7Pdjklrya1Dp4f4Yhn/H
 0PlI0JyfvI9LioDIxBnNXAcO9/8TxI7EaTnOp+YyT+r+z5YHMRm1Yhj2in8kylz95uM/pzxbL/
 VXNwQcv9NNzs5Ykz1pJFa7QHXk3TnmmaTUFpGM/Wso/rEFM0KkGWkP0EyfLNj8x32ko16TBhc8
 edM=
X-IronPort-AV: E=Sophos;i="5.70,423,1574092800"; 
   d="scan'208";a="237466878"
Received: from mail-dm6nam10lp2101.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.101])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2020 08:38:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XPJWkLh835ze2rkEbjp+wmIxMmlMPEwZ6QGdT4wc5PT2bn0HiVbK74ZeRbLLfiVpFY1S0i7XnFNQK+02biddFvm5mWuLkDmOAhY9EEU5Lya9BMU4v8TLbbTEv5a1YdOR5WmnkAMsOnzdpt7mwV4ISRyFm35KlURdvkVr2Inz8pIZHVWwNlNEoyH1uOFxxuBKqcqvq+s8nSpVMlbxASCc+4mWDWnnZUQ/n2vcHSEeHQYrCVY/+PzwixtsZKajZcELwSlo6/JZ4ju6dlH0/QltjBjiEhESK5gLMl0Oktnidj5RVZ+QXoye4kK3coFsPWxdZ01TwEFmY0B4m15n5M58Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t5XHYJaBMoQR9qV2HXO0EWI2TrzcW2Q7VfF5TgWBZU8=;
 b=DHPVs4Y7QZPZjP74rCYRwBIdabeKURfCw4pvLPuO2CP2cszoHvHfrfyOP6Qfz8TsCJlTvMzpToLxHK/YRriPAxyMRMbC3H6jIfBZcPcXMs08DIKobAVqgLLHemfKI3Wrv3o/cYlDXOFV6oul0pg/ITWKVbOQaFzIY79FG4LIOF+S6/flsS7OQ8euaWt16jsA35/8muWpV91uLtwcrDCVJH2cSg0/0m8dWC3xld9epmpR+H4zrWgAL6tn2cqkimCwHSUQdiHGiUrGYlgim8EHCBuyVjScboT5JmEa/huHw7UynXUvQDDTRfvaj+NCOlSNHX+EWPw3NdEehTMd2U6qAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t5XHYJaBMoQR9qV2HXO0EWI2TrzcW2Q7VfF5TgWBZU8=;
 b=kUs12wuxxTdrx6VeT+7ErA0pLahssU2ludfQga6jlXlcUylcPJSs/cb0fbWJaqHrOFE0l0DHOdpr0BoWWTwRWIRKxnMneoGynbl535qbMoP3jDvvgSq28W+WM5oi5ukNIwjWQQ1h3ZpfNsXJ0KzcTgy861wSAmlxAk+V33JZrMs=
Received: from BYAPR04MB5749.namprd04.prod.outlook.com (20.179.57.21) by
 BYAPR04MB3800.namprd04.prod.outlook.com (52.135.214.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.24; Mon, 10 Feb 2020 00:38:48 +0000
Received: from BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::a8ea:4ba9:cb57:e90f]) by BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::a8ea:4ba9:cb57:e90f%5]) with mapi id 15.20.2707.028; Mon, 10 Feb 2020
 00:38:48 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "tristmd@gmail.com" <tristmd@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] blktrace: Protect q->blk_trace with RCU
Thread-Topic: [PATCH] blktrace: Protect q->blk_trace with RCU
Thread-Index: AQHV3Pm1sBn7cXCscUyQVcxbWOqGBg==
Date:   Mon, 10 Feb 2020 00:38:47 +0000
Message-ID: <BYAPR04MB57492F689BA17786A24F08EE86190@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20200206142812.25989-1-jack@suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8d83e281-6dfd-47d6-130c-08d7adc197b4
x-ms-traffictypediagnostic: BYAPR04MB3800:
x-microsoft-antispam-prvs: <BYAPR04MB3800B66C79CBB3DEE9B8C0D086190@BYAPR04MB3800.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:949;
x-forefront-prvs: 03094A4065
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(136003)(39850400004)(396003)(346002)(376002)(199004)(189003)(86362001)(33656002)(5660300002)(54906003)(316002)(71200400001)(66946007)(55016002)(53546011)(64756008)(66446008)(6506007)(66476007)(66556008)(9686003)(52536014)(76116006)(8936002)(2906002)(81156014)(4326008)(8676002)(81166006)(7696005)(478600001)(110136005)(26005)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB3800;H:BYAPR04MB5749.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uNK6C2SbMDwAc/oLbP48OUXV8wkRtQiypFULnc5oBd8IpW7DByJqG1xwZYjS3DlM8o494CrDomy6/vOyU4TbQEf7MQ5ivYz3eMiD+5SLl8yGIkObB59YmIR5TM4uFGfkXHOV6sjz2F9KH7SZsINIths71FP9oq7qbTvN8nhaTC6dtPD9NvPIaf8dqDda5m1fHXrEW7J8ONuZ8MejO4DWdl1TYZ+kpMI5D1Q3ZdfCKQOesHoT352bYLovQGQA7mObl6knYJUANmgCoJZLAURt/jAuNC10TrpLkuzvF2Xb4G1zeX+se2PybUA3/25MKkhB2oMjDoxEroLUdjrbvTv8fjepZHdKqk5ufSfwQL6D+Va4QocoCWw/atXkBo1hSsAeBdVncN3hA5OhWAD/b+bF4IMYRkB2uGjwOUGWy+VhIJ2GOZpF2RIXCOG8sK8guQ3GZQVD3mva8jD3Ur26Wyh0EE0gl8YHYrkqxtsrh5HCDWK3fZQHeKr4NBZLy4NiI5Hr9VMpGAkYK3egSx6khQ1H+A==
x-ms-exchange-antispam-messagedata: RcPY6JyzgKnvzmirxcfanN6/VxE89vboYhmeBon2ut2ADs+Vb9ahehMcLV7M2AUZDMpLmlNrLjupygnfbCXi7TyVWQLZB9PHo9lKtXj1KlKdLbURjsDODtUNfQ7oy4/sbMGweiDmS+WQwFdY59C0rQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d83e281-6dfd-47d6-130c-08d7adc197b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2020 00:38:47.9280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZkgKB0HZNsJQ+7/AMAmv1iBQTFOW5ym2wdsfzdQ1y44jZULyQUPx4yyTmp+IUX7LnzFkOJu8A84SSYXFavR90rfuKIRtfu7x2LPpiHkHIPg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB3800
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
On 02/06/2020 06:28 AM, Jan Kara wrote:=0A=
> KASAN is reporting that __blk_add_trace() has a use-after-free issue=0A=
> when accessing q->blk_trace. Indeed the switching of block tracing (and=
=0A=
> thus eventual freeing of q->blk_trace) is completely unsynchronized with=
=0A=
> the currently running tracing and thus it can happen that the blk_trace=
=0A=
> structure is being freed just while __blk_add_trace() works on it.=0A=
> Protect accesses to q->blk_trace by RCU during tracing and make sure we=
=0A=
> wait for the end of RCU grace period when shutting down tracing. Luckily=
=0A=
> that is rare enough event that we can afford that. Note that postponing=
=0A=
> the freeing of blk_trace to an RCU callback should better be avoided as=
=0A=
> it could have unexpected user visible side-effects as debugfs files=0A=
> would be still existing for a short while block tracing has been shut=0A=
> down.=0A=
>=0A=
> Link:https://bugzilla.kernel.org/show_bug.cgi?id=3D205711=0A=
> CC:stable@vger.kernel.org=0A=
> Reported-by: Tristan<tristmd@gmail.com>=0A=
> Signed-off-by: Jan Kara<jack@suse.cz>=0A=
=0A=
