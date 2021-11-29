Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02D1461B4D
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 16:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244700AbhK2Pw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 10:52:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51029 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234066AbhK2PuJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 10:50:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638200811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=26f2b5Y7G+VSrFOVmDuCXcMN9XzKd9kyzFy/dKrRMFs=;
        b=MfjiI4A7yTizy8dh2P7zmdVxc9x056z/zC8iimjOAeiLWTQfLJQwhEiPOOD1lCRHOFbDnU
        NDUH7SY9SEuwrsrdvZrMm2jCtSuTOnxUr+yTeoWPnvQRHmF99HUF7g+35FWwb8DsBrmoE+
        /res1/isprflDWimCdu1Y6TplUELK1w=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-402-CkLl4Lf-N6Cs8q7XX7HpgQ-1; Mon, 29 Nov 2021 10:46:46 -0500
X-MC-Unique: CkLl4Lf-N6Cs8q7XX7HpgQ-1
Received: by mail-qt1-f197.google.com with SMTP id c19-20020ac81e93000000b002a71180fd3dso23932267qtm.1
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 07:46:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=26f2b5Y7G+VSrFOVmDuCXcMN9XzKd9kyzFy/dKrRMFs=;
        b=If5xSlYmepyXOsuKxH4Vaiw3pAYOoo+F4jeBY/eH+d/bA3ajAerqQW1UQ5uvOk0qHr
         fGP2zof7Uo2KIbZvJgR4i0tQw0MiL2IpvBqf8LMpDjuiCHZlizNOD5QSx5KgdSwmklex
         epewoZUsct/RyfRyhL0KxYYowGDfB/CTMCQNk31yA8FYdcoHiEK9T5khlKVQHONJ3xO9
         D4B1Vc92ZtBXrcvEZx5WhpMfTd6mNQrGjIZecKJbUvkVzOjulDY69yHlzUJe5xvmzIu6
         iNviVlNITA9AcV8PymbBQndP1wOOslozlKfqs53p49Ff6jSZ/h03U5Mzm7d6ylSjkbyH
         8Obw==
X-Gm-Message-State: AOAM531LtiwnOplo1Mmwwwto3J2F/uXTHl8/YOsSu/wY8El+Qa4wpI9O
        /SoVQjsbdtGY2zoBX+uw842cPTcWXjc73UglDCVEFF0Tqc1PSb8qXLAmQdcZoGdMKhroVekvyiL
        TxGbHIcFkHxak5J8Rtcbi4tCAJjNsm80q
X-Received: by 2002:ac8:5dca:: with SMTP id e10mr35867267qtx.558.1638200805993;
        Mon, 29 Nov 2021 07:46:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzmJhJipMnlWXB5mF5qETuRMHYQ36dNAJs3wp58pvJp9ZYv8XIMNgmkTSgAVFOQUHLD9BpDq0tDcNRB5vwVQA8=
X-Received: by 2002:ac8:5dca:: with SMTP id e10mr35867244qtx.558.1638200805822;
 Mon, 29 Nov 2021 07:46:45 -0800 (PST)
MIME-Version: 1.0
References: <163801865313345@kroah.com>
In-Reply-To: <163801865313345@kroah.com>
From:   Miklos Szeredi <mszeredi@redhat.com>
Date:   Mon, 29 Nov 2021 16:46:34 +0100
Message-ID: <CAOssrKdrJgV+m9yFee6SHMFU2W8zs4vrKotkn5kD+s61Gw9jkg@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] fuse: release pipe buf after last use"
 failed to apply to 4.9-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Justin Forbes <jmforbes@linuxtx.org>,
        stable <stable@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000001a689805d1ef5905"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--0000000000001a689805d1ef5905
Content-Type: text/plain; charset="UTF-8"

On Sat, Nov 27, 2021 at 2:11 PM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Hi Greg,

Attaching the backport against 4.9.292-rc1.

Should apply to the 4.14, 4.19 and 5.4 stable trees as well.

Thanks,
Miklos

--0000000000001a689805d1ef5905
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="fuse-release-pipe-buf-after-last-use-4.9.patch"
Content-Disposition: attachment; 
	filename="fuse-release-pipe-buf-after-last-use-4.9.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kwkueqlu0>
X-Attachment-Id: f_kwkueqlu0

RnJvbSBkODRjMzI3YzBmODE2MzUyNDQwN2M5ZjE4MjcxMGIxZDljZWZiOTMwIE1vbiBTZXAgMTcg
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
LSkKCmRpZmYgLS1naXQgYS9mcy9mdXNlL2Rldi5jIGIvZnMvZnVzZS9kZXYuYwppbmRleCA3MmNl
NjZlMGUwOGMuLjU4NWM1MmRiYjJlMyAxMDA2NDQKLS0tIGEvZnMvZnVzZS9kZXYuYworKysgYi9m
cy9mdXNlL2Rldi5jCkBAIC04OTgsMTcgKzg5OCwxNyBAQCBzdGF0aWMgaW50IGZ1c2VfdHJ5X21v
dmVfcGFnZShzdHJ1Y3QgZnVzZV9jb3B5X3N0YXRlICpjcywgc3RydWN0IHBhZ2UgKipwYWdlcCkK
IAkJZ290byBvdXRfcHV0X29sZDsKIAl9CiAKKwlnZXRfcGFnZShuZXdwYWdlKTsKKworCWlmICgh
KGJ1Zi0+ZmxhZ3MgJiBQSVBFX0JVRl9GTEFHX0xSVSkpCisJCWxydV9jYWNoZV9hZGRfZmlsZShu
ZXdwYWdlKTsKKwogCS8qCiAJICogUmVsZWFzZSB3aGlsZSB3ZSBoYXZlIGV4dHJhIHJlZiBvbiBz
dG9sZW4gcGFnZS4gIE90aGVyd2lzZQogCSAqIGFub25fcGlwZV9idWZfcmVsZWFzZSgpIG1pZ2h0
IHRoaW5rIHRoZSBwYWdlIGNhbiBiZSByZXVzZWQuCiAJICovCiAJcGlwZV9idWZfcmVsZWFzZShj
cy0+cGlwZSwgYnVmKTsKIAotCWdldF9wYWdlKG5ld3BhZ2UpOwotCi0JaWYgKCEoYnVmLT5mbGFn
cyAmIFBJUEVfQlVGX0ZMQUdfTFJVKSkKLQkJbHJ1X2NhY2hlX2FkZF9maWxlKG5ld3BhZ2UpOwot
CiAJZXJyID0gMDsKIAlzcGluX2xvY2soJmNzLT5yZXEtPndhaXRxLmxvY2spOwogCWlmICh0ZXN0
X2JpdChGUl9BQk9SVEVELCAmY3MtPnJlcS0+ZmxhZ3MpKQotLSAKMi4zMS4xCgo=
--0000000000001a689805d1ef5905--

