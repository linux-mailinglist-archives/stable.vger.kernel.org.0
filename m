Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6137195DAD
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 19:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgC0Sbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 14:31:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:54829 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgC0Sbm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Mar 2020 14:31:42 -0400
IronPort-SDR: NhpQelx26bGobiSxOyWhAgQQ99DVG0HC1j4z38idCJDD62cIahcCLKYGmlRbwJumy4KSChjqUH
 b2+RC/0jo6lw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2020 11:31:41 -0700
IronPort-SDR: cG8RjTzfhLi4jFGoL06K+0MCYrphuSQ6j6Otn7RFY/vjq3MDzwBD4xlE+JuyjrPphbmASo3WnQ
 K0rGnG1d3UGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,313,1580803200"; 
   d="scan'208";a="247970686"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga003.jf.intel.com with ESMTP; 27 Mar 2020 11:31:40 -0700
Received: from fmsmsx154.amr.corp.intel.com (10.18.116.70) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 27 Mar 2020 11:31:40 -0700
Received: from fmsmsx107.amr.corp.intel.com ([169.254.6.38]) by
 FMSMSX154.amr.corp.intel.com ([169.254.6.41]) with mapi id 14.03.0439.000;
 Fri, 27 Mar 2020 11:31:40 -0700
From:   "Ruhl, Michael J" <michael.j.ruhl@intel.com>
To:     Marek Szyprowski <m.szyprowski@samsung.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Bartlomiej Zolnierkiewicz" <b.zolnierkie@samsung.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>,
        Shane Francis <bigbeeshane@gmail.com>
Subject: RE: [PATCH v2] drm/prime: fix extracting of the DMA addresses from
 a scatterlist
Thread-Topic: [PATCH v2] drm/prime: fix extracting of the DMA addresses from
 a scatterlist
Thread-Index: AQHWBFQRvRx+hOOiski5ycfWmHv7Tahcuvpg
Date:   Fri, 27 Mar 2020 18:31:39 +0000
Message-ID: <14063C7AD467DE4B82DEDB5C278E8663FFFBFCE1@fmsmsx107.amr.corp.intel.com>
References: <CGME20200327162330eucas1p1b0413e0e9887aa76d3048f86d2166dcd@eucas1p1.samsung.com>
 <20200327162126.29705-1-m.szyprowski@samsung.com>
