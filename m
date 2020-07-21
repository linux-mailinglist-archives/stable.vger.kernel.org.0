Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C452282FA
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 17:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgGUPAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 11:00:43 -0400
Received: from mga04.intel.com ([192.55.52.120]:34275 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbgGUPAn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jul 2020 11:00:43 -0400
IronPort-SDR: /vKbJhQpXou5toW/S5igZgSVKcDSRb5fW+r7q7Pz6OUMcb6Snv2PwY7vDQCm25mgXILELW7e0+
 n5kcC+4/eP6A==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="147643466"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="147643466"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 08:00:42 -0700
IronPort-SDR: 2JgYyJ3e0B2ZxFLOg10fnEmH+KTXvI/GdeB1A929wTIhqFVLxGHpAFz0UV3DQERI+sYnQJWC0A
 accbGPVY9baA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="310272458"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga004.fm.intel.com with ESMTP; 21 Jul 2020 08:00:42 -0700
Received: from fmsmsx155.amr.corp.intel.com (10.18.116.71) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 21 Jul 2020 08:00:42 -0700
Received: from fmsmsx108.amr.corp.intel.com ([169.254.9.75]) by
 FMSMSX155.amr.corp.intel.com ([169.254.5.149]) with mapi id 14.03.0439.000;
 Tue, 21 Jul 2020 08:00:41 -0700
From:   "Ruhl, Michael J" <michael.j.ruhl@intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] io-mapping: Indicate mapping failure
Thread-Topic: [PATCH] io-mapping: Indicate mapping failure
Thread-Index: AQHWX2mezoQb/5kWOECvvagPAlWoCqkSkjMA//+K4SA=
Date:   Tue, 21 Jul 2020 15:00:41 +0000
Message-ID: <14063C7AD467DE4B82DEDB5C278E866301245DF505@FMSMSX108.amr.corp.intel.com>
References: <20200721141641.81112-1-michael.j.ruhl@intel.com>
 <20200721141641.81112-2-michael.j.ruhl@intel.com>
 <20200721144722.GH3703480@smile.fi.intel.com>
In-Reply-To: <20200721144722.GH3703480@smile.fi.intel.com>
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

Pi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogQW5keSBTaGV2Y2hlbmtvIDxhbmRy
aXkuc2hldmNoZW5rb0BsaW51eC5pbnRlbC5jb20+DQo+U2VudDogVHVlc2RheSwgSnVseSAyMSwg
MjAyMCAxMDo0NyBBTQ0KPlRvOiBSdWhsLCBNaWNoYWVsIEogPG1pY2hhZWwuai5ydWhsQGludGVs
LmNvbT4NCj5DYzogZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZzsgQW5kcmV3IE1vcnRv
biA8YWtwbUBsaW51eC0NCj5mb3VuZGF0aW9uLm9yZz47IE1pa2UgUmFwb3BvcnQgPHJwcHRAbGlu
dXguaWJtLmNvbT47IENocmlzIFdpbHNvbg0KPjxjaHJpc0BjaHJpcy13aWxzb24uY28udWs+OyBz
dGFibGVAdmdlci5rZXJuZWwub3JnDQo+U3ViamVjdDogUmU6IFtQQVRDSF0gaW8tbWFwcGluZzog
SW5kaWNhdGUgbWFwcGluZyBmYWlsdXJlDQo+DQo+T24gVHVlLCBKdWwgMjEsIDIwMjAgYXQgMTA6
MTY6NDFBTSAtMDQwMCwgTWljaGFlbCBKLiBSdWhsIHdyb3RlOg0KPj4gU29tZXRpbWVzIGl0IGlz
IGdvb2QgdG8ga25vdyB3aGVuIHlvdXIgbWFwcGluZyBmYWlsZWQuDQo+DQo+Q2FuIHlvdSBlbGFi
b3JhdGUuLi4NCg0KU3VyZSwgZ3Vlc3MgSSB3YXMgdG9vIGdsaWIuIPCfmIoNCg0KQ3VycmVudGx5
ICB0aGUgaW9fbWFwcGluZ19pbml0X3djICh0aGUgIUFUT01JQ19JT01BUCB2ZXJzaW9uKSwgZnVu
Y3Rpb24gd2lsbA0KYWx3YXlzIHJldHVybiBzdWNjZXNzLg0KDQpJZiB0aGUgc2V0dGluZyBvZiB0
aGUgaW9tZW0gKGZyb20gaW9yZW1hcF93YykgZmFpbHMsIHRoZSBvbmx5IHdheSBmb3IgdGhlIA0K
Y2FsbGVyIHRvIGtub3cgaXMgdG8gY2hlY2sgdGhlIHZhbHVlIG9mIGlvbWFwLT5pb21lbS4NCg0K
U2luY2UgYWxsIG9mIHRoZSBjYWxsZXJzIGV4cGVjdCBhIE5VTEwgcmV0dXJuIG9uIGVycm9yLCBh
bmQgY2hlY2sgZm9yIGEgTlVMTCwNCkkgZmVsdCB0aGlzIG5lZWRlZCBhIGZpeGVzIChpLmUuIHVu
ZXhwZWN0ZWQgYmVoYXZpb3IpLg0KDQo+PiBGaXhlczogY2FmYWYxNGE1ZDhmICgiaW8tbWFwcGlu
ZzogQWx3YXlzIGNyZWF0ZSBhIHN0cnVjdCB0byBob2xkIG1ldGFkYXRhDQo+YWJvdXQgdGhlIGlv
LW1hcHBpbmciDQo+DQo+Li4uZXNwZWNpYWxseSB0YWtpbmcgaW50byBhY2NvdW50IHRoYXQgRml4
ZXMgaW1wbGllcyByZWdyZXNzaW9uIC8gYnVnPw0KDQpUaGUgZmFpbHVyZSAoaW4gbXkgY2FzZSBh
IGNyYXNoKSBpcyBub3QgcmV2ZWFsZWQgdW50aWwgdGhlIGFkZHJlc3MgaXMgYWNjZXNzZWQNCmxv
bmcgYWZ0ZXIgdGhlIGluaXQuDQoNCkkgd2lsbCB1cGRhdGUgdGhlIGNvbW1pdC4NCg0KTWlrZQ0K
DQo+LS0NCj5XaXRoIEJlc3QgUmVnYXJkcywNCj5BbmR5IFNoZXZjaGVua28NCj4NCg0K
