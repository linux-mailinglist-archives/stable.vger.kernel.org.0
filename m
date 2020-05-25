Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12A11E11A0
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 17:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403999AbgEYPXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 11:23:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43627 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2403997AbgEYPXv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 11:23:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590420230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hb6A5oEE/7flZ7kgFaC1rhHPEB8uJ59S8yMg9iSDYYw=;
        b=cTm5k5nO1huxgu/J6chSB74SxDO06rlI9uh70S6wqINIUxZXE2N0wmb8Vmrg3vs0AfUicd
        tbHTPFUrCdmdOFoC2h7hdltfcRFnpJEgmQy2VhQZ8uJS4UAO0LLYluo0i592oPAT6yOZcU
        ahacsWGjrKvCgkD/rsSQVmG8d0ffXzU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-T5i8NFYfN6WdsdkUvpjg6Q-1; Mon, 25 May 2020 11:23:48 -0400
X-MC-Unique: T5i8NFYfN6WdsdkUvpjg6Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67FA01005510
        for <stable@vger.kernel.org>; Mon, 25 May 2020 15:23:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 626856EDA5
        for <stable@vger.kernel.org>; Mon, 25 May 2020 15:23:47 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5B8B41809542;
        Mon, 25 May 2020 15:23:47 +0000 (UTC)
Date:   Mon, 25 May 2020 11:23:47 -0400 (EDT)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Cc:     CKI Project <cki-project@redhat.com>
Message-ID: <1238663306.24257335.1590420227156.JavaMail.zimbra@redhat.com>
In-Reply-To: <cki.09562F3C51.NRM7O0HL2X@redhat.com>
References: <cki.09562F3C51.NRM7O0HL2X@redhat.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Test_report_for_kernel?=
 =?utf-8?Q?_5.6.14-79935d9.cki_(stable-queue)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.40.195.224, 10.4.195.29]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel 5.6.14-79935d9.cki (stable-queue)
Thread-Index: de24cRnY0YaKE6fCTFP86/mbOwxnBA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> From: "CKI Project" <cki-project@redhat.com>
> To: "Linux Stable maillist" <stable@vger.kernel.org>
> Sent: Monday, May 25, 2020 5:22:14 PM
> Subject: =E2=9D=8C FAIL: Test report for kernel 5.6.14-79935d9.cki (stabl=
e-queue)
>=20
>=20
> Hello,
>=20
> We ran automated tests on a recent commit from this kernel tree:
>=20
>        Kernel repo:
>        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
>             Commit: 79935d99370b - x86/unwind/orc: Fix
>             unwind_get_return_address_ptr() for inactive tasks
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
tawarehouse/2020/05/25/580491
>=20
> We attempted to compile the kernel for multiple architectures, but the
> compile
> failed on one or more architectures:
>=20
>            aarch64: FAILED (see build-aarch64.log.xz attachment)
>=20

Hi,

this looks like a bug in the revert.

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/=
commit/?h=3Dqueue/5.6&id=3D1d69ec1bac630983a00b62f155503c53559b3c14

attempts to revert the following commit:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/=
commit/?h=3Dqueue/5.6&id=3D5caf6102e32ead7ed5d21b5309c1a4a7d70e6a9f

but the bus.c changes are not reverted, only bus.h.


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

