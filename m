Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C623C9EF6
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 14:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhGOMys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 08:54:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57976 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229973AbhGOMys (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 08:54:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626353514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=My/TV9wPXXC9bA3vgWEHH+ODPTum/Ve84OOkWp1OwdU=;
        b=VBfGva2glK1iVMMVxFQU+9NwaJva5d0roYw/Fqk4EZJLRczunHSkh2+3dmmuHS9a8rv3Yc
        ohRgi9/Wc57z/nbzpZMeX4oMSIceKOfObGfHgDmoH6wHXlMB917U3I3NUejVTOdnMOh7PE
        cbS6p618FTryiAtJN9NfsMNEWrRuaMo=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-Q3Dg6Oz0Ol6VyYNkrApSdg-1; Thu, 15 Jul 2021 08:51:53 -0400
X-MC-Unique: Q3Dg6Oz0Ol6VyYNkrApSdg-1
Received: by mail-lf1-f69.google.com with SMTP id x5-20020a0565121305b029032696702876so1449939lfu.5
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 05:51:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=My/TV9wPXXC9bA3vgWEHH+ODPTum/Ve84OOkWp1OwdU=;
        b=KKG/obH4NCsSqKucw9UrzvO0ee+ndzNz7mtNDVc0Qtyk9Oh1oN7UwWULs1xeScHnfV
         mCfyLUCM1Dmdx+mBnnUVgHoo6GtRCjO6zNeG0ZRE9YwKJ1lQtVMxb9+DuDKAyN3EEbxG
         2AGOU91l6OwhzoHwxyxZHFQMLCvYqK5WWi7vPzkTmZwhR6hf5CJfQByVGv1YeVTHGOlQ
         G3B3zZXRHT5t1gn1QyRIzrgWAt95zfQbUqDUvjhYUFX1upc8Pe+yb5PzQqzzJOc6+oj1
         +Ih3VPbzDRFrMNh708UaVUSyKfQePKFrbaRikikA/41Va1Fl9RaO1Jdgscnl6pG3/hp/
         9rCQ==
X-Gm-Message-State: AOAM532yVornDsrVQ6xLwachBNyEoXNxbSU6waRYu4n177CFakja1W6E
        xC3YobuMfRA2uH/HR2KSLC78UV9uZmh6M1FXQLSwpGAxtTTyQClzZu4s7tk/g0Fdf3JbbYsTgOw
        j+bLWIwh9xac5OIdPtGTE0rLThoKFIFsD
X-Received: by 2002:a19:8642:: with SMTP id i63mr3489515lfd.156.1626353511885;
        Thu, 15 Jul 2021 05:51:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvJVggyb6prCf12pV1ULs/MfDj/PiKhRZb82xUWUuhinxppKB+KoPlYJKiTj9p+eGvgvSpdl2ONHbJmYCUocc=
X-Received: by 2002:a19:8642:: with SMTP id i63mr3489504lfd.156.1626353511703;
 Thu, 15 Jul 2021 05:51:51 -0700 (PDT)
MIME-Version: 1.0
References: <cki.8AA4B7C8B2.MU36FLBY8R@redhat.com>
In-Reply-To: <cki.8AA4B7C8B2.MU36FLBY8R@redhat.com>
From:   Veronika Kabatova <vkabatov@redhat.com>
Date:   Thu, 15 Jul 2021 14:51:15 +0200
Message-ID: <CA+tGwnmVdw=B5rnz3QmHeu3jGdHr36yf4MJHR5c11w09tP9Amw@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=E2=9D=8C_FAIL=3A_Test_report_for_kernel_5=2E13=2E2_=28stable=2D?=
        =?UTF-8?Q?queue=2C_ee00910f=29?=
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 15, 2021 at 2:50 PM CKI Project <cki-project@redhat.com> wrote:
>
>
> Hello,
>
> We ran automated tests on a recent commit from this kernel tree:
>
>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>             Commit: ee00910f75ff - powerpc/powernv/vas: Release reference to tgid during window close
>
> The results of these automated tests are provided below.
>
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: FAILED
>
> All kernel binaries, config files, and logs are available for download here:
>
>   https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.html?prefix=datawarehouse-public/2021/07/15/337656806
>
> We attempted to compile the kernel for multiple architectures, but the compile
> failed on one or more architectures:
>
>            ppc64le: FAILED (see build-ppc64le.log.xz attachment)
>             x86_64: FAILED (see build-x86_64.log.xz attachment)
>

Hi, looks to be introduced by

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=queue/5.13&id=07d407cc1259634b3334dd47519ecd64e6818617


Veronika

> We hope that these logs can help you find the problem quickly. For the full
> detail on our testing procedures, please scroll to the bottom of this message.
>
> Please reply to this email if you have any questions about the tests that we
> ran or if you have any suggestions on how to make future tests more effective.
>
>         ,-.   ,-.
>        ( C ) ( K )  Continuous
>         `-',-.`-'   Kernel
>           ( I )     Integration
>            `-'
> ______________________________________________________________________________
>
> Compile testing
> ---------------
>
> We compiled the kernel for 4 architectures:
>
>     aarch64:
>       make options: make -j24 INSTALL_MOD_STRIP=1 targz-pkg
>
>     ppc64le:
>       make options: make -j24 INSTALL_MOD_STRIP=1 targz-pkg
>
>     s390x:
>       make options: make -j24 INSTALL_MOD_STRIP=1 targz-pkg
>
>     x86_64:
>       make options: make -j24 INSTALL_MOD_STRIP=1 targz-pkg
>
>

