Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00FD760F2CA
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 10:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234622AbiJ0Iqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 04:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234524AbiJ0Iqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 04:46:32 -0400
Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC3033E2B;
        Thu, 27 Oct 2022 01:46:30 -0700 (PDT)
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29R7PlnH024408;
        Thu, 27 Oct 2022 01:46:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=UpyDVAysIckJv9/LwJq5g1oOnF5Fj2TTedOXHWgNWw4=;
 b=ADW8vu8MtQ15C3Ljx9VCwswg0QOXxz+Z6ME1qKx7oOpUoQko/H97cn5XTa9vnd2wPk/h
 vUFKK9BfnnjNggjoJzg8SjNs0u0roxNpWXoOeiosNEkTuEtGUJ02D451iCXxhlLJq5gJ
 e2WOnEMyZPomLP6ZTSWu55lhZt6agaVoCGjmxcmeHFiqJ4GwIE9Psh1sMaOAWQF9fJuB
 zR0DwQnT92UbII0AV6HoEeNt4PSv1PoViUbIgdj9wEqM5vSEAhEXe8iLmdEBoV6JM0j/
 A58vhNkqJF8lcae1uLE4NZcl+1uhVZjjEQ4yGZRl1jLYHrYq/zbtEThDgJrUCRsQGEtx WQ== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 3kfajeaxem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Oct 2022 01:46:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZOcvz1CkPbV/IjELkub7uN6hwkz1uNUD5k2MvvvKYhhkNPZkCVGMYf62PlrgSq3tMUh31Ye1rDNexWR3CjxNkJaTuDL/wyeRJGGrH4ZROEmwa7E0u+CJU1uiO7ndb/A87CT+DZIcClPzS5vGu5qqsRTgPTsHtMeQAriELplFRs9uUiWOGdTYoXCc/FasXk86XVtwYahzXgFsHG/HSDbMBbo6PpjTeeubIbg40dGqL/pPvDeqA+Vua10sV7fpXSNKznrs0WC694wm98neKYjJMwAaUvEGoi9nl3yk17aiFPBtnWnudIRdFFuxPbCqzDjYpmMu3ujqSdMUNkKme+whOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UpyDVAysIckJv9/LwJq5g1oOnF5Fj2TTedOXHWgNWw4=;
 b=EIepcMcFFd/03TPvOiMtpPFu8zlKTbGILPWQfgCSIg9mltzJuUDqI0TIm4QD8dPmXqbah2k8ETasTLgqoHF7eo1sLZDY37iAQs4p8G+pVEtB71RlvqVuxXL8qvtXUTcd2m9VZP2KLlsBiJKSGMsNKybOsqGoRW3Wwc1xTEG9jqGqMpWgvjecUomILjwP9I423MsOsW2piPwd2NrCzITuKCARc/aoKM1xfCeG1hvIRMRVF3KlZKHPdfuozzK0jRsVRQR3n0sONd1kG1Ka2i6bzsTswANh5vzDzlA4tRZ+ysIcRoMf6MIEsQCO2r3ftYBAzydNnkLeV/SgVFcF70l0yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UpyDVAysIckJv9/LwJq5g1oOnF5Fj2TTedOXHWgNWw4=;
 b=CRu15S3MLt7BZluTNv+bRqn4hUKvVoX38vcII55ZMUhyTh+n02Bgfw+MjkVOFGHmW6qTM9I1GZ981folZtsNnlUJu2vu2Vwa1rD/KiuvPdxJ1WLO26dj7Y7S5h/sIa0TkM8uL59yS71oxd/4ZS3YW4mDMR6cjZiT4MUL2pPtD1E=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by DM6PR07MB5865.namprd07.prod.outlook.com (2603:10b6:5:18b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Thu, 27 Oct
 2022 08:46:18 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::ea7c:b79f:752e:1afc]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::ea7c:b79f:752e:1afc%4]) with mapi id 15.20.5746.021; Thu, 27 Oct 2022
 08:46:18 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Peter Chen <peter.chen@kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Thread-Topic: [PATCH v2] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Thread-Index: AQHY57Ge68RMVQuhaUeO0fOrXMci/K4h2uCAgAAVsiA=
