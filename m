Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE412F0B14
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 03:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbhAKCsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 21:48:09 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:53582 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbhAKCsI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jan 2021 21:48:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610334310; x=1641870310;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=hAxuyY4Vixf+dp4TqEvE1evcq4308tPELmMANXkH3TY=;
  b=TBWI4w+T8piwVK5Pz5sn7p/1rzeh+XsN8NtLQcGizz+GLbCxlecchtzM
   zcX7415+Ob9gm/5tMDYlYJ50tPrq/htABrTyJmh3VkyLBWygn4VKj7eM9
   0SgWqziiHVC9PQbUBdv5dS9L3jkyGqr7Wyvkkqkha5cljlaC2/dvAXHLC
   shFItLf5wH+p5mhCBrV6bwHrh5Oqpz5NhLs427t4LkaGzPtR4DkPFIbqB
   bwzH1v4NiIvUjV4W+6IDNK75QLnAOkP5WrGl/JI7w3wIANS6iaHj7Fmzi
   0BO2G4eOeKdpxNyYGSX/YphiAK5L9nRM1rIzmYuTm8UDoEtLuy0J8UdIi
   Q==;
IronPort-SDR: Bfa3TkHetboTo4pGEQyuCOTNvltjitgjtf9YgfRwgT9rcKbgJ36knbTvGFXOVQXvqWZvHnlfif
 kGsmNaTwQjfBAxZ/zj7JeanMrMuiWlFhpbk6tfSI4H8OvR2F8YsYodUA0e34flzdkho0/90CWn
 ThETUehs01kf8A7yQygBqd2Z2fQMsvaIkoPgo0HXg0nsKKsTFWZHc2X2LsjutoXUSbs53wkyOf
 AlS6T5S83BmMABBiiuFZXJ5OuBqEKtoH7UCYtPrHmeEwqTuUJYR8LpgaEOkmLBC7kDkXp29Qcn
 V+g=
X-IronPort-AV: E=Sophos;i="5.79,337,1602518400"; 
   d="scan'208";a="260999465"
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.169])
  by ob1.hgst.iphmx.com with ESMTP; 11 Jan 2021 11:03:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jjVYq/QMM6r9Yn6yQcN5Nxnh6c6/C1E9cPhUUUmDlou4PBa/aOs5pU32c/WpiP+Bpu+Iid7Rv9Gf4pD7FHsVSBpR4M9HHWScDBD30Rin06r8WeTPCsm4GZXaNZX083VQssxISDWVsYC/zyz9RLsCalOj4809/Bp3xOkZEAYNzkgjoiHFAdn9t+fQPR9Xao1/YuWUBX732npdQRIVdaJ2maY9UCd2HcZfjOMRMI5haPjO6L+Jk2ZM2PjvgNG3zXbDAsH5k1uI3tipmQfM3dxJaC74RokC04+gsnhCuZWm7qVNqkDxTJW8Ru79P4jxbpAfYYPB2qBG0joXThw/m6qy3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clbEmvVlAnF7drGq9kT7b20vaw60EOtEmgOkTRFukho=;
 b=FCFdpfQqdzIgc8bTAJovuATBkcFxHFqzu0ka7KezvJCFfxMEjZ9p4qmPos9+ANgCcMNP8wR1PEJ5W/sSpVklwqnU4qgvczthWpSo36bWoLJvVjnsT0F5scbH2bHk4ye2dnVOtNRu8+g0NQs/orZyfu0vceMvXtOff7o8PbRN2/0z2Wrj+vDJSLYYXilWm7/6PX1RJ1+CheFohkZKldZn+ML3wwbVFZkHHdiZp0ZvpGU/Y45pY/eQUg316vEren85/pFZN1eDmwu1b5dlNahrTFBYWqI+4hzy2MHK7R6RnbXPBztnF0O/Wl5y1ydzKGkDCq56Y0F9aYUHJctn7ymExw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clbEmvVlAnF7drGq9kT7b20vaw60EOtEmgOkTRFukho=;
 b=bUe7bJbXU8oulg3PDfahXwiH/RbrkgvjxFFy7LnYMSFGmv2J51ACELha0sS3KFmTtviiwdyXI+aqzttIh+HwTsKxkJLTPXeYi0dQBg0WVKn19Gta5UVqCOQic1jmqn81OddaTbO4i7iABpAJy475XVlBGlhD8c6IQI25LHCPjC8=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by BL0PR04MB5089.namprd04.prod.outlook.com (2603:10b6:208:5e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 02:46:58 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::2dbb:7e01:f076:eca0]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::2dbb:7e01:f076:eca0%9]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 02:46:58 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Naohiro Aota <Naohiro.Aota@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 4.19 13/35] null_blk: Fix zone size initialization
