Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473B9204A25
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 08:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730694AbgFWGqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 02:46:49 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:30610 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730489AbgFWGqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 02:46:48 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05N6iH51010006;
        Mon, 22 Jun 2020 23:46:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=VKVTelWvtKvpt1S7Y0T4lSSnUJBQNHy2FMN/M55pciE=;
 b=bxpj5yJpZtbwFp0csZKfPUBqur2jDbIV0dfCMzSGZ5k3UUYYrM3z0/JFqUYycpXRzCm0
 7meOUyL5P93kjbjrVW1ah9iCw750uaIBi2AauuXFmTtZM57Jw9QJr4W8nZzxSVtQ6j6T
 bJh/mu43kN9k3gbDp9T+S85YcY/U0ymUGBncSD4pJ13d983deJdsquFQ40cau2LmDioP
 GjKGuTMuQSx0bCg9ucKo6E3oYgeTLK5hnNCGrrhnemJKEecE4mYbFMxMaKiCpnTghLzW
 wfXhmFLxW2wfJuBDWBG9kbALCsrl0joWvgNCgJAmzwLvGTi3rnaudU9qEJV7m2J8ntQ3 tA== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by mx0b-0014ca01.pphosted.com with ESMTP id 31tbucna32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 23:46:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VbKyxt96WrBfxOPr7mtUrA2M9mzv2oKXi55EJ0Ce/VoXs5c/4AP9vP/87aPMLN031U+6kfXpxXCGfYhLerPLMwZxhQBVB7ZA8iYrmauUu2TSQQMck7OWYuutqCqMVFBLJZ60ovFJgDathFSovJsawmGxplgWG2f5+n+Aa/12bQqShcS/IFPkp+jNeXQnyQ7Wf3uffkAOdOumymU7zNi9FpTOE7SNS4IAPgoTUpVHwnJePw2xCdAF7itSy3cYwoIXoIsQfB0D8lGzK5fqmBxim8un3v+97T4SdzOurh6S8jXjB0v6XHs7VLp6x7f/j//IEp4azBE4kGZDVpNJJRPrnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VKVTelWvtKvpt1S7Y0T4lSSnUJBQNHy2FMN/M55pciE=;
 b=DWt64nJfyXiP95R7XGWdf5Chi9VoNVHMncUmOCFVTWIHYSk2ZPeoYVsWiYjxuIEztP4IfRbBuBIR+4QwVl64NTdImk7SDkYXaIxDJQi4WxezdtzxdyzDzGMfDXW7yNYJcrjG610FJrRauHt8k9/5qu8n1M/Ky2KLwVcVoHoG2yvV930GfCSfyackXwqTvWDHSjBpHNZgWGjSvht/D2cporg/t2N/3aHOnfdASEy1bEYqDG/dv28psjVIXHaY6V+LKueCo/TiqjaVUWKtBtcfPtr7bDLSwFpNnl8hZiyV1Pr7BStvGybfKNhXY6eZVDq7QajBIZjR/Usw4xV6Vy9z1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VKVTelWvtKvpt1S7Y0T4lSSnUJBQNHy2FMN/M55pciE=;
 b=RGMDBJ0fHf5PjQ+37dWXWEqGpvAdtUaW/E5qcnnt22iyp6CYCJrwIlyZpJUn3pM+G6SAmAMcRDVYpbZBAf+rnXNAOG5JpL5PT6jSYQfIQ24GvBm+915Zw01ZFJuM5BH307RIfkEcizaXioGcTvQemTx9NlwS6PaQfWxtQ/vIB3k=
