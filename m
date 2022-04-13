Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A571A4FF719
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 14:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbiDMMx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 08:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235629AbiDMMx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 08:53:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 70A235674B
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 05:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649854263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Eulm2y9aUTnIqbN96P5OgT83WpD2X3ejmdT0ZWZScxQ=;
        b=X1ixnUKEhwScKoiR8yac5nOfHjLX2EbYxPnZY7Ya+7jKGNmt9dzfCmslb8+r6wQWHMla9H
        UqCDEXGapaHYVEupmsJIwxwVWZV4Y4tqEMhtqG+xVvlY+3PAQtJcbwXo96gD0d6AtJoaQn
        YvU7bWwHqlqKgIGbUE3SH2NAQiEWOb4=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-4Uwn-FTTOTC-WDk4N1AIzg-1; Wed, 13 Apr 2022 08:51:02 -0400
X-MC-Unique: 4Uwn-FTTOTC-WDk4N1AIzg-1
Received: by mail-lf1-f70.google.com with SMTP id h11-20020a0565123c8b00b0044b05b775ceso884626lfv.6
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 05:51:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Eulm2y9aUTnIqbN96P5OgT83WpD2X3ejmdT0ZWZScxQ=;
        b=4eGf1WGzH75/PLSc7mdPfZLIx5c4/5jeXfb8PRGtxLZFX7Tp9Sm0jg3Py5Q//vrMWx
         6p9ANHXMRfNPIP/jWrxfI6f0cwyVPMywlQAZBc3jMlMg2/h8Xl/m6qUKxoaQ3bV4VfbB
         W5nHdnB12g043EzYW+nTnODzy6+5knxzu37QCj2ZCJ6fDIxDcEQbxL4JcGdaUf4UAcKo
         iEfWZyXNXvH2cwwM+i8dzYlcLcJsA0pDkzRexznMrkcm9Ggjph9HRjf1+PHj1lPCQgS3
         iKKQYxWs7CP8ya9OEm8npymSo8ur4dGWGSzyrsV5GsJXmmBaGf0cQFxwRoXtC8Xrbotf
         M79A==
X-Gm-Message-State: AOAM531Kg0B6SfDD5FI8n3HO1L3GczlyhM6tM22yz3sPfCPQxFhOP5+t
        icnjRhCFO5822Yh98G57hyYb2I4K1AKNc9R0jZ7j+f5JWygs/WmLCXB3d9me4sSw0Lj1PoNMvCP
        MqdjeMMhJCBB1rkpqegMjhiRjVIFs2RhT
X-Received: by 2002:a05:651c:1603:b0:248:e00:aeba with SMTP id f3-20020a05651c160300b002480e00aebamr26558643ljq.456.1649854260743;
        Wed, 13 Apr 2022 05:51:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwu2OyzEJ4JRTKw7vAZezWqYqiMF//+sKH8r1BvdcnZgLuD8haa3z4A8gh3aKmOoGYr+OtLLE6BDwND6pgVEiA=
X-Received: by 2002:a05:651c:1603:b0:248:e00:aeba with SMTP id
 f3-20020a05651c160300b002480e00aebamr26558629ljq.456.1649854260503; Wed, 13
 Apr 2022 05:51:00 -0700 (PDT)
MIME-Version: 1.0
References: <cki.LEF6Q6V9CU1O7JTZ58AW@redhat.com> <YlZse4JgKRqMBdJ1@kroah.com>
In-Reply-To: <YlZse4JgKRqMBdJ1@kroah.com>
From:   Veronika Kabatova <vkabatov@redhat.com>
Date:   Wed, 13 Apr 2022 14:50:24 +0200
Message-ID: <CA+tGwnmKj22790PG3hVYbx_80cpSD_KfKc_qG-YpzQHYZWiYFA@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=E2=9D=8C_FAIL=3A_Test_report_for_kernel_5=2E17=2E2_=28stable=2D?=
        =?UTF-8?Q?queue=2C_eabfed45=29?=
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     CKI Project <cki-project@redhat.com>,
        skt-results-master@redhat.com,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        Li Wang <liwang@redhat.com>, Jan Stancek <jstancek@redhat.com>,
        Guangwu Zhang <guazhang@redhat.com>,
        Filip Suba <fsuba@redhat.com>,
        Fendy Tjahjadi <ftjahjad@redhat.com>,
        Yi Zhang <yizhan@redhat.com>,
        Changhui Zhong <czhong@redhat.com>,
        Bruno Goncalves <bgoncalv@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 13, 2022 at 8:24 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Apr 13, 2022 at 06:03:14AM -0000, CKI Project wrote:
> >
> >
> > Check out this report and any autotriaged failures in our web dashboard:
> >     https://datawarehouse.cki-project.org/kcidb/checkouts/38921
> >
> > Hello,
> >
> > We ran automated tests on a recent commit from this kernel tree:
> >
> >        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> >             Commit: eabfed45bc7c - io_uring: drop the old style inflight file tracking
>
> It's alive!
>
> > The results of these automated tests are provided below.
> >
> >     Overall result: FAILED (see details below)
> >              Merge: OK
> >            Compile: OK
> >              Tests: FAILED
> >     Targeted tests: NO
>
> But things are failing.
>
> Is this the CKI tool's issue, or is it the patches in the stable queue's
> issue?
>
> Given that CKI has been dead for so long, I'll guess it's a CKI issue
> unless you all say otherwise.
>

Hi,

yes, we finally got the builds fixed and are able to run the testing,
and immediately hit the following Fedora bug:

https://bugzilla.redhat.com/show_bug.cgi?id=2074083

We're looking into what exactly went wrong, the initial suspect is
that the bug caused aborted test runs which confused the
reporting system. Sorry about that, and thank you for reaching
out about the problem!

The listed failures are actual failures (both test and kernel bugs),
but not specific to the stable tree. They were already reported to
the relevant places. If you wish, you can look into the details in the
provided DataWarehouse link.

We're working on transforming the email reports to include the
known issue detection that is currently provided in the dashboard,
it should be in place in the (hopefully) near future. That should
also stabilize the emails.

Veronika

> thanks,
>
> greg k-h
>

