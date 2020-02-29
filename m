Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60CAC1747A6
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 16:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbgB2PVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 10:21:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32792 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727085AbgB2PVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 10:21:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582989681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PtxKWcwkRVz0a7VDbDRRNSoAjwbFX2cOg97L2uUYHko=;
        b=PdwlK1RbbINfck2NcWPDwkoQezUtkfKAdZMJvLYX7lLzzwzFnGEu4ajhPfdkG7O3jcqh3M
        3/K5vPmCT9X70xjymK5UtIqsVqOxCfGsgnRLwhuIFXH2drCqz+xU7ptEZZXeOO4pGyM372
        JDxAQZ7duuAf1nwM4Y2CD9zqbaFKen0=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-A_bUNGQFOnGyFT0C6ZMteQ-1; Sat, 29 Feb 2020 10:21:15 -0500
X-MC-Unique: A_bUNGQFOnGyFT0C6ZMteQ-1
Received: by mail-ot1-f70.google.com with SMTP id d16so3679119otf.5
        for <stable@vger.kernel.org>; Sat, 29 Feb 2020 07:21:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PtxKWcwkRVz0a7VDbDRRNSoAjwbFX2cOg97L2uUYHko=;
        b=c2xhLTSTGeiKuaekGf6DfhMbmACDXY03x7hOqdgs+kiLx8gtvCPhcsx+oBOjHu+OFR
         N0TYstl1tT6iRH1rMSAn4166L7998WfAubFwIkMyt7Pz278zmOxMFp0tK+eZs25pWoJG
         OvC8bG5nJiD3+jG0xdcj/LpcYnexAe9dRVYHxEgPJgacvhv75tx08S3G3EdT79W1rG7z
         sRA8OoXOInDvBgHJhiVe5UAdBsM51/YST0xTAkwLndqUocGd1du6038wV0DJ1I+TEqdV
         daPGWrZWcC/UxYl8uk0axT6GOsWEO80yrj13U70ZQMiqfExXLHzTIZBc2mtJF/2avDRD
         0gZg==
X-Gm-Message-State: APjAAAVVUB6YqGzIsfiLQgVcV+t006HiEn39tmYUZyEZ3AvibCwT8Xy1
        aetBQnxs+SnxEjhH8b5DH8J6E3g35Q+uiK9hZi2Xywma8Bl/ycAeA64pq5JCeKBZq7HmmoxO+Y6
        tApGDaOda07s4XwK0MYzUZZT5IUDtQ9o9
X-Received: by 2002:aca:488a:: with SMTP id v132mr3908330oia.166.1582989674771;
        Sat, 29 Feb 2020 07:21:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqwjcGW/EO8wo258CPzlS5+emmTxNs1lD0e8vVmppaYnkvNGZYeJ9CBiixMQtdRl8T6Sj8QMlL9JUGYVk+vJc6o=
X-Received: by 2002:aca:488a:: with SMTP id v132mr3908310oia.166.1582989674432;
 Sat, 29 Feb 2020 07:21:14 -0800 (PST)
MIME-Version: 1.0
References: <cki.D557417105.IEDVNU8MSC@redhat.com> <e5e321d0-9775-aa94-4b9b-c9b9f2d63430@redhat.com>
In-Reply-To: <e5e321d0-9775-aa94-4b9b-c9b9f2d63430@redhat.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Sat, 29 Feb 2020 16:21:06 +0100
Message-ID: <CAFqZXNutRKL_0t5FadSrFVEaZkQDbMbYUhr5V4H_xceqJM=NGg@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=E2=9D=8C_FAIL=3A_Test_report_for_kernel_5=2E4=2E23=2Dbfe3046=2E?=
        =?UTF-8?Q?cki_=28stable=29?=
To:     Rachel Sibley <rasibley@redhat.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Jianlin Shi <jishi@redhat.com>, Jianwen Ji <jiji@redhat.com>,
        Milos Malik <mmalik@redhat.com>, Hangbin Liu <haliu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 29, 2020 at 4:02 PM Rachel Sibley <rasibley@redhat.com> wrote:
> On 2/29/20 8:26 AM, CKI Project wrote:
> >
> > Hello,
> >
> > We ran automated tests on a recent commit from this kernel tree:
> >
> >         Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stab=
le/linux-stable-rc.git
> >              Commit: bfe3046ecafd - Linux 5.4.23
> >
> > The results of these automated tests are provided below.
> >
> >      Overall result: FAILED (see details below)
> >               Merge: OK
> >             Compile: OK
> >               Tests: FAILED
> >
> > All kernel binaries, config files, and logs are available for download =
here:
> >
> >    https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=
=3Ddatawarehouse/2020/02/28/462608
> >
> > One or more kernel tests failed:
> >
> >      ppc64le:
> >       =E2=9D=8C selinux-policy: serge-testsuite
> >
> >      aarch64:
> >       =E2=9D=8C selinux-policy: serge-testsuite
> >
> >      x86_64:
> >       =E2=9D=8C selinux-policy: serge-testsuite
>
> The selinux failures may be caused by this but I'll let Ondrej confirm:
> https://www.spinics.net/lists/stable/msg369030.html

Yes, it's this test bug again... I just applied the fix to our
selinux-testuite wrapper [1] (the testsuite patch itself is at [2]) so
it should stop happening now. Sorry it took so long.

[1] https://src.fedoraproject.org/tests/selinux/c/fbff736aea714e21dcd92b617=
bf22871d3fa2bc6?branch=3Dmaster
[2] https://patchwork.kernel.org/patch/11403121/

--=20
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.

