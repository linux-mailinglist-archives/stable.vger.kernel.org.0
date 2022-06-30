Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52759562493
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 22:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237236AbiF3Up5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 16:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233355AbiF3Up4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 16:45:56 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7C645519
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 13:45:55 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 65so500378pfw.11
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 13:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject;
        bh=tgr0RLUCg3flF00hLox83MHFwZpkx1j+xKd0UwQf2uU=;
        b=lye6wBzHqAbW0dNFGfohsRh2zQVumXuGB20wvzQvc3QR9SBIU9xM4c/m+AifqNGNcM
         /PFFeGdenoO9DjxRU+yph4bU3lG/BO+Ef+ETP4Ml3/ua5H3zLFAgLf/qmvIgFnCpGCej
         zbuKBSrBqhRL/9dFvDHul642G2h1Sny6urvB/JymhoRPFiYnrAFL/f3I1kbrnz+Fjdp1
         5v1v/KSDT7cDLxSYmb1xcg+xBvQaB0CgjpZ43QKAYw0r1VPi52dgHIyuHpfn+LDzu0wm
         uHrJIlGcbZInGUCXiv4qZ/Eg1kqNvP2KpqXu55wjf5BcdfhySkigpkaR8wJYqACPn3OJ
         pEKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject;
        bh=tgr0RLUCg3flF00hLox83MHFwZpkx1j+xKd0UwQf2uU=;
        b=IgpuJfnKnLCJSS4XBMaWJAb+2likRefIlQ/SXuIWPi+BSz1wGiaAKCAUEBCr4Dngp2
         WLUuc8WNq9IjE4NOgY20gLgUpefgUAVNBMdNwQAv/cpzSI7CwifmD5HU3wFRh4MCSK4w
         mSYhLlEytqvN8092V+0bjkv1f4E4egbzymhSOOpJHwNaGsTAYUxuQtk+dfEP1PhV9kXM
         XjUWex4M2BvdtQpq8QvJPJL/ANk6EyYaAj5+LGfDd/lFph9W+s2rR3Pggf/ctRvhW8MI
         gewMqLxDyKZbeHs9taFnnfBG3koYge/I7tLJ6RslVkKJ6TwfcjXkcOjZ20KIN4VCoGq3
         iE/w==
X-Gm-Message-State: AJIora8AEO461Yv5PQ690pZwIZPBP+8MWHUtrUdn0R7ZQ2c4oz+tRvTh
        29hOiMaFUSxZ/zy9UxXRApZ1PDeS9I7Q4A==
X-Google-Smtp-Source: AGRyM1vz5DQa8BD7QsUtHAhP62lrrE4L+sbNv2RF/uqhSXp8ifWZFcHgugWcI6dS/hCriQ4452I/AA==
X-Received: by 2002:a63:924f:0:b0:40c:f2d4:27e8 with SMTP id s15-20020a63924f000000b0040cf2d427e8mr9481919pgn.255.1656621954678;
        Thu, 30 Jun 2022 13:45:54 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q21-20020aa79835000000b0051844a64d3dsm14167711pfl.25.2022.06.30.13.45.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 13:45:54 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------CMkxb2lW0S2zs1Gt05FacZQz"
Message-ID: <36e6d08d-89c0-99e3-a248-1ce79315de03@kernel.dk>
Date:   Thu, 30 Jun 2022 14:45:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: 5.18/15/10 backport
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------CMkxb2lW0S2zs1Gt05FacZQz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

Can you apply these three patches, one for each of the 5.10, 5.15, and
5.18 stable tree? Doesn't fix any issues of concern, just ensures that
we -EINVAL when invalid fields are set in the sqe for these opcodes.
This brings it up to par with 5.19 and newer.

Thanks!

-- 
Jens Axboe

--------------CMkxb2lW0S2zs1Gt05FacZQz
Content-Type: text/x-patch; charset=UTF-8;
 name="5.10-0001-io_uring-ensure-that-send-sendmsg-and-recv-recvmsg-c.patch"
