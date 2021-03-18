Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3E33408C6
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 16:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbhCRP0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 11:26:41 -0400
Received: from mail-eopbgr150088.outbound.protection.outlook.com ([40.107.15.88]:23694
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231704AbhCRP0d (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Mar 2021 11:26:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIh+yV9zXFrhj+BUmXQp1UQ8MmlfixKTFimHE9mFYB7CbhyUJJoJDYb/dY+l8CWLfx4urlH6DHwHusCsSlHVrDS9qRcFOkGjLxl1sxYnkcd5pPSiIbfytD/LKj5DXNV2BLO2waP8zS6byDqtg/zPsM0KpsZeewzG43VNz6/hTis1hFpbXPyvG1LW30w7btTPgz5BIbj+usu46sCNByostvgj2/v16Il+sBBjYYtPLGZExZRhqsmQTEJajPiDbjeGfvx2y/E8aYgrbNezk/XQxl5nXWYrqvXKZGihJWVhKUGdXfDrBcrTIT9VvVjgEjdzh2ESC1wxFd0u13czAUU+dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/PypgDeZ79il9LXy2KJ6Pa7QsQnDBC/QTGVcApE7H1Y=;
 b=kfd36+vsMjwlFr/XPJZzWmT3AWczNlC844Ex25nkBKigng6wtfr8HHwOXXzFlNzm9ZyCYqFk/a+20KoDoy1ykrXafIovkWygU2DNcZzhcihxuONgOcmvFUUYCOatoDtxMCWpQzNYlG356c/DnXOUP1jxE5Pka0d5xyeSeenrrqTShkWNGSRJZazTF774hrJB9Rc30gCS/QIYBJ2OSvkAbTwX9tcOP7IjA8idjNLuCjH9ACp4nhBrOr0P6Zs4kBzcqxmUY/j+B45BESJTeohRChKZ1S5+D/Ybh5Cly+EkLVbF6Po3OVJq7CobVel0JtzgiCDjFuSgP1PGxQP58a+VJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=diasemi.com; dmarc=pass action=none header.from=diasemi.com;
 dkim=pass header.d=diasemi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=dialogsemiconductor.onmicrosoft.com;
 s=selector1-dialogsemiconductor-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/PypgDeZ79il9LXy2KJ6Pa7QsQnDBC/QTGVcApE7H1Y=;
 b=flEbIRkYDsQTMEXUcC+jUXQHSFaylnRO1R+wLPDvfj7NIFvoVp4235dmaQzoXvr/a6nKZnDNKZgfF3GGnpDlQiq62WIzywJ/GTm72pn6FSbRtWTgUp4bme/nPWg5bb/KrzO0IDkfcl9wdMA+lSizIMCzLTLOTIicpaxQbPZUJf4=
Received: from PR3PR10MB4142.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:ac::5)
 by PA4PR10MB4381.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:106::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Thu, 18 Mar
 2021 15:26:27 +0000
Received: from PR3PR10MB4142.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::7040:2788:a951:5f6]) by PR3PR10MB4142.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::7040:2788:a951:5f6%6]) with mapi id 15.20.3955.018; Thu, 18 Mar 2021
 15:26:27 +0000
From:   Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
To:     Badhri Jagan Sridharan <badhri@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] usb: typec: tcpm: Invoke power_supply_changed for
 tcpm-source-psy-
Thread-Topic: [PATCH v2] usb: typec: tcpm: Invoke power_supply_changed for
 tcpm-source-psy-
