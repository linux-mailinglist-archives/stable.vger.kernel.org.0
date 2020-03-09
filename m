Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 867A317EBA6
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 23:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgCIWEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 18:04:21 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23030 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726439AbgCIWEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 18:04:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583791460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yvJTacKjNVOztH256dZHpNYhzX5dRhKvlA341VjdCi8=;
        b=Uf816iHzFdgRt9B1h54EOGetWFZaeDFW45+cNWSPl4A4kayeiBf8XtWyV13gCAs0IcX4Zv
        IThN6A1tlCsw3tGPyqlNZquZT9PNGmCytKD+23EU6hKKq1IaGou4oQ+VKMmyBJuzes4vFO
        sV08UFakar/9pMql7dTVpvm+9GYnY1s=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-2kytYYPVP9OU195X2NJTfw-1; Mon, 09 Mar 2020 18:04:10 -0400
X-MC-Unique: 2kytYYPVP9OU195X2NJTfw-1
Received: by mail-ot1-f72.google.com with SMTP id s15so7412504otk.7
        for <stable@vger.kernel.org>; Mon, 09 Mar 2020 15:04:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yvJTacKjNVOztH256dZHpNYhzX5dRhKvlA341VjdCi8=;
        b=qF+k2fujwh3shuQNdHMEATzsZinietQa3ih0PvUfmILeX+vcA+IjpDjeYmc+5v4JsU
         RpzNsOVfYrBfoZ4RNm+winNGudqqBTWspLOTOPbhkOGfHWG3adktAeZb23UANC2rNpYM
         fa3vztM9jMz0COPCT7T8hNOW+M7UseBWzpTzAm0JBnh76nJc9kXKmL9Ze/VjJSlwJBLf
         qqgDoeCO0Lod7SSGK8tJbtsp8Hy+EsSFJCI6TeIEnOXoefBrhBL5dd3rKYi2hPzlfUFG
         6i3H8w0hmH8AZWDP+d2Um5jDreMFMbgHoYzE0NFYqtDNgEB9OyoGe4FWUg1OZTSFcIOG
         cY+Q==
X-Gm-Message-State: ANhLgQ0ffG/cMAxjXhf02mZAsZ6erCAUtg+OlqFI/sdQvam4NTLiSkkU
        4EP+o8lEir3ZRvC4iRZnABj+HoSvFWVAM2nGPZqna6JQ1DlGBkphC3K0Fcc5PIEHa9zMkftNMm9
        DCYGO0acgZTBNZ5aPCwiyuws+HYjDy2Hq
X-Received: by 2002:a9d:7458:: with SMTP id p24mr2890848otk.197.1583791448703;
        Mon, 09 Mar 2020 15:04:08 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsFE8SXSJ8i3wT/MUNuNnTpNxro53ctEUbxx3P0T+4oUrP1CSaaaAbP5OdDtfFhAVMUywBT7KEphLu8efKRKdk=
X-Received: by 2002:a9d:7458:: with SMTP id p24mr2890827otk.197.1583791448361;
 Mon, 09 Mar 2020 15:04:08 -0700 (PDT)
MIME-Version: 1.0
References: <cki.411617A928.D7E40QQCW6@redhat.com> <20200309215305.GV21491@sasha-vm>
In-Reply-To: <20200309215305.GV21491@sasha-vm>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Mon, 9 Mar 2020 23:03:57 +0100
Message-ID: <CAFqZXNugDTJ8MQePK1Cyz2TOJiPcPrq3ohmNZngJjaTCq1Y6mQ@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=E2=9D=8C_PANICKED=3A_Test_report_for_kernel_5=2E5=2E8=2Dc30f3?=
        =?UTF-8?Q?3b=2Ecki_=28stable=2Dqueue=29?=
To:     Sasha Levin <sashal@kernel.org>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>,
        Ondrej Moris <omoris@redhat.com>,
        William Gomeringer <wgomeringer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Mon, Mar 9, 2020 at 10:53 PM Sasha Levin <sashal@kernel.org> wrote:
>
> On Mon, Mar 09, 2020 at 09:24:35PM -0000, CKI Project wrote:
> >
> >Hello,
> >
> >We ran automated tests on a recent commit from this kernel tree:
> >
> >       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stab=
le/linux-stable-rc.git
> >            Commit: c30f33bfb014 - selftests: forwarding: vxlan_bridge_1=
d: use more proper tos value
> >
> >The results of these automated tests are provided below.
> >
> >    Overall result: FAILED (see details below)
> >             Merge: OK
> >           Compile: OK
> >             Tests: PANICKED
> >
> >All kernel binaries, config files, and logs are available for download h=
ere:
> >
> >  https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=3Dd=
atawarehouse/2020/03/09/480158
> >
> >One or more kernel tests failed:
> >
> >    s390x:
> >     =E2=9D=8C LTP
> >
> >    ppc64le:
> >     =E2=9D=8C LTP
> >
> >    aarch64:
> >     =E2=9D=8C audit: audit testsuite test
> >
> >    x86_64:
> >     =E2=9D=8C audit: audit testsuite test
>
> Following the link above I got to
> https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=3Ddata=
warehouse/2020/03/09/480158/audit__audit_testsuite_test/,
> but it shows that all tests are passing? The console log looks fine too:
> https://cki-artifacts.s3.us-east-2.amazonaws.com/datawarehouse/2020/03/09=
/480158/x86_64_5_console.log.
> Where's the panic?

The panic happened during the LTP test on s390x (note the lightning
symbols under s390x, Host 1). The backtrace is at the end of
https://cki-artifacts.s3.us-east-2.amazonaws.com/datawarehouse/2020/03/09/4=
80158/s390x_1_console.log

Cheers,

--=20
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.

