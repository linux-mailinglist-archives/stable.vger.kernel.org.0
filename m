Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1061C2CD9DD
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 16:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgLCPJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 10:09:57 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:52377 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgLCPJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 10:09:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607008196; x=1638544196;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hatktVvAGxduhP/iDLHeSoHdg0yu8IwFJCKrtKXdNkU=;
  b=F3KjFXWhJlCPeN5VHL+xU3XOQIQP2ZDiSnPQr2Sx8zux5AeQTowtxL1Q
   uFMeZH+PFZIpxzdwL/4396ztEo2HKaXh59HYiXUPD2EEHJi2VUD7uAXVw
   efQ3Y2lmMkN0+JCGfoBdqIxITOAgD6jarO1TZ+y+op6dF9oyLkTUvELjJ
   AdDI3JVVOHI9B0JfB7i8ZEOiQqJEthyEZb8RpxrD/c30sVnuLgeYBUovg
   WceGpN/oyd6oL7Imk30ZeT4o9FOJBfNYB9tUWs4sd3Lf2YmgjS1/P/9KM
   meeAptz3cmtUlpihqqXkmYODU5bRgU5vTRhEWUpn11fYQG5EXNJ0sLZJa
   A==;
IronPort-SDR: RdirafogSTcoEl8X3+9Nlq7p1ctQvHppQHcW+TtvuAI0aU12E+EZ5ONqU7hkorEWCYGI+KEEW0
 A6p6u4K4VHIORcTIAuSeTEcZYwPRdWF5VGv1z8erAtzFoCPZA6RLkZL2MhEZpdhWcebcf1jJuZ
 yH1Zzud2Atyp9mXdG23DnTk8eIlRPmaGBLNLXMLqv+7RGIR3Gjd3GU/9qSe/0ZQ878Cgb/d9zu
 NLJHlo2kPm/cuFO4AOPmKWL4op6EjvKj56dXyrh/xku9FFHYSLSziHmpUPKBh43e8feM3PUI4M
 Kss=
X-IronPort-AV: E=Sophos;i="5.78,389,1599548400"; 
   d="scan'208";a="106019743"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Dec 2020 08:08:51 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Dec 2020 08:08:50 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Thu, 3 Dec 2020 08:08:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MTCi+Cb9M86sg2qqxgb8oxzsiWvLe1TBsBhiRr4rXW0XTdQVS2E/6F55IkbhRl2gJarVFYXyJoEgsjkRJSCO6h2PEAacu12613eYDHJ03mkv0kidjLxWNl6ZwWa4G+cDWA4F6JYH0FQyXAUitcMqg6Zir8N8jQKWMAcMQaX3jysfV7xx5q96lyAGygp+7/nt0OPcxsISJcIHvKeahfcu+4vyuoN75dHNQjdyH5t9QhF6rE1ZixdC6j19sPUcol8tf9Mc9f0U+4mCB+1QF+0m7WfAlg/3ixMwutS4S2f0134BcVTnCp4S295ZSYF9Pq/nLgCkd31k2l/oB+E3pR4eLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hatktVvAGxduhP/iDLHeSoHdg0yu8IwFJCKrtKXdNkU=;
 b=gnS/XDb1YySzLhVmjLxkJfIHjX8OqL/cChIu6x4R/4lrSFQGCiiMtNWr1pgi2j+tgpGhhLQF3CLo4ee4RNTFdBqExuHEaM8GB2792rnOvGQEP4h5uJ4JYImEaIqUiyExRiIJYl5/3rHS2Ju1/lyhiA0P6DCgFMDzw7Jb7Ogb6KCVhQ+3+phC58+K4Pq7BQ2ForYUvQGVgq3Vq1TOMTtsPoFZHAjzlsOcyNntoZv1hzXyFcG/v6pNXF/OVUF9h4ft3mG+7+3hroB44ToA5PcybeQNS31km3cSt0wquu4sjQ4e5EnM0G3N4w5d1HFft2HXFfeTUEcK8/NqPJkxYzT8+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hatktVvAGxduhP/iDLHeSoHdg0yu8IwFJCKrtKXdNkU=;
 b=H5XAVbm4qn02wJb0YttES1vcWj5eG4dTeKQi7e2h9Oxej7OGfaw2H7w4ezwllKsufil5XpxbcHvpkeh4+sY5O4cGLT3qEVzyqdOTIisf248bEKNJSNZrl7ZE/7o748V+8altoxkfpzGcuwHEXQwnQGh9WyFXlr4Yhf72JI/49Ws=
