Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17CAD3B57EE
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 05:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbhF1DtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 23:49:13 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:47998 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232018AbhF1DtM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Jun 2021 23:49:12 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15S3iMY7022440;
        Sun, 27 Jun 2021 20:46:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=ZKUQaKQRfL5qAVYOgBcjuzNMZwVBos+icOhyFt0Dyd8=;
 b=AR+8y/lC8MoOGLShB7bL1M9tCLGW5+9xVD2W4PQCaLwJNEJbI1Nq7nM0lae4Ku2zBfmv
 HnDJRrjPcus4nxnXcVaCVKgkzJj0vXkjQqsgRITKJC4FOCvGwGvHMnkcQuahVv56JHUM
 NWc7YKObM8K69SNtYFtOhXlhxmxBadpcSnodlu/NE3t1wqjM3l/qzBP/7mEoexyyRqeT
 rn6KSyyYHnOq55s4P8x5tVIjlOopy01YhqGngg6qNKBKoxo/nSgQgzxFftv7lqPSUK6A
 LjUuPhzBc75MxsBtmn+dxFEIHkR7htn0rK323M69UfpX+MREsEwMHQWVfnvO8oNMlW51 fw== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by mx0b-0014ca01.pphosted.com with ESMTP id 39dyu1wxf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Jun 2021 20:46:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B3AkudQrH3B3mnNy94LRYswAYgCPcpHuJJbn1NIx/PHQP1AVVOx0dXZKA6yCQ3JnT5g08kCyO779y8S36HqIu5zSAln3kEMTAI4ApQ8K4nAaxV8pgi7pcBnPvfeZnONaG84i2luzNe2v2T3JFNZ3IIWIHBB6cOpTI4U6WlbT0UO5QNIxhwzm9ZD0HW5KDsPLDSR3Ad10DqjscHfPmzCXvEa1sR3QQDJVVsRmal2f/7e9TJC3FeE3+aQ3wDDA/y8+IR1YEXNqazgdkkA/ZZwFj0Wz55BmkM1OXbhz36JJhM9fV3lgVV4Q6baIurw99bwk4TKnm7jKuk2+vQa14bQtKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKUQaKQRfL5qAVYOgBcjuzNMZwVBos+icOhyFt0Dyd8=;
 b=jBqGpgo9ONIxvBn1a1T122ZmlNWhq7whGBTQi+OWT/bquYbwE6SM8lbZW0gew6Xi8RsrewRHEU5fHDf0c+ja5sZK0q1H32jthbLiAWaq/UUFJm37PEg+jUE3IchAFA0t7bPJ2fob14HExFFNQhasH74EDzoe/H14twRYGQMZczEjKX+Vp8nOGBDY5rfjCfc8BIGd407C+rCRU7B59Cg1Ks/4urHF8/tPSIXRujvlzgrmt/WFsl+qoyP4j265pDPha8NZZC4sTYAeFPHtvnp2179pp6EMDkZi5aqQnp5ooh1pQmi55FUtyijN+lr4SD+ZzxHCzTvlWAy/A8ZM9PgwtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKUQaKQRfL5qAVYOgBcjuzNMZwVBos+icOhyFt0Dyd8=;
 b=GgyHd+Cz6SG5R87pw/LSXIxt728+GgParxqEmRkgQUDXn4OTiTC26kbOPu9xeuFy0FfZz2aeRnsdEEoFokzSJUv+zs2vU/CJAekXz4PLUDdIDk3m4rt7YyScUHnoMvh4oy9F6fnPVKnIPduoWMhCH/bzEbOHsnCL/sLMCjPXQXs=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by BY5PR07MB8065.namprd07.prod.outlook.com (2603:10b6:a03:1f6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Mon, 28 Jun
 2021 03:46:38 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::21a3:4648:fcda:e438]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::21a3:4648:fcda:e438%4]) with mapi id 15.20.4242.025; Mon, 28 Jun 2021
 03:46:38 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Peter Chen <peter.chen@kernel.org>
CC:     "rogerq@kernel.org" <rogerq@kernel.org>,
        "a-govindraju@ti.com" <a-govindraju@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "felipe.balbi@linux.intel.com" <felipe.balbi@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kishon@ti.com" <kishon@ti.com>, Rahul Kumar <kurahul@cadence.com>,
        Sanket Parmar <sparmar@cadence.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] usb: cdns3: Fixed incorrect gadget state
Thread-Topic: [PATCH] usb: cdns3: Fixed incorrect gadget state
Thread-Index: AQHXZ/3ptkUHEkmY6UucrnPuWW+DP6smAnGAgALJ+aA=
Date:   Mon, 28 Jun 2021 03:46:38 +0000
Message-ID: <BYAPR07MB53812E6619228B19C2C3A6DADD039@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <20210623070247.46151-1-pawell@gli-login.cadence.com>
 <20210626085655.GA13671@Peter>
