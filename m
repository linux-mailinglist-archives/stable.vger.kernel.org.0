Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 324B016A1B5
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 10:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgBXJRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 04:17:25 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51044 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727168AbgBXJRZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Feb 2020 04:17:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582535844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N/fKsDtxSAzMIh6BDAj358XjJ/ekm/gCjQo0tpt4kAQ=;
        b=RLxoUSSFycRDaV8nccHLPr4nQXAK5q1D/IuKTd65cYcfXCr7pzT8CYWOm7iiD8yi9/jwqo
        aX5KoMgET2eVgYsOHYXr8LqKcZGMrtgsUqaOIlcLsTuOH2zMgJYJ+RezzhUX930jG15vCA
        gHCKw3vVRpuSBISTK+gOz8IWnwVMkmg=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-QaB4mWsOOPmeT9d8KwVPWQ-1; Mon, 24 Feb 2020 04:17:18 -0500
X-MC-Unique: QaB4mWsOOPmeT9d8KwVPWQ-1
Received: by mail-ot1-f70.google.com with SMTP id d16so5694261otp.10
        for <stable@vger.kernel.org>; Mon, 24 Feb 2020 01:17:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=N/fKsDtxSAzMIh6BDAj358XjJ/ekm/gCjQo0tpt4kAQ=;
        b=IG4WZLSUc4fjrdxaqmJj/SLK9OUHTW3qr0V3YkVftZVjI0SIHxMPz+0sVQjmXcXmun
         wVUp0vxd+Z1JOEFhXSwpMdXnRGxy+3WG+pRYDlh+I0hO5l6e17t4KnFim3ra3S/IHiIJ
         DVs5MsgN0WlzEQxFjOYLa05bG+tDnnE1HkW3ajg4SmPIN4/2qIn7X5rEUIKmt1RfUedK
         3gCew0TeDyI/YmuZkc2dK5wdUAmlUkoTOpgMc4/122qH7K/6Tc33K6ehfvsw9iyYuTRs
         3Og8QXle+uap+9CblSiQi6z3eMRruMxohgd2W6q1GsnnL79VF7oGOnPux53xi8K9DBSY
         V7Nw==
X-Gm-Message-State: APjAAAUoOXheof16Rkk3elbUf52n8beu37Hrs6dP1M8Sja5yaszO261i
        Edvyjq0rNsscwsxo4rFqhgyxjJsesrNp3V6B/Rw2OoAk8LAtWRVixjjkl68mheLb2KZr/Ns19DP
        7z5jGZPjYmxWLZXGgt0uecPP2kcHw9G0m
X-Received: by 2002:aca:514e:: with SMTP id f75mr12343822oib.103.1582535837631;
        Mon, 24 Feb 2020 01:17:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqwPLrq0wTOhHpLHGOtIpA4JFgxJILmp7yaf1lWt5isYMlJWblokNpIaxenEogKenazMafElLgv4QLAl5aFEHws=
X-Received: by 2002:aca:514e:: with SMTP id f75mr12343813oib.103.1582535837387;
 Mon, 24 Feb 2020 01:17:17 -0800 (PST)
MIME-Version: 1.0
References: <cki.C91ED894FB.V073T4NSBU@redhat.com>
In-Reply-To: <cki.C91ED894FB.V073T4NSBU@redhat.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Mon, 24 Feb 2020 10:17:06 +0100
Message-ID: <CAFqZXNvnywGVwqJhXcfwpmx2mmu8ajAUOdy0Ny8PvsT=Rg_3Qg@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOKdjCBGQUlMOiBUZXN0IHJlcG9ydCBmb3Iga2VybmVsIDUuNC4yMi1yYzItYjBiNA==?=
        =?UTF-8?B?MTMwLmNraSAoc3RhYmxlKQ==?=
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Milos Malik <mmalik@redhat.com>,
        SElinux list <selinux@vger.kernel.org>,
        Richard Haines <richard_c_haines@btinternet.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 23, 2020 at 10:44 PM CKI Project <cki-project@redhat.com> wrote=
:
> Hello,
>
> We ran automated tests on a recent commit from this kernel tree:
>
>        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/=
linux-stable-rc.git
>             Commit: b0b41307fca1 - Linux 5.4.22-rc2
>
> The results of these automated tests are provided below.
>
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: FAILED
>
> All kernel binaries, config files, and logs are available for download he=
re:
>
>   https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=3Dda=
tawarehouse/2020/02/23/453522
>
> One or more kernel tests failed:
>
>     ppc64le:
>      =E2=9D=8C selinux-policy: serge-testsuite
>      =E2=9D=8C Boot test
>
>     aarch64:
>      =E2=9D=8C selinux-policy: serge-testsuite
>
>     x86_64:
>      =E2=9D=8C selinux-policy: serge-testsuite

The SELinux testsuite failed due to the kernel headers being newer
than the running kernel itself. It is not (AFAICT) a bug in the
kernel. For more details see this patch, which should make the
testsuite work also in such situation:

https://github.com/SELinuxProject/selinux-testsuite/commit/859ccfd0a00970ab=
3f2459e19f2f3c3d950b8ed4

I need to test it and then I'll send it to the list for review.

>
> We hope that these logs can help you find the problem quickly. For the fu=
ll
> detail on our testing procedures, please scroll to the bottom of this mes=
sage.
>
> Please reply to this email if you have any questions about the tests that=
 we
> ran or if you have any suggestions on how to make future tests more effec=
tive.
>
>         ,-.   ,-.
>        ( C ) ( K )  Continuous
>         `-',-.`-'   Kernel
>           ( I )     Integration
>            `-'
[...]

--=20
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.

