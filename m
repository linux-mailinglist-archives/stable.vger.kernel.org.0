Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D4C420525
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 06:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhJDECA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 00:02:00 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:5758 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229463AbhJDEB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 00:01:59 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 193C8DRl018979;
        Sun, 3 Oct 2021 21:00:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=Seae6gWNRjodsb3qXJPJvx+nu+VbX136S4m8BeHyvXU=;
 b=RzjI4CAl8X1b8/Xe8roa2UPXPV+dqyYBOGmrPPn21+hDy/o/vTE3SjeIVpgVA8v+tWI2
 LDgfFpvB8SBwaC365zveJ80ykq7sJjZKWLZmMcwLCzNqMH2p6KL3mEaqbQdelafYNsFJ
 UTZHlsh7Fr7/LwbLVJoOGPX6B/Bv5IkXUTgq7YK1HEmhIpy7DaFiOqRE6dfHYVNEk9Wc
 AHTWDy6rTwqVladp+PyV1u3SBkb0aY20rHw4uOhT5mMsc9y6rDBhOABJ4YCl5VSNQvH5
 jXwhQMUjLeCMqISPKLnpAzXJOOPS93LEGpiDUbDaaeQRnR0Q2UkLugh90Bvp0RDdywCm zQ== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by mx0a-0014ca01.pphosted.com with ESMTP id 3bfc8p1afe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 Oct 2021 21:00:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hy9nltGXDbDq4ZLKXMCnm+oUvodbD64V5DVgiGIR4+P5Dddk0QPJzArkvcnokqAk2+U8DUlh33WZtXYzVKt9Sf7v/sIWntIUYPl511KgHgtyVszqU8icpb0Tg8zZGbbgV5qzUvvgCWeMutnPU4vJu6utDZ56SQUUKaLLvj4ZiJvYGa45aL6NzpWOZtHdN+fk8bxfeIyQXJYGDYGXXcoTOBUQz77pE/dbmQiQZwwtETzjFaXHHU6yP2cAf6APEiGdbK+At9lr+xeb60nqeilKE00JTtECbiLZWGc7akJfxNOojBGsEo0e3p3M9jx2dozk+WwJoPBWLzOlVWEwdmNW0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Seae6gWNRjodsb3qXJPJvx+nu+VbX136S4m8BeHyvXU=;
 b=MxDA0/YlIsR83W+d0ZZDMyNREgG9PMq0Eh8vBYSGrrb3mu8v04EFpoc4LRy8PRg7XCi0gqECuApDoGV4kJlrklQvOG7CjLiU2/TPGfLYRoWFgNY9Vhp8qVg+SQYBtOZMV3yDBse7b4o7u8NmVJWssUBu/sev00pmjejOe0lwOg5uZmdM1Zy2m1g+mi+0ZVg20WGOdoSpkd/dam/DMUAcAsnnz7t8cyk6sLq4fvJ53mwnjP/U2MtkAGfoSpF0sTKeMrq4mM8Kkzmyb4Qo1eUX9dznef5lDUYttIc8JHPdEm0PSzGTOY44hap1ZNECM9EuUOWKUXV7B9Y1r1yej3qVfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Seae6gWNRjodsb3qXJPJvx+nu+VbX136S4m8BeHyvXU=;
 b=hnR5y1woQG5PduDC+EkjqDMmeTM7L31HSdOntdeUG1DYdp/lINUyAFZiL0TXqVpRp5LutMq1XaqY8dSo5vBMmMYU6ROG+B5Ux1NX3LInewjvgilHLNkX5P4UF1sBOdFkcIEoIR94pe08qnmfpIVZmEXxnLo5vDryH53ViPq9zog=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by BY5PR07MB6452.namprd07.prod.outlook.com (2603:10b6:a03:1a5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17; Mon, 4 Oct
 2021 04:00:01 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::5cb9:678b:b9fc:79ec]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::5cb9:678b:b9fc:79ec%3]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 04:00:01 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     Greg KH <greg@kroah.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] usb: cdns3: fix race condition before setting doorbell
Thread-Topic: [PATCH] usb: cdns3: fix race condition before setting doorbell
Thread-Index: AQHXtd/PBxsxSNe50UaQkp/YX7ihCau8WQ0AgAAEVVCAAgAtgIAD3Qww
Date:   Mon, 4 Oct 2021 04:00:01 +0000
Message-ID: <BYAPR07MB5381E8281A6747C679EDF053DDAE9@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <20210930094217.23316-1-pawell@gli-login.cadence.com>
 <YVWLamYUlXMmjdqq@kroah.com>
 <BYAPR07MB5381A0DD3A5CBB66D5178372DDAA9@BYAPR07MB5381.namprd07.prod.outlook.com>
 <YVc8sZqAR1EOjrlE@sashalap>
