Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56AC3FEC90
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 15:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727568AbfKPODe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 09:03:34 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41347 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727551AbfKPODe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Nov 2019 09:03:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573913011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=phs4W9YYs6fFscGsJ+vXifjWd7XE9aJ9PgFGanJA3aM=;
        b=J97ZV9DUgH3PqtubDNpG3x6rclUZgbWOhzbHtAufIcBEwEXX80dANuqEWQia4C0+4s6eFC
        wQj5rmr/HkYId7Vh0t7X2aZcpMCb6oxwNyF1MfFcCmDdfDCr+hmOFkzGxMNnbQz3FrAWdi
        sk6Pi7+C7Ua62zNMY2xCdjuEHgWoxpk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-TlcCh86_MImICTnr8E7qUQ-1; Sat, 16 Nov 2019 09:03:28 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6A121005512;
        Sat, 16 Nov 2019 14:03:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B0038608D0;
        Sat, 16 Nov 2019 14:03:27 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9FA7118095FF;
        Sat, 16 Nov 2019 14:03:27 +0000 (UTC)
Date:   Sat, 16 Nov 2019 09:03:27 -0500 (EST)
From:   Jan Stancek <jstancek@redhat.com>
To:     CKI Project <cki-project@redhat.com>,
        Rachel Sibley <rasibley@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
Message-ID: <1987216338.12689847.1573913007381.JavaMail.zimbra@redhat.com>
In-Reply-To: <cki.FB80424DEC.V1BSM19IWA@redhat.com>
References: <cki.FB80424DEC.V1BSM19IWA@redhat.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Test_report_for_kernel_?=
 =?utf-8?Q?5.4.0-rc7-e1918f0.cki_(stable-next)?=
MIME-Version: 1.0
X-Originating-IP: [10.40.204.45, 10.4.195.27]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel 5.4.0-rc7-e1918f0.cki (stable-next)
Thread-Index: RfJRajFbYqwEY7sbNpESrUw1VYb7Ew==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: TlcCh86_MImICTnr8E7qUQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


----- Original Message -----
>=20
> Hello,
>=20
> We ran automated tests on a recent commit from this kernel tree:
>=20
>        Kernel repo:
>        git://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux-stable.=
git
>             Commit: e1918f0cc92b - kcov: remote coverage support
>=20
> The results of these automated tests are provided below.
>=20
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: FAILED
>=20
> All kernel binaries, config files, and logs are available for download he=
re:
>=20
>   https://artifacts.cki-project.org/pipelines/288750
>=20
> One or more kernel tests failed:
>=20
>     x86_64:
>      =E2=9D=8C LTP lite

Not a kernel problem.=20

Rachel,

You appear to be running LTP which doesn't have commit below.
Host CPU where this failed is family 6, model 71 (INTEL_FAM6_BROADWELL_G).

commit 0807a8258fbcf216bdd79a8d74a34b07bb42d8d3
Author: Jan Stancek <jstancek@redhat.com>
Date:   Mon Oct 28 14:33:26 2019 +0100

    pt_test: skip pt_disable_branch on Broadwell CPUs
   =20
    commit d35869ba348d ("perf/x86/intel/pt: Allow the disabling of branch =
tracing")
    disallows not setting BRANCH_EN due to erratum BDM106 on Broadwell CPUs=
.