Content-Disposition: attachment;
 filename*0="5.10-0001-io_uring-ensure-that-send-sendmsg-and-recv-recvmsg";
 filename*1="-c.patch"
Content-Transfer-Encoding: base64

RnJvbSAzMzg3ZTZjMWI3MjM3ODMyODM4MjJlOWRhMDgyNDMxNDdlNGMxZjM1IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IFRodSwgMzAgSnVuIDIwMjIgMTQ6NDQ6MTYgLTA2MDAKU3ViamVjdDogW1BBVENIXSBp
b191cmluZzogZW5zdXJlIHRoYXQgc2VuZC9zZW5kbXNnIGFuZCByZWN2L3JlY3Ztc2cgY2hl
Y2sKIHNxZS0+aW9wcmlvCgpjb21taXQgNzM5MTE0MjZhYWFhZGJhZTU0ZmE3MjM1OWIzM2E3
YjZhNTY5NDdkYiB1cHN0cmVhbS4KCkFsbCBvdGhlciBvcGNvZGVzIGNvcnJlY3RseSBjaGVj
ayBpZiB0aGlzIGlzIHNldCBhbmQgLUVJTlZBTCBpZiBpdCBpcwphbmQgdGhleSBkb24ndCBz
dXBwb3J0IHRoYXQgZmllbGQsIGZvciBzb21lIHJlYXNvbiB0aGUgdGhlc2Ugd2VyZQpmb3Jn
b3R0ZW4uCgpUaGlzIHdhcyB1bmlmaWVkIGEgYml0IGRpZmZlcmVudGx5IGluIHRoZSB1cHN0
cmVhbSB0cmVlLCBidXQgaGFkIHRoZQpzYW1lIGVmZmVjdCBhcyBtYWtpbmcgc3VyZSB3ZSBl
cnJvciBvbiB0aGlzIGZpZWxkLiBSYXRoZXIgdGhhbiBoYXZlCmEgcGFpbmZ1bCBiYWNrcG9y
dCBvZiB0aGUgdXBzdHJlYW0gY29tbWl0LCBqdXN0IGZpeHVwIHRoZSBtZW50aW9uZWQKb3Bj
b2Rlcy4KClNpZ25lZC1vZmYtYnk6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4KLS0t
CiBmcy9pb191cmluZy5jIHwgNCArKysrCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25z
KCspCgpkaWZmIC0tZ2l0IGEvZnMvaW9fdXJpbmcuYyBiL2ZzL2lvX3VyaW5nLmMKaW5kZXgg
MmUxMmRjYmM3YjBmLi4wMjNjM2ViMzRkY2MgMTAwNjQ0Ci0tLSBhL2ZzL2lvX3VyaW5nLmMK
KysrIGIvZnMvaW9fdXJpbmcuYwpAQCAtNDM2Niw2ICs0MzY2LDggQEAgc3RhdGljIGludCBp
b19zZW5kbXNnX3ByZXAoc3RydWN0IGlvX2tpb2NiICpyZXEsIGNvbnN0IHN0cnVjdCBpb191
cmluZ19zcWUgKnNxZSkKIAogCWlmICh1bmxpa2VseShyZXEtPmN0eC0+ZmxhZ3MgJiBJT1JJ
TkdfU0VUVVBfSU9QT0xMKSkKIAkJcmV0dXJuIC1FSU5WQUw7CisJaWYgKHVubGlrZWx5KHNx
ZS0+YWRkcjIgfHwgc3FlLT5zcGxpY2VfZmRfaW4gfHwgc3FlLT5pb3ByaW8pKQorCQlyZXR1
cm4gLUVJTlZBTDsKIAogCXNyLT5tc2dfZmxhZ3MgPSBSRUFEX09OQ0Uoc3FlLT5tc2dfZmxh
Z3MpOwogCXNyLT51bXNnID0gdTY0X3RvX3VzZXJfcHRyKFJFQURfT05DRShzcWUtPmFkZHIp
KTsKQEAgLTQ2MDEsNiArNDYwMyw4IEBAIHN0YXRpYyBpbnQgaW9fcmVjdm1zZ19wcmVwKHN0
cnVjdCBpb19raW9jYiAqcmVxLAogCiAJaWYgKHVubGlrZWx5KHJlcS0+Y3R4LT5mbGFncyAm
IElPUklOR19TRVRVUF9JT1BPTEwpKQogCQlyZXR1cm4gLUVJTlZBTDsKKwlpZiAodW5saWtl
bHkoc3FlLT5hZGRyMiB8fCBzcWUtPnNwbGljZV9mZF9pbiB8fCBzcWUtPmlvcHJpbykpCisJ
CXJldHVybiAtRUlOVkFMOwogCiAJc3ItPm1zZ19mbGFncyA9IFJFQURfT05DRShzcWUtPm1z
Z19mbGFncyk7CiAJc3ItPnVtc2cgPSB1NjRfdG9fdXNlcl9wdHIoUkVBRF9PTkNFKHNxZS0+
YWRkcikpOwotLSAKMi4zNS4xCgo=
--------------CMkxb2lW0S2zs1Gt05FacZQz
Content-Type: text/x-patch; charset=UTF-8;
 name="5.15-0001-io_uring-ensure-that-send-sendmsg-and-recv-recvmsg-c.patch"
