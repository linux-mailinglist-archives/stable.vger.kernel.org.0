Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6BB71747DB
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 17:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbgB2QFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 11:05:15 -0500
Received: from mail-io1-f41.google.com ([209.85.166.41]:46433 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727164AbgB2QFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 11:05:15 -0500
Received: by mail-io1-f41.google.com with SMTP id x21so2433013iox.13
        for <stable@vger.kernel.org>; Sat, 29 Feb 2020 08:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=6Y8c6YQN63ibm+SbmIWwaHAalsPxYuO2BuhOlMSJxsI=;
        b=hLcXQGP80f7blAOrQyGMD5SPa4N0mksAhP7lY/ejNmDOZUJEuEwEQSmdRrQwa0k2et
         EeAkpIJNmNVNbQP/4XGXeZ1wuQu9EJOUGkfKY7Xz8X63nPeG63xq8UnaXB846KQjT0m0
         gIamvpw5AGIrmda/VWv/isJZhFYqysjBz2DnIcqYx0KW0tkEQSiZ0FSpNnFPYnjGKwqj
         vO7IVwG2Qh+IBr3HObdyUplquM6LJdYrxtP69NTwJl22Djtr9bAA4YTWu7R6TewVKODh
         g6p+xt1nTkJWZMkE77bFHzXgi9C71St9pp2ljWkkQVlZ39hdGhJXYChR6fnuXp3Bo6X1
         ehgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=6Y8c6YQN63ibm+SbmIWwaHAalsPxYuO2BuhOlMSJxsI=;
        b=HvqKp1GQXZ4+qfUDwthQi+jyuFDV0bBLsjKVGgWAeerW1Hs22BYyeI36efKiXgu9fx
         Yt+fG2o9tc3iDk7yWPpj+vZrZtlqzN7tq8Wgy+HEt5xAPyEOeOsNiOSsx4NaoZYQNr8b
         Nc7XBMCWwD5UwqIbOYKjO5trHKEpnJqJLR8wXSHO8e0acFbcjdG79q0UGyj8Gi26BpaE
         xIGN0iK820xo/MGGzTFEPcUNeMf7SQo6jTtUtCC+Png99+UwBiR5HOP0a7qazQ0cYBik
         hGtAc4fFMS0Wra1NmnOwas9YuwoMy+5l5MCUUUzf31abta3PTwr+dCqFP5S8pxzgm2QQ
         q9AQ==
X-Gm-Message-State: APjAAAWzxu4Bq5kDR4zId7bsKeQETHQR9UeB7EQl++9kVi8bdU7Kd77M
        poHM4aR8lxWe1GlgylVqXJx/nP6+n+y6uVSVatsbjT7fRkI=
X-Google-Smtp-Source: APXvYqyDeofg1dMIgsk9W6XlNKxobC3j4AsjsL4mu+w0z5/jd4dg2YxCuMLy/kNvOqlvmGXwqg+EJ7aq7WHSCgShTmo=
X-Received: by 2002:a02:5b8a:: with SMTP id g132mr7343346jab.78.1582992314329;
 Sat, 29 Feb 2020 08:05:14 -0800 (PST)
MIME-Version: 1.0
From:   Marian Klein <mkleinsoft@gmail.com>
Date:   Sat, 29 Feb 2020 16:05:03 +0000
Message-ID: <CAA0DKYrY8OmrQOKxShFSqBiBLdNn+pM4C_Lx3_FdVHpovVNg+w@mail.gmail.com>
Subject: hibernation s2disk fix patch for 5.4 and 5.5
To:     stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>
Content-Type: multipart/mixed; boundary="00000000000094331f059fb91e98"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--00000000000094331f059fb91e98
Content-Type: text/plain; charset="UTF-8"

Dear stable kernel team

I tested this on behalf of darrick.wong@oracle.com
I do not have push rights to your repo. I tried. Can you include it
for 5.4 and 5.5 ?

Comment from Darrick

This patch should make it so
that uswsusp can unlock the swap device prior to writing the memory
image to disk, and then lock it again when resuming.

Best regards and Thanks
Marian Klein

--00000000000094331f059fb91e98
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="hibernation_swap_write_protection_bug206713fix.patch"
Content-Disposition: attachment; 
	filename="hibernation_swap_write_protection_bug206713fix.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k77spacs0>
X-Attachment-Id: f_k77spacs0

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvc3dhcC5oIGIvaW5jbHVkZS9saW51eC9zd2FwLmgK
aW5kZXggMWU5OWY3YWMxZDdlLi5hZGQ5M2UyMDU4NTAgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGlu
dXgvc3dhcC5oCisrKyBiL2luY2x1ZGUvbGludXgvc3dhcC5oCkBAIC00NTgsNiArNDU4LDcgQEAg
ZXh0ZXJuIHZvaWQgc3dhcF9mcmVlKHN3cF9lbnRyeV90KTsKIGV4dGVybiB2b2lkIHN3YXBjYWNo
ZV9mcmVlX2VudHJpZXMoc3dwX2VudHJ5X3QgKmVudHJpZXMsIGludCBuKTsKIGV4dGVybiBpbnQg
ZnJlZV9zd2FwX2FuZF9jYWNoZShzd3BfZW50cnlfdCk7CiBleHRlcm4gaW50IHN3YXBfdHlwZV9v
ZihkZXZfdCwgc2VjdG9yX3QsIHN0cnVjdCBibG9ja19kZXZpY2UgKiopOworZXh0ZXJuIHZvaWQg
c3dhcF9yZWxvY2thbGwodm9pZCk7CiBleHRlcm4gdW5zaWduZWQgaW50IGNvdW50X3N3YXBfcGFn
ZXMoaW50LCBpbnQpOwogZXh0ZXJuIHNlY3Rvcl90IG1hcF9zd2FwX3BhZ2Uoc3RydWN0IHBhZ2Ug
Kiwgc3RydWN0IGJsb2NrX2RldmljZSAqKik7CiBleHRlcm4gc2VjdG9yX3Qgc3dhcGRldl9ibG9j
ayhpbnQsIHBnb2ZmX3QpOwpkaWZmIC0tZ2l0IGEva2VybmVsL3Bvd2VyL3VzZXIuYyBiL2tlcm5l
bC9wb3dlci91c2VyLmMKaW5kZXggNzc0Mzg5NTRjYzJiLi40NzY3MWRhYzc2MTUgMTAwNjQ0Ci0t
LSBhL2tlcm5lbC9wb3dlci91c2VyLmMKKysrIGIva2VybmVsL3Bvd2VyL3VzZXIuYwpAQCAtMjcx
LDYgKzI3MSw4IEBAIHN0YXRpYyBsb25nIHNuYXBzaG90X2lvY3RsKHN0cnVjdCBmaWxlICpmaWxw
LCB1bnNpZ25lZCBpbnQgY21kLAogCQkJYnJlYWs7CiAJCX0KIAkJZXJyb3IgPSBoaWJlcm5hdGlv
bl9yZXN0b3JlKGRhdGEtPnBsYXRmb3JtX3N1cHBvcnQpOworCQlpZiAoIWVycm9yKQorCQkJc3dh
cF9yZWxvY2thbGwoKTsKIAkJYnJlYWs7CiAKIAljYXNlIFNOQVBTSE9UX0ZSRUU6CkBAIC0zNzIs
MTAgKzM3NCwxNiBAQCBzdGF0aWMgbG9uZyBzbmFwc2hvdF9pb2N0bChzdHJ1Y3QgZmlsZSAqZmls
cCwgdW5zaWduZWQgaW50IGNtZCwKIAkJCSAqLwogCQkJc3dkZXYgPSBuZXdfZGVjb2RlX2Rldihz
d2FwX2FyZWEuZGV2KTsKIAkJCWlmIChzd2RldikgeworCQkJCXN0cnVjdCBibG9ja19kZXZpY2Ug
KmJkOwogCQkJCW9mZnNldCA9IHN3YXBfYXJlYS5vZmZzZXQ7Ci0JCQkJZGF0YS0+c3dhcCA9IHN3
YXBfdHlwZV9vZihzd2Rldiwgb2Zmc2V0LCBOVUxMKTsKKwkJCQlkYXRhLT5zd2FwID0gc3dhcF90
eXBlX29mKHN3ZGV2LCBvZmZzZXQsICZiZCk7CiAJCQkJaWYgKGRhdGEtPnN3YXAgPCAwKQogCQkJ
CQllcnJvciA9IC1FTk9ERVY7CisKKwkJCQlpbm9kZV9sb2NrKGJkLT5iZF9pbm9kZSk7CisJCQkJ
YmQtPmJkX2lub2RlLT5pX2ZsYWdzICY9IH5TX1NXQVBGSUxFOworCQkJCWlub2RlX3VubG9jayhi
ZC0+YmRfaW5vZGUpOworCQkJCWJkcHV0KGJkKTsKIAkJCX0gZWxzZSB7CiAJCQkJZGF0YS0+c3dh
cCA9IC0xOwogCQkJCWVycm9yID0gLUVJTlZBTDsKZGlmZiAtLWdpdCBhL21tL3N3YXBmaWxlLmMg
Yi9tbS9zd2FwZmlsZS5jCmluZGV4IGIyYTJlNDVjOWEzNi4uNDM5YmZiNzI2M2QzIDEwMDY0NAot
LS0gYS9tbS9zd2FwZmlsZS5jCisrKyBiL21tL3N3YXBmaWxlLmMKQEAgLTE3OTksNiArMTc5OSwz
MiBAQCBpbnQgc3dhcF90eXBlX29mKGRldl90IGRldmljZSwgc2VjdG9yX3Qgb2Zmc2V0LCBzdHJ1
Y3QgYmxvY2tfZGV2aWNlICoqYmRldl9wKQogCXJldHVybiAtRU5PREVWOwogfQogCisvKiBSZS1s
b2NrIHN3YXAgZGV2aWNlcyBhZnRlciByZXN1bWluZyBmcm9tIHVzZXJzcGFjZSBzdXNwZW5kLiAq
Lwordm9pZCBzd2FwX3JlbG9ja2FsbCh2b2lkKQoreworCWludCB0eXBlOworCisJc3Bpbl9sb2Nr
KCZzd2FwX2xvY2spOworCWZvciAodHlwZSA9IDA7IHR5cGUgPCBucl9zd2FwZmlsZXM7IHR5cGUr
KykgeworCQlzdHJ1Y3Qgc3dhcF9pbmZvX3N0cnVjdCAqc2lzID0gc3dhcF9pbmZvW3R5cGVdOwor
CQlzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2ID0gYmRncmFiKHNpcy0+YmRldik7CisKKwkJLyoK
KwkJICogdXN3c3VzcCBvbmx5IGtub3dzIGhvdyB0byBzdXNwZW5kIHRvIGJsb2NrIGRldmljZXMs
IHNvIHdlCisJCSAqIGNhbiBza2lwIHN3YXAgZmlsZXMuCisJCSAqLworCQlpZiAoIShzaXMtPmZs
YWdzICYgU1dQX1dSSVRFT0spIHx8CisJCSAgICAhKHNpcy0+ZmxhZ3MgJiBTV1BfQkxLREVWKSkK
KwkJCWNvbnRpbnVlOworCisJCWlub2RlX2xvY2soYmRldi0+YmRfaW5vZGUpOworCQliZGV2LT5i
ZF9pbm9kZS0+aV9mbGFncyB8PSBTX1NXQVBGSUxFOworCQlpbm9kZV91bmxvY2soYmRldi0+YmRf
aW5vZGUpOworCQliZHB1dChiZGV2KTsKKwl9CisJc3Bpbl91bmxvY2soJnN3YXBfbG9jayk7Cit9
CisKIC8qCiAgKiBHZXQgdGhlIChQQUdFX1NJWkUpIGJsb2NrIGNvcnJlc3BvbmRpbmcgdG8gZ2l2
ZW4gb2Zmc2V0IG9uIHRoZSBzd2FwZGV2CiAgKiBjb3JyZXNwb25kaW5nIHRvIGdpdmVuIGluZGV4
IGluIHN3YXBfaW5mbyAoc3dhcCB0eXBlKS4K
--00000000000094331f059fb91e98--
