Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7BC461B9E
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 17:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345388AbhK2QQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 11:16:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:52027 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345848AbhK2QOb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 11:14:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638202272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UOwVm323z5FlKe3u3qLSjfbP+DwQWJ0ibZYWyJXF5mE=;
        b=FXO53t1Di8PqxcHlFpL9GPbC/9KzORhVWkrS3JxvrWpt6L/HCoGfasfc3pSbTmA+1jts27
        AMpWGRwldPv4bBwRbI5itvjW+i52kDB5qzgHOZlzWjCXLUPlsO42qXCq2gKKTLBNvZyff1
        jToyWOZiRSc6wIgdtMGyIPkAzx1Wk5c=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-Hx9NXPJ7ON65b0yIJ8totQ-1; Mon, 29 Nov 2021 11:10:53 -0500
X-MC-Unique: Hx9NXPJ7ON65b0yIJ8totQ-1
Received: by mail-qk1-f198.google.com with SMTP id bj10-20020a05620a190a00b004681da13edcso25097869qkb.1
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 08:10:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UOwVm323z5FlKe3u3qLSjfbP+DwQWJ0ibZYWyJXF5mE=;
        b=Lcvp4yL4Y3QDkfuUvbMSOxaTkvVVz3ZM4YhyVvUqx1HKBf0QXZS3PP77ceTL2xBwiH
         kZYnnERbb0AXrsh+udLNT4nFuPBqGOlONZe9hkki8lZEPhwUhyosEG93ifL81mM8iP7O
         0C0i2PFjf+9S7d6r5Th3qk8ZOBxvNmqiM13UaQG+kPeXy4nNJTu81zDPV4dMDGJI+yfa
         1Vy7htnZruXxGzzxblvPLoMaNGC8qaQGy5ETSr4ld6hq9g0n7ld8bHQUZNFibE4wYK4M
         x0WoG2TCvvl6IMMVNQos8u/Wcdeq7wEq9jBgRAyrCw5Ymp7PKjeMvKaTDc3kC7YEQyCf
         DKiQ==
X-Gm-Message-State: AOAM530Xbyxyav9xonuXThNEJA7kD6Q+QafkNcj4V0eG41/qGxHh3p3x
        L7RfiEU5qR/H/yXc1+oM/3NqYydXA9adUSM+Fk2w0h+mV2FIExzyMn9cU47RZzVKjY0MhNm6HJZ
        9wINP2XV0R63AzVcvqDbkOdViWfrmVIF5
X-Received: by 2002:a05:6214:23cc:: with SMTP id hr12mr35408862qvb.66.1638202252906;
        Mon, 29 Nov 2021 08:10:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx/MGZk8GKjCwM/8kv/wL4/W798JcJKst/zBf2U0k1M2V7V5ra5QYBOgBd+Ttc1tBA3f36wzI2aBoTcymfBleE=
X-Received: by 2002:a05:6214:23cc:: with SMTP id hr12mr35408838qvb.66.1638202252736;
 Mon, 29 Nov 2021 08:10:52 -0800 (PST)
MIME-Version: 1.0
References: <163801865218547@kroah.com>
In-Reply-To: <163801865218547@kroah.com>
From:   Miklos Szeredi <mszeredi@redhat.com>
Date:   Mon, 29 Nov 2021 17:10:41 +0100
Message-ID: <CAOssrKdd9u=tQ-fjXhqju9-7efHtN=mBed0ay1e_YM2yBHVT0Q@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] fuse: release pipe buf after last use"
 failed to apply to 4.4-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Justin Forbes <jmforbes@linuxtx.org>,
        stable <stable@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000588fb605d1efaf49"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000588fb605d1efaf49
Content-Type: text/plain; charset="UTF-8"

On Sat, Nov 27, 2021 at 2:11 PM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.


Hi Greg,

Attaching the backport of this patch against 4.4.292 + "fuse: fix page
stealing".

The latter has been dropped from 4.4, but together with this backport
should be good to go:

  stable-queue.git#c7f34b89ddfe^:queue-4.4/fuse-fix-page-stealing.patch

Thanks,
Miklos

--000000000000588fb605d1efaf49
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="fuse-release-pipe-buf-after-last-use-4.4.patch"
Content-Disposition: attachment; 
	filename="fuse-release-pipe-buf-after-last-use-4.4.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kwkv3dhb0>
X-Attachment-Id: f_kwkv3dhb0