Content-Disposition: attachment;
 filename*0="5.15-0001-io_uring-ensure-that-send-sendmsg-and-recv-recvmsg";
 filename*1="-c.patch"
Content-Transfer-Encoding: base64

RnJvbSAzYTA3NzNlYTFlM2IwOTJmNDk2NGMyNGM0MTg3MmY0M2EzNzM3YWY5IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IFRodSwgMzAgSnVuIDIwMjIgMTQ6NDI6MDUgLTA2MDAKU3ViamVjdDogW1BBVENIXSBp
b191cmluZzogZW5zdXJlIHRoYXQgc2VuZC9zZW5kbXNnIGFuZCByZWN2L3JlY3Ztc2cgY2hl
Y2sKIHNxZS0+aW9wcmlvCgpjb21taXQgNzM5MTE0MjZhYWFhZGJhZTU0ZmE3MjM1OWIzM2E3
YjZhNTY5NDdkYiB1cHN0cmVhbS4KCkFsbCBvdGhlciBvcGNvZGVzIGNvcnJlY3RseSBjaGVj
ayBpZiB0aGlzIGlzIHNldCBhbmQgLUVJTlZBTCBpZiBpdCBpcwphbmQgdGhleSBkb24ndCBz
dXBwb3J0IHRoYXQgZmllbGQsIGZvciBzb21lIHJlYXNvbiB0aGUgdGhlc2Ugd2VyZQpmb3Jn
b3R0ZW4uCgpUaGlzIHdhcyB1bmlmaWVkIGEgYml0IGRpZmZlcmVudGx5IGluIHRoZSB1cHN0
cmVhbSB0cmVlLCBidXQgaGFkIHRoZQpzYW1lIGVmZmVjdCBhcyBtYWtpbmcgc3VyZSB3ZSBl
cnJvciBvbiB0aGlzIGZpZWxkLiBSYXRoZXIgdGhhbiBoYXZlCmEgcGFpbmZ1bCBiYWNrcG9y
dCBvZiB0aGUgdXBzdHJlYW0gY29tbWl0LCBqdXN0IGZpeHVwIHRoZSBtZW50aW9uZWQKb3Bj
b2Rlcy4KClNpZ25lZC1vZmYtYnk6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4KLS0t
CiBmcy9pb191cmluZy5jIHwgNCArKysrCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25z
KCspCgpkaWZmIC0tZ2l0IGEvZnMvaW9fdXJpbmcuYyBiL2ZzL2lvX3VyaW5nLmMKaW5kZXgg
NWZjM2E2MmVhZTcyLi40NjNjNjBmZjhkZmIgMTAwNjQ0Ci0tLSBhL2ZzL2lvX3VyaW5nLmMK
KysrIGIvZnMvaW9fdXJpbmcuYwpAQCAtNDc5Myw2ICs0NzkzLDggQEAgc3RhdGljIGludCBp
b19zZW5kbXNnX3ByZXAoc3RydWN0IGlvX2tpb2NiICpyZXEsIGNvbnN0IHN0cnVjdCBpb191
cmluZ19zcWUgKnNxZSkKIAogCWlmICh1bmxpa2VseShyZXEtPmN0eC0+ZmxhZ3MgJiBJT1JJ
TkdfU0VUVVBfSU9QT0xMKSkKIAkJcmV0dXJuIC1FSU5WQUw7CisJaWYgKHVubGlrZWx5KHNx
ZS0+YWRkcjIgfHwgc3FlLT5maWxlX2luZGV4IHx8IHNxZS0+aW9wcmlvKSkKKwkJcmV0dXJu
IC1FSU5WQUw7CiAKIAlzci0+dW1zZyA9IHU2NF90b191c2VyX3B0cihSRUFEX09OQ0Uoc3Fl
LT5hZGRyKSk7CiAJc3ItPmxlbiA9IFJFQURfT05DRShzcWUtPmxlbik7CkBAIC01MDE0LDYg
KzUwMTYsOCBAQCBzdGF0aWMgaW50IGlvX3JlY3Ztc2dfcHJlcChzdHJ1Y3QgaW9fa2lvY2Ig
KnJlcSwgY29uc3Qgc3RydWN0IGlvX3VyaW5nX3NxZSAqc3FlKQogCiAJaWYgKHVubGlrZWx5
KHJlcS0+Y3R4LT5mbGFncyAmIElPUklOR19TRVRVUF9JT1BPTEwpKQogCQlyZXR1cm4gLUVJ
TlZBTDsKKwlpZiAodW5saWtlbHkoc3FlLT5hZGRyMiB8fCBzcWUtPmZpbGVfaW5kZXggfHwg
c3FlLT5pb3ByaW8pKQorCQlyZXR1cm4gLUVJTlZBTDsKIAogCXNyLT51bXNnID0gdTY0X3Rv
X3VzZXJfcHRyKFJFQURfT05DRShzcWUtPmFkZHIpKTsKIAlzci0+bGVuID0gUkVBRF9PTkNF
KHNxZS0+bGVuKTsKLS0gCjIuMzUuMQoK
--------------CMkxb2lW0S2zs1Gt05FacZQz
Content-Type: text/x-patch; charset=UTF-8;
 name="5.18-0001-io_uring-ensure-that-send-sendmsg-and-recv-recvmsg-c.patch"
