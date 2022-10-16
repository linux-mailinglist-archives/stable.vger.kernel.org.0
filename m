Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61EA5600326
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 22:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiJPUCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 16:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiJPUCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 16:02:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25E429825
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 13:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665950552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QIsFeevCbuwHb2I+xo0C7MUcbxe14NJ6KVTWsdZMFXE=;
        b=YBBcs71d05Xf9JzUrRneL1U30G3WvsdIY2wvPPPjnTM8p40GkZzbWjpU5yRhgQT8sOy5dO
        Bo9bEHStTP8t5e3Whe9JyMcIX0FgsJaGmLBmjyQAoQS4aj3cGEmM1EgDgLGM4yK7qrmBF8
        qkZjxKK9HU9E5mM7e5T/vmvilQW5UHI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-300-z-Z3JBxTNAaZbH8Y6u_8mg-1; Sun, 16 Oct 2022 16:02:30 -0400
X-MC-Unique: z-Z3JBxTNAaZbH8Y6u_8mg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51F24185A78F;
        Sun, 16 Oct 2022 20:02:30 +0000 (UTC)
Received: from [10.22.8.77] (unknown [10.22.8.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0189C56D204;
        Sun, 16 Oct 2022 20:02:29 +0000 (UTC)
Content-Type: multipart/mixed; boundary="------------HN75JXDAeqOhl11TGL0PGyJM"
Message-ID: <bc62af00-8f3b-31fe-0ff7-afd9473c0d0f@redhat.com>
Date:   Sun, 16 Oct 2022 16:02:29 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: FAILED: patch "[PATCH] tracing: Disable interrupt or preemption
 before acquiring" failed to apply to 5.4-stable tree
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     boqun.feng@gmail.com, mingo@redhat.com, peterz@infradead.org,
        rostedt@goodmis.org, will@kernel.org, stable@vger.kernel.org
References: <166593467012288@kroah.com>
 <778aaa49-9595-00b2-f054-717d871d4e08@redhat.com>
 <Y0wyv/wyQoS+J6JZ@kroah.com>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <Y0wyv/wyQoS+J6JZ@kroah.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------HN75JXDAeqOhl11TGL0PGyJM
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/22 12:35, Greg KH wrote:
> On Sun, Oct 16, 2022 at 12:26:22PM -0400, Waiman Long wrote:
>> On 10/16/22 11:37, gregkh@linuxfoundation.org wrote:
>>> The patch below does not apply to the 5.4-stable tree.
>>> If someone wants it applied there, or to any other stable or longterm
>>> tree, then please email the backport, including the original git commit
>>> id to <stable@vger.kernel.org>.
>>>
>>> Possible dependencies:
>>>
>>> c0a581d7126c ("tracing: Disable interrupt or preemption before acquiring arch_spinlock_t")
>>>
>>> thanks,
>>>
>>> greg k-h
>> You just have to remove the lockdep_assert_preemption_disabled() line as
>> this macro isn't defined in v5.4. It is a debug statement and its removal
>> won't have any functional impact.
> Wonderful, can you please submit a fixed up version like this so that I
> can apply it?
>
> thanks,
>
> greg k-h

Sure. See the attached patch.

Cheers,
Longman

--------------HN75JXDAeqOhl11TGL0PGyJM
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-tracing-Disable-interrupt-or-preemption-before-acqui.patch"
Content-Disposition: attachment;
 filename*0="0001-tracing-Disable-interrupt-or-preemption-before-acqui.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSBmZWVhMjJhMGUwOGVhY2U0OTc3ZWFlNTIwNGFiZWEyYmE2Yzc2YzZjIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBXYWltYW4gTG9uZyA8bG9uZ21hbkByZWRoYXQuY29t
PgpEYXRlOiBTdW4sIDE2IE9jdCAyMDIyIDE2OjAwOjI5IC0wNDAwClN1YmplY3Q6IFtQQVRD
SF0gdHJhY2luZzogRGlzYWJsZSBpbnRlcnJ1cHQgb3IgcHJlZW1wdGlvbiBiZWZvcmUgYWNx
dWlyaW5nCiBhcmNoX3NwaW5sb2NrX3QKCkZyb206IFdhaW1hbiBMb25nIDxsb25nbWFuQHJl
ZGhhdC5jb20+Cgpjb21taXQgYzBhNTgxZDcxMjZjMGJiYzk2MTYzMjc2ZjU4NWZkN2I0ZTRk
OGQwZSB1cHN0cmVhbS4KCkl0IHdhcyBmb3VuZCB0aGF0IHNvbWUgdHJhY2luZyBmdW5jdGlv
bnMgaW4ga2VybmVsL3RyYWNlL3RyYWNlLmMgYWNxdWlyZQphbiBhcmNoX3NwaW5sb2NrX3Qg
d2l0aCBwcmVlbXB0aW9uIGFuZCBpcnFzIGVuYWJsZWQuIEFuIGV4YW1wbGUgaXMgdGhlCnRy
YWNpbmdfc2F2ZWRfY21kbGluZXNfc2l6ZV9yZWFkKCkgZnVuY3Rpb24gd2hpY2ggaW50ZXJt
aXR0ZW50bHkgY2F1c2VzCmEgIkJVRzogdXNpbmcgc21wX3Byb2Nlc3Nvcl9pZCgpIGluIHBy
ZWVtcHRpYmxlIiB3YXJuaW5nIHdoZW4gdGhlIExUUApyZWFkX2FsbF9wcm9jIHRlc3QgaXMg
cnVuLgoKVGhhdCBjYW4gYmUgcHJvYmxlbWF0aWMgaW4gY2FzZSBwcmVlbXB0aW9uIGhhcHBl
bnMgYWZ0ZXIgYWNxdWlyaW5nIHRoZQpsb2NrLiBBZGQgdGhlIG5lY2Vzc2FyeSBwcmVlbXB0
aW9uIG9yIGludGVycnVwdCBkaXNhYmxpbmcgY29kZSBpbiB0aGUKYXBwcm9wcmlhdGUgcGxh
Y2VzIGJlZm9yZSBhY3F1aXJpbmcgYW4gYXJjaF9zcGlubG9ja190LgoKVGhlIGNvbnZlbnRp
b24gaGVyZSBpcyB0byBkaXNhYmxlIHByZWVtcHRpb24gZm9yIHRyYWNlX2NtZGxpbmVfbG9j
ayBhbmQKaW50ZXJ1cHQgZm9yIG1heF9sb2NrLgoKTGluazogaHR0cHM6Ly9sa21sLmtlcm5l
bC5vcmcvci8yMDIyMDkyMjE0NTYyMi4xNzQ0ODI2LTEtbG9uZ21hbkByZWRoYXQuY29tCgpD
YzogUGV0ZXIgWmlqbHN0cmEgPHBldGVyekBpbmZyYWRlYWQub3JnPgpDYzogSW5nbyBNb2xu
YXIgPG1pbmdvQHJlZGhhdC5jb20+CkNjOiBXaWxsIERlYWNvbiA8d2lsbEBrZXJuZWwub3Jn
PgpDYzogQm9xdW4gRmVuZyA8Ym9xdW4uZmVuZ0BnbWFpbC5jb20+CkNjOiBzdGFibGVAdmdl
ci5rZXJuZWwub3JnCkZpeGVzOiBhMzU4NzNhMDk5M2IgKCJ0cmFjaW5nOiBBZGQgY29uZGl0
aW9uYWwgc25hcHNob3QiKQpGaXhlczogOTM5YzdhNGYwNGZjICgidHJhY2luZzogSW50cm9k
dWNlIHNhdmVkX2NtZGxpbmVzX3NpemUgZmlsZSIpClN1Z2dlc3RlZC1ieTogU3RldmVuIFJv
c3RlZHQgPHJvc3RlZHRAZ29vZG1pcy5vcmc+ClNpZ25lZC1vZmYtYnk6IFdhaW1hbiBMb25n
IDxsb25nbWFuQHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlbiBSb3N0ZWR0IChH
b29nbGUpIDxyb3N0ZWR0QGdvb2RtaXMub3JnPgotLS0KIGtlcm5lbC90cmFjZS90cmFjZS5j
IHwgMjIgKysrKysrKysrKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDIyIGluc2Vy
dGlvbnMoKykKCmRpZmYgLS1naXQgYS9rZXJuZWwvdHJhY2UvdHJhY2UuYyBiL2tlcm5lbC90
cmFjZS90cmFjZS5jCmluZGV4IDU1ZGE4OGYxODM0Mi4uNjJmZDg3OThiMGM0IDEwMDY0NAot
LS0gYS9rZXJuZWwvdHJhY2UvdHJhY2UuYworKysgYi9rZXJuZWwvdHJhY2UvdHJhY2UuYwpA
QCAtMTAxNSwxMiArMTAxNSwxNCBAQCB2b2lkICp0cmFjaW5nX2NvbmRfc25hcHNob3RfZGF0
YShzdHJ1Y3QgdHJhY2VfYXJyYXkgKnRyKQogewogCXZvaWQgKmNvbmRfZGF0YSA9IE5VTEw7
CiAKKwlsb2NhbF9pcnFfZGlzYWJsZSgpOwogCWFyY2hfc3Bpbl9sb2NrKCZ0ci0+bWF4X2xv
Y2spOwogCiAJaWYgKHRyLT5jb25kX3NuYXBzaG90KQogCQljb25kX2RhdGEgPSB0ci0+Y29u
ZF9zbmFwc2hvdC0+Y29uZF9kYXRhOwogCiAJYXJjaF9zcGluX3VubG9jaygmdHItPm1heF9s
b2NrKTsKKwlsb2NhbF9pcnFfZW5hYmxlKCk7CiAKIAlyZXR1cm4gY29uZF9kYXRhOwogfQpA
QCAtMTE1Niw5ICsxMTU4LDExIEBAIGludCB0cmFjaW5nX3NuYXBzaG90X2NvbmRfZW5hYmxl
KHN0cnVjdCB0cmFjZV9hcnJheSAqdHIsIHZvaWQgKmNvbmRfZGF0YSwKIAkJZ290byBmYWls
X3VubG9jazsKIAl9CiAKKwlsb2NhbF9pcnFfZGlzYWJsZSgpOwogCWFyY2hfc3Bpbl9sb2Nr
KCZ0ci0+bWF4X2xvY2spOwogCXRyLT5jb25kX3NuYXBzaG90ID0gY29uZF9zbmFwc2hvdDsK
IAlhcmNoX3NwaW5fdW5sb2NrKCZ0ci0+bWF4X2xvY2spOworCWxvY2FsX2lycV9lbmFibGUo
KTsKIAogCW11dGV4X3VubG9jaygmdHJhY2VfdHlwZXNfbG9jayk7CiAKQEAgLTExODUsNiAr
MTE4OSw3IEBAIGludCB0cmFjaW5nX3NuYXBzaG90X2NvbmRfZGlzYWJsZShzdHJ1Y3QgdHJh
Y2VfYXJyYXkgKnRyKQogewogCWludCByZXQgPSAwOwogCisJbG9jYWxfaXJxX2Rpc2FibGUo
KTsKIAlhcmNoX3NwaW5fbG9jaygmdHItPm1heF9sb2NrKTsKIAogCWlmICghdHItPmNvbmRf
c25hcHNob3QpCkBAIC0xMTk1LDYgKzEyMDAsNyBAQCBpbnQgdHJhY2luZ19zbmFwc2hvdF9j
b25kX2Rpc2FibGUoc3RydWN0IHRyYWNlX2FycmF5ICp0cikKIAl9CiAKIAlhcmNoX3NwaW5f
dW5sb2NrKCZ0ci0+bWF4X2xvY2spOworCWxvY2FsX2lycV9lbmFibGUoKTsKIAogCXJldHVy
biByZXQ7CiB9CkBAIC0xOTUxLDYgKzE5NTcsMTEgQEAgc3RhdGljIHNpemVfdCB0Z2lkX21h
cF9tYXg7CiAKICNkZWZpbmUgU0FWRURfQ01ETElORVNfREVGQVVMVCAxMjgKICNkZWZpbmUg
Tk9fQ01ETElORV9NQVAgVUlOVF9NQVgKKy8qCisgKiBQcmVlbXB0aW9uIG11c3QgYmUgZGlz
YWJsZWQgYmVmb3JlIGFjcXVpcmluZyB0cmFjZV9jbWRsaW5lX2xvY2suCisgKiBUaGUgdmFy
aW91cyB0cmFjZV9hcnJheXMnIG1heF9sb2NrIG11c3QgYmUgYWNxdWlyZWQgaW4gYSBjb250
ZXh0CisgKiB3aGVyZSBpbnRlcnJ1cHQgaXMgZGlzYWJsZWQuCisgKi8KIHN0YXRpYyBhcmNo
X3NwaW5sb2NrX3QgdHJhY2VfY21kbGluZV9sb2NrID0gX19BUkNIX1NQSU5fTE9DS19VTkxP
Q0tFRDsKIHN0cnVjdCBzYXZlZF9jbWRsaW5lc19idWZmZXIgewogCXVuc2lnbmVkIG1hcF9w
aWRfdG9fY21kbGluZVtQSURfTUFYX0RFRkFVTFQrMV07CkBAIC0yMTYzLDYgKzIxNzQsOSBA
QCBzdGF0aWMgaW50IHRyYWNlX3NhdmVfY21kbGluZShzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRz
aykKIAkgKiB0aGUgbG9jaywgYnV0IHdlIGFsc28gZG9uJ3Qgd2FudCB0byBzcGluCiAJICog
bm9yIGRvIHdlIHdhbnQgdG8gZGlzYWJsZSBpbnRlcnJ1cHRzLAogCSAqIHNvIGlmIHdlIG1p
c3MgaGVyZSwgdGhlbiBiZXR0ZXIgbHVjayBuZXh0IHRpbWUuCisJICoKKwkgKiBUaGlzIGlz
IGNhbGxlZCB3aXRoaW4gdGhlIHNjaGVkdWxlciBhbmQgd2FrZSB1cCwgc28gaW50ZXJydXB0
cworCSAqIGhhZCBiZXR0ZXIgYmVlbiBkaXNhYmxlZCBhbmQgcnVuIHF1ZXVlIGxvY2sgYmVl
biBoZWxkLgogCSAqLwogCWlmICghYXJjaF9zcGluX3RyeWxvY2soJnRyYWNlX2NtZGxpbmVf
bG9jaykpCiAJCXJldHVybiAwOwpAQCAtNTE5OSw5ICs1MjEzLDExIEBAIHRyYWNpbmdfc2F2
ZWRfY21kbGluZXNfc2l6ZV9yZWFkKHN0cnVjdCBmaWxlICpmaWxwLCBjaGFyIF9fdXNlciAq
dWJ1ZiwKIAljaGFyIGJ1Zls2NF07CiAJaW50IHI7CiAKKwlwcmVlbXB0X2Rpc2FibGUoKTsK
IAlhcmNoX3NwaW5fbG9jaygmdHJhY2VfY21kbGluZV9sb2NrKTsKIAlyID0gc2NucHJpbnRm
KGJ1Ziwgc2l6ZW9mKGJ1ZiksICIldVxuIiwgc2F2ZWRjbWQtPmNtZGxpbmVfbnVtKTsKIAlh
cmNoX3NwaW5fdW5sb2NrKCZ0cmFjZV9jbWRsaW5lX2xvY2spOworCXByZWVtcHRfZW5hYmxl
KCk7CiAKIAlyZXR1cm4gc2ltcGxlX3JlYWRfZnJvbV9idWZmZXIodWJ1ZiwgY250LCBwcG9z
LCBidWYsIHIpOwogfQpAQCAtNTIyNiwxMCArNTI0MiwxMiBAQCBzdGF0aWMgaW50IHRyYWNp
bmdfcmVzaXplX3NhdmVkX2NtZGxpbmVzKHVuc2lnbmVkIGludCB2YWwpCiAJCXJldHVybiAt
RU5PTUVNOwogCX0KIAorCXByZWVtcHRfZGlzYWJsZSgpOwogCWFyY2hfc3Bpbl9sb2NrKCZ0
cmFjZV9jbWRsaW5lX2xvY2spOwogCXNhdmVkY21kX3RlbXAgPSBzYXZlZGNtZDsKIAlzYXZl
ZGNtZCA9IHM7CiAJYXJjaF9zcGluX3VubG9jaygmdHJhY2VfY21kbGluZV9sb2NrKTsKKwlw
cmVlbXB0X2VuYWJsZSgpOwogCWZyZWVfc2F2ZWRfY21kbGluZXNfYnVmZmVyKHNhdmVkY21k
X3RlbXApOwogCiAJcmV0dXJuIDA7CkBAIC01Njg0LDEwICs1NzAyLDEyIEBAIHN0YXRpYyBp
bnQgdHJhY2luZ19zZXRfdHJhY2VyKHN0cnVjdCB0cmFjZV9hcnJheSAqdHIsIGNvbnN0IGNo
YXIgKmJ1ZikKIAogI2lmZGVmIENPTkZJR19UUkFDRVJfU05BUFNIT1QKIAlpZiAodC0+dXNl
X21heF90cikgeworCQlsb2NhbF9pcnFfZGlzYWJsZSgpOwogCQlhcmNoX3NwaW5fbG9jaygm
dHItPm1heF9sb2NrKTsKIAkJaWYgKHRyLT5jb25kX3NuYXBzaG90KQogCQkJcmV0ID0gLUVC
VVNZOwogCQlhcmNoX3NwaW5fdW5sb2NrKCZ0ci0+bWF4X2xvY2spOworCQlsb2NhbF9pcnFf
ZW5hYmxlKCk7CiAJCWlmIChyZXQpCiAJCQlnb3RvIG91dDsKIAl9CkBAIC02NzY3LDEwICs2
Nzg3LDEyIEBAIHRyYWNpbmdfc25hcHNob3Rfd3JpdGUoc3RydWN0IGZpbGUgKmZpbHAsIGNv
bnN0IGNoYXIgX191c2VyICp1YnVmLCBzaXplX3QgY250LAogCQlnb3RvIG91dDsKIAl9CiAK
Kwlsb2NhbF9pcnFfZGlzYWJsZSgpOwogCWFyY2hfc3Bpbl9sb2NrKCZ0ci0+bWF4X2xvY2sp
OwogCWlmICh0ci0+Y29uZF9zbmFwc2hvdCkKIAkJcmV0ID0gLUVCVVNZOwogCWFyY2hfc3Bp
bl91bmxvY2soJnRyLT5tYXhfbG9jayk7CisJbG9jYWxfaXJxX2VuYWJsZSgpOwogCWlmIChy
ZXQpCiAJCWdvdG8gb3V0OwogCi0tIAoyLjMxLjEKCg==

--------------HN75JXDAeqOhl11TGL0PGyJM--

