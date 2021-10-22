Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566524370C3
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 06:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhJVE1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Oct 2021 00:27:08 -0400
Received: from mail-ma1ind01olkn0184.outbound.protection.outlook.com ([104.47.100.184]:32977
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229568AbhJVE1I (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Oct 2021 00:27:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OYUqp6e1szOe+504gtCt7yvjqavrly2Md83H8Vg7taFMQo2V+ofRsn+bACRh9gUJJ2nIU8Fd1jzzGrFKg67g+wk5s0WeLHy+bTZaoYfBocGFDZMNRYqk7SR8FALSp1N+RYJEX9gceT4nFLtH9G6Ex7Jf64lUULgo/MOP4j2hYnYOTRV5B+T1F2rRfMUqnuAf22Xz2/fDkuwzHO7zZo/IDgeoy4dbR4OeLo7VLGBSjvHFfvPsX+81IoBn02eFz8Ow36UIwsovaI5EYEp0/6B/dnvb9hVsB952xHgPT16/3Cv/slGicb00F7X5t9coWvhbmKCYjUoiiGMvd/GysspT7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pm/Iv3eS6SYFx04SmNAKpiZz/3RWdGpHPKHJzlgMF78=;
 b=g84ZiRwrbBmyVft/fr7KbUJ1fqRs8PEK/AOvMDRBXWOPxoMsrGGrptWV09y/V0zF947FIRKohcbQRVx2G68u5v1/jkdcvydTUIFfZmIRLrRN05cYskGENie/Tho8f+8k7DFbq26Vu8IvdjRoCB/Zufx3TEfNhz7/2DOVl+Psg4U4uGxVdZSDKnyTl1MqxbWWNEg4SWla4U7jYsVWyOuv+WgANNgDhaHnhk2apbKkl18GJsqWLq1u/m+N9XXp9Y7lBQ1Wg+liNOLAPGLuk7wHjiusmMh4x/T+VAgzyH5Bwo3rt4GUfNh4T8E6uvA8JrK4DtTv30EhYQA5yVZua4G02Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pm/Iv3eS6SYFx04SmNAKpiZz/3RWdGpHPKHJzlgMF78=;
 b=g4h5u/jeqZVo8upaA52wntCB1TfsBSFOZn/mQrC9fDd5UAQwlt6RHxwUPPz4UK724DHcXY5C1ig4Fg2Gv1Cls+fIcxCMLiqrprd39A+Vc5SXP0UK4S/KTQY6MUmBT0ipBNiH427c0DlkulEI3iDLQOZ9I+qf8J26K5pQf398k2ReDXrbLSjlQNr+Nj/u2JYbDz/YNhBJtbB9qUADncdLDQ/bNKUFpZULMAlBO1G3y91OHSDhBXLjSCERSWfT/nWNI7Gr3t6Qs2tc214Y+grujlTe2pmL/ppvVxfp6TfmeG7SA9+8XkwQtmJNVR5au9xHA0JdrybLi1YyB7+midl/Rg==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN1PR0101MB1999.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:1a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Fri, 22 Oct
 2021 04:24:47 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::fc30:dd98:6807:9ea]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::fc30:dd98:6807:9ea%3]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 04:24:47 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Lee Jones <lee.jones@linaro.org>
CC:     "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>
Subject: Re: [PATCHv4] mfd: intel-lpss: Add support for MacBookPro16,2 ICL-N
 UART
Thread-Topic: [PATCHv4] mfd: intel-lpss: Add support for MacBookPro16,2 ICL-N
 UART
Thread-Index: AQHXuZ5MX/VfaFrLFEeYbYAmwFc+mqvPTb8AgAKjIYCAAKzwgIAKyN6AgAEfjIA=
Date:   Fri, 22 Oct 2021 04:24:47 +0000
Message-ID: <054143A2-888C-42DF-947A-8CEAFF155292@live.com>
References: <7E63F4C9-6AE9-4E97-9986-B13A397289C5@live.com>
 <YWV4bnbn7VXjYWWy@google.com> <FC366D8C-0360-49B2-B641-5A3FD50E3398@live.com>
 <YWg/1zcfMN2+vuiJ@smile.fi.intel.com> <YXFL05vXfoCV/Go/@google.com>
