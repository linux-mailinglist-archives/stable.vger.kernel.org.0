Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB97B22F6AF
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 19:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731139AbgG0RbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 13:31:09 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:30165 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731077AbgG0RbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 13:31:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595871068; x=1627407068;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=l0ZayIw44r6V8etQUYHJX3WOb5G8HO0iF2lsbu5HMXk=;
  b=kYEwMnpiRY5icIGlhWF5A1p/F+AtjFaxbeu3qlJg0QkFycpesib57xwR
   vQ11Zd9DJq+img4UbgJooF23KZHpRif2B4mdTjX/zsutlw8VB3mIgdIWo
   kbmddITfk4MXd1zpAER306tvAthq8oc7qgY9FnAWgCjg/io1diOzLSOuQ
   nQU5GcUN+eBLmLO0q1lY6UzZBKxh/7HCU0oWgyC3zNoJ1ZpQKd4ojTMRr
   TOoTSPinyZPg2+yrd4rkJlx2zGtivwKOOPzGGZRUjHGlkAb9ON0Ayz1Pt
   aGnY6urmIRUp4/h3M3IqTRqmhBAkAO2JcM1vaovMuwi6ZHSD1y5UJ7fgX
   A==;
IronPort-SDR: kmzU8VzNT9GMEHEexPjOJDMMlfdl1ELlm2AS6BACT9bt44rkgdG4P3dLLeBgcDH8uZQNWebcwl
 lXBZTr8DZL7iGSs2eNZK2UPaPZNKg8E3SJUo6jsvt20mVGVBd3qd5DJVpj5nzqpk+I04Hv9NXz
 X2CGNjUMA+sVxKpD/ZTmG8HWcvPtQ6d5hpam0wuKqA354ybXqKDnjdKrmhpJDuYvmBq+K1dnte
 4Zhw8hDHYMvLFPwlR9vNr6w36aWQIZwDb6bwr3/XrOqosWYMXcl0RNsYW/7Tthe6/ORBovnedy
 9vE=
X-IronPort-AV: E=Sophos;i="5.75,402,1589212800"; 
   d="scan'208";a="143580257"
Received: from mail-sn1nam02lp2057.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.57])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jul 2020 01:31:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QiG812qbbITqysO5VHUqSxgbOIqkHLT+a0OdCjcu8SbUGyOl8h3ps0QdSkiF4iDH6q4Tz5CqalsU40zyxU9Aoze49WcV1xjQir1LDq8QhI7IueeeYsHgHmR+wQrJZPdRNbIGtDODu4B1AEf+QmesIxD1O/srLgDf0StR2T0MedSGHy/+sz2LnPbZsXLWFMTRB0JbTPJwOstjn1mGDnPRBo+a5gIVC+XmxdObFdVhmCffc35rgIxCAO/qQC0c0Kg3idFGhQERGoDzRAJf6lOKOiepgobWGpQcHXuhgvACq/HYujkuL7W27zzZFcSWZTuG7TRYlfzWhTJPb8rmEB/yXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l0ZayIw44r6V8etQUYHJX3WOb5G8HO0iF2lsbu5HMXk=;
 b=CurjyoAG6DihOCo+Uy+ai9uSgDTXaPcuQEWm41FQsAJ3ZcDkdJmQaHp/ERmoTs2TIhEwjSpxcc6fj8vpnCaz0PzSk0EHx1FPDi+lIup7pNQY076Gvq6rDHkMG0t+sch3Tmu1kgar0brnkJfa/cweiyW1x8PlS29MGHGBLqCglm8blAs/skSDHsLDLRyewx7iEknUWlg4bIYQIqhlHHf0+It7ML7lmobg6VQEVXV1q0d/866eGJG7vQqKM9bdUPZ4tR96WCU3WJ6C3PeUJRS6ftS70/IEfgi15VaEwyuxAKqIMKdA/+8mjVBQx+sOvz3HvxgbPKNXeCPzaqCzHcdTZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l0ZayIw44r6V8etQUYHJX3WOb5G8HO0iF2lsbu5HMXk=;
 b=SZTpbTYcGFAQVKV//HwrgXR+jkGDmjvdSYkevjagsZ4HnzykKURiqasBwalDNTKeRwR357dtxRTs3Y7QGQD4vsdIDwSCJXhEG5x1qOAwIKCWlwv+5TyTZdiP6dfk4PzXwFW+4Tmg8Bt/6hdgy0INf8NuYFw3JRYQV8GjsKnUDbE=
