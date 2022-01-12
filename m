Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC6E48C48A
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 14:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353502AbiALNN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 08:13:59 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:44486 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240900AbiALNNe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 08:13:34 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CAOkRO017984;
        Wed, 12 Jan 2022 05:13:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=qeSojkakIt2CJBAsHIRGpHge2x3MOXCLTRgC7BKst54=;
 b=aA287crAwQDONDGJj3zl347oVjFQFgCivlnBZweRjfbcjtq+ih8QyjpcZkQTCcrrVYKz
 RjTuDySLzVg2pbnCACB4Z1ncd49e9iAWpwQPs6Ms9wPXwbS/khXaLYgo51Ap5VrblXLP
 loz75mqlyB5K5HMI+sWgBgQUZBLw87OEikVoCPnXFMgHQJ6DXiB6F9uI7l1zezP18QCy
 Z51EW3LWWFZH7OuMO/2iDPEpc0CujGt4u1J/W/Z9S36AXBKiPjLH9sBALFt4VI7nfbn7
 9oFIVPA/T6x9+0g5GmFbHCuFMg6to41L6lzXZQ7PBUfsVIhN7aElXZI9+v7gJ3uil0w0 Uw== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2049.outbound.protection.outlook.com [104.47.73.49])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3dgkxpr9hf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 05:13:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bPZKaZJ0+HVrkkDjqndBxuqqJB9Iza1u/kO939i7Iz2X44TcyCrp3iaxloYPLBR0fFmzfBmSDqYbv5y0mKJTaSaSHaCps1Maufz2P3gmglA5TzsJr2kaHSFL18/FywSBvghFoLCffEtUKCEopVdxYaPjoZUJYWztxTdq6Em+fm3NupHsmgxB/OB0lLoMFrCfCgEupK10kJCIqx1Kqay+3IZe+hzcNeHib31HJqtPYsXKr+mrpzhhgLtmJPrdgvTzrsl38ry6EsT1YCkOPuOsFMmizLbGBz7EARuvPWkHTfk1By540NWVaoNUdFP/2bGwEx/bL2nSIUeK7/wBng2k1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qeSojkakIt2CJBAsHIRGpHge2x3MOXCLTRgC7BKst54=;
 b=e/8vvLfOgJhHrsMycMqpMYQggkD13AWGW9uVjwY18sp0SSWjovHttN3YElu1vyAHQKIobs+JhJ6Z/KsSvnVhUsdTagVwEbZ4YjNEDd4WTLIwImy/vWMcV0+3D6x9zDpX9uoW+Pn3ZrR0u3y5FKKPj4tp/nbHIcxzbdrZlDyAPJdyPed1d/4AHNBeR6u/p2u4nhZ6936Nm6I52GG7zZIj8RtFU3XWRZsj77WSVJfcrpNZEE/15PFtWQp2DaqMft0rRusTAyOy0hnFS/l73N58g2Rmc7GLin7FTsdT1OKbHrwOa4TFbLm9VkWxzj3ZCYD20eFZ6vLwipp18/UAI8310Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qeSojkakIt2CJBAsHIRGpHge2x3MOXCLTRgC7BKst54=;
 b=hkz1larqMDPaQcfElKEyIr6Y3bGDARdYVdFS2d6NDdX5IkRRZDpTCj3YyratCMFyd7NbALCxLooPe/CKxGIVKUDd46ypsTvtTDytMBE/oJ28Pzt9ll//qJGndEt5n5APHMzxt+jHCYm590+/T2g+XoJg75K1wD800lZC08uilgY=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by MW2PR07MB4010.namprd07.prod.outlook.com (2603:10b6:907:4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Wed, 12 Jan
 2022 13:13:10 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::c0b7:f4e5:466b:e90a]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::c0b7:f4e5:466b:e90a%4]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 13:13:10 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Peter Chen <peter.chen@kernel.org>
