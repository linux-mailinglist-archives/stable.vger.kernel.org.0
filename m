Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3BCA61EA8E
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 06:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiKGFjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 00:39:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiKGFjX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 00:39:23 -0500
Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B127662;
        Sun,  6 Nov 2022 21:39:21 -0800 (PST)
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A6MS95O010541;
        Sun, 6 Nov 2022 21:39:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=2aJ6IEEoy6f3j2bgv74ipH8FNUcxYankOFdjdPxeNAE=;
 b=S3rnUlW4zhqsU1IgQ7V4OrqSHSW6YddIJUCM2yMc1P6jth06aMFsCGXpAhCBmthvg2h+
 Q15K0z/lRij/+br6p0h9WezlnVWx2FLeZiDM1cDj4WtatGb/G7KXgv4ze5roWPk6o/QT
 vBkD3VewzQKDWbRLRg6Fon8FShQOSVMO0CA1ptesvPyAWS01e5RKpFPBcpo4hEJ7wspo
 lmfGx73il8R0/iMzLBI1z07D6+hADq+l/2bAg4mS6WJ26hF5lY2BxcGDGTtDu5z5Orkf
 xce57UIjrRSpz9j2PGZMiHY7IYaxUOPiwyYyEc7UKEuXkmnXBwxzR7Es8uhl74nRLDyk /Q== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 3kpepta198-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 06 Nov 2022 21:39:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OU+yrLYfMlkWwY1Tc6fwvWpyHDbYM3ZQkTw/Wt956Z4ckiTz7sFWqe+H4ADj9NKYgmATLNmOYREILDhJOBYyxnop32AoF6Yq2o/wu+2gizsaHEPeR3GXbNTpKRZtriIiZbvT5ICp25/VFwNwT4QtazzqxiEsjEnS9/G//8N+58emhrzf1IQU8pZ9OCVcuwbFScV25HDovx0GASnsWQEcDYg8saw81EKyyZrbeOnsJkc9YuYhz7Pko4DFGMEBTFtiS/CqjgsQqhkpgNK1Vuk6bdboKJ4d9tabYefss8qbhpn59IRSqF2VlVH/y8ve5yP1f2eqwRDHW0KsrLK+XIeX/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2aJ6IEEoy6f3j2bgv74ipH8FNUcxYankOFdjdPxeNAE=;
 b=iahjTvq+FX6jCxaMnjXISsOdqrFf0tROZG4mcANe1Q3kZ0Eqma8RnQtInnhS7keSGsE/Fp6Fa/93ZRlf9s0YYAX/42d+N4D6a3XhxV5P3KIgpyvJeZS6tJsN31SG/9qjhb5jBCExjydnC90SwTSk//Bm8gv2irviHDcmjJ/UgLoVht/5QEWt8ysPubIZceUZbMpNEhyKNR8Rgl4iEw3SNAuAneQT1LydXlTM49uT4hheusHFktuSck+UwkTtE4BxIvoiuTV/B89vBmBeHLQ4Jk6NzFlOGy8ZHa3N4mgTeX1Ptmw+/k7NMyMAL5ftTHDWbqO1GraVkQ6Q3o76+QPmmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2aJ6IEEoy6f3j2bgv74ipH8FNUcxYankOFdjdPxeNAE=;
 b=CISpXgHCnHIxEdr6YZOffnNi6MySNxz7AzYU/L5NrRfNQuPhl04mVAJX/2YktML0Hr41g39mXpQqiQcOxYCeIPc4DMpeX8k+ClI9yLtx/qGIxnYpN86q/1y5UsJrnb6W5CcVoQ/KUwPeg0Z6Jmmq1skwwvW8oRzsFq+mG5+biY0=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by DM6PR07MB5594.namprd07.prod.outlook.com (2603:10b6:5:36::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Mon, 7 Nov
 2022 05:39:08 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::ea7c:b79f:752e:1afc]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::ea7c:b79f:752e:1afc%4]) with mapi id 15.20.5791.025; Mon, 7 Nov 2022
 05:39:08 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Peter Chen <peter.chen@kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Thread-Topic: [PATCH v2] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Thread-Index: AQHY57Ge68RMVQuhaUeO0fOrXMci/K4h2uCAgAAVsiCAD7z/gIABUoKQ
Date:   Mon, 7 Nov 2022 05:39:08 +0000
Message-ID: <BYAPR07MB5381CD42617915D95122D56FDD3C9@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <1666620275-139704-1-git-send-email-pawell@cadence.com>
 <20221027072421.GA75844@nchen-desktop>
 <BYAPR07MB5381482129407B849BA9A616DD339@BYAPR07MB5381.namprd07.prod.outlook.com>
 <20221106090221.GA152143@nchen-desktop>
