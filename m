Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63DD66AC96
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 17:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjANQVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 11:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjANQVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 11:21:42 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED80A93EF
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 08:21:38 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id b9-20020a17090a7ac900b00226ef160dcaso25515302pjl.2
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 08:21:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:references:cc:to:from:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0hx1Ensn0e5ObKS1ZkT8R/gM3u0zWzRUf6ktJWOu3EM=;
        b=JKsxVhTzuBbgGxzd2kEVXQ60cUc0rJkFJ8xiV46gBjb+VyEQBf8emHtAc9KjOu1NUS
         4/d+z8SztYI7BvLwG6j8yjGlvnIrcLAdXhQLbKmLqgJXE6/BNEQ11f8LyZ37OsF6rm4m
         dwRKweKChgH8GhrJcwn8kGgwABIXKI4hcfE54faKW1wAZiVdlMOQv+pn2b5olyo87o4w
         BsESqoXpOOSiBWcXvDVSne5oBDVEPoKB5+LxGoGBIDAbJoLv6Z5l9PqeFHmkM0GHM2PT
         1SZCOsT59uE2OsQoZnvSDN8gu6GuLOY6kz6aLJGeNiatkBt+CtXPhqMsXENte/FmS96v
         S5Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:cc:to:from:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0hx1Ensn0e5ObKS1ZkT8R/gM3u0zWzRUf6ktJWOu3EM=;
        b=o8J1VG9GqSrmGd4zNVCDNIJlGM9/zbw+bZJXZc6bw/Etw9288oA6OhAcfeBYGuG3V7
         DcEzaWDOxUvJM5W4Jwx72slsSt8PpAP46LgT0v/PrbWEktmqTYS/NBcmIZJGQwOz22i6
         wS7YnYQVZbSYpg6P/UdVMj2XxgY/IGZXeqcrInFc3FEJC22pN4csSBeU3dYuvuiMnGTp
         B/A7h2qo0ktr7GBlzubK9CpA+XY1utLEIwJ1JCVtulXYkvU4roIU1nBMuTxMWafCCP8h
         8cdCV6ymWZHTWWPwJZZq3AoG7IKK9+MsIYcuL2FukiGRTm7uYru+YCpUMUkoq3aAWkuW
         w0ZA==
X-Gm-Message-State: AFqh2kpt2ccmkeEpr4LqMlmO+D5JzB5CUy1oboV9+Q2F1YQy3dAa4e+c
        VqYEq2+Rk53p3iWXqLE3M7Okjg==
X-Google-Smtp-Source: AMrXdXuLQ9yF/Z4zW7FqLMyoGxZ+8qRgD8JJA9DjxAHcPoBtyVlan/Ciuv3UvfXhuMEmckT09YUFdA==
X-Received: by 2002:a05:6a20:671b:b0:b8:5c45:a6dd with SMTP id q27-20020a056a20671b00b000b85c45a6ddmr5597pzh.3.1673713298314;
        Sat, 14 Jan 2023 08:21:38 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a7-20020a1709027e4700b00192740bb02dsm14837276pln.45.2023.01.14.08.21.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Jan 2023 08:21:37 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------Oh9gvl41Uh5yVLG0kbu16Cld"
Message-ID: <530fedb3-e8f4-46a0-faab-8435d313ad87@kernel.dk>
Date:   Sat, 14 Jan 2023 09:21:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: FAILED: patch "[PATCH] io_uring: lock overflowing for IOPOLL"
 failed to apply to 5.15-stable tree
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     gregkh@linuxfoundation.org, asml.silence@gmail.com
Cc:     stable@vger.kernel.org
References: <1673689917176116@kroah.com>
 <f7ffd01f-71f2-6bfc-daf7-e149be9bf836@kernel.dk>
In-Reply-To: <f7ffd01f-71f2-6bfc-daf7-e149be9bf836@kernel.dk>
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
--------------Oh9gvl41Uh5yVLG0kbu16Cld
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/14/23 9:15 AM, Jens Axboe wrote:
> On 1/14/23 2:51 AM, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 5.15-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
> 
> This has to be done a bit differently, but this one should work. I tested
> it on 5.10-stable, but should apply to 5.15-stable as well as they are
> the same base now.

Oops, missed accounting for overflow. Please use this one instead! Sorry
about that.

-- 
Jens Axboe


--------------Oh9gvl41Uh5yVLG0kbu16Cld
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-lock-overflowing-for-IOPOLL.patch"
Content-Disposition: attachment;
 filename="0001-io_uring-lock-overflowing-for-IOPOLL.patch"
