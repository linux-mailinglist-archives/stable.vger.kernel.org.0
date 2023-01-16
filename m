Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9BA66C23A
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbjAPOd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:33:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbjAPOdE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:33:04 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DAC2DE59
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 06:13:44 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id k12so8365554plk.0
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 06:13:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:references:cc:to:from:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OsbOj6yUhZKGsZglN/7ZtsllvXK90TDUysjC9jmEGRQ=;
        b=pfArc4puK8y3kBJfc1MZfFdnooMRoZVsrLP3HW8BV/72VQHhWVshUN/4+qmLgCQxHl
         nyktbC9hyXRojhzJ7mMr4JhmRlTDcD6GcRYqYBv4o4xg3WGsYzhUDLavGU11cPAdWnxe
         9ec1fE7WG3dFHy2gv+wtCpE1J+U3+1i4EY+F8RsFEBzbuQTb+oYpKgsB1bHOL6ZQ5VQL
         7dvndcV8lqo4+5tU17mNwN6OZ23lIQS3csbDVTZj1m22OqkU+Mezv+ltz2y22qfZRZFg
         z04Sb7kAIvNAoKdl/8t43VEcGyaqHJWG9quN1WwejlGlEXiURVnW+ZeBrSWRWnK8V5la
         25xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:cc:to:from:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OsbOj6yUhZKGsZglN/7ZtsllvXK90TDUysjC9jmEGRQ=;
        b=rDPV+5pA0yZ+fQd1hzlAdBfVllKttO9k8KIpqzHZCLYyIY76bGPtN/FQwKr7XJLHhZ
         50IL/mysj7JYxVWm3AhBRkOnTWe8OvmSeFsIqs5UAfLLxgg12k7A+hyPB5PjblVt/t+y
         bkFqljNVCUvXWvpGooWFmf1RZMS4Xtq4MwSb6gcHieXNVhYclEAJSqxUXcUUITmwk+0a
         e9fiDQekNgboXIOtj8LoNs7GFzODPKmfPEYkxBcBprk2SetCbSai5hhU35O+z33i4TzB
         O499CAYAVDdgRJDSw+i8+mQNvZ+tqFytOXtFK6rTKDJxyJ79ebf8tgxOVkSdKpQFCa2z
         hQXw==
X-Gm-Message-State: AFqh2krsbVlxhhWlgY5BgHRblUBd42IVuYdK24/y48yc43bGJs+pPXs5
        T9GEU6PS23nL/c62Tc1cmQPhnQ==
X-Google-Smtp-Source: AMrXdXssRNpPbiIlmBYxbkzi05mryxVHBs2FklNga9Xb6mgB7I4+VqZWSYaN1THnCtStJcwNGMjG1A==
X-Received: by 2002:a05:6a21:3a89:b0:b6:5687:17b1 with SMTP id zv9-20020a056a213a8900b000b6568717b1mr4831433pzb.4.1673878422014;
        Mon, 16 Jan 2023 06:13:42 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m2-20020a170902bb8200b001949c680b52sm1358758pls.193.2023.01.16.06.13.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 06:13:41 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------qgK8S7GbTKc0I1wM25WBpC6f"
Message-ID: <a862915b-66f3-9ad8-77d4-4b9ce7044037@kernel.dk>
Date:   Mon, 16 Jan 2023 07:13:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: =?UTF-8?Q?Re=3a_=5bregression=5d_Bug=c2=a0216932_-_io=5furing_with_?=
 =?UTF-8?Q?libvirt_cause_kernel_NULL_pointer_dereference_since_6=2e1=2e5?=
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Linux regressions mailing list <regressions@lists.linux.dev>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        io-uring@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Sergey V." <truesmb@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <74347fe1-ac68-2661-500d-b87fab6994f7@leemhuis.info>
 <c5632908-1b0f-af1f-4754-bf1d0027a6dc@kernel.dk>
