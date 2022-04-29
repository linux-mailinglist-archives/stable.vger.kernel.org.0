Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4F23514139
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 06:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236955AbiD2ETs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 00:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiD2ETr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 00:19:47 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3CDBABA8
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 21:16:31 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id w17so12458702ybh.9
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 21:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nGzfdVpGDpJKmD7ydQ+zCgF8MageoM1asOVhY7egrwU=;
        b=acz6dehnCZmHEav7i6ZIu3iQ5o/fj2OhASjaB26y0KP3hB7bXqUHbsaCxKE6ll1Ywm
         hb3BAzsyszCWFKa+x5uyypRby6cNFc8tTCe045AWJMKqCL4ddaWq4wRtaFP6sWMpDUPV
         uf+kFf4AnD+y5VTuKC+sPtf7//WkgNm6F7tWDhSrhVmPnHI/SIAyk+YsLYEve2KS62tv
         q80yg4haFHCg1vjuwEX/81HM5xXTDReBsszeb7ECYHjsFU5FVfqx2AYxD/b3XU38IVzA
         JK8b6Of+M+DjUpDyKSPSVazVb18q3Mc40S6t+EZzMdBy61odf+hwGzg791QOmNYN5ZDJ
         xxaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nGzfdVpGDpJKmD7ydQ+zCgF8MageoM1asOVhY7egrwU=;
        b=P0P6ZjPpbx98qnIeuvX1WbTlV20d9aWOy2QVJtkKh0W9bqUPn3gGUj4pqU/tFAU9s4
         3JPP8KoBhmXNJLRtiWdWrcajS24Zka4OtipDpb/IZa6A8D8zIXazL7FtzGH9uPsMzJsb
         P1ZAj6ijy+cQ2Y1BUlVEUcw3E3wCd8UlpKGMEb1Hr+QvJbTxM0gVX9slVHX/EYF4oXvg
         pGN6q8GoH/vROnc6ySRBSTLD8G/Ltqj/VehNlyGBw5MTcYiSvLRw1DyY75xaZpZl7OPm
         XIvCPopqhS3hiOR3sW5NSA/eNrvm9Gz8h7lWopeiz4uGdODOpp2EcADPodAwy8b8BGQ3
         nQKA==
X-Gm-Message-State: AOAM532tL/1WPgeXda8oXBjpPMQtruyRFBoSovTXxoArPxBEzYNGVd50
        h4Le44BDCCIPiYhKwAwMNAmO3QztP3ebTEqOK/llFQ==
X-Google-Smtp-Source: ABdhPJxWTucAyMUVugcAznFicYkHeXMvhcXkfKzR4asUrHTIicmRUXXUnUAiJ2ivkbt9EFOM4lSD3XV1E5H07Hio7+A=
X-Received: by 2002:a05:6902:526:b0:648:506b:1a0c with SMTP id
 y6-20020a056902052600b00648506b1a0cmr23034127ybs.254.1651205790389; Thu, 28
 Apr 2022 21:16:30 -0700 (PDT)
MIME-Version: 1.0
References: <165116018052255@kroah.com>
In-Reply-To: <165116018052255@kroah.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Fri, 29 Apr 2022 12:15:54 +0800
Message-ID: <CAMZfGtXuQr77H2juiJTK5ZhP6tHFj4fNLDFZ82VBOfknnoa3pg@mail.gmail.com>
Subject: Re: [External] FAILED: patch "[PATCH] mm: kfence: fix objcgs vector
 allocation" failed to apply to 5.15-stable tree
To:     gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, duanxiongchun@bytedance.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        roman.gushchin@linux.dev, torvalds@linux-foundation.org,
        stable@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000096be6b05ddc34eb0"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--00000000000096be6b05ddc34eb0
Content-Type: text/plain; charset="UTF-8"

On Thu, Apr 28, 2022 at 11:36 PM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>

I have fixed all conflicts and the attachment is the new patch for 5.15.

Thanks.

