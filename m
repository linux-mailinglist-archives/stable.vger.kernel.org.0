Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC8535D04D
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 20:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244869AbhDLS0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 14:26:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39178 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236888AbhDLS0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 14:26:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CIF93E001854;
        Mon, 12 Apr 2021 18:25:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ZVOqPWKddfmTSzMXFkg2ahxTcnsJCPhgLns9C3kWiL0=;
 b=FS1wDDH9Kv4rJPh/KIJ+mv3dGUzOwy+OFZT/4M6UfkFgsOh+Bo0JrC9LckJto/sa7/3i
 mLKNYADh5uMQbyyDjhypvnDOtjFgojmcOIg95SI/WYo3l1oH7fwmk+fcAORns0NAG2cX
 xkX5ddE3nfQ8XrdwunS3psxD/zDCKp+WEc7Wj2sghVX6leCgGqYqtHQjTCy/PM5NvL4u
 nzb9+I/8ZnxMFJNGg+KPBS6iSeoZ4K0DNfiQdEDc7AQCUcFtJs91dFSW833naHuPS1dy
 SDY9zii0obh3YYAatL8jY+pdJIgf8v82mTpg2+ygzkagUNvxEFu5VogJD4AJfhLdLI/R vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37u4nncnp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 18:25:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CIFctt003294;
        Mon, 12 Apr 2021 18:25:48 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2173.outbound.protection.outlook.com [104.47.73.173])
        by aserp3020.oracle.com with ESMTP id 37unwxq8da-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 18:25:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SojgY0xh5IKO/AtC8XUztQqfOxS5liNMa3AB/1vTZ6N9CzIomccjm1D1Xx4dbhqQDaJ4KBh9xeSuA9tKUwr0GEt5ps2lO1A1JQnlDpAOiZcdcFLYtAgohvXKxrNBA6JGeMctFMTKVBtiY+KgrHb8MYWurxT1MxfV9LJcKB75j48QCC7StIdRC2t+PJhmdexu3CATophg4Y3bL8V2oVfn7aQd6OYlDvMYidMUbdr7d+fd54WKAkx9n3OPQti3GQL5HO7RKShCMKBpjJXHsya3hQc63+57oAcGFcKdqjPPx5EdC1Sw09+2cvNbEi8CxlsU8JonnuCSYnYev6WHol5uww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZVOqPWKddfmTSzMXFkg2ahxTcnsJCPhgLns9C3kWiL0=;
 b=MC8r+G2d+6RndOsTme8G2LIF0X2tfyOg7d8b5oBmD3GeRZdQwQ7rRjWQjfNg0Yt7hJRhmfled5wgKgM0gM8MJnheYyrpgs5EDzXO3ulFIhze3Z6an4LEIIK1t9ZO5KxNDcEbEr7tY+ZL8dSos0lnyX1cZhdEoCmK4jjHspgxy4lHmzNbE/MGOTQq18lmIKrU5OjqcVj6m6yUPN/1pRH2LCaymLilGyQSPr1T+zXp0EaQ6d/5GGPD8a6nkZ7JdjCfkuKZbY5ANMqPOt3YyZPkTER1ioQuzdqHb9l4K1AvLwfXX9mxxNXUEi288vff/GW7cH1LFPYTTtCAkAsdaJ5dyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZVOqPWKddfmTSzMXFkg2ahxTcnsJCPhgLns9C3kWiL0=;
 b=UaxGmWbva+Bb3PvHQ0AIAJHNuk/Zj4V0oMeAreQVfm+9gsu8zh/RyHqdDZixGANabVPcYL9lsnKnHm17vw1s9xdJ4wkjzZusuJOVqVha3ZSDL92iW1rWhGSuYMk0FRW0N8ayMu9i/R4wBPChskM/61TAzZ9lXgrdbwwluyRDERw=
