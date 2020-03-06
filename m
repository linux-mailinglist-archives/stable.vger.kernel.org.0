Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61A2517BC5F
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 13:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgCFMKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 07:10:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25397 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726185AbgCFMKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 07:10:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583496607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9mZXSxOC6R3nHgWWUI6Q0x9r2qUZeyh7+6zlwl+sJKA=;
        b=iwkmCD2jxN41zrIi4yjhvwubS+qdaXde0SSsBuypGjq8srvJhWPmmjYS1vM440hkuBVolU
        8cdxG06Wc1ienoZZfRo7v7FMuNbSQOjVh5RH36bSTL+wrBFMLU8mREZI3rC4oWYT3cGyVw
        KL94y2ut5Q9MBjzN8jeqwvEEpE2zEwk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-zAXhmHtKOOOUQJAOlWa6lw-1; Fri, 06 Mar 2020 07:10:00 -0500
X-MC-Unique: zAXhmHtKOOOUQJAOlWa6lw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F21E4800D50;
        Fri,  6 Mar 2020 12:09:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E89AC46;
        Fri,  6 Mar 2020 12:09:58 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id DA30186A04;
        Fri,  6 Mar 2020 12:09:58 +0000 (UTC)
Date:   Fri, 6 Mar 2020 07:09:58 -0500 (EST)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        LTP Mailing List <ltp@lists.linux.it>,
        Nikolai Kondrashov <spbnick@gmail.com>,
        Inaki Malerba <imalerba@redhat.com>
Message-ID: <1680169507.12167032.1583496598731.JavaMail.zimbra@redhat.com>
In-Reply-To: <20200306080838.GB14808@dell5510>
References: <cki.AEA99E5519.SMAFL9TDK6@redhat.com> <20200306080838.GB14808@dell5510>
Subject: =?utf-8?Q?Re:_[LTP]_=E2=9D=8C_FAIL:_Test_report_for?=
 =?utf-8?Q?=09kernel_5.5.8-97453d9.cki_(stable)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.40.204.182, 10.4.195.4]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel 5.5.8-97453d9.cki (stable)
Thread-Index: WRh379kE2ZSfHWEbe2FjFUkY8TU74g==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> From: "Petr Vorel" <pvorel@suse.cz>
> To: "CKI Project" <cki-project@redhat.com>
> Cc: "Linux Stable maillist" <stable@vger.kernel.org>, "LTP Mailing List" =
<ltp@lists.linux.it>, "Nikolai Kondrashov"
> <spbnick@gmail.com>
> Sent: Friday, March 6, 2020 9:08:38 AM
> Subject: Re: [LTP] =E2=9D=8C FAIL: Test report for=09kernel 5.5.8-97453d9=
.cki (stable)
>=20
> Hi,
>=20
> > We ran automated tests on a recent commit from this kernel tree:
>=20
> >        Kernel repo:
> >        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-sta=
ble-rc.git
> >             Commit: 97453d9b9b2b - Linux 5.5.8
>=20
> > The results of these automated tests are provided below.
>=20
> >     Overall result: FAILED (see details below)
> >              Merge: OK
> >            Compile: OK
> >              Tests: FAILED
>=20
> > All kernel binaries, config files, and logs are available for download
> > here:
>=20
> >   https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=3D=
datawarehouse/2020/03/05/473513
>=20
> > One or more kernel tests failed:
>=20
> >     s390x:
> >      =E2=9D=8C stress: stress-ng
> >      =E2=9D=8C LTP
> Here it's 9 syscalls failed for "slept for too long" [1]
>     28=09tst_timer_test.c:310: FAIL: clock_nanosleep() slept for too long
>     12=09tst_timer_test.c:310: FAIL: nanosleep() slept for too long
>     27=09tst_timer_test.c:310: FAIL: poll() slept for too long
>     22=09tst_timer_test.c:310: FAIL: prctl() slept for too long
>     25=09tst_timer_test.c:310: FAIL: select() slept for too long
>     76=09tst_timer_test.c:310: FAIL: select() slept for too long
>    126=09tst_timer_test.c:310: FAIL: select() slept for too long
>     22=09tst_timer_test.c:310: FAIL: futex_wait() slept for too long
>     53=09tst_timer_test.c:310: FAIL: futex_wait() slept for too long
>=20
> BTW it'd be interesting to see previous build. I searched for stable in j=
obs
> [2], but there is no linux-5.5.y (I see linux-5.4.y).
>=20

We're not on the main kernelci.org page just yet. There's a staging grafana
instance with a limited set of data:

https://staging.kernelci.org:3000/d/home/home?orgId=3D1&var-origin=3Dredhat=
&var-git_repository_url=3DAll

We're planning the dashboard I mentioned in the previous email which should
make the discovery easier, as well as working on getting on the main
Kernel CI page. The best way right now is to check previous stable emails
by CKI Project in the archives:

https://lists.linaro.org/pipermail/linux-stable-mirror/2020-March/

These are two 5.5.y test runs from the list:

https://lists.linaro.org/pipermail/linux-stable-mirror/2020-March/174716.ht=
ml
https://lists.linaro.org/pipermail/linux-stable-mirror/2020-March/174715.ht=
ml

jstancek also already seems to be looking into some s390x issues which migh=
t
be related:

https://lists.linaro.org/pipermail/linux-stable-mirror/2020-March/174549.ht=
ml


Veronika

> Kind regards,
> Petr
>=20
> [1]
> https://cki-artifacts.s3.us-east-2.amazonaws.com/datawarehouse/2020/03/05=
/473513/s390x_2_LTP_syscalls.fail.log
> [2] https://kernelci.org/job/
>=20
>=20
>=20