--00000000000096be6b05ddc34eb0
Content-Type: application/octet-stream; 
	name="0001-mm-kfence-fix-objcgs-vector-allocation.patch"
Content-Disposition: attachment; 
	filename="0001-mm-kfence-fix-objcgs-vector-allocation.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l2jx6ojg0>
X-Attachment-Id: f_l2jx6ojg0

RnJvbSA5OWU3OGIyZTE0ZWNiZmVkZjNlOWIxYzZmNDdiYzk1ODdiMTI5OTg1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNdWNodW4gU29uZyA8c29uZ211Y2h1bkBieXRlZGFuY2UuY29t
PgpEYXRlOiBTdW4sIDI3IE1hciAyMDIyIDEwOjM5OjA0ICswODAwClN1YmplY3Q6IFtQQVRDSF0g
bW06IGtmZW5jZTogZml4IG9iamNncyB2ZWN0b3IgYWxsb2NhdGlvbgoKSWYgdGhlIGtmZW5jZSBv
YmplY3QgaXMgYWxsb2NhdGVkIHRvIGJlIHVzZWQgZm9yIG9iamVjdHMgdmVjdG9yLCB0aGVuCnRo
aXMgc2xvdCBvZiB0aGUgcG9vbCBldmVudHVhbGx5IGJlaW5nIG9jY3VwaWVkIHBlcm1hbmVudGx5
IHNpbmNlCnRoZSB2ZWN0b3IgaXMgbmV2ZXIgZnJlZWQuICBUaGUgc29sdXRpb25zIGNvdWxkIGJl
IDEpIGZyZWVpbmcgdmVjdG9yCndoZW4gdGhlIGtmZW5jZSBvYmplY3QgaXMgZnJlZWQgb3IgMikg
YWxsb2NhdGluZyBhbGwgdmVjdG9ycyBzdGF0aWNhbGx5LgpTaW5jZSB0aGUgbWVtb3J5IGNvbnN1
bXB0aW9uIG9mIG9iamVjdCB2ZWN0b3JzIGlzIGxvdywgaXQgaXMgYmV0dGVyIHRvCmNob3NlIDIp
IHRvIGZpeCB0aGUgaXNzdWUgYW5kIGl0IGlzIGFsc28gY2FuIHJlZHVjZSBvdmVyaGVhZCBvZiB2
ZWN0b3JzCmFsbG9jYXRpbmcgaW4gdGhlIGZ1dHVyZS4KCkZpeGVzOiBkM2ZiNDVmMzcwZDkgKCJt
bSwga2ZlbmNlOiBpbnNlcnQgS0ZFTkNFIGhvb2tzIGZvciBTTEFCIikKU2lnbmVkLW9mZi1ieTog
TXVjaHVuIFNvbmcgPHNvbmdtdWNodW5AYnl0ZWRhbmNlLmNvbT4KLS0tCiBtbS9rZmVuY2UvY29y
ZS5jICAgfCAxMSArKysrKysrKysrLQogbW0va2ZlbmNlL2tmZW5jZS5oIHwgIDMgKysrCiAyIGZp
bGVzIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQg
YS9tbS9rZmVuY2UvY29yZS5jIGIvbW0va2ZlbmNlL2NvcmUuYwppbmRleCA4NDU1NWI4MjMzZWYu
Ljg2M2YyZjdjYzAzNiAxMDA2NDQKLS0tIGEvbW0va2ZlbmNlL2NvcmUuYworKysgYi9tbS9rZmVu
Y2UvY29yZS5jCkBAIC00NDgsNiArNDQ4LDggQEAgc3RhdGljIGJvb2wgX19pbml0IGtmZW5jZV9p
bml0X3Bvb2wodm9pZCkKIAkgKiBlbnRlcnMgX19zbGFiX2ZyZWUoKSBzbG93LXBhdGguCiAJICov
CiAJZm9yIChpID0gMDsgaSA8IEtGRU5DRV9QT09MX1NJWkUgLyBQQUdFX1NJWkU7IGkrKykgewor
CQlzdHJ1Y3QgcGFnZSAqcGFnZSA9ICZwYWdlc1tpXTsKKwogCQlpZiAoIWkgfHwgKGkgJSAyKSkK
IAkJCWNvbnRpbnVlOwogCkBAIC00NTUsNyArNDU3LDExIEBAIHN0YXRpYyBib29sIF9faW5pdCBr
ZmVuY2VfaW5pdF9wb29sKHZvaWQpCiAJCWlmIChXQVJOX09OKGNvbXBvdW5kX2hlYWQoJnBhZ2Vz
W2ldKSAhPSAmcGFnZXNbaV0pKQogCQkJZ290byBlcnI7CiAKLQkJX19TZXRQYWdlU2xhYigmcGFn
ZXNbaV0pOworCQlfX1NldFBhZ2VTbGFiKHBhZ2UpOworI2lmZGVmIENPTkZJR19NRU1DRworCQlw
YWdlLT5tZW1jZ19kYXRhID0gKHVuc2lnbmVkIGxvbmcpJmtmZW5jZV9tZXRhZGF0YVtpIC8gMiAt
IDFdLm9iamNnIHwKKwkJCQkgICBNRU1DR19EQVRBX09CSkNHUzsKKyNlbmRpZgogCX0KIAogCS8q
CkBAIC04MDQsNiArODEwLDkgQEAgdm9pZCBfX2tmZW5jZV9mcmVlKHZvaWQgKmFkZHIpCiB7CiAJ
c3RydWN0IGtmZW5jZV9tZXRhZGF0YSAqbWV0YSA9IGFkZHJfdG9fbWV0YWRhdGEoKHVuc2lnbmVk
IGxvbmcpYWRkcik7CiAKKyNpZmRlZiBDT05GSUdfTUVNQ0cKKwlLRkVOQ0VfV0FSTl9PTihtZXRh
LT5vYmpjZyk7CisjZW5kaWYKIAkvKgogCSAqIElmIHRoZSBvYmplY3RzIG9mIHRoZSBjYWNoZSBh
cmUgU0xBQl9UWVBFU0FGRV9CWV9SQ1UsIGRlZmVyIGZyZWVpbmcKIAkgKiB0aGUgb2JqZWN0LCBh
cyB0aGUgb2JqZWN0IHBhZ2UgbWF5IGJlIHJlY3ljbGVkIGZvciBvdGhlci10eXBlZApkaWZmIC0t
Z2l0IGEvbW0va2ZlbmNlL2tmZW5jZS5oIGIvbW0va2ZlbmNlL2tmZW5jZS5oCmluZGV4IGMxZjIz
YzYxZTVmOS4uYzgzZWE3NTlhOTFhIDEwMDY0NAotLS0gYS9tbS9rZmVuY2Uva2ZlbmNlLmgKKysr
IGIvbW0va2ZlbmNlL2tmZW5jZS5oCkBAIC04Nyw2ICs4Nyw5IEBAIHN0cnVjdCBrZmVuY2VfbWV0
YWRhdGEgewogCS8qIEFsbG9jYXRpb24gYW5kIGZyZWUgc3RhY2sgaW5mb3JtYXRpb24uICovCiAJ
c3RydWN0IGtmZW5jZV90cmFjayBhbGxvY190cmFjazsKIAlzdHJ1Y3Qga2ZlbmNlX3RyYWNrIGZy
ZWVfdHJhY2s7CisjaWZkZWYgQ09ORklHX01FTUNHCisJc3RydWN0IG9ial9jZ3JvdXAgKm9iamNn
OworI2VuZGlmCiB9OwogCiBleHRlcm4gc3RydWN0IGtmZW5jZV9tZXRhZGF0YSBrZmVuY2VfbWV0
YWRhdGFbQ09ORklHX0tGRU5DRV9OVU1fT0JKRUNUU107Ci0tIAoyLjExLjAKCg==
--00000000000096be6b05ddc34eb0--