Content-Disposition: attachment;
 filename*0="5.18-0001-io_uring-ensure-that-send-sendmsg-and-recv-recvmsg";
 filename*1="-c.patch"
Content-Transfer-Encoding: base64

RnJvbSAyZmY0ZWYzNGMzZTFiZDZhNWFiN2E5NTZhZTk4Y2I5YjZhZTBhYWM4IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IFRodSwgMzAgSnVuIDIwMjIgMTQ6Mzg6NDUgLTA2MDAKU3ViamVjdDogW1BBVENIXSBp
b191cmluZzogZW5zdXJlIHRoYXQgc2VuZC9zZW5kbXNnIGFuZCByZWN2L3JlY3Ztc2cgY2hl
Y2sKIHNxZS0+aW9wcmlvCgpjb21taXQgNzM5MTE0MjZhYWFhZGJhZTU0ZmE3MjM1OWIzM2E3
YjZhNTY5NDdkYiB1cHN0cmVhbS4KCkFsbCBvdGhlciBvcGNvZGVzIGNvcnJlY3RseSBjaGVj
ayBpZiB0aGlzIGlzIHNldCBhbmQgLUVJTlZBTCBpZiBpdCBpcwphbmQgdGhleSBkb24ndCBz
dXBwb3J0IHRoYXQgZmllbGQsIGZvciBzb21lIHJlYXNvbiB0aGUgdGhlc2Ugd2VyZQpmb3Jn
b3R0ZW4uCgpUaGlzIHdhcyB1bmlmaWVkIGEgYml0IGRpZmZlcmVudGx5IGluIHRoZSB1cHN0
cmVhbSB0cmVlLCBidXQgaGFkIHRoZQpzYW1lIGVmZmVjdCBhcyBtYWtpbmcgc3VyZSB3ZSBl
cnJvciBvbiB0aGlzIGZpZWxkLiBSYXRoZXIgdGhhbiBoYXZlCmEgcGFpbmZ1bCBiYWNrcG9y
dCBvZiB0aGUgdXBzdHJlYW0gY29tbWl0LCBqdXN0IGZpeHVwIHRoZSBtZW50aW9uZWQKb3Bj
b2Rlcy4KClNpZ25lZC1vZmYtYnk6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4KLS0t
CiBmcy9pb191cmluZy5jIHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2lvX3VyaW5nLmMgYi9mcy9p
b191cmluZy5jCmluZGV4IDNkMTIzY2EwMjhjOS4uODk1MGI0NDM4OTFmIDEwMDY0NAotLS0g
YS9mcy9pb191cmluZy5jCisrKyBiL2ZzL2lvX3VyaW5nLmMKQEAgLTUyNTIsNyArNTI1Miw3
IEBAIHN0YXRpYyBpbnQgaW9fc2VuZG1zZ19wcmVwKHN0cnVjdCBpb19raW9jYiAqcmVxLCBj
b25zdCBzdHJ1Y3QgaW9fdXJpbmdfc3FlICpzcWUpCiAKIAlpZiAodW5saWtlbHkocmVxLT5j
dHgtPmZsYWdzICYgSU9SSU5HX1NFVFVQX0lPUE9MTCkpCiAJCXJldHVybiAtRUlOVkFMOwot
CWlmICh1bmxpa2VseShzcWUtPmFkZHIyIHx8IHNxZS0+ZmlsZV9pbmRleCkpCisJaWYgKHVu
bGlrZWx5KHNxZS0+YWRkcjIgfHwgc3FlLT5maWxlX2luZGV4IHx8IHNxZS0+aW9wcmlvKSkK
IAkJcmV0dXJuIC1FSU5WQUw7CiAKIAlzci0+dW1zZyA9IHU2NF90b191c2VyX3B0cihSRUFE
X09OQ0Uoc3FlLT5hZGRyKSk7CkBAIC01NDY1LDcgKzU0NjUsNyBAQCBzdGF0aWMgaW50IGlv
X3JlY3Ztc2dfcHJlcChzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwgY29uc3Qgc3RydWN0IGlvX3Vy
aW5nX3NxZSAqc3FlKQogCiAJaWYgKHVubGlrZWx5KHJlcS0+Y3R4LT5mbGFncyAmIElPUklO
R19TRVRVUF9JT1BPTEwpKQogCQlyZXR1cm4gLUVJTlZBTDsKLQlpZiAodW5saWtlbHkoc3Fl
LT5hZGRyMiB8fCBzcWUtPmZpbGVfaW5kZXgpKQorCWlmICh1bmxpa2VseShzcWUtPmFkZHIy
IHx8IHNxZS0+ZmlsZV9pbmRleCB8fCBzcWUtPmlvcHJpbykpCiAJCXJldHVybiAtRUlOVkFM
OwogCiAJc3ItPnVtc2cgPSB1NjRfdG9fdXNlcl9wdHIoUkVBRF9PTkNFKHNxZS0+YWRkcikp
OwotLSAKMi4zNS4xCgo=

--------------CMkxb2lW0S2zs1Gt05FacZQz--