In-Reply-To: <20221106090221.GA152143@nchen-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctN2Q2ZGE4Y2ItNWU1ZS0xMWVkLWE4NDgtMDBiZTQzMTQxNTFkXGFtZS10ZXN0XDdkNmRhOGNkLTVlNWUtMTFlZC1hODQ4LTAwYmU0MzE0MTUxZGJvZHkudHh0IiBzej0iNDA0MyIgdD0iMTMzMTIyNzMxNDUyNzYxOTgzIiBoPSIyR1VHc2NIZVRSMm41YjVXTjFOSm1iUGFXdDQ9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR07MB5381:EE_|DM6PR07MB5594:EE_
x-ms-office365-filtering-correlation-id: be407443-e5ca-4c95-1cb7-08dac0826417
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V9PFIPib5sR+RfrkNz2kBxMStvHvqYKhbazFIO7uEwkIoUgP6yRrUmuLmaiLw1tGHrNabm56qmKnjxQXtqO1+wHuIBEzE5xqld1EQ+2iQIg+UPBuM71P0EI5Wr6X/h5pEn+7CM5xCG8Je7WZlNl5qm+e0nClLGg5+fvibtQtbAher0HKw8WX0uwcNs79fWtozdbCQLJwH/ebNH/M7mLH4PVd3JVHgMDRRFVCrtTTDhDkVH0APlPj1WAzW+AjtBz8G8SeQWKVm2cDsHx3jhVmgnpuMFziaODUfqB7J49Oc7EX7f1niUNXj5zl3I3TXXHCLD6hyx4RkguN48UILY3jsBJBRxXrPPkC1ZoC08fN/bX1oNcxpOhQMOSX7eWeQg3YOAltFg00Tpjjw2kRP52A0FdSXekN8s22u5WSM5UxIMnZcBDQAuLrB6mKs2RzY08VLkTb8+TCuSHbauDBK56jYEQAHVTsGzs7MdTfWvzh5j335SYsYeydfo7J4VQg3z0YJ4D5nyp5WEsFty4a6j0eB2Aw+lWleLQIk/CxoWZB+DdgwzpNsWOhVhScqFr7BqNW+gH8ogb5m88tygCJLEeQ5DblH5SKatYyFMIWsyuw2koVngsKAZmVv+KITLK8cZxLbGDQIOkj//mH0uTp6VLHCF3/4eCKSlUjNKrRLiCQo7vWPN3BK9mencXmFQEqYzikLUBLkYYQnpQStsRkZEP5w6lmfq16YxsYtsYHSf/yweAsr0OcHk3EyTmlY6XTuvxdBCOPlmVGXhTVp3MZ/rcwGQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(36092001)(451199015)(41300700001)(5660300002)(66476007)(6916009)(4326008)(54906003)(8936002)(55016003)(38070700005)(64756008)(66446008)(66556008)(2906002)(33656002)(52536014)(316002)(66946007)(83380400001)(76116006)(8676002)(7696005)(86362001)(6506007)(38100700002)(26005)(9686003)(122000001)(186003)(478600001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fsLF/uS2DEvpzir5/4OAt94aEW4MaJczYsYnrkFPHtoy4gsxK+k/bU4NRCKj?=
 =?us-ascii?Q?C6lm54EZzfHn6Lkot/zSfC/yfDrHot1F/CGiw9IANV3in+JYTTD9UjhrE8FP?=
 =?us-ascii?Q?zSQvgIeCaGcMr5Ce8nw00GD5KcxGZyHPpT9uGVJOrxdTePhCOUwqrV4IRMZ3?=
 =?us-ascii?Q?y7uP4Se9psRuahSVyOZY6le81bjrMNMd48ed6Eqozj5+oCOaOcopLAZ2S3dG?=
 =?us-ascii?Q?Qq59G0gKMBkKPxqdxZqswRgaz5vXPUxN4UVteskw677jjdoT407Ipx8+/Tni?=
 =?us-ascii?Q?Tw2NECJkm9pbYl19g9iv86RoqSMIamnHMcLE5dkxCWBFK+zISzTJYAhXzY61?=
 =?us-ascii?Q?Di/YHneYrPbIsBszpbE4aYx860O+VchW2KdbuE7od9yWZNMv6heh7SyUeLNL?=
 =?us-ascii?Q?TKt7n8UNO7oLWoTD4WTCOjwiWrh/smWwzYl/xrmMZw4ft6yCUqK2+1sqpBwC?=
 =?us-ascii?Q?bKGt6b5BXTns8AyFuYG4EJgU+neNZl+YIGrMvzWvMNRzPXhiJ9oguPcis86d?=
 =?us-ascii?Q?b29iFG+HUWWIdyyG0BArtSd1g1N8KI47mXvBRihEmvtn2mnBzBeY0El0HN5z?=
 =?us-ascii?Q?oRla/oDBu2m37e5chomfABAQC91pIArtygTuhXxRbbGpSmGpWpb+KkTb+pCO?=
 =?us-ascii?Q?8ScGEKWQdQq4DwFTlNEXIIF0OHRfLe2+8kcfQj7JdQsGEpv9hf3xwJC6SWlH?=
 =?us-ascii?Q?qhlX64f7zCBU6ap+eDlbQvI7ameOxg6Po9KQ8K3aGAqilFbzyFQPkzJvL3T2?=
 =?us-ascii?Q?UHKDACSPRFnMps8NSSsGyHnNTdlMts8+U7XLJ0ou4sn1SuhwJneYpE3gq9lz?=
 =?us-ascii?Q?LSnCZ5RFFpTUnaxCecPo/yPug39/p3biL//vTtS3WCiIKcAwuI6lNss9Ha8t?=
 =?us-ascii?Q?z+YlAGGR8EmL3qbIkH/v1j52WJyb9cX8jCcZrE74kjd6hahAYnv4dMmgWBrL?=
 =?us-ascii?Q?s9Lr2knXMlEBWaA7WO3SBkYQAyJb2dkknDl9V6qecuu+NL/essI+Wt+SynoY?=
 =?us-ascii?Q?b8AFTrSdpNttVCLT/+OjzO7H4cTyAX4aFnVQqm2URSns7KHT7a82Dzu3WYmr?=
 =?us-ascii?Q?bPrLx8qGXFgBGhRcfAjKQTWBDzU6gSA9zYvh1U15v7Hio3/tGgXxTD9YUcfu?=
 =?us-ascii?Q?Q58Vsd7Z/7SoQz38XvhoGE8tAPDbKDFyq/EOIiRwoNr+JKXmzzrdhy1/d/Pa?=
 =?us-ascii?Q?TOROuO6MHqn6GdZc/m3P70GCvmxbEH6qS7V1db5WFC6h/nAFx65mm7IM0RE+?=
 =?us-ascii?Q?eGdXMjZAKcO29yecvjlOJ+98VoRfveFg0kKG2eAjMXoTIFoAVOsREv5+dlTd?=
 =?us-ascii?Q?TjV5oquXeTVGaVsLyVwi49FkzM3Pyzcla8b8lXZNpjf4EE2gyLNEz/sjl+Kd?=
 =?us-ascii?Q?1Id+R8EOv30wnCZSSyxF7gg2JutfC9E/hPP93BJLkfxXwCpX94C9BJ8v8YSx?=
 =?us-ascii?Q?V7p6og6F4F/YOlIMit3fv9pZ1beAbFnlvFyRWGfrL1WK4Y93tErJDAntJ02O?=
 =?us-ascii?Q?Exi2hfRZvEH7bQ+9XepfozCVxgy/P/llapdjSu3ZNIBruYjhMpOcJhaUg/5p?=
 =?us-ascii?Q?e0fbivjAE2MapKZ4xy/WXp5eOGmB1Jn5k2u2qQUwQKOiVsUAA2qfO55Q1LBA?=
 =?us-ascii?Q?aw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be407443-e5ca-4c95-1cb7-08dac0826417
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2022 05:39:08.3239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gZDZioLrXPL3UXTxoHvnZ2GI3Arkvfba9bU7P0a392uu5PPiNWIEuhhOaHV7PmrVSpKtcY3IhQnmN9JfccraOrKCloPAfXOwNKJbPv3bJmg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB5594
X-Proofpoint-GUID: tbw37VKf4uvLTa_-KEXCY-Lm-Ig5mXvR
X-Proofpoint-ORIG-GUID: tbw37VKf4uvLTa_-KEXCY-Lm-Ig5mXvR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-06_16,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 clxscore=1011
 bulkscore=0 suspectscore=0 adultscore=0 priorityscore=1501 phishscore=0
 mlxscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=533 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211070047
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>
>
>On 22-10-27 08:46:17, Pawel Laszczak wrote:
>>
>> >
>> >On 22-10-24 10:04:35, Pawel Laszczak wrote:
>> >> Patch modifies the TD_SIZE in TRB before ZLP TRB.
>> >> The TD_SIZE in TRB before ZLP TRB must be set to 1 to force
>> >> processing ZLP TRB by controller.
>> >>
>> >> cc: <stable@vger.kernel.org>
>> >> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence
>> >> USBSSP DRD Driver")
>> >> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
>> >>
>> >> ---
>> >> Changelog:
>> >> v2:
>> >> - returned value for last TRB must be 0
>> >>
>> >>  drivers/usb/cdns3/cdnsp-ring.c | 7 ++++++-
>> >>  1 file changed, 6 insertions(+), 1 deletion(-)
>> >>
>> >> diff --git a/drivers/usb/cdns3/cdnsp-ring.c
>> >> b/drivers/usb/cdns3/cdnsp-ring.c index 04dfcaa08dc4..aa79bce89d8a
>> >> 100644
>> >> --- a/drivers/usb/cdns3/cdnsp-ring.c
>> >> +++ b/drivers/usb/cdns3/cdnsp-ring.c
>> >> @@ -1769,8 +1769,13 @@ static u32 cdnsp_td_remainder(struct
>> >> cdnsp_device *pdev,
>> >>
>> >>  	/* One TRB with a zero-length data packet. */
>> >>  	if (!more_trbs_coming || (transferred =3D=3D 0 && trb_buff_len =3D=
=3D 0) ||
>> >> -	    trb_buff_len =3D=3D td_total_len)
>> >> +	    trb_buff_len =3D=3D td_total_len) {
>> >> +		/* Before ZLP driver needs set TD_SIZE=3D1. */
>> >> +		if (more_trbs_coming)
>> >> +			return 1;
>> >> +
>> >>  		return 0;
>> >> +	}
>> >
>> >Does that fix the issue you want at bulk transfer, which has
>> >zero-length packet at the last packet? It seems not align with your pre=
vious
>fix.
>> >Would you mind explaining more?
>>
>> Value returned by function cdnsp_td_remainder is used as TD_SIZE in
>> TRB.
>>
>> The last TRB in TD should have TD_SIZE=3D0, so trb for ZLP should have
>> set also TD_SIZE=3D0. If driver set TD_SIZE=3D0 on before the last one T=
RB
>> then the controller stops the transfer and ignore trb for ZLP packet.
>>
>> To fix this, the driver in such case must set TD_SIZE =3D 1 before the
>> last TRB.
>
>  	if (!more_trbs_coming || (transferred =3D=3D 0 && trb_buff_len =3D=3D 0=
) ||
> -	    trb_buff_len =3D=3D td_total_len)
> +	    trb_buff_len =3D=3D td_total_len) {
> +		/* Before ZLP driver needs set TD_SIZE=3D1. */
> +		if (more_trbs_coming)
> +			return 1;
> +
>  		return 0;
> +	}
>
>How your above fix could return TD_SIZE as 1 for last non-ZLP TRB?
>Which conditions are satisfied?

