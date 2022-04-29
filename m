Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4FC5143A4
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 10:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355395AbiD2IKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 04:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351618AbiD2IKy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 04:10:54 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB263BC85B
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 01:07:36 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2f7c424c66cso77697367b3.1
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 01:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IZ2e70iUD20mfmneeIo+rDt6KC1Pg07wLQCSyf6Qzr4=;
        b=VXYm7ZTx2ZuvZ35wCMO+vSQ9vACiZnQ6rGxKY9qybReP/8nw45VL29ibTtPDJ+mpKk
         OsjzLtuOqYdgkdRMbli4legKQAPSbGNnUartJXWf9iFvy4LKrXUqwhNujfwk9HPeZfiT
         Y5RW955BQ9DtXtdFBYreyaDh6e6P+lwq2qVQqGuJ2YawTQI7n6yreqUqHdHgs+UraEAY
         d409XFN7nIISvjSD9A0h1EGz4JTh8V1c5ZVySqtYousWoInQEdUKDbWoRQ4aguXILU60
         hXsjsYED6fciIW1yCrYundErhhxcGRqiOmFO+Rh5bmShjzPyDSfT7WV2dZNj+6aDd9Ka
         nVBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IZ2e70iUD20mfmneeIo+rDt6KC1Pg07wLQCSyf6Qzr4=;
        b=HKw1lrMnt5+ev05j7z6GOAu6Vt60neV4e9owHgfIs2WV2V+XW/Y2kPjcANmpeFI+dV
         G81f272GmJR8AUlJQa2lgRwo0UMdgQOhdkyaw3CFIZ4WOB4+psIgsMbhb4MQHL02PnDV
         BqI5M9VvrOO34CXzVOjwmQmmiC4FTXMf9hLxgCMRq6nTLlrbOrEGEBYWuC15JWwN4HOt
         DsT5efJzOhnVVqWGD20UmOLY8nO5fRTVzZjRS97pQ5Uwjt5ftGYtpW/eLlABafE+/2sR
         jCXCFuF02LwUfZWI8A0zll3F5tfGn5q/2etFW6FW4aT1nTYcxh6Blb7Jw740e8TB1DQi
         Hk5Q==
X-Gm-Message-State: AOAM533uyGX0eNj1zqsnX6g8KO/zad7CVrqsw4d/8fyK3WdXvLMVdLtc
        DiIFuatM3ulvJX5dGLt/U+TuBTy5oSbUBEWy1SyTQw==
X-Google-Smtp-Source: ABdhPJyLituefmAs2YL34CcrRDdaiJCQVZHw+5afrrFCuSE0MrIwnqLp0yULJx1QhFzL1cBayS5JnpuK2f5mxJcuVME=
X-Received: by 2002:a81:1f84:0:b0:2f8:6138:de59 with SMTP id
 f126-20020a811f84000000b002f86138de59mr9144743ywf.31.1651219656032; Fri, 29
 Apr 2022 01:07:36 -0700 (PDT)
MIME-Version: 1.0
References: <165116018052255@kroah.com> <CAMZfGtXuQr77H2juiJTK5ZhP6tHFj4fNLDFZ82VBOfknnoa3pg@mail.gmail.com>
 <YmuPZQLKLfV3X6cW@elver.google.com>
In-Reply-To: <YmuPZQLKLfV3X6cW@elver.google.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Fri, 29 Apr 2022 16:06:59 +0800
Message-ID: <CAMZfGtVOyUW0x1Hp689tV=Sr2O=H=jWRFpyJyRxVi5mHb=x8xA@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] mm: kfence: fix objcgs vector allocation"
 failed to apply to 5.15-stable tree
To:     Marco Elver <elver@google.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Xiongchun duan <duanxiongchun@bytedance.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux- stable <stable@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000000b9e3305ddc68925"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--0000000000000b9e3305ddc68925
Content-Type: text/plain; charset="UTF-8"

On Fri, Apr 29, 2022 at 3:10 PM Marco Elver <elver@google.com> wrote:
>
> On Fri, Apr 29, 2022 at 12:15PM +0800, Muchun Song wrote:
> > On Thu, Apr 28, 2022 at 11:36 PM <gregkh@linuxfoundation.org> wrote:
> > >
> > >
> > > The patch below does not apply to the 5.15-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > >
> >
> > I have fixed all conflicts and the attachment is the new patch for 5.15.
> >
> > Thanks.
>
> I wanted to test, but unfortunately this doesn't apply to 5.15.36.

My bad. I was based on v5.15.33. I have made a new version
for v5.15.36 (see attachment) and tested it.

Thanks.

--0000000000000b9e3305ddc68925
Content-Type: application/octet-stream; 
	name="0001-mm-kfence-fix-objcgs-vector-allocation.patch"
Content-Disposition: attachment; 
	filename="0001-mm-kfence-fix-objcgs-vector-allocation.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l2k5fdpt0>
X-Attachment-Id: f_l2k5fdpt0

