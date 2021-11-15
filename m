Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA2E4502D7
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 11:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbhKOK42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 05:56:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43467 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231403AbhKOKze (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 05:55:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636973549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CD69SitcWIafAa4BdwOCKL07BqmA889FhmfkJpuTiBw=;
        b=XUwerIAyHuL1wWRZdF6nSUYzyGU0MkPz9od0eeMg2BP5f4DD2yKPqzXC5YFoHLvHtG+ofu
        yL2Ux0c1x8rR8xkaSyeCvichR9GS+sddJwf3xt7iuHBk7b4Bu/xoGztjcxgPrpuUChj2JL
        bnuIBKrbQ/628CHzceBPj50Cm8ZZIiY=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-DeeWVyxDOdCS2Z-CeO7sEw-1; Mon, 15 Nov 2021 05:52:27 -0500
X-MC-Unique: DeeWVyxDOdCS2Z-CeO7sEw-1
Received: by mail-qv1-f71.google.com with SMTP id q2-20020a05621419e200b003aeeeff5417so15507004qvc.9
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 02:52:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CD69SitcWIafAa4BdwOCKL07BqmA889FhmfkJpuTiBw=;
        b=PbAauCtHBbLxabMa5ZwVAx9Ihf8zUieiDtsL31IEFoE33wYagy5beisylfL2cTzebt
         zdTvc+nk12Q3mT7E92YPgqeBlrFY/pC2Rv9GzHTx6hMy/3dBrKdhkOSQYd+HPeQqK6/M
         xJ9SXPUhH+og8tB7XC+ilq/taFsVG4USBFpskPZCvHT8WekxUaWTDM5rQmnfd4OIAho+
         hAo/dgcY7ZZVsyC6N6zpTqM0YVtUhm/k/C5cpo9wjXabLI363/F7rThlcduYJQjnv+af
         mREHIp7aEMVgg9VGaxzEBIojByymIY+BselXMr1O4LC3HGOXmHuStE+SHLnm44pj5wEX
         1JVw==
X-Gm-Message-State: AOAM532F2k5kuDvt0EJZmBiRWETGuxS8lGySboMZVVDTP8ag8eYb1s2j
        kwD1YIqH5cNHTDT2M+UKvQq+Cm6akvxYAZvFef4U/XJCPeGmWS9Pf1uW8B1L4p1JHkNqPU8ffHV
        7jNphcqBHmZPlEsNFAziD6HFAMKq1ZCsr
X-Received: by 2002:a0c:8bc9:: with SMTP id a9mr35460478qvc.17.1636973547131;
        Mon, 15 Nov 2021 02:52:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxxFvjSQCSF5keR/f4Hgz2KPNXwkRJLLeQ/EnLPC8AAnc/li6V4cAwoh81RSLqDLzSpG7pj1gYeXPiEZAUrhNU=
X-Received: by 2002:a0c:8bc9:: with SMTP id a9mr35460464qvc.17.1636973546976;
 Mon, 15 Nov 2021 02:52:26 -0800 (PST)
MIME-Version: 1.0
References: <16368092531141@kroah.com>
In-Reply-To: <16368092531141@kroah.com>
From:   Miklos Szeredi <mszeredi@redhat.com>
Date:   Mon, 15 Nov 2021 11:52:16 +0100
Message-ID: <CAOssrKdxG4WAm_XMdQv42ht79Y6UJ2RmBb08ZKTaTQSmOu_=mA@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] fuse: fix page stealing" failed to apply
 to 4.4-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     fdinoff@google.com, stable <stable@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000c67f0c05d0d19ade"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000c67f0c05d0d19ade
Content-Type: text/plain; charset="UTF-8"

On Sat, Nov 13, 2021 at 2:14 PM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>

Hi Greg,

Attaching tested backport of 712a951025c0 ("fuse: fix page stealing")
to v4.4.292.

Thanks,
Miklos

--000000000000c67f0c05d0d19ade
Content-Type: text/x-patch; charset="US-ASCII"; name="fuse-fix-page-stealing-4.4.patch"
Content-Disposition: attachment; filename="fuse-fix-page-stealing-4.4.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kw0jnzg20>
X-Attachment-Id: f_kw0jnzg20

