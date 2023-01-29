Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE11680135
	for <lists+stable@lfdr.de>; Sun, 29 Jan 2023 20:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbjA2TkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Jan 2023 14:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjA2TkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Jan 2023 14:40:15 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E046A5CF
        for <stable@vger.kernel.org>; Sun, 29 Jan 2023 11:40:14 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 7so1371463pgh.7
        for <stable@vger.kernel.org>; Sun, 29 Jan 2023 11:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9HuVji3x6QkoiKetH7e4ARi///vtMhIdly3rxnRGjGE=;
        b=Z9rLW6jXD54dfBNYMtTFVf6kSBufK9Z+W15aqM57XYGsVq9XBX/UiVOU7C4BIxzw05
         bIMipmWX3LViBcuE1grv7XTSnHiu+PcGvHuX6IFCCKiTafWYiSa+M3aRLT8qjBJX841g
         FbcQFhNAYJsFDwtBOzxnuEqahCWo+GUWmItDUuqy8QhVqM5n1SAFXMHq1tZ6sdrdFTCT
         bQTmhdfe3lSi3xwutPD/SjQDAEvqi5HsGwqwMu6ZgH+631AzMH6YPdI/y2HFezRKvP8r
         52XAJ/HIYCJhjGVYmtJiznksVnd9XqC0FQtosxsHd4OGVMbYjYU578VF4s8ctzzsBFl1
         j3NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9HuVji3x6QkoiKetH7e4ARi///vtMhIdly3rxnRGjGE=;
        b=5X8+mFm0Ayk0l9pzeniKUq6lFPeY7GbnWKOvDX+IlQqIbvvPDrgkiMrzc8VCvSO7ws
         KIalSPIMzbzCCD6QQGlLUhart50TjIk+keZ5cRtXwdwNgB1ePqoU2C5iP2txuxrVuuJl
         Q+BOegMNgw1OenRYahciN8dlqVxh4gKJ/KdIBSxgNRA1VDr4WI30p0YAJ0H2vUDPoaB8
         Ahp7NavZHE5OaieiZwP+6K4LiTxMC4fOnLE8OhXW2RmGh8TmKJBdrhX/tukNhWvXaTx9
         uUln6TKhDyDwufxv547MVVtJ6YTKU0bVDBXlFmCFbLFXAWU6S53G3gU7UEfSWcJmzOJp
         R7ow==
X-Gm-Message-State: AO0yUKXUVckTZHJAaww5OUTiwfyG5I137r75MsgB/Cgj8Sv4IeDIskUV
        sWu06oejf7Oaa0D06/PtOAHNEQnshVR3wpFX
X-Google-Smtp-Source: AK7set/3VRCSvDWEZpvHkK0ag/UHj5/IDuY73pc1LX6mnpPOF7/Zm2AtXKah6GZik3wlxaga2wECZw==
X-Received: by 2002:aa7:97a3:0:b0:590:761e:6dc9 with SMTP id d3-20020aa797a3000000b00590761e6dc9mr3338228pfq.1.1675021213438;
        Sun, 29 Jan 2023 11:40:13 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a7-20020a62bd07000000b00576ee69c130sm6001709pff.4.2023.01.29.11.40.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 11:40:12 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------eKOeaD5bbZHBL0zmBx2Y4uOQ"
Message-ID: <1aa4166f-c66b-5eea-e695-66f206482321@kernel.dk>
Date:   Sun, 29 Jan 2023 12:40:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: FAILED: patch "[PATCH] io_uring: always prep_async for drain
 requests" failed to apply to 6.1-stable tree
To:     gregkh@linuxfoundation.org, dylany@meta.com
Cc:     stable@vger.kernel.org
References: <1674998787177121@kroah.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1674998787177121@kroah.com>
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------eKOeaD5bbZHBL0zmBx2Y4uOQ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/29/23 6:26 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 6.1-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

This should do it.

-- 
Jens Axboe


--------------eKOeaD5bbZHBL0zmBx2Y4uOQ
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-always-prep_async-for-drain-requests.patch"
Content-Disposition: attachment;
 filename="0001-io_uring-always-prep_async-for-drain-requests.patch"
