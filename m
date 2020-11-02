Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40D52A30CB
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 18:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727288AbgKBREV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 12:04:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25505 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727258AbgKBREV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 12:04:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604336660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cTWdDmfFyU10xuhsQywfT5+4dHaUGI2TXBXRg+/NdXo=;
        b=HU0JsEdVRdrIKgWqbOL7YyaZaCKvDpykZXN7787vO5Tl2pnP/j4EQnvI2ldHNlqnlbt6ob
        RUkCSY51WUzMlFLG6JfQKv5snIRk5nsGmy5cu7IKvtvJVZyt6awSwE3BlOH3jmyMTlvHPM
        hBfYz+GHjaZMhTmCjrTgCy9bpJSnLz4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-SMK3Xnq2NJ61Oca76S6UbA-1; Mon, 02 Nov 2020 12:04:17 -0500
X-MC-Unique: SMK3Xnq2NJ61Oca76S6UbA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55265186840A
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 17:04:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CD62672C0
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 17:04:16 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 147C044A43
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 17:04:16 +0000 (UTC)
Date:   Mon, 2 Nov 2020 12:04:13 -0500 (EST)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Message-ID: <971679390.17141775.1604336653221.JavaMail.zimbra@redhat.com>
In-Reply-To: <cki.DDA75A7FB6.0XD3MFOTWJ@redhat.com>
References: <cki.DDA75A7FB6.0XD3MFOTWJ@redhat.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Test_report_for_kernel_5.9.3_(stable-queue)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.40.193.104, 10.4.195.18]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel 5.9.3 (stable-queue)
Thread-Index: InC9IJvsGhqW0ZafFuDK0aN9JWcp0Q==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> From: "CKI Project" <cki-project@redhat.com>
> To: "Linux Stable maillist" <stable@vger.kernel.org>
> Sent: Monday, November 2, 2020 6:03:09 PM
> Subject: =E2=9D=8C FAIL: Test report for kernel 5.9.3 (stable-queue)
>=20
>=20
> Hello,
>=20
> We ran automated tests on a recent commit from this kernel tree:
>=20
>        Kernel repo:
>        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
>             Commit: 7a177c028851 - nvme-rdma: fix crash when connect reje=
cted
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
>   https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.html?p=
refix=3Ddatawarehouse-public/2020/11/02/616599
>=20
> We attempted to compile the kernel for multiple architectures, but the
> compile
> failed on one or more architectures:
>=20
>             x86_64: FAILED (see build-x86_64.log.xz attachment)
>=20

00:01:58 sound/soc/sof/intel/hda-codec.c: In function =E2=80=98hda_codec_pr=
obe=E2=80=99:
00:01:58 sound/soc/sof/intel/hda-codec.c:177:4: error: label =E2=80=98error=
=E2=80=99 used but not defined
00:01:58   177 |    goto error;
00:01:58       |    ^~~~
00:01:58 make[6]: *** [scripts/Makefile.build:283: sound/soc/sof/intel/hda-=
codec.o] Error 1
00:01:58 make[5]: *** [scripts/Makefile.build:500: sound/soc/sof/intel] Err=
or 2
00:01:58 make[4]: *** [scripts/Makefile.build:500: sound/soc/sof] Error 2
00:01:58   CC [M]  net/ieee802154/6lowpan/core.o
00:01:58 make[3]: *** [scripts/Makefile.build:500: sound/soc] Error 2
00:01:58   CC [M]  drivers/mfd/sm501.o
00:01:58 make[2]: *** [Makefile:1784: sound] Error 2


Hi,

looks to be introduced by

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/=
commit/?h=3Dqueue/5.9&id=3Dfac9325d3013de4a4ffe8ed82fb386a7e9fce246


Veronika

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
>       make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>     ppc64le:
>       make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>     s390x:
>       make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>     x86_64:
>       make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>=20
>=20

