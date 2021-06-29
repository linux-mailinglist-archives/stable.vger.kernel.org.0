Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8DF3B6D64
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 06:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhF2ERJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 00:17:09 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:42784 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229517AbhF2ERI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 00:17:08 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15T47NHs016290;
        Mon, 28 Jun 2021 21:14:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=tJHk6SrKnhzVZeaOHCuZFzmpnhDiCVH+wBZvmwDbL+8=;
 b=E8PF040D96fOkbBfHirZz2bEpUThMIxEmUS/wSLWa23fp+wnDCp5zcoNL78ENryq7zzV
 5/+BDGE968HbLhB1vKBkpF4zDD6RBpdbM9hf1a9etPmJ713QA1B08PShluiA/yNURRtL
 ORxPqyhFhX/V9FJLRscM8uqm2vsx233OyLrRbcXZJdEoPYtUQRcN3pqBmYTm4zp+/GAD
 MJh46TZjexlCANoBiI4RW5Pik2VuZ9UO3qcIFfG5eM32gCSJ678uSDlCloxgryTzxtaR
 Hu69URiQLsRVfMfTNjP1b2JKK6X5PWdy7XMn1VxiHaXTI27DqLMqd3gumiT6hbObkatw Sg== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by mx0a-0014ca01.pphosted.com with ESMTP id 39f66xctq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Jun 2021 21:14:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OTVxSQKFXWWZD54hjIGp5DDxS0Re9EAbf/x6u5tVISnQt+WHlp69Li2O3ajltnD0vlq5Y0WIGvvCRLQBVlV4dZbjbOgDmKSMyxyQGIi8BfsqncNNz8OjmSDVyhq9UVZRKor9fjOj35jvw86UHVNkdjYMc00RpcUriPRnj8bXAqMJXoJ2Lqul0R7TBdJykOFVU4IAbDTxjxi7IvKOHmBf+apC+I5ys8drgImePZ1O3PFNKZnTxaC4Txmv0S2Y9wu6F8YbJNhvfOPw226JzVIAJYTzjXEcftaWUm+x9NnX0s7BVEw60fERIo4FeXRSHOhMXzWA7Bn0x45/19jekeLe4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJHk6SrKnhzVZeaOHCuZFzmpnhDiCVH+wBZvmwDbL+8=;
 b=Gg2J1RED4Q0TgE9UdTM4nqxDJmQJmX/47mYELa1/laSTKuLY3a6jv2RCH+wF884UtY9iZa+mW8LFDmqtO8K7w77pKFMPOwtOMsk3Ak+UJfzS3StH23LDlOq5BH4cJX0k5htOdX/cJb1nwFceP1t+ilUP9ToC9z7TYX/UlvCWM5pM0oJSBzpP6VYUShAwMU1wr6DMwVOcXM1SrGTSmM1NQEngUFPz9qaIGN3ZTaW0xMDIC3TbVXQYvW5VctrrjNfH0MxmnaZ2DJXPk5Vi94h/MKxBnsPPxCWj8Mp2/Uun3WcFxpQlMdbtpUS4Na9BAYDTyv/nrqrRK+6DcK6YiPgcaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJHk6SrKnhzVZeaOHCuZFzmpnhDiCVH+wBZvmwDbL+8=;
 b=PbG5S9znEy23+BC6CteOdDzJBlFFGUMWYCwupm7g9uH3fhmBZFFXw+0Ey82puly5pJRjgiWj/VyDKw0Z9USxB2zlRLG4WTVezbNSfdV9m7+xPOHcJOUMDv/0yKC+prV2Qby6lHJHtrf8yriT+G72xClvvKsZ6LTp137e+cgw9ds=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by SJ0PR07MB8725.namprd07.prod.outlook.com (2603:10b6:a03:376::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Tue, 29 Jun
 2021 04:14:34 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::21a3:4648:fcda:e438]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::21a3:4648:fcda:e438%4]) with mapi id 15.20.4242.025; Tue, 29 Jun 2021
 04:14:34 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Peter Chen <peter.chen@kernel.org>
CC:     "rogerq@kernel.org" <rogerq@kernel.org>,
        "a-govindraju@ti.com" <a-govindraju@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "felipe.balbi@linux.intel.com" <felipe.balbi@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbi@kernel.org" <balbi@kernel.org>,
        Rahul Kumar <kurahul@cadence.com>,
        Sanket Parmar <sparmar@cadence.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Brown, Zachary" <z-brown@ti.com>
