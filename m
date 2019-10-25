Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B819DE46DC
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 11:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfJYJQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 05:16:02 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:53273 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbfJYJQB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 05:16:01 -0400
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Claudiu.Beznea@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Claudiu.Beznea@microchip.com";
  x-sender="Claudiu.Beznea@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Claudiu.Beznea@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; spf=Pass smtp.mailfrom=Claudiu.Beznea@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: sdvAHdq9lJ0R3x/39ndPE3RpPIAigq6Bp0cPyZ4I7lAhO+48tj7TkqpAIV60+h4ceBaCaGIkVI
 /kv2CM/6KKtaIE5WjlC8YezlV+o+oGVyohZRPclfKiuabrOaOr8wHGWEDfl46r/7ZE9ghGPAuL
 6MsfnfV29JGbodqdwUQf7lKt3Lm53qKUTYy9TO435CIctzuoJQCyZL1/cSe4lauwwxih6oBdBN
 l++yfIrFpnXJL+8QqzOI/NIwqV469A8iR6Ly9DlRkcIN96rzDjZIPiCivxbVjGdEfAyhi4f+Sv
 Dig=
X-IronPort-AV: E=Sophos;i="5.68,228,1569308400"; 
   d="scan'208";a="51530411"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Oct 2019 02:16:00 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 25 Oct 2019 02:16:00 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 25 Oct 2019 02:16:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xx64MFV6X0TZHnnkcrcqR3lz9PBjBw8tZYt0+sSYboCet9VFpf1W13amKcQfL1k/JJgSxU0+KLyXZJkTdcUT2bTL2FNU4D++Ah2DgJLnwaZg02gVvBG9JP/QG1KUMcvsSCz3gA8GRppt/eaJzcfYI1MuxGjLq4UqWoT41zpqXcyJuGtprXynSCul4W6epTG126SmHnS2oMS1XHQ20Gy18fL0zTKBm8wwlmYpSmv9Ogs4lkCe6VnlxxIdlLoApc/5wp1cV3y7TT/hnfhDv/QEm1fjJrDGrnm5XzT502FFJI8toPn+V1GOt4dBnLn3meE43F9ygKDUIecdZurThD8nzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nqz/idQ6nlL1zH7IUT9L2wfWDmG/jbjSCde9VwuqC2w=;
 b=HHGAB/RJ6Lfu29CJ/UtILoS2ezDc4nTNH4M/IS8gcPv+lrTYKcQsznxLkG6JSunbojELAkayPaDncvNYTpTqGk45Z/K07RC+vNhsnyehQhv4jyaV+y1z/Xn/J0y6FMJXSy3WlKwkGXNQMDSDX0VMnNtPx0iFF/smukoJWGEudH6ytdNcNCXZcvhsgxMHL+DcttcL+G2MWOl6jbI/miTbpnoS48QCcoT0IrgOsHdIbmyrizm3569olHq2fsfuHdaihhg9/W/9bre0GLlNHNoJR0LZcfx9Af9ROJBVmwDM7H/okU0oieVwgdyNK4qZ7cGzww7T46ee/VsVku8uWVuLHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nqz/idQ6nlL1zH7IUT9L2wfWDmG/jbjSCde9VwuqC2w=;
 b=VWz+SmTVRigBUtiNI08Hi8PWkcsZrEIY+U5IX5/xNjzDsOLeL5nPksKIk8DYS5Midrzza52uPVaECOOb8pbGDwh2A+OBpEgYzuuxlsP46y/uKb2VJQyktcFCmBL6kMSY9TcT8/534v264e4AHfjIfnI0sLki/ROrPffCZnPXF2Q=
Received: from DM6PR11MB3225.namprd11.prod.outlook.com (20.176.120.85) by
 DM6PR11MB3355.namprd11.prod.outlook.com (20.176.122.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Fri, 25 Oct 2019 09:15:59 +0000
Received: from DM6PR11MB3225.namprd11.prod.outlook.com
 ([fe80::3874:9f3c:5325:d22]) by DM6PR11MB3225.namprd11.prod.outlook.com
 ([fe80::3874:9f3c:5325:d22%6]) with mapi id 15.20.2387.023; Fri, 25 Oct 2019
 09:15:59 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <Ludovic.Desroches@microchip.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>
CC:     <alexandre.belloni@bootlin.com>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: at91: sama5d4: fix pinctrl muxing
Thread-Topic: [PATCH] ARM: dts: at91: sama5d4: fix pinctrl muxing
Thread-Index: AQHVixAJLedNeuOqCEuZRlo+W7F7NqdrE3gA
Date:   Fri, 25 Oct 2019 09:15:59 +0000
Message-ID: <e2d81b87-408d-b50d-3e4c-b28367e4cb00@microchip.com>
References: <20191025084210.14726-1-ludovic.desroches@microchip.com>
In-Reply-To: <20191025084210.14726-1-ludovic.desroches@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MR2P264CA0086.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:32::26) To DM6PR11MB3225.namprd11.prod.outlook.com
 (2603:10b6:5:59::21)
