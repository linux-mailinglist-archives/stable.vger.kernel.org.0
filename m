Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43254153DEB
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 05:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbgBFEiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 23:38:12 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35475 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbgBFEiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 23:38:12 -0500
Received: by mail-wr1-f68.google.com with SMTP id w12so5508598wrt.2
        for <stable@vger.kernel.org>; Wed, 05 Feb 2020 20:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DtvYv67/s1nbtaXPgc2NQOiL/am7fJBGLfRExMKAfe8=;
        b=zaEEWzBfgk/LDq9aGOl34rQKBOUaqx8sC5/2iQn425Nu8JtfnBsXEg0uVYMZBRKPLg
         uW7N7EckASMCJvpcvsTgKzooPCoi5+kmFyubMwfi67sz4ooCIUYEfAy2rGduDPu8FY+/
         1INzm9BBA+9v5rm9FZrNWw0BargpoHYZFxx7s9Fn6ijxooEVDQh0uMb9unXJxH8WKvnP
         cqV83cJAX8H+nwR+mCeMR3kKymAj+2GTM1Bj9tASL12cLU9QWQu2jJgIil57ZzJMjlnT
         fE7/WrLZ3GQzzSTYzjlSjgpUP4rCxH50sA8gQplgTU4HZ9jVGPXn3+7yoOWfV8Js+hjz
         VHMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DtvYv67/s1nbtaXPgc2NQOiL/am7fJBGLfRExMKAfe8=;
        b=mVbiiHx0WGcL4AvIVMSEhzo1gsAk1To9drvUTGH9yDu9WgZWaQJYWOFYNuvseQLiGF
         RaJvdthYJ9sgLLSmOYS5D7JtPI9l2FLl2Ou4syArLUnBRjDHirkUaV9d95aIuQD7W+0O
         kGhq5iqRsZXoBvaWqHbFr+HaYd9xwFiBz6WYpDyYEsaoUvjytFcvE6rfHfWiNzX/vtnK
         w/d7LBWH1q/pFIYtFe23vG+CTj1XjPeqjssThazbJZ6kRZ/pGJk94qyoJyadCFxRzDhT
         E4NgXy0UyazeJ6uWPZZeAkci4svJJOUeQJ+UELeIGKi0FTrmni3cEgLsVfm6r2pLGW3i
         V8+A==
X-Gm-Message-State: APjAAAU6gbWb3tfGGSDrW3cuQyBsplc5P4GNmCHmy4ZcumtKis1ujj1u
        pAYXmVhYUo3BDHbrgOYwMPSH5qRJ9KdT9g==
X-Google-Smtp-Source: APXvYqwiKpqQx0ipDrORWbzu2opsCi/rcttgmywiHA/e5kOx5Ha46o2dJEp3FXG+OpwyA9AvEf0Y5A==
X-Received: by 2002:adf:ce87:: with SMTP id r7mr1287712wrn.245.1580963889705;
        Wed, 05 Feb 2020 20:38:09 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q130sm2324856wme.19.2020.02.05.20.38.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 20:38:09 -0800 (PST)
Message-ID: <5e3b9831.1c69fb81.75432.969f@mx.google.com>
Date:   Wed, 05 Feb 2020 20:38:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.170
X-Kernelci-Report-Type: build
Subject: stable-rc/linux-4.14.y build: 10 builds: 0 failed, 10 passed,
 6 warnings (v4.14.170)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y build: 10 builds: 0 failed, 10 passed, 6 warnings (v=
4.14.170)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.170/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.170
Git Commit: e0f8b8a65a473a8baa439cf865a694bbeb83fe90
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 4 unique architectures

Warnings Detected:

arc:

arm64:
    defconfig (gcc-8): 1 warning

arm:
    h3600_defconfig (gcc-8): 1 warning
    ks8695_defconfig (gcc-8): 1 warning
    multi_v4t_defconfig (gcc-8): 1 warning
    netx_defconfig (gcc-8): 1 warning
    versatile_defconfig (gcc-8): 1 warning

mips:


Warnings summary:

    6    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may =
be used uninitialized in this function [-Wmaybe-uninitialized]

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---
For more info write to <info@kernelci.org>
