Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A61F41D792
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 12:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349811AbhI3KYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 06:24:31 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:8642 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349764AbhI3KYa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 06:24:30 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18UAJF7Z015493;
        Thu, 30 Sep 2021 03:22:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=riSeCox4rYRMUpmqtf99xFTl9yyLFvIEkJ8Y1mFR6kc=;
 b=uIE09CcZybWlolah4eK0FDS9ToEzeCosyvrD1BLjZh/f8FN/G817YMDuRl+cgwyP8LsG
 JTIUJqwrk4L4JmDCcnslg2X4ljOgwa+vS9Sy9VGYnZkisf7J3Ds9d9N/i6gxw6+6JF22
 IvkFUqTPwGhLCp2/fGaf50chxQekiiEuoIUFfK8QBSxyl9uKktSYwOipEg/UwElKh1qs
 2hH/GxYT3cHTAq6M+giJfC8YMvxqaDhLnMu8CFnULTvvNqSF2YCqWSKGMmCrjN21dQ0Z
 dTPSU+Qs0kiLfx+A/AeNmxmcKupAxKqqWZI0Ho8wWu2vtEYy8QHoI3RLsDADeH+BqAoW IQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by mx0a-0014ca01.pphosted.com with ESMTP id 3bct60ukum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Sep 2021 03:22:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C7lmkTuWh8z3JHISf1JmiGMnXpi4vajd795rkx6eaj2nE/+5djcdnJXqfKu15zMZWbJgdN1gjgA55go7up7PugRBT3r602Id6VHlC6lp8Jw6FXEkuotR3/aNW4ChjT+nRmYL19WOBWNTjEXu2YTZuEClqHp+l1DVE6M07UrhShbiC9nybRCgJPKkntBogLyOZ5qZR46tBY0r2kmS+o4I21cW+qMrbQRjZjA+NhK3DechIK0BnL83NpU8qv+JmASxhJYTEruFMNKyxQPIwRzQH04Wzvgku3ZB7wO3ZY64DLGI+Xn+p9qVUdHHVBkvY2FQJUpHtlZMUfbbXyFNzn0Xug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=riSeCox4rYRMUpmqtf99xFTl9yyLFvIEkJ8Y1mFR6kc=;
 b=dh2pY/ZYJbccS86Fm42Nm6DtryzPMfJnmQcMyUdUaeQ60/6wpkUbh6XnL609mOJ/61a960cIrzyNHZA0dY+uFlKtZBmqhouGNYU7YnMOaP7be3m6o+fp+VeArEr/5AEWxX+1HPxY1smFBZ2jwfK+ntvpbH6dJJPlgA3oSHxU85Z2y167keq0w5Xm1Z3TxR32hhxZWZJ/zQUdgvjQ53SI/Fvc3p1E1/hOZfslUdHCTy1AyUMuAR3qCCzyCH2DreL3jWLekQpUnelxxRb3emo/ukufdBx7Pl1MgDobahL252BCu8TF4MnwdCaBvVdGZfnjFag42dsnCWh3BN43+Oyxgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=riSeCox4rYRMUpmqtf99xFTl9yyLFvIEkJ8Y1mFR6kc=;
 b=PNF/dVE2jyfVo+zs35igEUGi+bJ7LJYnjhB0hv1PHsTHOSVZ2cL1DZkWq5TLtweWtH24p3/jiG6z1Qnw/vAx5+mAITkpcraKaWVO0qlN2a0cnIWvpYwhFcWJv4MHjKTgUvOOV3DOW5dLRAPZ33+J002UFRwXYerqaMZqIz6xcvA=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by BY5PR07MB7128.namprd07.prod.outlook.com (2603:10b6:a03:1e2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.20; Thu, 30 Sep
 2021 10:22:43 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::5cb9:678b:b9fc:79ec]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::5cb9:678b:b9fc:79ec%3]) with mapi id 15.20.4566.014; Thu, 30 Sep 2021
 10:22:42 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Greg KH <greg@kroah.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] usb: cdns3: fix race condition before setting doorbell
Thread-Topic: [PATCH] usb: cdns3: fix race condition before setting doorbell
Thread-Index: AQHXtd/PBxsxSNe50UaQkp/YX7ihCau8WQ0AgAAEVVA=
Date:   Thu, 30 Sep 2021 10:22:42 +0000
Message-ID: <BYAPR07MB5381A0DD3A5CBB66D5178372DDAA9@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <20210930094217.23316-1-pawell@gli-login.cadence.com>
 <YVWLamYUlXMmjdqq@kroah.com>