Thread-Topic: [PATCH 4.19 13/35] null_blk: Fix zone size initialization
Thread-Index: AQHW4rJrXEheF1syA0iwzTfipJ4Neg==
Date:   Mon, 11 Jan 2021 02:46:57 +0000
Message-ID: <BL0PR04MB651475838D5C8FF0C6157F6EE7AB0@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210104155703.375788488@linuxfoundation.org>
 <20210104155704.049016882@linuxfoundation.org>
 <20210106125449.GA7589@duo.ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: ucw.cz; dkim=none (message not signed)
 header.d=none;ucw.cz; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:b89f:834c:8952:cf2d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e2b1e79f-cf03-41ae-a46d-08d8b5db2a18
x-ms-traffictypediagnostic: BL0PR04MB5089:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR04MB50891160D5B30D6CB897AFE9E7AB0@BL0PR04MB5089.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3lP2tGPPvymHiYWBma5r+ztdCor9q4uD1sATkUPMoloo7Enf1xnxnvblY1Mke8khQAVaH9zeXM8baZ7HX9Vn9oGud4kPNLpGWq4StfAKLDWuGimebyPBewKCIJh74UtaFstnEwheRE36Wlo9KGrt/OX8BYV3PdKZLD9PANOTdxX59orb0+BXZYMaxibvlvPt4jZa1hx5HATjWPXLgzUd9S/B2aYSC3sj14mqlwMYNhYiq5bwEptowwmuQiuNl/uZgBEkZgoNk4j9qdZYSnEEUKMvWjc6b4y2uN3R1xy7V88Nsc0OclT+pBMdJR8wzkSVDzzeQ5YW1auC/WhA5zjEYJLZWCWJe8fpgeteJi/lC4CEYR5cAzCzidaaEDxdKyzlMouzMyAFqWAaGaC67yqPKQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(52536014)(64756008)(7696005)(86362001)(66556008)(83380400001)(54906003)(2906002)(33656002)(5660300002)(66946007)(91956017)(76116006)(53546011)(66446008)(110136005)(316002)(71200400001)(66476007)(55016002)(8936002)(478600001)(6506007)(4326008)(9686003)(186003)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?8F1XRHOZb9QYQm6Yr1zKFb3KRlm6NhHWArSIGbOLiDNKb2QFUKRa4kwl3mRZ?=
 =?us-ascii?Q?C0bgG8DuFsu0KTj0TaJWpsC3Tw/42c7RXVmaeLfTUrv4f4yRUNG3coPsWVsV?=
 =?us-ascii?Q?WtDJY3bFq8weUHpuH2LLftY7t6flZdG8/I+FpJ8U+jhK+IjMluh4pjgQmi7D?=
 =?us-ascii?Q?2bhT5mgSQN6JUqZUVpgWFPyhhpaoKlbRtIg4JQvdMSgzgVW4NKKSgK4QOYkJ?=
 =?us-ascii?Q?YMXYyiHWVF7SyYbS0XUTxLbGMIa68a2lQXzUAC25eVhWozXwdTzhhUs8ya7+?=
 =?us-ascii?Q?lH3UgCBMp27qo1M6wzIOI4vZkVebbK4iLfmL8wp9mf5h5XrQtfjFj6PzDH14?=
 =?us-ascii?Q?gPFuOYQYR9qYWcjE6tR+mNVwBjgvHClcUIcWt+dyP7bieEN2oFN4SGc/M8aW?=
 =?us-ascii?Q?SRvUgmk7w3PXoZ5PcPiV0o7o3VHIHszprZEFC9MRodgc5Wmj1hKZtj5BW9U2?=
 =?us-ascii?Q?7H3sodGgGIVPrN/U8ZhRiYr77ApduyskY53M8PUXI2d5AfFrhd0vB6K3MBDg?=
 =?us-ascii?Q?bMH5fKWuAZKTqMqWVRYdPvbwGlhRikcISncq9YHeXLLrTr9j7nC6fm2L3E7C?=
 =?us-ascii?Q?KwXydZ4IQwP56Po+wuO2m0zM8qWsW6dyn1SU4IZrQ9HMeA34KQihXTTb/wdc?=
 =?us-ascii?Q?1ii1OLV/Qz5vE3dNb6wwg+2SAt6wCUhCnDskFxUK7kDq48KGW205YR5ove81?=
 =?us-ascii?Q?nmV/HjfmzhCNeZDywD7TBu5vuUos+5PX9+51xTA0Wsm17shFwXeUXt3qgYVa?=
 =?us-ascii?Q?3MtJ9U+4LABEYBqYfnIZ3tS7S99feueoRbubAeHWuUplDRslv+3OQTqt6nw6?=
 =?us-ascii?Q?edpI7HQ2Ni6smN2wzRr6JNjPLddk06JlcFdBwGUU7ZXfEjY/9X71yo9XfRBh?=
 =?us-ascii?Q?FOKenAgQuqqZybuOxQQ7dSHYXXQZ66YsWUMDFZVcmR0IbiIGgnDhu4y1JCnr?=
 =?us-ascii?Q?PRo+l7Fn1/aC3aFcvrynAjbwOh12PSwf7HOmCLWt9h26tthn8PKTzHkte4D0?=
 =?us-ascii?Q?h/w2nHTzboRi6vm2j7NSm+Lm9NpnV5+cYsKOkXTfI1WHiutK06ks4ZtqWrHh?=
 =?us-ascii?Q?sWzOSoX1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2b1e79f-cf03-41ae-a46d-08d8b5db2a18
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2021 02:46:58.0025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m6pksFCko5aUkBx1BlSXKM2pbzp2S8D8tHzzby47HHkx0WSc0nyp8M3vtAdiiCdey4QaP9rdQF2hbtKxODngug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB5089
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/01/06 21:55, Pavel Machek wrote:=0A=
> Hi!=0A=
> =0A=
>> commit 0ebcdd702f49aeb0ad2e2d894f8c124a0acc6e23 upstream.=0A=
>>=0A=
>> For a null_blk device with zoned mode enabled is currently initialized=
=0A=
>> with a number of zones equal to the device capacity divided by the zone=
=0A=
>> size, without considering if the device capacity is a multiple of the=0A=
>> zone size. If the zone size is not a divisor of the capacity, the zones=
=0A=
>> end up not covering the entire capacity, potentially resulting is out=0A=
>> of bounds accesses to the zone array.=0A=
>>=0A=
>> Fix this by adding one last smaller zone with a size equal to the=0A=
>> remainder of the disk capacity divided by the zone size if the capacity=
=0A=
>> is not a multiple of the zone size. For such smaller last zone, the zone=
=0A=
>> capacity is also checked so that it does not exceed the smaller zone=0A=
>> size.=0A=
> =0A=
>> --- a/drivers/block/null_blk_zoned.c=0A=
>> +++ b/drivers/block/null_blk_zoned.c=0A=
>> @@ -1,9 +1,9 @@=0A=
>>  // SPDX-License-Identifier: GPL-2.0=0A=
>>  #include <linux/vmalloc.h>=0A=
>> +#include <linux/sizes.h>=0A=
>>  #include "null_blk.h"=0A=
>>  =0A=
>> -/* zone_size in MBs to sectors. */=0A=
>> -#define ZONE_SIZE_SHIFT		11=0A=
>> +#define MB_TO_SECTS(mb) (((sector_t)mb * SZ_1M) >> SECTOR_SHIFT)=0A=
> =0A=
> This macro is quite dangerous. (mb) would help, but inline function=0A=
> would be better.=0A=
=0A=
Indeed.=0A=
=0A=
> =0A=
> =0A=
>> +	dev->nr_zones =3D dev_capacity_sects >> ilog2(dev->zone_size_sects);=
=0A=
>> +	if (dev_capacity_sects & (dev->zone_size_sects - 1))=0A=
>> +		dev->nr_zones++;=0A=
> =0A=
> Is this same as nr_zones =3D DIV_ROUND_UP(dev_capacity_sects,=0A=
> dev->zone_size_sects)? Would that be faster, more readable and robust=0A=
> against weird dev->zone_size_sects sizes?=0A=
=0A=
Yes, we can change to this to be more readable.=0A=
Will send a cleanup patch. Thanks !=0A=
=0A=
> =0A=
> Best regards,=0A=
> 								Pavel=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
