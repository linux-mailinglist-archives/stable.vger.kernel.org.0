Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDEF66AC64
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 17:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbjANQDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 11:03:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjANQC7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 11:02:59 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059D59019
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 08:02:59 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id o7-20020a17090a0a0700b00226c9b82c3aso27222310pjo.3
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 08:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=73nWUYhZUCs6f0Hd3+mpMaayQvbFl0yNts4AtsEGgOc=;
        b=DSS6ZYBCR0yzvyZtyJQldzAMPgkWwOyVCj0o6QVqRUicwYSG7iQbYi2aPpV1VpGiWE
         zQgKe9GPvR5VdSz5cSMh9w4E7Koo0P4ztDXJUdQcaC0+reRv6EfCk4M/TIA522NZwAtr
         WTv1iDwCzgc3npztVX3FdUhPF6PNngU48em8QQb1SwJioXTqYkWbGVuUkjJ2HI+38CG0
         0yUfmY4LDySmLr27bVhm43AinmQes7Xd9ub82r6MLTwb2mlMWkSC1c3OXcP4deieJIDZ
         mn+PgFVKyqCiQtwS1Y6bcOT2vFEgwBZkd8P1FXQQ8RlbJWoVgz2PGVW+iOjVOGlKM1Xn
         DYIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=73nWUYhZUCs6f0Hd3+mpMaayQvbFl0yNts4AtsEGgOc=;
        b=XBigQDbMvBowXDIi603raUV7QtGGWCv+kEEEvxJmtObtsvR+ptXSE3yUNLndUSukIH
         N1xehR4xDtMk58rlCsBdGcbUPRQMPwfbowmvjGxfOHJnKfTAlO75ZGTF4XLT2liMWDyj
         j6VXibcjrLYMZra8OwNHeATx4dEA9zR8qIXF3q03l7FabMvBdlnHh3vKoHIi9RcgeETX
         rqBn6IFPVo2U9w4q1oxfaPVAOiqLtc6+T6uVV9wIITPij68+dHxfDDEslsiaGlnYyJNw
         sR4Zr9c7iVvlyCFybwpNnEA3iS7g5cO5PCB9vwlIL9jmTJFlsNgMXyBYQoEf2NJGT1uE
         8atQ==
X-Gm-Message-State: AFqh2kq9DtaDP8/eD7d0UREnE4UigRgFFhdXv6azFrUKSNXS0y6k3HaM
        Fs65wQ0MsMbIUrFGGD7GMua3Vg==
X-Google-Smtp-Source: AMrXdXvPRqA0R7P3Jdfw5EKMpncdjPM/aez9MOW9BZuev048mVp7dRgznwNhCHpMRFwYnoh8xzDpLg==
X-Received: by 2002:a17:902:e2ca:b0:194:4c4f:e965 with SMTP id l10-20020a170902e2ca00b001944c4fe965mr889450plc.0.1673712178494;
        Sat, 14 Jan 2023 08:02:58 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id r6-20020a63d906000000b004b3de07bfaasm1061124pgg.10.2023.01.14.08.02.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Jan 2023 08:02:57 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------XHXvKRDzyEQ2QFLNwpo1KWo0"
Message-ID: <56ae7b67-09e9-6c4d-d1ac-0c37a25df2d6@kernel.dk>
Date:   Sat, 14 Jan 2023 09:02:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: FAILED: patch "[PATCH] io_uring: lock overflowing for IOPOLL"
 failed to apply to 6.1-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, asml.silence@gmail.com
Cc:     stable@vger.kernel.org
References: <1673689911293@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1673689911293@kroah.com>
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
--------------XHXvKRDzyEQ2QFLNwpo1KWo0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/14/23 2:51 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 6.1-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's this one.

-- 
Jens Axboe


--------------XHXvKRDzyEQ2QFLNwpo1KWo0
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-lock-overflowing-for-IOPOLL.patch"
Content-Disposition: attachment;
 filename="0001-io_uring-lock-overflowing-for-IOPOLL.patch"
Content-Transfer-Encoding: base64

