Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1E5745AC26
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 20:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhKWTZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 14:25:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33477 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231240AbhKWTZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 14:25:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637695365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7wgF/mQBHoxMqYXMPNOTmc+l3v46kd1T3TVNqFPYV5M=;
        b=Ql84W54z9gmMhJa8MbmQIxUaaOp7a3bHAxZMcrWYUbzUDA0+Bc5JfOdTvYEjp80L8pN+nN
        HIULYCHvm0bdaxAAwFlWoK9s6d4z+AhlNgoVTYj9V4jBMqMbFruSXOaKo17b3gNid2Cl5I
        yPDpu1ZKdUfx7MWxSwqcDsW6UM5B4+g=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-74-d7OozYYrOQeyJLAS_kKAsA-1; Tue, 23 Nov 2021 14:22:43 -0500
X-MC-Unique: d7OozYYrOQeyJLAS_kKAsA-1
Received: by mail-qt1-f197.google.com with SMTP id k1-20020ac80201000000b002a7200b449eso192203qtg.18
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 11:22:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7wgF/mQBHoxMqYXMPNOTmc+l3v46kd1T3TVNqFPYV5M=;
        b=ibuEMQgepX0TsNkcFN8u8mofF2+pjuM4DcoMFSLXRDtftHw3RFOQIbB1SM1C1Af8uk
         rt6Ma+LI3aWoCbWsw4lfLnHkXw7lP5EXPFjC3EUb72SwV7s0MX8w5Ki9c0+H5DYV/qCW
         /a0F/D9YGVPzCYBsXyBpYAVWU5IqBMm+wNihufIGe048yTG7qC46qPXBJoap/DRDFxC6
         hhyuB/ERYsoKJJ+adO4r3+PdrYdIm639J3hRcUZkjSUdCWQgwdhkAlahwT76GxAhEB99
         yX8GSG/KesbvStDpI5c3fJ6s8lvYRUD3/zYEDnkX+2v2u7v/gGWx5JITF85trMrJt+n+
         lXnQ==
X-Gm-Message-State: AOAM532OkPUV1nR+7r2B3KeigJL6Amq+vnJfJwIoCc8WSH8EZa2YghF0
        sMTlCSzpYrLZs7oeNTl3zIUOTzM385eJPd/wUhGcuMXfi/hfTVt6+Twf3mRMWk6dcxA+84+eStr
        CvDIi4Smd8k7UbNiT3+oUs8CcmVvwdpPW
X-Received: by 2002:a05:622a:349:: with SMTP id r9mr9079434qtw.213.1637695363136;
        Tue, 23 Nov 2021 11:22:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzIePFGvkD3N5zhD8lHSC06LJ7Uqf/s5pzdPHj7+tWYNMEidne25IPJMN9Ce8Sxvjigjxl7Uu8f1GPm2N6HDaU=
X-Received: by 2002:a05:622a:349:: with SMTP id r9mr9079403qtw.213.1637695362921;
 Tue, 23 Nov 2021 11:22:42 -0800 (PST)
MIME-Version: 1.0
References: <20211115165428.722074685@linuxfoundation.org> <20211115165430.669780058@linuxfoundation.org>
 <CAFxkdAqahwaN0u6u34d4CrMW7rYL=6TpWk1CcOn+uGQdEgkuTQ@mail.gmail.com>
