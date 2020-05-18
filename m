Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78DA21D7D1D
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 17:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgERPmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 11:42:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53372 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726958AbgERPmL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 11:42:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589816530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/42AnaZaSScef2KagdsiwkSJLOvXQ5M14Am9TZfORNY=;
        b=hIc98AxfAJKLc2pbIYzOs0/W3EJ2PzC2XBrJxMJvflAigB2kPIinIDrjh/dwAzhojoWZnT
        XU8NI/5XQzE0nH17CmFm2HV/aobxRfEcG6YP5LIaKvzTVbO0inmaBGiW0+wBu9TJyFVgoM
        Ha0rbxhIYIA4YPSn3/fOMnJFOuWf7Y4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-xLHjBU8zP0an6P9sdXtEzA-1; Mon, 18 May 2020 11:42:08 -0400
X-MC-Unique: xLHjBU8zP0an6P9sdXtEzA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 827798C252E
        for <stable@vger.kernel.org>; Mon, 18 May 2020 15:41:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7BF3E1002394
        for <stable@vger.kernel.org>; Mon, 18 May 2020 15:41:59 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 73E9618095FF;
        Mon, 18 May 2020 15:41:59 +0000 (UTC)
Date:   Mon, 18 May 2020 11:41:59 -0400 (EDT)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Cc:     CKI Project <cki-project@redhat.com>
Message-ID: <1063175897.23455623.1589816519233.JavaMail.zimbra@redhat.com>
In-Reply-To: <cki.F4DFA21C5D.24XICWV69E@redhat.com>
References: <cki.F4DFA21C5D.24XICWV69E@redhat.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Test_report_for_kernel?=
 =?utf-8?Q?_5.6.13-d8e36b7.cki=09(stable-queue)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.40.196.17, 10.4.195.10]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel 5.6.13-d8e36b7.cki (stable-queue)
Thread-Index: PgefI4gpc1wv3mA2tYkCzEgn84Fwew==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> From: "CKI Project" <cki-project@redhat.com>
> To: "Linux Stable maillist" <stable@vger.kernel.org>
> Sent: Monday, May 18, 2020 5:39:09 PM
> Subject: =E2=9D=8C FAIL: Test report for kernel 5.6.13-d8e36b7.cki=09(sta=
ble-queue)
>=20
>=20
> Hello,
>=20
> We ran automated tests on a recent commit from this kernel tree:
>=20
>        Kernel repo:
>        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
>             Commit: d8e36b7ce54e - Makefile: disallow data races on gcc-1=
0 as
>             well
>=20
> The results of these automated tests are provided below.
>=20
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: FAILED
>=20
> All kernel binaries, config files, and logs are available for download he=
re:
>=20
>   https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=3Dda=
tawarehouse/2020/05/18/570957
>=20

Hi,

I believe this is introduced by the following patch:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/=
commit/?h=3Dqueue/5.6&id=3Dde3f4548c1083d5ccb2afe1946fa8dd396001eeb


Veronika

> We attempted to compile the kernel for multiple architectures, but the
> compile
> failed on one or more architectures:
>=20
>            aarch64: FAILED (see build-aarch64.log.xz attachment)
>            ppc64le: FAILED (see build-ppc64le.log.xz attachment)
>              s390x: FAILED (see build-s390x.log.xz attachment)
>             x86_64: FAILED (see build-x86_64.log.xz attachment)
>=20
> We hope that these logs can help you find the problem quickly. For the fu=
ll
> detail on our testing procedures, please scroll to the bottom of this
> message.
>=20
> Please reply to this email if you have any questions about the tests that=
 we
> ran or if you have any suggestions on how to make future tests more
> effective.
>=20
>         ,-.   ,-.
>        ( C ) ( K )  Continuous
>         `-',-.`-'   Kernel
>           ( I )     Integration
>            `-'
> _________________________________________________________________________=
_____
>=20
> Compile testing
> ---------------
>=20
> We compiled the kernel for 4 architectures:
>=20
>     aarch64:
>       make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>     ppc64le:
>       make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>     s390x:
>       make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>     x86_64:
>       make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>=20
>=20

