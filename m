Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B24502050
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 04:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346170AbiDOCOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 22:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343504AbiDOCOK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 22:14:10 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2DE1A393;
        Thu, 14 Apr 2022 19:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649988702; x=1681524702;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zKcMh1uSuv4aANQHEyO6VkNKNbIFKvpALVi3DILMBUE=;
  b=AGRzpviFM7gO7I1Smh/G43bxIg6sULfUa9xvMLm9YMpy5i24ZPew+hZV
   anhPK58mGrHbd3SZ4WUUwGKdykXXXUQJdz/KM89KNrnjj03VileM+5tDB
   Ol9uRPIzWjJEES/gvwWi0fm/P6XD4vVRDHOn4lDJFdQS0iduObTQ2+gCs
   Q5NJXUpJJW8IBZDfElkZ1v1+4NbX59H2q6aGfysqVnvwwDcz+QdfLNNVJ
   hvmJGbgQX/q0kVZ1MZgqK5IFonKYrBc85nvg5jlFNL0ADbvjJrclS+k/8
   hZNKvKeITmX5nqp9Q0hEM4YjZgl0N3cu1G0Ry8h24G0YF/O8tlQFiRkXd
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,261,1643644800"; 
   d="scan'208";a="197962070"
Received: from mail-mw2nam10lp2101.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.101])
  by ob1.hgst.iphmx.com with ESMTP; 15 Apr 2022 10:11:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OHmrujZ3WJ8l84gr6ATe7LZdURYMXijCcQwIanOtt0RNcfT1tH3P++2p3leHe41iZz1rxacKPoyjfC45YBL6ObgrfvJ7eOQZZ5V5XljTWo+/AvzAdSkWwOls7wzYuRG1RWyLajc1XZmGaJOGaYO1C6l67oSR4lSgg6yZFoYttjGvV1jaWnc7Ek4RHesizX2km0ZskfZ32QAC5Sc8DymoUS9R3Ywc7ZA59VFVim1oA8tmVdNIiE3aUTeY/lj6Gf1NbhqG5vQmAF7qZ8cfV4y2F+BmK7Na5aULuJ6sWZX/FBE4x15yPZEm2/fCLTfgPRAymtHlp3Cu4pOpHhhYrzYalg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zKcMh1uSuv4aANQHEyO6VkNKNbIFKvpALVi3DILMBUE=;
 b=S7CFdtNBoqMKwJWfMcwNPbzZonx49fp7Coz7e72rv6qF7RusF7Ag2S3MPVrPpVDGZiKPOcbpwn5NkQOncdF8Lu+2RTmAB8uKUiYAqeq8UGmvl64V0nv+se7/ubAj1j7Se73TvXifyBLqrxhsD9FayN35U8qIKmp1o7xlqhVWfs9eTX09hkA9+f/hYVsdprCYc8tBDUBwlgm3Pht0PcXBO/CYkqn2Fjc/DSY8w/tr2aowl18s3ab8v0q/Z3yWvU72XRzMpotyvgAenO2cpZrtnAgvQs8VfIbSHD9ugUbdsNHbp+1A9C4qKC1fsJkJvDxJXuu/4wuxZ6tSqsLuc2Vliw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zKcMh1uSuv4aANQHEyO6VkNKNbIFKvpALVi3DILMBUE=;
 b=RGi0U3kLDseKoqAKpbQHs32r0eskMq1lxaNXXnZf0zwOp2/GkelTlYXINXg3q5rXVcrmeWs/5xjfRt7rXvFLgoLcwTpgbZa8CNFccJ9nIeiCWu7ZGu2UuOquJ6KwupqIQ4X0R7Y/A5zzz6rUCrCPCWFlnEMnJ22YHJQbjWaA0kE=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by CY4PR04MB0393.namprd04.prod.outlook.com (2603:10b6:903:b7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Fri, 15 Apr
 2022 02:11:40 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::995b:363e:8d1c:49af]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::995b:363e:8d1c:49af%8]) with mapi id 15.20.5164.021; Fri, 15 Apr 2022
 02:11:40 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Mike Frysinger <vapier@gentoo.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH v2] binfmt_flat: do not stop relocating GOT entries
 prematurely on riscv
