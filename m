Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A66B19BE7D
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 11:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387716AbgDBJUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 05:20:19 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:37541 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729033AbgDBJUT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 05:20:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1585819218; x=1617355218;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0tnkNGFJwDR2X3GDM0UJTgtjW/tJBv5VhMrWITSit4s=;
  b=hBJ5ibbmM3CMSEa2eqHhNEkVqy+NQo8GiAPXOvmSO7HVdp7tJpZnGgF7
   AVwktVquTunyLNT4OY06CIDPq8CZPNH2ZKwHCcVqM4ofq0qeT+qRLcMwf
   ji/HWKrm4+AJYE92acOaJ2YBm7YeftDbfob+SsrwbMh4D2IHBmtCF3hV3
   4Jbl/5DW5RRHWpz+iHD/4kSgDkNR0RzPETdeiDYzJ6p4RVgqpF49O4c0/
   G9SvE1cC0WLOa1Vl9pQTpHGKSwOuJmbe9pQJt3tY0/kYtOmMCQ6TDQ4Kr
   9LtFeX+uLHorERKp+p2b4OSU3wP8Zeu1R0mq1FYfzhumiRi57G2vFj55R
   Q==;
IronPort-SDR: YQQF7/MrLdja26WsFhYscwJ3lDzOeh0qNu2t6GlozNF7wH8fbHnKJsco0kZgni0VpWZSCpcqvb
 MG+5kBkbAYt1N/zqCOK87V9765KWF+aU9jtaeeIHzH/q4CzS0+hkE6C0VlTGdJlVftXLm0VmK3
 Iuh01bSoSx1lTdv2BEl5Z/orICpzKkCmdJ0z5JO38AIam1Xjo1YU4d2i48Ili8miyFeAYkfBVi
 d1OudaysuNtrW9Aelo2fPkpM4wsA3qOM2IIjKlaTCAxGool6tu3gyldeECGApBIpOOohWUfMhq
 v/g=
X-IronPort-AV: E=Sophos;i="5.72,335,1580799600"; 
   d="scan'208";a="72060561"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Apr 2020 02:20:18 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 2 Apr 2020 02:20:18 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Thu, 2 Apr 2020 02:20:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B85pQ+ZeaUqHxseXZRP+G9KbZZ5V+tvUDjos+16BZsE+WEQ2EsuoEevH6pzI9egnNTQpZ+naIUPiPVhtdOmdEtB7WuP/8OwuhbeF2WDs52dzBske7cuYwu8Heb+lONjDT1gIXtZpzDxLJa50cqTI5W6sZIhzFhisx77CDi8WBVf+0rziqtosWZ73+ihyh4hASUD3av56r/1jj66TJV8eTOsRrB+FKI2czre15X6vYqQALffZ9zj5Jp2DNuKmLilLBzKGNjS+M5dz4IYHkiX/2vawVbN7bjSTX/Kf7VnuElA91JKQHfHX8hQnTJS0o64j5DXLzK1IDkLoUXzQ4VoAQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0tnkNGFJwDR2X3GDM0UJTgtjW/tJBv5VhMrWITSit4s=;
 b=cHxCDbj+F/o0LbE5pr5Bbi/WLzzMiAULu8LSwT2GK3gW5hKNBNGX/w7Akg9tLoEtdNs3VoiYV4oOGNzNkNpOxoHiTdBfScL4M1YwGdMXX355Ilp2gRgHC3icr48QQNqW8keY6aQYXecwj88eRQQ57gcovkgwVKHzQhVuEGWiW/yMdcSIwGtNuErhdICbBIQ5b8hxZellIR8K2V3lYKhTWTPCsns0h7+R0CGrgpbpHBcXF72XgNHP8W6XBH0qdSXkRp+SbuZfGw9nSwTnx79OsfiIFT1F01ZmCjCudWczXho8VVt966Z10htdjBcZTtTJt0avmp5vt/tDm40fOVWblw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0tnkNGFJwDR2X3GDM0UJTgtjW/tJBv5VhMrWITSit4s=;
 b=gNW+tVJjY4bTIKPE9EVNy9L+m4EwtvSccwsFo+gFVu1yLfpL4zhukaoH7g/AGlF2snLXuPZBfOJc3ncLC7yVQV8ARAfxjzgvpsZWnwExU+E0anDTfSFkZVbP6kaeD2Vs5k4VPMN+nfpPLbCrtipN0d+7YlxiggtT3xf51jsMj0A=
