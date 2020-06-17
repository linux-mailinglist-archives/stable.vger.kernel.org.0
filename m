Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F4E1FC9BF
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 11:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725773AbgFQJXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 05:23:04 -0400
Received: from mo-csw1116.securemx.jp ([210.130.202.158]:35866 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgFQJXD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jun 2020 05:23:03 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id 05H9MnGw015535; Wed, 17 Jun 2020 18:22:49 +0900
X-Iguazu-Qid: 2wHHD3mJ12YGf7zPsW
X-Iguazu-QSIG: v=2; s=0; t=1592385769; q=2wHHD3mJ12YGf7zPsW; m=UsL2tXmrIBWdSrLrma6RDFrpMr88HoeSKulsTF551b0=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1112) id 05H9MlsN033518;
        Wed, 17 Jun 2020 18:22:48 +0900
Received: from enc01.localdomain ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id 05H9Mlw1029734;
        Wed, 17 Jun 2020 18:22:47 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.localdomain  with ESMTP id 05H9MlsQ029919;
        Wed, 17 Jun 2020 18:22:47 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FUC4iVndKCxZNVZ2cPgAT5102ZzzDwmgItRp1EClA/8GQAy8QFgRIO/BKnCoNLQ/qF10WCq5iTT5jddxcP95WsWs71IZ4y5ezqftMherc5nqev8yy7o+PEg3A6zmvLN3HK8KvIqeBwoVE/m6hpe4HbvfOkMCVMa6c88oqbDmHEDFF3xUx+8chT+EUfLgJ9EHZRZHyKwOCimZ/6WL9pFw4QYeVkLqgBqsGIwd2yvvCJVlK5bRcS5w23krVOGBHQ25WRjSD3h+6hZSm/9LqXVYvj7SJOhAENkxv1MTZ9lpj5ecva6tAGxWyw9ylFu26M2vkAr4WRrRxs84v6zOaRgXIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qwncW059pYP/GwtInLlmciiGGu+Fy6HBVDG2IUM2D+w=;
 b=Hrjd76JAbSKXDTTxDzCMyKeOGJ6zhoBcKZeD/Z3YWgboNxI6pYznHg8GM4SYeh64dIGW9+1/Xnbd7fBY/wSAuUnG5w+zOz/zXC8ig4QBK+TM67U/AtmMg01QS7IdEz4nwZ9jnTnXfv/zMZgKXc4nvfXiClFLjd9yEyD4QMwsMVRKQfpkDxTyFvAkfplBUTGrNGLnRFLuR9UcXT9lMPGY11Bd+hhZvXOa8c4AK7P5HKl6p88pHV/0AmM75AhE2gZ0948ra0IstUyZ6vWomYadu5m9/sBK6XA1RZ/Q7roMZL9hUIR1rweLUKuyWhGmEPDHulo+guOb/fU7UhkvEDXAOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toshiba.co.jp; dmarc=pass action=none
 header.from=toshiba.co.jp; dkim=pass header.d=toshiba.co.jp; arc=none
From:   <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, <ardb@kernel.org>,
        <rafael.j.wysocki@intel.com>
Subject: RE: [PATCH 5.4 064/134] ACPI: GED: add support for _Exx / _Lxx
 handler methods
Thread-Topic: [PATCH 5.4 064/134] ACPI: GED: add support for _Exx / _Lxx
 handler methods
Thread-Index: AQHWQ/Q8j4hpKScBzEO+XPSykaTGM6jciEDA
Date:   Wed, 17 Jun 2020 09:22:45 +0000
X-TSB-HOP: ON
Message-ID: <OSBPR01MB29835381F4879AF2614194F3929A0@OSBPR01MB2983.jpnprd01.prod.outlook.com>
References: <20200616153100.633279950@linuxfoundation.org>
 <20200616153103.838898964@linuxfoundation.org>
