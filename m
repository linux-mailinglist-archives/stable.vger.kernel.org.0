Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2441E94F5
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 03:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbfJ3CP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 22:15:58 -0400
Received: from mail-eopbgr1410090.outbound.protection.outlook.com ([40.107.141.90]:17824
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726025AbfJ3CP5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Oct 2019 22:15:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z5lnzcLtvIGouUbKnh+seJzUXnvm1IZ4XWm3DixksgUBG7pyKkcaKfkbcpmlhP3SaSOzgl3mo/mqY1ohCgj9u8ICWD2Fbkmy7UvZt3dOvc0GgQr2A1TNxr/pnx5HCAhvn1n4GwGGkIacFXOjUq/44k9KCY8XrpX428s/0KOb6+eSUmA/sfs9DQcxytQGBYd/kIyFACdnATgwXjlGxGqSc0HLcEvwu/sTyzaKorwJ4ShOKZ0PqkLS+Maw17L5xF3sLI+3EJ7pkPVmirq3CV0xsHgFTCgJhm1EJ0tS1TgjekiVBkNNBEGt5Q/x1d2hrE/smfsZGWdbnvYc1R3Q5KJqfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MT+kqWZleHarXDHLmPW8d3iUH63CNlOJFGafVym7HoM=;
 b=VpgfVfwTFkpntFTnJz1e6JBny4qr/SrkcqbKK0aecUguJ8bHaBhXXTy4AuWtln3sNOQEjeL54eT3AA+cR51GrZ+hqQq6k3J6ZQ0taNfB1aqt0GJbI+zHLcEWfdeho1r+dHtfJqTDUpB0fqa8IquIsZZFcaMSnh1VwTbaCFj7qGP1uFd5tcI1TXcpxv/PAoNUYeluhfqnIO/DScx9Xt9aGaaSda7wfyLuC5yzFgfRAS79RbpYR8twS8q3pKd5wmOHgZYGOd0AwT/0HvT+nVsT9hWPZp/hb87jePgVnwieAknzs5fCRxeacRCLlWrwz8lRm3R8yYFqCc8CYWTb+t1Dvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MT+kqWZleHarXDHLmPW8d3iUH63CNlOJFGafVym7HoM=;
 b=meop6vLkAWNnzQjAq69kB6kTdjtn8T3E2xuuVwGyla+QvvZtPwNAfnt5G29rsKQzhhcF8sbhtJXmOgKaARrD9RboYjjsjQan8uUrrVw5jKdFbneAuluQhUyYXYqI94nvxTVEKdVzUAqolpEi6GS6Hesu2FdYMgsvDrJr1uBwDr0=
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com (20.179.175.203) by
 TYAPR01MB3344.jpnprd01.prod.outlook.com (20.178.140.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.23; Wed, 30 Oct 2019 02:15:51 +0000
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::548:32de:c810:1947]) by TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::548:32de:c810:1947%4]) with mapi id 15.20.2387.028; Wed, 30 Oct 2019
 02:15:51 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     "REE erosca@DE.ADIT-JV.COM" <erosca@DE.ADIT-JV.COM>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
CC:     "horms@verge.net.au" <horms@verge.net.au>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Yohhei Fukui <yohhei.fukui@denso-ten.com>,
        Asano Yasushi <yasano@jp.adit-jv.com>,
        Steffen Pengel <spengel@jp.adit-jv.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        "REE erosca@DE.ADIT-JV.COM" <erosca@DE.ADIT-JV.COM>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>
Subject: RE: [PATCH v4] PCI: rcar: Fix missing MACCTLR register setting in
 rcar_pcie_hw_init()
Thread-Topic: [PATCH v4] PCI: rcar: Fix missing MACCTLR register setting in
 rcar_pcie_hw_init()