Received: from DM6PR11MB4123.namprd11.prod.outlook.com (2603:10b6:5:196::12)
 by DM6PR11MB4249.namprd11.prod.outlook.com (2603:10b6:5:1d9::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Thu, 2 Apr
 2020 09:20:16 +0000
Received: from DM6PR11MB4123.namprd11.prod.outlook.com
 ([fe80::f42c:82b3:ecda:5ff4]) by DM6PR11MB4123.namprd11.prod.outlook.com
 ([fe80::f42c:82b3:ecda:5ff4%6]) with mapi id 15.20.2878.017; Thu, 2 Apr 2020
 09:20:16 +0000
From:   <Eugen.Hristev@microchip.com>
To:     <Ludovic.Desroches@microchip.com>, <Nicolas.Ferre@microchip.com>,
        <alexandre.belloni@bootlin.com>, <robh+dt@kernel.org>
CC:     <devicetree@vger.kernel.org>, <Tudor.Ambarus@microchip.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <Codrin.Ciubotariu@microchip.com>, <Cristian.Birsan@microchip.com>
Subject: Re: [PATCH 1/5] ARM: dts: at91: sama5d2_ptc_ek: fix sdmmc0 node
 description
Thread-Topic: [PATCH 1/5] ARM: dts: at91: sama5d2_ptc_ek: fix sdmmc0 node
 description
Thread-Index: AQHWCHMUVzqU8dzz1022okz8VD+yc6hljvCA
Date:   Thu, 2 Apr 2020 09:20:16 +0000
Message-ID: <b4fe14af-a812-8798-187e-704541a6a75f@microchip.com>
References: <20200401221504.41196-1-ludovic.desroches@microchip.com>
In-Reply-To: <20200401221504.41196-1-ludovic.desroches@microchip.com>
Accept-Language: en-US, ro-RO
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Eugen.Hristev@microchip.com; 
x-originating-ip: [86.120.188.33]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d899c4b-dcab-495e-604f-08d7d6e70e73
x-ms-traffictypediagnostic: DM6PR11MB4249:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB4249B38EFB4C84EC079E6DF1E8C60@DM6PR11MB4249.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0361212EA8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4123.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(39860400002)(346002)(396003)(376002)(4326008)(53546011)(76116006)(5660300002)(31696002)(6506007)(91956017)(8936002)(2616005)(186003)(36756003)(66946007)(26005)(2906002)(86362001)(66556008)(107886003)(110136005)(6486002)(31686004)(316002)(81156014)(8676002)(66476007)(71200400001)(64756008)(6512007)(81166006)(66446008)(54906003)(478600001);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j+zIPEU9OGOjous2Wvk/GMoT/DNcxRVysITPbumAGB9hw6x6+TqkcQMY8PgdmGXxNVz9ak9UPwAa0AnyGONC5HVppNhYuwqpgwPp+pmljL5M8IrBZk+/SgQdA2IQucmJN56I+MozDG2SAddnemYYp6rLiKpKiblal/GZeALXJO4hUQS33KYIcGnIgO4gvBZyvdHyVN2Ba+qce56WzIukIoYPy70+1GbFOcyXvp3F2/oUPmeU2SX9alD3XwjddemPL4YnjKNAnlwdr8ULLEatvf54H1hwVstOtCp10o/2nEy9q2fCov2Woi9dleEZc6q/HVrd43zHRa21olBdbJHVcximCBf10qAEFMIayJZ+5GiJCFQwM45Dmmdgev5hZIsve+pos5B84nfz9gUGlCTzZbKZb1PwSmgQgBY2ZPf3Kn+adNUB1uxhznz5dN8e1HrT
x-ms-exchange-antispam-messagedata: L1WVr/RjAKNMgUOpjwbZsrLGckVep6rLoHaSWNScMjGIhYkajcqgvM+FF7jvyonb5KpAKEBFF9d6Eu4N91IhYiwHEgLqKgXEFc2krI8pJz8teHRh5sc1Gt93seeCif5gADQPiCnkj3sfBCL8wWP1hw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <65AF3050EA25D84F80ACCC7817B4FF62@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d899c4b-dcab-495e-604f-08d7d6e70e73
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2020 09:20:16.3207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZbyMCU9/6b0mJ/c1ZEzhRfdhnEmceScWL2evO/VadMrO7uRI4p4UjYd4uikx1gT1uoMcabmxomIOFpAyjRdF/83gPbsgnyaYW26JbyLKNcU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4249
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMDIuMDQuMjAyMCAwMToxNSwgTHVkb3ZpYyBEZXNyb2NoZXMgd3JvdGU6DQo+IFJlbW92ZSBu
b24tcmVtb3ZhYmxlIGFuZCBtbWMtZGRyLTFfOHYgcHJvcGVydGllcyBmcm9tIHRoZSBzZG1tYzAN
Cj4gbm9kZSB3aGljaCBjb21lIHByb2JhYmx5IGZyb20gYW4gdW5jaGVja2VkIGNvcHkvcGFzdGUu
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBMdWRvdmljIERlc3JvY2hlcyA8bHVkb3ZpYy5kZXNyb2No
ZXNAbWljcm9jaGlwLmNvbT4NCj4gRml4ZXM6NDJlZDUzNTU5NWVjICJBUk06IGR0czogYXQ5MTog
aW50cm9kdWNlIHRoZSBzYW1hNWQyIHB0YyBlayBib2FyZCINCj4gQ2M6IHN0YWJsZUB2Z2VyLmtl
cm5lbC5vcmcgIyA0LjE5IGFuZCBsYXRlcg0KPiAtLS0NCj4gICBhcmNoL2FybS9ib290L2R0cy9h
dDkxLXNhbWE1ZDJfcHRjX2VrLmR0cyB8IDIgLS0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMiBkZWxl
dGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL2FybS9ib290L2R0cy9hdDkxLXNhbWE1
ZDJfcHRjX2VrLmR0cyBiL2FyY2gvYXJtL2Jvb3QvZHRzL2F0OTEtc2FtYTVkMl9wdGNfZWsuZHRz
DQo+IGluZGV4IDFjMjRhYzgwMTliYTcuLjc3MjgwOWM1NGMxZjMgMTAwNjQ0DQo+IC0tLSBhL2Fy
Y2gvYXJtL2Jvb3QvZHRzL2F0OTEtc2FtYTVkMl9wdGNfZWsuZHRzDQo+ICsrKyBiL2FyY2gvYXJt
L2Jvb3QvZHRzL2F0OTEtc2FtYTVkMl9wdGNfZWsuZHRzDQo+IEBAIC0xMjUsOCArMTI1LDYgQEAg
c2RtbWMwOiBzZGlvLWhvc3RAYTAwMDAwMDAgew0KPiAgIAkJCWJ1cy13aWR0aCA9IDw4PjsNCj4g
ICAJCQlwaW5jdHJsLW5hbWVzID0gImRlZmF1bHQiOw0KPiAgIAkJCXBpbmN0cmwtMCA9IDwmcGlu
Y3RybF9zZG1tYzBfZGVmYXVsdD47DQo+IC0JCQlub24tcmVtb3ZhYmxlOw0KPiAtCQkJbW1jLWRk
ci0xXzh2Ow0KDQpIaSBMdWRvdmljLA0KDQpJIGFtIG5vdCBzdXJlIGFib3V0IHRoZSByZW1vdmFs
IG9mIG1tYy1kZHItMV84djsgdGhpcyBtZWFucyBlTU1DcyANCmNvbm5lY3RlZCBvbiB0aGlzIHNs
b3Qgd29uJ3Qgd29yayBpbiBoaWdoIHNwZWVkIG1vZGUsIHNvbWUgcGVvcGxlIHVzZSANCmVNTUMg
dG8gU0QtQ2FyZCBhZGFwdGVycyBhbmQgc3RpY2sgdGhlbSBpbnRvIFNELUNhcmQgc2xvdHMuDQpX
b3VsZCBpdCBiZSBhIHByb2JsZW0gdG8ga2VlcCB0aGlzIHByb3BlcnR5IGhlcmUgPw0KDQpUaGFu
a3MsDQpFdWdlbg0KDQo+ICAgCQkJc3RhdHVzID0gIm9rYXkiOw0KPiAgIAkJfTsNCj4gICANCj4g
DQoNCg==