RnJvbSBiODAwYTA2NDc0MjFmYzRjNGFjYTUzOGE5ZjBiYzViZmNlYWVjZTY1IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBQYXZlbCBCZWd1bmtvdiA8YXNtbC5zaWxlbmNlQGdt
YWlsLmNvbT4KRGF0ZTogU2F0LCAxNCBKYW4gMjAyMyAwODo0MTozMyAtMDcwMApTdWJqZWN0
OiBbUEFUQ0ggMS8yXSBpb191cmluZzogbG9jayBvdmVyZmxvd2luZyBmb3IgSU9QT0xMCk1J
TUUtVmVyc2lvbjogMS4wCkNvbnRlbnQtVHlwZTogdGV4dC9wbGFpbjsgY2hhcnNldD1VVEYt
OApDb250ZW50LVRyYW5zZmVyLUVuY29kaW5nOiA4Yml0Cgpjb21taXQgNTQ0ZDE2M2Q2NTlk
NDVhMjA2ZDg5MjkzNzBkNWEyOTg0ZTU0NmNiNyB1cHN0cmVhbS4KCnN5emJvdCByZXBvcnRz
IGFuIGlzc3VlIHdpdGggb3ZlcmZsb3cgZmlsbGluZyBmb3IgSU9QT0xMOgoKV0FSTklORzog
Q1BVOiAwIFBJRDogMjggYXQgaW9fdXJpbmcvaW9fdXJpbmcuYzo3MzQgaW9fY3FyaW5nX2V2
ZW50X292ZXJmbG93KzB4MWMwLzB4MjMwIGlvX3VyaW5nL2lvX3VyaW5nLmM6NzM0CkNQVTog
MCBQSUQ6IDI4IENvbW06IGt3b3JrZXIvdTQ6MSBOb3QgdGFpbnRlZCA2LjIuMC1yYzMtc3l6
a2FsbGVyLTE2MzY5LWczNThhMTYxYTZhOWUgIzAKV29ya3F1ZXVlOiBldmVudHNfdW5ib3Vu
ZCBpb19yaW5nX2V4aXRfd29yawpDYWxsIHRyYWNlOgrCoGlvX2NxcmluZ19ldmVudF9vdmVy
ZmxvdysweDFjMC8weDIzMCBpb191cmluZy9pb191cmluZy5jOjczNArCoGlvX3JlcV9jcWVf
b3ZlcmZsb3crMHg1Yy8weDcwIGlvX3VyaW5nL2lvX3VyaW5nLmM6NzczCsKgaW9fZmlsbF9j
cWVfcmVxIGlvX3VyaW5nL2lvX3VyaW5nLmg6MTY4IFtpbmxpbmVdCsKgaW9fZG9faW9wb2xs
KzB4NDc0LzB4NjJjIGlvX3VyaW5nL3J3LmM6MTA2NQrCoGlvX2lvcG9sbF90cnlfcmVhcF9l
dmVudHMrMHg2Yy8weDEwOCBpb191cmluZy9pb191cmluZy5jOjE1MTMKwqBpb191cmluZ190
cnlfY2FuY2VsX3JlcXVlc3RzKzB4MTNjLzB4MjU4IGlvX3VyaW5nL2lvX3VyaW5nLmM6MzA1
NgrCoGlvX3JpbmdfZXhpdF93b3JrKzB4ZWMvMHgzOTAgaW9fdXJpbmcvaW9fdXJpbmcuYzoy
ODY5CsKgcHJvY2Vzc19vbmVfd29yaysweDJkOC8weDUwNCBrZXJuZWwvd29ya3F1ZXVlLmM6
MjI4OQrCoHdvcmtlcl90aHJlYWQrMHgzNDAvMHg2MTAga2VybmVsL3dvcmtxdWV1ZS5jOjI0
MzYKwqBrdGhyZWFkKzB4MTJjLzB4MTU4IGtlcm5lbC9rdGhyZWFkLmM6Mzc2CsKgcmV0X2Zy
b21fZm9yaysweDEwLzB4MjAgYXJjaC9hcm02NC9rZXJuZWwvZW50cnkuUzo4NjMKClRoZXJl
IGlzIG5vIHJlYWwgcHJvYmxlbSBmb3Igbm9ybWFsIElPUE9MTCBhcyBmbHVzaCBpcyBhbHNv
IGNhbGxlZCB3aXRoCnVyaW5nX2xvY2sgdGFrZW4sIGJ1dCBpdCdzIGdldHRpbmcgbW9yZSBj
b21wbGljYXRlZCBmb3IgSU9QT0xMfFNRUE9MTCwKZm9yIHdoaWNoIF9faW9fY3FyaW5nX292
ZXJmbG93X2ZsdXNoKCkgaGFwcGVucyBmcm9tIHRoZSBDUSB3YWl0aW5nIHBhdGguCgpSZXBv
cnRlZC1hbmQtdGVzdGVkLWJ5OiBzeXpib3QrNjgwNTA4NzQ1MmQ3MjkyOTQwNGVAc3l6a2Fs
bGVyLmFwcHNwb3RtYWlsLmNvbQpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZyAjIDUuMTAr
ClNpZ25lZC1vZmYtYnk6IFBhdmVsIEJlZ3Vua292IDxhc21sLnNpbGVuY2VAZ21haWwuY29t
PgpTaWduZWQtb2ZmLWJ5OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+Ci0tLQogaW9f
dXJpbmcvcncuYyB8IDYgKysrKystCiAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvaW9fdXJpbmcvcncuYyBiL2lvX3VyaW5n
L3J3LmMKaW5kZXggYmI0N2NjNGRhNzEzLi42MjIzNDcyMDk1ZDIgMTAwNjQ0Ci0tLSBhL2lv
X3VyaW5nL3J3LmMKKysrIGIvaW9fdXJpbmcvcncuYwpAQCAtMTA1NSw3ICsxMDU1LDExIEBA
IGludCBpb19kb19pb3BvbGwoc3RydWN0IGlvX3JpbmdfY3R4ICpjdHgsIGJvb2wgZm9yY2Vf
bm9uc3BpbikKIAkJCWNvbnRpbnVlOwogCiAJCXJlcS0+Y3FlLmZsYWdzID0gaW9fcHV0X2ti
dWYocmVxLCAwKTsKLQkJX19pb19maWxsX2NxZV9yZXEocmVxLT5jdHgsIHJlcSk7CisJCWlm
ICh1bmxpa2VseSghX19pb19maWxsX2NxZV9yZXEoY3R4LCByZXEpKSkgeworCQkJc3Bpbl9s
b2NrKCZjdHgtPmNvbXBsZXRpb25fbG9jayk7CisJCQlpb19yZXFfY3FlX292ZXJmbG93KHJl
cSk7CisJCQlzcGluX3VubG9jaygmY3R4LT5jb21wbGV0aW9uX2xvY2spOworCQl9CiAJfQog
CiAJaWYgKHVubGlrZWx5KCFucl9ldmVudHMpKQotLSAKMi4zOS4wCgo=

--------------XHXvKRDzyEQ2QFLNwpo1KWo0--