CC:     "a-govindraju@ti.com" <a-govindraju@ti.com>,
        "frank.li@nxp.com" <frank.li@nxp.com>,
        "rogerq@kernel.org" <rogerq@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] usb: cdnsp: Fix segmentation fault in cdns_lost_power
 function
Thread-Topic: [PATCH] usb: cdnsp: Fix segmentation fault in cdns_lost_power
 function
Thread-Index: AQHYBsrYK4fAFdkFQkqeOjWZYn4NnaxfWfuAgAAAlzA=
Date:   Wed, 12 Jan 2022 13:13:10 +0000
Message-ID: <BYAPR07MB5381D8455AF977200D503D15DD529@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <20220111090737.10345-1-pawell@gli-login.cadence.com>
 <20220112125615.GC3796@Peter>
In-Reply-To: <20220112125615.GC3796@Peter>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctNjI0ODM2ZmEtNzNhOS0xMWVjLTg3YTgtYTQ0Y2M4MWIwYzU1XGFtZS10ZXN0XDYyNDgzNmZiLTczYTktMTFlYy04N2E4LWE0NGNjODFiMGM1NWJvZHkudHh0IiBzej0iMTgzNiIgdD0iMTMyODY0NjY3ODk1MDcwMTMwIiBoPSJUc3JnZmlveWsweCtYNnFEcktOcFNpbjZKTlk9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b9adcd7f-25cd-443e-85aa-08d9d5cd482a
x-ms-traffictypediagnostic: MW2PR07MB4010:EE_
x-microsoft-antispam-prvs: <MW2PR07MB40100CE06686C3C1A44569E9DD529@MW2PR07MB4010.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1hUHhTWA95lohXAhIVyMgMocKhtivCdmSo+eux9D7a8eUiiOqZ2CYybucFi6NYmQbsUof8GzRRMJ+2jANwp0RzupTofxNyh3JI1AS/ho+omJgzBO3IcWzTrxvT9KJihDmlGrvtt+iHejIojvKV6SRpW7gZEJzfJWNF2lJZkUfSyy3uyca0vrw/R8eH90wbhgDWPg891W7j638GKMHxOuVelIIvDYPC+NiZUpszDHYwe59bjX0XP71DwIozvQcWiivAsUJuWGQzqXjaICcXRSHEZYzZl7FweJk9myWo7r7I0ZJx4B/gG5CJ9HVxFkaZj67Zr3BKCspjxLeKW6no4xHn/n6ga9TxgkZGrh81oIkVJ7W3/vaVWl0vDhioL3Kwm8G50UzWCh7hmnRfIVFrGRnfA8seZ8vlZpxVIWg/XfiXV8PKkpiyIsLvcre/7eAE4044VlM7vU/epNLlbqx0A2buqJjUJEI6UVjR9YLmcx6wLs7W4ejX1gGeCMSy0rwXRo0V6oQxmGGnmOGhkfQjgz+umIAHARazKVjsBL7JWwlF89h3nlQerLJ/5QthuIXVDptIZ3SbPIZ++0CPDuFAYRZ/9DjDXbF7BlQv8Zbo91q4uNYGwN74A/SyTR7nWoEh5dqTnsCJRgQ4r9UtxSHzzs27Bw9V5kdNpPt6eJNYXluglstm37nzCx2rSsggdwpXNp5bdAhBBaCYmpO0/CdZF0YiKJO6CvPPvjgz5vDRyIRd5YhaG11QOFmJ7mV2rbNP2o
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36092001)(54906003)(55016003)(33656002)(5660300002)(186003)(52536014)(66476007)(6506007)(26005)(316002)(76116006)(86362001)(66446008)(64756008)(66946007)(71200400001)(66556008)(2906002)(9686003)(7696005)(83380400001)(122000001)(8936002)(38100700002)(8676002)(38070700005)(508600001)(4326008)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nOgvkTW/Zw9L4iJJ1O0XD6cN6QO3DvILktTlUeJS+mVFCJUb23CNYFeXI1Wk?=
 =?us-ascii?Q?9xznl9AyxwMtauVDw/MfRU9AE/lh4tPr1dnjXq1UYP1BY8zoKtTLB/EFDKgi?=
 =?us-ascii?Q?mY0EjkF1wMrbA8nusCEv10oIuKt6aA9awr1dV5934nD4dF5gY0ENG7BbUU4k?=
 =?us-ascii?Q?iStJASuQReNNts9HSOXdMxAYU8CRYjkjTAoG4Z+aobxo2mKRvtUcAbMJS1cU?=
 =?us-ascii?Q?6WH86wIw5E3W/J6JTGAWK6F+XR6IeX+0PuwYGEX5g/QpOEzsZ9GxjtFcLcLh?=
 =?us-ascii?Q?nfQac1Ef/KtGq20ho8DyiER7LkJBwH/9yMUzPxH3kpxBQt5RjhToghDoLWLm?=
 =?us-ascii?Q?jZiHOjDU5PXmyQpgo7y/GCvjkdLsLuWPunsAi148LTuCF1N1OkuQAK9/5LZr?=
 =?us-ascii?Q?KWo1AQ/SamJtSAQI8Ky5KkI9CbNmGuR75hLCO4nBZAMv0jma+zXv4pNfrnb1?=
 =?us-ascii?Q?E5+eS9xbGKkR1Fvty3R8YYzqMcYNEEzYP0eX9+rhjWV5zo711XcxCsgFirf5?=
 =?us-ascii?Q?a54z1xicCcg1OQbq6Jtk3PL54G5Bw6S0K9pvE7TvgjgqYlUUEtFLlspmbfrh?=
 =?us-ascii?Q?XP1BhEL5lNJg0sRopZhLTy1YaugfUMe6mHFF20pmGaMdV8qqeOYRSQD4wyT4?=
 =?us-ascii?Q?n2VyQ54+9LwRNruPtI5zW8lWGSUitrZBHEasXm9+LYsmA4rqaUbp5DAW5kD/?=
 =?us-ascii?Q?eA9HelAiF0+43X6y6McjiC6tBwoozvUNuLn85hrPYPuP7VfVAAdDtzAAFE0g?=
 =?us-ascii?Q?VaVHrfA+ULiM+RNQcZfkdDSm70VZC+ixbTK0knJHiVlYlrefN3GdjhFFcAWT?=
 =?us-ascii?Q?D9gqCaEA2XZ+xfGoYYsMu7/GJye7w1SQepS9r0cKVFwRajrcT/KbRl2a2w3D?=
 =?us-ascii?Q?yDbftMwpTOeb+BV8MtvuukwJGZy30DQoksgsSmRqdf410jBkqAOu28Pt8fye?=
 =?us-ascii?Q?Ef49q/e1qwlK3v2ZdhCrsbzT87llCqxmh55nBcA1LK7A57KVz2w8L1JukIYh?=
 =?us-ascii?Q?U7CFpU1uHL1qNh4uNEaQ+9zMBJhNIcEN9BeB3Y1IMnFrii02tKAwOWWqA+OE?=
 =?us-ascii?Q?0prbgltJgBSXqM7yUDtgbCe7EPR+hS2fTEZAhihoL4cKQm0EzEi7akGSNvAO?=
 =?us-ascii?Q?yTWKvojz+7pfAvbP+1RfAjROXuxPtqN/sVLALgzek7PGf79qiR+uzSisq59N?=
 =?us-ascii?Q?VWqanGo2CntMj8gqfXezeNZF7TU/NJbwcav45BBz2W3+bJ3g1J8eJWZxaGpQ?=
 =?us-ascii?Q?woFkassGwnK/nTjnThhebRa5RGrpMivdXJl96fnqvAHgiy7YwGgT2ab+1kwL?=
 =?us-ascii?Q?5Kea/NODTAuGYDRcuGNjKMlGEVXAzzzDS1/gxycpjiaIRgmONqp4ADIT6nWr?=
 =?us-ascii?Q?THydqG7U0Rh3BAadmDK9g7zVT3+PlsK4YWzP4zDQcxp5N1QLMdJd0UT22dGq?=
 =?us-ascii?Q?Kl9q1g+g/J1HjuIgUkDOuS6quiirsPpH10/OZHsALLccxWnCK3Ykf32HtFys?=
 =?us-ascii?Q?FHj1qMXM2JBzILZNvBB5dYMw1wOI76tJaGrMy1RgRRSyiTaJCNaf6XbXqsOt?=
 =?us-ascii?Q?OoizP+XSlSYEt2V2WFv07yMA8j2PRztn+/6CLl7xvH5cmxy5WY93G8p3DFpK?=
 =?us-ascii?Q?uANj67QquyfssXcJ7HVmzdZGaNYDafbu5Mxg6vwMucttI3Zw87L4KvwE3uVY?=
 =?us-ascii?Q?DvuV9g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9adcd7f-25cd-443e-85aa-08d9d5cd482a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2022 13:13:10.4769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vSNa4rKjY4wC9u2puR5IpWsbi2RouKMdtukPPZ7aCp2gYDsq++LD1MpPLbET5ZIyL72/IOwUEchnTGaCkzmt6uyGkbAwg6KOJqoUL6YHwwY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR07MB4010