Received: from SA2PR11MB4874.namprd11.prod.outlook.com (2603:10b6:806:f9::23)
 by SA2PR11MB4937.namprd11.prod.outlook.com (2603:10b6:806:118::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Thu, 3 Dec
 2020 15:08:49 +0000
Received: from SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::6903:3212:cc9e:761]) by SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::6903:3212:cc9e:761%7]) with mapi id 15.20.3632.020; Thu, 3 Dec 2020
 15:08:49 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <michael@walle.cc>
CC:     <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <miquel.raynal@bootlin.com>, <richard@nod.at>, <vigneshr@ti.com>,
        <boris.brezillon@collabora.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH v7 1/7] mtd: spi-nor: sst: fix BPn bits for the
 SST25VF064C
Thread-Topic: [PATCH v7 1/7] mtd: spi-nor: sst: fix BPn bits for the
 SST25VF064C
Thread-Index: AQHWyYFhbYejLXpUREmrcdCKcR8FGQ==
Date:   Thu, 3 Dec 2020 15:08:49 +0000
Message-ID: <2c66659b-ecff-c6bb-38c1-c1172780c710@microchip.com>
References: <20201202230040.14009-1-michael@walle.cc>
 <20201202230040.14009-2-michael@walle.cc>
 <44be8e3c-86ca-501e-e575-55f17747bda6@microchip.com>
 <bf31d41ca489b5d1b7976bfb8ede88e9@walle.cc>
In-Reply-To: <bf31d41ca489b5d1b7976bfb8ede88e9@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: walle.cc; dkim=none (message not signed)
 header.d=none;walle.cc; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [79.115.63.95]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e2662aa-5998-451b-8fca-08d8979d56dc
