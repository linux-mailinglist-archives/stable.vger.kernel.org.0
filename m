Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0DF46C12BF
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 14:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbjCTNIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 09:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbjCTNIG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 09:08:06 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C361B2C6
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 06:08:00 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id o11so12368193ple.1
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 06:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679317680;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tEGbMEjNaiafnvi7BsWtjkN3AFgXbbhDQrJRdS4zotg=;
        b=EYR5Wzz5vcLlAkzliYy3oEe06uplyrPxT2w7fKO0RQfEdYT+RX7uvk1Bnvb+Pmjc1j
         h5bxbLCx6iok+NgRA8/+5LR8V3+H81svqgMbkRA0kpgLi/r1+i8QEXF9GHmTr09qBfh/
         nf9uWqiFm2WKgIfYdMKw1/nZdAOZWGT7Wm+GuPbKzIYt/N3cffITDsOK/tZqGdXw0zJx
         kJZB9jG+aduWa8edvQ3s0CqrvY4CKIJ3I5wJIjmE9vhOpA8aUhQBY6ZGN1j+s1bEeqfW
         BI0U9Lk6xx0xJG0fPjJu/36UEXZIXLBxGYtaJR04JASuISPBJabHHalG4FZACQISBCN2
         /OsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679317680;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tEGbMEjNaiafnvi7BsWtjkN3AFgXbbhDQrJRdS4zotg=;
        b=4JR+Tw6LmyjJpPVszVy85wIyAhZ5jrs7TOGa2p63Z2I0yarMAejAAIFzLnkhDuJsKP
         c9kM67I+/+z32UrDTO9KL/zUu5Xf6vzn0RvduvS/lhdaFRpmjY8/GjihhmuOWKLSGMgT
         LZRvD4766Y68g9moE2ihesxDUAAtGKpcpAG4vX2GTmUxdOb+0WVpQGaW0maYGk3HarH0
         qmB5ifvIrNvd1WJg++Y5V/zS7aWJ1YmMhd1U3avuGl5pQEA3zcLZmOt/tBiuqPbV9uD3
         +5gLt5hyU/xqGZJThSxjUk+eZs5zLkFtLiNOeottAGWMbXfvjHT7+Gs6CsxmOUpa0utq
         ZLPg==
X-Gm-Message-State: AO0yUKXyE0Gqu574ttxXPo00Xxi6OM+pdpI/wzuhCSSl6usv3v7nz6Pg
        tYelWgzmZRUqxr242DD7zRDpKQ==
X-Google-Smtp-Source: AK7set/nKrEsr0iQOzUjjKXxf3psoY5eD+NH/fBO49a2J/SCS4pZrIfNHh/9KlM6qxlW3Jaath0xuw==
X-Received: by 2002:a17:902:c40c:b0:19a:a815:2864 with SMTP id k12-20020a170902c40c00b0019aa8152864mr17479525plk.4.1679317680151;
        Mon, 20 Mar 2023 06:08:00 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p12-20020a17090a2d8c00b0023440af7aafsm6150834pjd.9.2023.03.20.06.07.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 06:07:59 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------z0uW1iMWNh8sYGU4tpmBkQ07"
Message-ID: <8762c8d4-723d-dcdb-07ce-d90d96c4b32a@kernel.dk>
Date:   Mon, 20 Mar 2023 07:07:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: FAILED: patch "[PATCH] io_uring/msg_ring: let target know
 allocated index" failed to apply to 6.1-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, asml.silence@gmail.com
Cc:     stable@vger.kernel.org
References: <167931300423217@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <167931300423217@kroah.com>
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------z0uW1iMWNh8sYGU4tpmBkQ07
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/20/23 5:50 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 6.1-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> To reproduce the conflict and resubmit, you may use the following commands:
> 
> git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
> git checkout FETCH_HEAD
> git cherry-pick -x 5da28edd7bd5518f97175ecea77615bb729a7a28
> # <resolve conflicts, build, test, etc.>
> git commit -s
> git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167931300423217@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..

Here's a tested backport of that patch.

-- 
Jens Axboe


--------------z0uW1iMWNh8sYGU4tpmBkQ07
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-msg_ring-let-target-know-allocated-index.patch"
Content-Disposition: attachment;
 filename*0="0001-io_uring-msg_ring-let-target-know-allocated-index.patch"
Content-Transfer-Encoding: base64

