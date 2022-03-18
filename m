Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA77F4DD535
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 08:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbiCRH2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 03:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbiCRH23 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 03:28:29 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80125.outbound.protection.outlook.com [40.107.8.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21EE2EBF92;
        Fri, 18 Mar 2022 00:27:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bi3Rbim4ep6jRKJ3MzU58uPjg3eZDvijijtc/PZRKWG013mVcFGbmD8VFq9v5tvCWQ3+pvwqeYY+rpd/EBAp2nd9axZfleLP4BTFhYzwirA9vBoBChHHkQ/uR5GGuOwbn05PSoKz4BhrAnTrqtQy+1Mfbs7s45FbK3aaGuLgVqje1KUHP3gWKI7Ru3dlQbpRhDT1oCNilJhgILQNHh8UPiX5qiZZ7y5gToQ5wUga6rG+1CmHe30yoYdBJbNHtwGRF/vulARR9NZlww6QP2n+GvYYjXobORXXa+B5LqsjSLoHHi5p/hSXpsKK69M0jsFIoh55tbFio3oSpfWusXJTmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3inpjq57RrM1ddQNuIkgS4Est829t1FYyQFAww7i3zQ=;
 b=H7Dil8xgIkUKmrRnzRgTrk8A5i7MgkRE2IuDvFKcxIP8yeifWfF+1ee8BRJmRX5OSExCywOGkPjl/IeKzs1CubN+DRQXOQVO/oIZM+K0MfsimcKv/OmQonG1wwIglgktgtvIjnY8Pc3ptob19Z759dNOg57X4V45TtBP7In6J5D6eJBBfKS+AydoNVMePsX88JoQyPEvrSujfjQRD3u/DRHvtbYJWepFSYKAAiUm1tFy0zo/1b85d+1i+g/7gP+PpLmlhVbWtfUd8Sb7sU8oy3eALsC/Ee+CWwkMsmIoTLdn3XVnuAnKVhJtQ7cSsV36kIAOlN4GQxwtasNHSWEIYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3inpjq57RrM1ddQNuIkgS4Est829t1FYyQFAww7i3zQ=;
 b=BWlpqSlwmjrN5lISJIwvlAmP42PbaHH0ziUIo39pruMhpc+ZVDbDtSX7Bm/sSuB/i0Qh6CuuEuGCNnB4OjZJOgUeyUtJQgewnY8i9xWBLEziym+7pPlTLrOq8PZQ09u0OPH1Ys0qkK2mYKEjEx+EF8nDmQwzGQJVN/xdOerpTLY=
Received: from HE1PR07MB3450.eurprd07.prod.outlook.com (2603:10a6:7:2c::17) by
 AM7PR07MB6946.eurprd07.prod.outlook.com (2603:10a6:20b:1b8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.7; Fri, 18 Mar
 2022 07:27:08 +0000
Received: from HE1PR07MB3450.eurprd07.prod.outlook.com
 ([fe80::85af:b59b:2357:8d9e]) by HE1PR07MB3450.eurprd07.prod.outlook.com
 ([fe80::85af:b59b:2357:8d9e%6]) with mapi id 15.20.5081.014; Fri, 18 Mar 2022
 07:27:08 +0000
From:   "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "memxor@gmail.com" <memxor@gmail.com>,
        "ast@kernel.org" <ast@kernel.org>
Subject: Re: [PATCH 5.4 21/43] selftests/bpf: Add test for bpf_timer
 overwriting crash
Thread-Topic: [PATCH 5.4 21/43] selftests/bpf: Add test for bpf_timer
 overwriting crash
Thread-Index: AQHYOpmQ1TYofY4SQ0uVQYCDF8f92w==
Date:   Fri, 18 Mar 2022 07:27:07 +0000
Message-ID: <a0a7298ca5c64b3d0ecfcc8821c2de79186fa9f7.camel@nokia.com>
References: <20220314112734.415677317@linuxfoundation.org>
         <20220314112735.013019647@linuxfoundation.org>
In-Reply-To: <20220314112735.013019647@linuxfoundation.org>
Accept-Language: en-US, en-150, fi-FI
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.4 (3.42.4-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nokia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e96d31c7-a5ee-4f35-4319-08da08b0b5e0
x-ms-traffictypediagnostic: AM7PR07MB6946:EE_
x-microsoft-antispam-prvs: <AM7PR07MB6946BD496BA044B62807ED43B4139@AM7PR07MB6946.eurprd07.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZjJOkuaMQCTeVsd+I8aPSE0n2EM8wQv8hQZzo/hAg6KGbVJmsRE+eRTZYGUSOlBGu7EAdZN1qo7fgusvM/4QFIhgH1B65G9cNrxT/CvdJYY6uMHiRg6FIqtvYAT3k8BrX3BXi5ArAW/fwx3hH8QDiqnRlf8mX69NaTclmnTHjlZDaF3489voejjx2uz2pgvFae0gnlyn9E1GhmRWWbUz5JVKvGw+X73ZXIljyZVnKDNJOkzkm+X93lih0sftb9ecaKFzinXviJskfTHSvWkirwf0Anc4d+PLiHp1SXrBPIr3NCXQkY1e2Yze3AVD2sI4bTqITQvAQTCfbpvcQUS6RiyPOQoU4De/GWjbdlqyv/+xO+NZPPQGNVdswDXQO/2OZVGWEYO79Yu2/qNt48WNlJ++bCQfRvCTgBkajVIsqOVRoTsnAOjzmuj50HCGAN3i9C91fXP9rDsuu//1FvDFXhmTyKIsmjlggLohIZpWrb+WJFArpAl/mlX1b23Mwa9pzPPLnF8NLCg/iBDg5iUZ7tawWqk9go7QQAIBDPaKbWZgc/vWjAfnMIq5VO8w3Zxx6PwBcD95EUZ1Sls2JAprju+vK5xHK/690dakilnX7uvim9Rael2fY585whYE7wwxiWRmWXBy6DyPaA03AXzW18YNxUuOBqGwCivC0Tr1jA+dpzfOL4CB1UuezknG7fOLR5Jt37Du4VJdbLw2RDALjKA+4lZgBl5qBFdK1gGrIfij4P0O6GNTBKbnVYLgdE1lTXe7qM4SBwyIGs6BpFg2jGwglCE9affgsgYoKwReHAs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR07MB3450.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(2906002)(8936002)(83380400001)(38100700002)(110136005)(5660300002)(8676002)(6506007)(82960400001)(122000001)(508600001)(316002)(966005)(54906003)(2616005)(66556008)(36756003)(66476007)(26005)(4326008)(76116006)(66946007)(66446008)(64756008)(6486002)(71200400001)(38070700005)(86362001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VzlJTGRUSlVDV2xWb1FzVlVOc3I0dTlhNDhQdUdxcUlRVnc1dGNGcC9Ic1pQ?=
 =?utf-8?B?WTU3aFZza0JyQi9jNEo2eit5bEtuQUc1WTlhK0ZIS09UbEFVeFRYYVZ1Y090?=
 =?utf-8?B?M0hzV3VseHJlQ3RSSmpla3ZCVHBoQ0RNOXlmSi9xTjk0ZDN4a05KUmNQMmsv?=
 =?utf-8?B?dzl1RjUvUW5iWWVlcG1vYWhDYkZ3ZjYvUHd1WndZTjJXVm9zWFVRbHVwc1M3?=
 =?utf-8?B?N1BJWEhZemsyMVJjMnVvOFNMK1UyTnJNMjVLdVorcGpIMGZobG54eEZmVXJC?=
 =?utf-8?B?ZTkzZTVScGV3S1d0R1MzbFVqa0twZzBhOHZFTmtGemNGTjNKL21IZVBUS1JW?=
 =?utf-8?B?OVNkYUozK25NWkg2eWF4L3BlZWs1azAvRko3ZW4vQTQ4cHU2RHR4Q3R6Rlo4?=
 =?utf-8?B?a20vQU5PeERERDk0T2xUNmlBUDZtOVc4ajJkM0x3dDdtRUxnSWJOYUxzMFBU?=
 =?utf-8?B?NGVwRi9qZS93VU00R0E2dkFXTTZBV2xPcE53U01DdkJ6ckRnNmxSc21RUGp0?=
 =?utf-8?B?Tzlndm8vMFZERmgrMjFrbjBjWVlJRU5sYjBNamFJSXZJZzdYT3hJRVEvMDI4?=
 =?utf-8?B?UmJFam1XYmlMUkNrYzN4ODlCZWVNdkRxK3JWcUFOM0FCMjM3ejJTWUc0ZGhz?=
 =?utf-8?B?UXJQUHN0Mkdja3dOVXlYVmJ0REdQd0NXZ0VCVWpoNDgyUnNSQWptYVlsMk82?=
 =?utf-8?B?REhJVzR1TXJMVDRFZE5HejAxMENabjVSTlFrSVFtSG9jWkhLeW5JeU5tTFh2?=
 =?utf-8?B?SEV6d3d1dHR2eDhPOCszcnJFSHVmem5iZ2h0SnJkR1NQTFVVRVV0OGtuYVFk?=
 =?utf-8?B?WmtOaFlRcXBkR3RkQmliTnIvcW9yTXpyYVdxWnVsbzBGQS92NjRJYWtnM283?=
 =?utf-8?B?a1UxUGhENVFXa2lpaGdwMmlPOUVtN2RYVll2M1l2b211b0dxVnhNbVZyWUNu?=
 =?utf-8?B?Z09jQlBvQ0p5RHI0Skhodlo0dExmbTc2a3k3UFRpKys1eU5KaHpHMGY2S3M4?=
 =?utf-8?B?SnVESTJiK3Z3anJQWmlvdUtOV1dDSjl0dGhienJOQmlYSVhFejZHc1Ivek12?=
 =?utf-8?B?OW9BeklVM2t6dk0vU1R0TEVUR1Z0RVJwRWx2YkhZeDAvWVc5QjJTTVU0alhN?=
 =?utf-8?B?S21OUW5jbUZqTFdhZDY5YlpOMGZaaGs1YzBLWUFCMmp3Wkxpd1VQZzB3RVNi?=
 =?utf-8?B?dnhQeDRiTVhrMFJOVUdXV0ZmdG1VNUNGYTJrQzA4bTVkTGYwcmgvWlAyajRS?=
 =?utf-8?B?L0R5TkZNOGtNZEU2Y0pMTUlKNlBielV6Q1VJdGJNaEtxTGNLRG94MDlESHhp?=
 =?utf-8?B?YVJjWkVXQ2VDSlRuTnVrR1dWY3Z3SVJScnN2Q3pLa0JsZXVUS2o4MlJGTXdo?=
 =?utf-8?B?M1ZNYm8xeW1LWmthaTU5T0JpY2ZyR1pJSkt4UExqR21wK3ZMWUNPNGhjNy9i?=
 =?utf-8?B?WWdGUSs5M1JmWk0vU2N0a3lHVHBVV3hzczIrSXdnTVNwUUs1bmtiR3YycmYv?=
 =?utf-8?B?Ym92Y1ltS2dSSm1GazN3eGI3YkNycG5ETkpsSktRdTlDU0lOUWsvejNJblVq?=
 =?utf-8?B?S0h0UzFHRFliaUpaYnZjTG1CQ0h3SmhyUHQrTFlXZUs5Zm9Od1BkL2ZPcloy?=
 =?utf-8?B?NFh4S05LOWRXQUVVTVB6dWFuYnF4QUtUazBudEhZZGdvVWUxaE1xR2orc09i?=
 =?utf-8?B?VGdTZUI1K2hzd1ltYjc2Y0h4dFR5VGR2aVRQLzdyUmhVRTN2WnFyQjBXU2NR?=
 =?utf-8?B?R2hpQ1U2UWtoVmVQOVpZMlRBMGRoRWZwOC84UVZJY3NRd3hKYnRCckRPVm9k?=
 =?utf-8?B?S3U5enpPTEprb3BBbm02UjBraXVqNW9jUHdxbmMySXVtdzVyaUwvQUd1eVFO?=
 =?utf-8?B?RThOeXN6ck9xZDJiMTVrNjE1NUY2a2NWVUc3ZWRud1NRVkVwR0JkVE1Td0Zv?=
 =?utf-8?B?M0oxSENEQXJKNXo1SUxDQzVRUVE2eEhjMitBa0t3bXdla1pJQmlBZkc5SWRu?=
 =?utf-8?B?UWtSVUg1TSt3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A36F6FD691554D47A8E374252AFB2E66@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR07MB3450.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e96d31c7-a5ee-4f35-4319-08da08b0b5e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2022 07:27:08.0923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H41MyrdP+e6Gsicg88qUa35BMPmYpNR8yDhu4SjjTaf/mZROq5ZBIUCCyos1W7eBWUchmcR8RPEva68xj8ix3+JcZ6otNpd+D7Qg7R6mRGo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR07MB6946
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gTW9uLCAyMDIyLTAzLTE0IGF0IDEyOjUzICswMTAwLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3Jv
dGU6DQo+IEZyb206IEt1bWFyIEthcnRpa2V5YSBEd2l2ZWRpIDxtZW14b3JAZ21haWwuY29tPg0K
PiANCj4gWyBVcHN0cmVhbSBjb21taXQgYTdlNzUwMTZhMDc1M2MyNGQ2Yzk5NWJjMDI1MDFhZTM1
MzY4ZTMzMyBdDQo+IA0KPiBBZGQgYSB0ZXN0IHRoYXQgdmFsaWRhdGVzIHRoYXQgdGltZXIgdmFs
dWUgaXMgbm90IG92ZXJ3cml0dGVuIHdoZW4gZG9pbmcNCj4gYSBjb3B5X21hcF92YWx1ZSBjYWxs
IGluIHRoZSBrZXJuZWwuIFdpdGhvdXQgdGhlIHByaW9yIGZpeCwgdGhpcyB0ZXN0DQo+IHRyaWdn
ZXJzIGEgY3Jhc2guDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBLdW1hciBLYXJ0aWtleWEgRHdpdmVk
aSA8bWVteG9yQGdtYWlsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQWxleGVpIFN0YXJvdm9pdG92
IDxhc3RAa2VybmVsLm9yZz4NCj4gTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYnBmLzIw
MjIwMjA5MDcwMzI0LjEwOTMxODItMy1tZW14b3JAZ21haWwuY29tDQo+IFNpZ25lZC1vZmYtYnk6
IFNhc2hhIExldmluIDxzYXNoYWxAa2VybmVsLm9yZz4NCg0KSGksIHRoaXMgcGF0Y2ggaW4gNS40
LjE4NSBicmVha3MgYnBmIHNlbGZ0ZXN0cyBidWlsZCBmb3IgbWU6DQoNCiAgcHJvZ3MvdGltZXJf
Y3Jhc2guYzozOjEwOiBmYXRhbCBlcnJvcjogJ3ZtbGludXguaCcgZmlsZSBub3QgZm91bmQNCiAg
I2luY2x1ZGUgPHZtbGludXguaD4NCiAgICAgICAgICAgXn5+fn5+fn5+fn4NCg0KQmFzZWQgb24g
cXVpY2sgbG9vaywgdm1saW51eC5oIGdlbmVyYXRpb24gd2FzIGFkZGVkIHRvIHNlbGZ0ZXN0cyBp
biB2NS43LA0Kc28gZHJvcCB0aGlzIHBhdGNoIGluIHY1LjQ/DQoNCi1Ub21taQ0KDQoNCj4gLS0t
DQo+ICAuLi4vc2VsZnRlc3RzL2JwZi9wcm9nX3Rlc3RzL3RpbWVyX2NyYXNoLmMgICAgfCAzMiAr
KysrKysrKysrKw0KPiAgLi4uL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy90aW1lcl9jcmFz
aC5jIHwgNTQgKysrKysrKysrKysrKysrKysrKw0KPiAgMiBmaWxlcyBjaGFuZ2VkLCA4NiBpbnNl
cnRpb25zKCspDQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMv
YnBmL3Byb2dfdGVzdHMvdGltZXJfY3Jhc2guYw0KPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IHRvb2xz
L3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy90aW1lcl9jcmFzaC5jDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3RpbWVyX2NyYXNoLmMgYi90
b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvdGltZXJfY3Jhc2guYw0KPiBuZXcgZmls
ZSBtb2RlIDEwMDY0NA0KPiBpbmRleCAwMDAwMDAwMDAwMDAuLmY4Zjc5NDRlNzBkYQ0KPiAtLS0g
L2Rldi9udWxsDQo+ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy90aW1l
cl9jcmFzaC5jDQo+IEBAIC0wLDAgKzEsNTQgQEANCj4gKy8vIFNQRFgtTGljZW5zZS1JZGVudGlm
aWVyOiBHUEwtMi4wDQo+ICsNCj4gKyNpbmNsdWRlIDx2bWxpbnV4Lmg+DQo+ICsjaW5jbHVkZSA8
YnBmL2JwZl90cmFjaW5nLmg+DQo+ICsjaW5jbHVkZSA8YnBmL2JwZl9oZWxwZXJzLmg+DQo+ICsN
Cg0K
