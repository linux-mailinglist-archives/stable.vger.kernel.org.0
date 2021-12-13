Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29AA747236E
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233528AbhLMJEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:04:16 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:28410 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhLMJEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:04:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639386255; x=1670922255;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=TDujFsNMFVOuZcCCJo94gGidQ/Wr5DysFPeGld1fri8=;
  b=gxrl0AE/F53LkZi49q4Yk7biuLC6u8F6PFN36jSM6Q5A2CVYFuX2zDGS
   H2Z6VE5zH5R5y1uEAjxf8d9ZOcLfqKP4vP1o+G+iQLZEVe1jg+1V1exIw
   bZBzPKx0KY89+AWvMUjT3FP0p7JaPKn41Q9IJ8LbYLMSUpux6X0mZQG3f
   fmcSD9TtqkwyqK59dCSdwslcRPZdhcTK8T/LguqVx2slyPUsVcnnSNlIR
   oNbFCHuozE0cj5JWzA5OtSY81/AR8P5fhHjzj8oRyOdmmMSb4SPya1MmS
   3fNgajf/RJDgGKIGb5Z5rDhRgFxiaRKIGX4CdufeHDY5cgmnzVyLrPMkD
   w==;
X-IronPort-AV: E=Sophos;i="5.88,202,1635177600"; 
   d="scan'208";a="299951093"
Received: from mail-bn8nam08lp2044.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.44])
  by ob1.hgst.iphmx.com with ESMTP; 13 Dec 2021 17:04:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GcV7xXVpGTlQ5ELek9SLyoBDvj8KqF0QTTah7Qv7GY9UZ8uxJ6ImlnxLIeCq+fe6XQ1hrKwBG6XqckyJoYqYalUi1oyQ1th9l8pdkiYj+IwqI7wQ6xiFraWICfS3t/bEQ+6zOo8lJuAVEz55hNNyvsjrfq9AZk6mFSAzeXheQmnQ420k5ffDV7PYD0n7VQ7/1Urxw86b7MK2sFbC+ASh4+o2b3p6uyuTxPH1YFOBfuYCmFARPQSiLSF7ywXUNScIHhqJ3y+NYi9mY3rFuYmW6ZfDOnr44zwKL/V1n+4nKRckBkQP20W9p4Rl7d6LiR3IHh7722E4wnOHZ/3CXJ039w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=khRA6lZUo4y+izExcs7zlZrQbKWpLO2HZHuAfkRW9Ps=;
 b=fqANplMsho3mtGj3oY1hgp+7jXpXszszHomZyI6qd7LEp84Z980DCDHt+TlCd70wqA0xWqXhMQ5WRxg3PkSmL9p13Y1dwj3QjOHe/FXcGC7XSgW2OD9esakxbUw4D5MbMl3EoEjh24wTyvBT4P8TpXtucM6XM2NGyDlk/RFXOwZA6Ze7kD42bJtIejR+l5s/jZf9Cv+ToplwMcK9MdBjHMtrEquoI384LTQwdBz62rCdcDtunWJ5CZBYoRORi+2aTafVbvp+x/KeJmWx/N7eBk3ku2PF4GbRu3yZkNRw6LW5cK5Wq2fmA53PFV05y1CE+VHjkN+ED8k0QUUq+vW+uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=khRA6lZUo4y+izExcs7zlZrQbKWpLO2HZHuAfkRW9Ps=;
 b=OASAAzH68o99xgJEtkfqMxuj59F7xFOspgwRuNo1YWYVzGdb+cvCbT6AZfweyyhfSlcMik5DhktnmQL1d0myi41gBfnuqnEdIg3k6nW16O4jwbiTv+LsLvmqbHKFcKdB9v7tknE6L2KKJOSVACkCvRMCaoX8yL5bjBY7w8vHJCQ=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7447.namprd04.prod.outlook.com (2603:10b6:510:1f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.15; Mon, 13 Dec
 2021 09:04:12 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3418:fa40:16a4:6e0c]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3418:fa40:16a4:6e0c%3]) with mapi id 15.20.4778.017; Mon, 13 Dec 2021
 09:04:12 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "dsterba@suse.com" <dsterba@suse.com>,
        Naohiro Aota <Naohiro.Aota@wdc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] btrfs: zoned: clear data relocation bg on
 zone finish" failed to apply to 5.15-stable tree
Thread-Topic: FAILED: patch "[PATCH] btrfs: zoned: clear data relocation bg on
 zone finish" failed to apply to 5.15-stable tree
Thread-Index: AQHX72OLJqAc/lKd+02SWa3+kw0KAg==
Date:   Mon, 13 Dec 2021 09:04:12 +0000
Message-ID: <PH0PR04MB741665F6624813BBFBBA800E9B749@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <16393188751463@kroah.com>
 <PH0PR04MB74161D8CF905FE235521373E9B749@PH0PR04MB7416.namprd04.prod.outlook.com>
 <YbcCsD5riWyioUyI@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 834e64df-4309-4bd9-e906-08d9be178840