Received: from BN8PR10MB3571.namprd10.prod.outlook.com (2603:10b6:408:ad::23)
 by BN6PR10MB1857.namprd10.prod.outlook.com (2603:10b6:404:107::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Mon, 12 Apr
 2021 18:25:44 +0000
Received: from BN8PR10MB3571.namprd10.prod.outlook.com
 ([fe80::6919:5191:f3ad:ff9d]) by BN8PR10MB3571.namprd10.prod.outlook.com
 ([fe80::6919:5191:f3ad:ff9d%7]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 18:25:44 +0000
From:   Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Lu Baolu <baolu.lu@linux.intel.com>,
        Camille Lu <camille.lu@hpe.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 5.4 v2 1/1] iommu/vt-d: Fix agaw for a supported 48 bit
 guest address width
Thread-Topic: [PATCH 5.4 v2 1/1] iommu/vt-d: Fix agaw for a supported 48 bit
 guest address width
Thread-Index: AQHXK92E2Pb9yfR2lku6DbKUN6XPZ6qpw5SAgAX4kQCAAEa0AIABN+qA
Date:   Mon, 12 Apr 2021 18:25:44 +0000
Message-ID: <DEA60498-1BFD-441D-B641-BC843695ED96@oracle.com>
References: <20210407184030.21683-1-saeed.mirzamohammadi@oracle.com>
 <deca9431-a52a-2818-4493-5a6ffeadccb9@linux.intel.com>
 <E3377E7A-073F-4D9C-92FE-8CC4836343AF@oracle.com>
 <036429a7-9924-7ed5-6be9-2bd087594e9b@linux.intel.com>
In-Reply-To: <036429a7-9924-7ed5-6be9-2bd087594e9b@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
x-originating-ip: [136.52.113.136]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e39764e-88b4-4ce5-cf4a-08d8fde062df
x-ms-traffictypediagnostic: BN6PR10MB1857:
x-microsoft-antispam-prvs: <BN6PR10MB1857E7D7D5261C92BC675C94F1709@BN6PR10MB1857.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PkVjutjLN7pKWf3QSXHEDcVsdrzoR6NzGjvdhOwAUKZfjccQvNrLBARa9XqitirQ2M7e+sb4MZuoPcietw/TR8KMpnHpHF79SB2067CRsjDNsbeSquLwO09ost/6VPe9f2YyK8aknnYuANHuxsX7fPa6hRxIk2KpIPap3sQP27fWri68ZM5aKL/4YXhRq1XKF56vMVfTzsV1NJjMG4s9Aqs7Vk3u7+B8SWeUaL1CmfCwJ4SiGDIahIvcz84kDq2S1m8tBRo7GUJKoVnJLCi7EUYvPByf31KcwC0SkY4kJQQ7Q09/TBRyG8xNZ9IG1iv5fpMI9FIR7wf59fcdsr22FmhAEWgbavFUV/Hc38BOiyGkpiNE2uOSELMfOM0BhHzr7wOJuDqAbLlLjT1FNnrbSGmj0fBRwmVLF8J4pdewzEWPIjWVCZDHF3Ivs7HPRzFqXyxC6dgNBl3dU0hzNYlbZVzpAYiRFB2tJJ5RboXwqW+XQTISwpmo8qnZkykOzmdkiQabfuy01WIAU4OtE/eftup4z+MZrXvNe1ywV+iVW/HknSVdCb4YrupPytIaUZswZAPmJNKOXdEC+Wm0j3AbRu+nVUgL+iX1cu8F8qLs4n6D1K8WLVJtgdg7WZPOXBjp+P5f0SZxIi9a7E6SK+e21cUQdGvVH7tfS5HpMftZOHU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3571.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(136003)(376002)(39860400002)(316002)(36756003)(2906002)(33656002)(54906003)(53546011)(478600001)(6916009)(8936002)(38100700002)(83380400001)(26005)(44832011)(186003)(4326008)(66476007)(86362001)(2616005)(91956017)(71200400001)(8676002)(66946007)(76116006)(6486002)(6506007)(66556008)(66446008)(5660300002)(64756008)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?z4KSfBqFniyTljUZi9oBGqGGuaQ4MBOiS01ULmX9kzmcPCeY08yUdMleiPGD?=
 =?us-ascii?Q?Wi6sFQN2J13z3piVZlxkACMwoyLyWaBRbGgnjHtfsgj25QnFITtEFt/+2SQl?=
 =?us-ascii?Q?trshN9e9v8LRzWSWlQDOzIOANhar/MiRVBcbcxSxCsWtN+KPxKpKEsid/uji?=
 =?us-ascii?Q?vGr9nN+2f7LAaAvOVJALLgbHLkV0hggpbj221/TaIuSvjkK86PmNw6lFKtm5?=
 =?us-ascii?Q?2WIuy1xvOaKFtp8rJNU8a1pFBgs2E0HeXcA8HBRQoB7DE+O4nxbv/Zf0qrpe?=
 =?us-ascii?Q?RiN0hh36iQ8E/rRczwBlbzyYaPM9AIYqheeG0ms/d6X/vy0OV8VpAj3pb8aP?=
 =?us-ascii?Q?I+jXCQktiFaBIvEdrDMXsHOKZDOtVokCk/Inq7APoIugf2tVQ5TkZAH8yyKi?=
 =?us-ascii?Q?mcGXNC+2i+AKGxlPz+rQFjhzyccxO8FRayr59r5Com1xePXCrB3SV1/9nIdy?=
 =?us-ascii?Q?uzSr0IOrHFav4ioI5In7qvFuvTTWyhGSH4Q1LvDbCpIgb4njQtwo1C442/Dk?=
 =?us-ascii?Q?t00zWA1GQqlOMrZOHYlC7wvZFfGmyWexi28ZHWM2UJWG6Rvw37TfJHcZGtMq?=
 =?us-ascii?Q?hvd1pyOVZvzhehAru66/C/357djIX1y8Q6V6vW56bYJ2kCC67qmj4EchUFYl?=
 =?us-ascii?Q?cvFm8MOs8AymS4Fc2bxZQGxGc9g94H0A37z0+RWWZkQR3O7RmE+QDf/zgyqs?=
 =?us-ascii?Q?6OjTjdZMwqoJkNwcY8tuUMq77enufjEHQ9iWuhp56SWZDE6hyf1Q01+rJ3R4?=
 =?us-ascii?Q?KdQcPDCHc5M63LinRIxGFeBzmLlDiDSBXTMZQ5J/6c39fOFeBNWaVZoIhyPb?=
 =?us-ascii?Q?DUIIBETY4vYHaLv+MKPfP/srMRALYdmAuzXXoXsArvvsMIDL0Lyt9oDQJKAe?=
 =?us-ascii?Q?yZbNXhPxfIIGE2mS5KCH8t/k34h4Gfhfsnxax599pWyS0+Vq3FIYq/a4I3hI?=
 =?us-ascii?Q?Y0QrYGms8vpuHuoYpmbBjKSxf6aOaTmvl/uRid/8rnt39hMGNE6SMDjTUgUY?=
 =?us-ascii?Q?FwRf69SYPxeX83XBLBn80XC4qb9bCnmQ/PzF60gsn9y+5gG+pbebSSqlCQX2?=
 =?us-ascii?Q?TcQCR3+vCCpxFGf3qR8ReocC6R4gOx45v0N/C05z/TDzMhYcSHminsBsXpE5?=
 =?us-ascii?Q?hkQ29hTfJ1xXY3Q7/Mu45HCYz465y7A65ZSXq3sLaoOVbuTkefbNrct8Ahfb?=
 =?us-ascii?Q?a9ANrfLYq4icf3Vjg5XPvbUGdBbPrBN2F0dQG4TWjeHNxhNDnmrFMXqKB1iV?=
 =?us-ascii?Q?4hMzhC/b4XaL8elmChg76pJkEZpTYO7dJkWyiBSPA3pmUFTXOW+SCaB4v7//?=
 =?us-ascii?Q?qltMJaT0rMFyGHuapn1Zv9EIicxuIxWQw5JSR44tzXYf8g=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <60D8DE9EF6901F468FA534DF22B3FFB9@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3571.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e39764e-88b4-4ce5-cf4a-08d8fde062df
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 18:25:44.4942
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +B8fTMTr6690t4xHHPslRIXYo9BiIXHY5RYVqrXJRActhtyekV4SBZEQt8a73E9Ird5HX8KTsNFLpFa3jjVCKIaERZ9voioY5kqZZZEoZao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1857
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120117
X-Proofpoint-ORIG-GUID: HIbDX2gBRbVJd0s-sWIGF1k6gTmloOxm
X-Proofpoint-GUID: HIbDX2gBRbVJd0s-sWIGF1k6gTmloOxm
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1011 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120117
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

This patch fixes an issue with the IOMMU driver and it only applies to 5.4,=
 4.19, and 4.14 stable kernels. May I know when this patch would be availab=
le in the stable kernels?

Subject: iommu/vt-d: Fix agaw for a supported 48 bit guest address width

Thanks,
Saeed


> On Apr 11, 2021, at 4:49 PM, Lu Baolu <baolu.lu@linux.intel.com> wrote:
>=20
> I guess you need to ask Greg KH <gregkh@linuxfoundation.org> with this
> Cc-ing to stable@vger.kernel.org.
>=20
> Best regards,
> baolu
>=20
> On 2021/4/12 3:36, Saeed Mirzamohammadi wrote:
>> Hi Lu,
>> Thanks for the review. May I know when do we expect this to be applied t=
o 5.4?
>> Thanks,
>> Saeed
>>> On Apr 7, 2021, at 5:25 PM, Lu Baolu <baolu.lu@linux.intel.com <mailto:=
baolu.lu@linux.intel.com>> wrote:
>>>=20
>>> On 4/8/21 2:40 AM, Saeed Mirzamohammadi wrote:
>>>> The IOMMU driver calculates the guest addressability for a DMA request
>>>> based on the value of the mgaw reported from the IOMMU. However, this
>>>> is a fused value and as mentioned in the spec, the guest width
>>>> should be calculated based on the minimum of supported adjusted guest
>>>> address width (SAGAW) and MGAW.
>>>> This is from specification:
>>>> "Guest addressability for a given DMA request is limited to the
>>>> minimum of the value reported through this field and the adjusted
>>>> guest address width of the corresponding page-table structure.
>>>> (Adjusted guest address widths supported by hardware are reported
>>>> through the SAGAW field)."
>>>> This causes domain initialization to fail and following
>>>> errors appear for EHCI PCI driver:
>>>> [    2.486393] ehci-pci 0000:01:00.4: EHCI Host Controller
>>>> [    2.486624] ehci-pci 0000:01:00.4: new USB bus registered, assigned=
 bus
>>>> number 1
>>>> [    2.489127] ehci-pci 0000:01:00.4: DMAR: Allocating domain failed
>>>> [    2.489350] ehci-pci 0000:01:00.4: DMAR: 32bit DMA uses non-identit=
y
>>>> mapping
>>>> [    2.489359] ehci-pci 0000:01:00.4: can't setup: -12
>>>> [    2.489531] ehci-pci 0000:01:00.4: USB bus 1 deregistered
>>>> [    2.490023] ehci-pci 0000:01:00.4: init 0000:01:00.4 fail, -12
>>>> [    2.490358] ehci-pci: probe of 0000:01:00.4 failed with error -12
>>>> This issue happens when the value of the sagaw corresponds to a
>>>> 48-bit agaw. This fix updates the calculation of the agaw based on
>>>> the minimum of IOMMU's sagaw value and MGAW.
>>>> Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com <=
mailto:saeed.mirzamohammadi@oracle.com>>
>>>> Tested-by: Camille Lu <camille.lu@hpe.com <mailto:camille.lu@hpe.com>>
>>>> ---
>>>> Change in v2:
>>>> - Added cap_width to calculate AGAW based on the minimum value of MGAW=
 and AGAW.
>>>> ---
>>>>  drivers/iommu/intel-iommu.c | 7 ++++---
>>>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>>> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
>>>> index 953d86ca6d2b..a2a03df97704 100644
>>>> --- a/drivers/iommu/intel-iommu.c
>>>> +++ b/drivers/iommu/intel-iommu.c
>>>> @@ -1853,7 +1853,7 @@ static inline int guestwidth_to_adjustwidth(int =
gaw)
>>>>  static int domain_init(struct dmar_domain *domain, struct intel_iommu=
 *iommu,
>>>>       int guest_width)
>>>>  {
>>>> -int adjust_width, agaw;
>>>> +int adjust_width, agaw, cap_width;
>>>> unsigned long sagaw;
>>>> int err;
>>>>  @@ -1867,8 +1867,9 @@ static int domain_init(struct dmar_domain *doma=
in, struct intel_iommu *iommu,
>>>> domain_reserve_special_ranges(domain);
>>>> /* calculate AGAW */
>>>> -if (guest_width > cap_mgaw(iommu->cap))
>>>> -guest_width =3D cap_mgaw(iommu->cap);
>>>> +cap_width =3D min_t(int, cap_mgaw(iommu->cap), agaw_to_width(iommu->a=
gaw));
>>>> +if (guest_width > cap_width)
>>>> +guest_width =3D cap_width;
>>>> domain->gaw =3D guest_width;
>>>> adjust_width =3D guestwidth_to_adjustwidth(guest_width);
>>>> agaw =3D width_to_agaw(adjust_width);
>>>=20
>>> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com <mailto:baolu.lu@linux.=
intel.com>>
>>>=20
>>> Best regards,
>>> baolu

