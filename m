Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292925F8774
	for <lists+stable@lfdr.de>; Sat,  8 Oct 2022 23:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiJHVLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Oct 2022 17:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiJHVLY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Oct 2022 17:11:24 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A212937421
        for <stable@vger.kernel.org>; Sat,  8 Oct 2022 14:11:21 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-147-t6CPbisBOIOcGiX5wD9joQ-1; Sat, 08 Oct 2022 22:11:18 +0100
X-MC-Unique: t6CPbisBOIOcGiX5wD9joQ-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Sat, 8 Oct
 2022 22:11:17 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Sat, 8 Oct 2022 22:11:17 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>,
        Andrew Chernyakov <acherniakov@astralinux.ru>
CC:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>,
        Stephen Boyd <sboyd@kernel.org>,
        "Bjorn Andersson" <bjorn.andersson@linaro.org>
Subject: RE: [PATCH 5.10 1/1] rpmsg: qcom: glink: replace strncpy() with
 strscpy_pad()
Thread-Topic: [PATCH 5.10 1/1] rpmsg: qcom: glink: replace strncpy() with
 strscpy_pad()
Thread-Index: AQHY2mtsv76/5V4qLkGo5JA5B025Q64E/zsA
Date:   Sat, 8 Oct 2022 21:11:16 +0000
Message-ID: <36f776cbc16f4e988d96b7bcb77cd559@AcuMS.aculab.com>
References: <20221007132931.123755-1-acherniakov@astralinux.ru>
 <20221007132931.123755-2-acherniakov@astralinux.ru>
 <Y0BWc6A8C++M9TWP@kroah.com>
