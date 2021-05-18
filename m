Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1AE3870D5
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 07:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241374AbhERE2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 00:28:53 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:2073 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235926AbhERE2w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 00:28:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621312054; x=1652848054;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=riOyWCGCfagiaL4/BqVrgpz2q9ai3y4RxtrWAsDd7N0=;
  b=h7ZXdm3EWfDT2I/7ee7qgbAAu8hnmjqLg7k85EjDuhBZcIlpoOlXcbxO
   jO7YCUhbql5h7EG5Pp4QWbjU8CySumflYjt3rbfFTcklgu2xhCzZLHNbS
   /2N2ztBVyp1aT94c4I2O++mIwtvLb3jyfpVTHq8/2sc7gfGKaxmqH+ykF
   t3FY1T5sJEZnOtewvRcLbLDixoNcKyQG07OF0Va2W3C+AKfDOIbdb6yZL
   cYMofO+ER2py/H4lU8zCgQoq6xWHlAOqld2IJVNZgwF8mUK3xLwFMlHVY
   4EfDnA4nlz19QuHI3GzUncmwhaHUFvdBhcB4GRfqaHR7gIBQaxm5ix3yi
   w==;
IronPort-SDR: yDmB2cse2XETlLYvxVMxeE2kZJuL/HhTvHLKa9NhXa3hA8pRZaJL8z09Fju6+CW2nJlUIxcXQ3
 ga/hk1Vl9s8wd5ZGw5zXlYXShWfnwBfqJ+vMjOa0xqERxc4Dl2f4vYiV2WieJX7/9xQKCW6NN1
 uWYweOvGqkzI8xfHfzwttdrgBh5DSipwPFQS33A8UbaF9cPirbOmzrJK6Ktaq+5dwqbN+AK6Ba
 95cuJF8/cbE59MysL2quIZHbeoB4QK5XhXYxY23F9G6D1ILkQfHSHd/2cZRj8rpZjJo4TOfA50
 AGo=
X-IronPort-AV: E=Sophos;i="5.82,309,1613404800"; 
   d="scan'208";a="279742612"
Received: from mail-bn7nam10lp2101.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.101])
  by ob1.hgst.iphmx.com with ESMTP; 18 May 2021 12:27:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=maanQMGJRAL4GFamqlxUDK8nc6gh+v+B3T+toNiorRw1juOAtlqltEddllJHYB76U6B3Ri87RBv2lnxzSZ1XL2Uzj+ZyJbcr8b7Ixz3EZRykwz6YYMwvrSt+z9jb/w0jc9zHjXna9v+sSpFHmqZ64l7Pnhpu2LIU3yo+i4ULF3NEXNGuJSafzswfz8Q9QOo4XmzpAtm0xhCXKYZXo8KHfMXnSBH9cUbQ5QeuVVro6fcrsik5nZKYWhbZ22x80jf6rXSnFHg70dNmkiaHDgoqBaHILE+YG/nGlcAZPgN6XMs5R8KCpKfoBKYcC9jyIHtYbR+EkjZCdKpefdLMeyav+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=riOyWCGCfagiaL4/BqVrgpz2q9ai3y4RxtrWAsDd7N0=;
 b=IIxKpnUeyAjSmrvYBe+esenxjZCituxUusIx2HPt+fgcCCQ+GcNLvV9c75Q6pojG+z5fzLCUmoIkXq0xWrGkjOg0dSZCzWO6nqYBnU5a+7e9mFkyYY1Zz2BkLjDUPckEj9tzt2icH5Btf4lC9bmBbCq0zC8HPDP4WykDFQH/gb2ErBpjCJoj6IuPr+kjzXaguin5DPTTKKAoGUgfDe7fWvmDY7UDznzAhWnpY54tjxK+axxmRgWVYK3d4Of/RM7YIljLSJaC3kJ1B8IV52x8Agucc36qHMNn01nvxTRutCmYUmlsPyKdkQQ8Lvj1a0T39T6y5bGB7zyg+8ibRrIwvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=riOyWCGCfagiaL4/BqVrgpz2q9ai3y4RxtrWAsDd7N0=;
 b=DHr2k6huKvGx27dGkFJFKv88TYi9JxGp7InwbM/rcLipb1CW3oiMZ2ET38eevhoCoagDWr64xqUQvNsTdZmKhvpCWXDscohSOZlDRkIhleGCdzfAg6cThs0gvZTXs9cpM6lT1PWZIGe7D2w8E1ZpQsZCKnqzKhyjuwm9M7GPcTs=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB6103.namprd04.prod.outlook.com (2603:10b6:a03:e6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Tue, 18 May
 2021 04:27:32 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::6873:3d64:8f9f:faf0]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::6873:3d64:8f9f:faf0%7]) with mapi id 15.20.4129.031; Tue, 18 May 2021
 04:27:32 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Daniel Wagner <dwagner@suse.de>,
        Enzo Matsumiya <ematsumiya@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH AUTOSEL 5.4 2/2] nvmet: seset ns->file when open fails