Content-Transfer-Encoding: base64

RnJvbSA5MjllNWM1NGZmMmFkMTE2ZTlkY2VlOTY3ZmM1ZGYxZGJiNmIxZDkwIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBQYXZlbCBCZWd1bmtvdiA8YXNtbC5zaWxlbmNlQGdt
YWlsLmNvbT4KRGF0ZTogU2F0LCAxNCBKYW4gMjAyMyAwOToxNDowMyAtMDcwMApTdWJqZWN0
OiBbUEFUQ0hdIGlvX3VyaW5nOiBsb2NrIG92ZXJmbG93aW5nIGZvciBJT1BPTEwKTUlNRS1W
ZXJzaW9uOiAxLjAKQ29udGVudC1UeXBlOiB0ZXh0L3BsYWluOyBjaGFyc2V0PVVURi04CkNv
bnRlbnQtVHJhbnNmZXItRW5jb2Rpbmc6IDhiaXQKCmNvbW1pdCA1NDRkMTYzZDY1OWQ0NWEy
MDZkODkyOTM3MGQ1YTI5ODRlNTQ2Y2I3IHVwc3RyZWFtLgoKc3l6Ym90IHJlcG9ydHMgYW4g
aXNzdWUgd2l0aCBvdmVyZmxvdyBmaWxsaW5nIGZvciBJT1BPTEw6CgpXQVJOSU5HOiBDUFU6
IDAgUElEOiAyOCBhdCBpb191cmluZy9pb191cmluZy5jOjczNCBpb19jcXJpbmdfZXZlbnRf
b3ZlcmZsb3crMHgxYzAvMHgyMzAgaW9fdXJpbmcvaW9fdXJpbmcuYzo3MzQKQ1BVOiAwIFBJ
RDogMjggQ29tbToga3dvcmtlci91NDoxIE5vdCB0YWludGVkIDYuMi4wLXJjMy1zeXprYWxs
ZXItMTYzNjktZzM1OGExNjFhNmE5ZSAjMApXb3JrcXVldWU6IGV2ZW50c191bmJvdW5kIGlv
X3JpbmdfZXhpdF93b3JrCkNhbGwgdHJhY2U6CsKgaW9fY3FyaW5nX2V2ZW50X292ZXJmbG93
KzB4MWMwLzB4MjMwIGlvX3VyaW5nL2lvX3VyaW5nLmM6NzM0CsKgaW9fcmVxX2NxZV9vdmVy
ZmxvdysweDVjLzB4NzAgaW9fdXJpbmcvaW9fdXJpbmcuYzo3NzMKwqBpb19maWxsX2NxZV9y
ZXEgaW9fdXJpbmcvaW9fdXJpbmcuaDoxNjggW2lubGluZV0KwqBpb19kb19pb3BvbGwrMHg0
NzQvMHg2MmMgaW9fdXJpbmcvcncuYzoxMDY1CsKgaW9faW9wb2xsX3RyeV9yZWFwX2V2ZW50
cysweDZjLzB4MTA4IGlvX3VyaW5nL2lvX3VyaW5nLmM6MTUxMwrCoGlvX3VyaW5nX3RyeV9j
YW5jZWxfcmVxdWVzdHMrMHgxM2MvMHgyNTggaW9fdXJpbmcvaW9fdXJpbmcuYzozMDU2CsKg
aW9fcmluZ19leGl0X3dvcmsrMHhlYy8weDM5MCBpb191cmluZy9pb191cmluZy5jOjI4NjkK
wqBwcm9jZXNzX29uZV93b3JrKzB4MmQ4LzB4NTA0IGtlcm5lbC93b3JrcXVldWUuYzoyMjg5
CsKgd29ya2VyX3RocmVhZCsweDM0MC8weDYxMCBrZXJuZWwvd29ya3F1ZXVlLmM6MjQzNgrC
oGt0aHJlYWQrMHgxMmMvMHgxNTgga2VybmVsL2t0aHJlYWQuYzozNzYKwqByZXRfZnJvbV9m
b3JrKzB4MTAvMHgyMCBhcmNoL2FybTY0L2tlcm5lbC9lbnRyeS5TOjg2MwoKVGhlcmUgaXMg
bm8gcmVhbCBwcm9ibGVtIGZvciBub3JtYWwgSU9QT0xMIGFzIGZsdXNoIGlzIGFsc28gY2Fs
bGVkIHdpdGgKdXJpbmdfbG9jayB0YWtlbiwgYnV0IGl0J3MgZ2V0dGluZyBtb3JlIGNvbXBs
aWNhdGVkIGZvciBJT1BPTEx8U1FQT0xMLApmb3Igd2hpY2ggX19pb19jcXJpbmdfb3ZlcmZs
b3dfZmx1c2goKSBoYXBwZW5zIGZyb20gdGhlIENRIHdhaXRpbmcgcGF0aC4KClJlcG9ydGVk
LWFuZC10ZXN0ZWQtYnk6IHN5emJvdCs2ODA1MDg3NDUyZDcyOTI5NDA0ZUBzeXprYWxsZXIu
YXBwc3BvdG1haWwuY29tCkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnICMgNS4xMCsKU2ln
bmVkLW9mZi1ieTogUGF2ZWwgQmVndW5rb3YgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+ClNp
Z25lZC1vZmYtYnk6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4KLS0tCiBpb191cmlu
Zy9pb191cmluZy5jIHwgMTggKysrKysrKysrKysrKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwg
MTYgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9pb191cmlu
Zy9pb191cmluZy5jIGIvaW9fdXJpbmcvaW9fdXJpbmcuYwppbmRleCAwYzRkMTZhZmI5ZWYu
LmMzODM4YTJjNWM2ZiAxMDA2NDQKLS0tIGEvaW9fdXJpbmcvaW9fdXJpbmcuYworKysgYi9p
b191cmluZy9pb191cmluZy5jCkBAIC0yNDc4LDEyICsyNDc4LDI2IEBAIHN0YXRpYyB2b2lk
IGlvX2lvcG9sbF9jb21wbGV0ZShzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCwgdW5zaWduZWQg
aW50ICpucl9ldmVudHMsCiAKIAlpb19pbml0X3JlcV9iYXRjaCgmcmIpOwogCXdoaWxlICgh
bGlzdF9lbXB0eShkb25lKSkgeworCQlzdHJ1Y3QgaW9fdXJpbmdfY3FlICpjcWU7CisJCXVu
c2lnbmVkIGNmbGFnczsKKwogCQlyZXEgPSBsaXN0X2ZpcnN0X2VudHJ5KGRvbmUsIHN0cnVj
dCBpb19raW9jYiwgaW5mbGlnaHRfZW50cnkpOwogCQlsaXN0X2RlbCgmcmVxLT5pbmZsaWdo
dF9lbnRyeSk7Ci0KLQkJaW9fZmlsbF9jcWVfcmVxKHJlcSwgcmVxLT5yZXN1bHQsIGlvX3B1
dF9yd19rYnVmKHJlcSkpOworCQljZmxhZ3MgPSBpb19wdXRfcndfa2J1ZihyZXEpOwogCQko
Km5yX2V2ZW50cykrKzsKIAorCQljcWUgPSBpb19nZXRfY3FlKGN0eCk7CisJCWlmICh1bmxp
a2VseSghY3FlKSkgeworCQkJc3Bpbl9sb2NrKCZjdHgtPmNvbXBsZXRpb25fbG9jayk7CisJ
CQlpb19jcXJpbmdfZXZlbnRfb3ZlcmZsb3coY3R4LCByZXEtPnVzZXJfZGF0YSwKKwkJCQkJ
CQlyZXEtPnJlc3VsdCwgY2ZsYWdzKTsKKwkJCXNwaW5fdW5sb2NrKCZjdHgtPmNvbXBsZXRp
b25fbG9jayk7CisJCQljb250aW51ZTsKKwkJfQorCQlXUklURV9PTkNFKGNxZS0+dXNlcl9k
YXRhLCByZXEtPnVzZXJfZGF0YSk7CisJCVdSSVRFX09OQ0UoY3FlLT5yZXMsIHJlcS0+cmVz
dWx0KTsKKwkJV1JJVEVfT05DRShjcWUtPmZsYWdzLCBjZmxhZ3MpOworCiAJCWlmIChyZXFf
cmVmX3B1dF9hbmRfdGVzdChyZXEpKQogCQkJaW9fcmVxX2ZyZWVfYmF0Y2goJnJiLCByZXEs
ICZjdHgtPnN1Ym1pdF9zdGF0ZSk7CiAJfQotLSAKMi4zOS4wCgo=

--------------Oh9gvl41Uh5yVLG0kbu16Cld--
