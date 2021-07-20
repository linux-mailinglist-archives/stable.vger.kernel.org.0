Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B080B3CF567
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 09:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbhGTG4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 02:56:49 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:15041 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235079AbhGTG4m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 02:56:42 -0400
Received: from dggeme752-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GTVnt4YJNzZqrn;
        Tue, 20 Jul 2021 15:33:54 +0800 (CST)
Received: from dggeme756-chm.china.huawei.com (10.3.19.102) by
 dggeme752-chm.china.huawei.com (10.3.19.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 20 Jul 2021 15:37:16 +0800
Received: from dggeme756-chm.china.huawei.com ([10.6.80.68]) by
 dggeme756-chm.china.huawei.com ([10.6.80.68]) with mapi id 15.01.2176.012;
 Tue, 20 Jul 2021 15:37:16 +0800
From:   "wangliang (C)" <wangliang101@huawei.com>
To:     "palmerdabbelt@google.com" <palmerdabbelt@google.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wangle (RTOS FAE)" <wangle6@huawei.com>,
        "Chenxin (RTOS)" <kepler.chenxin@huawei.com>,
        Nixiaoming <nixiaoming@huawei.com>,
        "Wangkefeng (OS Kernel Lab)" <wangkefeng.wang@huawei.com>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBhcm06bW1hcDogZml4IHBoeXNpY2FsIGFkZHJlc3Mg?=
 =?gb2312?B?b3ZlcmZsb3cgd2hlbiBDT05GSUdfQVJNX0xQQUU9eQ==?=
Thread-Topic: [PATCH] arm:mmap: fix physical address overflow when
 CONFIG_ARM_LPAE=y
Thread-Index: AQHXeXUt7ahQu+mGnUGYPTbmKJayAqtLgAsA
Date:   Tue, 20 Jul 2021 07:37:16 +0000
Message-ID: <133369ed88a54e40a3ebbc667763f5b1@huawei.com>
References: <20210715123012.61215-1-wangliang101@huawei.com>
In-Reply-To: <20210715123012.61215-1-wangliang101@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.101.54]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

YWRkIGFybSBsaXN0DQoNCi0tLS0t08q8/tStvP4tLS0tLQ0Kt6K8/sjLOiB3YW5nbGlhbmcgKEMp
IA0Kt6LLzcqxvOQ6IDIwMjHE6jfUwjE1yNUgMjA6MzANCsrVvP7IyzogcGFsbWVyZGFiYmVsdEBn
b29nbGUuY29tOyBtY2dyb2ZAa2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9y
ZzsgZ3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc7IGxpbnV4QGFybWxpbnV4Lm9yZy51aw0Ks63L
zTogc3RhYmxlQHZnZXIua2VybmVsLm9yZzsgd2FuZ2xpYW5nIChDKSA8d2FuZ2xpYW5nMTAxQGh1
YXdlaS5jb20+OyBXYW5nbGUgKFJUT1MgRkFFKSA8d2FuZ2xlNkBodWF3ZWkuY29tPjsgQ2hlbnhp
biAoUlRPUykgPGtlcGxlci5jaGVueGluQGh1YXdlaS5jb20+OyBOaXhpYW9taW5nIDxuaXhpYW9t
aW5nQGh1YXdlaS5jb20+DQrW98ziOiBbUEFUQ0hdIGFybTptbWFwOiBmaXggcGh5c2ljYWwgYWRk
cmVzcyBvdmVyZmxvdyB3aGVuIENPTkZJR19BUk1fTFBBRT15DQoNCldoZW4gdGhlIENPTkZJR19B
Uk1fTFBBRSBpcyBlbmFibGVkIG9uIGFybTMyLCB0aGUgcGh5c2ljYWwgYWRkcmVzcyBtYXkgZXhj
ZWVkIDMyIGJpdHMuIEluIHRoZSBkZXZtZW1faXNfYWxsb3dlZCBmdW5jdGlvbiwgdGhlIHBoeXNp
Y2FsIGFkZHJlc3MgaXMgb2J0YWluZWQgdGhyb3VnaCBkaXNwbGFjZW1lbnQgb2YgdGhlIHBoeXNp
Y2FsIHBhZ2UgbnVtYmVyLldpdGhvdXQgZXhwbGljaXQgdHJhbnNsYXRpb24sIHRoZSBwaHlzaWNh
bCBhZGRyZXNzIG1heSBvdmVyZmxvdyBhbmQgYmUgdHJ1bmNhdGVkLg0KVXNlIHRoZSBQRk5fUEhZ
UyBtYWNybyB0byBmaXggdGhpcyBidWcuDQoNClRoaXMgYnVnIHdhcyBpbml0aWFsbHkgaW50cm9k
dWNlZCBpbiB2Mi42LjM3IHdpdGggY29tbWl0OjA4N2FhZmZjZGY5YzkxLg0KSW4gdjUuMTAsIHRo
aXMgY29kZSBoYXMgYmVlbiBtb2RpZmllZCBieSBjb21taXQ6NTI3NzAxZWRhNWYxOTYuDQoNCkZp
eGVzOiA1Mjc3MDFlZGE1ZjE5NiAoImxpYjogQWRkIGEgZ2VuZXJpYyB2ZXJzaW9uIG9mIGRldm1l
bV9pc19hbGxvd2VkIikNCkZpeGVzOiAwODdhYWZmY2RmOWM5MSAoIkFSTTogaW1wbGVtZW50IENP
TkZJR19TVFJJQ1RfREVWTUVNIGJ5IGRpc2FibGluZyBhY2Nlc3MgdG8gUkFNIHZpYSAvZGV2L21l
bSIpDQpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZyAjIHYyLjYuMzcNClNpZ25lZC1vZmYtYnk6
IExpYW5nIFdhbmcgPHdhbmdsaWFuZzEwMUBodWF3ZWkuY29tPg0KLS0tDQogbGliL2Rldm1lbV9p
c19hbGxvd2VkLmMgfCAyICstDQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRl
bGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9saWIvZGV2bWVtX2lzX2FsbG93ZWQuYyBiL2xpYi9k
ZXZtZW1faXNfYWxsb3dlZC5jIGluZGV4IGMwZDY3YzU0MTg0OS4uNjBiZTllMjRiZDU3IDEwMDY0
NA0KLS0tIGEvbGliL2Rldm1lbV9pc19hbGxvd2VkLmMNCisrKyBiL2xpYi9kZXZtZW1faXNfYWxs
b3dlZC5jDQpAQCAtMTksNyArMTksNyBAQA0KICAqLw0KIGludCBkZXZtZW1faXNfYWxsb3dlZCh1
bnNpZ25lZCBsb25nIHBmbikgIHsNCi0JaWYgKGlvbWVtX2lzX2V4Y2x1c2l2ZShwZm4gPDwgUEFH
RV9TSElGVCkpDQorCWlmIChpb21lbV9pc19leGNsdXNpdmUoUEZOX1BIWVMocGZuKSkpDQogCQly
ZXR1cm4gMDsNCiAJaWYgKCFwYWdlX2lzX3JhbShwZm4pKQ0KIAkJcmV0dXJuIDE7DQotLQ0KMi4z
Mi4wDQoNCg==
