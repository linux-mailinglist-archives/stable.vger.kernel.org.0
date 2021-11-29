Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397E4461063
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 09:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245073AbhK2Isb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 03:48:31 -0500
Received: from mail-bo1ind01olkn0173.outbound.protection.outlook.com ([104.47.101.173]:52896
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231468AbhK2IqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 03:46:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f7i+svsMZ7pp96COvHtSPc5QXOUhE3Zxqjwcv2i1VLKyoBD5hd+QyOpT6PWrC2GEHlIrlq5qAtaIkp/MaiuQShSyDlokFQXUk4TEHkxMEDYmvsMu7dgWQYd+NRwGjpcqt2IvUAnAgjy1LlRLjEwWxBeWwqlCSfcNGU5fjezIEDcjvg8D4y8bhIv7wyECGKfvC5z1LhgoQlKyxrrIqzS0XiEL2iIwUv3ISZ6dVKBiypVMQRhcMAhzDP4/A2NLeUierk5I7PkOKENYzFT/rvBj+iCxtju/i+DvxrNU0dsF0XGSEAD2SKP3Swj00X7A7+3tD6smRrsPJtA166xc3/ZMNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YG2xRrPwF9eMS0IkNM0RCFcP8XAnMuC+/k2Xl2FVC74=;
 b=fG/q0ZG2WQ9vSD4ndYmXuDcDPGI1R1niriiTMOoEpUl0+qZFDEbvn9suo82TzawZYYBme0r4v0jI3HQU37yUvkFUQYR+kIbKlbkH+v3/wU5xEhj/q+4NMI7UtsaWg9t+l+HMnToPP2TeqOpLbo18aavl9KTUgw8GsXvS8lF1Vjxc1TtepNCDAaeyTi9nuoTJsDarZIUqNlkeN3noC/QP3IwA3y+p8i6d0yq01zR1DGD8KdIMZavwKqeNNEHQr9hS8wEljoHAK4A5j0LEbwrpogL4QPmYc8b/LM1IgJ/1nMQu7zcy9NyZOrfARajJJCJuANMp0JK6wr/y2ELkHUfgWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YG2xRrPwF9eMS0IkNM0RCFcP8XAnMuC+/k2Xl2FVC74=;
 b=g+exoRjf3QXFGEXvHEQBoLctyYgtB4HFg0dp+/i52OUfi68jPEPdQglZ5PbbRNcAI+r7Zuayzq93+fST2lCs5hGHbPVOzfB6rdUhMVeQ1taoC+y+z83UwKQIUWFGZKsOaYatzVnXXbxiVoNSKhyretENQifb48OB9U2/c7gp4fgfXCCpWmYjVQU8c8jK1E6Y3wfmqscoFBJNKH0TItQfkPHOlfsn6ZDT3lHl4TL+7tIPVUthEf8vtqy8/znoYpMMa2pCiKLSnimdTxY/ET0Re1RKZRrcIp1hQhWp1EJrQrnP9ujnQt4f+jxjKNAuCfoA4BvcyGOpakUvTCNgTXTZuQ==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN3PR01MB7062.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:ac::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 08:42:54 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 08:42:54 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Marcel Holtmann <marcel@holtmann.org>
CC:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Daniel Winkler <danielwinkler@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Johan Hedberg <johan.hedberg@intel.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "sonnysasaka@chromium.org" <sonnysasaka@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 2/6] btbcm: disable read tx power for MacBook Pro 16,1 (16
 inch, 2019)
Thread-Topic: [PATCH 2/6] btbcm: disable read tx power for MacBook Pro 16,1
 (16 inch, 2019)
Thread-Index: AQHX5PKQXvZS6gRfDUeYXwKSvRtbmqwaJqEAgAAAzwCAAAMOAIAABcsA
Date:   Mon, 29 Nov 2021 08:42:53 +0000
Message-ID: <F7C7AB2A-50B8-453C-92B2-38273B5173BB@live.com>
References: <20211001083412.3078-1-redecorating@protonmail.com>
 <YYePw07y2DzEPSBR@kroah.com>
 <70a875d0-7162-d149-dbc1-c2f5e1a8e701@leemhuis.info>
 <20211116090128.17546-1-redecorating@protonmail.com>
 <e75bf933-9b93-89d2-d73f-f85af65093c8@leemhuis.info>
 <3B8E16FA-97BF-40E5-9149-BBC3E2A245FE@live.com> <YZSuWHB6YCtGclLs@kroah.com>
 <52DEDC31-EEB2-4F39-905F-D5E3F2BBD6C0@live.com>
 <8919a36b-e485-500a-2722-529ffa0d2598@leemhuis.info>
 <20211117124717.12352-1-redecorating@protonmail.com>
 <F8D12EA8-4B37-4887-998E-DC0EBE60E730@holtmann.org>
 <40550C00-4EE5-480F-AFD4-A2ACA01F9DBB@live.com>
 <332a19f1-30f0-7058-ac18-c21cf78759bb@leemhuis.info>
 <D9375D91-1062-4265-9DE9-C7CF2B705F3F@live.com>
 <BC534C52-7FCF-4238-8933-C5706F494A11@live.com>
 <5B9FF471-42DD-44DA-A9CE-0A83BA7A4212@live.com>
 <EBE48AE4-BCE3-42A6-BA8E-304C789C4667@holtmann.org>
 <47A8DBEC-322F-4C42-AF69-5FDB828B8680@live.com>
 <056FB976-25A3-466C-8C6D-DD5E11FDACCD@holtmann.org>