RnJvbSAxYjQ0NmUxOTljMDM5MmVlMWY0NGI3MDkzNjVjZWUzYmIwOTMwNmNmIE1vbiBTZXAgMTcg
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
YS9tbS9rZmVuY2UvY29yZS5jIGIvbW0va2ZlbmNlL2NvcmUuYwppbmRleCA4NjI2MGU4ZjI4MzAu
LjY2MDc2ZDg3NDJiNyAxMDA2NDQKLS0tIGEvbW0va2ZlbmNlL2NvcmUuYworKysgYi9tbS9rZmVu
Y2UvY29yZS5jCkBAIC01MjgsNiArNTI4LDggQEAgc3RhdGljIGJvb2wgX19pbml0IGtmZW5jZV9p
bml0X3Bvb2wodm9pZCkKIAkgKiBlbnRlcnMgX19zbGFiX2ZyZWUoKSBzbG93LXBhdGguCiAJICov
CiAJZm9yIChpID0gMDsgaSA8IEtGRU5DRV9QT09MX1NJWkUgLyBQQUdFX1NJWkU7IGkrKykgewor
CQlzdHJ1Y3QgcGFnZSAqcGFnZSA9ICZwYWdlc1tpXTsKKwogCQlpZiAoIWkgfHwgKGkgJSAyKSkK
IAkJCWNvbnRpbnVlOwogCkBAIC01MzUsNyArNTM3LDExIEBAIHN0YXRpYyBib29sIF9faW5pdCBr
ZmVuY2VfaW5pdF9wb29sKHZvaWQpCiAJCWlmIChXQVJOX09OKGNvbXBvdW5kX2hlYWQoJnBhZ2Vz
W2ldKSAhPSAmcGFnZXNbaV0pKQogCQkJZ290byBlcnI7CiAKLQkJX19TZXRQYWdlU2xhYigmcGFn
ZXNbaV0pOworCQlfX1NldFBhZ2VTbGFiKHBhZ2UpOworI2lmZGVmIENPTkZJR19NRU1DRworCQlw
YWdlLT5tZW1jZ19kYXRhID0gKHVuc2lnbmVkIGxvbmcpJmtmZW5jZV9tZXRhZGF0YVtpIC8gMiAt
IDFdLm9iamNnIHwKKwkJCQkgICBNRU1DR19EQVRBX09CSkNHUzsKKyNlbmRpZgogCX0KIAogCS8q
CkBAIC05MTEsNiArOTE3LDkgQEAgdm9pZCBfX2tmZW5jZV9mcmVlKHZvaWQgKmFkZHIpCiB7CiAJ
c3RydWN0IGtmZW5jZV9tZXRhZGF0YSAqbWV0YSA9IGFkZHJfdG9fbWV0YWRhdGEoKHVuc2lnbmVk
IGxvbmcpYWRkcik7CiAKKyNpZmRlZiBDT05GSUdfTUVNQ0cKKwlLRkVOQ0VfV0FSTl9PTihtZXRh
LT5vYmpjZyk7CisjZW5kaWYKIAkvKgogCSAqIElmIHRoZSBvYmplY3RzIG9mIHRoZSBjYWNoZSBh
cmUgU0xBQl9UWVBFU0FGRV9CWV9SQ1UsIGRlZmVyIGZyZWVpbmcKIAkgKiB0aGUgb2JqZWN0LCBh
cyB0aGUgb2JqZWN0IHBhZ2UgbWF5IGJlIHJlY3ljbGVkIGZvciBvdGhlci10eXBlZApkaWZmIC0t
Z2l0IGEvbW0va2ZlbmNlL2tmZW5jZS5oIGIvbW0va2ZlbmNlL2tmZW5jZS5oCmluZGV4IDkyYmY2
ZWZmNjA2MC4uNjAwZjJlMjQzMWQ2IDEwMDY0NAotLS0gYS9tbS9rZmVuY2Uva2ZlbmNlLmgKKysr
IGIvbW0va2ZlbmNlL2tmZW5jZS5oCkBAIC04OSw2ICs4OSw5IEBAIHN0cnVjdCBrZmVuY2VfbWV0
YWRhdGEgewogCXN0cnVjdCBrZmVuY2VfdHJhY2sgZnJlZV90cmFjazsKIAkvKiBGb3IgdXBkYXRp
bmcgYWxsb2NfY292ZXJlZCBvbiBmcmVlcy4gKi8KIAl1MzIgYWxsb2Nfc3RhY2tfaGFzaDsKKyNp
ZmRlZiBDT05GSUdfTUVNQ0cKKwlzdHJ1Y3Qgb2JqX2Nncm91cCAqb2JqY2c7CisjZW5kaWYKIH07
CiAKIGV4dGVybiBzdHJ1Y3Qga2ZlbmNlX21ldGFkYXRhIGtmZW5jZV9tZXRhZGF0YVtDT05GSUdf
S0ZFTkNFX05VTV9PQkpFQ1RTXTsKLS0gCjIuMTEuMAoK
--0000000000000b9e3305ddc68925--
