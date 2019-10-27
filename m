Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A420E61D6
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 10:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfJ0Jca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 05:32:30 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42711 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726106AbfJ0Jca (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 05:32:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572168747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Brt12eroTnBSuocOIrOnaBRgY6eEG5OTxhduVRLWoHo=;
        b=LoAhIncJFNIXESEu9hO8qvtitgpgQ6+/IAlmjUKMZcfwSFSheF4zJM4PZ39QUf6AjgAzUI
        iIWF81SPMY/IXvmbQ3tXSMDgaDKp7KyYFdzieedY0bnZ6I+mxHycsOyD/XMP8RjkseMT6d
        pzbnB9nIln6lVcMh5RDehAAeI1DPXyE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-xLzG1hxvNamOpilH46Ypcw-1; Sun, 27 Oct 2019 05:32:24 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A891E801E56;
        Sun, 27 Oct 2019 09:32:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A040E90AB;
        Sun, 27 Oct 2019 09:32:23 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8D04D1808878;
        Sun, 27 Oct 2019 09:32:23 +0000 (UTC)
Date:   Sun, 27 Oct 2019 05:32:23 -0400 (EDT)
From:   Jan Stancek <jstancek@redhat.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        LTP List <ltp@lists.linux.it>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>,
        Memory Management <mm-qe@redhat.com>
Message-ID: <2111263587.9218283.1572168743324.JavaMail.zimbra@redhat.com>
In-Reply-To: <CA+G9fYurG8gSO+xFc5LJvLMrqTyHG85oxH9=pSQ1LmPCa6PkqQ@mail.gmail.com>
References: <cki.61C56EFD16.AR8ITWHB7P@redhat.com> <CA+G9fYurG8gSO+xFc5LJvLMrqTyHG85oxH9=pSQ1LmPCa6PkqQ@mail.gmail.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Stable_queue:_queue-5.3?=
MIME-Version: 1.0
X-Originating-IP: [10.43.17.163, 10.4.195.1]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Stable queue: queue-5.3
Thread-Index: gNe4i/TBRrbrR5tiA3xma7jiYmwpjA==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: xLzG1hxvNamOpilH46Ypcw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> Hi Jan,
>=20
> On Sun, 27 Oct 2019 at 04:04, CKI Project <cki-project@redhat.com> wrote:
> >
> >
> > Hello,
> >
> > We ran automated tests on a patchset that was proposed for merging into
> > this
> > kernel tree. The patches were applied to:
> >
> >        Kernel repo:
> >        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
> >             Commit: 365dab61f74e - Linux 5.3.7
> >
> > The results of these automated tests are provided below.
> >
> >     Overall result: FAILED (see details below)
> >              Merge: OK
> >            Compile: OK
> >              Tests: FAILED
> >
> > All kernel binaries, config files, and logs are available for download
> > here:
> >
> >   https://artifacts.cki-project.org/pipelines/249576
> >
> > One or more kernel tests failed:
> >
> >     x86_64:
> >      =E2=9D=8C LTP lite
>=20
> I see these three failures from the logs,

[CC LTP list]

>=20
> LTP syscalls:
> fallocate05                                        FAIL       1

tst_mkfs.c:89: INFO: Formatting /dev/loop0 with ext4 opts=3D'' extra opts=
=3D''
mke2fs 1.45.3 (14-Jul-2019)
tst_test.c:1116: INFO: Timeout per run is 0h 05m 00s
tst_fill_fs.c:29: INFO: Creating file mntpoint/file0 size 21710183
tst_fill_fs.c:29: INFO: Creating file mntpoint/file1 size 8070086
tst_fill_fs.c:29: INFO: Creating file mntpoint/file2 size 3971177
tst_fill_fs.c:29: INFO: Creating file mntpoint/file3 size 36915315
tst_fill_fs.c:29: INFO: Creating file mntpoint/file4 size 70310993
tst_fill_fs.c:29: INFO: Creating file mntpoint/file5 size 4807935
tst_fill_fs.c:29: INFO: Creating file mntpoint/file6 size 90739786
tst_fill_fs.c:29: INFO: Creating file mntpoint/file7 size 76896492
tst_fill_fs.c:49: INFO: write(): ENOSPC (28)
fallocate05.c:50: PASS: write() wrote 8192 bytes
fallocate05.c:54: FAIL: fallocate() succeeded unexpectedly

So, test filled filesystem and fallocate() succeeded anyway.

>=20
> LTP mm:
> oom03                                              FAIL       2
> oom05                                              FAIL       2

This looks like test issue. systemd on Fedora31 started using cgroup2 exclu=
sively:
  cgroup2 on /sys/fs/cgroup type cgroup2 (rw,nosuid,nodev,noexec,relatime,s=
eclabel,nsdelegate)

Tests are trying to mount single hierarchy on cgroup1:
[pid 283933] 04:57:26 mkdir("/dev/cgroup", 0777) =3D 0
[pid 283933] 04:57:26 mount("memcg", "/dev/cgroup", "cgroup", 0, "memory") =
=3D -1 EBUSY (Device or resource busy)