In-Reply-To: <c5632908-1b0f-af1f-4754-bf1d0027a6dc@kernel.dk>
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
--------------qgK8S7GbTKc0I1wM25WBpC6f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/16/23 6:42 AM, Jens Axboe wrote:
> On 1/16/23 6:17?AM, Linux kernel regression tracking (Thorsten Leemhuis) wrote:
>> Hi, this is your Linux kernel regression tracker.
>>
>> I noticed a regression report in bugzilla.kernel.org. As many (most?)
>> kernel developer don't keep an eye on it, I decided to forward it by
>> mail. Quoting from https://bugzilla.kernel.org/show_bug.cgi?id=216932 :
> 
> Looks like:
> 
> commit 6d47e0f6a535701134d950db65eb8fe1edf0b575
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Wed Jan 4 08:52:06 2023 -0700
> 
>     block: don't allow splitting of a REQ_NOWAIT bio
> 
> got picked up by stable, but not the required prep patch:
> 
> 
> commit 613b14884b8595e20b9fac4126bf627313827fbe
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Wed Jan 4 08:51:19 2023 -0700
> 
>     block: handle bio_split_to_limits() NULL return
> 
> Greg/team, can you pick the latter too? It'll pick cleanly for
> 6.1-stable, not sure how far back the other patch has gone yet.

Looked back, and 5.15 has it too, but the cherry-pick won't work
on that kernel.

Here's one for 5.15-stable that I verified crashes before this one,
and works with it. Haven't done an allmodconfig yet...

-- 
Jens Axboe


--------------qgK8S7GbTKc0I1wM25WBpC6f
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-block-handle-bio_split_to_limits-NULL-return.patch"
Content-Disposition: attachment;
 filename="0001-block-handle-bio_split_to_limits-NULL-return.patch"
Content-Transfer-Encoding: base64