In-Reply-To: <YXFL05vXfoCV/Go/@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [+UqphtdBVJDLI+aogq3Oef74uUSp5NKExH4K6Su6WirchXfTZyBLN8yf60kVgWfq]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c14c978f-dd0b-466b-55bf-08d99513e1eb
x-ms-traffictypediagnostic: PN1PR0101MB1999:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PGkOiy0i5KkShME69ETC9LcmKxGB28vvv2ALKZWy0xthrqX9r8Rr6oFvUtTtBNG6rLhaeMu6XfFZk6vLkhulK146L8J7XtQm/A0obIIbSujfyF7PVfi5NxTd3H+XjrX6j2u9yfBiD1GlFKH4/3BuNgD/U6Pjmowx+RNAFwcI+9oIKKq0Se4uHYWK5RkQ7O7jtsOAnzxtDm4AMWPwKvLLAuChvxKaBnPw+EG4ztTRLKKK7KmkbNuACaODrPWrVExQ4hCPk9z/j9euIoeLL+im8yJC2ieFGuUB+MVeNILrjIhyLopW94lr63CPI2SWXEkFGbUAarB708mU9pHKOCrj+4hyHwcb7or+3IFyC/8++uNsc5+52rDEfqwzbtbVwrHyJG6A28kQXKebFzfglpH17N+qivpIsJUGLEmGkChtlEuN/VsfGi1eTL9q0DfJkOtTbMk21mD6jkbPBhrCkIOUMjcGxYTfyqU4C8lAKJFBEc/T24NYWrA3n/02aBB6IvRTYLdUJSt5MXZz7/aB6okRynx3dPGjvUN3HUIKWbVWYSc=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: gY7ITT7sIyI+jKt46WmT2g1r7YIex/U6fDVmm5LGVbncyr7HIjI5dVp0ZEIl/whmSm5aXqQV14jx5+rYTpXSCDDv9GTiHWZ0Uv8VAo8bj0E/2cDyOsmGRQwkqNbyAYvDq/rnTeXwdHCvWS/pxkJ4r1TNpSiIyF7WJge8/5BT3J7f2Hs6QxC2he6VtBwCnBSeZvtAvBTDTyqX4Tadq1Z3GYJVnfhn6B53GGp0XiAFOkUt/40Zukp2zRQMcfR23VpnqLk3+QUSi40Ewb/0kZwCKVV4inji5MYX4EtKLEmA2W0y8R7U8qkXSDPQtxtzW5Ub90Wzh7L+LDuPWIqFYN6MfNWfrRDY32pOBjSKiApkn6x49yIzh0+4FHzMAhI5cI8LB/CS0oSNqiDUHQx8SLNhGRbiCyjHftMu279aOrHx2druZC+svjlfOV2BKcimmOWsFzD9rxAG4LkcUl0/c8EurBqVWC00ZTRwiQ+KJ08xyZmjnaIfmDZaNQth4NzD/pIKRrHq4qOjCO/BqD+zxMzF5Wg6Qn7VFT66hWcSmWtmMux8bFsMkiLpY4meg26vKq+LJ37QEjzQfXvgS5giw2GEytffaw8oaA0cBceA55TN/jukuJKe9qvX/lRsEx6ACEfpMfZrXP5BsuoF677GMuw3dqqDJEipiamWnK6RzfW1TemjpOl7cNbDW4sVkPk/Vawjtu/wi1+6CfLN6NmbYp1xlXvwVIp+lcN2y/bKg015axQLDjQjHeWr5BTlZC7/xe2YlL43fnPLLrgrN6xo5R74EXyXoSyVzTwllAI5zxFgmwJhj1oF6DKXCU+Is3mNuoorfrwAKsCItI6KJaepp6AyivO6gcvoyPGnR7eW2TWHjGa02yldM5nN+dMD2UjL2nI5
Content-Type: text/plain; charset="utf-8"
Content-ID: <5F2C9EE6B26E0D4E844A24FEF9592291@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: c14c978f-dd0b-466b-55bf-08d99513e1eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2021 04:24:47.6053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-userprincipalname: gargaditya08@live.com
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN1PR0101MB1999
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQpGcm9tIDc2ZDgyNTNkOTAyMzNiMmMyZDNmYmM4MjM1NWM2MDNiZjBlYjk5NjQgTW9uIFNlcCAx
NyAwMDowMDowMCAyMDAxDQpGcm9tOiBPcmxhbmRvIENoYW1iZXJsYWluIDxyZWRlY29yYXRpbmdA
cHJvdG9ubWFpbC5jb20+DQpEYXRlOiBGcmksIDEgT2N0IDIwMjEgMTM6MzA6MTkgKzA1MzANClN1
YmplY3Q6IFtQQVRDSF0gQWRkIHN1cHBvcnQgZm9yIE1hY0Jvb2tQcm8xNiwyIFVBUlQNCkNjOiBz
dGFibGVAdmdlci5rZXJuZWwub3JnDQoNCkFkZGVkIDgwODY6MzhhOCB0byB0aGUgaW50ZWxfbHBz
c19wY2kgZHJpdmVyLiBJdCBpcyBhbiBJbnRlbCBJY2UgTGFrZSBQQ0gtTiBVQVJUIGNvbnRyb2xs
ZXIgcHJlc2VudCBvbiB0aGUgTWFjQm9va1BybzE2LDIuDQoNClNpZ25lZC1vZmYtYnk6IEFkaXR5
YSBHYXJnIDxnYXJnYWRpdHlhMDhAbGl2ZS5jb20+DQotLS0NCiBkcml2ZXJzL21mZC9pbnRlbC1s
cHNzLXBjaS5jIHwgMiArKw0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCg0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbWZkL2ludGVsLWxwc3MtcGNpLmMgYi9kcml2ZXJzL21mZC9pbnRl
bC1scHNzLXBjaS5jDQppbmRleCBjNTRkMTlmYjEuLjMzZDUwNDNmZCAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvbWZkL2ludGVsLWxwc3MtcGNpLmMNCisrKyBiL2RyaXZlcnMvbWZkL2ludGVsLWxwc3Mt
cGNpLmMNCkBAIC0yNTMsNiArMjUzLDggQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNl
X2lkIGludGVsX2xwc3NfcGNpX2lkc1tdID0gew0KIAl7IFBDSV9WREVWSUNFKElOVEVMLCAweDM0
ZWEpLCAoa2VybmVsX3Vsb25nX3QpJmJ4dF9pMmNfaW5mbyB9LA0KIAl7IFBDSV9WREVWSUNFKElO
VEVMLCAweDM0ZWIpLCAoa2VybmVsX3Vsb25nX3QpJmJ4dF9pMmNfaW5mbyB9LA0KIAl7IFBDSV9W
REVWSUNFKElOVEVMLCAweDM0ZmIpLCAoa2VybmVsX3Vsb25nX3QpJnNwdF9pbmZvIH0sDQorCS8q
IElDTC1OKi8NCisJeyBQQ0lfVkRFVklDRShJTlRFTCwgMHgzOGE4KSwgKGtlcm5lbF91bG9uZ190
KSZieHRfdWFydF9pbmZvIH0sDQogCS8qIFRHTC1IICovDQogCXsgUENJX1ZERVZJQ0UoSU5URUws
IDB4NDNhNyksIChrZXJuZWxfdWxvbmdfdCkmYnh0X3VhcnRfaW5mbyB9LA0KIAl7IFBDSV9WREVW
SUNFKElOVEVMLCAweDQzYTgpLCAoa2VybmVsX3Vsb25nX3QpJmJ4dF91YXJ0X2luZm8gfSwNCg0K
PiBPbiAyMS1PY3QtMjAyMSwgYXQgNDo0NSBQTSwgTGVlIEpvbmVzIDxsZWUuam9uZXNAbGluYXJv
Lm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBUaHUsIDE0IE9jdCAyMDIxLCBhbmRyaXkuc2hldmNoZW5r
b0BsaW51eC5pbnRlbC5jb20gd3JvdGU6DQo+IA0KPj4gT24gVGh1LCBPY3QgMTQsIDIwMjEgYXQg
MDQ6MTU6MDVBTSArMDAwMCwgQWRpdHlhIEdhcmcgd3JvdGU6DQo+PiANCj4+IEVudGlyZSBtZXNz
YWdlIGxvb2tzIGxpa2UgYSBtZXNzLiBBcmUgeW91IHN1cmUgeW91IGFyZSB1c2luZyBwcm9wZXIg
dG9vbHMNCj4+IGZvciBzZW5kaW5nIGl0Pw0KPiANCj4gQWdyZWVkLg0KPiANCj4gSSBjYW4ndCBh
cHBseSB0aGlzIHVudGlsIGl0J3Mgc3VibWl0dGVkIHByb3Blcmx5Lg0KPiANCj4gLSBQbGVhc2Ug
cmVhZCBEb2N1bWVudGF0aW9uL3Byb2Nlc3Mvc3VibWl0dGluZy1wYXRjaGVzLnJzdA0KPiAtIFBs
ZWFzZSByZWFkIERvY3VtZW50YXRpb24vcHJvY2Vzcy9jb2Rpbmctc3R5bGUucnN0DQo+IA0KPiBJ
ZiB5b3UgaGF2ZSBhbnkgcXVlc3Rpb25zLCBwbGVhc2UgcmVhY2ggb3V0LiAgV2UncmUgaGFwcHkg
dG8gaGVscC4NCj4gDQo+IC0tIA0KPiBMZWUgSm9uZXMgW+adjueQvOaWr10NCj4gU2VuaW9yIFRl
Y2huaWNhbCBMZWFkIC0gRGV2ZWxvcGVyIFNlcnZpY2VzDQo+IExpbmFyby5vcmcg4pSCIE9wZW4g
c291cmNlIHNvZnR3YXJlIGZvciBBcm0gU29Dcw0KPiBGb2xsb3cgTGluYXJvOiBGYWNlYm9vayB8
IFR3aXR0ZXIgfCBCbG9nDQoNCg==
