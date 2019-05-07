Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDA2916A36
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 20:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfEGScf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 14:32:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52634 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727259AbfEGScf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 14:32:35 -0400
Received: (qmail 6882 invoked by uid 2102); 7 May 2019 14:32:34 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 7 May 2019 14:32:34 -0400
Date:   Tue, 7 May 2019 14:32:34 -0400 (EDT)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To:     Sasha Levin <sashal@kernel.org>
cc:     mchehab@kernel.org, <andreyknvl@google.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] media: usb: siano: Fix general protection fault in smsusb
In-Reply-To: <20190507174759.835F020675@mail.kernel.org>
Message-ID: <Pine.LNX.4.44L0.1905071430420.1632-200000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1559625215-94944122-1557253954=:1632"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1559625215-94944122-1557253954=:1632
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Tue, 7 May 2019, Sasha Levin wrote:

> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.0.13, v4.19.40, v4.14.116, v4.9.173, v4.4.179, v3.18.139.
> 
> v5.0.13: Build OK!
> v4.19.40: Build OK!
> v4.14.116: Build OK!
> v4.9.173: Build OK!
> v4.4.179: Build OK!
> v3.18.139: Failed to apply! Possible dependencies:
>     0dd5f20cb35b ("[media] siano: get rid of sms_info()")
>     46b1e21fe50f ("[media] siano: add support for the media controller at USB driver")
>     5e022d1aa0be ("[media] siano: use pr_* print functions")
> 
> 
> How should we proceed with this patch?
> 
> --
> Thanks,
> Sasha

Attached is a version of the patch which has been back-ported to 
3.18.x.

Alan Stern

---1559625215-94944122-1557253954=:1632
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="smsusb-fix-3.18.x"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44L0.1905071432340.1632@iolanthe.rowland.org>
Content-Description: 
Content-Disposition: attachment; filename="smsusb-fix-3.18.x"

