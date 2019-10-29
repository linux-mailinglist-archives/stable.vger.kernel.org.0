Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0CBE7FAA
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 06:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbfJ2FZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 01:25:49 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41211 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfJ2FZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 01:25:49 -0400
Received: by mail-lj1-f194.google.com with SMTP id m9so4141750ljh.8
        for <stable@vger.kernel.org>; Mon, 28 Oct 2019 22:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BMj/XMca9xb8SASD5M6gVZ9IEBYl59TDwE2I7MM6FQk=;
        b=Fj/D2ai7MfFsCymZEBvBXFNjlHiDr3n337qZjlhHpgS/vexttC4uSoJwdSuDWEyLdM
         VmKbn6suk+Fte2xQusB5D0cbHqZhiuvxfHwRJH3u8Vf5dWYGygrd0GSgmq+pqtipiFcg
         4MlJXEYLL+iuHLt7+1GYa5e8sTAxPhS8vqKDF9b+wUlpaRPuN7K2vJ9P0JbP2jhRfIKO
         yHobD8zOpZaGg+a0ZF8IZ9Aal6di1Rs0km6Nmc6kl3f9Hkktj7HkaVPLojYNE49qY1yu
         LNkB99MrFFAkWancmwdk8B7gtebBVrN8MV+tSeeNH0ksn8SPAtMGpQWALLikgIU250sC
         hNXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BMj/XMca9xb8SASD5M6gVZ9IEBYl59TDwE2I7MM6FQk=;
        b=XOSw3zVv4hP6s2nJU/WHHAi9FW9hGSlNB+rra3jNv9Q8eQkXDCvv88uuV0XOQj/sUR
         Nd2j/f367s+J/BrYoUzdb2tkB9GVGKl1REHLbMzUHVvVG4YgJymGOUN/eiFWrEWF8X9P
         5v32E4YhRhpKMvSvCvR98zwN/XCyaD4wofzfRsSzXAnJOnG5Eml9ot9qeA8dMPt9DxIK
         QviQExlew4R4viDu6fZcTJKFQAmbhtwcNk5CCNc14TDPKodxV55hC23Cd65Y+BRbyDqy
         iF5RiUqJDAJZTPD04OLt7M/kAFeU3I07ro8W8yPdY6xwTchs0zBFp2rXLMGAzugtVxkk
         6nxw==
X-Gm-Message-State: APjAAAUK8DXjxQIS8icERsd0GFXFkYMGaFzHJiZGpxiSxVR4z73wP0vT
        /MJnK12JL1UDHTaywZqnd8wn8Fo//bDL4z2a6zObVQ==
X-Google-Smtp-Source: APXvYqxD0Dha9eOBmnmGC92xutE5i9pfRHANdH4Kb/Pl+vOZmM897gi/hU5MHjHg8liyWazowEDGg6/48+fmuMInL74=
X-Received: by 2002:a2e:9702:: with SMTP id r2mr846781lji.194.1572326745366;
 Mon, 28 Oct 2019 22:25:45 -0700 (PDT)
MIME-Version: 1.0
References: <cki.42EF9B43EC.BJO3Y6IXAB@redhat.com>
In-Reply-To: <cki.42EF9B43EC.BJO3Y6IXAB@redhat.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 29 Oct 2019 10:55:34 +0530
Message-ID: <CA+G9fYvhBRweWheZjLqOMrm_cTAxNvexGuk16w9FCt12+V1tpg@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=E2=9D=8C_FAIL=3A_Test_report_for_kernel_5=2E3=2E8=2Drc2=2D96dab?=
        =?UTF-8?Q?43=2Ecki_=28stable=29?=
To:     deepa.kernel@gmail.com
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Xiong Zhou <xzhou@redhat.com>, lkft-triage@lists.linaro.org,
        guaneryu@gmail.com, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, CKI Project <cki-project@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 29 Oct 2019 at 07:33, CKI Project <cki-project@redhat.com> wrote:
>
>
> Hello,
>
> We ran automated tests on a recent commit from this kernel tree:
>
>        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/=
linux-stable-rc.git
>             Commit: 96dab4347cbe - Linux 5.3.8-rc2
>
> The results of these automated tests are provided below.
>
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: FAILED
>
> All kernel binaries, config files, and logs are available for download he=
re:
>
>   https://artifacts.cki-project.org/pipelines/253188
>
> One or more kernel tests failed:
>
>     ppc64le:
>      =E2=9D=8C xfstests: ext4
>      =E2=9D=8C xfstests: xfs
>
>     aarch64:
>      =E2=9D=8C xfstests: ext4
>      =E2=9D=8C xfstests: xfs
>
>     x86_64:
>      =E2=9D=8C xfstests: ext4
>      =E2=9D=8C xfstests: xfs
>

FYI,
The test log output,

Running test generic/402
#! /bin/bash
# SPDX-License-Identifier: GPL-2.0
# Copyright (c) 2016 Deepa Dinamani.  All Rights Reserved.
#
# FS QA Test 402
#
# Test to verify filesystem timestamps for supported ranges.
#
# Exit status 1: test failed.
# Exit status 0: test passed.
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/aarch64 apm-mustang-b0-11 5.3.8-rc2-96dab43.cki
#1 SMP Mon Oct 28 14:23:22 UTC 2019
MKFS_OPTIONS  -- -f -m crc=3D1,finobt=3D1,rmapbt=3D1,reflink=3D1 -i sparse=
=3D1 /dev/sda4
MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:nfs_t:s0 /dev/sda4
/mnt/xfstests/mnt2

generic/402 - output mismatch (see
/var/lib/xfstests/results//generic/402.out.bad)
    --- tests/generic/402.out 2019-10-28 12:19:13.835212771 -0400
    +++ /var/lib/xfstests/results//generic/402.out.bad 2019-10-28
13:13:55.503682127 -0400
    @@ -1,2 +1,4 @@
     QA output created by 402
    +2147483647;2147483647 !=3D 2147483648;2147483648
    +2147483647;2147483647 !=3D -2147483648;-2147483648
     Silence is golden
    ...
    (Run 'diff -u /var/lib/xfstests/tests/generic/402.out
/var/lib/xfstests/results//generic/402.out.bad'  to see the entire
diff)
Ran: generic/402
Failures: generic/402
Failed 1 of 1 tests

Test source:
https://github.com/kdave/xfstests/blob/master/tests/generic/402

Here is the latest test case commit,

generic/402: fix for updated behavior of timestamp limits

The mount behavior will not be altered because of the unsupported
timestamps on the filesystems.

Adjust the test accordingly.

You can find the series at
https://git.kernel.org/torvalds/c/cfb82e1df8b7c76991ea12958855897c2fb4debc

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>

- Naresh