For last non-ZLP TRB TD_SIZE should be 0 or 1.

We have three casess:=20
1. =20
	TRB1 - length > 1
	TRb2 - ZLP

In this case TRB1 should have set TD_SIZE =3D 1. In this case the condition
	if (more_trbs_coming)
		return 1;

returns TD_SIZE=3D1. In this case more_trb_comming for TRB1 is 1 and for TR=
B2 is 0


2.=20
	TRB1 - length >1 and we don't except ZLP

In this case TD_SIZE should be set to 0 for TRB1 and function returns 0, mo=
re_trbs_comming for TRB1 will be set to 0.

3 More TRBs without ZLP:
	e.g.
	TRB1  -  length > 0,  more_trbs_comming =3D 1 - TD_SIZE  > 0
	TRB2 -  length > 0, more_trbs_comming =3D 1  - TD_SIZE > 0
	TRB3 - length >=3D 0, more_trbs_comming =3D 0 -  TD_SIZE  =3D 0

Pawel

>
>Peter
>
>> e.g.
>>
>> TD -> TRB1  transfer_length =3D 64KB, TD_SIZE =3D0
>>           TRB2 transfer_length =3D0, TD_SIZE =3D 0  - controller will
>> 		    ignore this transfer and stop transfer on previous one
>>
>> TD -> TRB1  transfer_length =3D 64KB, TD_SIZE =3D1
>>           TRB2 transfer_length =3D0, TD_SIZE =3D 0  - controller will
>> 		    execute this trb and send ZLP
>>
>> As you noticed previously, previous fix for last TRB returned TD_SIZE
>> =3D 1 in some cases.
>> Previous fix was working correct but was not compliance with
>> controller specification.
>>
>> >
>> >>
>> >>  	maxp =3D usb_endpoint_maxp(preq->pep->endpoint.desc);
>> >>  	total_packet_count =3D DIV_ROUND_UP(td_total_len, maxp);
>> >> --
>> >> 2.25.1
>> >>
>> >
>> >--
>> >
>>
>> Thanks,
>> Pawel Laszczak
>
>--
>
>Thanks,
>Peter Chen

Regards,
Pawel Laszczak=20