In-Reply-To: <YVWLamYUlXMmjdqq@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctNTYxNGU0Y2QtMjFkOC0xMWVjLTg3YTMtYTQ0Y2M4MWIwYzU1XGFtZS10ZXN0XDU2MTRlNGNmLTIxZDgtMTFlYy04N2EzLWE0NGNjODFiMGM1NWJvZHkudHh0IiBzej0iMTMwNyIgdD0iMTMyNzc0NzA5NTkyNjMxNDQ1IiBoPSJDZWF5eXhPMWhPcFE5LzhjNnBHbWhmWlA0aDA9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: kroah.com; dkim=none (message not signed)
 header.d=none;kroah.com; dmarc=none action=none header.from=cadence.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9ad9840-4439-4601-da91-08d983fc3cf4
x-ms-traffictypediagnostic: BY5PR07MB7128:
x-microsoft-antispam-prvs: <BY5PR07MB712857355F57493193807B78DDAA9@BY5PR07MB7128.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:962;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LJx55VxH1AnOcYTfPyn6IEUdaDossaPPYbB5Ab7bITSXJFOEs/VZtVXPNeVYvHyoLvZtJbWaSA4bGjK30sE21zwtoRl1NIbyh6RkJV2lX20vNIPUq88yTQEfDDimvdxnONJuNKUGPlCTcA+8h8kBNr21SfwzN+VgUnIY96VYtjBn88ZKj9JCETULvAze7/lhmblZ0ficNg/VvFWiSAcIAskbRlKSY+YN6qqrbrD+HqUtZrUr5N/9Z6lXtbT8aYPnZaTrydegDdeXOtqKxJ2bWodue89483akmDyGNte6CANORuqTDw23XyTlhD8aS6l+irakNIr6MDSQ85hZhFwQgk898WPkSdk24S6I74epORrcjYJk+orYvJ+nutrXYeQOyDTQQS2IhiqNB90lrVQecFvRJowlukvMi+SnfIMK8P4OnK1EY8fEQqrjj5IuSQCw5bhSFS1A5AyEank4k4Nqyy61F7nPbQ01oEy0U0eDQ9DYrN+xziu7gffDj9ZuyT+89czxU2G6aBhrWAakTlS9OZwFB0gNo8q0IEGz3LDYa15Naa7x2AlImpfR1U9k4+hQrh+5ddyo62wrcMH7r7qFJpz4eGzOVkE2HL9IMB1m/GPzBhoFRr1LBloyy8m3N02+f9NsAmdqJb+2B8xSs8se+q6hXW7kPegwOhkme5U+TpSW3WVxFVXtxm8FZGstbjnkiYPoXtIJdtakwalBFpaY+tM7cd2ZfNnguRABTdD+IiqWdxXh8aHDhG9+SCepiOz+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36092001)(8936002)(86362001)(6916009)(4326008)(316002)(8676002)(66446008)(55016002)(26005)(38070700005)(71200400001)(2906002)(508600001)(76116006)(7696005)(52536014)(33656002)(186003)(5660300002)(38100700002)(6506007)(122000001)(66946007)(64756008)(9686003)(66476007)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?66dLejShSZuf0FeVf2RTCqLpClIhklRywm8bJaO6/s2V21lVNXBy9uWMvYOV?=
 =?us-ascii?Q?3u+zCeQHdlzmjH4M7l97IHpu5t/fSvyOeTZabOpP0UHYPRcB2rbmsDqeJk2+?=
 =?us-ascii?Q?VDd7IsXpkSQwnyI/w9ZOj2BiGGbnxm/399aSbb4TYJMpZGn0zc9RvpkGeNtf?=
 =?us-ascii?Q?ltMCtwcE8kg7eFbOPTgO/oWIbdFFZzio8jT+Avr6yNUYq2CE2UXbLtI/iYfB?=
 =?us-ascii?Q?cKfP0d+phbcENZQrph2KYrAkwNzfrekBIc4JpNflPecfKzmHhPEtRr64rgvL?=
 =?us-ascii?Q?9yEr5/ccrScPfy5eJZY18jyj+YTvwWiuF4p1YoNw3igyOtYYD5aaA7V2FwAg?=
 =?us-ascii?Q?s2afB89rdL0hHkJSpfIkzb4sVeUvYgdEzcrNCDXucWaSlwJEnOqWtdb47w7A?=
 =?us-ascii?Q?rHFG4q0ury+XG/cKbsWuDXGJ2LZarD5kh1IXv00NTrYUCLBWgQwgqNxof+6Q?=
 =?us-ascii?Q?03fREAM1Ais/TjKxWNmK/4b+bV+G5WyhpVH/J0Gb5Qlx8Sywl4W/P3PJJHru?=
 =?us-ascii?Q?fkQ9DiycIYa+LV8wYlelldUsucJJ0Uvj+BAfAWOGrv5yUV1DkhEiWANN+pKv?=
 =?us-ascii?Q?Ae/vmGXIvfn5gdnYpzFtUhKFsNIVmefMhy+SzGGmUvg7opTF1IHr5LKXmVai?=
 =?us-ascii?Q?3K5UTCil5z9+xDawyx1LNXUZqoE70rJxuv4yva2gm41j9ek4kxDTzgdLuF0q?=
 =?us-ascii?Q?RbDb+/oPxrCTQbz4NsMPcM8d83hebAIsvIoFI2W7wNbENJEak3WFDfpw5dM5?=
 =?us-ascii?Q?FLUM6iKoLtQFvBlwpS45CbMGI/CJjl5DxkxmHE9lyTSDVKSNnTw803pGderT?=
 =?us-ascii?Q?2NKO+e21DJs8X+fGD8JsrQfmEI9dJXudl1gLjGui03cDC/2+zQQTxW8Rz7s4?=
 =?us-ascii?Q?5vdgP/ElcwTgPTD1tE7DsNnVAFGMT6oeLdGT4YVJeFiaOxddiO6xkRUeADmH?=
 =?us-ascii?Q?nJKrRXsDRMZoro5VbW0eM5EgDIAbejD6v59MtgQPzd0+7Ny448rlN2JU08Ru?=
 =?us-ascii?Q?CzWIzkxJhQzsjgp5jhUzCc9qG8026YbmArMw00mA/ykqnjO395fY8H/mNVWX?=
 =?us-ascii?Q?QgxOp71co+kz8we2fsOsK/uGiK2E3nmmMnTdHtQCLa5xxAM+DZkWhrg7Whab?=
 =?us-ascii?Q?2FJfLKxOFCDljcBgKmYQyFwmJ1oMTFGz5s1YfKZsoT+BRffngwYhkIXJFXWe?=
 =?us-ascii?Q?DxDTe/GrHcKNrnMcKQ7k64XbbtQ2suthPxXXUC+zqgo6maDlsKdMBbbuHBin?=
 =?us-ascii?Q?7QEqzgP1Ur73JBj6QQt9VkJ/L4bG1GqaV7EedL4lhkVwmgBgAMtYOrrcDpRC?=
 =?us-ascii?Q?K0ZRbOS0BAzUacdbMmA0Gj9S?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9ad9840-4439-4601-da91-08d983fc3cf4
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2021 10:22:42.6193
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tHUYMp0hX6qAe1gnlLL7PpxMT2vrCqgBA5Gvwit1NVdTe+L36B4ENW0SQVD9t04l1OAQQcwX4qn18cL/iJ3nIeKnajc76fVTYdepchNdnyA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR07MB7128
X-Proofpoint-GUID: N20bgJbcsGwfo1cDf3-Lvep7vL8FfhaS
X-Proofpoint-ORIG-GUID: N20bgJbcsGwfo1cDf3-Lvep7vL8FfhaS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-30_03,2021-09-29_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 phishscore=0
 suspectscore=0 spamscore=0 mlxlogscore=949 lowpriorityscore=0 bulkscore=0
 mlxscore=0 priorityscore=1501 impostorscore=0 clxscore=1011 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109300064
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>
>On Thu, Sep 30, 2021 at 11:42:17AM +0200, Pawel Laszczak wrote:
>> From: Pawel Laszczak <pawell@cadence.com>
>>
>> commit b69ec50b3e55c4b2a85c8bc46763eaf33060584 upstream
>>
>> For DEV_VER_V3 version there exist race condition between clearing
>> ep_sts.EP_STS_TRBERR and setting ep_cmd.EP_CMD_DRDY bit.
>> Setting EP_CMD_DRDY will be ignored by controller when
>> EP_STS_TRBERR is set. So, between these two instructions we have
>> a small time gap in which the EP_STS_TRBERR can be set. In such case
>> the transfer will not start after setting doorbell.
>>
>> Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
>> cc: <stable@vger.kernel.org> # 5.4.x
>> Tested-by: Aswath Govindraju <a-govindraju@ti.com>
>> Reviewed-by: Aswath Govindraju <a-govindraju@ti.com>
>> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
>> ---
>>  drivers/usb/cdns3/gadget.c | 14 ++++++++++++++
>>  1 file changed, 14 insertions(+)
>
>What kernel(s) are you wanting this applied to?

To 5.4. I added information in cc: <stable@vger.kernel.org>  tag (# 5.4.x) =
.=20
Is it sufficient or not?  I ask because I need to post this fix also to v5.=
10.

Thanks,
Pawel

>
>thanks,
>
>greg k-h