x-ms-traffictypediagnostic: SA2PR11MB4937:
x-microsoft-antispam-prvs: <SA2PR11MB49376CE98E94D8759CCFDCC5F0F20@SA2PR11MB4937.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lr1UbR2YNpGO/cIj6E5ptOwqd13MP9cZH1sC/liKVAlR6L02+EmduVNgHQDd0j5K0npjPav3zPjYZdls8cZvSB2dThcEbdjNIZG+9HUopI+ALOOnb2qVOye40KOhkgDxlOSIAb+qEf4GMIbUZgOlvd5frKtwys8aIeiYYXR1Y4pWQcpKqv7GtBPgAivhUcEoT2MQ6rf3pqXaD3UuKx/fhANKXQmUc9EZWGvmirrm6GMxEXd4HfQHaMSD1wMZuAdf3nQkcb79/Tv4QuaCV2X12b4AWVmrAjpUKmGUfVmTDpUw0aOndcWv4EdWVI+qPMzX8qB6ipzRX2S6G0WtKufw5c3BOXiUBAS7RguM4sjqy0MECVsiZGUv0uhGOfhpN1nTcSKTFqMltnXbmGazrfk2ioZlYf+1oT3W3XBoC5whlcQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4874.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(39860400002)(376002)(366004)(86362001)(66946007)(316002)(66476007)(8676002)(66556008)(8936002)(26005)(64756008)(6512007)(31696002)(66446008)(6916009)(5660300002)(83380400001)(31686004)(76116006)(6506007)(54906003)(478600001)(186003)(6486002)(2616005)(36756003)(2906002)(71200400001)(4326008)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TXNWVGFPZ3lCMjNHVmx3VC9mWjRuTUtGbHplZEpLemc0K0E4d3hTSkFRelpD?=
 =?utf-8?B?MExZUCsxbG1QQnhyZE1raEJZd2sxeWl0eERsYy9SL0Z5OUpFWTJLQ1kvTkJK?=
 =?utf-8?B?ZXY0Vjd1bi9QWjZpWHBCendSOG90MHB3Q0Vra1BxMFdDQ3YwUXFEV3lDamRC?=
 =?utf-8?B?TUtWMUVtTXo0VllURXFQU0RqM0NsNUptU3hpN1FkZElWMkZmL201dDEwTTV3?=
 =?utf-8?B?TzAxbnJDQnREYXpVSEhDTGhkSHN5S0R1MEpIb3YrRGhkQlVXWTlGUjlLV0hu?=
 =?utf-8?B?RGFxNTJoRGRkQ2VYczVHeHIwREZxSDZjSS9Rb0ZFRXMxR1FOV3c4QmdoUEkw?=
 =?utf-8?B?WkNsblNuTmtxZ3NuUDVnSlZ5UUw4aWl3U3hLMDNDdFhMb0taRUpvZUNRa25W?=
 =?utf-8?B?SXNRL0ZhME8yNzJDMWlSYWVEMmxIQ05WS3VBazBwQmNMT1I3WXc0RGNhdnVx?=
 =?utf-8?B?ekRsK0hXVmdnbmVuVmJxeWVGMmwvaUcxVnhVeDlsbzNTVUlIY1E5UHNjQ1ox?=
 =?utf-8?B?MTViUnBxU2lyNnBQUGI2RWR0ajhES0IwSHZkQ21IT0F4RlBDcnRyNWIvYU14?=
 =?utf-8?B?SVV5RGJ0cGM5ellwcElqTENhOGpodGVhZTN3UUtUR2dZLzZ0c3VTTk56enow?=
 =?utf-8?B?U21JTVdGeWZwUjZKOXd5QmZJY2pEbWExSXlsVUhkaGFkSnVGaGErZktFeVE1?=
 =?utf-8?B?eDNEUDRJQzBTN1BONjFXdWdwN2lzbnZGRW1WcGNXNWxoS3ZWUVUzbkFxNHVP?=
 =?utf-8?B?cFc5ejRYaENXNWV2b29xbERJQitXamtTNDZOamhVUnlWOWlOekZZT2tMYURL?=
 =?utf-8?B?QlZkd21adi80RzFMUTVCOHR2SEZjaERPU09qVGs5b09RR0FzU1J1MEpTeE16?=
 =?utf-8?B?UGN0dHpxUXVYb3ZCYWdLYmJxdm1TT3JNTVJrSzZSdTErakZRS29yNkRldGxl?=
 =?utf-8?B?dThyMGFMNGhKaklMZFdtRlErcWp5UWM3ZUc4M2w0Ky95bzBMTDVSSWlxNHpE?=
 =?utf-8?B?bTVheXgvWWlqcXQ4U2tCVG84UWlHU2lUK0tyQlJCYm96eVpWRHI0ZnFSOXJE?=
 =?utf-8?B?aEcvMm1CS3YzbTJBcHgrUEhvZUlvakY3UE5sSFVwTEhlcE5KRDdGNHMwaDFO?=
 =?utf-8?B?TjVSR0VEUUZ5YjlJR254eFVmWkpDbzBIS3daMXRRb1cwQWhhSzg2bzNzeTRC?=
 =?utf-8?B?Zm5DbUNxYjRSSkpVbStUdFdEVGlEa3pUYXpkM3VvUmFqQ055MkNNWmhvRUZ3?=
 =?utf-8?B?bzJwc05sWFZuOHN4N1NYbU0xaGI2OE9Od21ZbnZFQUkzMC8rTGFuZDQyQTk4?=
 =?utf-8?Q?PpliP1JEG7w6o=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E662DB3FA43954BAAE5A5A0FF5704D2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4874.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e2662aa-5998-451b-8fca-08d8979d56dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 15:08:49.5432
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H7hkPoWgn1wJAqYf5mwR5di9N0yK0nmp+tXl/4Xxu2B944biMkhN7hiRg+b0WY2J54ln7PYdm93uHg/cJoVvhCGEYtG+dFmyqrEEXswABZ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4937
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTIvMy8yMCA0OjM5IFBNLCBNaWNoYWVsIFdhbGxlIHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJ
TDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBrbm93
IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IEFtIDIwMjAtMTItMDMgMTU6MzQsIHNjaHJpZWIg
VHVkb3IuQW1iYXJ1c0BtaWNyb2NoaXAuY29tOg0KPj4gT24gMTIvMy8yMCAxOjAwIEFNLCBNaWNo
YWVsIFdhbGxlIHdyb3RlOg0KPj4+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mg
b3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cNCj4+PiB0aGUgY29udGVudCBpcyBz
YWZlDQo+Pj4NCj4+PiBUaGlzIGZsYXNoIHBhcnQgYWN0dWFsbHkgaGFzIDQgYmxvY2sgcHJvdGVj
dGlvbiBiaXRzLg0KPj4+DQo+Pj4gUmVwb3J0ZWQtYnk6IFR1ZG9yIEFtYmFydXMgPHR1ZG9yLmFt
YmFydXNAbWljcm9jaGlwLmNvbT4NCj4+PiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZyAjIHY1
LjcrDQo+Pg0KPj4gV2hpbGUgdGhlIHBhdGNoIGlzIGNvcnJlY3QgYWNjb3JkaW5nIHRvIHRoZSBk
YXRhc2hlZXQsIGl0IHdhcw0KPj4gbm90IHRlc3RlZCwgc28gaXQncyBub3QgYSBjYW5kaWRhdGUg
Zm9yIHN0YWJsZS4gSSB3b3VsZCB1cGRhdGUNCj4+IHRoZSBjb21taXQgbWVzc2FnZSB0byBpbmRp
Y2F0ZSB0aGF0IHRoZSB0aGUgcGF0Y2ggd2FzIG1hZGUNCj4+IHNvbGVseSBvbiBkYXRhc2hlZXQg
aW5mbyBhbmQgbm90IHRlc3RlZCwgSSB3b3VsZCBhZGQgdGhlIGZpeGVzDQo+PiB0YWcsIGFuZCBz
dHJpcCBjYy1pbmcgdG8gc3RhYmxlLg0KPiANCj4gV2hhdCBpcyB0aGUgZGlmZmVyZW5jZT8gQW55
IGNvbW1pdCB3aXRoIGEgRml4ZXMgdGFnIHdpbGwgYWxzbyBsYW5kDQo+IGluIHRoZSBzdGFibGUg
dHJlZXMuIEp1c3QgdGhhdCBpdCB3aWxsIGNhdXNlIGNvbXBpbGUgZXJyb3JzIGZvcg0KPiBrZXJu
ZWwgb2xkZXIgdGhhbiA1LjcuDQo+IA0KPiBTbyBpZiB5b3UgZG9uJ3Qgd2FudCB0byBoYXZlIGl0
IGluIHN0YWJsZSB0aGVuIHlvdSBtdXN0IG5vdCBhZGQNCj4gYSBGaXhlczogdGFnIGVpdGhlci4N
Cj4gDQoNCkRvY3VtZW50YXRpb24vcHJvY2Vzcy9zdGFibGUta2VybmVsLXJ1bGVzLnJzdCBkb2Vz
bid0IHNheSB0aGF0IHRoZQ0KRml4ZXMgdGFnIGlzIGEgZ3VhcmFudGVlIHRoYXQgYSBwYXRjaCB3
aWxsIGhpdCB0aGUgc3RhYmxlIGtlcm5lbHMuDQoNClNpbmNlIHRoaXMgcGF0Y2ggd2FzIG5vdCB0
ZXN0ZWQsIGl0J3Mgbm90IGEgY2FuZGlkYXRlIGZvciBzdGFibGUgYXMNCnBlciB0aGUgZmlyc3Qg
cnVsZS4gSXQncyBhIHRoZW9yZXRpY2FsIGZpeCwgYmVjYXVzZSBpdCBzaG91bGQgaW5kZWVkDQpm
aXggdGhlIGxvY2tpbmcgYXMgcGVyIHRoZSBkYXRhc2hlZXQuIEV2ZW4gZm9yIHRoZW9yZXRpY2Fs
IGZpeGVzLCBJDQp3b3VsZCBsaWtlIHRvIGtub3cgd2hhdCBjb21taXQgYnJva2UgdGhlIGZ1bmN0
aW9uYWxpdHksIGFuZCB0aGF0J3Mgd2h5DQpJIGFza2VkIGZvciB0aGUgRml4ZXMgdGFnLg0KDQpX
ZSBkb24ndCB3YW50IHRoZSBwYXRjaCBpbiBzdGFibGUsIHNvIHRoYXQncyB3aHkgSSBzYWlkIHRo
YXQgSSB3b3VsZA0KaW5kaWNhdGUgaW4gdGhlIGNvbW1pdCBtZXNzYWdlIHRoYXQgaXQgd2FzIG5v
dCB0ZXN0ZWQsIGFuZCB0aGF0IEkNCndvdWxkIHN0cmlwIHRoZSBjYyB0byBzdGFibGUuDQoNCk1h
eWJlIGl0J3MganVzdCBteSB1bmRlcnN0YW5kaW5nLiBPdGhlcnMgbWF5IGhlbHAuDQo=
