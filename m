Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB59514DC1D
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 14:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbgA3Njh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 08:39:37 -0500
Received: from mail-eopbgr30099.outbound.protection.outlook.com ([40.107.3.99]:31712
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727327AbgA3Njg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 08:39:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JLtvDW7DqwGLylgFf6Mom+fwga2+BbQfHRv95681+cT8ZQNqysw6l3NWJvamszRFL4aGCpAp/YL5elUKqkPiePj/WLdT3mXevXvn0dRsnAyaULKP54iXGcfXk5e/KMSooVjGDwYcChKD22YXrkZ8ixoAofCXmYTb0TfZVR3iYtMrOs1OgxCXzMIUFNEGQobPY0Zh1i5oBifxrQXmrCtokgF1NyxiCSf3/Q5R8lYiOcIkyABicEFvfYCw5dK2PSkQB8XwVfASBs/NUh4ILrXroThetSy3yFkTPIZgfihMzE0PqUdp5aqs4IsoexWdaVt+Nwq1J27b2LUM24Je5ndj+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fArP8G4/fHYw0FYerB1v4It+B+sG+2HNYHWTRG6oCrU=;
 b=PsUDuvdYMSersM6GUaSs6L5Da7mUlOCGltbiVv0Amqry7jPDOmbsZYOMrbbuO8C9XwR8VerN+s5ApuZggxYa2zj5J0eujgxvHF5bwJ28onldkuOTFsw++h9FelZigVcwdmYtibj7DPHiCLi4cvk6ks9qFlE8AM+BYVrNyolTqA/5v8U7HsjCFZgfhUm+wWb5A/xJleEeJDSHmfbnTiPJsRrNk/Ir/RDtTIG/cim8qOsAXtIp7N6i1IikajLMI8cu77l4uQjM8tYK/GHSJBFLdA2R8j3kPNQ8RD0oWSga7WQAAfMfJ6Ruzd4hdmEKXqH+AY3bw+bOx3gIfD9m6AP0Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fArP8G4/fHYw0FYerB1v4It+B+sG+2HNYHWTRG6oCrU=;
 b=ny+Q8lbEOOCCCV//85Nih8apWQ5oK9W0SzjHa+Fdw1Lpkp/oIwUUU6zd0+7YikfuClu4yhcvc8Q9l6QVIQBzAEzA0crXD0/VDZe37rDyZ5ndDa3DeMqgGAnDb09d5SF9mpSIhZCpMuQcfvRB1sjPbKJ8GGN+QEP3h/4oGghiGb0=
Received: from HE1PR07MB3067.eurprd07.prod.outlook.com (10.170.247.30) by
 HE1PR07MB3307.eurprd07.prod.outlook.com (10.170.246.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.10; Thu, 30 Jan 2020 13:39:34 +0000
Received: from HE1PR07MB3067.eurprd07.prod.outlook.com
 ([fe80::f5cf:6d45:7129:5aa1]) by HE1PR07MB3067.eurprd07.prod.outlook.com
 ([fe80::f5cf:6d45:7129:5aa1%6]) with mapi id 15.20.2707.011; Thu, 30 Jan 2020
 13:39:34 +0000
From:   "Huttunen, Janne (Nokia - FI/Espoo)" <janne.huttunen@nokia.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "peterz@infradead.org" <peterz@infradead.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "Huttunen, Janne (Nokia - FI/Espoo)" <janne.huttunen@nokia.com>
Subject: Please apply f6783319737f ('sched/fair: Fix insertion in
 rq->leaf_cfs_rq_list') to 4.19.y
Thread-Topic: Please apply f6783319737f ('sched/fair: Fix insertion in
 rq->leaf_cfs_rq_list') to 4.19.y
Thread-Index: AQHV13K1O/VzIEWLrUekng6PgM2m+A==
Date:   Thu, 30 Jan 2020 13:39:34 +0000
Message-ID: <d43f6fb40c371f4944a67f416da18248f4705a9e.camel@nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=janne.huttunen@nokia.com; 
x-originating-ip: [131.228.2.3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 271eb7ce-6083-40db-b68d-08d7a589d7bd
x-ms-traffictypediagnostic: HE1PR07MB3307:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR07MB33077705DE20D4CF5E5479849A040@HE1PR07MB3307.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 02981BE340
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(189003)(199004)(5660300002)(26005)(36756003)(2906002)(66556008)(66476007)(66946007)(76116006)(558084003)(186003)(6506007)(71200400001)(6486002)(6512007)(64756008)(54906003)(2616005)(8936002)(107886003)(316002)(66446008)(478600001)(8676002)(81156014)(86362001)(81166006)(4326008)(6916009)(99106002);DIR:OUT;SFP:1102;SCL:1;SRVR:HE1PR07MB3307;H:HE1PR07MB3067.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WP4DNyILcDArJ0qJI3/2/B4EsJpwwYsYK33/2QW05ypXwmgQ0CMDbQY9+jQisTBD78vfKzUJQzPhLitSH2uLcuvJMG0JTuqj2UwMMlo6Pw3KGayeWPNA8qLc9kT4J8ld5NioYRyprnejidfDBEaqhwtNsLlwFre+n8IZVLs0qiv/cIx2hP97bM3AGDt89I5UvmtVBUFcby/O+IVKjzO5x9aMGajjnVUNyF6kDHI2zdQS69ddNcDlu2zjOep6OI3CwhQFiFXTUVzC8ft1p8XuAHFOf24nTyOgSB7vbyaiCfVdgy5L6o5itoUGe0EhraKsZo/ZF38WzDmRhiKl1VGGIRxfOoFlYdzpJT8xrCaEqsL/aY0XyciFtaTrazjkc7ET8TfPFiOwyJzSnTFEcQ2x6VMGmqfWMsd/Gkru+6szzxUrkcB/kUJevM0FuKASCcWV3yIGqf4WZRD9B52FEgjCBZWviOIO6TDLf6SPSYMETlgGZ/w6Wtd4X4e3TDoZo6iY
x-ms-exchange-antispam-messagedata: ynh/9DI6mGZmqD/eVltnjDwJfBlx3CiIAGkbI1iMCa34r56BkKLYiFcPRlVnhQKErbqth+djabhv25niXPudDwA8YVs86ckzWh7kU9bjMfxuU9m3xoWGst8Z1kZySp4VIrEIjA04flsaWFE3OwoJxQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <B2112D7147B9E344A109835E718636F2@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 271eb7ce-6083-40db-b68d-08d7a589d7bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2020 13:39:34.2972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aMbsGP/bD/Ha4NDQy0oD7lcn76QR5QdK3qrppPTat7vCzvJ5SoOhPZwS8FbtJMc+iDvA0n6K8U2eFxhrqaqZdNG+R9A+b9yXcrpoy/2cNaY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR07MB3307
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQpUaGUgZjY3ODMzMTk3MzdmIGFwcGVhcnMgdG8gZml4IGEgcmVwcm9kdWNpYmxlIGNyYXNoIHRo
YXQgd2UgaGF2ZQ0KYmVlbiBleHBlcmllbmNpbmcgd2hpbGUgc3RyZXNzLXRlc3RpbmcgY3JlYXRp
b24gYW5kIGRlbGV0aW9uIG9mDQpjb250YWluZXJzLg0KDQpUaGUgZml4IHNlZW1zIHRvIGFwcGx5
IHRvIDQuMTkueSBtb3JlIGVhc2lseSBpZiB5b3UgZmlyc3QgYXBwbHkNCmFsc28gNWQyOTllYWJl
YTVhICgnc2NoZWQvZmFpcjogQWRkIHRtcF9hbG9uZV9icmFuY2ggYXNzZXJ0aW9uJykuDQoNCg0K
