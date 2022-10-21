Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4335607034
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 08:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiJUGlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 02:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJUGlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 02:41:22 -0400
X-Greylist: delayed 5860 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 20 Oct 2022 23:41:21 PDT
Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880A523B6BC;
        Thu, 20 Oct 2022 23:41:20 -0700 (PDT)
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29L2XmuY005879;
        Thu, 20 Oct 2022 22:03:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=ovaaNTJrsdnQmPvqWBnZ9jRLQiqam/NwmdvgD9r3coY=;
 b=d1bPO74t1tVGTu7e4Qggckw2rxlcJmPrHGov+OZ3aDifhtWeslLzkPMA9MosKGjVZ/mF
 pcBHWehCiLs7U1cw6jpwCfTcC2zDJ2Mf7Mo4bkFNr7GXziRssmxW/wjkZm2rJuqby4pA
 rlaW+k+r5Q6ev7HrCG0en4DmYvAQf71vyM+6qP7FKhXTFw7kaztpwmvshjjchhIMuNpX
 mkX6b6QuUpYPNxyAx7AuuxC2N1dsOh/vsncCrJCJgtuoztRzikiYVgbrXuuh/ppDT3jF
 XehaMAoYgPG5Ci7xVCn+2IBiI4zUprwQnb+1nNVESXuhflEviuZ+9J9wWfgockrrM9ow RQ== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 3kb01mnnx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 22:03:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eAUrL7uRyQ9OpEr+zq7Ji6EOVa46bW5SFK0O0ZXR7VjuYhNQmQeZxxKY/LyJAblkEEW7UgELiKztpJKEPsYUj3rj+Lsr04AmllMPKJv+rSnrRqBA5DILCZ3C9Ag+BpKIfXoEWUXRt5BqPigjT+4v7PMrYwzFMZz8Zr2sUXaQ8eYu1xNtjO7V5bqv/3+rz+ZLJ4ku+KER+6dIEkUXxt56rwSUc6EPhIWI8QReriGw67UcMFpDmVIia05hu6sZNziFTznrzJVUxLDBtcOhpNVcUDo/o+XIqXn4lm+U4G6WtSsQO+1eo9lFMjr1BjSlAqBs3ubOOfA2NC1VvWgWpVoMWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ovaaNTJrsdnQmPvqWBnZ9jRLQiqam/NwmdvgD9r3coY=;
 b=NztcbIgheo8JJ9WDawMtzoVTl30N1KICFHVKdEbd1mjJILV+DDG4CB4f5RCrLhAJrWYBSiKfmPvvA1K8CwNmC/K+fFC+b+3oojLlru6n1pDp8eHj2dfFlxbr9ePQWXaBULvzB1ls+8fJ2buiiSQ6GioyPT36r53BFiKmmIHIzz1peuokyyqW5qOlHvQ3S6XbqZK8WLOVFJ6ieExZliAptkGbkOEbq+2tSqGK4ptNHsRWI429N6xaa3lThr5eve4s5wgOU5Jw7P3f8jD3hJBnjvM24qxSurilPohvklXlCRa4VmrSZN8DSo+yQLClguYIrQhT112p6qiu5O8mZbGSeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovaaNTJrsdnQmPvqWBnZ9jRLQiqam/NwmdvgD9r3coY=;
 b=tgRBZ11TjkdlCj4JUuyJowD5wKsgEZ/D9k+A7mj5EjzTwJ6EbbLYm3BHM6MDe2J139K/GBiMyCYJXoQ84jnNgeuAqbXovkoHj3NpO2up258CJFcz/EszmK5OIQM7g5Qgyj8X7fwujxHNJ2CHc1Yoij9yEvidaHaBjimd3CLtAcY=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by DS7PR07MB8303.namprd07.prod.outlook.com (2603:10b6:5:38f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Fri, 21 Oct
 2022 05:03:25 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::ea7c:b79f:752e:1afc]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::ea7c:b79f:752e:1afc%4]) with mapi id 15.20.5723.033; Fri, 21 Oct 2022
 05:03:25 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Peter Chen <peter.chen@kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Thread-Topic: [PATCH] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Thread-Index: AQHY44ERVMaQ2YM4VkyQ1o26SeztW64XRlkAgAEFafA=
