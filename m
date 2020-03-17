Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12AD6188793
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 15:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgCQOfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 10:35:12 -0400
Received: from m176151.mail.qiye.163.com ([59.111.176.151]:58634 "EHLO
        m176151.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbgCQOfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 10:35:12 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Mar 2020 10:35:10 EDT
Received: from vivo.com (wm-11.qy.internal [127.0.0.1])
        by m176151.mail.qiye.163.com (Hmail) with ESMTP id BF500483D7B;
        Tue, 17 Mar 2020 22:25:04 +0800 (CST)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Message-ID: <ACEA7wD3CNSN-spMiGEyUqod.3.1584455104769.Hmail.wenhu.wang@vivo.com>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Allison Randal <allison@lohutok.net>,
        Richard Fontana <rfontana@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org, kernel@vivo.com,
        stable <stable@vger.kernel.org>
Subject: =?UTF-8?B?UmU6UmU6IFtQQVRDSCB2M10gcG93ZXJwYy9mc2wtODV4eDogZml4IGNvbXBpbGUgZXJyb3I=?=
X-Priority: 3
X-Mailer: HMail Webmail Server V2.0 Copyright (c) 2016-163.com
X-Originating-IP: 58.251.74.227
In-Reply-To: <878sjzfcpm.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Received: from wenhu.wang@vivo.com( [58.251.74.227) ] by ajax-webmail ( [127.0.0.1] ) ; Tue, 17 Mar 2020 22:25:04 +0800 (GMT+08:00)
From:   =?UTF-8?B?546L5paH6JmO?= <wenhu.wang@vivo.com>
Date:   Tue, 17 Mar 2020 22:25:04 +0800 (GMT+08:00)
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSFVDSEJCQkJNTE5MTktMSFlXWShZQU
        hPN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kJHlYWEh9ZQUhNTEhMSUlNSklNN1dZDB4ZWUEPCQ4eV1kSHx4VD1lB
        WUc6OD46TAw*SDg1KDVWCAs2Ejw#Ai4KFB9VSFVKTkNPT05OSktMSE5MVTMWGhIXVQweFRMOVQwa
        FRw7DRINFFUYFBZFWVdZEgtZQVlOQ1VJTkpVTE9VSUlMWVdZCAFZQUxJQkg3Bg++
X-HM-Tid: 0a70e8e2391993b5kuwsbf500483d7b
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogTWljaGFlbCBFbGxlcm1hbiA8bXBlQGVsbGVybWFuLmlkLmF1PgogRGF0ZTogMjAyMC0w
My0xNyAxOToyMjoxMwpUbzoi546L5paH6JmOIiA8d2VuaHUud2FuZ0B2aXZvLmNvbT4KIGNjOiBC
ZW5qYW1pbiBIZXJyZW5zY2htaWR0IDxiZW5oQGtlcm5lbC5jcmFzaGluZy5vcmc+LFBhdWwgTWFj
a2VycmFzIDxwYXVsdXNAc2FtYmEub3JnPixBbGxpc29uIFJhbmRhbCA8YWxsaXNvbkBsb2h1dG9r
Lm5ldD4sUmljaGFyZCBGb250YW5hIDxyZm9udGFuYUByZWRoYXQuY29tPixHcmVnIEtyb2FoLUhh
cnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPixUaG9tYXMgR2xlaXhuZXIgPHRnbHhA
bGludXRyb25peC5kZT4sbGludXhwcGMtZGV2QGxpc3RzLm96bGFicy5vcmcsbGludXgta2VybmVs
QHZnZXIua2VybmVsLm9yZyx0cml2aWFsQGtlcm5lbC5vcmcsa2VybmVsQHZpdm8uY29tLHN0YWJs
ZSA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4KU3ViamVjdDogUmU6IFtQQVRDSCB2M10gcG93ZXJw
Yy9mc2wtODV4eDogZml4IGNvbXBpbGUgZXJyb3I+546L5paH6JmOIDx3ZW5odS53YW5nQHZpdm8u
Y29tPiB3cml0ZXM6Cj4+IEZyb206IE1pY2hhZWwgRWxsZXJtYW4gPG1wZUBlbGxlcm1hbi5pZC5h
dT4KPj4gIERhdGU6IDIwMjAtMDMtMTYgMTc6NDE6MTIKPj4gVG86V0FORyBXZW5odSA8d2VuaHUu
d2FuZ0B2aXZvLmNvbT4sQmVuamFtaW4gSGVycmVuc2NobWlkdCA8YmVuaEBrZXJuZWwuY3Jhc2hp
bmcub3JnPixQYXVsIE1hY2tlcnJhcyA8cGF1bHVzQHNhbWJhLm9yZz4sV0FORyBXZW5odSA8d2Vu
aHUud2FuZ0B2aXZvLmNvbT4sQWxsaXNvbiBSYW5kYWwgPGFsbGlzb25AbG9odXRvay5uZXQ+LFJp
Y2hhcmQgRm9udGFuYSA8cmZvbnRhbmFAcmVkaGF0LmNvbT4sR3JlZyBLcm9haC1IYXJ0bWFuIDxn
cmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4sVGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxpbnV0cm9u
aXguZGU+LGxpbnV4cHBjLWRldkBsaXN0cy5vemxhYnMub3JnLGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmcKPj4gIGNjOiB0cml2aWFsQGtlcm5lbC5vcmcsa2VybmVsQHZpdm8uY29tLHN0YWJs
ZSA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4KPj4gU3ViamVjdDogUmU6IFtQQVRDSCB2M10gcG93
ZXJwYy9mc2wtODV4eDogZml4IGNvbXBpbGUgZXJyb3I+V0FORyBXZW5odSA8d2VuaHUud2FuZ0B2
aXZvLmNvbT4gd3JpdGVzOgo+Pj4+IEluY2x1ZGUgImxpbnV4L29mX2FkZHJlc3MuaCIgdG8gZml4
IHRoZSBjb21waWxlIGVycm9yIGZvcgo+Pj4+IG1wYzg1eHhfbDJjdGxyX29mX3Byb2JlKCkgd2hl
biBjb21waWxpbmcgZnNsXzg1eHhfY2FjaGVfc3JhbS5jLgo+Pj4+Cj4+Pj4gICBDQyAgICAgIGFy
Y2gvcG93ZXJwYy9zeXNkZXYvZnNsXzg1eHhfbDJjdGxyLm8KPj4+PiBhcmNoL3Bvd2VycGMvc3lz
ZGV2L2ZzbF84NXh4X2wyY3Rsci5jOiBJbiBmdW5jdGlvbiDigJhtcGM4NXh4X2wyY3Rscl9vZl9w
cm9iZeKAmToKPj4+PiBhcmNoL3Bvd2VycGMvc3lzZGV2L2ZzbF84NXh4X2wyY3Rsci5jOjkwOjEx
OiBlcnJvcjogaW1wbGljaXQgZGVjbGFyYXRpb24gb2YgZnVuY3Rpb24g4oCYb2ZfaW9tYXDigJk7
IGRpZCB5b3UgbWVhbiDigJhwY2lfaW9tYXDigJk/IFstV2Vycm9yPWltcGxpY2l0LWZ1bmN0aW9u
LWRlY2xhcmF0aW9uXQo+Pj4+ICAgbDJjdGxyID0gb2ZfaW9tYXAoZGV2LT5kZXYub2Zfbm9kZSwg
MCk7Cj4+Pj4gICAgICAgICAgICBefn5+fn5+fgo+Pj4+ICAgICAgICAgICAgcGNpX2lvbWFwCj4+
Pj4gYXJjaC9wb3dlcnBjL3N5c2Rldi9mc2xfODV4eF9sMmN0bHIuYzo5MDo5OiBlcnJvcjogYXNz
aWdubWVudCBtYWtlcyBwb2ludGVyIGZyb20gaW50ZWdlciB3aXRob3V0IGEgY2FzdCBbLVdlcnJv
cj1pbnQtY29udmVyc2lvbl0KPj4+PiAgIGwyY3RsciA9IG9mX2lvbWFwKGRldi0+ZGV2Lm9mX25v
ZGUsIDApOwo+Pj4+ICAgICAgICAgIF4KPj4+PiBjYzE6IGFsbCB3YXJuaW5ncyBiZWluZyB0cmVh
dGVkIGFzIGVycm9ycwo+Pj4+IHNjcmlwdHMvTWFrZWZpbGUuYnVpbGQ6MjY3OiByZWNpcGUgZm9y
IHRhcmdldCAnYXJjaC9wb3dlcnBjL3N5c2Rldi9mc2xfODV4eF9sMmN0bHIubycgZmFpbGVkCj4+
Pj4gbWFrZVsyXTogKioqIFthcmNoL3Bvd2VycGMvc3lzZGV2L2ZzbF84NXh4X2wyY3Rsci5vXSBF
cnJvciAxCj4+Pj4KPj4+PiBGaXhlczogY29tbWl0IDZkYjkyY2M5ZDA3ZCAoInBvd2VycGMvODV4
eDogYWRkIGNhY2hlLXNyYW0gc3VwcG9ydCIpCj4+Pgo+Pj5UaGUgc3ludGF4IGlzOgo+Pj4KPj4+
Rml4ZXM6IDZkYjkyY2M5ZDA3ZCAoInBvd2VycGMvODV4eDogYWRkIGNhY2hlLXNyYW0gc3VwcG9y
dCIpCj4+Pgo+Pj4+IENjOiBzdGFibGUgPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+Cj4+Pgo+Pj5U
aGUgY29tbWl0IGFib3ZlIHdlbnQgaW50byB2Mi42LjM3Lgo+Pj4KPj4+U28gbm8gb25lIGhhcyBu
b3RpY2VkIHRoaXMgYnVnIHNpbmNlIHRoZW4sIGhvdz8gT3IgZGlkIHNvbWV0aGluZyBlbHNlCj4+
PmNoYW5nZSB0byBleHBvc2UgdGhlIHByb2JsZW0/Cj4+Cj4+IEFjdHVhbGx5IGEgaGFyZCBxdWVz
dGlvbiB0byBhbnN3ZXIgY2F1c2UgaXQgYWxzbyBsZWZ0IG1lIHNjcmF0Y2hpbmcgZm9yIGxvbmcu
Cj4+IEhvd2V2ZXIsIEkgY2FuIG5vdCBmaW5kIHJpZ2h0IG9yIGRlZmluaXRlIGFuc3dlci4KPgo+
T2gsIGFjdHVhbGx5IGl0J3MgZmFpcmx5IHN0cmFpZ2h0IGZvcndhcmQsIHRoZSBjb2RlIGNhbid0
IGJlIGJ1aWx0IGF0Cj5hbGwgaW4gdXBzdHJlYW0gYmVjYXVzZSBDT05GSUdfRlNMXzg1WFhfQ0FD
SEVfU1JBTSBpcyBub3Qgc2VsZWN0YWJsZSBvcgo+c2VsZWN0ZWQgYnkgYW55dGhpbmcuCgpZZWFo
LCBzdXJlIHRoYXQgaXMgdGhlIHJlYXNvbiwgYW5kIEkgbWVhbnQgaXQgd2FzIGhhcmQgdG8gZmln
dXJlIG91dCB3aHkKbm9ib2R5IGhhZCBldmVyIGNvbXBpbGVkIHRoZSBkcml2ZXIgd2l0aCBGU0xf
ODVYWF9DQUNIRV9TUkFNIGVuYWJsZWQKdW50aWwgbWUuCj4KPllvdSBzZW50IGEgcGF0Y2ggcHJl
dmlvdXNseSB0byBtYWtlIGl0IHNlbGVjdGFibGUsIHdoaWNoIFNjb3R0IHRob3VnaHQKPndhcyBh
IGJhZCBpZGVhLgo+Cj5TbyB0aGlzIHdob2xlIGZpbGUgaXMgZGVhZCBjb2RlIGFzIGZhciBhcyBJ
J20gY29uY2VybmVkLCBzbyBwYXRjaGVzIGZvcgo+aXQgZGVmaW5pdGVseSBkbyBub3QgbmVlZCB0
byBnbyB0byBzdGFibGUuCj4KPklmIHlvdSB3YW50IHRvIGFkZCBhIHVzZXIgZm9yIGl0IHRoZW4g
cGxlYXNlIHNlbmQgYSBzZXJpZXMgZG9pbmcgdGhhdCwKPmFuZCB0aGlzIGNvbW1pdCBjYW4gYmUg
dGhlIGZpcnN0LgoKRm9yIHRoaXMsIGFzIHlvdSBtZW50aW9uZWQsIGl0IGlzIGRlYWQgYW5kIGRv
IG5vdCBuZWVkIHRvIGJlIGFwcGxpZWQgdG8gYW55IHN0YWJsZS4KQW5kIEkgcmVjb21tYW5kIHRo
ZSBwYXRjaCBhcyBhIHVuaXQgaXRzZWxmIGNhdXNlIG91ciBtb2R1bGUgd2hpY2ggdXNlcwppdCBp
cyBzdGlsbCB1bmRlciBkZXZlbG9waW5nLCBhbmQgdGhlIG1vZHVsZSBpdHNlbGYgd291bGQgYmUg
dGFrZW4gYXMgYQpjb21wbGV0ZSBsb2dpY2FsIGJsb2NrLiBBbHNvIGl0IHdvdWxkIHRha2Ugc29t
ZSB0aW1lLgoKVGhhbmtzLCBXZW5odQo+Cj5jaGVlcnMKDQoNCg==
