Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534F466AC87
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 17:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbjANQPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 11:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbjANQPr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 11:15:47 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C73393F1
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 08:15:45 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id q64so25268996pjq.4
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 08:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OhJo5NPm+zHZ7VIvwFUwSIimWHmGvAdDWVoLPUVvGug=;
        b=wUBisGN3JwrNab+W1+yewZVSWYH4vdQvITkAdymriHeU8rbaQN7Ef4QasILnqeZezS
         3bWaMW6mSvtVuierxjzFo8m5B1V8WHy1oYeS2zicOCBHnw/x4VxKdvnNa/sL0OILtQCF
         9Wk1FCu19NYRO6lq8V/wePnfbnFiiAmneaF8ke3LIqwnTSZmZFhvzNEMYzhVMIehWlPw
         jSUkfAtzcsDqOvtZdZO0PnQzwrzhM7idBBwKGFfW3rwOYf6jS/QTtfsuTsv5QrUfhEsQ
         420imI6hE5mYf+8UmXiMCPI2cBF0yjCDyc1IuX8jH+T0TeE2wryLdCLdN/sgD91f/zQL
         wMww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OhJo5NPm+zHZ7VIvwFUwSIimWHmGvAdDWVoLPUVvGug=;
        b=Lp3ru60oSyAL1lxSnQ/26AKPV+xresFp0R65lAlgosaoJDE6qvu1MsK2VDV+h9Dm38
         7wHUEnySbuNuIrt8ttvwn7EODmKHmigkvY6++8J2VNo891YEtyyVULDKdQTnYvknCNCL
         dah1fDEd/EqcjuoHA9hrHhrtyp6pamPzDGZeqjJdsR/vajzVpRrAJ0898Sq0Rl2n+id0
         mDpE3a74MzXNNLZPsMMegCxEF3GR80ZU+QxBzgcttoejjIvIAqCmPUe82qiHEthZ8deR
         ksVf9dHPLdv8OQU1Fut1s/Uj/jjq6Kjyja+bynvMSgMn8L/YvhakhRq3tb7wxLd+Gaai
         B4/w==
X-Gm-Message-State: AFqh2kojW1CcDghyOT1b5zvVMZbymBMW4xYdgmgHGkZ9nkEYJNRyBJud
        A3WcZfkluz22WERK6BmeUcLsmg==
X-Google-Smtp-Source: AMrXdXuVbo2HcLe9gnDZPfpSTCIIKTj0jYVwP2V2k+mR5uXJbaopQgd6NsOZ0BpB60l0/3dXLIjxrg==
X-Received: by 2002:a17:902:e944:b0:192:5c3e:8952 with SMTP id b4-20020a170902e94400b001925c3e8952mr1062459pll.2.1673712944874;
        Sat, 14 Jan 2023 08:15:44 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m7-20020a170902db0700b00192b0a07891sm16184350plx.101.2023.01.14.08.15.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Jan 2023 08:15:44 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------t0WcEAKg076LS0zVRDVTySq0"
Message-ID: <f7ffd01f-71f2-6bfc-daf7-e149be9bf836@kernel.dk>
Date:   Sat, 14 Jan 2023 09:15:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: FAILED: patch "[PATCH] io_uring: lock overflowing for IOPOLL"
 failed to apply to 5.15-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, asml.silence@gmail.com
Cc:     stable@vger.kernel.org
References: <1673689917176116@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1673689917176116@kroah.com>
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
--------------t0WcEAKg076LS0zVRDVTySq0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/14/23 2:51 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

This has to be done a bit differently, but this one should work. I tested
it on 5.10-stable, but should apply to 5.15-stable as well as they are
the same base now.

-- 
Jens Axboe


--------------t0WcEAKg076LS0zVRDVTySq0
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-lock-overflowing-for-IOPOLL.patch"
Content-Disposition: attachment;
 filename="0001-io_uring-lock-overflowing-for-IOPOLL.patch"
Content-Transfer-Encoding: base64

RnJvbSAzMTNjYzNkNGMzZjZhMWM2ZDBkZjUyNWYwMzY4YTJjNWE3Y2U5N2M4IE1vbiBTZXAg
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
Zy9pb191cmluZy5jIHwgMTYgKysrKysrKysrKysrKysrLQogMSBmaWxlIGNoYW5nZWQsIDE1
IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9pb191cmluZy9p
b191cmluZy5jIGIvaW9fdXJpbmcvaW9fdXJpbmcuYwppbmRleCAwYzRkMTZhZmI5ZWYuLjFh
M2YzNjBhZjM3MyAxMDA2NDQKLS0tIGEvaW9fdXJpbmcvaW9fdXJpbmcuYworKysgYi9pb191
cmluZy9pb191cmluZy5jCkBAIC0yNDc4LDEwICsyNDc4LDI0IEBAIHN0YXRpYyB2b2lkIGlv
X2lvcG9sbF9jb21wbGV0ZShzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCwgdW5zaWduZWQgaW50
ICpucl9ldmVudHMsCiAKIAlpb19pbml0X3JlcV9iYXRjaCgmcmIpOwogCXdoaWxlICghbGlz
dF9lbXB0eShkb25lKSkgeworCQlzdHJ1Y3QgaW9fdXJpbmdfY3FlICpjcWU7CisJCXVuc2ln
bmVkIGNmbGFnczsKKwogCQlyZXEgPSBsaXN0X2ZpcnN0X2VudHJ5KGRvbmUsIHN0cnVjdCBp
b19raW9jYiwgaW5mbGlnaHRfZW50cnkpOwogCQlsaXN0X2RlbCgmcmVxLT5pbmZsaWdodF9l
bnRyeSk7CisJCWNmbGFncyA9IGlvX3B1dF9yd19rYnVmKHJlcSk7CiAKLQkJaW9fZmlsbF9j
cWVfcmVxKHJlcSwgcmVxLT5yZXN1bHQsIGlvX3B1dF9yd19rYnVmKHJlcSkpOworCQljcWUg
PSBpb19nZXRfY3FlKGN0eCk7CisJCWlmICh1bmxpa2VseSghY3FlKSkgeworCQkJc3Bpbl9s
b2NrKCZjdHgtPmNvbXBsZXRpb25fbG9jayk7CisJCQlpb19jcXJpbmdfZXZlbnRfb3ZlcmZs
b3coY3R4LCByZXEtPnVzZXJfZGF0YSwKKwkJCQkJCQlyZXEtPnJlc3VsdCwgY2ZsYWdzKTsK
KwkJCXNwaW5fdW5sb2NrKCZjdHgtPmNvbXBsZXRpb25fbG9jayk7CisJCQljb250aW51ZTsK
KwkJfQorCQlXUklURV9PTkNFKGNxZS0+dXNlcl9kYXRhLCByZXEtPnVzZXJfZGF0YSk7CisJ
CVdSSVRFX09OQ0UoY3FlLT5yZXMsIHJlcS0+cmVzdWx0KTsKKwkJV1JJVEVfT05DRShjcWUt
PmZsYWdzLCBjZmxhZ3MpOwogCQkoKm5yX2V2ZW50cykrKzsKIAogCQlpZiAocmVxX3JlZl9w
dXRfYW5kX3Rlc3QocmVxKSkKLS0gCjIuMzkuMAoK

--------------t0WcEAKg076LS0zVRDVTySq0--