VGhlIHN5emthbGxlciBVU0IgZnV6emVyIGZvdW5kIGEgZ2VuZXJhbC1wcm90
ZWN0aW9uLWZhdWx0IGJ1ZyBpbiB0aGUNCnNtc3VzYiBwYXJ0IG9mIHRoZSBT
aWFubyBEVkIgZHJpdmVyLiAgVGhlIGZhdWx0IG9jY3VycyBkdXJpbmcgcHJv
YmUNCmJlY2F1c2UgdGhlIGRyaXZlciBhc3N1bWVzIHdpdGhvdXQgY2hlY2tp
bmcgdGhhdCB0aGUgZGV2aWNlIGhhcyBib3RoDQpJTiBhbmQgT1VUIGVuZHBv
aW50cyBhbmQgdGhlIElOIGVuZHBvaW50IGlzIGVwMS4NCg0KQnkgc2xpZ2h0
bHkgcmVhcnJhbmdpbmcgdGhlIGRyaXZlcidzIGluaXRpYWxpemF0aW9uIGNv
ZGUsIHdlIGNhbiBtYWtlDQp0aGUgYXBwcm9wcmlhdGUgY2hlY2tzIGVhcmx5
IG9uIGFuZCB0aHVzIGF2b2lkIHRoZSBwcm9ibGVtLiAgSWYgdGhlDQpleHBl
Y3RlZCBlbmRwb2ludHMgYXJlbid0IHByZXNlbnQsIHRoZSBuZXcgY29kZSBz
YWZlbHkgcmV0dXJucyAtRU5PREVWDQpmcm9tIHRoZSBwcm9iZSByb3V0aW5l
Lg0KDQpTaWduZWQtb2ZmLWJ5OiBBbGFuIFN0ZXJuIDxzdGVybkByb3dsYW5k
LmhhcnZhcmQuZWR1Pg0KUmVwb3J0ZWQtYW5kLXRlc3RlZC1ieTogc3l6Ym90
KzUzZjAyOWRiNzFjMTlhNDczMjVhQHN5emthbGxlci5hcHBzcG90bWFpbC5j
b20NCkNDOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4NCg0KLS0tDQoNCg0K
IGRyaXZlcnMvbWVkaWEvdXNiL3NpYW5vL3Ntc3VzYi5jIHwgICAzMyArKysr
KysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0NCiAxIGZpbGUgY2hhbmdl
ZCwgMjAgaW5zZXJ0aW9ucygrKSwgMTMgZGVsZXRpb25zKC0pDQoNCkluZGV4
OiB1c2ItZGV2ZWwvZHJpdmVycy9tZWRpYS91c2Ivc2lhbm8vc21zdXNiLmMN
Cj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT0NCi0tLSB1c2ItZGV2ZWwub3JpZy9k
cml2ZXJzL21lZGlhL3VzYi9zaWFuby9zbXN1c2IuYw0KKysrIHVzYi1kZXZl
bC9kcml2ZXJzL21lZGlhL3VzYi9zaWFuby9zbXN1c2IuYw0KQEAgLTQwMCw2
ICs0MDAsNyBAQCBzdGF0aWMgaW50IHNtc3VzYl9pbml0X2RldmljZShzdHJ1
Y3QgdXNiDQogCXN0cnVjdCBzbXNkZXZpY2VfcGFyYW1zX3QgcGFyYW1zOw0K
IAlzdHJ1Y3Qgc21zdXNiX2RldmljZV90ICpkZXY7DQogCWludCBpLCByYzsN
CisJaW50IGluX21heHA7DQogDQogCS8qIGNyZWF0ZSBkZXZpY2Ugb2JqZWN0
ICovDQogCWRldiA9IGt6YWxsb2Moc2l6ZW9mKHN0cnVjdCBzbXN1c2JfZGV2
aWNlX3QpLCBHRlBfS0VSTkVMKTsNCkBAIC00MTEsNiArNDEyLDI0IEBAIHN0
YXRpYyBpbnQgc21zdXNiX2luaXRfZGV2aWNlKHN0cnVjdCB1c2INCiAJZGV2
LT51ZGV2ID0gaW50ZXJmYWNlX3RvX3VzYmRldihpbnRmKTsNCiAJZGV2LT5z
dGF0ZSA9IFNNU1VTQl9ESVNDT05ORUNURUQ7DQogDQorCWZvciAoaSA9IDA7
IGkgPCBpbnRmLT5jdXJfYWx0c2V0dGluZy0+ZGVzYy5iTnVtRW5kcG9pbnRz
OyBpKyspIHsNCisJCXN0cnVjdCB1c2JfZW5kcG9pbnRfZGVzY3JpcHRvciAq
ZGVzYyA9DQorCQkJCSZpbnRmLT5jdXJfYWx0c2V0dGluZy0+ZW5kcG9pbnRb
aV0uZGVzYzsNCisNCisJCWlmIChkZXNjLT5iRW5kcG9pbnRBZGRyZXNzICYg
VVNCX0RJUl9JTikgew0KKwkJCWRldi0+aW5fZXAgPSBkZXNjLT5iRW5kcG9p
bnRBZGRyZXNzOw0KKwkJCWluX21heHAgPSB1c2JfZW5kcG9pbnRfbWF4cChk
ZXNjKTsNCisJCX0gZWxzZSB7DQorCQkJZGV2LT5vdXRfZXAgPSBkZXNjLT5i
RW5kcG9pbnRBZGRyZXNzOw0KKwkJfQ0KKwl9DQorDQorCXNtc19pbmZvKCJp
bl9lcCA9ICUwMngsIG91dF9lcCA9ICUwMngiLCBkZXYtPmluX2VwLCBkZXYt
Pm91dF9lcCk7DQorCWlmICghZGV2LT5pbl9lcCB8fCAhZGV2LT5vdXRfZXAp
IHsJLyogTWlzc2luZyBlbmRwb2ludHM/ICovDQorCQlzbXN1c2JfdGVybV9k
ZXZpY2UoaW50Zik7DQorCQlyZXR1cm4gLUVOT0RFVjsNCisJfQ0KKw0KIAlw
YXJhbXMuZGV2aWNlX3R5cGUgPSBzbXNfZ2V0X2JvYXJkKGJvYXJkX2lkKS0+
dHlwZTsNCiANCiAJc3dpdGNoIChwYXJhbXMuZGV2aWNlX3R5cGUpIHsNCkBA
IC00MjUsMjQgKzQ0NCwxMiBAQCBzdGF0aWMgaW50IHNtc3VzYl9pbml0X2Rl
dmljZShzdHJ1Y3QgdXNiDQogCQkvKiBmYWxsLXRocnUgKi8NCiAJZGVmYXVs
dDoNCiAJCWRldi0+YnVmZmVyX3NpemUgPSBVU0IyX0JVRkZFUl9TSVpFOw0K
LQkJZGV2LT5yZXNwb25zZV9hbGlnbm1lbnQgPQ0KLQkJICAgIGxlMTZfdG9f
Y3B1KGRldi0+dWRldi0+ZXBfaW5bMV0tPmRlc2Mud01heFBhY2tldFNpemUp
IC0NCi0JCSAgICBzaXplb2Yoc3RydWN0IHNtc19tc2dfaGRyKTsNCisJCWRl
di0+cmVzcG9uc2VfYWxpZ25tZW50ID0gaW5fbWF4cCAtIHNpemVvZihzdHJ1
Y3Qgc21zX21zZ19oZHIpOw0KIA0KIAkJcGFyYW1zLmZsYWdzIHw9IFNNU19E
RVZJQ0VfRkFNSUxZMjsNCiAJCWJyZWFrOw0KIAl9DQogDQotCWZvciAoaSA9
IDA7IGkgPCBpbnRmLT5jdXJfYWx0c2V0dGluZy0+ZGVzYy5iTnVtRW5kcG9p
bnRzOyBpKyspIHsNCi0JCWlmIChpbnRmLT5jdXJfYWx0c2V0dGluZy0+ZW5k
cG9pbnRbaV0uZGVzYy4gYkVuZHBvaW50QWRkcmVzcyAmIFVTQl9ESVJfSU4p
DQotCQkJZGV2LT5pbl9lcCA9IGludGYtPmN1cl9hbHRzZXR0aW5nLT5lbmRw
b2ludFtpXS5kZXNjLmJFbmRwb2ludEFkZHJlc3M7DQotCQllbHNlDQotCQkJ
ZGV2LT5vdXRfZXAgPSBpbnRmLT5jdXJfYWx0c2V0dGluZy0+ZW5kcG9pbnRb
aV0uZGVzYy5iRW5kcG9pbnRBZGRyZXNzOw0KLQl9DQotDQotCXNtc19pbmZv
KCJpbl9lcCA9ICUwMngsIG91dF9lcCA9ICUwMngiLA0KLQkJZGV2LT5pbl9l
cCwgZGV2LT5vdXRfZXApOw0KLQ0KIAlwYXJhbXMuZGV2aWNlID0gJmRldi0+
dWRldi0+ZGV2Ow0KIAlwYXJhbXMuYnVmZmVyX3NpemUgPSBkZXYtPmJ1ZmZl
cl9zaXplOw0KIAlwYXJhbXMubnVtX2J1ZmZlcnMgPSBNQVhfQlVGRkVSUzsN
Cg==
---1559625215-94944122-1557253954=:1632--
