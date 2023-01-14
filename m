Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B094966ACB4
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 17:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjANQsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 11:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbjANQsi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 11:48:38 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8258A77
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 08:48:36 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id 200so12039926pfx.7
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 08:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:references:cc:to:from:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wputr8zb4OltAvXO86HCxmc2WhjAA1c1GbhCyXS3+9E=;
        b=aq1htpAJ9yFJlNh9oyqlqSz9j7fmZgRufhiCFAYKwCm4VaLu7wplZi12T5/7v7uBSu
         af+ai+yQoqatV/5qw0V1MPT0AIvTpCXw9C6mcCHZyej/1NgGrxGG4PMVG6TQrb5gZjt7
         tjooNsXVqwOwrKyJrd+z3l/Vc7XCsDCIq6tDqPiC786qYRm0QF1Z0igUdXJgRJ6CpLBF
         mb/rVjufrky2RdZU1pv81eCtQ+C2c0pBdGsOnXhvNGitOWtfe6aKDe7CteTi2ES/YD8I
         sq47Xx70/A1S0sZTo6Zu5a6bSxaHsanbwtYyLbEk+Ftjxml9b0n66dCOPwxi/TsMRmT4
         wgWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:cc:to:from:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Wputr8zb4OltAvXO86HCxmc2WhjAA1c1GbhCyXS3+9E=;
        b=mhvvu8yy714XmLcregLXhjaas1cqOLQQomsi5M1vLSYM2Kz+fiCwqCCNZ3Qj84Edh9
         v7kURGhrJAJI5+GAwZrb8lWiuNQj2ScX53HcT7jcJ+62CeJcVmzjP+i+zNgTrzOsElq6
         jZSJ5F8wVMkjEBUDCRXMgp2zmOvzYjwomvipRo7zvAbmbIRiehZxMLq2NCJcCRM1LpSv
         e+lk1U9byZecCxKhtYc+EIeQbghhhOq3rtp25ve/54rJln3kUTNUwMyugBhqVjVlerMh
         WXqg4s+0P+Wj0u22w+c/AGKiXzikWfqo3MhUaJwtkiCACTiABSxYsqKgb3LlGS3NCuNS
         EaZQ==
X-Gm-Message-State: AFqh2kp/AjNIKdSRC8qtfXR3mTCQCcbmBRoUidkIUIdx4QpP+or0plXb
        sEoNX7uZ5ngOBKHVvnTEZtnOyg==
X-Google-Smtp-Source: AMrXdXszAwJqhoS9HEZnTYqRSY3MnO6UTjvuzBZIao8aBKReNfgkDaeIOdu+Fe8iIF+p5SXCuU1sxg==
X-Received: by 2002:a62:190d:0:b0:587:4621:9645 with SMTP id 13-20020a62190d000000b0058746219645mr6177396pfz.1.1673714916340;
        Sat, 14 Jan 2023 08:48:36 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x65-20020a623144000000b0058ba6f416besm2755274pfx.183.2023.01.14.08.48.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Jan 2023 08:48:35 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------xNpH0YZPtcnJkCzcfAa6rm8K"
Message-ID: <3a32e477-4170-07e7-94fc-384d8e86a7d7@kernel.dk>
Date:   Sat, 14 Jan 2023 09:48:34 -0700
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
 <530fedb3-e8f4-46a0-faab-8435d313ad87@kernel.dk>
In-Reply-To: <530fedb3-e8f4-46a0-faab-8435d313ad87@kernel.dk>
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
--------------xNpH0YZPtcnJkCzcfAa6rm8K
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/14/23 9:21?AM, Jens Axboe wrote:
> On 1/14/23 9:15?AM, Jens Axboe wrote:
>> On 1/14/23 2:51?AM, gregkh@linuxfoundation.org wrote:
>>>
>>> The patch below does not apply to the 5.15-stable tree.
>>> If someone wants it applied there, or to any other stable or longterm
>>> tree, then please email the backport, including the original git commit
>>> id to <stable@vger.kernel.org>.
>>
>> This has to be done a bit differently, but this one should work. I tested
>> it on 5.10-stable, but should apply to 5.15-stable as well as they are
>> the same base now.
> 
> Oops, missed accounting for overflow. Please use this one instead! Sorry
> about that.