In-Reply-To: <YVc8sZqAR1EOjrlE@sashalap>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctOGEzMGQ4YjQtMjRjNy0xMWVjLTg3YTMtYTQ0Y2M4MWIwYzU1XGFtZS10ZXN0XDhhMzBkOGI1LTI0YzctMTFlYy04N2EzLWE0NGNjODFiMGM1NWJvZHkudHh0IiBzej0iMTc1NCIgdD0iMTMyNzc3OTM1OTg3NzYyODU1IiBoPSJncWlheUNDOW5OZ3I1WE5UYVhmOHNpdEl6em89IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=cadence.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 323dbafa-a34a-4653-3135-08d986eb7071
x-ms-traffictypediagnostic: BY5PR07MB6452:
x-microsoft-antispam-prvs: <BY5PR07MB6452743BBD5F86D7A4409F53DDAE9@BY5PR07MB6452.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1201;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yE2HQ+6iC0N1Jn8TLofmU0V0aURMPoiIu/McNfxfcgvm5kpeYQiNTEDCkKRcEj83uhkqhryH8OIw9Kbbo3L5s6ZiJgWaPUGDIkef/wiRdM9o+nsu5vCbsXaqKQ7K/OdvvDI3jc+M4IhTAKyR/6YveDxA5zh5sFv7ekPLFcucGTSVsyRe2YjtDKCxs0qXUAfNw5gEwGn8eC3aNsxrtD6XV76H0oVkhfBx495OXLI78XL5sNtN9KYz4A5yFQE143w3G5Xh681GteHQYdk6YtCpL2djCT+FkWL8qklJ03aCVpz2lyZ6BxaKDal+uS1HWQ2wUS+WLxvClGRQ12TN8Blxwng5IAljGFQPjWc+G34zSsY0VBkNnFmndAYLuRqC8Py/FoHik5VNWKZwUjichSA+mWKy5wp5xCdX5Mm/4zxtg1h4H2wsV88oyCxUXEqwRbMYxiVraDxbxj+eP+QnZvcQBDgOhvQ+uCZCyyLoDJHaZwaPLHMuCUfeC+iHif0ZB6u4QeNHMph8at7cxj6/NmfWNk+I/ELuJMvkG67ULt03Nh3atlYuWuxe2QO8IB8QtmFcr7ifHYwxv7fhLrZIfTNavjzf6Fq78YfZOxHNsJ4C1vu8/2BVze165pWger0WSAjV2ZSMZKY3UkcaD+Rh4QzGmXsM6J02mjPlQOvyJD4QNFd+mSeWEvFOKGd1+hmhvevOfDgznHljsHhp1zgph5wwcK5sjeO52OzveD9BVR9dkpA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36092001)(122000001)(66446008)(508600001)(66476007)(64756008)(186003)(76116006)(7696005)(6506007)(316002)(5660300002)(54906003)(33656002)(71200400001)(66556008)(66946007)(8936002)(52536014)(26005)(8676002)(38100700002)(4326008)(6916009)(9686003)(55016002)(2906002)(38070700005)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lCNNmjUzhC0yM91CyNIlvT28bC4eRgLaXEHf3r5AIS5uMdvc/E0F/b2AifEq?=
 =?us-ascii?Q?Av7ZDhlsarHcmFXz0w2UOsw8Xg0lDKQW2GYtlybsD7e85/F6MLgYsLOB+z9q?=
 =?us-ascii?Q?yfZDCvmbPA9I6dbYKg9hP6romMIwjxQRarlSbs3X344oI+tfKsqA8YWu3x2f?=
 =?us-ascii?Q?B0b/Zg7qNh9BQ1Vp/jkxDMJLK6m8tqrf2HT6x1PHqkID2IIx1NCHhnXdG9J0?=
 =?us-ascii?Q?K/byjKhCyzEnrU90+Ro4G9rDxRb+tT30LoxIYCGd/QyWqt6vCSM8/kl3igzV?=
 =?us-ascii?Q?R98cp+0A8LY45vi157r5ita+wK4Pc/2dejo4LVe9mFPHbHUcksumzhHLY2Yt?=
 =?us-ascii?Q?5VCB7SRV6ZY4/DhQ/7MoTxx4HJlFl9t5dAR2V0tbNt9wyTdvsjCuslIIoccy?=
 =?us-ascii?Q?hRVqjoT2es1Zso1W1NTx/hYvvDm5bV+MUdCoPxiQFVypqKgWjacZHBRUQlxr?=
 =?us-ascii?Q?mRywyyg4Ts/sr+SSdQbFSQEiA4/ZY2lQz4lkgTMffwlymyYPyTrdDA0G5Z3C?=
 =?us-ascii?Q?lF1yE3qPaErEmp2GENveChllLJD9TND9JUkxwUUPDBwq7AM/imj2gudKuCCH?=
 =?us-ascii?Q?EmZpouFWYEgfCH/pAxhiIEBghXcPmiyFHu6zLw4v8XjqFC6KU9G/Wf/KJ4u+?=
 =?us-ascii?Q?xBHydR9VBA7wzHhxPrF9tiVLJbeUAEEZPmohBj0MStgHhz7kqZwYhnNjfZWh?=
 =?us-ascii?Q?8KOufsmbEwvEqfNIfGVu86Namzw8Ii/SnVtYnOhc88BX9Zk0rWhJn2mNrGSS?=
 =?us-ascii?Q?vRLaznyI1ijPho+EVqN7AujVIM3CcBDaaDgsZTWspA+6gB/Q7Awyuv5Lqd3G?=
 =?us-ascii?Q?xJnCisLgyw7rsR8LsJMVdjnc66GQBv9/qAkTucTSxZGxPVNL3NInHSI1J/PG?=
 =?us-ascii?Q?nO0TSdS+dukxLYqKFZO26jV8ApoI8YTbr4pB2PMpXCAv7B6lwI9cBt5NhPYs?=
 =?us-ascii?Q?B16o/RFLp7OGzt5sM7yeIzK5twAsdPnkitfbW4bEmPA6xnf7YuwDRu33QxfY?=
 =?us-ascii?Q?DcRgApMPVhV9qbhqahfjKftRChfAviVui9KIMRJ1LsPRfN+nEX+0Ua0n+R4P?=
 =?us-ascii?Q?Btk6j/Gw1t2ik6sp1GvIJwMJ/bG2J/Ct7MggI9wrn+v6VOUjAmnFIVz8S6uS?=
 =?us-ascii?Q?zzBz+H+jNgf0MQpSwiGADU75sxaCxFHJaRh7PK2pvkxOSRtibox5+o7454z+?=
 =?us-ascii?Q?lJ0o7CJz6FosjDDBIso549NVKB5giaC1Tg5QqTsG8Idw6r8LMWagNBormMvW?=
 =?us-ascii?Q?vUYOuF4f1HObaSLa6ia0xMbvi4Hb9CUl68fNUtleI2n1NwvDDa7Xc0Yk4dCn?=
 =?us-ascii?Q?1nmClnOjFPwn70YudW4YV5r1?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 323dbafa-a34a-4653-3135-08d986eb7071
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2021 04:00:01.0649
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mb/1wx9m2b09EafAY7G8hKUphhS2yxKZCVasg2I1+gAIdjVgU3hQlPZqOYihA+s12p8OJL4CFZHU+XeH2LAu/lo991z0910cFoKxv6oD2k8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR07MB6452
X-Proofpoint-GUID: g5XZxpcmfdC5NYCdU78XUysNRzMRnRQP
X-Proofpoint-ORIG-GUID: g5XZxpcmfdC5NYCdU78XUysNRzMRnRQP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-04_01,2021-10-01_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 adultscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 phishscore=0 mlxscore=0
 clxscore=1011 mlxlogscore=876 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110040028
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>
>
>On Thu, Sep 30, 2021 at 10:22:42AM +0000, Pawel Laszczak wrote:
>>>
>>>On Thu, Sep 30, 2021 at 11:42:17AM +0200, Pawel Laszczak wrote:
>>>> From: Pawel Laszczak <pawell@cadence.com>
>>>>
>>>> commit b69ec50b3e55c4b2a85c8bc46763eaf33060584 upstream
>>>>
>>>> For DEV_VER_V3 version there exist race condition between clearing
>>>> ep_sts.EP_STS_TRBERR and setting ep_cmd.EP_CMD_DRDY bit.
>>>> Setting EP_CMD_DRDY will be ignored by controller when
>>>> EP_STS_TRBERR is set. So, between these two instructions we have
>>>> a small time gap in which the EP_STS_TRBERR can be set. In such case
>>>> the transfer will not start after setting doorbell.
>>>>
>>>> Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
>>>> cc: <stable@vger.kernel.org> # 5.4.x
>>>> Tested-by: Aswath Govindraju <a-govindraju@ti.com>
>>>> Reviewed-by: Aswath Govindraju <a-govindraju@ti.com>
>>>> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
>>>> ---
>>>>  drivers/usb/cdns3/gadget.c | 14 ++++++++++++++
>>>>  1 file changed, 14 insertions(+)
>>>
>>>What kernel(s) are you wanting this applied to?
>>
>>To 5.4. I added information in cc: <stable@vger.kernel.org>  tag (# 5.4.x=
) .
>>Is it sufficient or not?  I ask because I need to post this fix also to v=
5.10.
>
>I queued this up for both 5.10 and 5.4, thanks.
>
>The issue seems to be that in the upstream patch you explicitly stated
>to go only to 5.12:
>
>	cc: <stable@vger.kernel.org> # 5.12.x
>
>Was that your intent?

Yes.=20
Patch could not be applied to older kernel version because files name were =
changed.

Thanks=20
Pawel Laszczak

>
>--
>Thanks,
>Sasha