RnJvbSA3NTNlMzMzZTg2ZjBlNDE4NjBhZGYzNGJmNGZmY2YxMGIyMTg4YjlkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaWtsb3MgU3plcmVkaSA8bXN6ZXJlZGlAcmVkaGF0LmNvbT4K
RGF0ZTogVGh1LCAyNSBOb3YgMjAyMSAxNDowNToxOCArMDEwMApTdWJqZWN0OiBbUEFUQ0hdIGZ1
c2U6IHJlbGVhc2UgcGlwZSBidWYgYWZ0ZXIgbGFzdCB1c2UKCkNoZWNraW5nIGJ1Zi0+ZmxhZ3Mg
c2hvdWxkIGJlIGRvbmUgYmVmb3JlIHRoZSBwaXBlX2J1Zl9yZWxlYXNlKCkgaXMgY2FsbGVkCm9u
IHRoZSBwaXBlIGJ1ZmZlciwgc2luY2UgcmVsZWFzaW5nIHRoZSBidWZmZXIgbWlnaHQgbW9kaWZ5
IHRoZSBmbGFncy4KClRoaXMgaXMgZXhhY3RseSB3aGF0IHBhZ2VfY2FjaGVfcGlwZV9idWZfcmVs
ZWFzZSgpIGRvZXMsIGFuZCB3aGljaCByZXN1bHRzCmluIHRoZSBzYW1lIFZNX0JVR19PTl9QQUdF
KFBhZ2VMUlUocGFnZSkpIHRoYXQgdGhlIG9yaWdpbmFsIHBhdGNoIHdhcwp0cnlpbmcgdG8gZml4
LgoKUmVwb3J0ZWQtYnk6IEp1c3RpbiBGb3JiZXMgPGptZm9yYmVzQGxpbnV4dHgub3JnPgpGaXhl
czogNzEyYTk1MTAyNWMwICgiZnVzZTogZml4IHBhZ2Ugc3RlYWxpbmciKQpDYzogPHN0YWJsZUB2
Z2VyLmtlcm5lbC5vcmc+ICMgdjIuNi4zNQpTaWduZWQtb2ZmLWJ5OiBNaWtsb3MgU3plcmVkaSA8
bXN6ZXJlZGlAcmVkaGF0LmNvbT4KKGNoZXJyeSBwaWNrZWQgZnJvbSBjb21taXQgNDczNDQxNzIw
Yzg2MTZkZmFmNDQ1MWY5YzdlYTE0ZjBlYjVlNWQ2NSkKLS0tCiBmcy9mdXNlL2Rldi5jIHwgMTAg
KysrKystLS0tLQogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9mcy9mdXNlL2Rldi5jIGIvZnMvZnVzZS9kZXYuYwppbmRleCA3NWZh
ZDQxYmM2ZTEuLmRjNzA1ZTRiZTM1MCAxMDA2NDQKLS0tIGEvZnMvZnVzZS9kZXYuYworKysgYi9m
cy9mdXNlL2Rldi5jCkBAIC05MjIsNiArOTIyLDExIEBAIHN0YXRpYyBpbnQgZnVzZV90cnlfbW92
ZV9wYWdlKHN0cnVjdCBmdXNlX2NvcHlfc3RhdGUgKmNzLCBzdHJ1Y3QgcGFnZSAqKnBhZ2VwKQog
CQlyZXR1cm4gZXJyOwogCX0KIAorCXBhZ2VfY2FjaGVfZ2V0KG5ld3BhZ2UpOworCisJaWYgKCEo
YnVmLT5mbGFncyAmIFBJUEVfQlVGX0ZMQUdfTFJVKSkKKwkJbHJ1X2NhY2hlX2FkZF9maWxlKG5l
d3BhZ2UpOworCiAJLyoKIAkgKiBSZWxlYXNlIHdoaWxlIHdlIGhhdmUgZXh0cmEgcmVmIG9uIHN0
b2xlbiBwYWdlLiAgT3RoZXJ3aXNlCiAJICogYW5vbl9waXBlX2J1Zl9yZWxlYXNlKCkgbWlnaHQg
dGhpbmsgdGhlIHBhZ2UgY2FuIGJlIHJldXNlZC4KQEAgLTkyOSwxMSArOTM0LDYgQEAgc3RhdGlj
IGludCBmdXNlX3RyeV9tb3ZlX3BhZ2Uoc3RydWN0IGZ1c2VfY29weV9zdGF0ZSAqY3MsIHN0cnVj
dCBwYWdlICoqcGFnZXApCiAJYnVmLT5vcHMtPnJlbGVhc2UoY3MtPnBpcGUsIGJ1Zik7CiAJYnVm
LT5vcHMgPSBOVUxMOwogCi0JcGFnZV9jYWNoZV9nZXQobmV3cGFnZSk7Ci0KLQlpZiAoIShidWYt
PmZsYWdzICYgUElQRV9CVUZfRkxBR19MUlUpKQotCQlscnVfY2FjaGVfYWRkX2ZpbGUobmV3cGFn
ZSk7Ci0KIAllcnIgPSAwOwogCXNwaW5fbG9jaygmY3MtPnJlcS0+d2FpdHEubG9jayk7CiAJaWYg
KHRlc3RfYml0KEZSX0FCT1JURUQsICZjcy0+cmVxLT5mbGFncykpCi0tIAoyLjMxLjEKCg==
--000000000000588fb605d1efaf49--