In-Reply-To: <CAFxkdAqahwaN0u6u34d4CrMW7rYL=6TpWk1CcOn+uGQdEgkuTQ@mail.gmail.com>
From:   Miklos Szeredi <mszeredi@redhat.com>
Date:   Tue, 23 Nov 2021 20:22:32 +0100
Message-ID: <CAOssrKd4gHrKNNttZZey9orZ=F+msx4Axa6Mi_XgZw-9M39h-Q@mail.gmail.com>
Subject: Re: [PATCH 5.15 056/917] fuse: fix page stealing
To:     Justin Forbes <jmforbes@linuxtx.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Frank Dinoff <fdinoff@google.com>
Content-Type: multipart/mixed; boundary="0000000000005bb3d405d179aabc"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--0000000000005bb3d405d179aabc
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 23, 2021 at 7:29 PM Justin Forbes <jmforbes@linuxtx.org> wrote:
>
> On Mon, Nov 15, 2021 at 7:04 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Miklos Szeredi <mszeredi@redhat.com>
> >
> > commit 712a951025c0667ff00b25afc360f74e639dfabe upstream.
> >
> > It is possible to trigger a crash by splicing anon pipe bufs to the fuse
> > device.
> >
> > The reason for this is that anon_pipe_buf_release() will reuse buf->page if
> > the refcount is 1, but that page might have already been stolen and its
> > flags modified (e.g. PG_lru added).
> >
> > This happens in the unlikely case of fuse_dev_splice_write() getting around
> > to calling pipe_buf_release() after a page has been stolen, added to the
> > page cache and removed from the page cache.
> >
> > Fix by calling pipe_buf_release() right after the page was inserted into
> > the page cache.  In this case the page has an elevated refcount so any
> > release function will know that the page isn't reusable.
> >
> > Reported-by: Frank Dinoff <fdinoff@google.com>
> > Link: https://lore.kernel.org/r/CAAmZXrsGg2xsP1CK+cbuEMumtrqdvD-NKnWzhNcvn71RV3c1yw@mail.gmail.com/
> > Fixes: dd3bb14f44a6 ("fuse: support splice() writing to fuse device")
> > Cc: <stable@vger.kernel.org> # v2.6.35
> > Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> It appears this patch causes a rather serious regression in flatpacks
> using portals to access files.  Reverting this patch restores expected
> behavior. I have asked users in the Fedora bug to test with 5.16-rc2
> to see if we are just missing a dependent patch in stable, or if this
> is broken there as well, but no response yet.:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=2025285
> https://github.com/flatpak/flatpak/issues/4595

Hi,

Thanks for the report.  Can someone with the reproducer try the attached patch?

I think the race there is unlikely but possible.

Thanks,
Miklos

--0000000000005bb3d405d179aabc
Content-Type: text/x-patch; charset="US-ASCII"; name="fuse-refcount-fix.patch"
Content-Disposition: attachment; filename="fuse-refcount-fix.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kwchikl50>
X-Attachment-Id: f_kwchikl50

ZGlmZiAtLWdpdCBhL2ZzL2Z1c2UvZGV2LmMgYi9mcy9mdXNlL2Rldi5jCmluZGV4IDc5ZjdlZGE0
OWUwNi4uOTU5ZDJiN2Y5ZTlkIDEwMDY0NAotLS0gYS9mcy9mdXNlL2Rldi5jCisrKyBiL2ZzL2Z1
c2UvZGV2LmMKQEAgLTg0NywxNCArODQ3LDE0IEBAIHN0YXRpYyBpbnQgZnVzZV90cnlfbW92ZV9w
YWdlKHN0cnVjdCBmdXNlX2NvcHlfc3RhdGUgKmNzLCBzdHJ1Y3QgcGFnZSAqKnBhZ2VwKQogCiAJ
cmVwbGFjZV9wYWdlX2NhY2hlX3BhZ2Uob2xkcGFnZSwgbmV3cGFnZSk7CiAKKwlnZXRfcGFnZShu
ZXdwYWdlKTsKKwogCS8qCiAJICogUmVsZWFzZSB3aGlsZSB3ZSBoYXZlIGV4dHJhIHJlZiBvbiBz
dG9sZW4gcGFnZS4gIE90aGVyd2lzZQogCSAqIGFub25fcGlwZV9idWZfcmVsZWFzZSgpIG1pZ2h0
IHRoaW5rIHRoZSBwYWdlIGNhbiBiZSByZXVzZWQuCiAJICovCiAJcGlwZV9idWZfcmVsZWFzZShj
cy0+cGlwZSwgYnVmKTsKIAotCWdldF9wYWdlKG5ld3BhZ2UpOwotCiAJaWYgKCEoYnVmLT5mbGFn
cyAmIFBJUEVfQlVGX0ZMQUdfTFJVKSkKIAkJbHJ1X2NhY2hlX2FkZChuZXdwYWdlKTsKIAo=
--0000000000005bb3d405d179aabc--