Thread-Index: AQHVf+9qjSU3Sv51RE+DQhHbHCYXz6dxzQWAgAC8WBA=
Date:   Wed, 30 Oct 2019 02:15:50 +0000
Message-ID: <TYAPR01MB45441F470C83E7CAEF4D72E0D8600@TYAPR01MB4544.jpnprd01.prod.outlook.com>
References: <1570769432-15358-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <20191029143753.GA28404@vmlxhi-102.adit-jv.com>
In-Reply-To: <20191029143753.GA28404@vmlxhi-102.adit-jv.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yoshihiro.shimoda.uh@renesas.com; 
x-originating-ip: [150.249.235.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 47b4782f-4a3a-442e-6904-08d75cdf15ef
x-ms-traffictypediagnostic: TYAPR01MB3344:
x-ld-processed: 53d82571-da19-47e4-9cb4-625a166a4a2a,ExtAddr
x-microsoft-antispam-prvs: <TYAPR01MB3344C587A508E57DC04BA7A0D8600@TYAPR01MB3344.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(366004)(346002)(39860400002)(136003)(396003)(189003)(199004)(316002)(5660300002)(2906002)(86362001)(54906003)(102836004)(52536014)(476003)(76176011)(6506007)(110136005)(486006)(446003)(26005)(11346002)(186003)(66066001)(7696005)(99286004)(33656002)(8936002)(8676002)(14454004)(7736002)(305945005)(74316002)(66556008)(25786009)(66476007)(76116006)(71190400001)(81156014)(81166006)(71200400001)(66446008)(64756008)(4326008)(229853002)(6246003)(55016002)(256004)(478600001)(6116002)(3846002)(66946007)(413944005)(9686003)(6436002)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB3344;H:TYAPR01MB4544.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IrWzozqqEwkcM+8gCwdg2pni0p9IxLoqpO1VjGJUp/vvDx4zLuxJkIS/xMs1n6xDN86Ac8dCNAOF4sFD0/L3XXAH+HP+r7AJJLymGR4MOcEAp1PQPOvnAZ/7PkzYUjD5T8Ob6OcnfhV1aGYp1SMbeqjoULc4/kCYYqy/OrgAvDAVikOGxU8k/ECAWo3D0CGKAW9qtSy+4g8LBKdgYtUnAVBFMJ5Siw2TCLJkdTtVowLUkkjXE8B95nTjg1K0U76snf5iCzqayHgsJYp3Dz4PDyHKVOjSzxmNIcunP82Ph00G6WzdZsOcEPGvt/+B01dmddxXz+HSeo476u4J6UOoXVBFcyu2sT/XtGAelJaiEFTGCAVfu7/CXc68lkaklZNmH9yimOUZ6zuNSnVhMZiPFGg4ErToD/YrMuBA2fFazKzr7ZGpdAknQCh+i6lgDvFd
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47b4782f-4a3a-442e-6904-08d75cdf15ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 02:15:50.9849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EbVjBKn29lSeeQRRRaWeQSkExX+1/iyeLi3r47AeUhdb3PuUHdw3cgqsUZk1prfNHoo/umLYgDHxWcz/3Qq4cm24tEHRq2Lde/WMh4M1sDrbE3dJpERI34jl/DbLxXS3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB3344
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RGVhciBFdWdlbml1LXNhbiwNCg0KVGhhbmsgeW91IGZvciB5b3VyIGNvbW1lbnRzIQ0KDQo+IEZy
b206IEV1Z2VuaXUgUm9zY2EsIFNlbnQ6IFR1ZXNkYXksIE9jdG9iZXIgMjksIDIwMTkgMTE6Mzgg
UE0NCj4gDQo+IERlYXIgU2hpbW9kYS1zYW4sIGRlYXIgcmV2aWV3ZXJzLA0KPiANCj4gT24gRnJp
LCBPY3QgMTEsIDIwMTkgYXQgMDE6NTA6MzJQTSArMDkwMCwgWW9zaGloaXJvIFNoaW1vZGEgd3Jv
dGU6DQo+ID4gQWNjb3JkaW5nIHRvIHRoZSBSLUNhciBHZW4yLzMgbWFudWFsLCB0aGUgYml0IDAg
b2YgTUFDQ1RMUiByZWdpc3Rlcg0KPiA+IHNob3VsZCBiZSB3cml0dGVuIHRvIDAgYmVmb3JlIGVu
YWJsaW5nIFBDSUVUQ1RMUi5DRklOSVQgYmVjYXVzZQ0KPiA+IHRoZSBiaXQgMCBpcyBzZXQgdG8g
MSBvbiByZXNldC4gVG8gYXZvaWQgdW5leHBlY3RlZCBiZWhhdmlvcnMgZnJvbQ0KPiA+IHRoaXMg
aW5jb3JyZWN0IHNldHRpbmcsIHRoaXMgcGF0Y2ggZml4ZXMgaXQuDQo+IA0KPiBZb3VyIGRldmVs
b3BtZW50IGFuZCByZXZpZXdpbmcgZWZmb3J0IHRvIHJlYWNoIHY0IGlzIHZlcnkgYXBwcmVjaWF0
ZWQuDQo+IA0KPiBIb3dldmVyLCBpbiB0aGUgY29udGV4dCBvZiBzb21lIGludGVybmFsIHJldmll
d3Mgb2YgdGhpcyBwYXRjaCwgd2UgYXJlDQo+IGhhdmluZyBoYXJkIHRpbWVzIHJlY29uY2lsaW5n
IHRoZSBjaGFuZ2Ugd2l0aCBvdXIgKHBvc3NpYmx5IGluY29tcGxldGUNCj4gb3IgaW5hY2N1cmF0
ZSkgaW50ZXJwcmV0YXRpb24gb2YgdGhlIFItQ2FyMyBIVyBVc2Vy4oCZcyBNYW51YWwgKFJldi4y
LjAwDQo+IEp1bCAyMDE5KS4gVGhlIGxhdHRlciBzYXlzIGluDQo+IENoYXB0ZXIgIjU0LiBQQ0lF
IENvbnRyb2xsZXIiIC8gIigyKSBJbml0aWFsIFNldHRpbmcgb2YgUENJIEV4cHJlc3MiOg0KPiAN
Cj4gIC0tLS1zbmlwLS0tLQ0KPiAgQmUgc3VyZSB0byB3cml0ZSB0aGUgaW5pdGlhbCB2YWx1ZSAo
PSBIJzgwRkYgMDAwMCkgdG8gTUFDQ1RMUiBiZWZvcmUNCj4gIGVuYWJsaW5nIFBDSUVUQ1RMUi5D
RklOSVQuDQo+ICAtLS0tc25pcC0tLS0NCj4gDQo+IElzIG15IGFzc3VtcHRpb24gY29ycmVjdCB0
aGF0IHRoZSBkZXNjcmlwdGlvbiBvZiB0aGlzIHBhdGNoIGlzIGENCj4gcmV3b3JkaW5nIG9mIHRo
ZSBhYm92ZSBxdW90ZSBmcm9tIHRoZSBtYW51YWwgPHNuaXA+DQoNCllvdSBhcmUgY29ycmVjdC4g
U2luY2UgdGhlIHJlc2V0IHZhbHVlIG9mIE1BQ0NUTFIgaXMgSCc4MEZGIDAwMDEsIEkgdGhvdWdo
dA0KY2xlYXJpbmcgdGhlIExTQiBiaXQgd2FzIGVub3VnaC4NCkhvd2V2ZXIsIGFzIHlvdXIgc2l0
dWF0aW9uLCBJIHRoaW5rIEkgc2hvdWxkIGhhdmUgZGVzY3JpYmVkIHRoZSBhYm92ZSBxdW90ZQ0K
ZnJvbSB0aGUgbWFudWFsIGFuZCBoYXZlIHN1Y2ggYSBjb2RlICh3cml0aW5nIHRoZSB2YWx1ZSBp
bnN0ZWFkIG9mIGNsZWFyaW5nDQp0aGUgTFNCIG9ubHkpLiANCg0KPiBJZiBpdCBpcyBvbmx5IHRo
ZSBMU0Igd2hpY2ggInNob3VsZCBiZSB3cml0dGVuIHRvIDAgYmVmb3JlIGVuYWJsaW5nDQo+IFBD
SUVUQ1RMUi5DRklOSVQiLCB3b3VsZCB5b3UgYWdyZWUgdGhhdCB0aGUgc3RhdGVtZW50IHF1b3Rl
ZCBmcm9tIHRoZQ0KPiBtYW51YWwgd291bGQgYmV0dGVyIGJlIHJlcGhyYXNlZCBhcHByb3ByaWF0
ZWx5PyBUSUEuDQoNCkFzIEkgbWVudGlvbmVkIGFib3ZlLCBJIHRoaW5rIHRoZSBhYm92ZSBxdW90
ZSBmcm9tIHRoZSBtYW51YWwgaXMgYmV0dGVyDQp0aGFuIHJlcGhyYXNlZC4NCg0KU2VyZ2VpLCBH
ZWVydC1zYW4sIEkgdGhpbmsgd2Ugc2hvdWxkIHJldmVydCB0aGlzIHBhdGNoIGFuZCBmaXggY29k
ZS9jb21taXQNCmxvZyB0byBmb2xsb3cgdGhlIG1hbnVhbC4gV2hhdCBkbyB5b3UgdGhpbms/DQoN
CkJlc3QgcmVnYXJkcywNCllvc2hpaGlybyBTaGltb2RhDQoNCj4gPg0KPiA+IEZpeGVzOiBjMjVk
YTQ3Nzg4MDMgKCJQQ0k6IHJjYXI6IEFkZCBSZW5lc2FzIFItQ2FyIFBDSWUgZHJpdmVyIikNCj4g
PiBGaXhlczogYmUyMGJiY2IwYThjICgiUENJOiByY2FyOiBBZGQgdGhlIGluaXRpYWxpemF0aW9u
IG9mIFBDSWUgbGluayBpbiByZXN1bWVfbm9pcnEoKSIpDQo+ID4gQ2M6IDxzdGFibGVAdmdlci5r
ZXJuZWwub3JnPiAjIHY1LjIrDQo+ID4gU2lnbmVkLW9mZi1ieTogWW9zaGloaXJvIFNoaW1vZGEg
PHlvc2hpaGlyby5zaGltb2RhLnVoQHJlbmVzYXMuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBTZXJn
ZWkgU2h0eWx5b3YgPHNlcmdlaS5zaHR5bHlvdkBjb2dlbnRlbWJlZGRlZC5jb20+DQo+ID4gUmV2
aWV3ZWQtYnk6IEdlZXJ0IFV5dHRlcmhvZXZlbiA8Z2VlcnQrcmVuZXNhc0BnbGlkZXIuYmU+DQo+
IA0KPiAtLQ0KPiBCZXN0IFJlZ2FyZHMsDQo+IEV1Z2VuaXUNCg==