RnJvbSAxYjZiNDZiMzQ0NTYxYzliNTEyN2JjYzU5YzY4YTMxMGQ2NmY0MzY4IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBQYXZlbCBCZWd1bmtvdiA8YXNtbC5zaWxlbmNlQGdt
YWlsLmNvbT4KRGF0ZTogTW9uLCAyMCBNYXIgMjAyMyAwNzowNTowMiAtMDYwMApTdWJqZWN0
OiBbUEFUQ0hdIGlvX3VyaW5nL21zZ19yaW5nOiBsZXQgdGFyZ2V0IGtub3cgYWxsb2NhdGVk
IGluZGV4Cgpjb21taXQgNWRhMjhlZGQ3YmQ1NTE4Zjk3MTc1ZWNlYTc3NjE1YmI3MjlhN2Ey
OCB1cHN0cmVhbS4KCm1zZ19yaW5nIHJlcXVlc3RzIHRyYW5zZmVycmluZyBmaWxlcyBzdXBw
b3J0IGF1dG8gaW5kZXggc2VsZWN0aW9uIHZpYQpJT1JJTkdfRklMRV9JTkRFWF9BTExPQywg
aG93ZXZlciB0aGV5IGRvbid0IHJldHVybiB0aGUgc2VsZWN0ZWQgaW5kZXgKdG8gdGhlIHRh
cmdldCByaW5nIGFuZCB0aGVyZSBpcyBubyBvdGhlciBnb29kIHdheSBmb3IgdGhlIHVzZXJz
cGFjZSB0bwprbm93IHdoZXJlIGlzIHRoZSByZWNlaWV2ZWQgZmlsZS4KClJldHVybiB0aGUg
aW5kZXggZm9yIGFsbG9jYXRlZCBzbG90cyBhbmQgMCBvdGhlcndpc2UsIHdoaWNoIGlzCmNv
bnNpc3RlbnQgd2l0aCBvdGhlciBmaXhlZCBmaWxlIGluc3RhbGxpbmcgcmVxdWVzdHMuCgpD
Yzogc3RhYmxlQHZnZXIua2VybmVsLm9yZyAjIHY2LjArCkZpeGVzOiBlNjEzMGViYThhODQ4
ICgiaW9fdXJpbmc6IGFkZCBzdXBwb3J0IGZvciBwYXNzaW5nIGZpeGVkIGZpbGUgZGVzY3Jp
cHRvcnMiKQpTaWduZWQtb2ZmLWJ5OiBQYXZlbCBCZWd1bmtvdiA8YXNtbC5zaWxlbmNlQGdt
YWlsLmNvbT4KTGluazogaHR0cHM6Ly9naXRodWIuY29tL2F4Ym9lL2xpYnVyaW5nL2lzc3Vl
cy84MDkKU2lnbmVkLW9mZi1ieTogSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPgotLS0K
IGlvX3VyaW5nL21zZ19yaW5nLmMgfCA0ICsrKy0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9pb191cmluZy9tc2dfcmlu
Zy5jIGIvaW9fdXJpbmcvbXNnX3JpbmcuYwppbmRleCA3ZDViNTQ0Y2ZjMzAuLjM1MjYzODlh
YzIxOCAxMDA2NDQKLS0tIGEvaW9fdXJpbmcvbXNnX3JpbmcuYworKysgYi9pb191cmluZy9t
c2dfcmluZy5jCkBAIC04NCw2ICs4NCw4IEBAIHN0YXRpYyBpbnQgaW9fbXNnX3NlbmRfZmQo
c3RydWN0IGlvX2tpb2NiICpyZXEsIHVuc2lnbmVkIGludCBpc3N1ZV9mbGFncykKIAlzdHJ1
Y3QgZmlsZSAqc3JjX2ZpbGU7CiAJaW50IHJldDsKIAorCWlmIChtc2ctPmxlbikKKwkJcmV0
dXJuIC1FSU5WQUw7CiAJaWYgKHRhcmdldF9jdHggPT0gY3R4KQogCQlyZXR1cm4gLUVJTlZB
TDsKIAlpZiAodGFyZ2V0X2N0eC0+ZmxhZ3MgJiBJT1JJTkdfU0VUVVBfUl9ESVNBQkxFRCkK
QEAgLTEyMCw3ICsxMjIsNyBAQCBzdGF0aWMgaW50IGlvX21zZ19zZW5kX2ZkKHN0cnVjdCBp
b19raW9jYiAqcmVxLCB1bnNpZ25lZCBpbnQgaXNzdWVfZmxhZ3MpCiAJICogY29tcGxldGVz
IHdpdGggLUVPVkVSRkxPVywgdGhlbiB0aGUgc2VuZGVyIG11c3QgZW5zdXJlIHRoYXQgYQog
CSAqIGxhdGVyIElPUklOR19PUF9NU0dfUklORyBkZWxpdmVycyB0aGUgbWVzc2FnZS4KIAkg
Ki8KLQlpZiAoIWlvX3Bvc3RfYXV4X2NxZSh0YXJnZXRfY3R4LCBtc2ctPnVzZXJfZGF0YSwg
bXNnLT5sZW4sIDAsIHRydWUpKQorCWlmICghaW9fcG9zdF9hdXhfY3FlKHRhcmdldF9jdHgs
IG1zZy0+dXNlcl9kYXRhLCByZXQsIDAsIHRydWUpKQogCQlyZXQgPSAtRU9WRVJGTE9XOwog
b3V0X3VubG9jazoKIAlpb19kb3VibGVfdW5sb2NrX2N0eChjdHgsIHRhcmdldF9jdHgsIGlz
c3VlX2ZsYWdzKTsKLS0gCjIuMzkuMgoK

--------------z0uW1iMWNh8sYGU4tpmBkQ07--
