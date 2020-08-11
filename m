Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96394241471
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 03:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgHKBOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 21:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbgHKBON (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 21:14:13 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A317BC06174A
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 18:14:13 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id r11so6695118pfl.11
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 18:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language;
        bh=BUKFjtKz4pubf3RVqSbmCea+dcvkG4fg8QKJxpH6xnY=;
        b=XJiocQllzBrU/kJViudbzSRQ8acxyPQe8bXFSb25Oa35wbQPUKLG/nYjird7pcQOJw
         GJ2gsN/b6kAJ/VutKpGquFwXgIV9H3Z2puUMNtKeiRxHVwvxDCJvhANA5vWwf40MJgQr
         ehJnfNXJAofkyhOyuf7ofrlDkOiQJBSfxOFWvBOdCTCITJ5mY4+yv450w3+bniiB3JS1
         RxWZRB25acyf2fmVY+ZpkkGReh13WOnjzVtX8ZDrFxi0TkxkLbSFRUx5ONoN9t0iWAi+
         bClkAn1BQlPJ0a5fWwmZSVjVC1iflyeWsmbkeASyJShY4Ds1UT3r5fEWZE/IUXWRT7OS
         +7Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language;
        bh=BUKFjtKz4pubf3RVqSbmCea+dcvkG4fg8QKJxpH6xnY=;
        b=REal1e5eyEQg+footFBZE5olqnk/8kFY/wYWvjglTW+WoD/Olsm88QnEDnutlu9qwh
         Ii1IzcfasGM7lvMBjzeJSLHM5KI3fFKi/YU78NuXwEFzwy4Lp+55qbVwBR6fnRu1bNcr
         WXSylmpoz5WO7h0i7mCndXlIdNhYlOph+6tb0Eaoq1wTN+CVJHhxIb3PClmgt7iHncw1
         o8IsRDvkU10OSg7zYg8nwGDBGdnaIqc6oLCi+KcCVIlaqtU1ifa/VCxwu1M7OpE/sr0f
         91yQbsX64bzN7BzhSUiw9RJvUr6YE4vP8nTKYrQf5jEzQFBxGsEkdosyK8MWkirZ3GCe
         EFsw==
X-Gm-Message-State: AOAM532NEgJgja5wRp2CjeOkLH8HfceIoR2d7k5d9JFy8c1SyncoZSJP
        vz/EmKnguY2SZ+h6gIaWJ40jvqW4o68=
X-Google-Smtp-Source: ABdhPJzBHuSxHIU9nHCFj0+GaLEvh1RnfqFsBn9Uv3xMM2Qa2/u6n6TxP5IvY3sDwNL6g7UZWjrGHQ==
X-Received: by 2002:a63:220a:: with SMTP id i10mr2838729pgi.88.1597108452880;
        Mon, 10 Aug 2020 18:14:12 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z6sm23732411pfg.68.2020.08.10.18.14.10
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 18:14:11 -0700 (PDT)
To:     stable@vger.kernel.org
From:   Jens Axboe <axboe@kernel.dk>
Subject: Stable inclusion request
Message-ID: <e708995f-6666-fbdd-9373-792007e7ea73@kernel.dk>
Date:   Mon, 10 Aug 2020 19:14:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------DF2E8DFEF87384978C589E37"
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------DF2E8DFEF87384978C589E37
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi,

Can we queue up a backport of:

commit 4c6e277c4cc4a6b3b2b9c66a7b014787ae757cc1                                 
Author: Jens Axboe <axboe@kernel.dk>                                            
Date:   Wed Jul 1 11:29:10 2020 -0600                                           
                                                                                
    io_uring: abstract out task work running

for 5.7 and 5.8 stable? It fixes a reported issue from Dave Chinner,
since the abstraction also ensures that we always set the current
task state appropriately before running task work.

I've attached both a 5.8 and 5.7 port of the patch.

Thanks!

-- 
Jens Axboe


--------------DF2E8DFEF87384978C589E37
Content-Type: text/plain; charset=UTF-8;
 name="5.7-patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="5.7-patch"

Y29tbWl0IDRjNmUyNzdjNGNjNGE2YjNiMmI5YzY2YTdiMDE0Nzg3YWU3NTdjYzEKQXV0aG9y
OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRhdGU6ICAgV2VkIEp1bCAxIDExOjI5
OjEwIDIwMjAgLTA2MDAKCiAgICBpb191cmluZzogYWJzdHJhY3Qgb3V0IHRhc2sgd29yayBy
dW5uaW5nCiAgICAKICAgIFByb3ZpZGUgYSBoZWxwZXIgdG8gcnVuIHRhc2tfd29yayBpbnN0
ZWFkIG9mIGNoZWNraW5nIGFuZCBydW5uaW5nCiAgICBtYW51YWxseSBpbiBhIGJ1bmNoIG9m
IGRpZmZlcmVudCBzcG90cy4gV2hpbGUgZG9pbmcgc28sIGFsc28gbW92ZSB0aGUKICAgIHRh
c2sgcnVuIHN0YXRlIHNldHRpbmcgd2hlcmUgd2UgcnVuIHRoZSB0YXNrIHdvcmsuIFRoZW4g
d2UgY2FuIG1vdmUgaXQKICAgIG91dCBvZiB0aGUgY2FsbGJhY2sgaGVscGVycy4gVGhpcyBh
bHNvIGhlbHBzIGVuc3VyZSB3ZSBvbmx5IGRvIHRoaXMgb25jZQogICAgcGVyIHRhc2tfd29y
ayBsaXN0IHJ1biwgbm90IHBlciB0YXNrX3dvcmsgaXRlbS4KICAgIAogICAgU3VnZ2VzdGVk
LWJ5OiBPbGVnIE5lc3Rlcm92IDxvbGVnQHJlZGhhdC5jb20+CiAgICBTaWduZWQtb2ZmLWJ5
OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CgpkaWZmIC0tZ2l0IGEvZnMvaW9fdXJp
bmcuYyBiL2ZzL2lvX3VyaW5nLmMKaW5kZXggNGUwOWFmMWQ1ZDIyLi45MmJiYmNmZjc3Nzcg
MTAwNjQ0Ci0tLSBhL2ZzL2lvX3VyaW5nLmMKKysrIGIvZnMvaW9fdXJpbmcuYwpAQCAtMTY5
Miw2ICsxNjkyLDE3IEBAIHN0YXRpYyBpbnQgaW9fcHV0X2tidWYoc3RydWN0IGlvX2tpb2Ni
ICpyZXEpCiAJcmV0dXJuIGNmbGFnczsKIH0KIAorc3RhdGljIGlubGluZSBib29sIGlvX3J1
bl90YXNrX3dvcmsodm9pZCkKK3sKKwlpZiAoY3VycmVudC0+dGFza193b3JrcykgeworCQlf
X3NldF9jdXJyZW50X3N0YXRlKFRBU0tfUlVOTklORyk7CisJCXRhc2tfd29ya19ydW4oKTsK
KwkJcmV0dXJuIHRydWU7CisJfQorCisJcmV0dXJuIGZhbHNlOworfQorCiBzdGF0aWMgdm9p
ZCBpb19pb3BvbGxfcXVldWUoc3RydWN0IGxpc3RfaGVhZCAqYWdhaW4pCiB7CiAJc3RydWN0
IGlvX2tpb2NiICpyZXE7CkBAIC0xODgxLDYgKzE4OTIsNyBAQCBzdGF0aWMgaW50IGlvX2lv
cG9sbF9jaGVjayhzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCwgdW5zaWduZWQgKm5yX2V2ZW50
cywKIAkJICovCiAJCWlmICghKCsraXRlcnMgJiA3KSkgewogCQkJbXV0ZXhfdW5sb2NrKCZj
dHgtPnVyaW5nX2xvY2spOworCQkJaW9fcnVuX3Rhc2tfd29yaygpOwogCQkJbXV0ZXhfbG9j
aygmY3R4LT51cmluZ19sb2NrKTsKIAkJfQogCkBAIC00NDIxLDcgKzQ0MzMsNiBAQCBzdGF0
aWMgdm9pZCBpb19hc3luY190YXNrX2Z1bmMoc3RydWN0IGNhbGxiYWNrX2hlYWQgKmNiKQog
CQlyZXR1cm47CiAJfQogCi0JX19zZXRfY3VycmVudF9zdGF0ZShUQVNLX1JVTk5JTkcpOwog
CWlmIChpb19zcV90aHJlYWRfYWNxdWlyZV9tbShjdHgsIHJlcSkpIHsKIAkJaW9fY3FyaW5n
X2FkZF9ldmVudChyZXEsIC1FRkFVTFQpOwogCQlnb3RvIGVuZF9yZXE7CkBAIC02MTUzLDgg
KzYxNjQsNyBAQCBzdGF0aWMgaW50IGlvX3NxX3RocmVhZCh2b2lkICpkYXRhKQogCQkJaWYg
KCFsaXN0X2VtcHR5KCZjdHgtPnBvbGxfbGlzdCkgfHwgbmVlZF9yZXNjaGVkKCkgfHwKIAkJ
CSAgICAoIXRpbWVfYWZ0ZXIoamlmZmllcywgdGltZW91dCkgJiYgcmV0ICE9IC1FQlVTWSAm
JgogCQkJICAgICFwZXJjcHVfcmVmX2lzX2R5aW5nKCZjdHgtPnJlZnMpKSkgewotCQkJCWlm
IChjdXJyZW50LT50YXNrX3dvcmtzKQotCQkJCQl0YXNrX3dvcmtfcnVuKCk7CisJCQkJaW9f
cnVuX3Rhc2tfd29yaygpOwogCQkJCWNvbmRfcmVzY2hlZCgpOwogCQkJCWNvbnRpbnVlOwog
CQkJfQpAQCAtNjE4Niw4ICs2MTk2LDcgQEAgc3RhdGljIGludCBpb19zcV90aHJlYWQodm9p
ZCAqZGF0YSkKIAkJCQkJZmluaXNoX3dhaXQoJmN0eC0+c3FvX3dhaXQsICZ3YWl0KTsKIAkJ
CQkJYnJlYWs7CiAJCQkJfQotCQkJCWlmIChjdXJyZW50LT50YXNrX3dvcmtzKSB7Ci0JCQkJ
CXRhc2tfd29ya19ydW4oKTsKKwkJCQlpZiAoaW9fcnVuX3Rhc2tfd29yaygpKSB7CiAJCQkJ
CWZpbmlzaF93YWl0KCZjdHgtPnNxb193YWl0LCAmd2FpdCk7CiAJCQkJCWNvbnRpbnVlOwog
CQkJCX0KQEAgLTYyMTEsOCArNjIyMCw3IEBAIHN0YXRpYyBpbnQgaW9fc3FfdGhyZWFkKHZv
aWQgKmRhdGEpCiAJCXRpbWVvdXQgPSBqaWZmaWVzICsgY3R4LT5zcV90aHJlYWRfaWRsZTsK
IAl9CiAKLQlpZiAoY3VycmVudC0+dGFza193b3JrcykKLQkJdGFza193b3JrX3J1bigpOwor
CWlvX3J1bl90YXNrX3dvcmsoKTsKIAogCXNldF9mcyhvbGRfZnMpOwogCWlvX3NxX3RocmVh
ZF9kcm9wX21tKGN0eCk7CkBAIC02Mjc4LDkgKzYyODYsOCBAQCBzdGF0aWMgaW50IGlvX2Nx
cmluZ193YWl0KHN0cnVjdCBpb19yaW5nX2N0eCAqY3R4LCBpbnQgbWluX2V2ZW50cywKIAlk
byB7CiAJCWlmIChpb19jcXJpbmdfZXZlbnRzKGN0eCwgZmFsc2UpID49IG1pbl9ldmVudHMp
CiAJCQlyZXR1cm4gMDsKLQkJaWYgKCFjdXJyZW50LT50YXNrX3dvcmtzKQorCQlpZiAoIWlv
X3J1bl90YXNrX3dvcmsoKSkKIAkJCWJyZWFrOwotCQl0YXNrX3dvcmtfcnVuKCk7CiAJfSB3
aGlsZSAoMSk7CiAKIAlpZiAoc2lnKSB7CkBAIC02MzAyLDggKzYzMDksOCBAQCBzdGF0aWMg
aW50IGlvX2NxcmluZ193YWl0KHN0cnVjdCBpb19yaW5nX2N0eCAqY3R4LCBpbnQgbWluX2V2
ZW50cywKIAkJcHJlcGFyZV90b193YWl0X2V4Y2x1c2l2ZSgmY3R4LT53YWl0LCAmaW93cS53
cSwKIAkJCQkJCVRBU0tfSU5URVJSVVBUSUJMRSk7CiAJCS8qIG1ha2Ugc3VyZSB3ZSBydW4g
dGFza193b3JrIGJlZm9yZSBjaGVja2luZyBmb3Igc2lnbmFscyAqLwotCQlpZiAoY3VycmVu
dC0+dGFza193b3JrcykKLQkJCXRhc2tfd29ya19ydW4oKTsKKwkJaWYgKGlvX3J1bl90YXNr
X3dvcmsoKSkKKwkJCWNvbnRpbnVlOwogCQlpZiAoc2lnbmFsX3BlbmRpbmcoY3VycmVudCkp
IHsKIAkJCWlmIChjdXJyZW50LT5qb2JjdGwgJiBKT0JDVExfVEFTS19XT1JLKSB7CiAJCQkJ
c3Bpbl9sb2NrX2lycSgmY3VycmVudC0+c2lnaGFuZC0+c2lnbG9jayk7CkBAIC03NjkxLDgg
Kzc2OTgsNyBAQCBTWVNDQUxMX0RFRklORTYoaW9fdXJpbmdfZW50ZXIsIHVuc2lnbmVkIGlu
dCwgZmQsIHUzMiwgdG9fc3VibWl0LAogCWludCBzdWJtaXR0ZWQgPSAwOwogCXN0cnVjdCBm
ZCBmOwogCi0JaWYgKGN1cnJlbnQtPnRhc2tfd29ya3MpCi0JCXRhc2tfd29ya19ydW4oKTsK
Kwlpb19ydW5fdGFza193b3JrKCk7CiAKIAlpZiAoZmxhZ3MgJiB+KElPUklOR19FTlRFUl9H
RVRFVkVOVFMgfCBJT1JJTkdfRU5URVJfU1FfV0FLRVVQKSkKIAkJcmV0dXJuIC1FSU5WQUw7
Cg==
--------------DF2E8DFEF87384978C589E37
Content-Type: text/plain; charset=UTF-8;
 name="5.8-patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="5.8-patch"

Y29tbWl0IDRjNmUyNzdjNGNjNGE2YjNiMmI5YzY2YTdiMDE0Nzg3YWU3NTdjYzEKQXV0aG9y
OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRhdGU6ICAgV2VkIEp1bCAxIDExOjI5
OjEwIDIwMjAgLTA2MDAKCiAgICBpb191cmluZzogYWJzdHJhY3Qgb3V0IHRhc2sgd29yayBy
dW5uaW5nCiAgICAKICAgIFByb3ZpZGUgYSBoZWxwZXIgdG8gcnVuIHRhc2tfd29yayBpbnN0
ZWFkIG9mIGNoZWNraW5nIGFuZCBydW5uaW5nCiAgICBtYW51YWxseSBpbiBhIGJ1bmNoIG9m
IGRpZmZlcmVudCBzcG90cy4gV2hpbGUgZG9pbmcgc28sIGFsc28gbW92ZSB0aGUKICAgIHRh
c2sgcnVuIHN0YXRlIHNldHRpbmcgd2hlcmUgd2UgcnVuIHRoZSB0YXNrIHdvcmsuIFRoZW4g
d2UgY2FuIG1vdmUgaXQKICAgIG91dCBvZiB0aGUgY2FsbGJhY2sgaGVscGVycy4gVGhpcyBh
bHNvIGhlbHBzIGVuc3VyZSB3ZSBvbmx5IGRvIHRoaXMgb25jZQogICAgcGVyIHRhc2tfd29y
ayBsaXN0IHJ1biwgbm90IHBlciB0YXNrX3dvcmsgaXRlbS4KICAgIAogICAgU3VnZ2VzdGVk
LWJ5OiBPbGVnIE5lc3Rlcm92IDxvbGVnQHJlZGhhdC5jb20+CiAgICBTaWduZWQtb2ZmLWJ5
OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CgpkaWZmIC0tZ2l0IGEvZnMvaW9fdXJp
bmcuYyBiL2ZzL2lvX3VyaW5nLmMKaW5kZXggNDkzZTUwNDdlNjdjLi45NWJhY2FiMDQ3ZGQg
MTAwNjQ0Ci0tLSBhL2ZzL2lvX3VyaW5nLmMKKysrIGIvZnMvaW9fdXJpbmcuYwpAQCAtMTc0
Nyw2ICsxNzQ3LDE3IEBAIHN0YXRpYyBpbnQgaW9fcHV0X2tidWYoc3RydWN0IGlvX2tpb2Ni
ICpyZXEpCiAJcmV0dXJuIGNmbGFnczsKIH0KIAorc3RhdGljIGlubGluZSBib29sIGlvX3J1
bl90YXNrX3dvcmsodm9pZCkKK3sKKwlpZiAoY3VycmVudC0+dGFza193b3JrcykgeworCQlf
X3NldF9jdXJyZW50X3N0YXRlKFRBU0tfUlVOTklORyk7CisJCXRhc2tfd29ya19ydW4oKTsK
KwkJcmV0dXJuIHRydWU7CisJfQorCisJcmV0dXJuIGZhbHNlOworfQorCiBzdGF0aWMgdm9p
ZCBpb19pb3BvbGxfcXVldWUoc3RydWN0IGxpc3RfaGVhZCAqYWdhaW4pCiB7CiAJc3RydWN0
IGlvX2tpb2NiICpyZXE7CkBAIC0xOTM2LDYgKzE5NDcsNyBAQCBzdGF0aWMgaW50IGlvX2lv
cG9sbF9jaGVjayhzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCwgdW5zaWduZWQgKm5yX2V2ZW50
cywKIAkJICovCiAJCWlmICghKCsraXRlcnMgJiA3KSkgewogCQkJbXV0ZXhfdW5sb2NrKCZj
dHgtPnVyaW5nX2xvY2spOworCQkJaW9fcnVuX3Rhc2tfd29yaygpOwogCQkJbXV0ZXhfbG9j
aygmY3R4LT51cmluZ19sb2NrKTsKIAkJfQogCkBAIC00MzU2LDcgKzQzNjgsNiBAQCBzdGF0
aWMgdm9pZCBpb19hc3luY190YXNrX2Z1bmMoc3RydWN0IGNhbGxiYWNrX2hlYWQgKmNiKQog
CWtmcmVlKGFwb2xsKTsKIAogCWlmICghY2FuY2VsZWQpIHsKLQkJX19zZXRfY3VycmVudF9z
dGF0ZShUQVNLX1JVTk5JTkcpOwogCQlpZiAoaW9fc3FfdGhyZWFkX2FjcXVpcmVfbW0oY3R4
LCByZXEpKSB7CiAJCQlpb19jcXJpbmdfYWRkX2V2ZW50KHJlcSwgLUVGQVVMVCk7CiAJCQln
b3RvIGVuZF9yZXE7CkBAIC02MDgyLDggKzYwOTMsNyBAQCBzdGF0aWMgaW50IGlvX3NxX3Ro
cmVhZCh2b2lkICpkYXRhKQogCQkJaWYgKCFsaXN0X2VtcHR5KCZjdHgtPnBvbGxfbGlzdCkg
fHwgbmVlZF9yZXNjaGVkKCkgfHwKIAkJCSAgICAoIXRpbWVfYWZ0ZXIoamlmZmllcywgdGlt
ZW91dCkgJiYgcmV0ICE9IC1FQlVTWSAmJgogCQkJICAgICFwZXJjcHVfcmVmX2lzX2R5aW5n
KCZjdHgtPnJlZnMpKSkgewotCQkJCWlmIChjdXJyZW50LT50YXNrX3dvcmtzKQotCQkJCQl0
YXNrX3dvcmtfcnVuKCk7CisJCQkJaW9fcnVuX3Rhc2tfd29yaygpOwogCQkJCWNvbmRfcmVz
Y2hlZCgpOwogCQkJCWNvbnRpbnVlOwogCQkJfQpAQCAtNjExNSw4ICs2MTI1LDcgQEAgc3Rh
dGljIGludCBpb19zcV90aHJlYWQodm9pZCAqZGF0YSkKIAkJCQkJZmluaXNoX3dhaXQoJmN0
eC0+c3FvX3dhaXQsICZ3YWl0KTsKIAkJCQkJYnJlYWs7CiAJCQkJfQotCQkJCWlmIChjdXJy
ZW50LT50YXNrX3dvcmtzKSB7Ci0JCQkJCXRhc2tfd29ya19ydW4oKTsKKwkJCQlpZiAoaW9f
cnVuX3Rhc2tfd29yaygpKSB7CiAJCQkJCWZpbmlzaF93YWl0KCZjdHgtPnNxb193YWl0LCAm
d2FpdCk7CiAJCQkJCWNvbnRpbnVlOwogCQkJCX0KQEAgLTYxNDUsOCArNjE1NCw3IEBAIHN0
YXRpYyBpbnQgaW9fc3FfdGhyZWFkKHZvaWQgKmRhdGEpCiAJCXRpbWVvdXQgPSBqaWZmaWVz
ICsgY3R4LT5zcV90aHJlYWRfaWRsZTsKIAl9CiAKLQlpZiAoY3VycmVudC0+dGFza193b3Jr
cykKLQkJdGFza193b3JrX3J1bigpOworCWlvX3J1bl90YXNrX3dvcmsoKTsKIAogCWlvX3Nx
X3RocmVhZF9kcm9wX21tKGN0eCk7CiAJcmV2ZXJ0X2NyZWRzKG9sZF9jcmVkKTsKQEAgLTYy
MTEsOSArNjIxOSw4IEBAIHN0YXRpYyBpbnQgaW9fY3FyaW5nX3dhaXQoc3RydWN0IGlvX3Jp
bmdfY3R4ICpjdHgsIGludCBtaW5fZXZlbnRzLAogCWRvIHsKIAkJaWYgKGlvX2NxcmluZ19l
dmVudHMoY3R4LCBmYWxzZSkgPj0gbWluX2V2ZW50cykKIAkJCXJldHVybiAwOwotCQlpZiAo
IWN1cnJlbnQtPnRhc2tfd29ya3MpCisJCWlmICghaW9fcnVuX3Rhc2tfd29yaygpKQogCQkJ
YnJlYWs7Ci0JCXRhc2tfd29ya19ydW4oKTsKIAl9IHdoaWxlICgxKTsKIAogCWlmIChzaWcp
IHsKQEAgLTYyMzUsOCArNjI0Miw4IEBAIHN0YXRpYyBpbnQgaW9fY3FyaW5nX3dhaXQoc3Ry
dWN0IGlvX3JpbmdfY3R4ICpjdHgsIGludCBtaW5fZXZlbnRzLAogCQlwcmVwYXJlX3RvX3dh
aXRfZXhjbHVzaXZlKCZjdHgtPndhaXQsICZpb3dxLndxLAogCQkJCQkJVEFTS19JTlRFUlJV
UFRJQkxFKTsKIAkJLyogbWFrZSBzdXJlIHdlIHJ1biB0YXNrX3dvcmsgYmVmb3JlIGNoZWNr
aW5nIGZvciBzaWduYWxzICovCi0JCWlmIChjdXJyZW50LT50YXNrX3dvcmtzKQotCQkJdGFz
a193b3JrX3J1bigpOworCQlpZiAoaW9fcnVuX3Rhc2tfd29yaygpKQorCQkJY29udGludWU7
CiAJCWlmIChzaWduYWxfcGVuZGluZyhjdXJyZW50KSkgewogCQkJaWYgKGN1cnJlbnQtPmpv
YmN0bCAmIEpPQkNUTF9UQVNLX1dPUkspIHsKIAkJCQlzcGluX2xvY2tfaXJxKCZjdXJyZW50
LT5zaWdoYW5kLT5zaWdsb2NrKTsKQEAgLTc2NTUsOCArNzY2Miw3IEBAIFNZU0NBTExfREVG
SU5FNihpb191cmluZ19lbnRlciwgdW5zaWduZWQgaW50LCBmZCwgdTMyLCB0b19zdWJtaXQs
CiAJaW50IHN1Ym1pdHRlZCA9IDA7CiAJc3RydWN0IGZkIGY7CiAKLQlpZiAoY3VycmVudC0+
dGFza193b3JrcykKLQkJdGFza193b3JrX3J1bigpOworCWlvX3J1bl90YXNrX3dvcmsoKTsK
IAogCWlmIChmbGFncyAmIH4oSU9SSU5HX0VOVEVSX0dFVEVWRU5UUyB8IElPUklOR19FTlRF
Ul9TUV9XQUtFVVApKQogCQlyZXR1cm4gLUVJTlZBTDsK
--------------DF2E8DFEF87384978C589E37--