In-Reply-To: <20210626085655.GA13671@Peter>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctNmVlOTgyMzEtZDdjMy0xMWViLTg3OTEtYTQ0Y2M4MWIwYzU1XGFtZS10ZXN0XDZlZTk4MjMyLWQ3YzMtMTFlYi04NzkxLWE0NGNjODFiMGM1NWJvZHkudHh0IiBzej0iMjEzMCIgdD0iMTMyNjkzMjU1OTU1MDExNzg5IiBoPSJvZE95OXdyZ242UVpzZFNyR1pmVEFxejR3V009IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=cadence.com;
x-originating-ip: [185.217.253.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd948225-317c-4450-5c2c-08d939e75597
x-ms-traffictypediagnostic: BY5PR07MB8065:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR07MB8065EF5414C4509955AFFBC2DD039@BY5PR07MB8065.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6p/yEsFRtSxjwsl0ilR+/nh7vfcO2vK9ACe5nIy0Luqcgadv9t5RnN88D50Mmh4CQf2P8ahxfTehhPvkKhGEvUfqbe2DDw+DW+CO59RKsJhluk9jXfs2qSFXWWdSzsytBecwfgDnRQ3rdrEiBnsued3ENY018Ev8F4pMotZvHDVM7avgQyfFmorryjoBEGVsDcLg9Tl8ZSr1Me4HJjLk8ShgH9afolRzqOI9jw/0cDYKXXz1GNL93Fku1zE+QJzpDpQaj+3ERhJQGWaMWGQf+roM9Z0mHsn0gBMg2+g4yfBMhrokIbSf6Yq++AgKbKE0UThK2BwNhTwDR6X5KXLgZBxADqLHURz6obYPtRdO4lTtdygyKvIeZeX7WyuoTQLM4lb6jB2riG29FQrLfZ7zLxP6PhqLQF7NO0aKe1llH3vDXzfBUaIUo6FKPSstAOrNYufMWZaUUhmyL8j0+fYtzcE5cIKJwOuUDcaxuBTlMbftgmwXNZfoNNu+DDYU7ZrA844u7GLz+cMm+Sd6XBAeMbwffEk9GZeEj7c7RTesKFewGjTfvE8MukBh4tKaWHhLhhj7LcTYPBQgSxsVKyZKPWrsc9k0RnChikwpG9BbnqZ8LNKiSDp5Gp7Y+gFcZ4mHWS9Um4hd00OMwn4HC15hRyxCBOjwQfUvC3OKlydhl+w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(36092001)(8676002)(8936002)(71200400001)(38100700002)(2906002)(5660300002)(9686003)(66446008)(6916009)(64756008)(122000001)(55016002)(33656002)(76116006)(66476007)(52536014)(66556008)(66946007)(186003)(6506007)(83380400001)(316002)(7696005)(54906003)(478600001)(4326008)(26005)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mrZb1x8F7WV1xHkqBep3LbxFgbSXZEgG/B6qAQbb4cGMJAbr4T0CrInEOQ8y?=
 =?us-ascii?Q?8LwgMRPneZMX3fek4dSGQ3hQ2Yce1lBbgyCNyinyzwrQRvic1LttRPA7H51u?=
 =?us-ascii?Q?g9bLOp7bEgRANFe9OdFXByh+QZPKObjFI1pqsuzXowIQwbhrYcGn0tes8dIR?=
 =?us-ascii?Q?o4LrPzkikpYB2CX7wq4E2aZGA+9tyMKGZQTyvO+ZNI1mgZ5Iv1VvAuVzLIgD?=
 =?us-ascii?Q?IbgCpkEmr2rCknUJ3zpJEaBvb79O7jFTyO1mgpqHn4lO0yc2S7P3yXwBMSu7?=
 =?us-ascii?Q?w8VoZLTXVQcrOEXELWCwj4zYF0DOA+5ri7ttzlcppFlfikRogBMirrqgL+Ni?=
 =?us-ascii?Q?7Xv7/J/WMCFqQCOK+RP+dyINRH8E1+jg4KnP26g4iMOpOWzK2hbYvT1Jv53K?=
 =?us-ascii?Q?ZlOHOTBXa8/iY1GbJpY94zK+uMOt2X+1Gxitt9lhzxdsCvlEksIzsfaKCFDI?=
 =?us-ascii?Q?ZTzoDnmxkLWClc9zYCUxuODzGw2yhy1MwhEvfFw5tfjnLo8ZltSqbHrwsc8g?=
 =?us-ascii?Q?znbXGYxIKMOLrbHJPj90hV/7MTWoLFJMNlfC1uzdKPR6qpOOfYP+gGa1q5oO?=
 =?us-ascii?Q?uRuC8h9UsciI0CQb4iCa5bcxP4FnoKeCK4H5G7dsRw3vx5zqBh8S6iaf8k/b?=
 =?us-ascii?Q?1a0ropPwoluo2vLQP3bVI9Sk0JSmneNAwU3yXyZeAm1+YC/Ju/pvOsdBpH10?=
 =?us-ascii?Q?oz7sOmf8iyL1NMYK1uu5t5ychUT0H4scsyt/NnVjbw1jrjCmE4X4z3j2YdO4?=
 =?us-ascii?Q?/AVfifzGO87GK84ior1R59rZN7ZCpFSoXHDgUzFxhogTJuFQVuukgqplDF+Y?=
 =?us-ascii?Q?4IXB3qWxcjen5+ZnkUMr3hBQe5YNkUlKuWsujazw2mQhcY9DtrlfALxQIPJt?=
 =?us-ascii?Q?p3wEZHqLiFELhfVcYIVXvHhNayJy41gmku4YmspgoCXTSF3zcWTlXmXNa/uE?=
 =?us-ascii?Q?MXk0vN4dRH2EWkj4g/49hrsEThBX0lzXCcZBp3oQbl5FXRSqHv0vDA4+nuwG?=
 =?us-ascii?Q?uNt+8FqsD9WUlRo2OeabhNo9J37bcneq5lhU5FcO8cB5XP57HB7BOAPa+tkP?=
 =?us-ascii?Q?p7vJ9wj3DE62Q9wmXn6SWZBIQD21UoM1HbnKXV2lYIi07Iv7u+0+Q28anit7?=
 =?us-ascii?Q?9Zrd5uD1BZbATqHlCau7avBC9JTJaE6UeLdXWhXgAc0EvwyoAsUuLxsAi3ah?=
 =?us-ascii?Q?sPm3ruIO0x4m5SUkHK8yZMkTVeJ5EOvqL7nX/wr1xLwtCik3iHeGgmhp0MQc?=
 =?us-ascii?Q?fSY2t94bPZgJ+wSpmdIpHYHhql6KAsS2kJs+J8Pqm/GpCyQwm+1fbV4sFO7M?=
 =?us-ascii?Q?OsXTG1A8BqwOj3/zhmYHPV2+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd948225-317c-4450-5c2c-08d939e75597
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2021 03:46:38.4618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YzmiFc1aOWTdY1pHX7S+R0BXW27+YG90vijg5yq0QiTsYr9MS0x6V8i3Czd4+saXat3vOde2UrFf5xEtsI0GFMQDiBYa1OxkDhGmZhtK8hA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR07MB8065
X-Proofpoint-ORIG-GUID: fpeW32o4bOcMBMSW1pqIDfYwe1cMykvj
X-Proofpoint-GUID: fpeW32o4bOcMBMSW1pqIDfYwe1cMykvj
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-28_03:2021-06-25,2021-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 adultscore=0
 malwarescore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 mlxlogscore=999
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106280026
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>
>On 21-06-23 09:02:47, Pawel Laszczak wrote:
>> From: Pawel Laszczak <pawell@cadence.com>
>>
>> For delayed status phase, the usb_gadget->state was set
>> to USB_STATE_ADDRESS and it has never been updated to
>> USB_STATE_CONFIGURED.
>> Patch updates the gadget state to correct USB_STATE_CONFIGURED.
>> As a result of this bug the controller was not able to enter to
>> Test Mode while using MSC function.
>
>Pawel, would you please describe more about this issue? I remember the cdn=
s3
>controller at i.mx series SoC could enter test mode by using current
>code.

The issue occurs only for MSC class. MSC class has delayed status stage, so
after returning from cdns3_req_ep0_set_configuration function called=20
for Set Configuration driver remains in USB_STATE_ADDRESS.

In order to enter to test mode driver needs meet the condition included in=
=20
cdns3_ep0_feature_handle_device function:
		if (state !=3D USB_STATE_CONFIGURED || speed > USB_SPEED_HIGH)
			return -EINVAL;

But it is still in USB_STATE_ADDRESS, because there was delayed status stag=
e.
To fix issue driver state must be updated to USB_STATE_CONFIGURED before=20
or after  finishing status stage.

>
>>
>> Cc: <stable@vger.kernel.org>
>> Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
>> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
>> ---
>>  drivers/usb/cdns3/cdns3-ep0.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/usb/cdns3/cdns3-ep0.c b/drivers/usb/cdns3/cdns3-ep0=
.c
>> index 9a17802275d5..ec5bfd8944c3 100644
>> --- a/drivers/usb/cdns3/cdns3-ep0.c
>> +++ b/drivers/usb/cdns3/cdns3-ep0.c
>> @@ -731,6 +731,7 @@ static int cdns3_gadget_ep0_queue(struct usb_ep *ep,
>>  		request->actual =3D 0;
>>  		priv_dev->status_completion_no_call =3D true;
>>  		priv_dev->pending_status_request =3D request;
>> +		usb_gadget_set_state(&priv_dev->gadget, USB_STATE_CONFIGURED);
>>  		spin_unlock_irqrestore(&priv_dev->lock, flags);
>>
>>  		/*
>> --
>> 2.25.1
>>
>
--

Thanks,
Pawel Laszczak