Date:   Thu, 27 Oct 2022 08:46:17 +0000
Message-ID: <BYAPR07MB5381482129407B849BA9A616DD339@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <1666620275-139704-1-git-send-email-pawell@cadence.com>
 <20221027072421.GA75844@nchen-desktop>
In-Reply-To: <20221027072421.GA75844@nchen-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctZDBkMTkxOGQtNTVkMy0xMWVkLWE4NDctNjBhNWUyNWI5NmEzXGFtZS10ZXN0XGQwZDE5MThmLTU1ZDMtMTFlZC1hODQ3LTYwYTVlMjViOTZhM2JvZHkudHh0IiBzej0iMjU4NyIgdD0iMTMzMTEzMzM5NzU4MjkxMzQzIiBoPSJhTVBqTEFtT3NkUUhIanoyMTNzTXlJUFRjdUk9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR07MB5381:EE_|DM6PR07MB5865:EE_
x-ms-office365-filtering-correlation-id: 098415cc-d8f0-4a8d-05e5-08dab7f7b6db
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +c0hzjSvmiRETGvMmVd0WN1XTo6Csfcz3BKB1fe+LvYtjLhOSuxRsgW+p1P8P/ueG347cm5u30632ICjPfwarzCCzXBBCQJX/2nSOijqaJNhU3mS8Ro5yZ4oeKJUSUtgV2CHAbJaEfUfYY0vVnV6kqVC3x78bPQkDCtugLdTJD1tDX8lERcHerHSkKzQx3NyI/QQt6vmgL6HG6dyZzdeqv7I5k8iJASz3VM4Vf1bEvxDflaaKLH87aQTX+6sGL8RrQu05WMrmbZUyDKrqVBcJ0mNGV8gBYaHDA6isidhMsb/Yq7UjGy8jhaWqqpGUutKMuvjW/xsSEJcqhMdhPgazYGzLO3hRXTyRfYtbBIVSSkup1IFmOsuWPqLba52mugpY0w2eY7F8I+IpKLqBzNqZgEg/ZCYQLci6pD6kj8i6JijvCxednL4uXXdqvhrNpQLXJYJZUaYhMYv7y5I6e6qmc5v/l97IEaJl3iMclYaatftMlVsckCTQFbKV4eChqHBhVDqZNhh2TIceJNFRaH9phE6QA5h+ywwbpsq99BZun++znUGE3dSsp25Vt/oRR0yiv9hZyWocCSM1n4rr1NXW9+2k0xOfvXS/RHih/Aw6tVglwoJbFIlP8MUiDZBfLXAaDm5H+QCEC1DZiTEJ26qU4PwapjJdFf9+TmzF/0DyXjpmJbBiNsP9KgjhPW/uvhjqwZKUs+nIhbFzDJz75nJeuq4JYm75/whz2TGgvukNaP0MbkEIOoISapFHGK2fu4XFsp1G69VbUpZiY2P0VomVg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(366004)(39860400002)(376002)(396003)(36092001)(451199015)(64756008)(66946007)(33656002)(66476007)(41300700001)(66556008)(316002)(38070700005)(66446008)(8676002)(76116006)(8936002)(6916009)(71200400001)(5660300002)(54906003)(4326008)(186003)(86362001)(122000001)(7696005)(26005)(478600001)(38100700002)(6506007)(55016003)(83380400001)(52536014)(9686003)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xS27eaPrxk6P2F+uEljzAKITh0ikVpNX6LxipDW1z1BM7+0DuWuQHo8QCIma?=
 =?us-ascii?Q?sfPVnMXiEeIm+ZdGmiIBtlo1jSNj4wX7m2qdeXqRlat7C1PoMmZ+zJe2ULR8?=
 =?us-ascii?Q?TwggGSRp9rsfGSr2oKa+o/SobKeuuPxZquqwEaZRKbPOtJzuJomODLLDysr1?=
 =?us-ascii?Q?88Dera9yADZaiABK2qlu9nsRSxu+qNUlqL0rOS5TNSx6fffLTmvFujfsCe6R?=
 =?us-ascii?Q?QeuKclbaShEFr1HpEJCi9xRdofgiFmPURWDgPP6JKto9dOtywi8iAHhVvICp?=
 =?us-ascii?Q?59sGDsLslXrsDFCGZcfGHDYKxNge+fBLAaKTN3ZVUuieUC8Xj0xL+E4biRJj?=
 =?us-ascii?Q?t9LAFWggfOOEoBJvcf3WXaLzZTd112wUGsGkA/nt41mOyGiyb6GNsuR7k8is?=
 =?us-ascii?Q?5mJTOByPQ1FXmdqV+JrlYgGyEAfpGI6jEswtwHZwxC+Mst/qHLpryhVtUUNh?=
 =?us-ascii?Q?5n2GEvdxmJ9KTLXpjFwVJ6HxIf+c9rsFVpuLKO5CU2c016MXM8B1Mj2f20yI?=
 =?us-ascii?Q?me9LWS1daSKfYn+zA/twermF1QVNX581CbDKBB2EAqIiASCni59ukvDrFzsw?=
 =?us-ascii?Q?lrMHOJqaRJdyTMu4RBPJDfnEJGyQ0IAQe7CU1ig1tue6jRSnxTRIpq8a8d/J?=
 =?us-ascii?Q?wZHuf85G4hS9ql/vt5IfNTzMvPwN15qSM8uqsOKmOLdhiEuHduAIJ6MLi1X2?=
 =?us-ascii?Q?To+zSxCFuGwYfCdP0chSqv4BFW1sutWchZSabphRaw7b+ayVlkzVHcMxPDxC?=
 =?us-ascii?Q?XvGqC7ZWV8xaHUlFi8sH8BNwgjtBVR6Oc32a0d9NhNNqmABbySz0T+6X3mKf?=
 =?us-ascii?Q?jZUZD/VxzCU1nZfcgY/UTrlGJQO3F5TNnYHh1oPUQPhq2nqwBPat+MQf/hwX?=
 =?us-ascii?Q?dTADPKlJP9S6NQF2lXdj77gyeQlIVuAtBPSzFvBXodvsm5WrToVmy2IyhZrJ?=
 =?us-ascii?Q?LXRTUII6Fh5Tzdi/ldcEbSTm8UnMi81RXnZDweaBojp7P8Y6KNy0m7q13tUE?=
 =?us-ascii?Q?PyN7TRYFmj9rsH5B/EW5U6qBCI9mRHnkA6SDufsMMndccL8zubtlFoqllak5?=
 =?us-ascii?Q?rLXPum1mnElfB5dUazHXWqq/F1DVNKqtf4bldadn21uxWOcfLfOB05SyOnAB?=
 =?us-ascii?Q?B+YGgNG8hiWwnOxtmuhSxxeGJg+kR9yBtaJMXvbSx/yUIbu8QTQsqBlpa27N?=
 =?us-ascii?Q?tQ0gdxqdFntw9gjKZx8JCLaJIHdN+lkKv5QuSdC9k+E0GOaF3by7iXKKnR3c?=
 =?us-ascii?Q?8xFrT+4TwhuqpwuzNcoipGUuZuCMwUB09I9p6FwAo3CBA4eqCwJoItsI0nPU?=
 =?us-ascii?Q?k2sUcn2CostiG0sRYJhcq7t6heMSXFDkMcqnEuFOS6/JdzbuH5LY3KWfYPZu?=
 =?us-ascii?Q?dnUO8pYsc+6AeTKLE44ggoezJ5GwkYxONRx1zVEuK52o3VPm5b/xPqNWoZTY?=
 =?us-ascii?Q?Il4EDpB+48JEiRhU3gzrNMpfGAhYhPsrroljeJeqPWwqFw/I6jgdeqkq3cZw?=
 =?us-ascii?Q?PttSaH/v+3bg9lC1JzEnVoauE+rcspCm4F6zG6fY14mjGHzun4FGASxiABE2?=
 =?us-ascii?Q?Pc8Amt+aL6dIz1DUck1rz/Q8lMpB1JSleFXg/0jN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 098415cc-d8f0-4a8d-05e5-08dab7f7b6db
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 08:46:17.8802
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /vJwbMpwrnC3j1umLUSndE4XzoWwBWHKMpUKkdIHQoQzQSrzi5fcmL2D1dJlXw+yxi0gkcYyrFTxBQuCEzedAJWo7+wFjejeo//5UVkNXMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB5865
X-Proofpoint-ORIG-GUID: Ide3UuMkenUoNFJswevV6JV2Il5byl4Q
X-Proofpoint-GUID: Ide3UuMkenUoNFJswevV6JV2Il5byl4Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_03,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 clxscore=1015
 adultscore=0 spamscore=0 bulkscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 lowpriorityscore=0 mlxlogscore=503 impostorscore=0
 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2210270049
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>
>On 22-10-24 10:04:35, Pawel Laszczak wrote:
>> Patch modifies the TD_SIZE in TRB before ZLP TRB.
>> The TD_SIZE in TRB before ZLP TRB must be set to 1 to force processing
>> ZLP TRB by controller.
>>
>> cc: <stable@vger.kernel.org>
>> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence
>> USBSSP DRD Driver")
>> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
>>
>> ---
>> Changelog:
>> v2:
>> - returned value for last TRB must be 0
>>
>>  drivers/usb/cdns3/cdnsp-ring.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/usb/cdns3/cdnsp-ring.c
>> b/drivers/usb/cdns3/cdnsp-ring.c index 04dfcaa08dc4..aa79bce89d8a
>> 100644
>> --- a/drivers/usb/cdns3/cdnsp-ring.c
>> +++ b/drivers/usb/cdns3/cdnsp-ring.c
>> @@ -1769,8 +1769,13 @@ static u32 cdnsp_td_remainder(struct
>> cdnsp_device *pdev,
>>
>>  	/* One TRB with a zero-length data packet. */
>>  	if (!more_trbs_coming || (transferred =3D=3D 0 && trb_buff_len =3D=3D =
0) ||
>> -	    trb_buff_len =3D=3D td_total_len)
>> +	    trb_buff_len =3D=3D td_total_len) {
>> +		/* Before ZLP driver needs set TD_SIZE=3D1. */
>> +		if (more_trbs_coming)
>> +			return 1;
>> +
>>  		return 0;
>> +	}
>
>Does that fix the issue you want at bulk transfer, which has zero-length p=
acket
>at the last packet? It seems not align with your previous fix.
>Would you mind explaining more?

