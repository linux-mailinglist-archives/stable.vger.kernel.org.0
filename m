Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76E9C161B88
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 20:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbgBQTVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 14:21:39 -0500
Received: from mail-wr1-f43.google.com ([209.85.221.43]:39091 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbgBQTVj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 14:21:39 -0500
Received: by mail-wr1-f43.google.com with SMTP id y11so21091496wrt.6
        for <stable@vger.kernel.org>; Mon, 17 Feb 2020 11:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YFbLSf+1muDGqbWOH9O0Xck0wQTU+1QODFuPi17l39M=;
        b=Aa5Vhffke8MvvzaFMN5T90sI0z32ABP34rFRsbOc/qYx3wjTNtTlCftG7uhFnxv0pe
         munB+rIkTzO/k6DvixZuH15uaY6ctb+d6zDXoXjRHg5IPatDqoquXNG3KReXpwqR7/bF
         LPzFyCvx7yg/S/HFyYQdciXXlzKqo7yTFPppvKcNcK5E21kf0R9naMUg5wnlGkL+/mB4
         kL5TzrKtJCcdR83WHJbWz122c5tXeUdU2l12qfJKGN5MGC2oKHYB4Lph7Ux1Td2XO7aI
         XsVYiS6Qo8Ip+E2x3FKaJrG51HawouBi8k0YRwDH7yOCGM54H7WkBZW4HDCbF5CMb/wC
         AsYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YFbLSf+1muDGqbWOH9O0Xck0wQTU+1QODFuPi17l39M=;
        b=LGwom6P6DmEtimp1ZJ+N76QpVesdBIzJKkhOZbqcS3yfzf8fqArLlCKymHbXeAT0vE
         quOqjlC9Y4/aFeBeN5w/caufNSRUmKL3yGt0NHoBGyZl17f5BXKaL/OvlkxDzF5KLpK+
         aDSeI6MCAgyJ7OTgXvxsQI4nD/KETE5P3hO4kGvMuGnHUaitY3oFZPmHtCHPHpInIniX
         i1kXcsZTCRiNqsBHXrgwHPJI7mgRKS101L1a69PEYgl7x1J7BH3n4d6QKZerkvHUAZUq
         AXkDAw07EsXcbcS1uQfeMSjJaRRushzwYIsyOr5yR4BYEK7lqKq9DfzBfqNULKPW3OdB
         T7yQ==
X-Gm-Message-State: APjAAAWllnZmP27Zm4FuV+FjWJwATrsKDXyLWgh/b58qf+q2+f48I6QQ
        /RHadX6GQto4glQgFfBMN8Mrp+Ee6PUg8Q==
X-Google-Smtp-Source: APXvYqyBo/KzhaOIc+b5d6/EyQ2obYbapUiFE8RwuWBn43ZCdntLLI1SugWaVZCjBbvO1aDyMRG3Ig==
X-Received: by 2002:a5d:4ed0:: with SMTP id s16mr24111574wrv.144.1581967297183;
        Mon, 17 Feb 2020 11:21:37 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a9sm2405565wrn.3.2020.02.17.11.21.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 11:21:36 -0800 (PST)
Message-ID: <5e4ae7c0.1c69fb81.6814f.c333@mx.google.com>
Date:   Mon, 17 Feb 2020 11:21:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.171
Subject: stable-rc/linux-4.14.y build: 16 builds: 0 failed, 16 passed,
 7 warnings (v4.14.171)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y build: 16 builds: 0 failed, 16 passed, 7 warnings (v=
4.14.171)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.171/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.171
Git Commit: 98db2bf27b9ed2d5ed0b6c9c8a4bfcb127a19796
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 4 unique architectures

Warnings Detected:

arc:

arm64:

arm:
    colibri_pxa270_defconfig (gcc-8): 1 warning
    magician_defconfig (gcc-8): 1 warning
    mainstone_defconfig (gcc-8): 1 warning
    netwinder_defconfig (gcc-8): 1 warning
    prima2_defconfig (gcc-8): 1 warning
    versatile_defconfig (gcc-8): 1 warning
    vexpress_defconfig (gcc-8): 1 warning

mips:


Warnings summary:

    7    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may =
be used uninitialized in this function [-Wmaybe-uninitialized]

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---
For more info write to <info@kernelci.org>
