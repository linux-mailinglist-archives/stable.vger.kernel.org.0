Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381104D85BA
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 14:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbiCNNKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 09:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbiCNNKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 09:10:11 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E34C10DF
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 06:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1647263340; x=1678799340;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Q+jd2IcRuCv++iDH6Ax6+uNV1maoyydU0UhpnJdQX8M=;
  b=meCow6en4QOn50dG2Q6i3/8mJt+Tp9wXeOJ0+Ty+DDgKtCAu+T5qL2pW
   2ypNOHmDn+Q/tZyiVDERwTEpryvGpY4Krco6x/2RhT++cUQYCpoSGfZpg
   JOK2skQkgu874XewhrE8CmvYQuLN8Keq0kD83um2bRRx5Hwr2cUNAGJeZ
   fvzkslJUbgKjVZuMV+zIV21AkGGZsOx6ucznON6B/G31Z11+QdnYkoAgI
   A6HX0cSm/yFUq1UpVzTLpvdTTts4t/R6iDE5r9OowAuZRxguS5D+zYjfx
   8cq40+yku41fZxpUy6S6FG+157g9aSKXuD5AhFNiiFrJ579Kc30OQuQf2
   w==;
X-IronPort-AV: E=Sophos;i="5.90,180,1643644800"; 
   d="scan'208";a="307262658"
Received: from mail-bn8nam12lp2177.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.177])
  by ob1.hgst.iphmx.com with ESMTP; 14 Mar 2022 21:08:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9NEqujTwA/gJEqNlPZ9DhISCX0N6gN5JcNtKWAMylOaRRm3VmohBWVpVCQ5seRgWsE4A7gH+7z31I+otV6J93d/RWn4So9fCAfORHEleT39KodYsr2HeNeeaXjzj7oTs0CBIxtgT3QL6ugxVnlP56FLRyrocqoKW4jDJQHsmrLtsgpRKyhZBjOYW6Xbqpu+Zab2O1drIj1+Jz+3FjlanllWL7gxhCni0EUW7bnrGv+dIJ+FrBtXZRJQQj9XhAvpmqswl2sLO9F0hbYjf3gkhuUC9PoqCD/R5Z+T00oBo5n666tkHVuFhrfcaTUCB7vovUAk+l8NFPD4+fpcier49Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q+jd2IcRuCv++iDH6Ax6+uNV1maoyydU0UhpnJdQX8M=;
 b=KZd+evEGnvqAQW6/NOqbZUvI22Mbl5AHB4aLWirkRjTzZTwEhpfxGV9roN6L+XDr3TY3qRZj88CKHxyxv+3FVOsy4l6nWDBmOC20UWw96qU/tGM0OPV9CYmAV0K2n3bsANItvoCZETLCI5fgVrPEyajIKKSB8IAVWtvq0LtOiJJcEWjY6qM1XtYTBUm/PXj7+FMsCRqEDqM396yTPYynrSjF99RUNeMyz8sNcSIVXlx/ZjXKJnEGaJUCiVJcEiIHmvIbZlJblPUZry8ZsbZcDC9kfErCKlny0ImGrQcD3V9smWkRyxX8jxKbGdqJ2w7MscuF/VOR2wPPj7f8iWO5Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q+jd2IcRuCv++iDH6Ax6+uNV1maoyydU0UhpnJdQX8M=;
 b=EKRLsoFrmeqcXII4Ke3AmTuHInTQTG0/agbVie7oD1rtCP0sNnRADFiE1rfU7xxUPF1bjLbBqw8W3nroTDnr1UdeQsWhQnCRhlBC5bMGzndZe0M+XeVbVn9AVJpsenNpm4WRBL9XM2dll+qEFZvgDZvQWir/KVQx/TUfL2U5CPE=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by DM6PR04MB4185.namprd04.prod.outlook.com (2603:10b6:5:a6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.21; Mon, 14 Mar
 2022 13:08:57 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::f025:4f23:8e46:b2ed]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::f025:4f23:8e46:b2ed%2]) with mapi id 15.20.5061.028; Mon, 14 Mar 2022
 13:08:57 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Christoph Hellwig <hch@lst.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: kintegrityd workqueue fix backported, but only to some LTS
