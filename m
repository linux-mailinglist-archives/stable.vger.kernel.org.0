Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C8166AC63
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 17:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjANQCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 11:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjANQCl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 11:02:41 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C869019
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 08:02:40 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d9so26308530pll.9
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 08:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NrS0nBGkZA7ZXO6PJbkGBl1W9uZYAhflAMwToQtgOzY=;
        b=5mSGKw0lIKrfuPRyTlH6Rq0P8g3ItxrzHGZGBQqJxgfWA/NEFjll2HnkMIF61o2n0O
         z0jriVIJAzgcqetAQ2bp3upNidZjQ0MQzL1vIML8nfi4m6+vJwsG8mCjTIASkFbWDmyw
         ExsPUY54UISZ03ZeXgnFPJSL3JsVy8i2CeaYOnwP5Vi0iDtHf0qJnqEN6FO+qRkWrdkq
         ouao46t9fjiUVQMpcygtVTeKieUwG7iW6EI4spB69dmsASLepaOzjkcvA9zOEKDARcR6
         FE2ngFOdUcZBRn30xpp5X+gNcNEh6fnI6dedLGBwZpKDbr4e7YygVruuj3RSi6A6FunU
         e7QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NrS0nBGkZA7ZXO6PJbkGBl1W9uZYAhflAMwToQtgOzY=;
        b=mFQSAPgf33E5F/YC7eeCRsDqW1pD8u1UfVWomuUnRflKnu0Y+ZYAw//LkahmehXTg7
         vNyXgtXHu8vEf2jtf1czPgNPpq8IOb8a6X1QFdLrldcFLSQAA15CphZ91b3YCLSdxuv/
         H8uUGLSbx3bLpZLd2pjZqEXJiYXY1e9eu7tGOcSkz/JdSqrDk0l9iyssl7e1mtb76FYM
         qd0hxW0EsG1svRMzIBd6GmxNj49e2+Nzz2OxBAqNuC9mz3FwOwC+5N3imzFYEyEso2zP
         pvQV7fjyfhy6CiPir1RR6WdzQt4SnUdye1cM8niwz92DCBkEo2RQTQlrLeVuERMCVnav
         rNgg==
X-Gm-Message-State: AFqh2kq91pFyqdfGDC/mz2GYJ9fnw8oeRsGu9a8pJdh0Dx/wD0aGT8mS
        8x8FR5yRgZrWwqpZkCVb3lkkr/1gL6nx02aR
X-Google-Smtp-Source: AMrXdXtpzZW486mKm+CAe/UuQa60kdvJADm1JSgYi6CuAbiCr8s7ln1HeE0/sFlsU4kIsWQ7s5MWWQ==
X-Received: by 2002:a17:902:d052:b0:194:4785:5e9 with SMTP id l18-20020a170902d05200b00194478505e9mr901735pll.4.1673712159373;
        Sat, 14 Jan 2023 08:02:39 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j3-20020a170903028300b001944bf0b57asm7501219plr.204.2023.01.14.08.02.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Jan 2023 08:02:38 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------jEKUZsmD0Ln9aJBojpb1QHE3"
Message-ID: <20172644-899c-8e0f-8cb5-8ad0e166d843@kernel.dk>
Date:   Sat, 14 Jan 2023 09:02:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: FAILED: patch "[PATCH] io_uring/poll: attempt request issue after
 racy poll wakeup" failed to apply to 6.1-stable tree
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
References: <1673689899136134@kroah.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1673689899136134@kroah.com>
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
--------------jEKUZsmD0Ln9aJBojpb1QHE3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/14/23 2:51?AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 6.1-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's a test variant of this one.

-- 
Jens Axboe

--------------jEKUZsmD0Ln9aJBojpb1QHE3
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-poll-attempt-request-issue-after-racy-poll-.patch"
Content-Disposition: attachment;
 filename*0="0002-io_uring-poll-attempt-request-issue-after-racy-poll-.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSA3MWNkMzM0MmI1NjYyZjAzMDFhOTRiMjc4NTg1ZWIzZWVjYzZiYWZhIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IFNhdCwgMTQgSmFuIDIwMjMgMDg6NDY6MTQgLTA3MDAKU3ViamVjdDogW1BBVENIIDIv
