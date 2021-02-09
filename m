Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30E2315925
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 23:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbhBIWJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 17:09:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbhBIWFk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 17:05:40 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB11BC08EC66
        for <stable@vger.kernel.org>; Tue,  9 Feb 2021 14:04:00 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id m22so30761742lfg.5
        for <stable@vger.kernel.org>; Tue, 09 Feb 2021 14:04:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tx92KR5yoK7Kj/E1nLE3ghpQl5QQOqByWmJjzpCqtGY=;
        b=V9UwqGgzVSybr9MIk7X99nXuilfse+Mk3lydDn9RKCzCDYoRB0jaRN+0j9MgwzacFu
         gRu43Pm1ruDkaldhqSI5PoDCwr8oM5gMRZ1n8jG6KKWHOx0mKaox9/lF3u76ljge1VQS
         yj32Jj3AKfWfodOLM8Zk0KFcJSORZEpSei+Io=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tx92KR5yoK7Kj/E1nLE3ghpQl5QQOqByWmJjzpCqtGY=;
        b=ZkdcJP3aKH3pNU9bm6W3AsWYNfBqkeCGdgiHGRyopsFu9cg0QLYhTF8iT8TFHYgXDa
         uaecnPVY3+qB0cruGY862ECYcSZqpcI/oS3Z2ZeEvcl7zW0bfl3J+0IBx0T+icnDN5sM
         N3gZplavD+WEZGUpZM+zpbgubUWn5qvB3VOH2npKPoWGyZOaKQ305hYYpFTHbiJ2C/zq
         jqkgoTXjg7wC8wW5RqUdull7gxU1tuvlqxOzDbVvKm/01pfrgBhQspn9u4NPF5AqASZ9
         f7CXR4i1hOT6ImsZLLUPiPOBJcDI5boPngu/ZhpIn50rH3s8JjvEhWIYhbqlChSe4Ot7
         d4iw==
X-Gm-Message-State: AOAM531qp5Ce5tEpt6zxqK3cKNmZCknGyFLB9YaXeK4XKpcLQi5bl6cS
        zJpW2jkbOi9BTCj//9SWKFNi1zcUoQM5Fw==
X-Google-Smtp-Source: ABdhPJz0vSIaAt89voNJtuNyaIqadCRZ+Yxbh7g0J4McJt8XWsoJrMHE2SfNMASp98hXIxtVx7HsKQ==
X-Received: by 2002:a05:6512:10c5:: with SMTP id k5mr14015659lfg.583.1612908220322;
        Tue, 09 Feb 2021 14:03:40 -0800 (PST)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com. [209.85.208.175])
        by smtp.gmail.com with ESMTPSA id j5sm2733226lfm.105.2021.02.09.14.03.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 14:03:37 -0800 (PST)
Received: by mail-lj1-f175.google.com with SMTP id q14so198254ljp.4
        for <stable@vger.kernel.org>; Tue, 09 Feb 2021 14:03:36 -0800 (PST)
X-Received: by 2002:a2e:8116:: with SMTP id d22mr15212997ljg.48.1612908215823;
 Tue, 09 Feb 2021 14:03:35 -0800 (PST)
MIME-Version: 1.0
References: <20210209134115.4d933d446165cd0ed8977b03@linux-foundation.org> <20210209214217.gRa4Jmu1g%akpm@linux-foundation.org>
In-Reply-To: <20210209214217.gRa4Jmu1g%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 9 Feb 2021 14:03:19 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiDt_eJvfrr-dCXq3eZ+ZmVTD2-rM2pcxBk4d-FM3h-bw@mail.gmail.com>
Message-ID: <CAHk-=wiDt_eJvfrr-dCXq3eZ+ZmVTD2-rM2pcxBk4d-FM3h-bw@mail.gmail.com>
Subject: Re: [patch 09/14] tmpfs: disallow CONFIG_TMPFS_INODE64 on alpha
To:     Andrew Morton <akpm@linux-foundation.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Chris Down <chris@chrisdown.name>,
        Hugh Dickins <hughd@google.com>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Linux-MM <linux-mm@kvack.org>, Matt Turner <mattst88@gmail.com>,
        mm-commits@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Seth Forshee <seth.forshee@canonical.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 9, 2021 at 1:42 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> As with s390, alpha is a 64-bit architecture with a 32-bit ino_t.  With
> CONFIG_TMPFS_INODE64=y tmpfs mounts will get 64-bit inode numbers and
> display "inode64" in the mount options, whereas passing "inode64" in the
> mount options will fail.

Ugh.

The two patches for s390 and alpha are obviously the right thing to
do, but I do wonder if we could strive to make __kernel_ino_t go away
entirely.

It's actually not used very much, because it's such a nasty type, and
s390 and alpha are the only ones that override it from the default
"word length" version (and honestly, even that default is not a great
type).

The main use of it is for "ino_t" and for "struct ustat".

And yes, "ino_t" is widely used, but I think pretty much all uses of
it are entirely internal to the kernel, and we could just make it be
"unsigned long".

Does anybody see any actual user interfaces that depend on
"__kernel_ino_t", aka "ino_t" (apart from that "struct ustat")?

I guess this is mostly a question for s390, which is actively maintained?

           Linus