RnJvbSA4NTAwOTE1OTMxMjhjZGJjNzJjZTBmMDZmZjM1NjY1ZDdkNzA4YTVmIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IE1vbiwgMTYgSmFuIDIwMjMgMDc6MTE6MDQgLTA3MDAKU3ViamVjdDogW1BBVENIXSBi
bG9jazogaGFuZGxlIGJpb19zcGxpdF90b19saW1pdHMoKSBOVUxMIHJldHVybgoKY29tbWl0
IDYxM2IxNDg4NGI4NTk1ZTIwYjlmYWM0MTI2YmY2MjczMTM4MjdmYmUgdXBzdHJlYW0uCgpU
aGlzIGNhbid0IGhhcHBlbiByaWdodCBub3csIGJ1dCBpbiBwcmVwYXJhdGlvbiBmb3IgYWxs
b3dpbmcKYmlvX3NwbGl0X3RvX2xpbWl0cygpIHJldHVybmluZyBOVUxMIGlmIGl0IGVuZGVk
IHRoZSBiaW8sIGNoZWNrIGZvciBpdAppbiBhbGwgdGhlIGNhbGxlcnMuCgpTaWduZWQtb2Zm
LWJ5OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+Ci0tLQogYmxvY2svYmxrLW1lcmdl
LmMgICAgICAgICAgICAgfCA0ICsrKy0KIGJsb2NrL2Jsay1tcS5jICAgICAgICAgICAgICAg
IHwgMiArKwogZHJpdmVycy9ibG9jay9kcmJkL2RyYmRfcmVxLmMgfCAyICsrCiBkcml2ZXJz
L2Jsb2NrL3BrdGNkdmQuYyAgICAgICB8IDIgKysKIGRyaXZlcnMvYmxvY2svcHMzdnJhbS5j
ICAgICAgIHwgMiArKwogZHJpdmVycy9ibG9jay9yc3h4L2Rldi5jICAgICAgfCAyICsrCiBk
cml2ZXJzL21kL21kLmMgICAgICAgICAgICAgICB8IDIgKysKIGRyaXZlcnMvbnZtZS9ob3N0
L211bHRpcGF0aC5jIHwgMiArKwogZHJpdmVycy9zMzkwL2Jsb2NrL2Rjc3NibGsuYyAgfCAy
ICsrCiA5IGZpbGVzIGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkK
CmRpZmYgLS1naXQgYS9ibG9jay9ibGstbWVyZ2UuYyBiL2Jsb2NrL2Jsay1tZXJnZS5jCmlu
ZGV4IGJiMjZkYjkzYWQxZC4uZDE0MzViNjU3Mjk3IDEwMDY0NAotLS0gYS9ibG9jay9ibGst
bWVyZ2UuYworKysgYi9ibG9jay9ibGstbWVyZ2UuYwpAQCAtMzQ4LDExICszNDgsMTMgQEAg
dm9pZCBfX2Jsa19xdWV1ZV9zcGxpdChzdHJ1Y3QgYmlvICoqYmlvLCB1bnNpZ25lZCBpbnQg
Km5yX3NlZ3MpCiAJCQlicmVhazsKIAkJfQogCQlzcGxpdCA9IGJsa19iaW9fc2VnbWVudF9z
cGxpdChxLCAqYmlvLCAmcS0+YmlvX3NwbGl0LCBucl9zZWdzKTsKKwkJaWYgKElTX0VSUihz
cGxpdCkpCisJCQkqYmlvID0gc3BsaXQgPSBOVUxMOwogCQlicmVhazsKIAl9CiAKIAlpZiAo
c3BsaXQpIHsKLQkJLyogdGhlcmUgaXNuJ3QgY2hhbmNlIHRvIG1lcmdlIHRoZSBzcGxpdHRl
ZCBiaW8gKi8KKwkJLyogdGhlcmUgaXNuJ3QgY2hhbmNlIHRvIG1lcmdlIHRoZSBzcGxpdCBi
aW8gKi8KIAkJc3BsaXQtPmJpX29wZiB8PSBSRVFfTk9NRVJHRTsKIAogCQliaW9fY2hhaW4o
c3BsaXQsICpiaW8pOwpkaWZmIC0tZ2l0IGEvYmxvY2svYmxrLW1xLmMgYi9ibG9jay9ibGst
bXEuYwppbmRleCAxYTI4YmE5MDE3ZWQuLjlmNTNiNGNhZjk3NyAxMDA2NDQKLS0tIGEvYmxv
Y2svYmxrLW1xLmMKKysrIGIvYmxvY2svYmxrLW1xLmMKQEAgLTIxOTMsNiArMjE5Myw4IEBA
IGJsa19xY190IGJsa19tcV9zdWJtaXRfYmlvKHN0cnVjdCBiaW8gKmJpbykKIAogCWJsa19x
dWV1ZV9ib3VuY2UocSwgJmJpbyk7CiAJX19ibGtfcXVldWVfc3BsaXQoJmJpbywgJm5yX3Nl
Z3MpOworCWlmICghYmlvKQorCQlnb3RvIHF1ZXVlX2V4aXQ7CiAKIAlpZiAoIWJpb19pbnRl
Z3JpdHlfcHJlcChiaW8pKQogCQlnb3RvIHF1ZXVlX2V4aXQ7CmRpZmYgLS1naXQgYS9kcml2
ZXJzL2Jsb2NrL2RyYmQvZHJiZF9yZXEuYyBiL2RyaXZlcnMvYmxvY2svZHJiZC9kcmJkX3Jl
cS5jCmluZGV4IDQ3ZTBkMTA1YjQ2Mi4uNDI4MWRjODQ3YmMyIDEwMDY0NAotLS0gYS9kcml2
ZXJzL2Jsb2NrL2RyYmQvZHJiZF9yZXEuYworKysgYi9kcml2ZXJzL2Jsb2NrL2RyYmQvZHJi
ZF9yZXEuYwpAQCAtMTYwMiw2ICsxNjAyLDggQEAgYmxrX3FjX3QgZHJiZF9zdWJtaXRfYmlv
KHN0cnVjdCBiaW8gKmJpbykKIAlzdHJ1Y3QgZHJiZF9kZXZpY2UgKmRldmljZSA9IGJpby0+
YmlfYmRldi0+YmRfZGlzay0+cHJpdmF0ZV9kYXRhOwogCiAJYmxrX3F1ZXVlX3NwbGl0KCZi
aW8pOworCWlmICghYmlvKQorCQlyZXR1cm4gQkxLX1FDX1RfTk9ORTsKIAogCS8qCiAJICog
d2hhdCB3ZSAiYmxpbmRseSIgYXNzdW1lOgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ibG9jay9w
a3RjZHZkLmMgYi9kcml2ZXJzL2Jsb2NrL3BrdGNkdmQuYwppbmRleCAwZjI2YjI1MTBhNzUu
LmNhMmFiOTc3ZWY4ZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9ibG9jay9wa3RjZHZkLmMKKysr
IGIvZHJpdmVycy9ibG9jay9wa3RjZHZkLmMKQEAgLTI0MDcsNiArMjQwNyw4IEBAIHN0YXRp
YyBibGtfcWNfdCBwa3Rfc3VibWl0X2JpbyhzdHJ1Y3QgYmlvICpiaW8pCiAJc3RydWN0IGJp
byAqc3BsaXQ7CiAKIAlibGtfcXVldWVfc3BsaXQoJmJpbyk7CisJaWYgKCFiaW8pCisJCXJl
dHVybiBCTEtfUUNfVF9OT05FOwogCiAJcGQgPSBiaW8tPmJpX2JkZXYtPmJkX2Rpc2stPnF1
ZXVlLT5xdWV1ZWRhdGE7CiAJaWYgKCFwZCkgewpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ibG9j
ay9wczN2cmFtLmMgYi9kcml2ZXJzL2Jsb2NrL3BzM3ZyYW0uYwppbmRleCBjN2IxOWUxMjhi
MDMuLmM3OWFhNGQ4Y2NmNyAxMDA2NDQKLS0tIGEvZHJpdmVycy9ibG9jay9wczN2cmFtLmMK
KysrIGIvZHJpdmVycy9ibG9jay9wczN2cmFtLmMKQEAgLTU4Nyw2ICs1ODcsOCBAQCBzdGF0
aWMgYmxrX3FjX3QgcHMzdnJhbV9zdWJtaXRfYmlvKHN0cnVjdCBiaW8gKmJpbykKIAlkZXZf
ZGJnKCZkZXYtPmNvcmUsICIlc1xuIiwgX19mdW5jX18pOwogCiAJYmxrX3F1ZXVlX3NwbGl0
KCZiaW8pOworCWlmICghYmlvKQorCQlyZXR1cm4gQkxLX1FDX1RfTk9ORTsKIAogCXNwaW5f
bG9ja19pcnEoJnByaXYtPmxvY2spOwogCWJ1c3kgPSAhYmlvX2xpc3RfZW1wdHkoJnByaXYt
Pmxpc3QpOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ibG9jay9yc3h4L2Rldi5jIGIvZHJpdmVy
cy9ibG9jay9yc3h4L2Rldi5jCmluZGV4IDFjYzQwYjBlYTc2MS4uNmIyNTNkOTliYzQ4IDEw
MDY0NAotLS0gYS9kcml2ZXJzL2Jsb2NrL3JzeHgvZGV2LmMKKysrIGIvZHJpdmVycy9ibG9j
ay9yc3h4L2Rldi5jCkBAIC0xMjcsNiArMTI3LDggQEAgc3RhdGljIGJsa19xY190IHJzeHhf
c3VibWl0X2JpbyhzdHJ1Y3QgYmlvICpiaW8pCiAJYmxrX3N0YXR1c190IHN0ID0gQkxLX1NU
U19JT0VSUjsKIAogCWJsa19xdWV1ZV9zcGxpdCgmYmlvKTsKKwlpZiAoIWJpbykKKwkJcmV0
dXJuIEJMS19RQ19UX05PTkU7CiAKIAltaWdodF9zbGVlcCgpOwogCmRpZmYgLS1naXQgYS9k
cml2ZXJzL21kL21kLmMgYi9kcml2ZXJzL21kL21kLmMKaW5kZXggNTlhYjk5ODQ0ZGY4Li45
ZTU0Yjg2NWYzMGQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWQvbWQuYworKysgYi9kcml2ZXJz
L21kL21kLmMKQEAgLTQ1OCw2ICs0NTgsOCBAQCBzdGF0aWMgYmxrX3FjX3QgbWRfc3VibWl0
X2JpbyhzdHJ1Y3QgYmlvICpiaW8pCiAJfQogCiAJYmxrX3F1ZXVlX3NwbGl0KCZiaW8pOwor
CWlmICghYmlvKQorCQlyZXR1cm4gQkxLX1FDX1RfTk9ORTsKIAogCWlmIChtZGRldi0+cm8g
PT0gMSAmJiB1bmxpa2VseShydyA9PSBXUklURSkpIHsKIAkJaWYgKGJpb19zZWN0b3JzKGJp
bykgIT0gMCkKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbnZtZS9ob3N0L211bHRpcGF0aC5jIGIv
ZHJpdmVycy9udm1lL2hvc3QvbXVsdGlwYXRoLmMKaW5kZXggZmUxOTlkNTY4YTRhLi44ZDk3
Yjk0MmRlMDEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbnZtZS9ob3N0L211bHRpcGF0aC5jCisr
KyBiL2RyaXZlcnMvbnZtZS9ob3N0L211bHRpcGF0aC5jCkBAIC0zMjksNiArMzI5LDggQEAg
c3RhdGljIGJsa19xY190IG52bWVfbnNfaGVhZF9zdWJtaXRfYmlvKHN0cnVjdCBiaW8gKmJp
bykKIAkgKiBwb29sIGZyb20gdGhlIG9yaWdpbmFsIHF1ZXVlIHRvIGFsbG9jYXRlIHRoZSBi
dmVjcyBmcm9tLgogCSAqLwogCWJsa19xdWV1ZV9zcGxpdCgmYmlvKTsKKwlpZiAoIWJpbykK
KwkJcmV0dXJuIEJMS19RQ19UX05PTkU7CiAKIAlzcmN1X2lkeCA9IHNyY3VfcmVhZF9sb2Nr
KCZoZWFkLT5zcmN1KTsKIAlucyA9IG52bWVfZmluZF9wYXRoKGhlYWQpOwpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zMzkwL2Jsb2NrL2Rjc3NibGsuYyBiL2RyaXZlcnMvczM5MC9ibG9jay9k
Y3NzYmxrLmMKaW5kZXggNWJlM2QxYzM5YTc4Li41NDE3NmMwNzM1NDcgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvczM5MC9ibG9jay9kY3NzYmxrLmMKKysrIGIvZHJpdmVycy9zMzkwL2Jsb2Nr
L2Rjc3NibGsuYwpAQCAtODY2LDYgKzg2Niw4IEBAIGRjc3NibGtfc3VibWl0X2JpbyhzdHJ1
Y3QgYmlvICpiaW8pCiAJdW5zaWduZWQgbG9uZyBieXRlc19kb25lOwogCiAJYmxrX3F1ZXVl
X3NwbGl0KCZiaW8pOworCWlmICghYmlvKQorCQlyZXR1cm4gQkxLX1FDX1RfTk9ORTsKIAog
CWJ5dGVzX2RvbmUgPSAwOwogCWRldl9pbmZvID0gYmlvLT5iaV9iZGV2LT5iZF9kaXNrLT5w
cml2YXRlX2RhdGE7Ci0tIAoyLjM5LjAKCg==

--------------qgK8S7GbTKc0I1wM25WBpC6f--