In-Reply-To: <Y0BWc6A8C++M9TWP@kroah.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogR3JlZyBLcm9haC1IYXJ0bWFuDQo+IFNlbnQ6IDA3IE9jdG9iZXIgMjAyMiAxNzo0MA0K
PiANCj4gT24gRnJpLCBPY3QgMDcsIDIwMjIgYXQgMDQ6Mjk6MzFQTSArMDMwMCwgQW5kcmV3IENo
ZXJueWFrb3Ygd3JvdGU6DQo+ID4gRnJvbTogS3J6eXN6dG9mIEtvemxvd3NraSA8a3J6eXN6dG9m
Lmtvemxvd3NraUBsaW5hcm8ub3JnPg0KPiA+DQo+ID4gY29tbWl0IDc2NjI3OWE4Zjg1ZGYzMjM0
NWRiZGEwM2IxMDJjYTFlZTNkNWRkZWEgdXBzdHJlYW0uDQo+ID4NCj4gPiBUaGUgdXNlIG9mIHN0
cm5jcHkoKSBpcyBjb25zaWRlcmVkIGRlcHJlY2F0ZWQgZm9yIE5VTC10ZXJtaW5hdGVkDQo+ID4g
c3RyaW5nc1sxXS4gUmVwbGFjZSBzdHJuY3B5KCkgd2l0aCBzdHJzY3B5X3BhZCgpLCB0byBrZWVw
IGV4aXN0aW5nDQo+ID4gcGFkLWJlaGF2aW9yIG9mIHN0cm5jcHksIHNpbWlsYXJseSB0byBjb21t
aXQgMDhkZTQyMGE4MDE0ICgicnBtc2c6DQo+ID4gZ2xpbms6IFJlcGxhY2Ugc3RybmNweSgpIHdp
dGggc3Ryc2NweV9wYWQoKSIpLiAgVGhpcyBmaXhlcyBXPTEgd2FybmluZzoNCj4gPg0KPiA+ICAg
SW4gZnVuY3Rpb24g4oCYcWNvbV9nbGlua19yeF9jbG9zZeKAmSwNCj4gPiAgICAgaW5saW5lZCBm
cm9tIOKAmHFjb21fZ2xpbmtfd29ya+KAmSBhdCAuLi9kcml2ZXJzL3JwbXNnL3Fjb21fZ2xpbmtf
bmF0aXZlLmM6MTYzODo0Og0KPiA+ICAgZHJpdmVycy9ycG1zZy9xY29tX2dsaW5rX25hdGl2ZS5j
OjE1NDk6MTc6IHdhcm5pbmc6IOKAmHN0cm5jcHnigJkgc3BlY2lmaWVkIGJvdW5kIDMyIGVxdWFs
cw0KPiBkZXN0aW5hdGlvbiBzaXplIFstV3N0cmluZ29wLXRydW5jYXRpb25dDQo+ID4gICAgMTU0
OSB8ICAgICAgICAgICAgICAgICBzdHJuY3B5KGNoaW5mby5uYW1lLCBjaGFubmVsLT5uYW1lLCBz
aXplb2YoY2hpbmZvLm5hbWUpKTsNCj4gPg0KPiA+IFsxXSBodHRwczovL3d3dy5rZXJuZWwub3Jn
L2RvYy9odG1sL2xhdGVzdC9wcm9jZXNzL2RlcHJlY2F0ZWQuaHRtbCNzdHJuY3B5LW9uLW51bC10
ZXJtaW5hdGVkLXN0cmluZ3MNCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEtyenlzenRvZiBLb3ps
b3dza2kgPGtyenlzenRvZi5rb3psb3dza2lAbGluYXJvLm9yZz4NCj4gPiBSZXZpZXdlZC1ieTog
U3RlcGhlbiBCb3lkIDxzYm95ZEBrZXJuZWwub3JnPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEJqb3Ju
IEFuZGVyc3NvbiA8Ympvcm4uYW5kZXJzc29uQGxpbmFyby5vcmc+DQo+ID4gTGluazogaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvci8yMDIyMDUxOTA3MzMzMC43MTg3LTEta3J6eXN6dG9mLmtvemxv
d3NraUBsaW5hcm8ub3JnDQo+ID4gU2lnbmVkLW9mZi1ieTogQW5kcmV3IENoZXJueWFrb3YgPGFj
aGVybmlha292QGFzdHJhbGludXgucnU+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvcnBtc2cvcWNv
bV9nbGlua19uYXRpdmUuYyB8IDIgKy0NCj4gPiAgZHJpdmVycy9ycG1zZy9xY29tX3NtZC5jICAg
ICAgICAgIHwgNCArKy0tDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAz
IGRlbGV0aW9ucygtKQ0KPiANCj4gV2h5IGp1c3QgdGhpcyBzcGVjaWZpYyBrZXJuZWwgYnJhbmNo
PyAgV2UgY2FuJ3QgYWRkIHBhdGNoZXMgdG8gYW4gb2xkZXINCj4gdHJlZSBhbmQgaGF2ZSBzb21l
b25lIHVwZ3JhZGUgdG8gYSBuZXdlciBvbmUgYW5kIGhpdCB0aGUgc2FtZSBpc3N1ZS4NCj4gDQo+
IFNvIHBsZWFzZSBwcm92aWRlIGJhY2twb3J0cyBmb3IgYWxsIGFjdGl2ZSB2ZXJzaW9ucy4gIElu
IHRoaXMgY2FzZSB0aGF0DQo+IHdvdWxkIGJlIDUuMTUueSBhbmQgNS4xOS55Lg0KDQpJZiBpdCBp
cyBvbmx5IGZpeGluZyBhIGNvbXBpbGUgd2FybmluZyBpcyBpdCBldmVuIHN0YWJsZSBtYXRlcmlh
bD8NClRoZSBnZW5lcmljIGNvbW1pdCBtZXNzYWdlIGRvZXNuJ3Qgc2F5IHdoZXRoZXIgdGhlIG9s
ZCBjb2RlIHdhcw0KYWN0dWFsbHkgcmlnaHQgb3Igd3JvbmcuDQoNCkF0IGxlYXN0IG9uZSBvZiB0
aGVzZSAncmVwbGFjZSBzdHJuY3B5KCknIGNoYW5nZXMgd2FzIGRlZmluaXRlbHkNCmJyb2tlbiAo
dGhlIGNvcHkgbmVlZGVkIHRvIGJlIGVxdWl2YWxlbnQgdG8gbWVtY3B5KCkpLg0KDQpTbyBhcHBs
eWluZyBBTlkgb2YgdGhlbSB0byBzdGFibGUgdW5sZXNzIHRoZXkgYWN0dWFsbHkgZml4DQphIHJl
YWwgYnVnIHNlZW1zIGR1YmlvdXMuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3Mg
TGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQ
VCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