Thread-Topic: kintegrityd workqueue fix backported, but only to some LTS
Thread-Index: AQHYN5mtjBWghYPVmkqkfGiiQU6Z4ay+ztwAgAALQwA=
Date:   Mon, 14 Mar 2022 13:08:57 +0000
Message-ID: <Yi8+aIyDFWCfBMT/@x1-carbon>
References: <Yi8r+UyK092FE12X@x1-carbon> <Yi809h0I28SN0qG8@kroah.com>
In-Reply-To: <Yi809h0I28SN0qG8@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8aa0908f-2ee5-4e5e-4db3-08da05bbccb7
x-ms-traffictypediagnostic: DM6PR04MB4185:EE_
x-microsoft-antispam-prvs: <DM6PR04MB41855546C8B9158706609D83F20F9@DM6PR04MB4185.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KMRuB81VD4WXAmECiPSbyvoDLvGI/lkvQiFmgl1mq5ZlRjndC2YJMbjx0CvMJCAXcXBiVoIbi+TSkdIlgafO/gZMo0VeFzynnjhzmPSXN1lpjlQHLmkBudquCsX3ASnmDGbzCNOJRv5CF11kItcxcZiDWq/B/XGMJJq0ISSUslOSSEYxkxihPoJ2r8eF8F0QAcWw+mGkIYlADPN8E2fsqMoVdPvmg554AApUdOiRi0lqqECbgwdcqray7PWyQ1Ng+yDfWPSGU5zG7BzukbC49+F4mksRWuosqbOo9yxZ7z2zarUOU7e8bYsnnP71qk8GtAVrg0U9ExFA/pkB+/crYcNinqWcZQpoFfApyC7ymGH8Qh3cr4jU/gmi5MzTSgHV24+O1Cfvz5LrOXrIl9a8ofOMOSx6tLnnPieAH0NEVQh+HCDLJhJpGLibYGpBXxD6Rxm28BjVLyBFWWxrz/ERjFTMf6IXC5oo5W+kgZd6prIensk95+bhH2B3K2GstH658+AP+29amHRG0UAL5ucpbh4y80MRn0rNbghfI9yBNTSUNWyfH6589cFtBVZYhWJ+lQNaWs8XxaT2ZXTf3Ro6bgDsUDoSj5Cn7PJsQyaJsfIYv0Pq7R4SaKiinTvz8A/JntFytnTIrGcEHLtbJwiAWmQdODRaoGSv9rafitHwKeYrpdpDVKHRA+uW3/dx+eKZPZatVt6kRm9cs55ASeob0x3Jw+xS+Ya9QxaBG9IkUDCTNNQEnolghGHerYAZ4aVYPo7ID68q1GQGyZSuuWZLYmhs1//50pgwJrF7hS2hAjE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(91956017)(83380400001)(316002)(33716001)(2906002)(86362001)(38070700005)(4326008)(8676002)(66476007)(64756008)(66556008)(66946007)(76116006)(38100700002)(6506007)(508600001)(8936002)(71200400001)(6916009)(9686003)(6512007)(54906003)(966005)(122000001)(6486002)(5660300002)(26005)(82960400001)(186003)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UV34mhdxzDclZkqeWImnveu0ung2tDuNmXn9xAmwPcO2bahQAxO7Bzmfv4O8?=
 =?us-ascii?Q?6hI6O+mebCN8E2XQFKSWvIEH/00Sl5bdC1//Su/1jCIhag8HHrkyCb4xrNV6?=
 =?us-ascii?Q?gzseQGKo02pydCYNRVEzzLDPf5tAShzMn2jfh8ife+ma9IBaDkemmxy4og67?=
 =?us-ascii?Q?CR1bBgcFJlsY33i7q8kqf3of45pGjXtTNNk4n0JVmDVNPmLEqLvmygC7/Q2l?=
 =?us-ascii?Q?bU+ZLGPHpL25I67evDMn5Sxu3PMxqhnKv4JDAm+SysRoqyUHeNIpZzVQdsEX?=
 =?us-ascii?Q?7OUGXY08sx1w4kUdxHTaOIW38/wgvQ+vSj+S2qLnA8LLB68IqiBjFUjQ/PcS?=
 =?us-ascii?Q?is2+kdXX0EmgseqywrIx2iOrPSbGJl7i/nDCHkly0Nw6YNJXGrAW9ql/ZoBy?=
 =?us-ascii?Q?4vfka2EIsLDWhusFs4wvqwrPAKUXZ/mbcUE+n5S+GPAqSYJAvcPRsTPlQQh1?=
 =?us-ascii?Q?+/7IoQiaQ1DYD24hAByoQ1ZeyV8VQpBgE0l4ZK2TP9Eu4lx42LT8QiVd3WVA?=
 =?us-ascii?Q?l6q8tWRh4HAoLIZoeQDlgr5JVZXaxV2cXkO0dAW0jc173N+rDLfy67B+WTVm?=
 =?us-ascii?Q?meel/d4q40qqtcwskBgldpQ05PR07UyXS9nPfkWeIZ2CCGkWxHEytkMCEqlS?=
 =?us-ascii?Q?URu/f8mgRrrHa+YgfRa5ewnNHLUpMeABWmBppCkUChBPjmj1vndbw/LCl6T6?=
 =?us-ascii?Q?hAcJzTp8VEMfEBtR1pgSH3LHYnIoRguXQCaVQ9zqcg/EMsDhOkd9dVD1FtER?=
 =?us-ascii?Q?TCcmwt0f6rBtQ/WM51xdpyNcx3jVwkuKbZNp7wIZ8K/iiOBOAbrV8guag4pt?=
 =?us-ascii?Q?SVc5FRvapSxBlMFxE0z2UuoFOke1f8TtPkWl2lB34X+0mruDlcOTJqezogMG?=
 =?us-ascii?Q?TTgSNRD2FXR4l9iUOpCXjDNGpE+kJAaPjMn3lpmk08P/3ljl+tpFrUrzNpi1?=
 =?us-ascii?Q?qMfit75UmiSGAuVbqr1rqD8lm3oTeP1gbfXDpUNJOND1o9pjBcwMWYrBMh8r?=
 =?us-ascii?Q?5wDaujgqSmmhs0XDkrB8WqEGy1phmr8kqIphNYltpGlm/bgcbBtrRjSnf2Tq?=
 =?us-ascii?Q?t0f5UheE3JV4g0YQpgUNc09l9qDMoIXdKCKpejjkA5QSAnkShk40DkjvJEhc?=
 =?us-ascii?Q?i73rhL2MC8ZRQ8D3YEVA4sWXC3Kjj5Xqfggav9baJogaWihAKMS6y9Tg235p?=
 =?us-ascii?Q?AuRznAtxCdBFX1HAWVCpj//VH5DTVHA0TEVgd+YIy6EwaKoVTKeP7r7/f+bR?=
 =?us-ascii?Q?7FuME6FDfYYjjB0b9nVNvsoTcRfv80QAfwdmipNpsTMaF+CfYLAPNLi0rBY2?=
 =?us-ascii?Q?r5VHaiFwdvo3Vrsy1mY0s76Pk+LAq2YcPkYYZO+5DOviTjzPKxmac1o4uaLD?=
 =?us-ascii?Q?PL2uJJREE6PmTWE8rgReOK/oTEsuVAo0H5xLbO7L+RDsiywQt0E2pq+uYudm?=
 =?us-ascii?Q?XEIdZast9/Vo41MksnPco2Q/7R82/cD4fBtXYxsvaS9mK2N13g2l8Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5B09C2467C10EA418894A88908073E1D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aa0908f-2ee5-4e5e-4db3-08da05bbccb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2022 13:08:57.6841
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U0qeQUZNKYEnDCV6+Llh7BFgz0tKD6kvXtjpIpeSGroSZs32NXjIia7ZwtQX1fyq+ROwLTrdZG59D8Y735NDfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4185
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 14, 2022 at 01:28:38PM +0100, Greg KH wrote:
> On Mon, Mar 14, 2022 at 11:50:18AM +0000, Niklas Cassel wrote:
> > Hello Christoph, stable,
> >=20
> > I recently saw a crash caused by the kintegrityd workqueue that could o=
nly
> > be reproduced on older kernels.
> > A null pointer dereference in function bio_integrity_verify_fn.
> >=20
> > The fix in Linus's tree for this:
> > 3df49967f6f1 ("block: flush the integrity workqueue in blk_integrity_un=
register")
> > was first merged in v5.15.
> >=20
> > The fix has been backported to v5.10 LTS branch in:
> > 1ef68b84bc11 ("block: flush the integrity workqueue in blk_integrity_un=
register")
> >=20
> > The fix doesn't have a fixes tag, but from inspecting the code,
> > I don't understand why this was only backported to v5.10, AFAICT it sho=
uld
> > at least have been backported to v5.4, v4.19 and v4.14 LTS as well.
> >=20
> > Original series:
> > https://lore.kernel.org/all/20210914070657.87677-3-hch@lst.de/
> >=20
> > The blk_flush_integrity() call that actually fixes the crash should be
> > trivial to backport/add before clearing the flag and doing the memset.
>=20
> A backported patch series would be great to have, to show that you have
> tested that it works properly.

Hello Greg,

Unfortunately, I don't have access to the machine. I was only provided
a kernel crash dump to diagnose the crash.

I guess I was hoping for someone more familiar with the integrity stuff
to backport it. Both patch 1 and 3 are unrelated to the NULL pointer crash,
and because of various refactoring, I'm not sure if patch 1 and 3 are even
applicable for older kernel versions.


Kind regards,
Niklas=
