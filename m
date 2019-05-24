Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41B7929FAA
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 22:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404095AbfEXURW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 16:17:22 -0400
Received: from mail-eopbgr740101.outbound.protection.outlook.com ([40.107.74.101]:38992
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404089AbfEXURW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 May 2019 16:17:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Sony.onmicrosoft.com;
 s=selector1-Sony-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+EipEKuBss7Jp5D7IWixf0tfcV8nnz1hwJfTZxiYYqY=;
 b=dVl5P/1W86MYLbQRgWacJHmFmOKwwWdvzIYppFH4ZHydQqzWlB6QCqWyNnE8Wls0zdckWGStaBuBe5mxkGufqPIUhlU1tgvFugYNhKSRk0aH80mqdFhuohJsZJz87Bp8HLbZ1A/lDYuRu6hDSwqV6ys9vqUdehRyYfzAXjq1m3M=
Received: from BY5PR13CA0028.namprd13.prod.outlook.com (2603:10b6:a03:180::41)
 by DM6PR13MB2250.namprd13.prod.outlook.com (2603:10b6:5:c9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1922.10; Fri, 24 May
 2019 20:17:17 +0000
Received: from CY1NAM02FT035.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::205) by BY5PR13CA0028.outlook.office365.com
 (2603:10b6:a03:180::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1943.8 via Frontend
 Transport; Fri, 24 May 2019 20:17:17 +0000
Authentication-Results: spf=permerror (sender IP is 160.33.194.228)
 smtp.mailfrom=sony.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=sony.com;
Received-SPF: PermError (protection.outlook.com: domain of sony.com used an
 invalid SPF mechanism)
Received: from usculsndmail01v.am.sony.com (160.33.194.228) by
 CY1NAM02FT035.mail.protection.outlook.com (10.152.75.186) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1922.16 via Frontend Transport; Fri, 24 May 2019 20:17:16 +0000
Received: from usculsndmail13v.am.sony.com (usculsndmail13v.am.sony.com [146.215.230.104])
        by usculsndmail01v.am.sony.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id x4OKHF0b020684;
        Fri, 24 May 2019 20:17:15 GMT
Received: from USCULXHUB02V.am.sony.com (hub.cul.am.sony.com [146.215.231.16])
        by usculsndmail13v.am.sony.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id x4OKHEuS000748;
        Fri, 24 May 2019 20:17:14 GMT
Received: from USCULXMSG01.am.sony.com ([fe80::b09d:6cb6:665e:d1b5]) by
 USCULXHUB02V.am.sony.com ([146.215.231.16]) with mapi id 14.03.0439.000; Fri,
 24 May 2019 16:17:14 -0400
From:   <Tim.Bird@sony.com>
To:     <vkabatov@redhat.com>, <automated-testing@yoctoproject.org>,
        <info@kernelci.org>, <khilamn@baylibre.org>,
        <syzkaller@googlegroups.com>, <lkp@lists.01.org>,
        <stable@vger.kernel.org>, <labbott@redhat.com>
CC:     <eslobodo@redhat.com>, <cki-project@redhat.com>
Subject: RE: CKI hackfest @Plumbers invite
Thread-Topic: CKI hackfest @Plumbers invite
Thread-Index: AdUSbaN1oGVEoc2FRCGELn9GsI4Q0w==
Date:   Fri, 24 May 2019 20:17:04 +0000
Message-ID: <ECADFF3FD767C149AD96A924E7EA6EAF9772760D@USCULXMSG01.am.sony.com>
References: <1204558561.21265703.1558449611621.JavaMail.zimbra@redhat.com>
 <1667759567.21267950.1558450452057.JavaMail.zimbra@redhat.com>
In-Reply-To: <1667759567.21267950.1558450452057.JavaMail.zimbra@redhat.com>
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
X-Forefront-Antispam-Report: CIP:160.33.194.228;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(136003)(346002)(396003)(39860400002)(376002)(2980300002)(448002)(199004)(189003)(13464003)(2486003)(186003)(23676004)(426003)(436003)(37786003)(66066001)(446003)(966005)(85326001)(86362001)(8936002)(2906002)(14444005)(5660300002)(50466002)(7696005)(26005)(76176011)(356004)(2201001)(6666004)(102836004)(7736002)(7416002)(305945005)(6116002)(316002)(2876002)(54906003)(33656002)(55846006)(246002)(70206006)(110136005)(70586007)(336012)(4326008)(6306002)(476003)(8676002)(55016002)(72206003)(6246003)(229853002)(478600001)(1250700005)(486006)(3846002)(86152003)(47776003)(126002)(11346002)(5001870100001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR13MB2250;H:usculsndmail01v.am.sony.com;FPR:;SPF:PermError;LANG:en;PTR:mail01.sonyusa.com,mail.sonyusa.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53a25f3a-ecbb-4574-88cd-08d6e084d14f
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DM6PR13MB2250;
X-MS-TrafficTypeDiagnostic: DM6PR13MB2250:
X-MS-Exchange-PUrlCount: 1
X-Microsoft-Antispam-PRVS: <DM6PR13MB2250810D5D2D6C06D2B7CF8EFD020@DM6PR13MB2250.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0047BC5ADE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: RT/U1CptrKjQqv1V70vTK6uyquLkppzDb7TzeXFOn7DNcc4feyB+Poh4/g7H4+QZwC8g7Dbp7W1Pp54bYej5MC5aD0YdTVhAiqEWqFJbO8RCrfv2gEwwu3ZY7rmOvjMMsQSN8Y9S+ob6cDhFkDyO3L3nXRLi+tOYeQv7n4yKzPZ96t8LhkEZP2b+SlYT6NOGRLUDgsZiMOZxuL/eIOdFWqrKXe09gAmw7RtQfl5FEUOrg5XiP4c+aod1KNtynwrE5ZHHWiDeFvROqy0+YXLoYI1RaqFafkX6e4D5rk6Llrm0TQ7jrNuLHbNWmJoBTSJO3FDmCZ8hQ+C0Ai4VksUM8Yqozqc4yutuZhuzFfPgJpBLsVUvg1j/Y7zxvJDR1ZYGDotuQxpOw8KR7QNVOsxQZkH8pSkjLasfWIWAe3BBCAk=
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2019 20:17:16.4904
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53a25f3a-ecbb-4574-88cd-08d6e084d14f
X-MS-Exchange-CrossTenant-Id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=66c65d8a-9158-4521-a2d8-664963db48e4;Ip=[160.33.194.228];Helo=[usculsndmail01v.am.sony.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB2250
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVmVyb25pa2EgS2FiYXRv
dmEgDQo+IA0KPiBIaSwNCj4gDQo+IGFzIHNvbWUgb2YgeW91IGhhdmUgaGVhcmQsIENLSSBQcm9q
ZWN0IGlzIHBsYW5uaW5nIGhhY2tmZXN0IENJIG1lZXRpbmdzIGFmdGVyDQo+IFBsdW1iZXJzIGNv
bmZlcmVuY2UgdGhpcyB5ZWFyIChTZXB0LiAxMi0xMykuIFdlIHdvdWxkIGxpa2UgdG8gaW52aXRl
DQo+IGV2ZXJ5b25lDQo+IHdobyBoYXMgaW50ZXJlc3QgaW4gQ0kgZm9yIGtlcm5lbCB0byBjb21l
IGFuZCBqb2luIHVzLg0KPiANCj4gVGhlIGVhcmx5IGFnZW5kYSB3aXRoIHN1bW1hcnkgaXMgYXQg
dGhlIGVuZCBvZiB0aGUgZW1haWwuIElmIHlvdSB0aGluayB0aGVyZSdzDQo+IHNvbWV0aGluZyBp
bXBvcnRhbnQgbWlzc2luZyBsZXQgdXMga25vdyEgQWxzbyBsZXQgdXMga25vdyBpbiBjYXNlIHlv
dSdkDQo+IHdhbnQgdG8NCj4gbGVhZCBhbnkgb2YgdGhlIHNlc3Npb25zLCB3ZSdkIGJlIGhhcHB5
IHRvIGRlbGVnYXRlIG91dCBzb21lIHdvcmsgOikNCj4gDQo+IA0KPiBQbGVhc2Ugc2VuZCB1cyBh
biBlbWFpbCBhcyBzb29uIGFzIHlvdSBkZWNpZGUgdG8gY29tZSBhbmQgZmVlbCBmcmVlIHRvIGlu
dml0ZQ0KPiBvdGhlciBwZW9wbGUgd2hvIHNob3VsZCBiZSBwcmVzZW50LiBXZSBhcmUgbm90IHBs
YW5uaW5nIHRvIGNhcCB0aGUNCj4gYXR0ZW5kYW5jZQ0KPiByaWdodCBub3cgYnV0IG5lZWQgdG8g
c29sdmUgdGhlIGxvZ2lzdGljcyBiYXNlZCBvbiB0aGUgaW50ZXJlc3QuIFRoZSBldmVudCBpcw0K
PiBmcmVlIHRvIGF0dGVuZCwgbm8gYWRkaXRpb25hbCByZWdpc3RyYXRpb24gZXhjZXB0IGxldHRp
bmcgdXMga25vdyBpcyBuZWVkZWQuDQo+IA0KPiBGZWVsIGZyZWUgdG8gY29udGFjdCB1cyBpZiB5
b3UgaGF2ZSBhbnkgcXVlc3Rpb25zLA0KDQpJIHBsYW4gdG8gY29tZSB0byB0aGUgZXZlbnQuDQoN
Cj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0NCj4gSGVyZSBpcyBhbiBlYXJseSBhZ2VuZGEgd2UgcHV0IHRvZ2V0aGVyOg0KPiAtIElu
dHJvZHVjdGlvbnMNCj4gLSBDb21tb24gcGxhY2UgZm9yIHVwc3RyZWFtIHJlc3VsdHMsIHJlc3Vs
dCBwdWJsaXNoaW5nIGluIGdlbmVyYWwNCj4gICAtIFRoZSBkaXNjdXNzaW9uIG9uIHRoZSBtYWls
aW5nIGxpc3QgaXMgZ29pbmcgc3Ryb25nIHNvIHdlIG1pZ2h0IGJlIGFibGUgdG8NCj4gICAgIHN1
YnN0aXR1dGUgdGhpcyBzZXNzaW9uIGZvciBhIGRpZmZlcmVudCBvbmUgaW4gY2FzZSBldmVyeXRo
aW5nIGlzIHNvbHZlZCBieQ0KPiAgICAgU2VwdGVtYmVyLg0KPiAtIFRlc3QgcmVzdWx0IGludGVy
cHJldGF0aW9uIGFuZCBidWcgZGV0ZWN0aW9uDQo+ICAgLSBIb3cgdG8gYXV0b2RldGVjdCBpbmZy
YXN0cnVjdHVyZSBmYWlsdXJlcywgcmVncmVzc2lvbnMvbmV3IGJ1Z3MgYW5kIHRlc3QNCj4gICAg
IGJ1Z3M/IEhvdyB0byBoYW5kbGUgY29udGludW91cyBmYWlsdXJlcyBkdWUgdG8ga25vd24gYnVn
cyBpbiBib3RoIHRlc3RzDQo+IGFuZA0KPiAgICAga2VybmVsPyBXaGF0J3MgeW91ciBzb2x1dGlv
bj8gQ2FuIHBlb3BsZSBhbHdheXMgdHJ1c3QgdGhlIHJlc3VsdHMgdGhleQ0KPiAgICAgcmVjZWl2
ZT8NCj4gLSBHZXR0aW5nIHJlc3VsdHMgdG8gZGV2ZWxvcGVycy9tYWludGFpbmVycw0KPiAgIC0g
QWltZWQgYXQga2VybmVsIGRldmVsb3BlcnMgYW5kIG1haW50YWluZXJzLCBzaGFyZSB5b3VyIGZl
ZWRiYWNrIGFuZA0KPiAgICAgZXhwZWN0YXRpb25zLg0KPiAgIC0gSG93IG11Y2ggZGF0YSBzaG91
bGQgYmUgc2VudCBpbiB0aGUgaW5pdGlhbCBjb21tdW5pY2F0aW9uIHZzLiBhIGNsaWNrIGF3YXkN
Cj4gICAgIGluIGEgZGFzaGJvYXJkPyBEbyB5b3Ugd2FudCBpbmNyZW1lbnRhbCBlbWFpbHMgd2l0
aCBuZXcgcmVzdWx0cyBhcyB0aGV5DQo+IGNvbWUNCj4gICAgIGluPw0KPiAgIC0gV2hhdCBhYm91
dCBhZGRpbmcgY2hlY2tzIHRvIHRlc3RlZCBwYXRjaGVzIGluIFBhdGNod29yayB3aGVuIHBhdGNo
DQo+IHNlcmllcw0KPiAgICAgYXJlIGJlaW5nIHRlc3RlZD8NCj4gICAtIFByb3ZpZGluZyBlbm91
Z2ggZGF0YS9zY3JpcHQgdG8gcmVwcm9kdWNlIHRoZSBmYWlsdXJlLiBXaGF0IGlmIHNwZWNpYWwg
SFcNCj4gICAgIGlzIG5lZWRlZD8NCj4gLSBPbmJvYXJkaW5nIG5ldyBrZXJuZWwgdHJlZXMgdG8g
dGVzdA0KPiAgIC0gQWltZWQgYXQga2VybmVsIGRldmVsb3BlcnMgYW5kIG1haW50YWluZXJzLg0K
PiAgIC0gV2hpY2ggdHJlZXMgYXJlIG1vc3QgcHJvbmUgdG8gYnJpbmcgaW4gbmV3IHByb2JsZW1z
PyBXaGljaCBhcmUgdGhlIG1vc3QNCj4gICAgIGNyaXRpY2FsIG9uZXM/IERvIHlvdSB3YW50IHRo
ZW0gdG8gYmUgdGVzdGVkPyBXaGljaCB0ZXN0cyBkbyB5b3UgZmVlbCBhcmUNCj4gICAgIG1vc3Qg
YmVuZWZpY2lhbCBmb3Igc3BlY2lmaWMgdHJlZXMgb3IgaW4gZ2VuZXJhbD8NCj4gLSBTZWN1cml0
eSB3aGVuIHRlc3RpbmcgdW50cnVzdGVkIHBhdGNoZXMNCj4gICAtIEhvdyBkbyB3ZSBtZXJnZSwg
Y29tcGlsZSwgYW5kIHRlc3QgcGF0Y2hlcyB0aGF0IGhhdmUgdW50cnVzdGVkIGNvZGUgaW4NCj4g
dGhlbQ0KPiAgICAgYW5kIGhhdmUgbm90IHlldCBiZWVuIHJldmlld2VkPyBIb3cgZG8gd2UgYXZv
aWQgYWJ1c2Ugb2Ygc3lzdGVtcywNCj4gICAgIGluZm9ybWF0aW9uIHRoZWZ0LCBvciBvdGhlciBk
YW1hZ2U/DQo+ICAgLSBDaGVjayBvdXQgdGhlIG9yaWdpbmFsIHBhdGNoIHRoYXQgc3BhcmtlZCB0
aGUgZGlzY3Vzc2lvbiBhdA0KPiAgICAgaHR0cHM6Ly9wYXRjaHdvcmsub3psYWJzLm9yZy9wYXRj
aC84NjIxMjMvDQo+IC0gQXZvaWRpbmcgZWZmb3J0IGR1cGxpY2F0aW9uDQo+ICAgLSBGb29kIGZv
ciB0aG91Z2h0IGJ5IEdyZWdLSA0KPiAgIC0gWCBkaWZmZXJlbnQgQ0kgc3lzdGVtcyBydW5uaW5n
ICR7VEVTVH0gb24gbGF0ZXN0IHN0YWJsZSBrZXJuZWwgb24geDg2XzY0DQo+ICAgICBtaWdodCBs
b29rIHVzZWxlc3Mgb24gdGhlIGZpcnN0IGxvb2sgYnV0IGlzIGl0PyBBTUQvSW50ZWwgQ1BVcywg
ZGlmZmVyZW50DQo+ICAgICBuZXR3b3JrIGNhcmRzLCBkaWZmZXJlbnQgZ3JhcGhpYyBkcml2ZXJz
LCBjb21waWxlcnMsIGtlcm5lbCBjb25maWd1cmF0aW9uLi4uDQo+ICAgICBIb3cgZG8gd2UgZGlz
dHJpYnV0ZSB0aGUgd29ya2xvYWQgdG8gYXZvaWQgZG9pbmcgdGhlIHNhbWUgdGhpbmcgYWxsIG92
ZXINCj4gICAgIGFnYWluIHdoaWxlIHN0aWxsIHJ1bm5pbmcgaW4gZW5vdWdoIGRpZmZlcmVudCBl
bnZpcm9ubWVudHMgdG8gZ2V0IHRoZSBtb3N0DQo+ICAgICBjb3ZlcmFnZT8NCj4gLSBDb21tb24g
aGFyZHdhcmUgcG9vbHMNCj4gICAtIElzIHRoaXMgc29tZXRoaW5nIHBlb3BsZSBhcmUgaW50ZXJl
c3RlZCBpbj8gV291bGQgYmUgaGVscGZ1bCBlc3BlY2lhbGx5IGZvcg0KPiAgICAgSFcgdGhhdCdz
IGhhcmQgdG8gYWNjZXNzLCBlZy4gcHBjNjRsZSBvciBzMzkweCBzeXN0ZW1zLiBDb21wYW5pZXMg
Y291bGQNCj4gYWxzbw0KPiAgICAgc2luZyB1cCB0byBzaGFyZSB0aGVpciBIVyBmb3IgdGVzdGlu
ZyB0byBlbnN1cmUga2VybmVsIHdvcmtzIHdpdGggdGhlaXINCj4gICAgIHByb2R1Y3RzLg0KDQpJ
IGhhdmUgc3Ryb25nIG9waW5pb25zIG9uIHNvbWUgb2YgdGhlc2UsIGJ1dCBtYXliZSBvbmx5IHVz
ZWZ1bCBleHBlcmllbmNlDQppbiBhIGZldyBhcmVhcy4gIEZ1ZWdvIGhhcyAyIHNlcGFyYXRlIG5v
dGlvbnMsIHdoaWNoIHdlIGNhbGwgInNraXBsaXN0cyINCmFuZCAicGFzcyBjcml0ZXJpYSIsIHdo
aWNoIGhhdmUgdG8gZG8gd2l0aCB0aGlzIGJ1bGxldDoNCg0KLSBIb3cgdG8gYXV0b2RldGVjdCBp
bmZyYXN0cnVjdHVyZSBmYWlsdXJlcywgcmVncmVzc2lvbnMvbmV3IGJ1Z3MgYW5kIHRlc3QNCiAg
ICAgYnVncz8gSG93IHRvIGhhbmRsZSBjb250aW51b3VzIGZhaWx1cmVzIGR1ZSB0byBrbm93biBi
dWdzIGluIGJvdGgNCiAgICAgdGVzdHMgYW5kIGtlcm5lbD8gV2hhdCdzIHlvdXIgc29sdXRpb24/
IENhbiBwZW9wbGUgYWx3YXlzIHRydXN0IHRoZSByZXN1bHRzIHRoZXkNCiAgICAgcmVjZWl2ZT8N
Cg0KSSdkIGJlIGhhcHB5IHRvIGRpc2N1c3MgdGhpcywgaWYgaXQncyBkZXNpcmVkLg0KDQpPdGhl
cndpc2UsIEkndmUgcmVjZW50bHkgYmVlbiB3b3JraW5nIG9uIHN0YW5kYXJkcyBmb3IgInRlc3Qg
ZGVmaW5pdGlvbiIsDQp3aGljaCBkZWZpbmVzIHRoZSBkYXRhIGFuZCBtZXRhLWRhdGEgYXNzb2Np
YXRlZCB3aXRoIGEgdGVzdC4gICBJIGNvdWxkIHRhbGsNCmFib3V0IHdoZXJlIEknbSBhdCB3aXRo
IHRoYXQsIGlmIHBlb3BsZSBhcmUgaW50ZXJlc3RlZC4NCg0KTGV0IG1lIGtub3cgd2hhdCB5b3Ug
dGhpbmsuDQogLS0gVGltDQoNCg==
