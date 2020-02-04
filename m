Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB43151750
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 10:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgBDJDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 04:03:01 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34607 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726151AbgBDJDA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 04:03:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580806979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MgbQWepxvZEKVjhljUIgxQZLJyyhLVVP/zdUzW5X4U0=;
        b=h1opbibRIobf4/I2TdmZLUNEnQSVA9XTe9nbIFAbfs50Dlp7juk3nlfC/4VSj6f5OEl2Ii
        iF3XGSUUFEhY9apEJgZNqdtOkyuD14sQvrj4Vr77DEZpsAOiOCvyH1TOqCIfOr3W6WJtxZ
        b/KcUJXIgNC3j7KQvTH5+zKpra83CYU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-cuqg0jjXPV2LC1SQt4jJ4w-1; Tue, 04 Feb 2020 04:02:53 -0500
X-MC-Unique: cuqg0jjXPV2LC1SQt4jJ4w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 135F885EE6F;
        Tue,  4 Feb 2020 09:02:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0BADE5DA83;
        Tue,  4 Feb 2020 09:02:51 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 25E861809563;
        Tue,  4 Feb 2020 09:02:51 +0000 (UTC)
Date:   Tue, 4 Feb 2020 04:02:50 -0500 (EST)
From:   Jan Stancek <jstancek@redhat.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>,
        Jaroslav Kysela <jkysela@redhat.com>
Message-ID: <1905459596.5574249.1580806970915.JavaMail.zimbra@redhat.com>
In-Reply-To: <cki.A43C5F6701.3LH2WNZUVM@redhat.com>
References: <cki.A43C5F6701.3LH2WNZUVM@redhat.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Test_report_for_kerne?=
 =?utf-8?Q?l_5.4.18-rc1-6213eed.cki_(stable)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.43.17.25, 10.4.195.11]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel 5.4.18-rc1-6213eed.cki (stable)
Thread-Index: lsdpAyQ4GSnbyv+nGAm45PURpUkWDA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
>        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
>             Commit: 6213eed0e444 - Linux 5.4.18-rc1
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
>   https://artifacts.cki-project.org/pipelines/419091
>=20
> One or more kernel tests failed:
>=20
>     ppc64le:
>      =E2=9D=8C LTP

b45d82cfbabc ("max_map_count: use default overcommit mode")
should address that. CKI job is currently at LTP commit:
  baf4ca1653a9 ("syscalls/capset01: Cleanup & convert to new library")