In-Reply-To: <056FB976-25A3-466C-8C6D-DD5E11FDACCD@holtmann.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [QAMTgCYhzgAb9w0WPUewoIUy6fmmmHSrIEJ02vj6bk04CoG3kOJBCJOaIJ5V5SjL]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8913753f-ef8b-4f8b-a869-08d9b3143c2f
x-ms-traffictypediagnostic: PN3PR01MB7062:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6KGcOGjzONiUejrWayN44kPmXBKawXNcXDKUPtEz5uWGKoYk3wnTWzlq2Ri/6db+kEESjOP5haHc+mzj4HeYqGB4yde6IlL1OweaeNS49WluPOnwciilmLxIfyLfdgGdRVSIhplwEInuPzkvRjWfZfoE8iC3mg5dIhQf2AUsxf05jru0U/FL1lJxLJ2naLTBATL2ctaWbmSXJrXlLk4yQrk8oaAqlWqA95J7Nf2hPa4jYSywy2l+3EoGvRSm5h/4FwdJICVPpMkUIL/qDqyF3l7J8Q6uOp57r0O60whHTIGhexk0lk2ZjawJH/zm2BFHX25e48jC9JR40IJToTESQzqRk8/MO5t9dSi8GAa0hMiMPdPfErqCBJlxhoH/8oX15+IMZAY36qqZYBz5p8dMkB0/8f99qL5iFb7NOqyMN74GGKKhEax8rbu7cpqEzt2XbAFe89JMpfiF3el1HPqPnr7XhYqI7bJQGbthqkLpHnKhhg2LBYIpCMJTH9IpibLsn+6Lvsn+8QHBbBSeqStN5o+qvX0NvA/i2fpEYIDd50N1u/wz6q8z9GoQsdGHxVxI/N20QVMkhJxfeHK7QDlEaw==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: FIERsEbNVFsmaXdUbEA/YpMTc5B4TuObWB0rmt6HZolhopa8SQBrzZIzZ7wR6CeLC8kdwnQteH10Wh3JOZ90Ih5eAFU+TZ4kztXOte5ry7NfwObOIfHCtYa99pk17whYJ9YDuR6xXu2nLc8Cla8JCKt5ZTPDepi9DWLFj46G6HHaZIG00njYAnCIyU1KsJvpKfr+YoxLmz76n/IgGebyVe/8eh8Bs5ffehN1uhEwvKY53psu1hWe7pLepucC+kkj2ATKC8HbwSx06vOQDcLmmtwzjStmlvtp1JzYfhgt9ks7SaOd8/Oi9Qf21iv5G+tPn+zmdq6vBNUPUvYQlK4tHF5HbEKl0j2l3ZdpFg880AlIE5Dyah114biVrtJ4IK6tdl3M/PJ6NYH06sh42QCWAYYvMGp5z76nSJtLdCIa1pWFQwbj4Cbj5FigMFrkI0DhxduMi/41+3l0wskkULKA46Rwr9q0CbW6nctoqtV3+dHMbpuRlvZAnTXMZAsxPefjcCwvgcxYRehAuIYhhkAL8WXkJ1cIP6MVpDZW1twMVNC4rFngM2ywzU7Qv3zte/7REYwo9sL1XQjfXic9TSJVDuqEGf865R7rx4DMBpgDL3kEoTXjMjats9ce7ybWCvkaOJ1uqggvYZIEcdrEKDvECbxEzlK+QlH0jOb/uAG64y8LsFW2BTo90pVbjj2H2vT+vHA2zSPC0otr0n8My3/1uSgH6ZG5YcPubU0g6K8Ww3i+bs7GYJIU46DGGdIpz61pZKqS6ki2BEz9/Uwlkv2a8g==
Content-Type: text/plain; charset="utf-8"
Content-ID: <501A62E6FABB5642A0D70D3138959BBD@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 8913753f-ef8b-4f8b-a869-08d9b3143c2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 08:42:53.9223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN3PR01MB7062
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gT24gMjktTm92LTIwMjEsIGF0IDE6NTIgUE0sIE1hcmNlbCBIb2x0bWFubiA8bWFyY2Vs
QGhvbHRtYW5uLm9yZz4gd3JvdGU6DQo+IA0KPiBIaSBBZGl0eWEsDQo+IA0KPj4+PiBCbHVldG9v
dGggb24gQXBwbGUgTWFjQm9vayBQcm8gMTYsMSBpcyB1bmFibGUgdG8gc3RhcnQgZHVlIHRvIExF
IE1pbi9NYXggVHggUG93ZXIgYmVpbmcgcXVlcmllZCBvbiBzdGFydHVwLiBBZGQgYSBETUkgYmFz
ZWQgcXVpcmsgc28gdGhhdCBpdCBpcyBkaXNhYmxlZC4NCj4+PiANCj4+PiBsaXN0IGFsbCB0aGUg
TWFjQm9va3MgdGhhdCB5b3UgZm91bmQgcHJvYmxlbWF0aWMgcmlnaHQgbm93LiBXZSBhZGQgdGhl
DQo+Pj4gaW5pdGlhbCBhcyBhIGxhcmdlIGJhdGNoIGluc3RlYWQgb2YgYWxsIGluZGl2aWR1YWwu
DQo+Pj4gDQo+Pj4+IA0KPj4+PiBTaWduZWQtb2ZmLWJ5OiBBZGl0eWEgR2FyZyA8Z2FyZ2FkaXR5
YTA4QGxpdmUuY29tPg0KPj4+PiBUZXN0ZWQtYnk6IEFkaXR5YSBHYXJnIDxnYXJnYWRpdHlhMDhA
bGl2ZS5jb20+DQo+Pj4+IC0tLQ0KPj4+PiBkcml2ZXJzL2JsdWV0b290aC9idGJjbS5jIHwgMjAg
KysrKysrKysrKysrKysrKysrKysNCj4+Pj4gMSBmaWxlIGNoYW5nZWQsIDIwIGluc2VydGlvbnMo
KykNCj4+Pj4gDQo+Pj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2JsdWV0b290aC9idGJjbS5jIGIv
ZHJpdmVycy9ibHVldG9vdGgvYnRiY20uYw0KPj4+PiBpbmRleCBlNDE4MmFjZWU0ODhjNS4uYzFi
MGNhNjM4ODBhNjggMTAwNjQ0DQo+Pj4+IC0tLSBhL2RyaXZlcnMvYmx1ZXRvb3RoL2J0YmNtLmMN
Cj4+Pj4gKysrIGIvZHJpdmVycy9ibHVldG9vdGgvYnRiY20uYw0KPj4+PiBAQCAtOCw2ICs4LDcg
QEANCj4+Pj4gDQo+Pj4+ICNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4NCj4+Pj4gI2luY2x1ZGUg
PGxpbnV4L2Zpcm13YXJlLmg+DQo+Pj4+ICsjaW5jbHVkZSA8bGludXgvZG1pLmg+DQo+Pj4+ICNp
bmNsdWRlIDxhc20vdW5hbGlnbmVkLmg+DQo+Pj4+IA0KPj4+PiAjaW5jbHVkZSA8bmV0L2JsdWV0
b290aC9ibHVldG9vdGguaD4NCj4+Pj4gQEAgLTM0Myw5ICszNDQsMjMgQEAgc3RhdGljIHN0cnVj
dCBza19idWZmICpidGJjbV9yZWFkX3VzYl9wcm9kdWN0KHN0cnVjdCBoY2lfZGV2ICpoZGV2KQ0K
Pj4+PiAJcmV0dXJuIHNrYjsNCj4+Pj4gfQ0KPj4+PiANCj4+Pj4gK3N0YXRpYyBjb25zdCBzdHJ1
Y3QgZG1pX3N5c3RlbV9pZCBkaXNhYmxlX2Jyb2tlbl9yZWFkX3RyYW5zbWl0X3Bvd2VyW10gPSB7
DQo+Pj4+ICsJew0KPj4+PiArCQkvKiBNYXRjaCBmb3IgQXBwbGUgTWFjQm9vayBQcm8gMTYsMSB3
aGljaCBuZWVkcw0KPj4+PiArCQkgKiBSZWFkIExFIE1pbi9NYXggVHggUG93ZXIgdG8gYmUgZGlz
YWJsZWQuDQo+Pj4+ICsJCSAqLw0KPj4+IA0KPj4+IEFjdHVhbGx5IGxlYXZlIHRoZSBjb21tZW50
IG91dC4gWW91IGFyZSBub3QgYWRkaW5nIGFueSB2YWx1ZSB0aGF0IGlzbuKAmXQNCj4+PiBhbHJl
YWR5IGluIHRoZSB2YXJpYWJsZSBuYW1lIG9yIHRoZSBETUkuIEl0IGlzIGp1c3QgcmVwZWF0aW5n
IHRoZSBvYnZpb3VzLg0KPj4gQWxyaWdodCwgSSBwcmVwYXJlIHRoZSBwYXRjaGVzIGludG8gYSBz
aW5nbGUgb25lDQo+IA0KPiB0d28gcGF0Y2hlcywgb25lIGZvciBhZGRpbmcgdGhlIHF1aXJrIHRv
IHRoZSBjb3JlIGFuZCBvbmUgZm9yIGFkanVzdGluZyB0aGUgZHJpdmVyLg0KU2VudA0KPiANCj4g
UmVnYXJkcw0KPiANCj4gTWFyY2VsDQo+IA0KDQo=
