Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39923216D99
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 15:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgGGNWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 09:22:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59248 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726900AbgGGNWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 09:22:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594128141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9ue6YYwk32A9nIg6/1Spz15c47zqLAbofPO02wmWeik=;
        b=OjpnN0vtnQ+Vjpj2F1zlBLSksolsD4GKopT1h2h0hO8E21zApU5sZ9QXjWuV1ZN998vBF+
        HVaWKM4nvC36QeSW1p2xOqSaXLSmDEtz5SL6lpIUt/rvxb+hW5+6gzwQx0DtUAddVB3uML
        PWDoceFPcXOpa7GbLqw2s8R3BJ3f3oA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-6CHOsRkHPJaB4yhjr2Zvjw-1; Tue, 07 Jul 2020 09:22:19 -0400
X-MC-Unique: 6CHOsRkHPJaB4yhjr2Zvjw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5CF96EE00
        for <stable@vger.kernel.org>; Tue,  7 Jul 2020 13:22:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 27DB273FE0
        for <stable@vger.kernel.org>; Tue,  7 Jul 2020 13:22:18 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1B2DC1809542;
        Tue,  7 Jul 2020 13:22:18 +0000 (UTC)
Date:   Tue, 7 Jul 2020 09:22:18 -0400 (EDT)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Cc:     CKI Project <cki-project@redhat.com>
Message-ID: <797274823.1395373.1594128138075.JavaMail.zimbra@redhat.com>
In-Reply-To: <cki.F7C2FD0653.HR5I5NSB1Z@redhat.com>
References: <cki.F7C2FD0653.HR5I5NSB1Z@redhat.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Test_report_for_kerne?=
 =?utf-8?Q?l_5.7.7-3df5764.cki_(stable-queue)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.40.193.99, 10.4.195.18]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel 5.7.7-3df5764.cki (stable-queue)
Thread-Index: WaGJgMwE5uxvqdhG+A5uBm5P9d3V0w==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> From: "CKI Project" <cki-project@redhat.com>
> To: "Linux Stable maillist" <stable@vger.kernel.org>
> Sent: Tuesday, July 7, 2020 3:20:30 PM
> Subject: =E2=9D=8C FAIL: Test report for kernel 5.7.7-3df5764.cki (stable=
-queue)
>=20
>=20
> Hello,
>=20
> We ran automated tests on a recent commit from this kernel tree:
>=20
>        Kernel repo:
>        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
>             Commit: 3df5764655da - Revert "ALSA: usb-audio: Improve frame=
s
>             size computation"
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
tawarehouse/2020/07/07/609686
>=20
> We attempted to compile the kernel for multiple architectures, but the
> compile
> failed on one or more architectures:
>=20
>            aarch64: FAILED (see build-aarch64.log.xz attachment)
>=20

Hi,

this seems to be caused by

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/=
commit/?h=3Dqueue/5.7&id=3D4773ae0e5c3738779b50e7cb73bf3443b3c84343


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

