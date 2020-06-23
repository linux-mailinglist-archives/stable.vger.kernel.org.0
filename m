Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663F5204A1E
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 08:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730776AbgFWGpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 02:45:51 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:27342 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730635AbgFWGpu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 02:45:50 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05N6gS3K006627;
        Mon, 22 Jun 2020 23:45:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=f/XR0H3+QLR5jc7BvWIXhmurvlXZGfrA26HOdMcCz44=;
 b=bAYpjXFHlEt9eqPxjPMDNjoKnIGNrg0awewLKsFSqbjKvk097XLbvlg7YiKD9vvaUwLM
 ufkvw5DPiSmAgmtZattfSlZ+Fo7qsapd9/2dmKdaGD/Tq/BqMnwoCJulUNbyflcU5nC3
 EEJNBMq8hscROmRoCFpNHoPspyxRu8OeZkgjgGgV09JDJEkk9pHMHs8C5aL1VA4BUl60
 WE706S/MX72y/kCs1bZ5qklc/0PsIu6JbJFCjtWMhp1iCD8+X8Pz5f08H5DsYbd4q+A6
 z0VvW1rYOBQk9CJ77e+ot2ohC3hhElyH/jxN3NxJswUK92ErFBMYIXUScTouf4Nj/pZh zA== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by mx0a-0014ca01.pphosted.com with ESMTP id 31sf0y8ayd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 23:45:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OSHFdqVonFVZGBKcCCR+NWF5/VbAesEvGsF2zdht4rUGVEXREucbVs5Nt2NRCFZv0ezI1tC2l6dLTzGf9ZFtCIz+OfNCEenvpRLvUYIJyWTg0QHTSmebOiTIzBPLgkoR4Y5wLVLslouicGMLR1FGWLJUPhpbeTzl4P0KsTCErCJAPiNvp48sN9QFs6jPIdwvs3sz1i5yqCeGl6u4M6Wp2ufeqq5KE9RTti77eOnvhOHfciFB1ohc+7ljufw9wHjKruLxrBvRURliRaxxnQA7Gd4wZbkffY9+0ns4QGFNkL4GNMEfcCvVuxaiWDTxiVGMdpFO5zbduRYq1o3RSUwEZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/XR0H3+QLR5jc7BvWIXhmurvlXZGfrA26HOdMcCz44=;
 b=hr+clXvG2eR+ARHpME9sT/5FsayPpPHiIq5gdi4bUkRVbXvs/LRu9aMAgamf5CNpUmjdD8vG5aaHJaYDSbv58btsth3w2bmALMc/NCdc+GKvOdnb8AoBqvIU1Ehq8/2BV4nBG6WGFCJJbboWnTXIAitWRGt6qtWmYak7lJMZI6fxq4ZPawEqlmGhV9GKEEmQZnMjJ6DkpHmh1rafdLhnrPO842bIpxifAvT40xKPVvGqONU+A7ezBAY5jIWU4zDqYa72swUjtOgfNfHGU8+hKeXIixzwpLPbBXXd9A/m6IVIXP5jcmmzbw+9UCJIpm4EzXrff3dtyozu7T7lkGvLEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/XR0H3+QLR5jc7BvWIXhmurvlXZGfrA26HOdMcCz44=;
 b=kqkjZtn72zyTkgKDqTkYXMQ/X8eWdv2SXUXSKXLgwNSXiKqvglLJBceYiWUad9W90xIVFLsYTzwI8IGFhe+R+iWuRE652A1m+y+IpTv3TJxdm6Nn7WOTD7s/uR1qyhkAlsZgQueSX8O4MHtqVamcEA/PMvPlh+eYIxytLZOWEIE=
