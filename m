Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B211DC660
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 15:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391224AbfJRNnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 09:43:07 -0400
Received: from mail-bgr052101131049.outbound.protection.outlook.com ([52.101.131.49]:52356
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388989AbfJRNnH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 09:43:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oARbA+QSjiXojT8gYKf0aNMJPWD2ajQW7MgEOrOhlN2FVvlUXdkXIycwm81DmZclbiTCVqcXJ2lSLHJP/FKxEi5W9EJyAhXq9fp01Y7pFi7GM4wx3moJGQGZuNUdauYMQBOlMtv6d0b6JvwDAgT4t2Z1T0CXFSDpmpNGi3Q1tD93JRSbtV+OkqjGJ3mmyW3/Nx+1gzi+1MCgzrFMp7eA0wK9u/yOKoeh4pHIMM40dQXZb2rM/QKSIN5kps/5aWBM9/nyF+U8+wtMwIrTuZU51FCBRm8jR0VV7lgfK114sXofItNQZaArudycSn6zJs7T0tNt2SLGEoU47Z6emvVoAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fRlzsE18uYv1cEj8xS7NOkZ9K9JavisXyht7yACvM9c=;
 b=oD+BKUsAA9mFPNpRR7EuTVvZSs/4WSMSNLrtoU0Iu2TMr+QZTIGPIMcaP3Dq5nu2zOMR5WBYQBKb+b4UCpcqalFkXuc5LCjw+SuJ9+8DbD3mu6chFgAsGfshWERmKr6jX4l7kr2a7N5NhZMTqM0yjJXUlwLJ4oBqPcSaDM/m6tnEpSXqZ3+S0UfXFGDEevGYSspgeOhM6bsX6r1UnnXWyDhhwziTpQnCaW6XaMadxgBfJo8cjVsgws4/NvOFqJsUgGkaVvrKT/YMkgJjcs++U3OZ5bz9uiRmXAnyPuzGcxm3kGS48WXngtdNYvxJWBlhagp7FAbDW0EmXadABmoSKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uni.strath.ac.uk; dmarc=pass action=none
 header.from=uni.strath.ac.uk; dkim=pass header.d=uni.strath.ac.uk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=strath.onmicrosoft.com; s=selector2-strath-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fRlzsE18uYv1cEj8xS7NOkZ9K9JavisXyht7yACvM9c=;
 b=RWuAzlHr+Bu0PqssNFC9AP0SRRR7d6EyZXmuSkmiH7mIB1fZn72MWwvRtIkpsoYWSO2so+0Fv9ZTeFQOa7A7y3qmu6054de71UbC1o/oLndNXc1rjojQLhiBm68MzgOpHdrDkbf0Cs7ikqk7Aj4252igLAHzNE0acGYNesG17Vo=
Received: from DB6PR0501MB2776.eurprd05.prod.outlook.com (10.172.225.142) by
 DB6PR0501MB2215.eurprd05.prod.outlook.com (10.168.55.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Fri, 18 Oct 2019 13:43:03 +0000
Received: from DB6PR0501MB2776.eurprd05.prod.outlook.com
 ([fe80::24f6:3036:e2a0:bceb]) by DB6PR0501MB2776.eurprd05.prod.outlook.com
 ([fe80::24f6:3036:e2a0:bceb%10]) with mapi id 15.20.2347.024; Fri, 18 Oct
 2019 13:43:03 +0000
From:   <kxb17217@uni.strath.ac.uk>
To:     "Zhen Shen (Student)" <zhen.shen.2017@uni.strath.ac.uk>
Subject: =?iso-8859-1?Q?Herzliche_Gl=FCckw=FCnsche?=
Thread-Topic: =?iso-8859-1?Q?Herzliche_Gl=FCckw=FCnsche?=
Thread-Index: AQHVhbn2Kvot429C0ES/0JIyLY+OVA==
Date:   Fri, 18 Oct 2019 13:43:03 +0000
Message-ID: <DB6PR0501MB27766D106BEEBACAF8FBD63AF16C0@DB6PR0501MB2776.eurprd05.prod.outlook.com>
Reply-To: "googgelwinner90@gmail.com" <googgelwinner90@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR01CA0083.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::24) To DB6PR0501MB2776.eurprd05.prod.outlook.com
 (2603:10a6:4:81::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=zhen.shen.2017@uni.strath.ac.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-antivirus: Avast (VPS 191015-6, 10/16/2019), Outbound message
x-antivirus-status: Clean
x-originating-ip: [185.248.13.41]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b28450b-e69d-4af4-da75-08d753d118c5
x-ms-traffictypediagnostic: DB6PR0501MB2215:
x-microsoft-antispam-prvs: <DB6PR0501MB2215324C5F2A9834DCE47DA2BF6C0@DB6PR0501MB2215.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:136;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(199004)(189003)(2906002)(186003)(7736002)(6636002)(478600001)(6862004)(25786009)(7696005)(305945005)(99286004)(43066004)(2860700004)(66806009)(386003)(52116002)(6506007)(5660300002)(74316002)(102836004)(224303003)(6436002)(256004)(4744005)(486006)(561924002)(71200400001)(22416003)(14454004)(71190400001)(9686003)(81156014)(8936002)(26005)(6116002)(8796002)(316002)(81166006)(66946007)(786003)(55016002)(476003)(7406005)(7276002)(66066001)(7366002)(7336002)(7416002)(52536014)(66556008)(66446008)(66476007)(64756008)(3846002)(33656002)(5003540100004);DIR:OUT;SFP:1501;SCL:1;SRVR:DB6PR0501MB2215;H:DB6PR0501MB2776.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:de;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: uni.strath.ac.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UzNrV4pvdhgB1eBmQG2iAai0nED2Bn3ChQ5tpQBO6LK0UBPAlBUH+Hs3zTNxVenrVz7+zcBWDfmB+ide0g5J/8zaac/JxnTVGEt4LIXBQIb5Qrf3/hTYdYN0tboBk16NeBtQCNOazjKOIHfbjtoDqAvKqZ14mEDlRpOFS1ahol7V4yi4hUkRTuijtZ4sW/vkQgEbsNTiLOEk98SpN/kUePZ8qeGzWFWH57U2Qcts0ut/8wfYJBmzEWenV36XbrfJEiWzylyppGQIYYETm4kVmmBTA7ecHToHWBz8JGhG+YxE8AuA+gSQFkPiS8hQzfBL0ZPSPOLhF3s97Lpjj2M+8zV7rs4ZGM4c5sUrx++xmx4v0oG+IDn06TFkYt2fxlo/sUyc5CKc3FH7Dk/lT+lRu2X8buiyct2xfMpGfZIeayY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <93DF1FCD1832B14F8E8BDF6F6CFE0A8C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: uni.strath.ac.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b28450b-e69d-4af4-da75-08d753d118c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 13:43:03.0431
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 631e0763-1533-47eb-a5cd-0457bee5944e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ar/esrJqpWtGbl6aJNJnRIlOIMl1rg7zd5V/i90CfbKduPBYJcXTaGKQwExzUSLy2ND6iekc66MZT/g64++PDf5uvD6oQq+taJevOuTyVVQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2215
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hallo,

Wir sind hier, um Ihnen mitzuteilen, dass Sie unter den gl=FCcklichen Gewin=
nern ausgew=E4hlt wurden, um als aktiver Nutzer die Summe von =A31.150,000,=
00 GBP bei der k=FCrzlich abgeschlossenen Google Online-Ziehung zu erhalten=
. Bitte f=FCllen Sie die nachstehenden Angaben aus, um weitere Informatione=
n und Anspr=FCche zu erhalten. Ihre Gewinnzahl ist GFP / 955 / GPWIN / US

(1) Ihre Adresse:
(2) Ihr Telefon:
(3) Ihre Nationalit=E4t:
(4) dein vollst=E4ndiger Name:
(5) Beruf:
(6) dein Geschlecht:


Mr. Larry,
Online-Director von Google

Grossbritannien
 +4474188315896, +1(205)287-2163

Wollstrasse 37, D-67547 Worms.