Received: from DM6PR07MB5529.namprd07.prod.outlook.com (2603:10b6:5:7a::30) by
 DM5PR07MB4037.namprd07.prod.outlook.com (2603:10b6:4:b2::38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3109.22; Tue, 23 Jun 2020 06:46:37 +0000
Received: from DM6PR07MB5529.namprd07.prod.outlook.com
 ([fe80::f447:6767:a746:9699]) by DM6PR07MB5529.namprd07.prod.outlook.com
 ([fe80::f447:6767:a746:9699%7]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 06:46:37 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Peter Chen <peter.chen@nxp.com>,
        "balbi@kernel.org" <balbi@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-imx@nxp.com" <linux-imx@nxp.com>,
        "rogerq@ti.com" <rogerq@ti.com>, "jun.li@nxp.com" <jun.li@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 3/3] usb: cdns3: ep0: add spinlock for
 cdns3_check_new_setup
Thread-Topic: [PATCH 3/3] usb: cdns3: ep0: add spinlock for
 cdns3_check_new_setup
Thread-Index: AQHWSQuwoitcFwvemkuLLh8L3c34jqjlwd5w
Date:   Tue, 23 Jun 2020 06:46:36 +0000
Message-ID: <DM6PR07MB5529B0947299C70C31551838DD940@DM6PR07MB5529.namprd07.prod.outlook.com>
References: <20200623030918.8409-1-peter.chen@nxp.com>
 <20200623030918.8409-4-peter.chen@nxp.com>
In-Reply-To: <20200623030918.8409-4-peter.chen@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctNDcxMDBmYmQtYjUxZC0xMWVhLTg3NjctMWM0ZDcwMWRmYmE0XGFtZS10ZXN0XDQ3MTAwZmJmLWI1MWQtMTFlYS04NzY3LTFjNGQ3MDFkZmJhNGJvZHkudHh0IiBzej0iMTcwMSIgdD0iMTMyMzczNjgzOTQ5MjY1MDkyIiBoPSJ6NHZhTGYwRE1IMlRJbkVGWVdNMzJBZ3MzNlk9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=cadence.com;
x-originating-ip: [185.217.253.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 590fe8b8-94a0-443c-3762-08d817412d1f
x-ms-traffictypediagnostic: DM5PR07MB4037:
x-microsoft-antispam-prvs: <DM5PR07MB403717E6A19A1DC6FF8D5E3FDD940@DM5PR07MB4037.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 04433051BF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HJSlbN7MFuPZMeOlTD1BG9c5ce17gchR9AcBx21wUsEviJP3TfWCUolcSyPETljWy1dkzNCAvOqMp/RIuNKW06iouS89YmvZNKwsRGIRhG/k4FSsEG0q7IlfBQO4PyFuRTkJQSd/tIubxI3hJy+tlEJ7S3lUyU93ItSGb0UlPvVr0+6LzzeVG/pdRVlvDq+HL3wk7P36MnferG6V5/cVSWzuNP1TN8/gXUtcvhOl6QepnzI2a+IE58fN1FqQ0FEKk55jryxAq0GUp7A1Fxwsk/aL6WNOi5mlF2V6GDJo3GMKmJdZbTMIwDF+LGcPzEIO5zXQsxQib3klua1VV/piTeEvlkxjavIV0MiRntPBpsTQCrXytQlOYb3nDTo70OQ6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR07MB5529.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(376002)(366004)(39860400002)(346002)(36092001)(6506007)(9686003)(52536014)(26005)(8936002)(5660300002)(55016002)(8676002)(2906002)(86362001)(76116006)(186003)(66946007)(66556008)(66446008)(66476007)(64756008)(4326008)(71200400001)(83380400001)(54906003)(478600001)(7696005)(110136005)(316002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: LuZAsK61xWsYI1mWS4Q05I8wE4X9Yi14AUSG5TW7egloiRww6B2LYA2u0B6XbgVsSUXIzbTIxDm5OalV8ZOuHo8V9n/u5ZfeZK8vHb+R0UzslpDsJqZftQZIlh1GKU9eK7HWLy9x69P10V0kb/O8iaQnS/5C5n1ATPqv0h0spzAIfNa0TddX2V26ID86r+quvyoxTBKTGyQEcJizzFtTaHVj00nvaTeVaONOqPXD7DkUM1ZT9r2mwaviC86LpUUApEvwz5Apm5+MfihWTvgLoLK+IVqlS+IchXWc6O7fgI1iTaDipIWp0CiTRtBtZHjnsUcmMgORDY/nErK6oIFnaattbTno+MzVcwHZ85CTC/6I0ZXfAlyhPGoS2WQQ+MJv5qmu3FFVd1Jfooh54653xLAYvdfRatdt8rrA6qgheZnVYUZCfdoSvRsvgbrcl3MzQNS2eg2na7gyEWoZQDw32EPrmN8cWK6nLXOskekvvvhU8IppxraxmjdYUb14olZz
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 590fe8b8-94a0-443c-3762-08d817412d1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2020 06:46:36.9399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3yper3rC91nL4KGyCMIm3pGwDNkgdqZOg9smzbngwdOAmPgmG29jMNbsQBiq0fF18bto8C/72FPD3rR7k3cekef9vJ4tw8XOuZrfuFhQdIU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR07MB4037
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_04:2020-06-22,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 cotscore=-2147483648 impostorscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 spamscore=0
 phishscore=0 suspectscore=0 clxscore=1015 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230052
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>
>The other thread may access other endpoints when the cdns3_check_new_setup
>is handling, add spinlock to protect it.
>
>Cc: <stable@vger.kernel.org>
>Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
>Signed-off-by: Peter Chen <peter.chen@nxp.com>

Reviewed-by: Pawel Laszczak <pawell@cadence.com>

>---
> drivers/usb/cdns3/ep0.c | 7 ++++---
> 1 file changed, 4 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/usb/cdns3/ep0.c b/drivers/usb/cdns3/ep0.c
>index 74a1ff5000ba..5aa69980e7ff 100644
>--- a/drivers/usb/cdns3/ep0.c
>+++ b/drivers/usb/cdns3/ep0.c
>@@ -705,15 +705,17 @@ static int cdns3_gadget_ep0_queue(struct usb_ep *ep,
> 	int ret =3D 0;
> 	u8 zlp =3D 0;
>
>+	spin_lock_irqsave(&priv_dev->lock, flags);
> 	trace_cdns3_ep0_queue(priv_dev, request);
>
> 	/* cancel the request if controller receive new SETUP packet. */
>-	if (cdns3_check_new_setup(priv_dev))
>+	if (cdns3_check_new_setup(priv_dev)) {
>+		spin_unlock_irqrestore(&priv_dev->lock, flags);
> 		return -ECONNRESET;
>+	}
>
> 	/* send STATUS stage. Should be called only for SET_CONFIGURATION */
> 	if (priv_dev->ep0_stage =3D=3D CDNS3_STATUS_STAGE) {
>-		spin_lock_irqsave(&priv_dev->lock, flags);
> 		cdns3_select_ep(priv_dev, 0x00);
>
> 		erdy_sent =3D !priv_dev->hw_configured_flag;
>@@ -738,7 +740,6 @@ static int cdns3_gadget_ep0_queue(struct usb_ep *ep,
> 		return 0;
> 	}
>
>-	spin_lock_irqsave(&priv_dev->lock, flags);
> 	if (!list_empty(&priv_ep->pending_req_list)) {
> 		dev_err(priv_dev->dev,
> 			"can't handle multiple requests for ep0\n");
>--
>2.17.1