In-Reply-To: <20200616153103.838898964@linuxfoundation.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=toshiba.co.jp;
x-originating-ip: [103.91.184.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 65d11443-c1f2-443e-fb6b-08d8129ffee4
x-ms-traffictypediagnostic: OSBPR01MB4904:
x-microsoft-antispam-prvs: <OSBPR01MB4904B2042AA7776DDDE3E7D2929A0@OSBPR01MB4904.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:800;
x-forefront-prvs: 04371797A5
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3iyxxJDdlq3gSI6PdSFE7EYRAc1YHaldH9eM6KcoKpxmL0gIi4lB+DbTPJDz1tPJIK4A4r7WteqGKB5Ed2uIubfArhO8ManygVhyVnNuj3ync4whfjCkGNri8AmUoqHXPLFJy0FQd6SfZN6H3vjjOFQpGQnveAgP68HHZuwRZn6HJkVgUeW6926y/L/WmtYke0UFPTE0bJS86cVzguGhS7QE3U1uMdBZm2tCQPuNhsxEnikeX2Qmxsw9UoyJO27ESNUEHLdC8pPEFaUsJOKDH8OA0csxQeprB98KcpchKot2ysat2R2mGlTLcFtUIf9pDHBlK+NV/W75up/IOVKIbw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSBPR01MB2983.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(376002)(366004)(136003)(39860400002)(71200400001)(52536014)(8676002)(110136005)(26005)(86362001)(33656002)(5660300002)(4326008)(83380400001)(2906002)(53546011)(8936002)(478600001)(66476007)(66946007)(54906003)(64756008)(66556008)(66446008)(7696005)(76116006)(55016002)(6506007)(9686003)(186003)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: /TaJVV11sfXdY3QoK6gQOFC+lgMmuWXopgZBS6TVt3FJ4tXgZOKtueMvOPz62FOjIZdE/7lg+HZ3T+Ib8KNqNHerQfDK0AsJ/FhEVLn3EKr8k/YD/bCNtoRKVmDYqtLZvd9b5q7J4YnhslCtD5JYUXl1wpjGBIGRsvAX6bXvo34ZpUfhB4UUHO7xGV+UkBOtavb+cgyhmBJZjmIuyVqGnJGKK2ZFMgycgObgheRhODYyJhnNzKPwP43DcazzPhqGap1YyuklmXtBGYU7KfWlcwSRWcrlhk+pIKQddKH1O9GCjYNsxKcOzoqW7p2D+lDX0qO38etixVVq+8eAih4GI8hlcFE132I/qw8F2gJriOtesZjy/hDHHGmm6OPxx/fjIKuFHiIzZkm3prUNZt851F1wtsjNSrK8lKU5Iwy2qFY8YAEXvt/KYIX5RR/LHEw8FR4ceeHSEVrlXvCb46oJjmv+a10Fw8nUviVKbXYP3Vc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 65d11443-c1f2-443e-fb6b-08d8129ffee4
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2020 09:22:45.7635
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f109924e-fb71-4ba0-b2cc-65dcdf6fbe4f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sMVrsaZS/zAT5Mbuizq4nQftMq9JUMw98j5MPlnvH2lgEy7D3Od4UX19rhoniiPUqorzQPiVtajrB7k+JBH7eMS2pjSdUidWo3/b0/f492UK4gCB72lm7upn2bTAQ/vd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB4904
X-OriginatorOrg: toshiba.co.jp
MSSCP.TransferMailToMossAgent: 103
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogc3RhYmxlLW93bmVy
QHZnZXIua2VybmVsLm9yZyBbbWFpbHRvOnN0YWJsZS1vd25lckB2Z2VyLmtlcm5lbC5vcmddIE9u
IEJlaGFsZiBPZiBHcmVnIEtyb2FoLUhhcnRtYW4NCj4gU2VudDogV2VkbmVzZGF5LCBKdW5lIDE3
LCAyMDIwIDEyOjM0IEFNDQo+IFRvOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IENj
OiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPjsgc3RhYmxl
QHZnZXIua2VybmVsLm9yZzsgQXJkIEJpZXNoZXV2ZWwgPGFyZGJAa2VybmVsLm9yZz47IFJhZmFl
bA0KPiBKLiBXeXNvY2tpIDxyYWZhZWwuai53eXNvY2tpQGludGVsLmNvbT4NCj4gU3ViamVjdDog
W1BBVENIIDUuNCAwNjQvMTM0XSBBQ1BJOiBHRUQ6IGFkZCBzdXBwb3J0IGZvciBfRXh4IC8gX0x4
eCBoYW5kbGVyIG1ldGhvZHMNCj4gDQo+IEZyb206IEFyZCBCaWVzaGV1dmVsIDxhcmRiQGtlcm5l
bC5vcmc+DQo+IA0KPiBjb21taXQgZWE2ZjNhZjRjNWU2M2Y2OTgxYzBiMGFiOGViZWM0MzhlMmQ1
ZWY0MCB1cHN0cmVhbS4NCj4gDQo+IFBlciB0aGUgQUNQSSBzcGVjLCBpbnRlcnJ1cHRzIGluIHRo
ZSByYW5nZSBbMCwgMjU1XSBtYXkgYmUgaGFuZGxlZA0KPiBpbiBBTUwgdXNpbmcgaW5kaXZpZHVh
bCBtZXRob2RzIHdob3NlIG5hbWluZyBpcyBiYXNlZCBvbiB0aGUgZm9ybWF0DQo+IF9FeHggb3Ig
X0x4eCwgd2hlcmUgeHggaXMgdGhlIGhleCByZXByZXNlbnRhdGlvbiBvZiB0aGUgaW50ZXJydXB0
DQo+IGluZGV4Lg0KPiANCj4gQWRkIHN1cHBvcnQgZm9yIHRoaXMgbWlzc2luZyBmZWF0dXJlIHRv
IG91ciBBQ1BJIEdFRCBkcml2ZXIuDQo+IA0KPiBDYzogdjQuOSsgPHN0YWJsZUB2Z2VyLmtlcm5l
bC5vcmc+ICMgdjQuOSsNCj4gU2lnbmVkLW9mZi1ieTogQXJkIEJpZXNoZXV2ZWwgPGFyZGJAa2Vy
bmVsLm9yZz4NCj4gU2lnbmVkLW9mZi1ieTogUmFmYWVsIEouIFd5c29ja2kgPHJhZmFlbC5qLnd5
c29ja2lAaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdy
ZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPiANCg0KVGhpcyBwYXRjaCBhbHNvIHJlcXVpcmVz
IHRoZSBmb2xsb3dpbmcgcGF0Y2guDQpQbGVhc2UgYXBwbHkgdG8gdGhpcyBrZXJuZWwgdmVyc2lv
biwgNC45LCA0LjE0LCA0LjE5LCA1LjYgYW5kIDUuNy4gDQoNCkZyb20gZTVjMzk5YjBiZDY0OTBj
MTJjMGFmMmE5ZWFhOWQ3Y2Q4MDVkNTJjOSBNb24gU2VwIDE3IDAwOjAwOjAwIDIwMDENCkZyb206
IEFyZCBCaWVzaGV1dmVsIDxhcmRiQGtlcm5lbC5vcmc+DQpEYXRlOiBXZWQsIDI3IE1heSAyMDIw
IDEzOjM3OjAwICswMjAwDQoNCiAgICBBQ1BJOiBHRUQ6IHVzZSBjb3JyZWN0IHRyaWdnZXIgdHlw
ZSBmaWVsZCBpbiBfRXh4IC8gX0x4eCBoYW5kbGluZw0KDQogICAgQ29tbWl0IGVhNmYzYWY0YzVl
NjNmNjkgKCJBQ1BJOiBHRUQ6IGFkZCBzdXBwb3J0IGZvciBfRXh4IC8gX0x4eCBoYW5kbGVyDQog
ICAgbWV0aG9kcyIpIGFkZGVkIGEgcmVmZXJlbmNlIHRvIHRoZSAndHJpZ2dlcmluZycgZmllbGQg
b2YgZWl0aGVyIHRoZQ0KICAgIG5vcm1hbCBvciB0aGUgZXh0ZW5kZWQgQUNQSSBJUlEgcmVzb3Vy
Y2Ugc3RydWN0LCBidXQgaW5hZHZlcnRlbnRseSB1c2VkDQogICAgdGhlIHdyb25nIHBvaW50ZXIg
aW4gdGhlIGxhdHRlciBjYXNlLiBOb3RlIHRoYXQgYm90aCBwb2ludGVycyByZWZlciB0byB0aGUN
CiAgICBzYW1lIHVuaW9uLCBhbmQgdGhlICd0cmlnZ2VyaW5nJyBmaWVsZCBhcHBlYXJzIGF0IHRo
ZSBzYW1lIG9mZnNldCBpbiBib3RoDQogICAgc3RydWN0IHR5cGVzLCBzbyBpdCBjdXJyZW50bHkg
aGFwcGVucyB0byB3b3JrIGJ5IGFjY2lkZW50LiBCdXQgbGV0J3MgZml4DQogICAgaXQgbm9uZXRo
ZWxlc3MNCg0KICAgIEZpeGVzOiBlYTZmM2FmNGM1ZTYzZjY5ICgiQUNQSTogR0VEOiBhZGQgc3Vw
cG9ydCBmb3IgX0V4eCAvIF9MeHggaGFuZGxlciBtZXRob2RzIikNCiAgICBTaWduZWQtb2ZmLWJ5
OiBBcmQgQmllc2hldXZlbCA8YXJkYkBrZXJuZWwub3JnPg0KICAgIFNpZ25lZC1vZmYtYnk6IFJh
ZmFlbCBKLiBXeXNvY2tpIDxyYWZhZWwuai53eXNvY2tpQGludGVsLmNvbT4NCg0KQmVzdCByZWdh
cmRzLA0KICBOb2J1aGlybw0KDQo+IC0tLQ0KPiAgZHJpdmVycy9hY3BpL2V2Z2VkLmMgfCAgIDIy
ICsrKysrKysrKysrKysrKysrKystLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxOSBpbnNlcnRpb25z
KCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gLS0tIGEvZHJpdmVycy9hY3BpL2V2Z2VkLmMNCj4g
KysrIGIvZHJpdmVycy9hY3BpL2V2Z2VkLmMNCj4gQEAgLTc5LDYgKzc5LDggQEAgc3RhdGljIGFj
cGlfc3RhdHVzIGFjcGlfZ2VkX3JlcXVlc3RfaW50ZQ0KPiAgCXN0cnVjdCByZXNvdXJjZSByOw0K
PiAgCXN0cnVjdCBhY3BpX3Jlc291cmNlX2lycSAqcCA9ICZhcmVzLT5kYXRhLmlycTsNCj4gIAlz
dHJ1Y3QgYWNwaV9yZXNvdXJjZV9leHRlbmRlZF9pcnEgKnBleHQgPSAmYXJlcy0+ZGF0YS5leHRl
bmRlZF9pcnE7DQo+ICsJY2hhciBldl9uYW1lWzVdOw0KPiArCXU4IHRyaWdnZXI7DQo+IA0KPiAg
CWlmIChhcmVzLT50eXBlID09IEFDUElfUkVTT1VSQ0VfVFlQRV9FTkRfVEFHKQ0KPiAgCQlyZXR1
cm4gQUVfT0s7DQo+IEBAIC04NywxNCArODksMjggQEAgc3RhdGljIGFjcGlfc3RhdHVzIGFjcGlf
Z2VkX3JlcXVlc3RfaW50ZQ0KPiAgCQlkZXZfZXJyKGRldiwgInVuYWJsZSB0byBwYXJzZSBJUlEg
cmVzb3VyY2VcbiIpOw0KPiAgCQlyZXR1cm4gQUVfRVJST1I7DQo+ICAJfQ0KPiAtCWlmIChhcmVz
LT50eXBlID09IEFDUElfUkVTT1VSQ0VfVFlQRV9JUlEpDQo+ICsJaWYgKGFyZXMtPnR5cGUgPT0g
QUNQSV9SRVNPVVJDRV9UWVBFX0lSUSkgew0KPiAgCQlnc2kgPSBwLT5pbnRlcnJ1cHRzWzBdOw0K
PiAtCWVsc2UNCj4gKwkJdHJpZ2dlciA9IHAtPnRyaWdnZXJpbmc7DQo+ICsJfSBlbHNlIHsNCj4g
IAkJZ3NpID0gcGV4dC0+aW50ZXJydXB0c1swXTsNCj4gKwkJdHJpZ2dlciA9IHAtPnRyaWdnZXJp
bmc7DQo+ICsJfQ0KPiANCj4gIAlpcnEgPSByLnN0YXJ0Ow0KPiANCj4gLQlpZiAoQUNQSV9GQUlM
VVJFKGFjcGlfZ2V0X2hhbmRsZShoYW5kbGUsICJfRVZUIiwgJmV2dF9oYW5kbGUpKSkgew0KPiAr
CXN3aXRjaCAoZ3NpKSB7DQo+ICsJY2FzZSAwIC4uLiAyNTU6DQo+ICsJCXNwcmludGYoZXZfbmFt
ZSwgIl8lYyUwMmhoWCIsDQo+ICsJCQl0cmlnZ2VyID09IEFDUElfRURHRV9TRU5TSVRJVkUgPyAn
RScgOiAnTCcsIGdzaSk7DQo+ICsNCj4gKwkJaWYgKEFDUElfU1VDQ0VTUyhhY3BpX2dldF9oYW5k
bGUoaGFuZGxlLCBldl9uYW1lLCAmZXZ0X2hhbmRsZSkpKQ0KPiArCQkJYnJlYWs7DQo+ICsJCS8q
IGZhbGwgdGhyb3VnaCAqLw0KPiArCWRlZmF1bHQ6DQo+ICsJCWlmIChBQ1BJX1NVQ0NFU1MoYWNw
aV9nZXRfaGFuZGxlKGhhbmRsZSwgIl9FVlQiLCAmZXZ0X2hhbmRsZSkpKQ0KPiArCQkJYnJlYWs7
DQo+ICsNCj4gIAkJZGV2X2VycihkZXYsICJjYW5ub3QgbG9jYXRlIF9FVlQgbWV0aG9kXG4iKTsN
Cj4gIAkJcmV0dXJuIEFFX0VSUk9SOw0KPiAgCX0NCj4gDQoNCg==