x-ms-exchange-messagesentrepresentingtype: 1
x-tagtoolbar-keys: D20191025121552227
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9f03b341-4197-433a-9b18-08d7592bf2fc
x-ms-traffictypediagnostic: DM6PR11MB3355:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB3355E177B5A096057C01F26787650@DM6PR11MB3355.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:321;
x-forefront-prvs: 02015246A9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(39860400002)(376002)(136003)(396003)(199004)(189003)(6486002)(102836004)(66066001)(14454004)(446003)(186003)(8936002)(76176011)(81166006)(8676002)(81156014)(3846002)(2906002)(31686004)(26005)(52116002)(99286004)(53546011)(25786009)(6506007)(11346002)(386003)(478600001)(305945005)(64756008)(66556008)(7736002)(4326008)(6246003)(66446008)(66946007)(66476007)(6436002)(6512007)(486006)(71190400001)(36756003)(6116002)(2201001)(5660300002)(54906003)(256004)(110136005)(86362001)(71200400001)(316002)(2501003)(229853002)(4744005)(2616005)(476003)(31696002)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3355;H:DM6PR11MB3225.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z4h0oI8E1IxRxGfqPfrABYNTmgWTJCRDt/fsN7lOGQwxrU+QlhqPnI3KWbpqfnqQATSASdgb/Lq9tesbllpx+a+IBM/IfTBvKeYMOCMoivrQaGsq+VP3w+Kndh2bEeOLz1CtsQ08p3L9zM/9JULhqTg+VVq7nvRc/YR8qRSXpI+sfrU+oG7UPG9uizOKeid8QXYF7Ah0HMy+e6wycs4DKVr7c/nJdiLEYn0dvDJbxrcQz6cV2iW3ThLa0iLJuSFnzwntlUojKXUYP4iXT8G0Kb+TPP5YodTFKIBr94aCGJI/sZZlgkOla9gUKDP4eSZ4UX6F2lGowRs73DDmCQwvD0au1NI6x+STzTUMiEzLeNK9Q5/y3JXgZSOFtrc33oybBF2Og20ECR53mYcfj095ioRPCsaUo+jHOSVtxr7XZduCIch13w0ZQm2LZ8IuS71/
Content-Type: text/plain; charset="utf-8"
Content-ID: <5DD681549F566C408235A38CB7FF4D0A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f03b341-4197-433a-9b18-08d7592bf2fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2019 09:15:59.2600
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PfmFKE5OmUmXR8SoVCfYd/g23j1oGsy4FW9uGj2m4XCBNLsuvUniT6HMBxtYIyhd2SJH3+pMzmU7OtyNvZT7by+X+zHM1CgwFxCfqGJh3bE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3355
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCk9uIDI1LjEwLjIwMTkgMTE6NDIsIEx1ZG92aWMgRGVzcm9jaGVzIHdyb3RlOg0KPiBFeHRl
cm5hbCBFLU1haWwNCj4gDQo+IA0KPiBGaXggcGluY3RybCBtdXhpbmcsIFBEMjgsIFBEMjkgYW5k
IFBEMzEgY2FuIGJlIG11eGVkIHRvIHBlcmlwaGVyYWwgQS4gSXQNCj4gYWxsb3dzIHRvIHVzZSBT
Q0swLCBTQ0sxIGFuZCBTUEkwX05QQ1MyIHNpZ25hbHMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBM
dWRvdmljIERlc3JvY2hlcyA8bHVkb3ZpYy5kZXNyb2NoZXNAbWljcm9jaGlwLmNvbT4NCj4gRml4
ZXM6IDY3OWY4ZDkyYmIwMSAoIkFSTTogYXQ5MS9kdDogc2FtYTVkNDogYWRkIHBpb0QgcGluIG11
eCBtYXNrIGFuZCBlbmFibGUgcGlvRCIpDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQoN
ClJldmlld2VkLWJ5OiBDbGF1ZGl1IEJlem5lYSA8Y2xhdWRpdS5iZXpuZWFAbWljcm9jaGlwLmNv
bT4NCg0KPiAtLS0NCj4gIGFyY2gvYXJtL2Jvb3QvZHRzL3NhbWE1ZDQuZHRzaSB8IDIgKy0NCj4g
IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2FyY2gvYXJtL2Jvb3QvZHRzL3NhbWE1ZDQuZHRzaSBiL2FyY2gvYXJtL2Jvb3Qv
ZHRzL3NhbWE1ZDQuZHRzaQ0KPiBpbmRleCA2YWIyN2E3YjM4OGQuLmE0Y2VmMDdjMzhjYiAxMDA2
NDQNCj4gLS0tIGEvYXJjaC9hcm0vYm9vdC9kdHMvc2FtYTVkNC5kdHNpDQo+ICsrKyBiL2FyY2gv
YXJtL2Jvb3QvZHRzL3NhbWE1ZDQuZHRzaQ0KPiBAQCAtOTE0LDcgKzkxNCw3IEBAIC8qICAgQSAg
ICAgICAgICBCICAgICAgICAgIEMgICovDQo+ICAJCQkJCTB4ZmZmZmZmZmYgMHgzZmZjZmU3YyAw
eDFjMDEwMTAxCS8qIHBpb0EgKi8NCj4gIAkJCQkJMHg3ZmZmZmZmZiAweGZmZmNjYzNhIDB4M2Yw
MGNjM2EJLyogcGlvQiAqLw0KPiAgCQkJCQkweGZmZmZmZmZmIDB4M2ZmODNmZmYgMHhmZjAwZmZm
ZgkvKiBwaW9DICovDQo+IC0JCQkJCTB4MDAwM2ZmMDAgMHg4MDAyYTgwMCAweDAwMDAwMDAwCS8q
IHBpb0QgKi8NCj4gKwkJCQkJMHhiMDAzZmYwMCAweDgwMDJhODAwIDB4MDAwMDAwMDAJLyogcGlv
RCAqLw0KPiAgCQkJCQkweGZmZmZmZmZmIDB4N2ZmZmZmZmYgMHg3NmZmZjFiZgkvKiBwaW9FICov
DQo+ICAJCQkJCT47DQo+ICANCj4gDQo=
