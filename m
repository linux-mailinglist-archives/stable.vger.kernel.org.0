Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C2F27AB80
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 12:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgI1KIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 06:08:15 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:55012 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgI1KIP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 06:08:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1601287695; x=1632823695;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=8QGQT8S5AmMcukbYhTerfnXcuETYs02fRa7NbXGp5dc=;
  b=Q3oOE83afSmUDWKfuNzMRlo3+JQFXN6DNUcFOsgXs0k69UKqqbFV/AXN
   dhOjmOaXbNElgbSUDtDjLRPwbyZ2Vx5DlBbyClqxLyjm5g1x+YxFTgiuu
   m8ZqGOM+fmqVpVAqy7OG1M1Lweaww0FJQk6ewIxe//AdzoD3VEprtyBsd
   KjSfS6c1/gCmtTaWi5uEDW47wPldRRmmhDxC8LTDBDq6rAjvcjH5NiQsD
   Qi2m1hZ0e4K2tY9vKdR1267Zs6pJMQEtBkSxe3x0bO6khGO2r9xWTg6A5
   F2/hpFokLZWcy2Usw6kpCLGy9D1nLh74nPgOzR3De59LENsV5zHfQdUzu
   w==;
IronPort-SDR: 9pxBptQ9t2Q13gMfm9Jc5KXnWryUeersyaEQ9xArgIIRe+63IQ8Sf4gsSohUhizTdOzIqEGSu4
 Q58hBOwA56qDwQqMDNg9nmlBLKz26b9E7rS5eYdxGNVQJykyereox4UI7guDJSshy/+E5S55jK
 b0lG2fimWWRLoeH4Dk3E79MW3nLevwXrBPTX3IWpzxhwuQhFSVOAha5LMXJUYpjzEUmAwCUcQV
 vlG8Xg6Pap4CAxL4pZw8GB9h5bNXIzluMvsZVo5EJdany6tMIjx6LZLqudiOCFweFjkA4sLv3d
 7m0=
X-IronPort-AV: E=Sophos;i="5.77,313,1596470400"; 
   d="scan'208";a="148452854"
Received: from mail-dm6nam10lp2107.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.107])
  by ob1.hgst.iphmx.com with ESMTP; 28 Sep 2020 18:08:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aCSnj3MLOEPG7jg6vHAPgY9uogxR5ha+PhEG8zz+rG66uBxij7elTFIFQn5Z4lSDpefbFDgRjXf7EFtl/cutc2yvr2MXJjxKzUM4Q+dXarqS6IZqYaUiGSsMh2DIliZ6ZW91nkkPQx2KjX7nxquTr/+H1ExIH6pPMSM74sGKR3OWkpEN138iLjsGmVBlisr3npO2KM9KTusc30GF5docbThG7r6QVMiupi3L2BYQkG9I3NawLz17Ivg/fWzgRjGTkSGlRfOPEYwuXmMh3dierhhd/UbNMo1JgaE5hKq8rFSdhINJSZz32+RREBp5U+Jkh18axlYKuKddf6srISNB4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e9qM8x7VHR4fGy0jt+/KA+E4pTXwJhMNSIt4IMEjmvQ=;
 b=Zn27RwK1o9Yn1Yli9H1kazx2B4UU+Qp5e04syfskkVVOouxEM/xEuphET1cqS0nlAaPQbw1qUwlw1N5PES3eQran0E77RgesfGhzdkPEy/4JOZ/C1qtqdbMzorNJ0LdQy2Jouwof31f0ImL0PmxDYEJNvHkfI5UZtn0m5FHQQoeyILR4cSIz2euoN2BcHYVp05/jpFgc2W+19RV5TTRMJ3guJG/YK90zA7AjawrFQ+zFvUH6bvs1BwWmI9ysZ4Yak2PwHgUctTmJvCFVkPMkgEgiNzwTBkXe5lSdkZJbYk9Fs/swubJg5koZyyh3xxxQbAvprlm8cPYc3IK5LvEvQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e9qM8x7VHR4fGy0jt+/KA+E4pTXwJhMNSIt4IMEjmvQ=;
 b=kRjreaz/7O7W+Dvx56nQa4R0XMojphkmCS2JRYSa0UJ2/WypGJgW4I074g9DxSEIGskJSZJky3FHuTsJthTCM3DnNDeRF0yiI64m80ua+ejuDKC+Op+qqEiTICVFw+u9td5twdifgHFFJL4yDiGnxiLyW8P5NfhqRKyMNzyIiLw=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1206.namprd04.prod.outlook.com (2603:10b6:903:b8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.24; Mon, 28 Sep
 2020 10:08:12 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7%12]) with mapi id 15.20.3412.029; Mon, 28 Sep 2020
 10:08:12 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "selvakuma.s1@samsung.com" <selvakuma.s1@samsung.com>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>