Received: from DM6PR07MB5529.namprd07.prod.outlook.com (2603:10b6:5:7a::30) by
 DM5PR07MB4037.namprd07.prod.outlook.com (2603:10b6:4:b2::38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3109.22; Tue, 23 Jun 2020 06:45:38 +0000
Received: from DM6PR07MB5529.namprd07.prod.outlook.com
 ([fe80::f447:6767:a746:9699]) by DM6PR07MB5529.namprd07.prod.outlook.com
 ([fe80::f447:6767:a746:9699%7]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 06:45:38 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Peter Chen <peter.chen@nxp.com>,
        "balbi@kernel.org" <balbi@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-imx@nxp.com" <linux-imx@nxp.com>,
        "rogerq@ti.com" <rogerq@ti.com>, "jun.li@nxp.com" <jun.li@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/3] usb: cdns3: ep0: fix the test mode set incorrectly
Thread-Topic: [PATCH 1/3] usb: cdns3: ep0: fix the test mode set incorrectly
Thread-Index: AQHWSQus3TAr3rsOJEqrbqQsH2/av6jlwJnA
Date:   Tue, 23 Jun 2020 06:45:38 +0000
Message-ID: <DM6PR07MB55299792641156038575FC4DDD940@DM6PR07MB5529.namprd07.prod.outlook.com>
References: <20200623030918.8409-1-peter.chen@nxp.com>
 <20200623030918.8409-2-peter.chen@nxp.com>
In-Reply-To: <20200623030918.8409-2-peter.chen@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctMjM2ZjI4YzctYjUxZC0xMWVhLTg3NjctMWM0ZDcwMWRmYmE0XGFtZS10ZXN0XDIzNmYyOGM5LWI1MWQtMTFlYS04NzY3LTFjNGQ3MDFkZmJhNGJvZHkudHh0IiBzej0iMTA1OSIgdD0iMTMyMzczNjgzMzUxNTQ3MjQxIiBoPSJhT0V5V2tUbDlXNDJlZWFZMHBPL3NYeGZYV2M9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=cadence.com;
x-originating-ip: [185.217.253.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9575269c-e127-469a-6f8f-08d817410a23
x-ms-traffictypediagnostic: DM5PR07MB4037:
x-microsoft-antispam-prvs: <DM5PR07MB4037A87207BA86A974146A2ADD940@DM5PR07MB4037.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 04433051BF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0JgGnQHCXX4YeWOhlsTjNPevg6DeAQGtUqmNGBWI/cAro3domGclonPprrdX0/8t5ZQKOGwNupsKQrDmnDGWagGsO1VBTE1KmKFY7A1l3C4nd4Wpztmc492eSzX4vXHSscroGqPqj0IhZ5M/Y6zuqoEKg/cq9nzF51/vzMVmG+8wwKJQ8JtDsxLVcj9pL6+QvyTFOwJ4H4gxKrfwBN33M8vV0sFqZp1V6ebfOOYKPTHBbV0EqDH2JcqQKY2AOJq+1vhFxthqXp2vPiYuP/s7sHhucSnnodoUv5+OCC3EzkE+okAgGC+shk5igbXrktekKAz4/ls3nvtYqYI49ndSXwSzRXpC00+H2zPeDaj4jN8hvD792ZVm6JEXdNKp8JHk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR07MB5529.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(376002)(366004)(39860400002)(346002)(36092001)(6506007)(9686003)(52536014)(26005)(4744005)(8936002)(5660300002)(55016002)(8676002)(2906002)(86362001)(76116006)(186003)(66946007)(66556008)(66446008)(66476007)(64756008)(4326008)(71200400001)(83380400001)(54906003)(478600001)(7696005)(110136005)(316002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: zlJ/nSvHAKaQIQzPs5UGNbPaZkdjJxPqJLojUlQvUPWaNp2FAWimgvcXSXVMG0rpvMj/Ydx9JA6oaud6J7cpLry+BCvCu5YH132iSRdrlRrCnTb5Px4GXUwKdi6O3C3Nz8wETjOoY8dTBD+F8XxNqbwOD6IbU75IeBaWS3EnxNo6m5cteDpY62P793ipPCsWFXYZEsG/+f0EDy4yJTGaA3s45h3woRV2JeoIGpPYkSZCAhNE0Rybr2a82Vg6XoOGenKvnjW5IIuSXK4jDZ4jGzC4YAl9V4pRm9loUB4i+pLeva4arnRjql7Y9hdTush2pbwA6jCibVg1JwUl/pX5rwHe/SOh0rFJFNHw9KMy66f57w3et/hkqJ0wTweSglhI9mCvZoM2k1C7kXb0HH2LiqdyIi7SAGvkq/UhILwEDRfsEe+8joe6g8gOoNRIxkcbe1Xv8d2ns7OBbZY43oWXSrlT5OQX2iJSm1uF84sPyJ7JFNG1G5A5SqMf0UiAyzI2
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9575269c-e127-469a-6f8f-08d817410a23
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2020 06:45:38.2972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NWhY+8cA7USdoIIfd7t7be6eZ+5EXZHfzDXOi6tLdVw6COy0AZoDxtWPR6eGxTQF1Aebl6jkI8yymt28sWxNYTbKIFBj4Ix5JL9mvGTOqVc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR07MB4037
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_04:2020-06-22,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 adultscore=0
 spamscore=0 phishscore=0 impostorscore=0 clxscore=1011
 cotscore=-2147483648 suspectscore=0 malwarescore=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 priorityscore=1501 mlxlogscore=800 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230052
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Reviewed-by: Pawel Laszczak <pawell@cadence.com>
>
>
>The 'tmode' is ctrl->wIndex, changing it as the real test
>mode value for register assignment.
>
>Cc: <stable@vger.kernel.org>
>Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
>Reviewed-by: Jun Li <jun.li@nxp.com>
>Signed-off-by: Peter Chen <peter.chen@nxp.com>
>---
> drivers/usb/cdns3/ep0.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/usb/cdns3/ep0.c b/drivers/usb/cdns3/ep0.c
>index 2465a84e8fee..74a1ff5000ba 100644
>--- a/drivers/usb/cdns3/ep0.c
>+++ b/drivers/usb/cdns3/ep0.c
>@@ -327,7 +327,8 @@ static int cdns3_ep0_feature_handle_device(struct cdns=
3_device *priv_dev,
> 		if (!set || (tmode & 0xff) !=3D 0)
> 			return -EINVAL;
>
>-		switch (tmode >> 8) {
>+		tmode >>=3D 8;
>+		switch (tmode) {

For me it's looks the same, but it's ok.=20

> 		case TEST_J:
> 		case TEST_K:
> 		case TEST_SE0_NAK:
>--
>2.17.1

