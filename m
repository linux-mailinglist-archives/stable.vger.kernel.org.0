Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 511D717AB00
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 17:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgCEQ4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 11:56:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28052 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726092AbgCEQ4L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Mar 2020 11:56:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583427369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n9SivJVu+fQ+64T5Hjkz3v1ZMb9dZxIa2r8KbXyL5Gs=;
        b=hiaNvF6HXKphpmSrOkoQpZ0gD3K96fZVDKsDlyCtH1V3+ZhlhAdE8gSD2K2+2MPzVm+z4i
        f/ZmY088PsgX6noh+gFOQDB1GL5Bjr2J0/diGDSFYpTufoAPUzU9xqM1hnYXJK8BWEqL6G
        zpEZhC2Bm1Ai72cHFxZPifCrHmiQw7w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-esYLcx6_MO-QYNtXYagVUA-1; Thu, 05 Mar 2020 11:56:03 -0500
X-MC-Unique: esYLcx6_MO-QYNtXYagVUA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0042DB62;
        Thu,  5 Mar 2020 16:56:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9567F272C4;
        Thu,  5 Mar 2020 16:56:02 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 83E8186A04;
        Thu,  5 Mar 2020 16:56:02 +0000 (UTC)
Date:   Thu, 5 Mar 2020 11:56:02 -0500 (EST)
From:   Jan Stancek <jstancek@redhat.com>
To:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Cc:     Memory Management <mm-qe@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
Message-ID: <173385062.10432633.1583427362328.JavaMail.zimbra@redhat.com>
In-Reply-To: <2065777364.10425170.1583425488638.JavaMail.zimbra@redhat.com>
References: <cki.EED856DF66.LLEP90YP5M@redhat.com> <2065777364.10425170.1583425488638.JavaMail.zimbra@redhat.com>
Subject: =?utf-8?Q?Re:_[LTP]__=E2=9D=8C_FAIL:_Test_report_for_ke?=
 =?utf-8?Q?rnel_5.5.7-60528b7.cki_(stable-queue)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.43.17.25, 10.4.195.1]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel
 5.5.7-60528b7.cki (stable-queue)
Thread-Index: kkuOJFuqhkSqHy2lWMvJx4dG0KzmcTW74Dzw
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
>=20
>=20
> ----- Original Message -----
> >=20
> > Hello,
> >=20
> > We ran automated tests on a recent commit from this kernel tree:
> >=20
> >        Kernel repo:
> >        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-sta=
ble-rc.git
> >             Commit: 60528b79e30a - kvm: nVMX: VMWRITE checks unsupporte=
d
> >             field before read-only field
> >=20
> > The results of these automated tests are provided below.
> >=20
> >     Overall result: FAILED (see details below)
> >              Merge: OK
> >            Compile: OK
> >              Tests: FAILED
> >=20
> > All kernel binaries, config files, and logs are available for download
> > here:
> >=20
> >   https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=3D=
datawarehouse/2020/03/04/471505
> >=20
> > One or more kernel tests failed:
> >=20
> >     s390x:
> >      =E2=9D=8C LTP
>=20
> All instances of similar panics [1] manifest mostly on s390 and at
> first glance look like memory corruptions.
>=20
> I'm looking to confirm, whether this has been fixed by:
>=20
>   commit 6fcca0fa48118e6d63733eb4644c6cd880c15b8f
>   Author: Suren Baghdasaryan <surenb@google.com>
>   Date:   Mon Feb 3 13:22:16 2020 -0800
>=20
>     sched/psi: Fix OOB write when writing 0 bytes to PSI files

It's unrelated. The test does read, not write.

5.6.0-0.rc3 crashed as well. On s390x I'm using it's enough to
"cat /sys/fs/cgroup/cpu.pressure" to trigger.