Date:   Fri, 21 Oct 2022 05:03:25 +0000
Message-ID: <BYAPR07MB5381E4649DFD2BD0C528AC0FDD2D9@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <1666159637-161135-1-git-send-email-pawell@cadence.com>
 <20221020132010.GA29690@nchen-desktop>
In-Reply-To: <20221020132010.GA29690@nchen-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctM2UyOGJmZDYtNTBmZC0xMWVkLWE4NDctNjBhNWUyNWI5NmEzXGFtZS10ZXN0XDNlMjhiZmQ4LTUwZmQtMTFlZC1hODQ3LTYwYTVlMjViOTZhM2JvZHkudHh0IiBzej0iMjEzNyIgdD0iMTMzMTA4MDIwMTI4MjU4OTU5IiBoPSJ2aGhVaGVVb2JHZ1FlOXErL3hYcHMzd2hhdDQ9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR07MB5381:EE_|DS7PR07MB8303:EE_
x-ms-office365-filtering-correlation-id: 588cc9e3-c138-443d-7532-08dab32195ac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RLi1Aeu3LLGYPrpS11ZhI0r83q9q+V54oOqjTePKewT+OqCMp2b9M60Cq50C6zP6MyClHbh90NvCWVYGvbk/4Hu43F764FEuPHlOOTIY856ImYWd24lcrsogVW4m3DpMtXscdDJf7xg08qcRfBKd6fIDkKokwte+Z08fx2eOvQdqK6jQBAC3fZKJcShbkeUZZmv9y+tdVGvlhX8QjKC3j3ervxPVYuBTGplvr10Y9IWxXJK7JUmzyR9wPRI4W5E+2a3UDejO96y2ReInRj8V9B5ZI3QdMaghQBzlSrpJlyRDBB7RgSP2xQR/9Q/3s5IqzRy6DKxWKo5WSdcjQZc/5Fe5MXHVOtGJVI1ttOcRj9oHBybOkoTl+JP5WzzBoiql3wjncqLF9lnszxoeqObNCORaRSa+LrtPYYoNKq3+jhR/PLqb9JJWTv/KzDkfMVw+Uz9PFXSEcdSLYUwC0pqEFsc1QHy6O3kmuUUNNqA5jHuMrwKbR2hLS8S5kCQxyzNRQb5TPIcwaebiLQGbXsBvCXXhgnX49Z/qFC73NDfniaJUPgZXBSy6NBJ/gIF06w8x30HhhIo1D+e7r6PTWhiJnWzkNd3ztw4fGtSb30nBLFfxEzaGsRLyus2bGVyohMDmGht7lqpASTQEgqH5IrLls7TPc7lsstA0xWnPc0DL1rQSRgGsCFn1zMC7K7kRCHTm2Ht/yPRNzTokROwuy2+a3AHjX3PvC9xs138a1CbOsZliXmhZLytj0WYIlDR1rbxKZ6jp3xVMksau2VBXQj10ag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(36092001)(451199015)(71200400001)(122000001)(83380400001)(6916009)(478600001)(316002)(54906003)(38100700002)(9686003)(66556008)(86362001)(76116006)(66446008)(64756008)(55016003)(66946007)(4326008)(66476007)(8676002)(52536014)(38070700005)(26005)(186003)(5660300002)(8936002)(7696005)(33656002)(2906002)(6506007)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SQh+FOh2JuQaeibxymrebNhLF3+lT3VChhhKi/qs9Nd6XEz19yt4b+J6FAsD?=
 =?us-ascii?Q?q8P+MfdCxrw3q0kiR3RMmbHYBlemUP9BwIOv2jwbPTuG21bCtHQVbV4Mpmzg?=
 =?us-ascii?Q?qyqi7nma8NLd1t5kmUyv/zCyQsZZdnUbFk9gLbrHsfAX2XhcQaPkfXVrv5ot?=
 =?us-ascii?Q?4Op4LrzL+MWMFDM4HMWG7FOTvZMwhrDr5diXse76bB6k2pJXrahKi8VIgRyc?=
 =?us-ascii?Q?7DkhlB94MshGm2u/U7V2dkTmapfN+83We3H9mAXo2DLqmVQmZDsxLtstWcBo?=
 =?us-ascii?Q?EcP4YUkD9D5BFHO6TdEB5j/8aZK3XRisYsmV6SljuNVgtEKMLsf1KroLrS3l?=
 =?us-ascii?Q?THHVjcC3mJKWWTen6lOYIQEWB5DNW5n8Ln/cSo8or+OjJoqPJsR+4ZNgZZ3j?=
 =?us-ascii?Q?tGnSdldCGfZe23DVOc27oE2mrvHrHtKSEkTyTNKgjBAn3X+Dfpn6yvwupUGW?=
 =?us-ascii?Q?izQ8DtH6WLLL2hcpblfIDPBsBLzp7rkzV5YCvWlBLlNbAcUrrrfodB//XTJS?=
 =?us-ascii?Q?onTYpWz1/mn0x2jM/XDQBhokr2RbbN3HQgjYl8Ek1i3f1530InsN52IqMEH1?=
 =?us-ascii?Q?EvZoPFhPzNS9c79eDVNlVGAvNo+BmtXrLMod5Z+kVtYkirURiZDbOpByzA2g?=
 =?us-ascii?Q?GbXRrjnNa5pb77EhNbzwjjCRqsVWhBIsg/LG62Gm7g6XV1pDR/k9KLUMNJVv?=
 =?us-ascii?Q?zTkAB1LN0AbfxFnQZYXHuldaiv12pt8uvzm14xL/XsRiU2DPQHYkMYmElkYq?=
 =?us-ascii?Q?bPEKj/JOZEOAWF1KEBB86dyXVUZbuLnTKlxMc2vjLhCXB7jg6VA7oSdVuUTZ?=
 =?us-ascii?Q?Tivp1TMKdgIr7xU1Nh2ScPdoXJAW2TAr10VZHJ2Pke2/kdqoLHfZ19vS6vwF?=
 =?us-ascii?Q?Rc4/05kgdm+qMWXJXiWM4mKD/1L5t6zwr1D+ZfRF0mHFoeX59TJuyUALBri8?=
 =?us-ascii?Q?w3jqjNVKIldF/1jLC+4yUBKhTUHVqhrR+sFUW1p/Dbu39qC92Pl6RIza9nYO?=
 =?us-ascii?Q?rpLwRZzVYj5Thm4DqkqVRN7Br1MxRQZQr34StT+q+V2s9Vux5LObFC2oRWvD?=
 =?us-ascii?Q?CAd6vAPYSpCPZ2Rp9cgDtI1mBs2O4FMhF/tWAVXk+ygmZ99r7xWBvcGSJ+gm?=
 =?us-ascii?Q?aRUWdOm0cQDVDYqXElxhDZJP11uHGginuveWne0bi85k3wMP519W38X0ya28?=
 =?us-ascii?Q?1tbYMVtB/bJ/qZoFAlSLQjtx/74fkd7JpItV4DY4oDKBrgw+Vld7f2PTmBBQ?=
 =?us-ascii?Q?T9P5qo4usbNKl5e+H/OwV8+aprZqWa05mSfTh9viz1MHv+DBRPBI3xuYSrrn?=
 =?us-ascii?Q?UkwH1oR3EyRy7n9ORRCezV3nnUFMlQh2TpqdzKmdWYR1JRgqzrV8XhqUBtQr?=
 =?us-ascii?Q?57G0N58uUOp+E3PPBKV0k6kP1Wq1zqGRtCu0FHSH3ggsn6iGbzxT5gu+NmuV?=
 =?us-ascii?Q?hxjM7oAKMgiJper1ZiBQETL3d2y1KOqsjDQoP+zH+vde0fotWJ7p6zW+hoXR?=
 =?us-ascii?Q?QCISumZs4psRkVNDRSr6n7y5gZ+bDGR5gK+YOT/DyhGRZKz+TRi315D6u7uQ?=
 =?us-ascii?Q?4BXF5QiAR7Ykr/QbhtQO9CSetFGB1AKRI3VsVnYKe32UMVVkqn0jbt1tQrk3?=
 =?us-ascii?Q?Yg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 588cc9e3-c138-443d-7532-08dab32195ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2022 05:03:25.2590
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h4cF5wfjn+S0094MehrVg7fpGByxkby6DV5lOfTb8tuT7aWDTTXjMtKGxtHDrQY5/S8FjcWTRTDuIVUE2+/bkQz4UNrDBWS8+3Y9aSrmPCA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR07MB8303
X-Proofpoint-GUID: dTKx8hNVFzmPIAYicY29LUoSrYvYI6B9
X-Proofpoint-ORIG-GUID: dTKx8hNVFzmPIAYicY29LUoSrYvYI6B9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_01,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 adultscore=0
 mlxlogscore=482 spamscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 mlxscore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210210028
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>
>
>On 22-10-19 02:07:17, Pawel Laszczak wrote:
>> Patch modifies the TD_SIZE in TRB before ZLP TRB.
>> The TD_SIZE in TRB before ZLP TRB must be set to 1 to force processing
>> ZLP TRB by controller.
>>
>> Cc: <stable@vger.kernel.org>
>> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence
>> USBSSP DRD Driver")
>> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
>> ---
>>  drivers/usb/cdns3/cdnsp-ring.c | 15 ++++++++-------
>>  1 file changed, 8 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/usb/cdns3/cdnsp-ring.c
>> b/drivers/usb/cdns3/cdnsp-ring.c index 794e413800ae..4809d0e894bb
>> 100644
>> --- a/drivers/usb/cdns3/cdnsp-ring.c
>> +++ b/drivers/usb/cdns3/cdnsp-ring.c
>> @@ -1765,18 +1765,19 @@ static u32 cdnsp_td_remainder(struct
>cdnsp_device *pdev,
>>  			      struct cdnsp_request *preq,
>>  			      bool more_trbs_coming)
>>  {
>> -	u32 maxp, total_packet_count;
>> -
>> -	/* One TRB with a zero-length data packet. */
>> -	if (!more_trbs_coming || (transferred =3D=3D 0 && trb_buff_len =3D=3D =
0) ||
>> -	    trb_buff_len =3D=3D td_total_len)
>> -		return 0;
>> +	u32 maxp, total_packet_count, remainder;
>>
>>  	maxp =3D usb_endpoint_maxp(preq->pep->endpoint.desc);
>>  	total_packet_count =3D DIV_ROUND_UP(td_total_len, maxp);
>>
>>  	/* Queuing functions don't count the current TRB into transferred. */
>> -	return (total_packet_count - ((transferred + trb_buff_len) / maxp));
>> +	remainder =3D (total_packet_count - ((transferred + trb_buff_len) /
>> +maxp));
>> +
>> +	/* Before ZLP driver needs set TD_SIZE=3D1. */
>> +	if (!remainder && more_trbs_coming)
>> +		remainder =3D 1;
>
>Without ZLP, TD_SIZE =3D 0 for the last TRB.
>With ZLP, TD_SIZE =3D 1 for current TRB, and TD_SIZE =3D 0 for the next TR=
B (the
>last zero-length packet) right?

Yes, you have right.

Pawel

>Peter
>
>> +
>> +	return remainder;
>>  }
>>
>>  static int cdnsp_align_td(struct cdnsp_device *pdev,
>> --
>> 2.25.1
>>
>
>--
>
>Thanks,
>Peter Chen

Regards,
Pawel Laszczak