Subject: RE: [PATCH] usb: cdns3: Fixed incorrect gadget state
Thread-Topic: [PATCH] usb: cdns3: Fixed incorrect gadget state
Thread-Index: AQHXZ/3ptkUHEkmY6UucrnPuWW+DP6smAnGAgALJ+aCAAWvzgIAALO4g
Date:   Tue, 29 Jun 2021 04:14:34 +0000
Message-ID: <BYAPR07MB5381DC97BB26892DFE2312C8DD029@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <20210623070247.46151-1-pawell@gli-login.cadence.com>
 <20210626085655.GA13671@Peter>
 <BYAPR07MB53812E6619228B19C2C3A6DADD039@BYAPR07MB5381.namprd07.prod.outlook.com>
 <20210629011457.GA14090@nchen>
In-Reply-To: <20210629011457.GA14090@nchen>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctODA2MjZjOWYtZDg5MC0xMWViLTg3OTEtYTQ0Y2M4MWIwYzU1XGFtZS10ZXN0XDgwNjI2Y2EwLWQ4OTAtMTFlYi04NzkxLWE0NGNjODFiMGM1NWJvZHkudHh0IiBzej0iMzQwNyIgdD0iMTMyNjk0MTM2NzE2MzQ0NzUyIiBoPSJqN3pLTWZLamlHNXNOekQ0T0xxcTR3SGVMUjA9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=cadence.com;
x-originating-ip: [185.217.253.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3947a85f-a74d-4a8e-48bd-08d93ab4670f
x-ms-traffictypediagnostic: SJ0PR07MB8725:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR07MB87253492CB6CF79B430605EBDD029@SJ0PR07MB8725.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H65Ph2ND0W/Q6uHrc678t+7DUCGfNahcNF8TuRM0KkSSVzHAu6TSeCv9+ohoyryoAj77ne3Kat8vayhqz51fripRZVw8GYV7xH60W/ClqBjIhCtGoOjtIhdJOQ8Cagr6cktRUQZqIT1596uzBx2b2M1evC+AdRds9vGbyRANXSFjchI6PA7wjrqdIU2FpSzp0KTJDnehOMn8tJbjwylLbTaucKz/+gwzns19FvB9CdN9xFnUd6tV1YumUj7rHD7XpT0e7EPQ3sDX9COht/3phLSEX98Uth4NbiTHIUuUdiX5QTfEfYwTGpHfeJkDpcbEhX2ucYjLpSKDpruaE0h8sYhePajVcgXUKmwWkXWaHZBs8bMNxIo7dimEVmZQ2D7TSHtm0B7GskYO5qk+R+t+c9gmEf2uTTpDRtJIzTvE02+Xa8HGmlunyTOT5air+acT5T1uVHhxHSPkieQMyZpwQ4akaiuTDclL2oRv85s2uxu0+WCxpomTM7oQp+LqgcYydKNWte1LLqBUMA5xjHrjznqp2BbxnHmkIIiMjvnjmOceUTcNl8VD1R+UQCJgrhd02p124sVvBxLDfNnO71mviVH9OpHurJo/6T9s9i/HoGtaDzZC3PJeYN/cTkAovz8twoopdeMMQ2flqQPsyvt2xwU1/4euGoMV5zrU781Azx15DIHi8ZnFv6h9BaGzIwC5/tOQ4E5CGnDzMGbDlALYXkbDRMy7bWzojWqX+7M3bh1qwGHqgVAhc6DzldYBt2CpnQxAhvbjYnnAAqJ0DhDhErQ2X3YBd64mh9O7qB5jAjLqKtGQ996u5Xl3WRcnN5Fchp7rt8XO7FY+jX9BltoB7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(376002)(136003)(39860400002)(36092001)(76116006)(38100700002)(478600001)(8936002)(966005)(8676002)(66946007)(55016002)(33656002)(7416002)(66556008)(64756008)(66446008)(66476007)(83380400001)(9686003)(122000001)(6916009)(71200400001)(54906003)(26005)(7696005)(5660300002)(6506007)(316002)(86362001)(2906002)(186003)(52536014)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PMVbJWH2LPWUcOVwp9NzHQjm/+DQDNhDuFP31pY3y+1v+YNC1/2yadRCXRTz?=
 =?us-ascii?Q?I1g4DEtHqACW14TkqIwEUulKPtdKDsvd/cusRWqgwPny2KeJLTtUKaY5D9Jm?=
 =?us-ascii?Q?KpLENoXB6NNcyOav4rdYm6kSH/nRhex1C8oIIfwZ6iAxsunLvte4YeyAFVFA?=
 =?us-ascii?Q?Ce9yVA/pqyZKy62WABuDfVQlcMdhTERp2Fx7R4aOH/pGIwitU5L9dZINDM+e?=
 =?us-ascii?Q?QNVtnCtXovVmsNASfIVGiKwOZwcTxZH5JG52hb1WxHwPVJsTJtkE5BWQpRCQ?=
 =?us-ascii?Q?yjfSHPlYmWktqoLfKmpZdVLoP1FiNGE0wZW/IqRFaSj83uKoW35pmQnjo2hD?=
 =?us-ascii?Q?UtC6Ev/Gl2WSjRF83/k6/RqmhikE+8wpIunWqBx76b3JouQ2VwblkaY9ITQj?=
 =?us-ascii?Q?XjpW4AX8z/w0oqLfPbKGPqBzFN1JOFEZ5ppAbuIhFwY1MPavDhv2NM17brpa?=
 =?us-ascii?Q?8uCG2b0QXfe8rEDEtDjJgbCjGnTHJy3fw7xH8NXRkEYVV0cz/fVPPkChRouX?=
 =?us-ascii?Q?dkaeq4eToukySy6YHwuXU5JdZ2PGjKKgZvKab3AqzgKAj3oK0SuZY1k2q7Nd?=
 =?us-ascii?Q?LIafvqMEnWpv5jxiK1VQsRHHQA5x0/hSh4RPSWW7mws5gXy4a5F1L8ptO+d3?=
 =?us-ascii?Q?JCAfE3Y7aw5jBLKBo0Omh3Fwl/tmUdUf0vix4vQzMwqfvrj5BonmKuTioE29?=
 =?us-ascii?Q?GXmaBNSjp/mO0bVXkmrA9jT6nD4K7NP8dbh0/UJVNVoh9tVOE2i00PC4+ZPB?=
 =?us-ascii?Q?Q6kKC9OTsVjaAb1ORn09M5rpFbB/rx184KJsTqvPTLEVx4yNdhgk360jPxBA?=
 =?us-ascii?Q?qtfxgAkaq3SC745OJvm5+C1i4NO+33943mU0Kb3gg1N85pXwqRswYPBp3d3k?=
 =?us-ascii?Q?5z8VhAogm6kYQkq36Utj4wsu7GW/eWfzzsAkDIoXXsgccVXVbdVh1sGqSaMY?=
 =?us-ascii?Q?EEB/P0sCky2uw/SKGGDv3MctDfP8EdlX0fMkuhTHeaq0+2Vz9tom2o1BBzUn?=
 =?us-ascii?Q?UEaWRFc00Oo5qs5HgW0mhFw2nBB6yAGoMVax+GAevGVXsGk0DLjcqeQo9meD?=
 =?us-ascii?Q?1IYWQMfbcCxoljM9SVBH8s//EHeWKp7qZ4q/SBBdiHnAJ7yuN6bWmzF+9xFS?=
 =?us-ascii?Q?v+Q/tnJVZ7yJAq+ziwLQl3bM/ElPmoEs76W26OUduNzE0n6JG5yYprwWzyVB?=
 =?us-ascii?Q?4lB/b0zfvPcZCi7WplVyJdjJhIb7Cy5Ao0Cfpr2bUydNHARojOYfSprrXXNh?=
 =?us-ascii?Q?I6UJRPNXg+hYUzgbNKN3acG/l91oyeQ7q50CtfCqhnah5aYgO5OOG0KUPEJk?=
 =?us-ascii?Q?CJDCwqn1a3EUYcdT3E+ITO9n?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3947a85f-a74d-4a8e-48bd-08d93ab4670f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2021 04:14:34.6155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yr0wSwzrPrAHAbXwmiFxCuIuCeMZhKvvT/mXGp14hkBBcWJTBpEGYHh3ApCcHhuizW603U8eSWcm6bTxUsWI3TxkiyMZLZADKTRABvq39J4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR07MB8725
X-Proofpoint-ORIG-GUID: VrUqctHi0fQjtrb1Ca8pxdEO8ESuS8ay
X-Proofpoint-GUID: VrUqctHi0fQjtrb1Ca8pxdEO8ESuS8ay
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-28_14:2021-06-25,2021-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 phishscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106290029
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>
>On 21-06-28 03:46:38, Pawel Laszczak wrote:
>> >
>> >On 21-06-23 09:02:47, Pawel Laszczak wrote:
>> >> From: Pawel Laszczak <pawell@cadence.com>
>> >>
>> >> For delayed status phase, the usb_gadget->state was set
>> >> to USB_STATE_ADDRESS and it has never been updated to
>> >> USB_STATE_CONFIGURED.
>> >> Patch updates the gadget state to correct USB_STATE_CONFIGURED.
>> >> As a result of this bug the controller was not able to enter to
>> >> Test Mode while using MSC function.
>> >
>> >Pawel, would you please describe more about this issue? I remember the =
cdns3
>> >controller at i.mx series SoC could enter test mode by using current
>> >code.
>>
>> The issue occurs only for MSC class. MSC class has delayed status stage,=
 so
>> after returning from cdns3_req_ep0_set_configuration function called
>> for Set Configuration driver remains in USB_STATE_ADDRESS.
>>
>> In order to enter to test mode driver needs meet the condition included =
in
>> cdns3_ep0_feature_handle_device function:
>> 		if (state !=3D USB_STATE_CONFIGURED || speed > USB_SPEED_HIGH)
>> 			return -EINVAL;
>>
>> But it is still in USB_STATE_ADDRESS, because there was delayed status s=
tage.
>> To fix issue driver state must be updated to USB_STATE_CONFIGURED before
>> or after  finishing status stage.
>>
>
>I am wondering if the cdns3 driver set gadget state as USB_STATE_ADDRESS
>is correct for delayed status stage, since the composite core has already
>set it as USB_STATE_CONFIGURED at function set_config.

Composite core set the driver to USB_STATE_CONFIGURED, then=20
cdns3 for delayed status stage restore state to USB_STATE_ADDRESS, because
the configuration has not been completed  yet.
However, after the configuration is successfully completed driver should
set the state again to USB_STATE_CONFIGURED.
The best place to do this is the completion event for status stage, but we =
haven't such
event in this controller, so I've put it just after preparing controller fo=
r sending
status stage.
The same solution I found in e.g https://elixir.bootlin.com/linux/latest/so=
urce/drivers/usb/dwc3/ep0.c#L134

The other solution is to update gadget state in composite core before or af=
ter sending delayed status stage,
but  such solution will have impact for other UDC drivers .

>> >
>> >>
>> >> Cc: <stable@vger.kernel.org>
>> >> Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
>> >> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
>> >> ---
>> >>  drivers/usb/cdns3/cdns3-ep0.c | 1 +
>> >>  1 file changed, 1 insertion(+)
>> >>
>> >> diff --git a/drivers/usb/cdns3/cdns3-ep0.c b/drivers/usb/cdns3/cdns3-=
ep0.c
>> >> index 9a17802275d5..ec5bfd8944c3 100644
>> >> --- a/drivers/usb/cdns3/cdns3-ep0.c
>> >> +++ b/drivers/usb/cdns3/cdns3-ep0.c
>> >> @@ -731,6 +731,7 @@ static int cdns3_gadget_ep0_queue(struct usb_ep *=
ep,
>> >>  		request->actual =3D 0;
>> >>  		priv_dev->status_completion_no_call =3D true;
>> >>  		priv_dev->pending_status_request =3D request;
>> >> +		usb_gadget_set_state(&priv_dev->gadget, USB_STATE_CONFIGURED);
>> >>  		spin_unlock_irqrestore(&priv_dev->lock, flags);
>> >>
>> >>  		/*
>> >> --
>> >> 2.25.1
>> >>
>> >
>> --
>>
>> Thanks,
>> Pawel Laszczak
>>
>
>--
>
>Thanks,
>Peter Chen

--

Regards,
Pawel Laszczak

