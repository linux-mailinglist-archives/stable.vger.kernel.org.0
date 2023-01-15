Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD65B66AF11
	for <lists+stable@lfdr.de>; Sun, 15 Jan 2023 03:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbjAOC1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 21:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjAOC1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 21:27:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19485A247
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 18:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673749624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AJIvyqOWtN+A1+cEe3pWM7nweu5/e4TKYos1SMlWyfU=;
        b=KkU019oHAm97EW2oYW090E9FswPV/kj+9xaqMQd0qBbTHR31IlNtZ+1pRiAKRRXZSWl/Of
        xORBHQF2VvRMegS7z473Zem/m0GH0I5Mxo8hVo5fhs+tqndPLPzTt7eCww9l7xAL6dukEk
        z743JTC7nuTw4wazU41GIguMwiw/MDk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-XtIooDTnO3anP22949Yd3w-1; Sat, 14 Jan 2023 21:26:55 -0500
X-MC-Unique: XtIooDTnO3anP22949Yd3w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31C1E1C068C3;
        Sun, 15 Jan 2023 02:26:55 +0000 (UTC)
Received: from [10.22.8.29] (unknown [10.22.8.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D60B32166B26;
        Sun, 15 Jan 2023 02:26:54 +0000 (UTC)
Content-Type: multipart/mixed; boundary="------------5Gbd9SQxay1w8LgjwaizY4f0"
Message-ID: <41a01c47-ebf6-49c5-45f0-5d03a2a3b805@redhat.com>
Date:   Sat, 14 Jan 2023 21:26:54 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: FAILED: patch "[PATCH] sched/core: Fix use-after-free bug in
 dup_user_cpus_ptr()" failed to apply to 6.1-stable tree
Content-Language: en-US
From:   Waiman Long <longman@redhat.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        wangbiao3@xiaomi.com
References: <167368999799102@kroah.com>
 <fea9d850-4942-3457-0e14-573763e891a4@redhat.com>
 <881dc653-a6b4-6fea-542d-e06d79d011e5@redhat.com>
In-Reply-To: <881dc653-a6b4-6fea-542d-e06d79d011e5@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------5Gbd9SQxay1w8LgjwaizY4f0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 1/14/23 14:33, Waiman Long wrote:
> On 1/14/23 14:28, Waiman Long wrote:
>> On 1/14/23 04:53, gregkh@linuxfoundation.org wrote:
>>> The patch below does not apply to the 6.1-stable tree.
>>> If someone wants it applied there, or to any other stable or longterm
>>> tree, then please email the backport, including the original git commit
>>> id to <stable@vger.kernel.org>.
>>>
>>> Possible dependencies:
>>>
>>> 87ca4f9efbd7 ("sched/core: Fix use-after-free bug in 
>>> dup_user_cpus_ptr()")
>>> 8f9ea86fdf99 ("sched: Always preserve the user requested cpumask")
>>> 713a2e21a513 ("sched: Introduce affinity_context")
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>> ------------------ original commit in Linus's tree ------------------
>>>
>>>  From 87ca4f9efbd7cc649ff43b87970888f2812945b8 Mon Sep 17 00:00:00 2001
>>> From: Waiman Long <longman@redhat.com>
>>> Date: Fri, 30 Dec 2022 23:11:19 -0500
>>> Subject: [PATCH] sched/core: Fix use-after-free bug in 
>>> dup_user_cpus_ptr()
>>> MIME-Version: 1.0
>>> Content-Type: text/plain; charset=UTF-8
>>> Content-Transfer-Encoding: 8bit
>>>
>>> Since commit 07ec77a1d4e8 ("sched: Allow task CPU affinity to be
>>> restricted on asymmetric systems"), the setting and clearing of
>>> user_cpus_ptr are done under pi_lock for arm64 architecture. However,
>>> dup_user_cpus_ptr() accesses user_cpus_ptr without any lock
>>> protection. Since sched_setaffinity() can be invoked from another
>>> process, the process being modified may be undergoing fork() at
>>> the same time.  When racing with the clearing of user_cpus_ptr in
>>> __set_cpus_allowed_ptr_locked(), it can lead to user-after-free and
>>> possibly double-free in arm64 kernel.
>>>
>>> Commit 8f9ea86fdf99 ("sched: Always preserve the user requested
>>> cpumask") fixes this problem as user_cpus_ptr, once set, will never
>>> be cleared in a task's lifetime. However, this bug was re-introduced
>>> in commit 851a723e45d1 ("sched: Always clear user_cpus_ptr in
>>> do_set_cpus_allowed()") which allows the clearing of user_cpus_ptr in
>>> do_set_cpus_allowed(). This time, it will affect all arches.
>>>
>>> Fix this bug by always clearing the user_cpus_ptr of the newly
>>> cloned/forked task before the copying process starts and check the
>>> user_cpus_ptr state of the source task under pi_lock.
>>>
>>> Note to stable, this patch won't be applicable to stable releases.
>>> Just copy the new dup_user_cpus_ptr() function over.
>>
>> I have a note here about what to do when backporting to stable. Just 
>> copy the new function over will be fine.
>
> That will be before the application of the subsequent patch which will 
> modify it in a way for suitable for stable. I can send out a separate 
> stable patch for that later today.

The attached patch will apply to linux-6.1.y as well as linux-5.15.y.

Cheers,
Longman

--------------5Gbd9SQxay1w8LgjwaizY4f0
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-sched-core-Fix-use-after-free-bug-in-dup_user_cpus_p.patch"
Content-Disposition: attachment;
 filename*0="0001-sched-core-Fix-use-after-free-bug-in-dup_user_cpus_p.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSAzNmZlZWJiZmEyYjE4YTAyMTAyZjEzNmZkZmFhNTNhN2YyNTgzMGQ4IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBXYWltYW4gTG9uZyA8bG9uZ21hbkByZWRoYXQuY29t
PgpEYXRlOiBTYXQsIDE0IEphbiAyMDIzIDIwOjA1OjM0IC0wNTAwClN1YmplY3Q6IFtQQVRD
SF0gc2NoZWQvY29yZTogRml4IHVzZS1hZnRlci1mcmVlIGJ1ZyBpbiBkdXBfdXNlcl9jcHVz
X3B0cigpCk1JTUUtVmVyc2lvbjogMS4wCkNvbnRlbnQtVHlwZTogdGV4dC9wbGFpbjsgY2hh
cnNldD1VVEYtOApDb250ZW50LVRyYW5zZmVyLUVuY29kaW5nOiA4Yml0Cgpjb21taXQgODdj
YTRmOWVmYmQ3Y2M2NDlmZjQzYjg3OTcwODg4ZjI4MTI5NDViOCB1cHN0cmVhbS4KClNpbmNl
IGNvbW1pdCAwN2VjNzdhMWQ0ZTggKCJzY2hlZDogQWxsb3cgdGFzayBDUFUgYWZmaW5pdHkg
dG8gYmUKcmVzdHJpY3RlZCBvbiBhc3ltbWV0cmljIHN5c3RlbXMiKSwgdGhlIHNldHRpbmcg
YW5kIGNsZWFyaW5nIG9mCnVzZXJfY3B1c19wdHIgYXJlIGRvbmUgdW5kZXIgcGlfbG9jayBm
b3IgYXJtNjQgYXJjaGl0ZWN0dXJlLiBIb3dldmVyLApkdXBfdXNlcl9jcHVzX3B0cigpIGFj
Y2Vzc2VzIHVzZXJfY3B1c19wdHIgd2l0aG91dCBhbnkgbG9jawpwcm90ZWN0aW9uLiBTaW5j
ZSBzY2hlZF9zZXRhZmZpbml0eSgpIGNhbiBiZSBpbnZva2VkIGZyb20gYW5vdGhlcgpwcm9j
ZXNzLCB0aGUgcHJvY2VzcyBiZWluZyBtb2RpZmllZCBtYXkgYmUgdW5kZXJnb2luZyBmb3Jr
KCkgYXQKdGhlIHNhbWUgdGltZS4gIFdoZW4gcmFjaW5nIHdpdGggdGhlIGNsZWFyaW5nIG9m
IHVzZXJfY3B1c19wdHIgaW4KX19zZXRfY3B1c19hbGxvd2VkX3B0cl9sb2NrZWQoKSwgaXQg
Y2FuIGxlYWQgdG8gdXNlci1hZnRlci1mcmVlIGFuZApwb3NzaWJseSBkb3VibGUtZnJlZSBp
biBhcm02NCBrZXJuZWwuCgpDb21taXQgOGY5ZWE4NmZkZjk5ICgic2NoZWQ6IEFsd2F5cyBw
cmVzZXJ2ZSB0aGUgdXNlciByZXF1ZXN0ZWQKY3B1bWFzayIpIGZpeGVzIHRoaXMgcHJvYmxl
bSBhcyB1c2VyX2NwdXNfcHRyLCBvbmNlIHNldCwgd2lsbCBuZXZlcgpiZSBjbGVhcmVkIGlu
IGEgdGFzaydzIGxpZmV0aW1lLiBIb3dldmVyLCB0aGlzIGJ1ZyB3YXMgcmUtaW50cm9kdWNl
ZAppbiBjb21taXQgODUxYTcyM2U0NWQxICgic2NoZWQ6IEFsd2F5cyBjbGVhciB1c2VyX2Nw
dXNfcHRyIGluCmRvX3NldF9jcHVzX2FsbG93ZWQoKSIpIHdoaWNoIGFsbG93cyB0aGUgY2xl
YXJpbmcgb2YgdXNlcl9jcHVzX3B0ciBpbgpkb19zZXRfY3B1c19hbGxvd2VkKCkuIFRoaXMg
dGltZSwgaXQgd2lsbCBhZmZlY3QgYWxsIGFyY2hlcy4KCkZpeCB0aGlzIGJ1ZyBieSBhbHdh
eXMgY2xlYXJpbmcgdGhlIHVzZXJfY3B1c19wdHIgb2YgdGhlIG5ld2x5CmNsb25lZC9mb3Jr
ZWQgdGFzayBiZWZvcmUgdGhlIGNvcHlpbmcgcHJvY2VzcyBzdGFydHMgYW5kIGNoZWNrIHRo
ZQp1c2VyX2NwdXNfcHRyIHN0YXRlIG9mIHRoZSBzb3VyY2UgdGFzayB1bmRlciBwaV9sb2Nr
LgoKTm90ZSB0byBzdGFibGUsIHRoaXMgcGF0Y2ggd29uJ3QgYmUgYXBwbGljYWJsZSB0byBz
dGFibGUgcmVsZWFzZXMuCkp1c3QgY29weSB0aGUgbmV3IGR1cF91c2VyX2NwdXNfcHRyKCkg
ZnVuY3Rpb24gb3Zlci4KCkZpeGVzOiAwN2VjNzdhMWQ0ZTggKCJzY2hlZDogQWxsb3cgdGFz
ayBDUFUgYWZmaW5pdHkgdG8gYmUgcmVzdHJpY3RlZCBvbiBhc3ltbWV0cmljIHN5c3RlbXMi
KQpGaXhlczogODUxYTcyM2U0NWQxICgic2NoZWQ6IEFsd2F5cyBjbGVhciB1c2VyX2NwdXNf
cHRyIGluIGRvX3NldF9jcHVzX2FsbG93ZWQoKSIpClJlcG9ydGVkLWJ5OiBEYXZpZCBXYW5n
IOeOi+aghyA8d2FuZ2JpYW8zQHhpYW9taS5jb20+ClNpZ25lZC1vZmYtYnk6IFdhaW1hbiBM
b25nIDxsb25nbWFuQHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IEluZ28gTW9sbmFyIDxt
aW5nb0BrZXJuZWwub3JnPgpSZXZpZXdlZC1ieTogUGV0ZXIgWmlqbHN0cmEgPHBldGVyekBp
bmZyYWRlYWQub3JnPgpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwpMaW5rOiBodHRwczov
L2xvcmUua2VybmVsLm9yZy9yLzIwMjIxMjMxMDQxMTIwLjQ0MDc4NS0yLWxvbmdtYW5AcmVk
aGF0LmNvbQotLS0KIGtlcm5lbC9zY2hlZC9jb3JlLmMgfCAzNyArKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKystLS0tCiAxIGZpbGUgY2hhbmdlZCwgMzMgaW5zZXJ0aW9ucygr
KSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9rZXJuZWwvc2NoZWQvY29yZS5jIGIv
a2VybmVsL3NjaGVkL2NvcmUuYwppbmRleCA1MzVhZjlmYmVhN2IuLjk4MWU0MWNjNDEyMSAx
MDA2NDQKLS0tIGEva2VybmVsL3NjaGVkL2NvcmUuYworKysgYi9rZXJuZWwvc2NoZWQvY29y
ZS5jCkBAIC0yNTg3LDE0ICsyNTg3LDQzIEBAIHZvaWQgZG9fc2V0X2NwdXNfYWxsb3dlZChz
dHJ1Y3QgdGFza19zdHJ1Y3QgKnAsIGNvbnN0IHN0cnVjdCBjcHVtYXNrICpuZXdfbWFzaykK
IGludCBkdXBfdXNlcl9jcHVzX3B0cihzdHJ1Y3QgdGFza19zdHJ1Y3QgKmRzdCwgc3RydWN0
IHRhc2tfc3RydWN0ICpzcmMsCiAJCSAgICAgIGludCBub2RlKQogewotCWlmICghc3JjLT51
c2VyX2NwdXNfcHRyKQorCWNwdW1hc2tfdCAqdXNlcl9tYXNrOworCXVuc2lnbmVkIGxvbmcg
ZmxhZ3M7CisKKwkvKgorCSAqIEFsd2F5cyBjbGVhciBkc3QtPnVzZXJfY3B1c19wdHIgZmly
c3QgYXMgdGhlaXIgdXNlcl9jcHVzX3B0cidzCisJICogbWF5IGRpZmZlciBieSBub3cgZHVl
IHRvIHJhY2luZy4KKwkgKi8KKwlkc3QtPnVzZXJfY3B1c19wdHIgPSBOVUxMOworCisJLyoK
KwkgKiBUaGlzIGNoZWNrIGlzIHJhY3kgYW5kIGxvc2luZyB0aGUgcmFjZSBpcyBhIHZhbGlk
IHNpdHVhdGlvbi4KKwkgKiBJdCBpcyBub3Qgd29ydGggdGhlIGV4dHJhIG92ZXJoZWFkIG9m
IHRha2luZyB0aGUgcGlfbG9jayBvbgorCSAqIGV2ZXJ5IGZvcmsvY2xvbmUuCisJICovCisJ
aWYgKGRhdGFfcmFjZSghc3JjLT51c2VyX2NwdXNfcHRyKSkKIAkJcmV0dXJuIDA7CiAKLQlk
c3QtPnVzZXJfY3B1c19wdHIgPSBrbWFsbG9jX25vZGUoY3B1bWFza19zaXplKCksIEdGUF9L
RVJORUwsIG5vZGUpOwotCWlmICghZHN0LT51c2VyX2NwdXNfcHRyKQorCXVzZXJfbWFzayA9
IGttYWxsb2Nfbm9kZShjcHVtYXNrX3NpemUoKSwgR0ZQX0tFUk5FTCwgbm9kZSk7CisJaWYg
KCF1c2VyX21hc2spCiAJCXJldHVybiAtRU5PTUVNOwogCi0JY3B1bWFza19jb3B5KGRzdC0+
dXNlcl9jcHVzX3B0ciwgc3JjLT51c2VyX2NwdXNfcHRyKTsKKwkvKgorCSAqIFVzZSBwaV9s
b2NrIHRvIHByb3RlY3QgY29udGVudCBvZiB1c2VyX2NwdXNfcHRyCisJICoKKwkgKiBUaG91
Z2ggdW5saWtlbHksIHVzZXJfY3B1c19wdHIgY2FuIGJlIHJlc2V0IHRvIE5VTEwgYnkgYSBj
b25jdXJyZW50CisJICogZG9fc2V0X2NwdXNfYWxsb3dlZCgpLgorCSAqLworCXJhd19zcGlu
X2xvY2tfaXJxc2F2ZSgmc3JjLT5waV9sb2NrLCBmbGFncyk7CisJaWYgKHNyYy0+dXNlcl9j
cHVzX3B0cikgeworCQlzd2FwKGRzdC0+dXNlcl9jcHVzX3B0ciwgdXNlcl9tYXNrKTsKKwkJ
Y3B1bWFza19jb3B5KGRzdC0+dXNlcl9jcHVzX3B0ciwgc3JjLT51c2VyX2NwdXNfcHRyKTsK
Kwl9CisJcmF3X3NwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnNyYy0+cGlfbG9jaywgZmxhZ3Mp
OworCisJaWYgKHVubGlrZWx5KHVzZXJfbWFzaykpCisJCWtmcmVlKHVzZXJfbWFzayk7CisK
IAlyZXR1cm4gMDsKIH0KIAotLSAKMi4zMS4xCgo=

--------------5Gbd9SQxay1w8LgjwaizY4f0--

