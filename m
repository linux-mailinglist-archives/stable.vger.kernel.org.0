Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1553CF569
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 09:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235590AbhGTG6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 02:58:35 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7402 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235238AbhGTG6d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 02:58:33 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GTVql3y83z7xCJ;
        Tue, 20 Jul 2021 15:35:31 +0800 (CST)
Received: from dggemm754-chm.china.huawei.com (10.1.198.60) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Jul 2021 15:39:09 +0800
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemm754-chm.china.huawei.com (10.1.198.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Jul 2021 15:39:09 +0800
Received: from dggpeml500012.china.huawei.com ([7.185.36.15]) by
 dggpeml500012.china.huawei.com ([7.185.36.15]) with mapi id 15.01.2176.012;
 Tue, 20 Jul 2021 15:39:09 +0800
From:   "Zhengyejian (Zetta)" <zhengyejian1@huawei.com>
To:     Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        yuehaibing <yuehaibing@huawei.com>,
        Zhangjinhao <zhangjinhao2@huawei.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "johannes.berg@intel.com" <johannes.berg@intel.com>
Subject: Re: [RFC PATCH 4.4] mac80211: fix handling A-MSDUs that start with an
 RFC 1042 header
Thread-Topic: [RFC PATCH 4.4] mac80211: fix handling A-MSDUs that start with
 an RFC 1042 header
Thread-Index: Add9OQjftxuyosdtQ6Ov1Pb9ik5nEQ==
Date:   Tue, 20 Jul 2021 07:39:09 +0000
Message-ID: <70d0f888685a443881322319c657bfa5@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.110.218]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiA+IEhvdyBhYm91dCBsaW51eCA0LjkgYmVsb3csIGFyZSB0aGV5IGNvbXBsaWFudCAgd2l0aCA4
MDIuMTEgc3RhbmRhcmQgb3Igbm90Pw0KPiANCj4gVGhleSBhcmUgY29tcGxpYW50Lg0KPiANCj4g
PiBXb3VsZCB0aGV5IG5lZWQgYWRkaXRpb25hbCBwYXRjaGVzIHRvIG1pdGlnYXRlIHRoZSBhZ2dy
ZWdhdGlvbiBhdHRhY2s/DQo+IA0KPiBUaGV5IG5lZWQgdGhlIGJhY2twb3J0IG9mICJbUEFUQ0gg
MDQvMThdIGNmZzgwMjExOiBtaXRpZ2F0ZSBBLU1TRFUNCj4gYWdncmVnYXRpb24gYXR0YWNrcyIg
dG8gbWl0aWdhdGUgYXR0YWNrcy4gVGhpcyBwYXRjaCBoYXMgYmVlbiBiYWNrcG9ydGVkDQo+IHRv
IDQuNDoNCj4gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQv
c3RhYmxlL2xpbnV4LmdpdC9jb21taXQvP2g9DQo+IHY0LjQuMjc1JmlkPWRhZWE3ZmY1MTg2MWNl
YzkzZmY3ZjU2MTA5NWQ5MDQ4YjY3M2I1MWYNCj4gDQo+IFNvIGlmIHlvdSB0YWtlIGFsbCB0aGUg
cGF0Y2hlcyB0aGF0IGhhdmUgYmVlbiBiYWNrcG9ydGVkIHRvIDQuNCB5b3UNCj4gc2hvdWxkIGJl
IE9LLg0KPiANCj4gQ2hlZXJzLA0KPiBNYXRoeQ0KDQpJIGdldCBpdCBub3csIHRoYW5rcy4NCg0K
QmVzdCByZWdhcmRzLA0KWmhlbmcgWWVqaWFuDQo=
