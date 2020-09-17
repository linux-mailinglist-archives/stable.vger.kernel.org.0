Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F4A26E3E0
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 20:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgIQShp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 14:37:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33751 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728004AbgIQRFN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 13:05:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600362311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bz+6mZSJB2bAt5SSZ6szT3QcBgmm7s5WRMSwYx0+Ark=;
        b=dU2m17fKNrxowfdYataFb5Bc/+tcBGtBg/i1WLOVHCWF+IVNsyxl4b0xJJityZvrTasmmf
        6gpDUqsYZ1WwoB8CfKjSixF4SoKJsAPvFfYirwjoMQZK33OPxRNCXs3W6gShBL45+rfwb6
        6vs83mCGvuzvPGucCb+7hGGMYXUjR5U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-L_h_DZGMPVeYV_fzS7RG3g-1; Thu, 17 Sep 2020 12:58:52 -0400
X-MC-Unique: L_h_DZGMPVeYV_fzS7RG3g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11BB857053
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 16:58:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A8B11992F
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 16:58:52 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id F2DEB44A77;
        Thu, 17 Sep 2020 16:58:51 +0000 (UTC)
Date:   Thu, 17 Sep 2020 12:58:51 -0400 (EDT)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Cc:     CKI Project <cki-project@redhat.com>
Message-ID: <844826791.11580305.1600361931814.JavaMail.zimbra@redhat.com>
In-Reply-To: <cki.6E3AFCFF18.F6R74WI3JM@redhat.com>
References: <cki.6E3AFCFF18.F6R74WI3JM@redhat.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Test_report_for_?=
 =?utf-8?Q?kernel_5.8.10_(stable-queue)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.40.194.192, 10.4.195.12]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel 5.8.10 (stable-queue)
Thread-Index: jOSNPiqEEYFDmKMCDXaQlSCMX8iA5Q==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> From: "CKI Project" <cki-project@redhat.com>
> To: "Linux Stable maillist" <stable@vger.kernel.org>
> Sent: Thursday, September 17, 2020 6:53:13 PM
> Subject: =E2=9D=8C FAIL: Test report for kernel 5.8.10 (stable-queue)
>=20
>=20
> Hello,
>=20
> We ran automated tests on a recent commit from this kernel tree:
>=20
>        Kernel repo:
>        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
>             Commit: 64d351e12747 - loop: Set correct device size when usi=
ng
>             LOOP_CONFIGURE
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
refix=3Ddatawarehouse/2020/09/17/613941
>=20
> We attempted to compile the kernel for multiple architectures, but the
> compile
> failed on one or more architectures:
>=20
>            ppc64le: FAILED (see build-ppc64le.log.xz attachment)
>=20

Hi, the artifact uploads are suffering some issues right now so I'm includi=
ng
the log excerpt here:

...
00:04:31   MODINFO modules.builtin.modinfo
00:04:32   GEN     modules.builtin
00:04:32   LD      .tmp_vmlinux.kallsyms1
00:04:33 powerpc64le-linux-gnu-ld: arch/powerpc/kernel/cputable.o:(.init.da=
ta+0xd78): undefined reference to `__machine_check_early_realmode_p10'
00:04:33 make[2]: *** [Makefile:1135: vmlinux] Error 1
00:04:33 make[1]: *** [scripts/Makefile.package:109: targz-pkg] Error 2
00:04:33 make: *** [Makefile:1491: targz-pkg] Error 2


This seems to be introduced by=20
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/=
commit/?id=3D72f26692391f65ea65fc46b6cdae128734283946

The kernel misses the function, it mainline it was included in:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D201220bb0e8cb




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