Content-Transfer-Encoding: base64

RnJvbSA3MWE1OGFiOGNmMWJiNGI0YzI4NmZiYWJlMjY2YTgyYmFiMjBmZGYyIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBEeWxhbiBZdWRha2VuIDxkeWxhbnlAbWV0YS5jb20+
CkRhdGU6IFN1biwgMjkgSmFuIDIwMjMgMTI6MzQ6NTEgLTA3MDAKU3ViamVjdDogW1BBVENI
XSBpb191cmluZzogYWx3YXlzIHByZXBfYXN5bmMgZm9yIGRyYWluIHJlcXVlc3RzCgpjb21t
aXQgZWY1YzYwMGFkYjFkOTg1NTEzZDJiNjEyY2M5MDQwM2ExNDhmZjI4NyB1cHN0cmVhbS4K
CkRyYWluIHJlcXVlc3RzIGFsbCBnbyB0aHJvdWdoIGlvX2RyYWluX3JlcSwgd2hpY2ggaGFz
IGEgcXVpY2sgZXhpdCBpbiBjYXNlCnRoZXJlIGlzIG5vdGhpbmcgcGVuZGluZyAoaWUgdGhl
IGRyYWluIGlzIG5vdCB1c2VmdWwpLiBJbiB0aGF0IGNhc2UgaXQgY2FuCnJ1biB0aGUgaXNz
dWUgdGhlIHJlcXVlc3QgaW1tZWRpYXRlbHkuCgpIb3dldmVyIGZvciBzYWZldHkgaXQgcXVl
dWVzIGl0IHRocm91Z2ggdGFzayB3b3JrLgpUaGUgcHJvYmxlbSBpcyB0aGF0IGluIHRoaXMg
Y2FzZSB0aGUgcmVxdWVzdCBpcyBydW4gYXN5bmNocm9ub3VzbHksIGJ1dAp0aGUgYXN5bmMg
d29yayBoYXMgbm90IGJlZW4gcHJlcGFyZWQgdGhyb3VnaCBpb19yZXFfcHJlcF9hc3luYy4K
ClRoaXMgaGFzIG5vdCBiZWVuIGEgcHJvYmxlbSB1cCB0byBub3csIGFzIHRoZSB0YXNrIHdv
cmsgYWx3YXlzIHdvdWxkIHJ1bgpiZWZvcmUgcmV0dXJuaW5nIHRvIHVzZXJzcGFjZSwgYW5k
IHNvIHRoZSB1c2VyIHdvdWxkIG5vdCBoYXZlIGEgY2hhbmNlIHRvCnJhY2Ugd2l0aCBpdC4K
Ckhvd2V2ZXIgLSB3aXRoIElPUklOR19TRVRVUF9ERUZFUl9UQVNLUlVOIC0gdGhpcyBpcyBu
byBsb25nZXIgdGhlIGNhc2UgYW5kCnRoZSB3b3JrIG1pZ2h0IGJlIGRlZmVyZWQsIGdpdmlu
ZyB1c2Vyc3BhY2UgYSBjaGFuY2UgdG8gY2hhbmdlIGRhdGEgYmVpbmcKcmVmZXJyZWQgdG8g
aW4gdGhlIHJlcXVlc3QuCgpJbnN0ZWFkIF9hbHdheXNfIHByZXBfYXN5bmMgZm9yIGRyYWlu
IHJlcXVlc3RzLCB3aGljaCBpcyBzaW1wbGVyIGFueXdheQphbmQgcmVtb3ZlcyB0aGlzIGlz
c3VlLgoKQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKRml4ZXM6IGMwZTBkNmJhMjVmMSAo
ImlvX3VyaW5nOiBhZGQgSU9SSU5HX1NFVFVQX0RFRkVSX1RBU0tSVU4iKQpTaWduZWQtb2Zm
LWJ5OiBEeWxhbiBZdWRha2VuIDxkeWxhbnlAbWV0YS5jb20+Ckxpbms6IGh0dHBzOi8vbG9y
ZS5rZXJuZWwub3JnL3IvMjAyMzAxMjcxMDU5MTEuMjQyMDA2MS0xLWR5bGFueUBtZXRhLmNv
bQpTaWduZWQtb2ZmLWJ5OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+Ci0tLQogaW9f
dXJpbmcvaW9fdXJpbmcuYyB8IDE4ICsrKysrKysrLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5n
ZWQsIDggaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvaW9f
dXJpbmcvaW9fdXJpbmcuYyBiL2lvX3VyaW5nL2lvX3VyaW5nLmMKaW5kZXggY2VhNWRlOThj
NDIzLi42ZmM0YWFlZjVmZTIgMTAwNjQ0Ci0tLSBhL2lvX3VyaW5nL2lvX3VyaW5nLmMKKysr
IGIvaW9fdXJpbmcvaW9fdXJpbmcuYwpAQCAtMTY1OCwxNyArMTY1OCwxMiBAQCBzdGF0aWMg
X19jb2xkIHZvaWQgaW9fZHJhaW5fcmVxKHN0cnVjdCBpb19raW9jYiAqcmVxKQogCX0KIAlz
cGluX3VubG9jaygmY3R4LT5jb21wbGV0aW9uX2xvY2spOwogCi0JcmV0ID0gaW9fcmVxX3By
ZXBfYXN5bmMocmVxKTsKLQlpZiAocmV0KSB7Ci1mYWlsOgotCQlpb19yZXFfY29tcGxldGVf
ZmFpbGVkKHJlcSwgcmV0KTsKLQkJcmV0dXJuOwotCX0KIAlpb19wcmVwX2FzeW5jX2xpbmso
cmVxKTsKIAlkZSA9IGttYWxsb2Moc2l6ZW9mKCpkZSksIEdGUF9LRVJORUwpOwogCWlmICgh
ZGUpIHsKIAkJcmV0ID0gLUVOT01FTTsKLQkJZ290byBmYWlsOworCQlpb19yZXFfY29tcGxl
dGVfZmFpbGVkKHJlcSwgcmV0KTsKKwkJcmV0dXJuOwogCX0KIAogCXNwaW5fbG9jaygmY3R4
LT5jb21wbGV0aW9uX2xvY2spOwpAQCAtMTk0MiwxMyArMTkzNywxNiBAQCBzdGF0aWMgdm9p
ZCBpb19xdWV1ZV9zcWVfZmFsbGJhY2soc3RydWN0IGlvX2tpb2NiICpyZXEpCiAJCXJlcS0+
ZmxhZ3MgJj0gflJFUV9GX0hBUkRMSU5LOwogCQlyZXEtPmZsYWdzIHw9IFJFUV9GX0xJTks7
CiAJCWlvX3JlcV9jb21wbGV0ZV9mYWlsZWQocmVxLCByZXEtPmNxZS5yZXMpOwotCX0gZWxz
ZSBpZiAodW5saWtlbHkocmVxLT5jdHgtPmRyYWluX2FjdGl2ZSkpIHsKLQkJaW9fZHJhaW5f
cmVxKHJlcSk7CiAJfSBlbHNlIHsKIAkJaW50IHJldCA9IGlvX3JlcV9wcmVwX2FzeW5jKHJl
cSk7CiAKLQkJaWYgKHVubGlrZWx5KHJldCkpCisJCWlmICh1bmxpa2VseShyZXQpKSB7CiAJ
CQlpb19yZXFfY29tcGxldGVfZmFpbGVkKHJlcSwgcmV0KTsKKwkJCXJldHVybjsKKwkJfQor
CisJCWlmICh1bmxpa2VseShyZXEtPmN0eC0+ZHJhaW5fYWN0aXZlKSkKKwkJCWlvX2RyYWlu
X3JlcShyZXEpOwogCQllbHNlCiAJCQlpb19xdWV1ZV9pb3dxKHJlcSwgTlVMTCk7CiAJfQot
LSAKMi4zOS4wCgo=

--------------eKOeaD5bbZHBL0zmBx2Y4uOQ--