Thread-Topic: [PATCH AUTOSEL 5.4 2/2] nvmet: seset ns->file when open fails
Thread-Index: AQHXS4QLY+4qNiq68Ua1UWDgR0mY1w==
Date:   Tue, 18 May 2021 04:27:32 +0000
Message-ID: <BYAPR04MB4965B34C6F9C5E833782C7C1862C9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210518011002.1485938-1-sashal@kernel.org>
 <20210518011002.1485938-2-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9026b4c-fccf-4be0-32e7-08d919b5413d
x-ms-traffictypediagnostic: BYAPR04MB6103:
x-microsoft-antispam-prvs: <BYAPR04MB61036049CAFD517872409647862C9@BYAPR04MB6103.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7WLFUMHevqVC9AtoGXUxJOvJLXWifZOg/juS14Gv7HS4mRMjgJyZQbGVclvEfzViW/FqcjjjL2gLB0pV4sC7o3oU3wnwLDABtAhHJyAFJD1nVPo302kE96AfzmeAJdUxCCv/iWaf7tpYq/H5lisHiGwmnC+5qvITH8UDn1k/x9t1lYpInTARvMfJlk8zkGEzp25dmrgpVcsDchfMusk5v73MX/D4kBWx4ceFMXxRTTw6bvGaFq4rSesMzBmWWSr00hkdRoTuAI2YP45mY+GWG5pxXyW1Vtnj5bAyOpxLH+mRFF4vAx+2nkdheEXU3GIpZ9scSJVCoGyksIHbmzszvogUN0m6nf+IxaaVvDiZfuRIbjdBr+8FcuVhB8tJhzDdh2MKDUp54w3w5Mq27Fw1i9oeouJ7d/BGLARiRWSHcPrYVmyGNQOYDQ5EfGieSKLpYEap4s2aCnVUQ4W5BuQVp7EfPYzfHb/cjQqEQed7ynHih1HiaG+0N8e9k9uc43gh1IBig5X5+ezZ1GsWoX7KP0VYUT6zaQ8hthP7G8V2QiA7FoKVP8B3kIAbzydBwpl1zqedt2JS0C7aH9z9uPosv7jxaYOVt5vblIRs1EDugJA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(366004)(39860400002)(376002)(54906003)(7696005)(64756008)(66556008)(66476007)(8936002)(66446008)(33656002)(6916009)(2906002)(478600001)(8676002)(186003)(5660300002)(53546011)(316002)(4326008)(26005)(6506007)(122000001)(38100700002)(55016002)(52536014)(9686003)(4744005)(66946007)(86362001)(71200400001)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?G20Zp4T+9ytJRpu+bKBhf4X5dju+4OeyJPHoSyomgiVBLj7GlNQmsFoGwS84?=
 =?us-ascii?Q?oSXbAzaVoyYon/O8+zGxs153Ecq19gIj2dtpCgAF/dJZ1QDut/yFeC+805CO?=
 =?us-ascii?Q?oS/FmuCJoSjXQXJ46E2hEJXFRfLEfpK3o1/mG7XVU3NhqtrO83XoT4rYpJ6Z?=
 =?us-ascii?Q?snmuG3Blqe2HEUKub+MDUwbbQMXaCuSdSZ0vysPlDm7YbRC4QPl3ANJ0CXzm?=
 =?us-ascii?Q?0F/xCjQ60oWU3HIFQnmi6X3OEiPgFBlyYpetTUQFkYCk+z51+hZimxIHgAR9?=
 =?us-ascii?Q?i6E/HWhr5WPm7BvwVXqFN7DcEh+73HAc7iK7WiI2kwLy1PodQiVotqdOES5+?=
 =?us-ascii?Q?ZEzQbS5cUuRsvCNIJaHo6lt4ywys8QRwK/OMZX2jGCQT16QIgP5GSWUALLDY?=
 =?us-ascii?Q?DHKvfIdrbZ/wTYpPPQtxQvupsuWwpE1EaPp/4FiUEbMBCUuVvgFKbKKWcjvP?=
 =?us-ascii?Q?oeOLvvcKbRCDUZCBlyMVgLUEUcfeIoN+Qoitsw62MXOfimXZ9fiH3vi7CRzw?=
 =?us-ascii?Q?5mkw2PdXfjm29ZsrJARG5IodVooqFl5uFkMeH7ikEd0SPX112ygspDOEfqBA?=
 =?us-ascii?Q?Ou5X/xyugB/Kie2Zd2W10BizSMdmTiAKfe6nUY2DI9Vp6oZKqG8uf8ywDH8f?=
 =?us-ascii?Q?aRgE+iNLT3CW5vKIuotvrJvvzSASdu0b5lO+t1Ukg9UscBCLqLVp0G9qTuW1?=
 =?us-ascii?Q?0jMBX2mgkbrW4wTgQdcL/ew8R0EkU5MIKNXugK3vO19u+UXZDX4GRqRls4HK?=
 =?us-ascii?Q?BfXXvyBXiQpBnHh3/wyYsE6g781e9fxQZduy2rmvyS6LAKHo2xU9u1I814cq?=
 =?us-ascii?Q?CrbxZjD0grXEE3zS0/iqkK8SJ8OxtPQEXsZJt2r/Dz654H2YUhplJ0py9KCH?=
 =?us-ascii?Q?MQDGtrsemPXgT4NMj/PJLIjoqkjvU4hAA9LXR8UWKlLES321+M0f7hzCUWxN?=
 =?us-ascii?Q?M+S5kFWUy8hrz/sfTNPfyQWYp4tbmBZ8iuuhHfQsVNvhomqMY7k9rqf9nqjz?=
 =?us-ascii?Q?alXJ0/dM2nWSSJnHA8IX4RCcB5O08X3NMN/fZITKKgReH/e5s/4XvMhzGS2B?=
 =?us-ascii?Q?unvPHAjF44W6viP8JFodAOJLi1DVZR8ERc/mQNtJKuLuSRyfadqpkQWqVWm5?=
 =?us-ascii?Q?hpRywF0sKg3Q+kXgHrvgnVMWeAcedD9EK54YLxbcQlVBDJ56hcV//YYJk1lj?=
 =?us-ascii?Q?/R75EcRsVJP1qwILpqeR/owlcxKrwbcEwLmcRwBTTQ+Vvf+buNJ8HLpomDsB?=
 =?us-ascii?Q?mMvyPGcq8cwsvYJL0qANh9zCq+nfxAH9AW9LmXCRM81nBMy3oLfjQSuirHDM?=
 =?us-ascii?Q?DmaFHuVO7aoAq5p0rwkCQ8X6?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9026b4c-fccf-4be0-32e7-08d919b5413d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2021 04:27:32.2351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q7dguruzbIGjas2T/ytm0kVMqU9QKxWcdmBd+kWPEVFeaVCiMJ34tXY3EzJ6exdxewDXlM5nfzNGnHgxmkARPnLWcnSPMkp2BwfQGavfegQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB6103
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha,=0A=
=0A=
On 5/17/21 18:20, Sasha Levin wrote:=0A=
> From: Daniel Wagner <dwagner@suse.de>=0A=
>=0A=
> [ Upstream commit 85428beac80dbcace5b146b218697c73e367dcf5 ]=0A=
>=0A=
> Reset the ns->file value to NULL also in the error case in=0A=
> nvmet_file_ns_enable().=0A=
>=0A=
> The ns->file variable points either to file object or contains the=0A=
> error code after the filp_open() call. This can lead to following=0A=
> problem:=0A=
>=0A=
> When the user first setups an invalid file backend and tries to enable=0A=
> the ns, it will fail. Then the user switches over to a bdev backend=0A=
> and enables successfully the ns. The first received I/O will crash the=0A=
> system because the IO backend is chosen based on the ns->file value:=0A=
=0A=
I think the patch subject line is being worked on since it needs to be=0A=
reset and not seset.=0A=
=0A=
Not sure how we can go about fixing that.=0A=
=0A=
=0A=