Not batting 1000 on this one today. Wrote a test case for this
specifically now and verified it, this one is good. For real.

-- 
Jens Axboe

--------------xNpH0YZPtcnJkCzcfAa6rm8K
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-lock-overflowing-for-IOPOLL.patch"
Content-Disposition: attachment;
 filename="0001-io_uring-lock-overflowing-for-IOPOLL.patch"
Content-Transfer-Encoding: base64

RnJvbSAzMWY4OTczOTZiYmJkMzcwMTAyNjAxMTkyOTNlODQwMDc3MzZkYmM3IE1vbiBTZXAg
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
LmNiODNiYTUwYjAxNyAxMDA2NDQKLS0tIGEvaW9fdXJpbmcvaW9fdXJpbmcuYworKysgYi9p
b191cmluZy9pb191cmluZy5jCkBAIC0yNDc4LDEyICsyNDc4LDI2IEBAIHN0YXRpYyB2b2lk
IGlvX2lvcG9sbF9jb21wbGV0ZShzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCwgdW5zaWduZWQg
aW50ICpucl9ldmVudHMsCiAKIAlpb19pbml0X3JlcV9iYXRjaCgmcmIpOwogCXdoaWxlICgh
bGlzdF9lbXB0eShkb25lKSkgeworCQlzdHJ1Y3QgaW9fdXJpbmdfY3FlICpjcWU7CisJCXVu
c2lnbmVkIGNmbGFnczsKKwogCQlyZXEgPSBsaXN0X2ZpcnN0X2VudHJ5KGRvbmUsIHN0cnVj
dCBpb19raW9jYiwgaW5mbGlnaHRfZW50cnkpOwogCQlsaXN0X2RlbCgmcmVxLT5pbmZsaWdo
dF9lbnRyeSk7Ci0KLQkJaW9fZmlsbF9jcWVfcmVxKHJlcSwgcmVxLT5yZXN1bHQsIGlvX3B1
dF9yd19rYnVmKHJlcSkpOworCQljZmxhZ3MgPSBpb19wdXRfcndfa2J1ZihyZXEpOwogCQko
Km5yX2V2ZW50cykrKzsKIAorCQljcWUgPSBpb19nZXRfY3FlKGN0eCk7CisJCWlmIChjcWUp
IHsKKwkJCVdSSVRFX09OQ0UoY3FlLT51c2VyX2RhdGEsIHJlcS0+dXNlcl9kYXRhKTsKKwkJ
CVdSSVRFX09OQ0UoY3FlLT5yZXMsIHJlcS0+cmVzdWx0KTsKKwkJCVdSSVRFX09OQ0UoY3Fl
LT5mbGFncywgY2ZsYWdzKTsKKwkJfSBlbHNlIHsKKwkJCXNwaW5fbG9jaygmY3R4LT5jb21w
bGV0aW9uX2xvY2spOworCQkJaW9fY3FyaW5nX2V2ZW50X292ZXJmbG93KGN0eCwgcmVxLT51
c2VyX2RhdGEsCisJCQkJCQkJcmVxLT5yZXN1bHQsIGNmbGFncyk7CisJCQlzcGluX3VubG9j
aygmY3R4LT5jb21wbGV0aW9uX2xvY2spOworCQl9CisKIAkJaWYgKHJlcV9yZWZfcHV0X2Fu
ZF90ZXN0KHJlcSkpCiAJCQlpb19yZXFfZnJlZV9iYXRjaCgmcmIsIHJlcSwgJmN0eC0+c3Vi
bWl0X3N0YXRlKTsKIAl9Ci0tIAoyLjM5LjAKCg==

--------------xNpH0YZPtcnJkCzcfAa6rm8K--
