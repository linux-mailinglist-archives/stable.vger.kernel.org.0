Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3A930B939
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 09:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbhBBIGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 03:06:46 -0500
Received: from mailgw02.mediatek.com ([1.203.163.81]:48667 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S231509AbhBBIGo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 03:06:44 -0500
X-UUID: 82750cbdde014d07889be2407e07b253-20210202
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=9toMsDCOSf/q6lPmUSHIfDg7TrnfClK1zuFPSy0VQpg=;
        b=OwFwVbP3m8iVDmjhBVS3qSu25OOmhBLAYkn8BmgdkJPNEu9VdpHf18NhKXhVj824xPRkcow3/90OLttAG2KRjJilNo8FuLR/ESTsHk2SuujbJr+KYGL5NRLKLIrnc1xwZGC/paYuavVITB8zywxXsiXnJsZxObku/HjiX1u2d8g=;
X-UUID: 82750cbdde014d07889be2407e07b253-20210202
Received: from mtkcas34.mediatek.inc [(172.27.4.253)] by mailgw02.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 517422257; Tue, 02 Feb 2021 16:05:56 +0800
Received: from MTKCAS32.mediatek.inc (172.27.4.184) by MTKMBS32N1.mediatek.inc
 (172.27.4.71) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Feb
 2021 16:05:53 +0800
Received: from [10.17.3.153] (10.17.3.153) by MTKCAS32.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 2 Feb 2021 16:05:53 +0800
Message-ID: <1612253153.5147.0.camel@mhfsdcap03>
Subject: Re: patch "usb: xhci-mtk: skip dropping bandwidth of unchecked
 endpoints" added to usb-linus
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <ikjn@chromium.org>, <stable@vger.kernel.org>
Date:   Tue, 2 Feb 2021 16:05:53 +0800
In-Reply-To: <YBj4gcIuj1oTo4Xh@kroah.com>
References: <1612185061176212@kroah.com>
         <1612247694.25113.15.camel@mhfsdcap03> <YBj4gcIuj1oTo4Xh@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
X-TM-SNTS-SMTP: FC5AE1AD740DF40A9AE89B35E543753021CD5790192D74E3CF0DE898085B5B4A2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDIxLTAyLTAyIGF0IDA4OjAwICswMTAwLCBHcmVnIEtIIHdyb3RlOg0KPiBPbiBU
dWUsIEZlYiAwMiwgMjAyMSBhdCAwMjozNDo1NFBNICswODAwLCBDaHVuZmVuZyBZdW4gd3JvdGU6
DQo+ID4gSGkgR3JlZywNCj4gPiANCj4gPiAgICBJIHNlbnQgb3V0IHYyLCBhZGQgJ2JyZWFrJyB3
aGVuIGZpbmQgdGhlIGVwIGluDQo+ID4geGhjaV9tdGtfZHJvcF9lcF9xdWlyaygpLCBidXQgbm8g
ZWZmZWN0IHdpdGggdGhlIGZ1bmN0aW9uLg0KPiA+IFBsZWFzZSBwaWNrIHVwIHYyIGlmIHBvc3Np
YmxlLCBzb3JyeSBmb3IgaW5jb252ZW5pZW5jZQ0KPiANCj4gSSBjYW4gbm90IGRvIHRoYXQsIGFz
IGl0IGlzIGFscmVhZHkgaW4gbXkgcHVibGljIHRyZWUuDQo+IA0KPiBJIGNhbiBlaXRoZXIgcmV2
ZXJ0IHRoZSBleGlzdGluZyBvbmUsIGFuZCB0YWtlIHRoaXMsIG9yIGp1c3QgYWNjZXB0IGENCj4g
Zm9sbG93LW9uIHBhdGNoLiAgSSBwcmVmZXIgYSBmb2xsb3ctb24gb25lLCBwbGVhc2Ugc2VuZCB0
aGF0Lg0KSSdsbCBwcmVwYXJlIGEgZm9sbG93LW9uIHBhdGNoLCB0aGFua3MNCg0KPiANCj4gdGhh
bmtzLA0KPiANCj4gZ3JlZyBrLWgNCg0K