In-Reply-To: <20200327162126.29705-1-m.szyprowski@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Pi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogTWFyZWsgU3p5cHJvd3NraSA8bS5z
enlwcm93c2tpQHNhbXN1bmcuY29tPg0KPlNlbnQ6IEZyaWRheSwgTWFyY2ggMjcsIDIwMjAgMTI6
MjEgUE0NCj5UbzogZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZzsgbGludXgtc2Ftc3Vu
Zy1zb2NAdmdlci5rZXJuZWwub3JnOw0KPmxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj5D
YzogTWFyZWsgU3p5cHJvd3NraSA8bS5zenlwcm93c2tpQHNhbXN1bmcuY29tPjsNCj5zdGFibGVA
dmdlci5rZXJuZWwub3JnOyBCYXJ0bG9taWVqIFpvbG5pZXJraWV3aWN6DQo+PGIuem9sbmllcmtp
ZUBzYW1zdW5nLmNvbT47IE1hYXJ0ZW4gTGFua2hvcnN0DQo+PG1hYXJ0ZW4ubGFua2hvcnN0QGxp
bnV4LmludGVsLmNvbT47IE1heGltZSBSaXBhcmQNCj48bXJpcGFyZEBrZXJuZWwub3JnPjsgVGhv
bWFzIFppbW1lcm1hbm4gPHR6aW1tZXJtYW5uQHN1c2UuZGU+Ow0KPkRhdmlkIEFpcmxpZSA8YWly
bGllZEBsaW51eC5pZT47IERhbmllbCBWZXR0ZXIgPGRhbmllbEBmZndsbC5jaD47IEFsZXggRGV1
Y2hlcg0KPjxhbGV4YW5kZXIuZGV1Y2hlckBhbWQuY29tPjsgU2hhbmUgRnJhbmNpcyA8YmlnYmVl
c2hhbmVAZ21haWwuY29tPjsNCj5SdWhsLCBNaWNoYWVsIEogPG1pY2hhZWwuai5ydWhsQGludGVs
LmNvbT4NCj5TdWJqZWN0OiBbUEFUQ0ggdjJdIGRybS9wcmltZTogZml4IGV4dHJhY3Rpbmcgb2Yg
dGhlIERNQSBhZGRyZXNzZXMgZnJvbSBhDQo+c2NhdHRlcmxpc3QNCj4NCj5TY2F0dGVybGlzdCBl
bGVtZW50cyBjb250YWlucyBib3RoIHBhZ2VzIGFuZCBETUEgYWRkcmVzc2VzLCBidXQgb25lDQo+
c2hvdWxkIG5vdCBhc3N1bWUgMToxIHJlbGF0aW9uIGJldHdlZW4gdGhlbS4gVGhlIHNnLT5sZW5n
dGggaXMgdGhlIHNpemUNCj5vZiB0aGUgcGh5c2ljYWwgbWVtb3J5IGNodW5rIGRlc2NyaWJlZCBi
eSB0aGUgc2ctPnBhZ2UsIHdoaWxlDQo+c2dfZG1hX2xlbihzZykgaXMgdGhlIHNpemUgb2YgdGhl
IERNQSAoSU8gdmlydHVhbCkgY2h1bmsgZGVzY3JpYmVkIGJ5DQo+dGhlIHNnX2RtYV9hZGRyZXNz
KHNnKS4NCj4NCj5UaGUgcHJvcGVyIHdheSBvZiBleHRyYWN0aW5nIGJvdGg6IHBhZ2VzIGFuZCBE
TUEgYWRkcmVzc2VzIG9mIHRoZSB3aG9sZQ0KPmJ1ZmZlciBkZXNjcmliZWQgYnkgYSBzY2F0dGVy
bGlzdCBpdCB0byBpdGVyYXRlIGluZGVwZW5kZW50bHkgb3ZlciB0aGUNCj5zZy0+cGFnZXMvc2ct
Pmxlbmd0aCBhbmQgc2dfZG1hX2FkZHJlc3Moc2cpL3NnX2RtYV9sZW4oc2cpIGVudHJpZXMuDQo+
DQo+Rml4ZXM6IDQyZTY3YjQ3OWVhYiAoImRybS9wcmltZTogdXNlIGRtYSBsZW5ndGggbWFjcm8g
d2hlbiBtYXBwaW5nIHNnIikNCj5TaWduZWQtb2ZmLWJ5OiBNYXJlayBTenlwcm93c2tpIDxtLnN6
eXByb3dza2lAc2Ftc3VuZy5jb20+DQo+UmV2aWV3ZWQtYnk6IEFsZXggRGV1Y2hlciA8YWxleGFu
ZGVyLmRldWNoZXJAYW1kLmNvbT4NCj4tLS0NCj4gZHJpdmVycy9ncHUvZHJtL2RybV9wcmltZS5j
IHwgMzcgKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tDQo+LQ0KPiAxIGZpbGUg
Y2hhbmdlZCwgMjUgaW5zZXJ0aW9ucygrKSwgMTIgZGVsZXRpb25zKC0pDQo+DQo+ZGlmZiAtLWdp
dCBhL2RyaXZlcnMvZ3B1L2RybS9kcm1fcHJpbWUuYyBiL2RyaXZlcnMvZ3B1L2RybS9kcm1fcHJp
bWUuYw0KPmluZGV4IDFkZTJjZGUyMjc3Yy4uMjgyNzc0ZTQ2OWFjIDEwMDY0NA0KPi0tLSBhL2Ry
aXZlcnMvZ3B1L2RybS9kcm1fcHJpbWUuYw0KPisrKyBiL2RyaXZlcnMvZ3B1L2RybS9kcm1fcHJp
bWUuYw0KPkBAIC05NjIsMjcgKzk2Miw0MCBAQCBpbnQgZHJtX3ByaW1lX3NnX3RvX3BhZ2VfYWRk
cl9hcnJheXMoc3RydWN0DQo+c2dfdGFibGUgKnNndCwgc3RydWN0IHBhZ2UgKipwYWdlcywNCj4g
CXVuc2lnbmVkIGNvdW50Ow0KPiAJc3RydWN0IHNjYXR0ZXJsaXN0ICpzZzsNCj4gCXN0cnVjdCBw
YWdlICpwYWdlOw0KPi0JdTMyIGxlbiwgaW5kZXg7DQo+Kwl1MzIgcGFnZV9sZW4sIHBhZ2VfaW5k
ZXg7DQo+IAlkbWFfYWRkcl90IGFkZHI7DQo+Kwl1MzIgZG1hX2xlbiwgZG1hX2luZGV4Ow0KPg0K
Pi0JaW5kZXggPSAwOw0KPisJLyoNCj4rCSAqIFNjYXR0ZXJsaXN0IGVsZW1lbnRzIGNvbnRhaW5z
IGJvdGggcGFnZXMgYW5kIERNQSBhZGRyZXNzZXMsIGJ1dA0KPisJICogb25lIHNob3VkIG5vdCBh
c3N1bWUgMToxIHJlbGF0aW9uIGJldHdlZW4gdGhlbS4gVGhlIHNnLT5sZW5ndGgNCj5pcw0KPisJ
ICogdGhlIHNpemUgb2YgdGhlIHBoeXNpY2FsIG1lbW9yeSBjaHVuayBkZXNjcmliZWQgYnkgdGhl
IHNnLT5wYWdlLA0KPisJICogd2hpbGUgc2dfZG1hX2xlbihzZykgaXMgdGhlIHNpemUgb2YgdGhl
IERNQSAoSU8gdmlydHVhbCkgY2h1bmsNCj4rCSAqIGRlc2NyaWJlZCBieSB0aGUgc2dfZG1hX2Fk
ZHJlc3Moc2cpLg0KPisJICovDQoNCklzIHRoZXJlIGFuIGV4YW1wbGUgb2Ygd2hhdCB0aGUgc2Nh
dHRlcmxpc3Qgd291bGQgbG9vayBsaWtlIGluIHRoaXMgY2FzZT8NCg0KRG9lcyBlYWNoIFNHIGVu
dHJ5IGFsd2F5cyBoYXZlIHRoZSBwYWdlIGFuZCBkbWEgaW5mbz8gb3IgY291bGQgeW91IGhhdmUN
CmVudHJpZXMgdGhhdCBoYXZlIHBhZ2UgaW5mb3JtYXRpb24gb25seSwgYW5kIGVudHJpZXMgdGhh
dCBoYXZlIGRtYSBpbmZvIG9ubHk/DQoNCklmIHRoZSBzYW1lIGVudHJ5IGhhcyBkaWZmZXJlbnQg
c2l6ZSBpbmZvIChwYWdlX2xlbiA9IFBBR0VfU0laRSwNCmRtYV9sZW4gPSA0ICogUEFHRV9TSVpF
PyksIGFyZSB3ZSBndWFyYW50ZWVkIHRoYXQgdGhlIGFycmF5cyAocGFnZSBhbmQgYWRkcnMpIGhh
dmUNCmJlZW4gc2l6ZWQgY29ycmVjdGx5Pw0KDQpKdXN0IHRyeWluZyB0byBnZXQgbXkgaGVhZCB3
cmFwcGVkIGFyb3VuZCB0aGlzLg0KDQpUaGFua3MsDQoNCk1pa2UNCg0KPisJcGFnZV9pbmRleCA9
IDA7DQo+KwlkbWFfaW5kZXggPSAwOw0KPiAJZm9yX2VhY2hfc2coc2d0LT5zZ2wsIHNnLCBzZ3Qt
Pm5lbnRzLCBjb3VudCkgew0KPi0JCWxlbiA9IHNnX2RtYV9sZW4oc2cpOw0KPisJCXBhZ2VfbGVu
ID0gc2ctPmxlbmd0aDsNCj4gCQlwYWdlID0gc2dfcGFnZShzZyk7DQo+KwkJZG1hX2xlbiA9IHNn
X2RtYV9sZW4oc2cpOw0KPiAJCWFkZHIgPSBzZ19kbWFfYWRkcmVzcyhzZyk7DQo+DQo+LQkJd2hp
bGUgKGxlbiA+IDApIHsNCj4tCQkJaWYgKFdBUk5fT04oaW5kZXggPj0gbWF4X2VudHJpZXMpKQ0K
PisJCXdoaWxlIChwYWdlcyAmJiBwYWdlX2xlbiA+IDApIHsNCj4rCQkJaWYgKFdBUk5fT04ocGFn
ZV9pbmRleCA+PSBtYXhfZW50cmllcykpDQo+IAkJCQlyZXR1cm4gLTE7DQo+LQkJCWlmIChwYWdl
cykNCj4tCQkJCXBhZ2VzW2luZGV4XSA9IHBhZ2U7DQo+LQkJCWlmIChhZGRycykNCj4tCQkJCWFk
ZHJzW2luZGV4XSA9IGFkZHI7DQo+LQ0KPisJCQlwYWdlc1twYWdlX2luZGV4XSA9IHBhZ2U7DQo+
IAkJCXBhZ2UrKzsNCj4rCQkJcGFnZV9sZW4gLT0gUEFHRV9TSVpFOw0KPisJCQlwYWdlX2luZGV4
Kys7DQo+KwkJfQ0KPisJCXdoaWxlIChhZGRycyAmJiBkbWFfbGVuID4gMCkgew0KPisJCQlpZiAo
V0FSTl9PTihkbWFfaW5kZXggPj0gbWF4X2VudHJpZXMpKQ0KPisJCQkJcmV0dXJuIC0xOw0KPisJ
CQlhZGRyc1tkbWFfaW5kZXhdID0gYWRkcjsNCj4gCQkJYWRkciArPSBQQUdFX1NJWkU7DQo+LQkJ
CWxlbiAtPSBQQUdFX1NJWkU7DQo+LQkJCWluZGV4Kys7DQo+KwkJCWRtYV9sZW4gLT0gUEFHRV9T
SVpFOw0KPisJCQlkbWFfaW5kZXgrKzsNCj4gCQl9DQo+IAl9DQo+IAlyZXR1cm4gMDsNCj4tLQ0K
PjIuMTcuMQ0KDQo=