Ml0gaW9fdXJpbmcvcG9sbDogYXR0ZW1wdCByZXF1ZXN0IGlzc3VlIGFmdGVyIHJhY3kgcG9s
bAogd2FrZXVwCgpjb21taXQgNmU1YWVkYjkzMjRhYWIxYzE0YTIzZmFlM2Q4ZWViNjRhNjc5
YzIwZSB1cHN0cmVhbS4KCklmIHdlIGhhdmUgbXVsdGlwbGUgcmVxdWVzdHMgd2FpdGluZyBv
biB0aGUgc2FtZSB0YXJnZXQgcG9sbCB3YWl0cXVldWUsCnRoZW4gaXQncyBxdWl0ZSBwb3Nz
aWJsZSB0byBnZXQgYSByZXF1ZXN0IHRyaWdnZXJlZCBhbmQgZ2V0IGRpc2FwcG9pbnRlZApp
biBub3QgYmVpbmcgYWJsZSB0byBtYWtlIGFueSBwcm9ncmVzcyB3aXRoIGl0LiBJZiB3ZSBy
YWNlIGluIGRvaW5nIHNvLAp3ZSdsbCBwb3RlbnRpYWxseSBsZWF2ZSB0aGUgcG9sbCByZXF1
ZXN0IG9uIHRoZSBpbnRlcm5hbCB0YWJsZXMsIGJ1dApyZW1vdmVkIGZyb20gdGhlIHdhaXRx
dWV1ZS4gVGhhdCBtZWFucyB0aGF0IGFueSBzdWJzZXF1ZW50IHRyaWdnZXIgb2YKdGhlIHBv
bGwgd2FpdHF1ZXVlIHdpbGwgbm90IGtpY2sgdGhhdCByZXF1ZXN0IGludG8gYWN0aW9uLCBj
YXVzaW5nIGFuCmFwcGxpY2F0aW9uIHRvIHBvdGVudGlhbGx5IHdhaXQgZm9yIGNvbXBsZXRp
b24gb2YgYSByZXF1ZXN0IHRoYXQgd2lsbApuZXZlciBoYXBwZW4uCgpGaXggdGhpcyBieSBh
ZGRpbmcgYSBuZXcgcG9sbCByZXR1cm4gc3RhdGUsIElPVV9QT0xMX1JFSVNTVUUuIFJhdGhl
cgp0aGFuIGhhdmUgY29tcGxpY2F0ZWQgbG9naWMgZm9yIGhvdyB0byByZS1hcm0gYSBnaXZl
biB0eXBlIG9mIHJlcXVlc3QsCmp1c3QgcHVudCBpdCBmb3IgYSByZWlzc3VlLgoKV2hpbGUg
aW4gdGhlcmUsIG1vdmUgdGhlICdyZXQnIHZhcmlhYmxlIHRvIHRoZSBvbmx5IHNlY3Rpb24g
d2hlcmUgaXQKZ2V0cyB1c2VkLiBUaGlzIGF2b2lkcyBjb25mdXNpb24gdGhlIHNjb3BlIG9m
IGl0LgoKQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKRml4ZXM6IGViMDA4OWQ2MjliYSAo
ImlvX3VyaW5nOiBzaW5nbGUgc2hvdCBwb2xsIHJlbW92YWwgb3B0aW1pc2F0aW9uIikKU2ln
bmVkLW9mZi1ieTogSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPgotLS0KIGlvX3VyaW5n
L3BvbGwuYyB8IDMzICsrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLQogMSBmaWxl
IGNoYW5nZWQsIDIyIGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2lvX3VyaW5nL3BvbGwuYyBiL2lvX3VyaW5nL3BvbGwuYwppbmRleCBmZGVkMTQ0NWE4
MDMuLmNhZTVlMWY0NmMzNSAxMDA2NDQKLS0tIGEvaW9fdXJpbmcvcG9sbC5jCisrKyBiL2lv
X3VyaW5nL3BvbGwuYwpAQCAtMjIzLDIyICsyMjMsMjMgQEAgZW51bSB7CiAJSU9VX1BPTExf
RE9ORSA9IDAsCiAJSU9VX1BPTExfTk9fQUNUSU9OID0gMSwKIAlJT1VfUE9MTF9SRU1PVkVf
UE9MTF9VU0VfUkVTID0gMiwKKwlJT1VfUE9MTF9SRUlTU1VFID0gMywKIH07CiAKIC8qCiAg
KiBBbGwgcG9sbCB0dyBzaG91bGQgZ28gdGhyb3VnaCB0aGlzLiBDaGVja3MgZm9yIHBvbGwg
ZXZlbnRzLCBtYW5hZ2VzCiAgKiByZWZlcmVuY2VzLCBkb2VzIHJld2FpdCwgZXRjLgogICoK
LSAqIFJldHVybnMgYSBuZWdhdGl2ZSBlcnJvciBvbiBmYWlsdXJlLiBJT1VfUE9MTF9OT19B
Q1RJT04gd2hlbiBubyBhY3Rpb24gcmVxdWlyZSwKLSAqIHdoaWNoIGlzIGVpdGhlciBzcHVy
aW91cyB3YWtldXAgb3IgbXVsdGlzaG90IENRRSBpcyBzZXJ2ZWQuCi0gKiBJT1VfUE9MTF9E
T05FIHdoZW4gaXQncyBkb25lIHdpdGggdGhlIHJlcXVlc3QsIHRoZW4gdGhlIG1hc2sgaXMg
c3RvcmVkIGluIHJlcS0+Y3FlLnJlcy4KLSAqIElPVV9QT0xMX1JFTU9WRV9QT0xMX1VTRV9S
RVMgaW5kaWNhdGVzIHRvIHJlbW92ZSBtdWx0aXNob3QgcG9sbCBhbmQgdGhhdCB0aGUgcmVz
dWx0Ci0gKiBpcyBzdG9yZWQgaW4gcmVxLT5jcWUuCisgKiBSZXR1cm5zIGEgbmVnYXRpdmUg
ZXJyb3Igb24gZmFpbHVyZS4gSU9VX1BPTExfTk9fQUNUSU9OIHdoZW4gbm8gYWN0aW9uCisg
KiByZXF1aXJlLCB3aGljaCBpcyBlaXRoZXIgc3B1cmlvdXMgd2FrZXVwIG9yIG11bHRpc2hv
dCBDUUUgaXMgc2VydmVkLgorICogSU9VX1BPTExfRE9ORSB3aGVuIGl0J3MgZG9uZSB3aXRo
IHRoZSByZXF1ZXN0LCB0aGVuIHRoZSBtYXNrIGlzIHN0b3JlZCBpbgorICogcmVxLT5jcWUu
cmVzLiBJT1VfUE9MTF9SRU1PVkVfUE9MTF9VU0VfUkVTIGluZGljYXRlcyB0byByZW1vdmUg
bXVsdGlzaG90CisgKiBwb2xsIGFuZCB0aGF0IHRoZSByZXN1bHQgaXMgc3RvcmVkIGluIHJl
cS0+Y3FlLgogICovCiBzdGF0aWMgaW50IGlvX3BvbGxfY2hlY2tfZXZlbnRzKHN0cnVjdCBp
b19raW9jYiAqcmVxLCBib29sICpsb2NrZWQpCiB7CiAJc3RydWN0IGlvX3JpbmdfY3R4ICpj
dHggPSByZXEtPmN0eDsKLQlpbnQgdiwgcmV0OworCWludCB2OwogCiAJLyogcmVxLT50YXNr
ID09IGN1cnJlbnQgaGVyZSwgY2hlY2tpbmcgUEZfRVhJVElORyBpcyBzYWZlICovCiAJaWYg
KHVubGlrZWx5KHJlcS0+dGFzay0+ZmxhZ3MgJiBQRl9FWElUSU5HKSkKQEAgLTI3NCwxMCAr
Mjc1LDE1IEBAIHN0YXRpYyBpbnQgaW9fcG9sbF9jaGVja19ldmVudHMoc3RydWN0IGlvX2tp
b2NiICpyZXEsIGJvb2wgKmxvY2tlZCkKIAkJaWYgKCFyZXEtPmNxZS5yZXMpIHsKIAkJCXN0
cnVjdCBwb2xsX3RhYmxlX3N0cnVjdCBwdCA9IHsgLl9rZXkgPSByZXEtPmFwb2xsX2V2ZW50
cyB9OwogCQkJcmVxLT5jcWUucmVzID0gdmZzX3BvbGwocmVxLT5maWxlLCAmcHQpICYgcmVx
LT5hcG9sbF9ldmVudHM7CisJCQkvKgorCQkJICogV2UgZ290IHdva2VuIHdpdGggYSBtYXNr
LCBidXQgc29tZW9uZSBlbHNlIGdvdCB0bworCQkJICogaXQgZmlyc3QuIFRoZSBhYm92ZSB2
ZnNfcG9sbCgpIGRvZXNuJ3QgYWRkIHVzIGJhY2sKKwkJCSAqIHRvIHRoZSB3YWl0cXVldWUs
IHNvIGlmIHdlIGdldCBub3RoaW5nIGJhY2ssIHdlCisJCQkgKiBzaG91bGQgYmUgc2FmZSBh
bmQgYXR0ZW1wdCBhIHJlaXNzdWUuCisJCQkgKi8KKwkJCWlmICh1bmxpa2VseSghcmVxLT5j
cWUucmVzKSkKKwkJCQlyZXR1cm4gSU9VX1BPTExfUkVJU1NVRTsKIAkJfQotCi0JCWlmICgo
dW5saWtlbHkoIXJlcS0+Y3FlLnJlcykpKQotCQkJY29udGludWU7CiAJCWlmIChyZXEtPmFw
b2xsX2V2ZW50cyAmIEVQT0xMT05FU0hPVCkKIAkJCXJldHVybiBJT1VfUE9MTF9ET05FOwog
CQlpZiAoaW9faXNfdXJpbmdfZm9wcyhyZXEtPmZpbGUpKQpAQCAtMjk0LDcgKzMwMCw3IEBA
IHN0YXRpYyBpbnQgaW9fcG9sbF9jaGVja19ldmVudHMoc3RydWN0IGlvX2tpb2NiICpyZXEs
IGJvb2wgKmxvY2tlZCkKIAkJCQlyZXR1cm4gSU9VX1BPTExfUkVNT1ZFX1BPTExfVVNFX1JF
UzsKIAkJCX0KIAkJfSBlbHNlIHsKLQkJCXJldCA9IGlvX3BvbGxfaXNzdWUocmVxLCBsb2Nr
ZWQpOworCQkJaW50IHJldCA9IGlvX3BvbGxfaXNzdWUocmVxLCBsb2NrZWQpOwogCQkJaWYg
KHJldCA9PSBJT1VfU1RPUF9NVUxUSVNIT1QpCiAJCQkJcmV0dXJuIElPVV9QT0xMX1JFTU9W
RV9QT0xMX1VTRV9SRVM7CiAJCQlpZiAocmV0IDwgMCkKQEAgLTMyNSw2ICszMzEsMTEgQEAg
c3RhdGljIHZvaWQgaW9fcG9sbF90YXNrX2Z1bmMoc3RydWN0IGlvX2tpb2NiICpyZXEsIGJv
b2wgKmxvY2tlZCkKIAlpZiAocmV0ID09IElPVV9QT0xMX0RPTkUpIHsKIAkJc3RydWN0IGlv
X3BvbGwgKnBvbGwgPSBpb19raW9jYl90b19jbWQocmVxLCBzdHJ1Y3QgaW9fcG9sbCk7CiAJ
CXJlcS0+Y3FlLnJlcyA9IG1hbmdsZV9wb2xsKHJlcS0+Y3FlLnJlcyAmIHBvbGwtPmV2ZW50
cyk7CisJfSBlbHNlIGlmIChyZXQgPT0gSU9VX1BPTExfUkVJU1NVRSkgeworCQlpb19wb2xs
X3JlbW92ZV9lbnRyaWVzKHJlcSk7CisJCWlvX3BvbGxfdHdfaGFzaF9lamVjdChyZXEsIGxv
Y2tlZCk7CisJCWlvX3JlcV90YXNrX3N1Ym1pdChyZXEsIGxvY2tlZCk7CisJCXJldHVybjsK
IAl9IGVsc2UgaWYgKHJldCAhPSBJT1VfUE9MTF9SRU1PVkVfUE9MTF9VU0VfUkVTKSB7CiAJ
CXJlcS0+Y3FlLnJlcyA9IHJldDsKIAkJcmVxX3NldF9mYWlsKHJlcSk7CkBAIC0zNTAsNyAr
MzYxLDcgQEAgc3RhdGljIHZvaWQgaW9fYXBvbGxfdGFza19mdW5jKHN0cnVjdCBpb19raW9j
YiAqcmVxLCBib29sICpsb2NrZWQpCiAKIAlpZiAocmV0ID09IElPVV9QT0xMX1JFTU9WRV9Q
T0xMX1VTRV9SRVMpCiAJCWlvX3JlcV9jb21wbGV0ZV9wb3N0KHJlcSk7Ci0JZWxzZSBpZiAo
cmV0ID09IElPVV9QT0xMX0RPTkUpCisJZWxzZSBpZiAocmV0ID09IElPVV9QT0xMX0RPTkUg
fHwgcmV0ID09IElPVV9QT0xMX1JFSVNTVUUpCiAJCWlvX3JlcV90YXNrX3N1Ym1pdChyZXEs
IGxvY2tlZCk7CiAJZWxzZQogCQlpb19yZXFfY29tcGxldGVfZmFpbGVkKHJlcSwgcmV0KTsK
LS0gCjIuMzkuMAoK

--------------jEKUZsmD0Ln9aJBojpb1QHE3--