Received: from BY5PR04MB6724.namprd04.prod.outlook.com (2603:10b6:a03:219::15)
 by BYAPR04MB5349.namprd04.prod.outlook.com (2603:10b6:a03:ca::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.26; Mon, 27 Jul
 2020 17:31:05 +0000
Received: from BY5PR04MB6724.namprd04.prod.outlook.com
 ([fe80::90f3:1abd:2ec8:a91a]) by BY5PR04MB6724.namprd04.prod.outlook.com
 ([fe80::90f3:1abd:2ec8:a91a%9]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 17:31:05 +0000
From:   Atish Patra <Atish.Patra@wdc.com>
To:     "shorne@gmail.com" <shorne@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "walken@google.com" <walken@google.com>,
        "naresh.kamboju@linaro.org" <naresh.kamboju@linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "palmerdabbelt@google.com" <palmerdabbelt@google.com>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zong.li@sifive.com" <zong.li@sifive.com>
Subject: Re: [PATCH 5.7 233/244] RISC-V: Acquire mmap lock before invoking
 walk_page_range
Thread-Topic: [PATCH 5.7 233/244] RISC-V: Acquire mmap lock before invoking
 walk_page_range
Thread-Index: AQHWXrETjDxZGeRGbk6/4QyqHlR0zKkQvJIAgAATOoCAAAaugIABztSAgADqJ4CAACfuAIAA478AgAce4QA=
Date:   Mon, 27 Jul 2020 17:31:04 +0000
Message-ID: <4e48b5e0815a5cfa484c2988c1a0f2abd8f0ecd3.camel@wdc.com>
References: <20200720191403.GB1529125@kroah.com>
         <mhng-903745bf-c5df-4e70-ade8-c1e596265fc4@palmerdabbelt-glaptop1>
         <20200722124839.GB3155653@kroah.com>
         <0fcbb91ab6dc49807dcca953c5dca673ad403045.camel@wdc.com>
         <20200723044642.GA80756@lianli.shorne-pla.net>
In-Reply-To: <20200723044642.GA80756@lianli.shorne-pla.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.44.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 05d2fe78-afb5-4967-4781-08d83252d71a
x-ms-traffictypediagnostic: BYAPR04MB5349:
x-microsoft-antispam-prvs: <BYAPR04MB53498B415AE210F2A5C00622FA720@BYAPR04MB5349.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lfE5SzczCAgSLP5G/wHeAVmp2VYcDdB0rm+widz7PN7SoHRIIrhjjDx5hW9wNc+qqNaZPde67al57n6hQGA4bqpR8241tEY9i5uLDrG/5NawtJVhHnu7qcrsTdDK+vjd5A00IblRGd+dLQIF/BpAPOktt3FHaPuKe2UQQeEYVWmh3O4BvzA0SGb/dW0TrVQ8r/qHmSN8OmCjdp95E7QfHT2h+98/0HJohQExh0OwnhENGS71w48IwiNsakRmcxDl4BLYNneDL2R6ipjupkqpsvNJvVVK7PbuKnCE1qvkOo4QhSd14300h9EbIf66g2f/3Rw7D1sEnLMmP3La36Zgb0o7nNYfdcmmGhMYDOHiZ4Ohtbgi8W5Mix3M8LQnF32MlHU2wb1pe0yTDNrDPJZ4Qg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6724.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(366004)(136003)(346002)(396003)(83380400001)(2616005)(54906003)(2906002)(6486002)(36756003)(316002)(76116006)(4326008)(110136005)(8676002)(5660300002)(66556008)(66476007)(64756008)(186003)(66446008)(966005)(66946007)(26005)(71200400001)(8936002)(6512007)(6506007)(86362001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: whFDV4xCnn0WmYfgqqmt0m5zgaDlirxGKrmRgvlrsaZdjEcm24bCLb+T8yeEh4JUzsObP4cmOnHbOZt4AJ5tfdotjLPlR8CxawOb+blD9/Hy6Z3xby0/qpAfWBufhWaCVKyIzOewg4SDS1pftX6B0V9MukP+nzE3hjL+jhjcJ84S2uuRepm4hwVCTVDPXf/HEX0W+P/sPSfjb1RI7zMwqR8ELBRcHmxK1+FkZrRdOzjKPiPEu8M25GnJVSeRL+J4WiuuXlJvH2KgwlksPVXIAAPB/dWzlhVSLdFHZC+jTfLiKDXuckdX/KylTP0rjHbvfOI4Bo3naAyONp0C5I804QnvvULR+YqIVq6WuaihYmc/aTte02CVm92TK7OrUPZx6lUTLyXUOh3tXcFvrtRDWtJD8nH4BjEQ6Sn9ga/HynOhoo9+IchcOESw/52KZlIcbJg2821Vv/ldfL6Swgn3xmZeWHGr8RSjiEFJ95vNA6FBme+wMICpMCRS7HTeo+mi
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <FAECE01788A3104FA93B7076F0746D80@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6724.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05d2fe78-afb5-4967-4781-08d83252d71a
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2020 17:31:04.8584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MEniA0IKDbTW7iz4DKhg5c8Qfi6cfgHmN7BR7mnhmvoCLUya5IRhzF4hZN+BSP/xzyVJkgxf6c5czGXybySTiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5349
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDIwLTA3LTIzIGF0IDEzOjQ2ICswOTAwLCBTdGFmZm9yZCBIb3JuZSB3cm90ZToN
Cj4gT24gV2VkLCBKdWwgMjIsIDIwMjAgYXQgMDM6MTE6MzVQTSArMDAwMCwgQXRpc2ggUGF0cmEg
d3JvdGU6DQo+ID4gT24gV2VkLCAyMDIwLTA3LTIyIGF0IDE0OjQ4ICswMjAwLCBHcmVnIEtIIHdy
b3RlOg0KPiA+ID4gT24gVHVlLCBKdWwgMjEsIDIwMjAgYXQgMDM6NTA6MzVQTSAtMDcwMCwgUGFs
bWVyIERhYmJlbHQgd3JvdGU6DQo+ID4gPiA+IE9uIE1vbiwgMjAgSnVsIDIwMjAgMTI6MTQ6MDMg
UERUICgtMDcwMCksIEdyZWcgS0ggd3JvdGU6DQo+ID4gPiA+ID4gT24gTW9uLCBKdWwgMjAsIDIw
MjAgYXQgMDY6NTA6MTBQTSArMDAwMCwgQXRpc2ggUGF0cmEgd3JvdGU6DQo+ID4gPiA+ID4gPiBP
biBNb24sIDIwMjAtMDctMjAgYXQgMjM6MTEgKzA1MzAsIE5hcmVzaCBLYW1ib2p1IHdyb3RlOg0K
PiA+ID4gPiA+ID4gPiBSSVNDLVYgYnVpbGQgYnJlYWtzIG9uIHN0YWJsZS1yYyA1LjcgYnJhbmNo
Lg0KPiA+ID4gPiA+ID4gPiBidWlsZCBmYWlsZWQgd2l0aCBnY2MtOCwgZ2NjLTkgYW5kIGdjYy05
Lg0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gU29ycnkgZm9yIHRo
ZSBjb21waWxhdGlvbiBpc3N1ZS4NCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gbW1hcF9yZWFk
X2xvY2sgd2FzIGludHJkb3VjZWQgaW4gdGhlIGZvbGxvd2luZyBjb21taXQuDQo+ID4gPiA+ID4g
PiANCj4gPiA+ID4gPiA+IGNvbW1pdCA5NzQwY2E0ZTk1YjQNCj4gPiA+ID4gPiA+IEF1dGhvcjog
TWljaGVsIExlc3BpbmFzc2UgPHdhbGtlbkBnb29nbGUuY29tPg0KPiA+ID4gPiA+ID4gRGF0ZTog
ICBNb24gSnVuIDggMjE6MzM6MTQgMjAyMCAtMDcwMA0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
PiAgICAgbW1hcCBsb2NraW5nIEFQSTogaW5pdGlhbCBpbXBsZW1lbnRhdGlvbiBhcyByd3NlbQ0K
PiA+ID4gPiA+ID4gd3JhcHBlcnMNCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gVGhlIGZvbGxv
d2luZyB0d28gY29tbWl0cyByZXBsYWNlZCB0aGUgdXNhZ2Ugb2YgbW1hcF9zZW0NCj4gPiA+ID4g
PiA+IHJ3c2VtDQo+ID4gPiA+ID4gPiBjYWxscw0KPiA+ID4gPiA+ID4gd2l0aCBtbWFwX2xvY2su
DQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IGQ4ZWQ0NWM1ZGNkNCAobW1hcCBsb2NraW5nIEFQ
STogdXNlIGNvY2NpbmVsbGUgdG8gY29udmVydA0KPiA+ID4gPiA+ID4gbW1hcF9zZW0NCj4gPiA+
ID4gPiA+IHJ3c2VtIGNhbGwgc2l0ZXMpDQo+ID4gPiA+ID4gPiA4OTE1NGRkNTMxM2YgKG1tYXAg
bG9ja2luZyBBUEk6IGNvbnZlcnQgbW1hcF9zZW0gY2FsbCBzaXRlcw0KPiA+ID4gPiA+ID4gbWlz
c2VkIGJ5DQo+ID4gPiA+ID4gPiBjb2NjaW5lbGxlKQ0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
PiBUaGUgZmlyc3QgY29tbWl0IGlzIG5vdCBwcmVzZW50IGluIHN0YWxlIDUuNy15IGZvciBvYnZp
b3VzDQo+ID4gPiA+ID4gPiByZWFzb25zLg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBEbyB3
ZSBuZWVkIHRvIHNlbmQgYSBzZXBhcmF0ZSBwYXRjaCBvbmx5IGZvciBzdGFibGUgYnJhbmNoDQo+
ID4gPiA+ID4gPiB3aXRoDQo+ID4gPiA+ID4gPiBtbWFwX3NlbSA/IEkgYW0gbm90IHN1cmUgaWYg
dGhhdCB3aWxsIGNhdXNlIGEgY29uZmxpY3QNCj4gPiA+ID4gPiA+IGFnYWluIGluDQo+ID4gPiA+
ID4gPiBmdXR1cmUuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gSSBkbyBub3QgbGlrZSB0YWtpbmcg
b2RkIGJhY2twb3J0cywgYW5kIHdvdWxkIHJhdGhlciB0YWtlIHRoZQ0KPiA+ID4gPiA+IHJlYWwg
cGF0Y2gNCj4gPiA+ID4gPiB0aGF0IGlzIHVwc3RyZWFtLg0KPiA+ID4gPiANCj4gPiA+ID4gSSBn
dWVzcyBJJ20gYSBiaXQgbmV3IHRvIHN0YWJsZSBiYWNrcG9ydHMgc28gSSdtIG5vdCBzdXJlDQo+
ID4gPiA+IHdoYXQncw0KPiA+ID4gPiBleHBlY3RlZCBoZXJlLg0KPiA+ID4gPiBUaGUgZmFpbGlu
ZyBwYXRjaCBmaXhlcyBhIGJ1ZyBieSB1c2luZyBhIG5ldyBpbnRlcmZhY2UuICBUaGUNCj4gPiA+
ID4gc21hbGxlc3QgZGlmZiBmaXgNCj4gPiA+ID4gZm9yIHRoZSBzdGFibGUga2VybmVscyB3b3Vs
ZCBiZSB0byBjb25zdHJ1Y3QgYSBzaW1pbGFyIGZpeA0KPiA+ID4gPiB3aXRob3V0DQo+ID4gPiA+
IHRoZSBuZXcNCj4gPiA+ID4gaW50ZXJmYWNlLCB3aGljaCBpbiB0aGlzIGNhc2UgaXMgdmVyeSBl
YXN5IGFzIHRoZSBuZXcgaW50ZXJmYWNlDQo+ID4gPiA+IGp1c3QgY29udmVydGVkDQo+ID4gPiA+
IHNvbWUgZ2VuZXJpYyBsb2NraW5nIGNhbGxzIHRvIG9uZS1saW5lIGZ1bmN0aW9ucy4gIEl0IHNl
ZW1zDQo+ID4gPiA+IHNvbWV3aGF0IGNpcmN1aXRvdXMNCj4gPiA+ID4gdG8gbGFuZCB0aGF0IGlu
IExpbnVzJyB0cmVlLCB0aG91Z2gsIGFzIGl0IHdvdWxkIHJlcXVpcmUNCj4gPiA+ID4gYnJlYWtp
bmcNCj4gPiA+ID4gb3VyIHBvcnQNCj4gPiA+ID4gYmVmb3JlIGZpeGluZyBpdCB0byB1c2UgdGhl
IG9sZCBpbnRlcmZhY2VzIGFuZCB0aGVuIGNsZWFuaW5nIGl0DQo+ID4gPiA+IHVwDQo+ID4gPiA+
IHRvIHVzZSB0aGUNCj4gPiA+ID4gbmV3IGludGVyZmFjZXMuDQo+ID4gPiA+IA0KPiA+ID4gPiBB
cmUgd2UgZXhwZWN0ZWQgdG8gcHVsbCB0aGUgbmV3IGludGVyZmFjZSBvbnRvIHN0YWJsZSBpbg0K
PiA+ID4gPiBhZGRpdGlvbg0KPiA+ID4gPiB0byB0aGlzIGZpeD8NCj4gPiA+IA0KPiA+ID4gSWYg
aXQgcmVhbGx5IGRvZXMgZml4IGEgYmlnIGlzc3VlLCB5ZXMsIHRoYXQgaXMgZmluZSB0byBkby4N
Cj4gPiA+IA0KPiA+IA0KPiA+IFRoZSBvcmlnaW5hbCBpc3N1ZSB3YXMgbWFuaWZlc3RzIG9ubHkg
Zm9yIGNlcnRhaW4gcm9vdGZzIHdpdGgNCj4gPiBDT05GSUdfREVCVUdfVk0gZW5hYmxlZCBpbiBr
ZXJuZWwuIEkgYW0gbm90IHN1cmUgaWYgdGhhdCBxdWFsZmllcw0KPiA+IGZvciBhDQo+ID4gYmln
IGlzc3VlIDopLiBCdXQgdGhlcmUgd2FzIGEgc2ltaWxhciBmaXggZm9yIE9wZW5SSVNDIGFzIHdl
bGwuDQo+ID4gDQo+ID4gK3N0YWZmb3JkICh3aG8gZml4ZWQgdGhlIGlzc3VlIGZvciBPcGVuUklT
QykNCj4gPiANCj4gPiBAc3RhZmZvcmQgV2FzIHRoZXJlIGEgcmVxdWVzdCB0byBiYWNrcG9ydCB0
aGUgZml4IHRvIHN0YWJsZSA/DQo+IA0KPiBJIGhhdmUgbm90IHJlcXVlc3RlZCAgcHVsbGluZyBt
eSBwYXRjaCB0byBzdGFibGUuICBNaW5lIGlzIHRoaXMgb25lOg0KPiANCj4gICAzMTNhNTI1N2I4
NGMyICgib3BlbnJpc2M6IGZpeCBib290IG9vcHMgd2hlbiBERUJVR19WTSBpcyBlbmFibGVkIikN
Cj4gDQo+IElmIHlvdSBjYXQgcmVxdWVzdCB0aGF0IHdvdWxkIGJlIGdyZWF0Lg0KPiANCj4gPiBJ
IGNhbiBjb21iaW5lIGFsbCB0aGUgZ2l0IGlkcyB0aGF0IG5lZWRzIHRvIGJlIHB1bGxlZCBpbi4N
Cj4gDQo+IE5vdGUsIG1pbmUgbGlzdHM6DQo+IA0KPiAgIEZpeGVzOiA0MmZjNTQxNDA0ZjIgKCJt
bWFwIGxvY2tpbmcgQVBJOiBhZGQgbW1hcF9hc3NlcnRfbG9ja2VkKCkNCj4gYW5kIG1tYXBfYXNz
ZXJ0X3dyaXRlX2xvY2tlZCgpIikNCj4gDQo+IHdoaWxlIHlvdXIncyBsaXN0czoNCj4gDQo+ICAg
Rml4ZXM6IDM5NWEyMWZmODU5YyhyaXNjdjogYWRkIEFSQ0hfSEFTX1NFVF9ESVJFQ1RfTUFQIHN1
cHBvcnQpDQo+IA0KPiBUaGF0IGlzIHdoZW4gdGhlIGNvZGUgd2FzIGludHJvZHVjZWQgdG8gdGhl
IHJpc2N2IHBvcnQsIGJ1dCBub3QgdGhlDQo+IGNvbW1pdCB0aGF0DQo+IGJyb2tlIGJvb3Rpbmcu
DQo+IA0KPiBJIHRoaW5rIGlmIHlvdSBsaXN0IHRoZSBGaXhlcyBhcyBJIGRpZCB3aGVuIGJhY2tw
b3J0aW5nIHRvIHN0YWJsZQ0KPiBHcmVnLCBvciBoaXMNCj4gdG9vbHMsIHdvdWxkIGFsc28ga25v
dyB0aGF0IHRoZSBwYXRjaCBkZXBlbmRzIG9uIHRoZSB0aGUgNDJmYzU0MTQwNGYyDQo+IGNvbW1p
dC4NCj4gDQo+IEFsc28sIEkgZ3Vlc3MgdGhlcmUgaXMgbm8gcHJvYmxlbSB3aXRoIGxpc3Rpbmcg
MiAiRml4ZXMiIGluIHRoZQ0KPiBmdXR1cmUuDQo+IA0KDQpUaGFua3MuIEkgd2lsbCBrZWVwIHRo
YXQgaW4gbWluZCBpbiBmdXR1cmUuDQoNCkJhY2twb3J0aW5nIHRoZSBSSVNDLVYgZml4IHdvdWxk
IHJlcXVpcmUgdGhlIG9yaWdpbmFsIGNvbW1pdCB0byBiZQ0KYmFja3BvcnRlZCBhcyB3ZWxsLg0K
DQpjb21taXQgOTc0MGNhNGU5NWI0IChtbWFwIGxvY2tpbmcgQVBJOiBpbml0aWFsIGltcGxlbWVu
dGF0aW9uIGFzIHJ3c2VtDQp3cmFwcGVycykNCg0KSG93ZXZlciwgdGhhdCBpcyB0aGUgZmlyc3Qg
Y29tbWl0IGZvciBiaWcgY2xlYW51cCAxMiBwYXRjaCBzZXJpZXMuDQpodHRwczovL2xrbWwub3Jn
L2xrbWwvMjAyMC81LzIwLzU2DQoNCldoaWxlIGJhY2twb3J0aW5nIHRoZSBmaXJzdCBjb21taXQg
KDk3NDBjYTRlOTViNCkgd291bGQgc29sdmUgdGhlDQpwcm9ibGVtIGZvciBSSVNDLVYsIGFsbCBv
dGhlciBhcmNoaXRlY3R1cmUgZml4ZXMgd29uJ3QgYmUgdGhlcmUuDQpEbyB3ZSB3YW50IHRoYXQg
aW4gc3RhYmxlIHRyZWU/DQoNCg0KPiBUaGFua3MgQXRpc2ggYW5kIFBhbG1lci4NCj4gDQo+IC1T
dGFmZm9yZA0KPiANCj4gPiA+ID4gVGhlIG5ldyBpbnRlcmZhY2UgZG9lc24ndCBhY3R1YWxseSBm
aXggYW55dGhpbmcgaXRzZWxmLCBidXQgaXQNCj4gPiA+ID4gd291bGQgYWxsb3cgYQ0KPiA+ID4g
PiBmdW5jdGlvbmFsIGtlcm5lbCB0byBiZSBjb25zdHJ1Y3RlZCB0aGF0IGNvbnNpc3RlZCBvZiBv
bmx5DQo+ID4gPiA+IGJhY2twb3J0cyBmcm9tDQo+ID4gPiA+IExpbnVzJyB0cmVlICh3aGljaCB3
b3VsZCBhbHNvIG1ha2UgZnVydGhlciBmaXhlcyBlYXNpZXIpLg0KPiA+ID4gDQo+ID4gPiBUaGF0
J3MgZmluZS4NCj4gPiA+IA0KPiA+ID4gPiBJdCBzZWVtcyBzYWZlIHRvDQo+ID4gPiA+IGp1c3Qg
cHVsbCBpbiA5NzQwY2E0ZTk1YjQgKCJtbWFwIGxvY2tpbmcgQVBJOiBpbml0aWFsDQo+ID4gPiA+
IGltcGxlbWVudGF0aW9uIGFzIHJ3c2VtDQo+ID4gPiA+IHdyYXBwZXJzIikgYmVmb3JlIHRoaXMg
ZmFpbGluZyBwYXRjaCwgYXMgaW4gdGhpcyBjYXNlIHRoZSBuZXcNCj4gPiA+ID4gaW50ZXJmYWNl
IHdpbGwNCj4gPiA+ID4gZnVuY3Rpb24gY29ycmVjdGx5IHdpdGggb25seSBhIHN1YnNldCBvZiBj
YWxsZXJzIGhhdmluZyBiZWVuDQo+ID4gPiA+IGNvbnZlcnRlZC4gIE9mDQo+ID4gPiA+IGNvdXJz
ZSB0aGF0J3Mgbm90IGEgZ2VuZXJhbGx5IHRydWUgc3RhdGVtZW50IHNvIEkgZG9uJ3Qga25vdyBp
Zg0KPiA+ID4gPiBmdXR1cmUgY29kZQ0KPiA+ID4gPiB3aWxsIGJlaGF2ZSB0aGF0IHdheSwgYnV0
IHB1bGxpbmcgaW4gdGhvc2UgY29udmVyc2lvbiBwYXRjaGVzDQo+ID4gPiA+IGlzDQo+ID4gPiA+
IGRlZmluaXRlbHkNCj4gPiA+ID4gdW5uZWNlc3NhcnkgZGlmZiByaWdodCBub3cuDQo+ID4gPiAN
Cj4gPiA+IElmIHNvbWVvbmUgd2FudHMgdG8gc2VuZCBtZSBhIGZ1bGwgc2V0IG9mIHRoZSBnaXQg
aWRzIHRoYXQgbmVlZA0KPiA+ID4gdG8gYmUNCj4gPiA+IHB1bGxlZCBpbiwgSSB3aWxsIGJlIGds
YWQgdG8gZG8gc28uDQo+ID4gPiANCj4gPiA+IHRoYW5rcywNCj4gPiA+IA0KPiA+ID4gZ3JlZyBr
LWgNCj4gPiANCj4gPiAtLSANCj4gPiBSZWdhcmRzLA0KPiA+IEF0aXNoDQoNCi0tIA0KUmVnYXJk
cywNCkF0aXNoDQo=