x-ms-traffictypediagnostic: PH0PR04MB7447:EE_
x-microsoft-antispam-prvs: <PH0PR04MB7447B3B9BC38000F8B84BE7A9B749@PH0PR04MB7447.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JaMYx+srylCj54un+j6IEfM91letzkFQfCE2OmfYWbFPDRJPQpFNfG51xHbViqpQeMc066oOGx/k8YcGqWBHGXx4jYwhL1HQjfKqXPEWqkMUKIfZ/JC7WR6XR+Pw6evNMytGIY8Cf/7c++GmBfIXDMrxo8uCfiQyitfesbZ4N6H8S4p32Z7H6rXr0zP/6dR1v6mtbYmfOmRFXY+4OCNYLbw6cxH8r+qtGzyaNic2/AZvVO0fxa1Wp/rB5QkwldjHgwo9q0k0HNu1HeT1ID2HTA+dyYt4JgKnrADMAeeDqhgYRfKmq8Dhi0vzcw38ybCEPrklTlm3d3sIHyF/1tbCtCtg/NRl8bWOmsKAtBw0Ql3BfbXjudMBrdoq4y//D/8dPK74EKmlCLAnG7IS+SBUU0hh1eVzvYM0cd1RDu8t06TQJXDoElq5Tb0I2N8LDGjH5foWhm36ECl6jKuGA/BMRo2Bnk6wIhf7OJTt6/It+h/inEv/uK+f7nCBRe8udKZKGDYnX9c1mA+Q7GLttT0jtnBN7QhHedH9pL8MCg8z7YLfa6xgggTjmHS/hMloE+Zj+vAz2J+lgkdcDofxutpZeaqvIx5gL/MrFLeWm/V9+HcAK/VJpUYwBHcPGCjQd8yQmih4/GQ5G1yuT3CLBYW64aJsYoBpJ176PAVu/gBZMQABgDWXudEmaggLSfcDp+8HoWrw2riOHncJKfekZ7IzBQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(4744005)(316002)(7696005)(33656002)(54906003)(38070700005)(6506007)(76116006)(8936002)(4326008)(8676002)(5660300002)(2906002)(66476007)(38100700002)(9686003)(66946007)(55016003)(508600001)(186003)(71200400001)(86362001)(64756008)(122000001)(83380400001)(66446008)(82960400001)(52536014)(91956017)(66556008)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?n94WQZPfBR/OVwrfWNDKfc8lhqXV0S4B2mMLX6sk996j/dQ+va8cb2VtA/JZ?=
 =?us-ascii?Q?tdyA2FFxHRvSFLzwgJdZN6ROYD2deT7H/yQRygJu03dw9aKdKpsNp/qSJ/aL?=
 =?us-ascii?Q?agOQXsU4kihFyBley1GZFe7k18VNmYJbIBo4EiTwOz9K4Ndv/6Z5ETIavYmq?=
 =?us-ascii?Q?whsjIUl9oK+jL6NYGiixd2nKAM2zx+qE+3+fqHEKZcFtSG21OuHxua/lU/kI?=
 =?us-ascii?Q?rymcpRvvJKbzo2JXaQfOIwWMjBFA/IEpNkN/Y66D47qVJ36Yb9S0UVdjgzgk?=
 =?us-ascii?Q?eIo3tvQQ2sPA7hMdwNW4mlJ3YHi8wQE5b9BlH2BQzd+GW13v0/tKZZAgSbow?=
 =?us-ascii?Q?jKFS+2RgNq+6Z+N1w9KnkF+br7SoItCV1lnnfuYSG/e1aawp7BeSsob5iai7?=
 =?us-ascii?Q?KOOr/omRPmeilMIyKZImdO0125NKZFmc/eJ+MzZyI6j/93KmVfFhpWaubPOa?=
 =?us-ascii?Q?2/Xh7BTPYdKCHEnnMKTSvZE8mI12Z21FA8nFcQ2aD0KMnOO5OjvqVOEc012m?=
 =?us-ascii?Q?+2lIpq7QNXYnvBjRPmwNoyeakHScwk8OkmgfdpgrRk0I43bedFsJXZMjnj7g?=
 =?us-ascii?Q?VqtBG0kiWJRyKVn+tA1uzCu/aqEoPtgGXRjm9pEG1PoWMwL9Q1w73bWCN4SX?=
 =?us-ascii?Q?uTJHnPQ/X4OA5z76WDEK+dlKq8pXhaUT/G55o/3XAQffdJpD9CtWqQVV6qwG?=
 =?us-ascii?Q?H8JMQAmxflhvaGIjq1nyJJ8SSE8rgRvn5zmh4hAfOmireD89O+3TZ1QseVcW?=
 =?us-ascii?Q?cOozXQa1jdeEVwd/7avT75cfPkuPeeyf8Jvg+70PAOjtGrdcZbK6qhmEvrBl?=
 =?us-ascii?Q?ZPrsgAT7faBK1gTUgEjZBe24woig7nFotcqZf5C8f1ogoiV7YlVqEHrRtpTg?=
 =?us-ascii?Q?GPEXt0l9pt4UeSH3mxqKM1MFX0k7bgBY1IkkZdOZcYJWIeptTCW2a6b5cl9t?=
 =?us-ascii?Q?UpHKGkEKrz2AYPQT1iGbfHknuoSMZ0RhDlNGbn99KGln2dPqQpdZG1yXnFS8?=
 =?us-ascii?Q?swYe7NQ0NL0/hvAKbSgyEax98U9CXmIR8R3OL/xkWKVGwX+auFN65yaPP8qb?=
 =?us-ascii?Q?Lm4GMd/a4E23AWOYD4kiJYZ1PS+bc4FXfeD/NSS+K/R1V5VUQvyfqKoMlg5T?=
 =?us-ascii?Q?OWqlqrjaHO+gHmJFiaAG/RTzBQeqiUKFRtpz3Z4YJw2sWaMLX0eFv6gLE2Xi?=
 =?us-ascii?Q?FKHDtY7WMM/eQJe0cfYElgaRQfscxykKg79SJjGgcr534v0V3CFjLPFkl1kr?=
 =?us-ascii?Q?hxVBMCuRRcLs8TfL/FOoXTPYlyx2MLe3BBrw4kawv8URfpx66lHFBxVGhtB/?=
 =?us-ascii?Q?ybkgn22FMgd2nGdJRZgQ5jfeXmyAO5j1r0mdBHwOdDw+j/wv6wfL0aTNFUSZ?=
 =?us-ascii?Q?9dopts30BRi3o+f72ws77mqz3S/N9iZXiFs+ANnKKGW4sy4qv0yJ59At7aMp?=
 =?us-ascii?Q?ml8+prggWqZxoTiCfuUc8uSbIaJKM/GYWiZhN5OQezZVbScuNqUmTgjDtqoW?=
 =?us-ascii?Q?xloAJxW9/7cAV85ZBNh+35fuuSlq/dnVKBo/1gsAkG9NLTgHyNCCdfINy5eh?=
 =?us-ascii?Q?4Ro66COu8XIHQGmPSebv2qWERbJphVR56LrGhBTuFOEtHxb4PryY6H4hkips?=
 =?us-ascii?Q?ZEg9S4uBPEjMIhJLm9iEbqQFvg1mWvSGCUYSWDN9isTzXjAC5N/Jh7Ls/1Ph?=
 =?us-ascii?Q?HHm73tJ83oo1jRbs/mHyCurznMUvmq1YO+mM7X7e8c6fftXPybetV5WxeW0O?=
 =?us-ascii?Q?zgUikkl0omtlBJj57mP0uQ9gm5pqTJM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 834e64df-4309-4bd9-e906-08d9be178840
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 09:04:12.7294
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R/Fdg0RiuVILSdF24KHESjIcRvHGLQOiWoGBv8eZVmiLdh3Je4rQZmpMjJatN/GlzHDmko1XF5+sD7bdX7pvA66uKXGrA48Fi79lyaBY/q4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7447
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13/12/2021 09:22, gregkh@linuxfoundation.org wrote:=0A=
> On Mon, Dec 13, 2021 at 07:34:37AM +0000, Johannes Thumshirn wrote:=0A=
>> On 12/12/2021 15:21, gregkh@linuxfoundation.org wrote:=0A=
>>>=0A=
>>> The patch below does not apply to the 5.15-stable tree.=0A=
>>> If someone wants it applied there, or to any other stable or longterm=
=0A=
>>> tree, then please email the backport, including the original git commit=
=0A=
>>> id to <stable@vger.kernel.org>.=0A=
>>>=0A=
>>=0A=
>> Hi Greg, =0A=
>>=0A=
>> this patch doesn't need any backporting to stable. The failure can only =
=0A=
>> happen on v5.16-rcX.=0A=
> =0A=
> Really?  The Fixes: tag says otherwise:=0A=
> 	Fixes: c2707a255623 ("btrfs: zoned: add a dedicated data relocation bloc=
k group")=0A=
> as that commit id is in 5.15.4.=0A=
> =0A=
> Perhaps that tag is incorrect?=0A=
> =0A=
=0A=
Nope, but 5.15.4 does not contain the functions where we forgot to add =0A=
the calls to btrfs_clear_data_reloc_bg().=0A=
=0A=
The bug was a race between me and Naohiro working on c2707a255623 and=0A=
afba2bc036b0e ("btrfs: zoned: implement active zone tracking").=0A=
=0A=
Thanks,=0A=
	Johannes=0A=
