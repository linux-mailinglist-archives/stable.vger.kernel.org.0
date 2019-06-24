Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB4751B07
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 20:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbfFXSzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 14:55:24 -0400
Received: from mail-eopbgr740113.outbound.protection.outlook.com ([40.107.74.113]:58096
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729473AbfFXSzY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 14:55:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Sony.onmicrosoft.com;
 s=selector1-Sony-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DyvZ8Wt8o35zgdEk71VUOTjGxiOnzAczs/3SOfNVeLA=;
 b=GUVQbp82+yyXSdMr0gi3+6QrSeUy/vVqTWynXndIV5K0bXXyKUAGnexYkvkVTpvjhWofBhtah0sclIV98OT1JNfotbk+aSmJX8EWnd5+CZElkurPjR9WQJEMJLUCblXrdhsWQFulh0FEoGFQAl46nTpuhg7tvJDN1JNAtOLE1eo=
Received: from MN2PR13CA0011.namprd13.prod.outlook.com (2603:10b6:208:160::24)
 by BN7PR13MB2243.namprd13.prod.outlook.com (2603:10b6:406:b6::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2032.9; Mon, 24 Jun
 2019 18:55:22 +0000
Received: from CY1NAM02FT063.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::207) by MN2PR13CA0011.outlook.office365.com
 (2603:10b6:208:160::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2032.11 via Frontend
 Transport; Mon, 24 Jun 2019 18:55:22 +0000
Authentication-Results: spf=permerror (sender IP is 160.33.194.228)
 smtp.mailfrom=sony.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=sony.com;
Received-SPF: PermError (protection.outlook.com: domain of sony.com used an
 invalid SPF mechanism)
Received: from usculsndmail01v.am.sony.com (160.33.194.228) by
 CY1NAM02FT063.mail.protection.outlook.com (10.152.75.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1987.11 via Frontend Transport; Mon, 24 Jun 2019 18:55:21 +0000
Received: from usculsndmail13v.am.sony.com (usculsndmail13v.am.sony.com [146.215.230.104])
        by usculsndmail01v.am.sony.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id x5OItJxK008136;
        Mon, 24 Jun 2019 18:55:19 GMT
Received: from USCULXHUB05V.am.sony.com (hub.bc.in.sel.sony.com [146.215.231.43])
        by usculsndmail13v.am.sony.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id x5OItIWI000453;
        Mon, 24 Jun 2019 18:55:19 GMT
Received: from USCULXMSG01.am.sony.com ([fe80::b09d:6cb6:665e:d1b5]) by
 USCULXHUB05V.am.sony.com ([146.215.231.43]) with mapi id 14.03.0439.000; Mon,
 24 Jun 2019 14:55:18 -0400
From:   <Tim.Bird@sony.com>
To:     <vkabatov@redhat.com>, <guillaume.tucker@gmail.com>
CC:     <kernelci@groups.io>, <automated-testing@yoctoproject.org>,
        <info@kernelci.org>, <syzkaller@googlegroups.com>,
        <lkp@lists.01.org>, <stable@vger.kernel.org>, <labbott@redhat.com>,
        <eslobodo@redhat.com>, <cki-project@redhat.com>
Subject: RE: CKI hackfest @Plumbers invite
Thread-Topic: CKI hackfest @Plumbers invite
Thread-Index: AQHVJ37SWv4qmkd5dESo8sS6Z+b53aak+c4AgAYyvSA=
Date:   Mon, 24 Jun 2019 18:55:12 +0000
Message-ID: <ECADFF3FD767C149AD96A924E7EA6EAF977399CD@USCULXMSG01.am.sony.com>
References: <1204558561.21265703.1558449611621.JavaMail.zimbra@redhat.com>
 <1667759567.21267950.1558450452057.JavaMail.zimbra@redhat.com>
 <CAH1_8nAx-1+uqOwAOCfGbqdWzgWD1-oikAfoVBqw4qPcu8v4fw@mail.gmail.com>
 <1759213455.26229412.1561047112464.JavaMail.zimbra@redhat.com>
In-Reply-To: <1759213455.26229412.1561047112464.JavaMail.zimbra@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [146.215.228.6]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:160.33.194.228;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(39860400002)(346002)(136003)(396003)(376002)(2980300002)(448002)(13464003)(199004)(189003)(426003)(246002)(14444005)(486006)(70206006)(26005)(102836004)(436003)(186003)(55846006)(76176011)(4744005)(7696005)(70586007)(37786003)(476003)(2486003)(23676004)(11346002)(126002)(446003)(4326008)(33656002)(316002)(7736002)(356004)(53546011)(336012)(110136005)(50466002)(6666004)(55016002)(54906003)(5660300002)(229853002)(86362001)(6246003)(72206003)(66066001)(47776003)(2876002)(2906002)(8676002)(305945005)(6116002)(8936002)(3846002)(478600001)(7416002)(5001870100001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN7PR13MB2243;H:usculsndmail01v.am.sony.com;FPR:;SPF:PermError;LANG:en;PTR:mail.sonyusa.com,mail01.sonyusa.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1454419-0867-4073-064a-08d6f8d58275
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BN7PR13MB2243;
X-MS-TrafficTypeDiagnostic: BN7PR13MB2243:
X-Microsoft-Antispam-PRVS: <BN7PR13MB22438D9473BE2EEEF8A92D2AFDE00@BN7PR13MB2243.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 007814487B
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: vI60t5fXbt9uz+uCqVbG9MmP3/PgGK0u6+earQ8NovAWVsIBPqx+jgbJZEun5FODrwGY+R3kRqHrq2QJVmcD83cHs2ksMLbJFG/evFm0yzNoutrZfwcDugPjpS1QSt8PnnoCQ4B1A5ogXwzA0QvnIKni16OeniNZdyr4X526JGwTYdRnFasUkC6XDrXXmBAmbev6J1YkXuWOeC3P8KulNdIZTkV1YXU/YO38Y15Y0u51zBhEop01nStQkfVg090HnrNwmZT6RZwqhp/21BkAuFbXH4Q++i3JtBo5/6r38t3j5TKml13R8gwp/1ro+7dvGskHjCHrQBAExuTct9fO0xBRVzh7UUIm4m6k2FtaJ7jCN8Yu/zYJcGjv+Ygonzutk49PTQ8mF0V8xIM0EkPzKXQ8F5Zq4fikADAji1anUFE=
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2019 18:55:21.1676
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1454419-0867-4073-064a-08d6f8d58275
X-MS-Exchange-CrossTenant-Id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=66c65d8a-9158-4521-a2d8-664963db48e4;Ip=[160.33.194.228];Helo=[usculsndmail01v.am.sony.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR13MB2243
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBWZXJvbmlrYSBLYWJhdG92YSAN
Cj4gDQo+IC0tLS0tIE9yaWdpbmFsIE1lc3NhZ2UgLS0tLS0NCj4gPiBGcm9tOiAiR3VpbGxhdW1l
IFR1Y2tlciIgDQo+ID4NCj4gPiBIaSBWZXJvbmlrYSwNCj4gPg0KPiA+IE9uIFR1ZSwgTWF5IDIx
LCAyMDE5IGF0IDM6NTUgUE0gVmVyb25pa2EgS2FiYXRvdmENCj4gPHZrYWJhdG92QHJlZGhhdC5j
b20+DQo+ID4gd3JvdGU6DQo+ID4NCj4gDQo+IEkgYWdyZWUgdGhhdCB0aGlzIHRvcGljIGlzIGlt
cG9ydGFudCAoYW5kIEkgYmVsaWV2ZSBzb21lIG90aGVyIENLSSBwZW9wbGUNCj4gbWFkZSB0aGF0
IGNsZWFyIGFzIHdlbGwpIHNvIEkgYWRkZWQgaXQgdG8gdGhlIGFnZW5kYSB0b3BpY3MuIFRoZSBs
aXN0IG9mDQo+IHRob3NlIGlzIGdldHRpbmcgbG9uZyBzbyB3ZSdkIGRlZmluaXRlbHkgbmVlZCB0
byBjdXJhdGUgaXQgcHJvcGVybHkgc29vbg0KPiBidXQgSSdsbCBtYWtlIHN1cmUgdGhpcyBzdGF5
cyB0aGVyZS4NCg0KSSBhZ3JlZSB0aGF0IEd1aWxsYXVtZSdzIHRvcGljIHdvdWxkIGJlIGdvb2Qg
dG8gZGlzY3Vzcy4NCg0KSXMgdGhlIGRyYWZ0IGFnZW5kYSBvbmxpbmUgYW55d2hlcmU/DQogLS0g
VGltDQoNCg==