Subject: Re: [PATCH v2 0/1] concurrency handling for zoned null-blk
Thread-Topic: [PATCH v2 0/1] concurrency handling for zoned null-blk
Thread-Index: AQHWlX4IZbk5XA9mPUe5geXsiVF3DA==
Date:   Mon, 28 Sep 2020 10:08:12 +0000
Message-ID: <CY4PR04MB37518CD9911CD9EC1643EFBFE7350@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <CGME20200928095910epcas5p2226ab95a8e4fbd3cfe3f48afb1a58c40@epcas5p2.samsung.com>
 <20200928095549.184510-1-joshi.k@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:809d:4e2f:7912:1e64]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d1d4f5b7-4f28-48dd-c6ba-08d8639668da
x-ms-traffictypediagnostic: CY4PR04MB1206:
x-microsoft-antispam-prvs: <CY4PR04MB120688C7F92EBABA31734293E7350@CY4PR04MB1206.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZhBBPWNRhBYD4LoCmb8xxO++XkZ4XzUZJYLhKiVHfPhKE+NzNDIxYaUpo6NWHU4OF1ee5zTMCy/Ty4pf2ZPV828sZaIWwBJkdzqw2WMeyE0eaLrMfcUgIwxH6AxdVO9HfGPQ1YiUAqjZC0QuD7HY0w8VKeV6UvfDubc4hqB1cqHRtglT6fmEYIvwkyTUu3rs7fqqDEdcbVMKDQ42x5FbhLr6hdGSNHb0OpDohZJh5Nrkx8+DAeX+9NTXrCUQQzvL7tbirLswacZczJ0hahF4WLJlCaP1KqG85CKR8gW56bg2i4YU+2EEO32KBSjGTlLhM1lZzQDsq+H5nHoo/VI0kpkAWzXSYkPZodJ2EqwBSx3IZcU9hl/xxQF2nV8woZD0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(39860400002)(346002)(376002)(478600001)(55016002)(5660300002)(9686003)(86362001)(71200400001)(91956017)(83380400001)(186003)(54906003)(52536014)(110136005)(53546011)(6506007)(7696005)(2906002)(64756008)(66556008)(66446008)(8676002)(66476007)(76116006)(316002)(33656002)(4326008)(4744005)(66946007)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: qYH394BUP2+gYK4pQLPK0zxTurOWAlFnqH5DfQhvB6Gy5dZnzVHDY0p8f9AZOd3QEmywc8duKp9pnBWZfklKpJZe8jSPajpuqr2u12A1xF4M5oySQm6izBucAgsiH0xDgnLeg4WbBp+s6Sq6V4PX8QVhS9PaRng0nQUTqbUqTDRk84XCnZv8SZS5LzIk5u6v9PosFbUG6PrjoJ8INPF2mw1tMlxKJ8WLU+IaqjRdb9P3KN6pHUYplSq32hxdaOa46t+knil++ZovhgHPy5CbijkubiZwLJSg+zP36DXdB1n48C67/wKCcgdTSOfczQrrkiQJ63HczVZewPctae25VoFO3ZoMF+5WQZAeFPZ+KAJ/kgi8Nuuyz67hC706UrF7iLdloQUKplruPnapNoecFOeDhf366oeQGtvseFevwZSiU7KAWmrYqLT8+viLUkAOwyQfrM7reDt34WTwC+BHZDypwzcL8NoQVsVPFOoadGo9vNc5nVGPXIgLY36GD/c9JT2nwBIF/Cx/QHxLGGQhoyj63If+3IaHK5IFs+nDREvUYfzmL1ZJF4JGKQQth8EV9osWJrSXFWzfECjSl4OEmMYOpE9COAKc4a1IdFt64XBP9kSWeNCJBdpvkdj4gQRlo72mMOiNol/l8H2IufHBHefpnNMmsGj1HegCAaWez0WTVCceSZjfEzXJzPPgSvHysR1k3nrKHYNnr5Fsb/z3aQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1d4f5b7-4f28-48dd-c6ba-08d8639668da
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2020 10:08:12.6288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jl42ISS+s1OP8rkX3BPIAWeXOTwpcAZtssb/n3B71yJZMEQiM8+0D0926Fhz7Mx5cpItURtq5tqIQ572xbqe4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1206
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/09/28 18:59, Kanchan Joshi wrote:=0A=
> Changes since v1:=0A=
> - applied the refactoring suggested by Damien=0A=
> =0A=
> Kanchan Joshi (1):=0A=
>   null_blk: synchronization fix for zoned device=0A=
> =0A=
>  drivers/block/null_blk.h       |  1 +=0A=
>  drivers/block/null_blk_zoned.c | 22 ++++++++++++++++++----=0A=
>  2 files changed, 19 insertions(+), 4 deletions(-)=0A=
> =0A=
=0A=
For single patches, you should add this after the "---" in the patch file, =
above=0A=
the patch stats. This is ignores by git when the patch is applied (the patc=
h=0A=
starts at the first "diff" entry).=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