RnJvbSAyNGUwOTljOGE0N2M2MWNmZDg0OTcxNWRjNTA3NGM2YWVjZDMyMzNkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaWtsb3MgU3plcmVkaSA8bXN6ZXJlZGlAcmVkaGF0LmNvbT4K
RGF0ZTogVHVlLCAyIE5vdiAyMDIxIDExOjEwOjM3ICswMTAwClN1YmplY3Q6IFtQQVRDSF0gZnVz
ZTogZml4IHBhZ2Ugc3RlYWxpbmcKCkl0IGlzIHBvc3NpYmxlIHRvIHRyaWdnZXIgYSBjcmFzaCBi
eSBzcGxpY2luZyBhbm9uIHBpcGUgYnVmcyB0byB0aGUgZnVzZQpkZXZpY2UuCgpUaGUgcmVhc29u
IGZvciB0aGlzIGlzIHRoYXQgYW5vbl9waXBlX2J1Zl9yZWxlYXNlKCkgd2lsbCByZXVzZSBidWYt
PnBhZ2UgaWYKdGhlIHJlZmNvdW50IGlzIDEsIGJ1dCB0aGF0IHBhZ2UgbWlnaHQgaGF2ZSBhbHJl
YWR5IGJlZW4gc3RvbGVuIGFuZCBpdHMKZmxhZ3MgbW9kaWZpZWQgKGUuZy4gUEdfbHJ1IGFkZGVk
KS4KClRoaXMgaGFwcGVucyBpbiB0aGUgdW5saWtlbHkgY2FzZSBvZiBmdXNlX2Rldl9zcGxpY2Vf
d3JpdGUoKSBnZXR0aW5nIGFyb3VuZAp0byBjYWxsaW5nIHBpcGVfYnVmX3JlbGVhc2UoKSBhZnRl
ciBhIHBhZ2UgaGFzIGJlZW4gc3RvbGVuLCBhZGRlZCB0byB0aGUKcGFnZSBjYWNoZSBhbmQgcmVt
b3ZlZCBmcm9tIHRoZSBwYWdlIGNhY2hlLgoKRml4IGJ5IGNhbGxpbmcgcGlwZV9idWZfcmVsZWFz
ZSgpIHJpZ2h0IGFmdGVyIHRoZSBwYWdlIHdhcyBpbnNlcnRlZCBpbnRvCnRoZSBwYWdlIGNhY2hl
LiAgSW4gdGhpcyBjYXNlIHRoZSBwYWdlIGhhcyBhbiBlbGV2YXRlZCByZWZjb3VudCBzbyBhbnkK
cmVsZWFzZSBmdW5jdGlvbiB3aWxsIGtub3cgdGhhdCB0aGUgcGFnZSBpc24ndCByZXVzYWJsZS4K
ClJlcG9ydGVkLWJ5OiBGcmFuayBEaW5vZmYgPGZkaW5vZmZAZ29vZ2xlLmNvbT4KTGluazogaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci9DQUFtWlhyc0dnMnhzUDFDSytjYnVFTXVtdHJxZHZELU5L
bld6aE5jdm43MVJWM2MxeXdAbWFpbC5nbWFpbC5jb20vCkZpeGVzOiBkZDNiYjE0ZjQ0YTYgKCJm
dXNlOiBzdXBwb3J0IHNwbGljZSgpIHdyaXRpbmcgdG8gZnVzZSBkZXZpY2UiKQpDYzogPHN0YWJs
ZUB2Z2VyLmtlcm5lbC5vcmc+ICMgdjIuNi4zNQpTaWduZWQtb2ZmLWJ5OiBNaWtsb3MgU3plcmVk
aSA8bXN6ZXJlZGlAcmVkaGF0LmNvbT4KKGNoZXJyeSBwaWNrZWQgZnJvbSBjb21taXQgNzEyYTk1
MTAyNWMwNjY3ZmYwMGIyNWFmYzM2MGY3NGU2MzlkZmFiZSkKLS0tCiBmcy9mdXNlL2Rldi5jIHwg
MTAgKysrKysrKysrLQogMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlv
bigtKQoKZGlmZiAtLWdpdCBhL2ZzL2Z1c2UvZGV2LmMgYi9mcy9mdXNlL2Rldi5jCmluZGV4IDM4
YTEyYjBlMzk1Zi4uNzVmYWQ0MWJjNmUxIDEwMDY0NAotLS0gYS9mcy9mdXNlL2Rldi5jCisrKyBi
L2ZzL2Z1c2UvZGV2LmMKQEAgLTkyMiw2ICs5MjIsMTMgQEAgc3RhdGljIGludCBmdXNlX3RyeV9t
b3ZlX3BhZ2Uoc3RydWN0IGZ1c2VfY29weV9zdGF0ZSAqY3MsIHN0cnVjdCBwYWdlICoqcGFnZXAp
CiAJCXJldHVybiBlcnI7CiAJfQogCisJLyoKKwkgKiBSZWxlYXNlIHdoaWxlIHdlIGhhdmUgZXh0
cmEgcmVmIG9uIHN0b2xlbiBwYWdlLiAgT3RoZXJ3aXNlCisJICogYW5vbl9waXBlX2J1Zl9yZWxl
YXNlKCkgbWlnaHQgdGhpbmsgdGhlIHBhZ2UgY2FuIGJlIHJldXNlZC4KKwkgKi8KKwlidWYtPm9w
cy0+cmVsZWFzZShjcy0+cGlwZSwgYnVmKTsKKwlidWYtPm9wcyA9IE5VTEw7CisKIAlwYWdlX2Nh
Y2hlX2dldChuZXdwYWdlKTsKIAogCWlmICghKGJ1Zi0+ZmxhZ3MgJiBQSVBFX0JVRl9GTEFHX0xS
VSkpCkBAIC0yMDkwLDcgKzIwOTcsOCBAQCBzdGF0aWMgc3NpemVfdCBmdXNlX2Rldl9zcGxpY2Vf
d3JpdGUoc3RydWN0IHBpcGVfaW5vZGVfaW5mbyAqcGlwZSwKIG91dF9mcmVlOgogCWZvciAoaWR4
ID0gMDsgaWR4IDwgbmJ1ZjsgaWR4KyspIHsKIAkJc3RydWN0IHBpcGVfYnVmZmVyICpidWYgPSAm
YnVmc1tpZHhdOwotCQlidWYtPm9wcy0+cmVsZWFzZShwaXBlLCBidWYpOworCQlpZiAoYnVmLT5v
cHMpCisJCQlidWYtPm9wcy0+cmVsZWFzZShwaXBlLCBidWYpOwogCX0KIAlwaXBlX3VubG9jayhw
aXBlKTsKIAotLSAKMi4zMS4xCgo=
--000000000000c67f0c05d0d19ade--