Thread-Topic: [PATCH v2] binfmt_flat: do not stop relocating GOT entries
 prematurely on riscv
Thread-Index: AQHYT9+B/BNFs63JH02JGuF3zm1OJqzwFV2AgAALBgCAAAcwAIAAA0oAgAABboCAABA9AA==
Date:   Fri, 15 Apr 2022 02:11:39 +0000
Message-ID: <YljUWpq42t1gQFRf@x1-carbon>
References: <20220414091018.896737-1-niklas.cassel@wdc.com>
 <f379cb56-6ff5-f256-d5f2-3718a47e976d@opensource.wdc.com>
 <Yli8voX7hw3EZ7E/@x1-carbon>
 <6ee62ced-7a49-be56-442d-ba012782b8e2@opensource.wdc.com>
 <YljFiLqPHemB/u77@x1-carbon>
 <9a9a4dcf-0ea1-01ac-d599-16c10b547beb@opensource.wdc.com>
In-Reply-To: <9a9a4dcf-0ea1-01ac-d599-16c10b547beb@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d1d2bf2f-ea1c-44bc-ead5-08da1e85473c
x-ms-traffictypediagnostic: CY4PR04MB0393:EE_
x-microsoft-antispam-prvs: <CY4PR04MB0393652883C411723C948FB8F2EE9@CY4PR04MB0393.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2syTxO5bKAY3inVu0xVgo7f+rgY2oXxfqQvQTHSgF9LUXLIao1SdtCUSxpxn2vIJGxRLzm4O07au1O3tx0qS29jYzBGUgh/wi9lTGFL+XbuI8t2mu2QmeQ6tXUDs52mH71Vjr+Qv10ifZWoPq802Mhz0Z/K0+7R2d7YowTPeFo0pC1WtqxuDnh1f0c2RAjdS4JHTEvnRRF22AoK/ysZZOIKtWi2fYek6XQKXIjRhyxmYjuOeXNSGJ9aMDVSd1parpLWmSruxJ0UcGHEBzHe2M88I+87ijh/+Tk3vIH7iAHzeALj4NSKwzYQPFj1Rx+C2USCCEPJ7wpWd2O2eO6NhLpqbBsqFHxodw967i1kHhqcB8+d6x4T8P1RDZh1xPkmadYib92ta7o1gBCVePK4nWCwOhyskuyfnzooJ1qGaQzABIbdgRIK9ZM46TsCaJHsD5yDWoORGK5hrNShFO5KBUOYjbBNXvH062toTfFT6WTfHUrMo5bBC/gqQjuGXRgG5eXyFdljkGtnVby2v9vBdGY82KepNxnRABBMrX1LrOYjlN27u1LaePBx992GrulU/6CD3qB5dSJUXU04/qGPaIIzXosPdSuWL/4nZ/zzJSKFx2CE7lAwg+lNcsIJkqVZ52bytL0JvILYG4ramvb7r9vZMoMUr0lYSIZT41Ftsxx028/+8Bhmt6sCiFEM9WioD4ZXJncDVR1145p07tsB7DA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(122000001)(82960400001)(5660300002)(7416002)(54906003)(38070700005)(38100700002)(33716001)(316002)(83380400001)(2906002)(86362001)(91956017)(66446008)(6862004)(8676002)(4326008)(71200400001)(508600001)(6486002)(66946007)(76116006)(66556008)(64756008)(66476007)(8936002)(26005)(186003)(6506007)(53546011)(6512007)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ec/DdO5KKXr4QOWJ69QL0sOv8vC5DzjeMc4URXK4c+VPgLESn4OevtIXWvkN?=
 =?us-ascii?Q?1evKJAFIrWtO8VfM8nkOlUtyzzYnuipfUGPHHIBi8S/0W+3tvQT19klEsaIL?=
 =?us-ascii?Q?YoMz09rMaE6U/Or6u9ggx3azdATgHoBgR2iRugoHfj+hmvwJz5z4AQOol+KK?=
 =?us-ascii?Q?8vjwWxcGPUDInyrkOCVqL5mWFq+e7yvRF++1tvEwH49HGkCnyM99DM/zLL/n?=
 =?us-ascii?Q?fEC7OwX6FJJBR5eyhaZ8dGJqgJppN3mHgaYkti+ywRlRShenlsg/twXOAOhg?=
 =?us-ascii?Q?r5QYAkT2nzne+8TrcKx5L/Yqfj0vPhjX6Z8+LnirJJ7sPSqC4QytaDJOl0/0?=
 =?us-ascii?Q?WhyKcue+k1sraD5xEtbi3SIgUDSa4CpmbaA9dgn0IWrMJNYkxOgO3KaNSmsG?=
 =?us-ascii?Q?Jr8ecYhFRikcHfp56QDYAfeMSBNpEbObUk3OVXAtDJyRtoo87hv43iKagS2D?=
 =?us-ascii?Q?a8vDMX7o8Srwo56AlzS2L5Y0F8CvQIVPl35nYJEBoeMUHHgCQ3/BMuW3U0Nc?=
 =?us-ascii?Q?XJU2FedkiYplrxtfPCyPcVQszoQ0xhjZdNVVyaUJT7jtz+SkNBTGZxRLeUsr?=
 =?us-ascii?Q?3X8QcptOHl+jsTACpogbNkHbFIeot+ut32rCbGWhyLZwrO6pJvaRxvJ0mcUB?=
 =?us-ascii?Q?uiiCHCZqGJNWpBNDi4fykVcDianpAFcodgw9kPVx6286PoC0DKNanDVlHN2p?=
 =?us-ascii?Q?8mIJoHqv441e0PKyd+xZMf45uiOdGf75FO0iAvDlDoI2ENOzvBFnQ9hjK3Xg?=
 =?us-ascii?Q?vTFUBSe/qAmd7GvsSEle2R/nDcTb2UEWdci9ZRcRoqgpaFe/MiXmJYMGAKXL?=
 =?us-ascii?Q?FVDlSNL9GMh1KwNBKKDshGM6FiKRuv7g4Ahaje0R6mO0bmbTpJBg4yrcQhNx?=
 =?us-ascii?Q?BhC5lzmvvTN2QxO1eUhzqjr7xUu4DlN2o6EC6WEbcroqGt7C+7uC3Z7KOcZq?=
 =?us-ascii?Q?hIm6fqOSlyqXeCRHUcQjrxSehg3FNuxOZ4kFqMEDlQPiAlhy4mo3MR/O8gni?=
 =?us-ascii?Q?V6aolrj3LJq6xrNnWohvHchlqNpQUUvga2xpixCK13z+jVG2nXBQZFiWEIL7?=
 =?us-ascii?Q?e4LiV5EuINJQGMuDmp5ydP59ZzL6Z0e4kHh7JALnG9UOSVz8LRkFJuv+KhPl?=
 =?us-ascii?Q?ZdVj8T8jeO66gJOx2mtxfnR7wOSXqzTmI66tadY4iV1JRseuvzVT/xzATbPa?=
 =?us-ascii?Q?7+1tFQPfigNbNK6ulSbABWQ4iIsA6aJCyzqpish3zrhDMB+XEHrmeasaaYhN?=
 =?us-ascii?Q?SIVsxUXLKJDDyKMheKmsgRx41O8Pn/6knqQssx7GdxxJUS9gbg+5GeeUKrGh?=
 =?us-ascii?Q?r0wGw7Wdt0AaQg6KyWm/4VXAONcY4iGQRa4VBwrAv6AATfrYhdu42wyMoX/0?=
 =?us-ascii?Q?pnvWuF1oRygAwVYxFyC9+LgMA2xW1qgVHaqzQx6+cUd/W2kYRcsbtV45En6E?=
 =?us-ascii?Q?tCjff5oaPuiM1jN8deYdC/k7AzxY/sXYVIYCJoKP0u0xO0Bc/SDl9UOonv6G?=
 =?us-ascii?Q?v4++HsUkhZCNMznAHm1b11M3W3ZMaL51gWOlQbBdm3IvV5717R9QS4g1S9Y5?=
 =?us-ascii?Q?4hpb9Dj93kxtY6Q4MjqXoa4xaOQjwuMwYZ5ZG5phHWloVp6OBIt5Fy/yH8j8?=
 =?us-ascii?Q?ZaTRucjxcA2nxytRJzoc+LHWUQiIt2ybx2ASgVPRmhLSs7RoW8ajVO7rpjCN?=
 =?us-ascii?Q?n1gv6BTTRTliln4xBPl6fXqaR3muqVasgZ8AhWhTwBKrXJy07UH5U/6xyMvb?=
 =?us-ascii?Q?nqQiSVkhb8vyzTZ2rJ5glnQhLczHu2o=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8F37960F8EB37D41819B15FE97695048@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1d2bf2f-ea1c-44bc-ead5-08da1e85473c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 02:11:39.9598
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zA14FSkNUOohSp3JwDWX+D2dbULLyV6+RGs93KXgCwXxO4GEPXzG9ssJC+r708aA0KOssYdyMhsxrJPHGO93Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0393
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 15, 2022 at 10:13:31AM +0900, Damien Le Moal wrote:
> On 4/15/22 10:08, Niklas Cassel wrote:
> > On Fri, Apr 15, 2022 at 09:56:38AM +0900, Damien Le Moal wrote:
> >> On 4/15/22 09:30, Niklas Cassel wrote:
> >>> On Fri, Apr 15, 2022 at 08:51:27AM +0900, Damien Le Moal wrote:
> >>>> On 4/14/22 18:10, Niklas Cassel wrote:
> >=20
> > (snip)
> >=20
> >> So if we are sure that we can just skip the first 16B/8B for riscv, I
> >> would not bother checking the header content. But as mentioned, the
> >> current code is fine too.
> >=20
> > That was my point, I'm not sure that we can be sure that we can always
> > skip it in the future. E.g. if the elf2flt linker script decides to swa=
p
> > the order of .got and .got.plt for some random reason in the future,
> > we would skip data that really should have been relocated.
>=20
> Good point. Your current patch is indeed better then. BUT that would also
> mean that the skip header function needs to be called inside the loop
> then, no ? If the section orders are reversed, we would still need to ski=
p
> that header in the middle of the relocation loop...

So this is theoretical, but if the sections were swapped in the linker
script, and we have the patch in $subject applied, we will not skip data
that needs to be relocated. But after relocating all the entries in the
.got section we will still break too early, if we actually had any
.got.plt entries after the .got.plt header. The .got.plt entries would
not get relocated.

However, the elf2flt maintainer explicitly asked ut to fix the kernel or
binutils, so that they can continue using the exact same linker script
that it has been using forever. (And we shouldn't need to change binutils
just for the bFLT format.)

So the chance that the linker script changes in practice is really small.
(This .got.plt vs .got hasn't changed in 19 years.)

But if it does, we will just have one problem instead of two :)
However, I think that applying this patch is sufficient for now,
since it makes the code work with the existing elf2flt linker script.

Adapting the code to also handle this theoretical layout of the linker
script would just complicate things even more. I'm not even sure if we
would be able to handle this case, since the information about the .got
and .got.plt section sizes is lost once the ELF has been converted to
bFLT.


Kind regards,
Niklas=
