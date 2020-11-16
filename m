Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F512B53D7
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 22:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbgKPVaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 16:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729153AbgKPVaZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 16:30:25 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1D3C0613CF
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 13:30:24 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id d17so7531011plr.5
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 13:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zhoLMeD7cZwA+7hEUZL+onNuWwC14FEGxujZcToXxmo=;
        b=K58NsWzilV9sTXJ8gaXSlNDoNlHV5VavJzHSSmdzIi8RYE8XT6zUpQ+0frt/bS07OL
         P5wuLwaAHtW7kcLFN7eioXSSf5BHpX1vH2+6w+g5w3EnCY2cf5vNWIKVzEmi+KAXpHa8
         C2duPXd/YqaWVOCBIZX90wcoHjRmlQTwr0I7s3I9/898jw+byb95x0uMPvU+8x7RaAXn
         sfRU//yhqol24IUt0iwUG0qzpcjqzeQBLEm23VDaJjzqFFMN+O3HuARGMuB+O8KY2hmE
         F5OYLW73qH+K4TtMzIVjliLyQUmsV762p30Us18nRbbDr+cg1G+aGvktutGyMyO6lkwW
         6nuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zhoLMeD7cZwA+7hEUZL+onNuWwC14FEGxujZcToXxmo=;
        b=N8Lj29xAoNwW1M7mybN9Vt9T6Et6w9lB2VDwo5Rk85BvRlPi+AyUn0eIshzrCjygcw
         7aWO33+TK+ImlH8B6RRteZ1XhXlqFwwyGkmtCgGbyyyIOLbAdHrXaZppVwlMo2GaCIyv
         9OTzZjk/ZIf4t3IlsLAo+My7bknJO20Iskds/K3rskyft5qkZ/Ym7G0E/tdCoUZ4bhl5
         4LBfBgbSh1j0dGoeXFsskzwxeBE/PgGqH6LB3mpNfDL4/zVfEU8mppR0MbJhy3cmz4pE
         sAzsMs1/+bEFFWPJaGlQ/1dPg/LfYxUfKHvWCzwOlzc6QGR4DiVbxI7S/IlAXWtcIjm4
         Eqcg==
X-Gm-Message-State: AOAM533s8IWASP4hcum0sKZDCJZTsENRE+u4QUuALXCp6AKjHyzcOT9+
        sWubvSuLmaw7iUEuyx/Gq6Lxszjx00GjJA==
X-Google-Smtp-Source: ABdhPJxHLKy0x2+DzXpcDaBaADHi/tNOYPx6wfkeEppR9KzjB4k99Gm30lwLyfrPOp0OnRfNigMFkA==
X-Received: by 2002:a17:902:c113:b029:d6:944e:fdb3 with SMTP id 19-20020a170902c113b02900d6944efdb3mr14408099pli.4.1605562223557;
        Mon, 16 Nov 2020 13:30:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 143sm10058952pgh.57.2020.11.16.13.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 13:30:22 -0800 (PST)
Message-ID: <5fb2ef6e.1c69fb81.ca88.7683@mx.google.com>
Date:   Mon, 16 Nov 2020 13:30:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v5.4.77-105-gc72d10024c02
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 build: 9 builds: 0 failed, 9 passed,
 3 warnings (v5.4.77-105-gc72d10024c02)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 build: 9 builds: 0 failed, 9 passed, 3 warnings (v5.4.7=
7-105-gc72d10024c02)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.4=
/kernel/v5.4.77-105-gc72d10024c02/

Tree: stable-rc
Branch: queue/5.4
Git Describe: v5.4.77-105-gc72d10024c02
Git Commit: c72d10024c02c6cf7bf5684ecc1d1ab2b3ef7908
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 3 unique architectures

Warnings Detected:

arm:
    s5pv210_defconfig (gcc-8): 1 warning
    sama5_defconfig (gcc-8): 1 warning

mips:

x86_64:
    tinyconfig (gcc-8): 1 warning


Warnings summary:

    2    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL
    1    .config:1156:warning: override: UNWINDER_GUESS changes choice state

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    .config:1156:warning: override: UNWINDER_GUESS changes choice state

---
For more info write to <info@kernelci.org>