X-Proofpoint-GUID: FN2tnG_q5IJhVMuv8B3KjVWBAP7xsMhr
X-Proofpoint-ORIG-GUID: FN2tnG_q5IJhVMuv8B3KjVWBAP7xsMhr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 malwarescore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 mlxlogscore=653 impostorscore=0 spamscore=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120087
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>
>On 22-01-11 10:07:37, Pawel Laszczak wrote:
>> From: Pawel Laszczak <pawell@cadence.com>
>>
>> CDNSP driver read not initialized cdns->otg_v0_regs
>> which lead to segmentation fault. Patch fixes this issue.
>>
>> Fixes: 2cf2581cd229 ("usb: cdns3: add power lost support for system resu=
me")
>> cc: <stable@vger.kernel.org>
>> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
>> ---
>>  drivers/usb/cdns3/drd.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/usb/cdns3/drd.c b/drivers/usb/cdns3/drd.c
>> index 55c73b1d8704..d00ff98dffab 100644
>> --- a/drivers/usb/cdns3/drd.c
>> +++ b/drivers/usb/cdns3/drd.c
>> @@ -483,11 +483,11 @@ int cdns_drd_exit(struct cdns *cdns)
>>  /* Indicate the cdns3 core was power lost before */
>>  bool cdns_power_is_lost(struct cdns *cdns)
>>  {
>> -	if (cdns->version =3D=3D CDNS3_CONTROLLER_V1) {
>> -		if (!(readl(&cdns->otg_v1_regs->simulate) & BIT(0)))
>> +	if (cdns->version =3D=3D CDNS3_CONTROLLER_V0) {
>> +		if (!(readl(&cdns->otg_v0_regs->simulate) & BIT(0)))
>>  			return true;
>>  	} else {
>> -		if (!(readl(&cdns->otg_v0_regs->simulate) & BIT(0)))
>> +		if (!(readl(&cdns->otg_v1_regs->simulate) & BIT(0)))
>>  			return true;
>>  	}
>>  	return false;
>> --
>
>Pawel, may this lead cdns driver segment fault?
>

Yes, we can observe such situation for CDNSP driver on simulation.=20
As you know, it is a common code and driver support two version  of registe=
r map for DRD.

If cdns->version  =3D=3D CDNSP_CONTROLLER_V2 (for CNDSP) the cdns->otg_v0_r=
egs is NULL.
It will cause segmentation fault.=20

I didn't analyze why this issue was not observed on my FPGA testing board.

Regards,

Pawel Laszczak =20