Value returned by function cdnsp_td_remainder is used=20
as TD_SIZE in TRB.

The last TRB in TD should have TD_SIZE=3D0, so trb for ZLP should have
set also TD_SIZE=3D0. If driver set TD_SIZE=3D0 on before the last one
TRB then the controller stops the transfer and ignore trb for ZLP packet.

To fix this, the driver in such case must set TD_SIZE =3D 1
before the last TRB.=20

e.g.

TD -> TRB1  transfer_length =3D 64KB, TD_SIZE =3D0
          TRB2 transfer_length =3D0, TD_SIZE =3D 0  - controller will
		    ignore this transfer and stop transfer on previous one

TD -> TRB1  transfer_length =3D 64KB, TD_SIZE =3D1
          TRB2 transfer_length =3D0, TD_SIZE =3D 0  - controller will
		    execute this trb and send ZLP

As you noticed previously, previous fix for last TRB returned
TD_SIZE =3D 1 in some cases.
Previous fix was working correct but was not compliance with
controller specification.

>
>>
>>  	maxp =3D usb_endpoint_maxp(preq->pep->endpoint.desc);
>>  	total_packet_count =3D DIV_ROUND_UP(td_total_len, maxp);
>> --
>> 2.25.1
>>
>
>--
>

Thanks,
Pawel Laszczak