Thread-Index: AQHXG1kn097VtujeWkiKnVEPJK+rvKqJ3XWA
Date:   Thu, 18 Mar 2021 15:26:27 +0000
Message-ID: <PR3PR10MB41420951E2867C2E0E5272B980699@PR3PR10MB4142.EURPRD10.PROD.OUTLOOK.COM>
References: <20210317181249.1062995-1-badhri@google.com>
In-Reply-To: <20210317181249.1062995-1-badhri@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=diasemi.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [147.161.166.124]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 515b32bd-50d0-43c8-465a-08d8ea223307
x-ms-traffictypediagnostic: PA4PR10MB4381:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PA4PR10MB43818EADF89CEA215E5C3C53A7699@PA4PR10MB4381.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:1107;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XYzQp3oozvcLnMr98zmXgZFhVRAJoFTktXJjQgggCE4BRlHasN3ZSeyPUS5WebqoMYDzPVwj4OouvV7NBF0dGWRT6CW/OM2DvFFuqgAN9cVYItCHbL/89UiXvffsaeKBrPZj+VRrg/QDTnn6gxui0Cd42ttteB6YXN3IRwmWvziUoipGajfYIbn9TOyoCR4EVwyoxu94adEQWcnDj4jswO0BDh1zhlo3Rnf9KvXmI3iXkjcNtgwJTXCg5ei2Etq/MWD7HNB6zqlAtQiPEGnlFaDPXWNd6VmogzQhJbNqS0Cms9U+C2WiXOoNFNuX7T4ChPIFwFdy7im3lAqlpQtCS6ST0VNVKjE5UHKAkbDxWX3b9zIj8Yzi/2mVoXCy5xmoFrIU9my/9NvxBZszRK5oe+WTK+t/8RRQ3IZpU1JFvSlobRRQo92ru/7vi9V9x5MJ4R+4v19XIxkmiXLwAFXOyRIynUsiPrFRKJUDQcUkXbkU42b9neGYDtyHg85NsvjsxGqrymW6YKyHx926lCvC/KZ2qxkHhijOS/8aieYHF1HdETNcPpyfCpXk1gtudB4Glaw1e/KrXgMbFwy3f5QNM9FszQw9UgEFgRBbkiGj1u3Lu/LhcMAtmufvtbqdgo9G
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR10MB4142.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(39850400004)(346002)(396003)(186003)(26005)(478600001)(71200400001)(316002)(66446008)(66476007)(2906002)(33656002)(8936002)(52536014)(38100700001)(83380400001)(53546011)(4326008)(55016002)(5660300002)(86362001)(7696005)(76116006)(6506007)(110136005)(66946007)(54906003)(64756008)(8676002)(66556008)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?am1FVHFjdnkvN2pwVk5vRGxLM3V4K3ZLV3dndkFUVjZJc1YvMlh0RmdsZmV1?=
 =?utf-8?B?UFpMcGpjaTdRN3g0ZWdpVzJrbEVUY0tBTTE0YzYvQUFNKzlncmpzRkZvSHFx?=
 =?utf-8?B?NVBiN2dDdkFGbkhlSml5SFdpOVdldWR2SHRGdmkyOE90OWs4Z1l1ZEtPRGlj?=
 =?utf-8?B?Z3hJTDRwVFEydFNBODlJT0VvVWc5SDZsNlZzbms3YUVINkFISmUzYVgyVmta?=
 =?utf-8?B?T0J6VnZJc3lVVExDeU9ndWxidGpHMjB1ZFlzakhlZXBrYVgvR1pCdzdvNXVw?=
 =?utf-8?B?YjBSay95b29rR0NOQm0rd05lVmdKaWRIREk3N28vWnVJMUJpSDNuaWpKb29h?=
 =?utf-8?B?VkFRTVZvMnZtOGErSlYwci9QRHUvTDZScHRRSmNSdFVOZnc4bUY4UTd0REJ6?=
 =?utf-8?B?Y0ZFWERjY040SXJLQndsc0pKeHE2NHBSNGNqa2JRblZaZjhWUmFadWJoSm1l?=
 =?utf-8?B?L0xOVXhoOHordXNsd21KazZJbVJlVXA2V2JoMENBcW9VcjFyamxsZ0RVQ3RR?=
 =?utf-8?B?Y0U0ajZyMUlVeC9JTmNKdFJBeWtabXFlN1kyTS9HNW9Nbk43OTQ1YTNsOXBE?=
 =?utf-8?B?dkNVb0FUK21mNkM1MndYRjJmcEd0TjNoV3ZkN0I0blg1ZUJsa3MrT0RrNjd2?=
 =?utf-8?B?R3dMbEdCZStadkRRV05USDErSmc0R1BNUWduczlKdlRnRVFlK0o1dm1zY29Y?=
 =?utf-8?B?VStRQUR6VnZMUVIvc0tIY3hCZVZHc1BuYUJBV2doY2thVkFQTmRSeVRicGp2?=
 =?utf-8?B?UU42eU51c3YwQXA0cGNYS2dvVTMrWjhWcmJDdE5iODRtRzlHR1RxRS91NHlw?=
 =?utf-8?B?ZmdIVFBMM1JLNHU5SjdUNWRkN3RWa3RDSkhJZUNPeGJpTk5XdkhTd3poMU53?=
 =?utf-8?B?WURnVjc1VVdtazFIMWtVaWJVdE9LNzBPdm1xRHcxVWY4aThqUDlqT0FiOHpa?=
 =?utf-8?B?RWxuQVZJSC91bXdBVGZDTno1QjNOd3F5VnZhK2FCdnB4Z0d6ZnA0VzJvbWVJ?=
 =?utf-8?B?a2V3RHd1M1FsMHF3d0E5dDdlTjhXeFN5aG9SSWtBbTdaRFVaRVgwWXhMQytD?=
 =?utf-8?B?UDZ5QWZZbGZiMEU2OTM1Q1VRb1AvczdaWi96YWcrOFdUcFJtTzZpYTVxbU84?=
 =?utf-8?B?OVJnUElQRUhMRUVHMjIxV3RDL3ptYlJyTUhRejdJbDRnSnozWDFQNE1xMTVY?=
 =?utf-8?B?a0dUTTBHcE13OXo5L0xrT0taU2ZocGozNmJPaCtYa3FIbThhWVpmaVVSNm1I?=
 =?utf-8?B?VExaa1VsaG53b2NtVHRpcU9iZGk3a0dPZVNsM2drN2JqeGc3QVJWekNzYjlP?=
 =?utf-8?B?U1IxY3A0ZmlnUm1hYWh6VjVVaHJUR2VMWm5MeFRLMHdVaDFlbm5hK2lrME1Y?=
 =?utf-8?B?WlBLd3ZEMzlBZitLQ1FnQXFVMElJNnpodWZzUUFGd3Fia0FtanpOYUwzaDZt?=
 =?utf-8?B?dnJqNGxQY3RCcVBNc29ZQ1NRU0hNQ28xa2RxZ21PU2pDNDk4VUF2cGNwZVlj?=
 =?utf-8?B?RUluUlNDc3lpV2ZQWE5jcFhITkZrZnk3NjNSNE45enU1WU5BN2lJVE1FcTR1?=
 =?utf-8?B?NDIzWjY1V3FaTEo1YkZGTXhsTkcxVTIxemJ1U3E2b1RVNVpYMnNzMFBJcjJ0?=
 =?utf-8?B?NHVjMS8wdlJmM3ZzQXRPb0Q2RWJ6ZjdTN04ya3kxNENaN3RsVi9WVGlZL2Nq?=
 =?utf-8?B?ZSs1SHlyYzF2MEw4RTIxWmhvTDhHNGhvN3VBd2lZSWV5MEhwb2Nxb0k1Y0lI?=
 =?utf-8?Q?YGp9rPL4O4bV8TKUEDUwVtx4v3vnl3UtAiYUK1P?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: diasemi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PR3PR10MB4142.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 515b32bd-50d0-43c8-465a-08d8ea223307
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2021 15:26:27.7662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 511e3c0e-ee96-486e-a2ec-e272ffa37b7c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xwkTZtiGPQe9t/LYH2eFACYpDGW9rJh/mN1EspH6Hq6NA4XKuozJSZlPY9Wj6tTLhuoqchPrJifw1JAUdi41q4NEtzlgacw7pj3L9f264Fw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR10MB4381
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTcgTWFyY2ggMjAyMSAxODoxMywgQmFkaHJpIEphZ2FuIFNyaWRoYXJhbiB3cm90ZToNCg0K
PiB0Y3BtLXNvdXJjZS1wc3ktIGRvZXMgbm90IGludm9rZSBwb3dlcl9zdXBwbHlfY2hhbmdlZCBB
UEkgd2hlbg0KPiBvbmUgb2YgdGhlIHB1Ymxpc2hlZCBwb3dlciBzdXBwbHkgcHJvcGVydGllcyBp
cyBjaGFuZ2VkLg0KPiBwb3dlcl9zdXBwbHlfY2hhbmdlZCBuZWVkcyB0byBiZSBjYWxsZWQgdG8g
bm90aWZ5DQo+IHVzZXJzcGFjZSBjbGllbnRzKHVldmVudHMpIGFuZCBrZXJuZWwgY2xpZW50cy4N
Cj4gDQo+IEZpeGVzOiBmMmE4YWEwNTNjMTc2KCJ0eXBlYzogdGNwbTogUmVwcmVzZW50IHNvdXJj
ZSBzdXBwbHkgdGhyb3VnaA0KPiBwb3dlcl9zdXBwbHkiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBCYWRo
cmkgSmFnYW4gU3JpZGhhcmFuIDxiYWRocmlAZ29vZ2xlLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IEd1
ZW50ZXIgUm9lY2sgPGxpbnV4QHJvZWNrLXVzLm5ldD4NCj4gUmV2aWV3ZWQtYnk6IEhlaWtraSBL
cm9nZXJ1cyA8aGVpa2tpLmtyb2dlcnVzQGxpbnV4LmludGVsLmNvbT4NCj4gLS0tDQo+IENoYW5n
ZXMgc2luY2UgVjE6DQo+IC0gRml4ZWQgY29tbWl0IG1lc3NhZ2UgYXMgcGVyIEd1ZW50ZXIncyBz
dWdnZXN0aW9uDQo+IC0gQWRkZWQgUmV2aWV3ZWQtYnkgdGFncw0KPiAtIGNjJ2VkIHN0YWJsZQ0K
PiAtLS0NCj4gIGRyaXZlcnMvdXNiL3R5cGVjL3RjcG0vdGNwbS5jIHwgOSArKysrKysrKy0NCj4g
IDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL3VzYi90eXBlYy90Y3BtL3RjcG0uYyBiL2RyaXZlcnMvdXNiL3R5
cGVjL3RjcG0vdGNwbS5jDQo+IGluZGV4IDExZDBjNDBiYzQ3ZC4uZTg5MzZlYTE3ZjgwIDEwMDY0
NA0KPiAtLS0gYS9kcml2ZXJzL3VzYi90eXBlYy90Y3BtL3RjcG0uYw0KPiArKysgYi9kcml2ZXJz
L3VzYi90eXBlYy90Y3BtL3RjcG0uYw0KPiBAQCAtOTQ1LDYgKzk0NSw3IEBAIHN0YXRpYyBpbnQg
dGNwbV9zZXRfY3VycmVudF9saW1pdChzdHJ1Y3QgdGNwbV9wb3J0ICpwb3J0LA0KPiB1MzIgbWF4
X21hLCB1MzIgbXYpDQo+IA0KPiAgCXBvcnQtPnN1cHBseV92b2x0YWdlID0gbXY7DQo+ICAJcG9y
dC0+Y3VycmVudF9saW1pdCA9IG1heF9tYTsNCj4gKwlwb3dlcl9zdXBwbHlfY2hhbmdlZChwb3J0
LT5wc3kpOw0KPiANCj4gIAlpZiAocG9ydC0+dGNwYy0+c2V0X2N1cnJlbnRfbGltaXQpDQo+ICAJ
CXJldCA9IHBvcnQtPnRjcGMtPnNldF9jdXJyZW50X2xpbWl0KHBvcnQtPnRjcGMsIG1heF9tYSwg
bXYpOw0KPiBAQCAtMjkzMSw2ICsyOTMyLDcgQEAgc3RhdGljIGludCB0Y3BtX3BkX3NlbGVjdF9w
ZG8oc3RydWN0IHRjcG1fcG9ydCAqcG9ydCwNCj4gaW50ICpzaW5rX3BkbywNCj4gDQo+ICAJcG9y
dC0+cHBzX2RhdGEuc3VwcG9ydGVkID0gZmFsc2U7DQo+ICAJcG9ydC0+dXNiX3R5cGUgPSBQT1dF
Ul9TVVBQTFlfVVNCX1RZUEVfUEQ7DQo+ICsJcG93ZXJfc3VwcGx5X2NoYW5nZWQocG9ydC0+cHN5
KTsNCj4gDQo+ICAJLyoNCj4gIAkgKiBTZWxlY3QgdGhlIHNvdXJjZSBQRE8gcHJvdmlkaW5nIHRo
ZSBtb3N0IHBvd2VyIHdoaWNoIGhhcyBhDQo+IEBAIC0yOTU1LDYgKzI5NTcsNyBAQCBzdGF0aWMg
aW50IHRjcG1fcGRfc2VsZWN0X3BkbyhzdHJ1Y3QgdGNwbV9wb3J0ICpwb3J0LA0KPiBpbnQgKnNp
bmtfcGRvLA0KPiAgCQkJCXBvcnQtPnBwc19kYXRhLnN1cHBvcnRlZCA9IHRydWU7DQo+ICAJCQkJ
cG9ydC0+dXNiX3R5cGUgPQ0KPiAgCQkJCQlQT1dFUl9TVVBQTFlfVVNCX1RZUEVfUERfUFBTOw0K
PiArCQkJCXBvd2VyX3N1cHBseV9jaGFuZ2VkKHBvcnQtPnBzeSk7DQo+ICAJCQl9DQo+ICAJCQlj
b250aW51ZTsNCj4gIAkJZGVmYXVsdDoNCj4gQEAgLTMxMTIsNiArMzExNSw3IEBAIHN0YXRpYyB1
bnNpZ25lZCBpbnQgdGNwbV9wZF9zZWxlY3RfcHBzX2FwZG8oc3RydWN0DQo+IHRjcG1fcG9ydCAq
cG9ydCkNCj4gIAkJCQkJCSAgcG9ydC0+cHBzX2RhdGEub3V0X3ZvbHQpKTsNCj4gIAkJcG9ydC0+
cHBzX2RhdGEub3BfY3VyciA9IG1pbihwb3J0LT5wcHNfZGF0YS5tYXhfY3VyciwNCj4gIAkJCQkJ
ICAgICBwb3J0LT5wcHNfZGF0YS5vcF9jdXJyKTsNCj4gKwkJcG93ZXJfc3VwcGx5X2NoYW5nZWQo
cG9ydC0+cHN5KTsNCj4gIAl9DQo+IA0KPiAgCXJldHVybiBzcmNfcGRvOw0KDQpSZWdhcmRpbmcg
c2VsZWN0aW5nIFBET3Mgb3IgUFBTIEFQRE9zLCBzdXJlbHkgd2Ugc2hvdWxkIG9ubHkgbm90aWZ5
IG9mIGEgY2hhbmdlDQp3aGVuIHdlIHJlYWNoIFNOS19SRUFEWSB3aGljaCBtZWFucyBhIG5ldyBj
b250cmFjdCBoYXMgYmVlbiBlc3RhYmxpc2hlZD8gVW50aWwNCnRoYXQgcG9pbnQgaXQncyBwb3Nz
aWJsZSBhbnkgcmVxdWVzdGVkIGNoYW5nZSBjb3VsZCBiZSByZWplY3RlZCBzbyB3aHkgaW5mb3Jt
DQpjbGllbnRzIGJlZm9yZSB3ZSBrbm93IHRoZSBzZXR0aW5ncyBoYXZlIHRha2VuIGVmZmVjdD8g
SSBjb3VsZCBiZSBtaXNzaW5nDQpzb21ldGhpbmcgaGVyZSBhcyBpdCdzIGJlZW4gYSBsaXR0bGUg
d2hpbGUgc2luY2UgSSBkZWx2ZWQgaW50byB0aGlzLCBidXQgdGhpcw0KZG9lc24ndCBzZWVtIHRv
IG1ha2Ugc2Vuc2UgdG8gbWUuDQoNCj4gQEAgLTMzNDcsNiArMzM1MSw3IEBAIHN0YXRpYyBpbnQg
dGNwbV9zZXRfY2hhcmdlKHN0cnVjdCB0Y3BtX3BvcnQgKnBvcnQsIGJvb2wNCj4gY2hhcmdlKQ0K
PiAgCQkJcmV0dXJuIHJldDsNCj4gIAl9DQo+ICAJcG9ydC0+dmJ1c19jaGFyZ2UgPSBjaGFyZ2U7
DQo+ICsJcG93ZXJfc3VwcGx5X2NoYW5nZWQocG9ydC0+cHN5KTsNCj4gIAlyZXR1cm4gMDsNCj4g
IH0NCj4gDQo+IEBAIC0zNTMwLDYgKzM1MzUsNyBAQCBzdGF0aWMgdm9pZCB0Y3BtX3Jlc2V0X3Bv
cnQoc3RydWN0IHRjcG1fcG9ydCAqcG9ydCkNCj4gIAlwb3J0LT50cnlfc3JjX2NvdW50ID0gMDsN
Cj4gIAlwb3J0LT50cnlfc25rX2NvdW50ID0gMDsNCj4gIAlwb3J0LT51c2JfdHlwZSA9IFBPV0VS
X1NVUFBMWV9VU0JfVFlQRV9DOw0KPiArCXBvd2VyX3N1cHBseV9jaGFuZ2VkKHBvcnQtPnBzeSk7
DQoNClRoaXMgaXMgYWxyZWFkeSB0YWtlbiBjYXJlIG9mIGF0IHRoZSBlbmQgb2YgdGhpcyBmdW5j
dGlvbiwgaXNuJ3QgaXQ/DQoNCj4gIAlwb3J0LT5ucl9zaW5rX2NhcHMgPSAwOw0KPiAgCXBvcnQt
PnNpbmtfY2FwX2RvbmUgPSBmYWxzZTsNCj4gIAlpZiAocG9ydC0+dGNwYy0+ZW5hYmxlX2ZycykN
Cj4gQEAgLTU5NTcsNyArNTk2Myw3IEBAIHN0YXRpYyBpbnQgdGNwbV9wc3lfc2V0X3Byb3Aoc3Ry
dWN0IHBvd2VyX3N1cHBseQ0KPiAqcHN5LA0KPiAgCQlyZXQgPSAtRUlOVkFMOw0KPiAgCQlicmVh
azsNCj4gIAl9DQo+IC0NCj4gKwlwb3dlcl9zdXBwbHlfY2hhbmdlZChwb3J0LT5wc3kpOw0KPiAg
CXJldHVybiByZXQ7DQo+ICB9DQo+IA0KPiBAQCAtNjExMCw2ICs2MTE2LDcgQEAgc3RydWN0IHRj
cG1fcG9ydCAqdGNwbV9yZWdpc3Rlcl9wb3J0KHN0cnVjdCBkZXZpY2UNCj4gKmRldiwgc3RydWN0
IHRjcGNfZGV2ICp0Y3BjKQ0KPiAgCWVyciA9IGRldm1fdGNwbV9wc3lfcmVnaXN0ZXIocG9ydCk7
DQo+ICAJaWYgKGVycikNCj4gIAkJZ290byBvdXRfcm9sZV9zd19wdXQ7DQo+ICsJcG93ZXJfc3Vw
cGx5X2NoYW5nZWQocG9ydC0+cHN5KTsNCj4gDQo+ICAJcG9ydC0+dHlwZWNfcG9ydCA9IHR5cGVj
X3JlZ2lzdGVyX3BvcnQocG9ydC0+ZGV2LCAmcG9ydC0+dHlwZWNfY2Fwcyk7DQo+ICAJaWYgKElT
X0VSUihwb3J0LT50eXBlY19wb3J0KSkgew0KPiAtLQ0KPiAyLjMxLjAucmMyLjI2MS5nN2Y3MTc3
NDYyMC1nb29nDQoNCg==
