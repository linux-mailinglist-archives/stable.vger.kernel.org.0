Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7CA153DD3
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 05:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbgBFET7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 23:19:59 -0500
Received: from mail-wr1-f41.google.com ([209.85.221.41]:40973 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727415AbgBFET7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 23:19:59 -0500
Received: by mail-wr1-f41.google.com with SMTP id c9so5438119wrw.8
        for <stable@vger.kernel.org>; Wed, 05 Feb 2020 20:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fNFWOqKGYRE5SmAvqTg//5k6Ce+OS7AOo+rwSb4rKbY=;
        b=unAfzQzc1ra0thrk6+5JBhQIjEH5ulzJmqFNmkT1+fgMq8kXxgW4CU7NxYIHX9ZFFv
         nvYXv73G3T9ijEnOBcukwaDCuHim2tdCdwx6saRLznHrp575Yu+XQEw8CMqD9GjXrIM4
         oDlga1DOba0xmzranUM9rh5Vx3cPZezjlwEMQauPaeCp9r4ay8dxoxmYNfcLVeXkfBhi
         23hxFQbRNq/SwCMsFQN4CsZ22Qa77PIjK++heR40Yc2Umzq0j8ab/NLhDBgty0fg/TQa
         QJApmfvR92nm+qV1POTrDnVT28Hki+v0RmNZl7OW+I3YTjkPN6ImA/BlFPbWSF0ErSLW
         NDwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fNFWOqKGYRE5SmAvqTg//5k6Ce+OS7AOo+rwSb4rKbY=;
        b=hKKQLWulm8wQk42+gB39wP+g8b7sZ4mifr+LqqVrmsJ9+WY6h16MYJ0nAaNwxQALbI
         8TXrOfmGtGlVe3fY5zTvXTIqldG8Vg3im/8yjPKvk+4+h+wWF+QhuotZ6P9bBv/SaS4y
         DWPc5ksZOc2i4Dyz2Sz7aO2425jbkra/xxgMrIuCkE3aOY3gHe7w+jqdDdhurW1vSTYH
         pdemMmNyuIGY8l/NqhS7+cAV0b0jpm0yjFo2TaIvwRdl4b4xCiEQmoJWzHnzc0cLN1xy
         d7h+8T2wecD+K/9Nt7tubiApheWw/sarXjPwztGTetxJSEqRo7cMxjBd0LlOYiBuQPa6
         tm5g==
X-Gm-Message-State: APjAAAUIJ4JSYjloSfeMtf30SY+CE62NIbkCyXaY+7RdBU14c48Rgn9j
        dEfGugkET27RHyDlsnSkKLAe3V/18brH3w==
X-Google-Smtp-Source: APXvYqyeYLrREN+u+yFieEm9wz5NVaesqDyqkZZZyzmAXu+IuQAeBvcrbCANDDEssd5ZdimM0+MzvQ==
X-Received: by 2002:adf:f606:: with SMTP id t6mr1241832wrp.304.1580962794564;
        Wed, 05 Feb 2020 20:19:54 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k10sm2453729wrd.68.2020.02.05.20.19.53
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 20:19:54 -0800 (PST)
Message-ID: <5e3b93ea.1c69fb81.92d23.aaf6@mx.google.com>
Date:   Wed, 05 Feb 2020 20:19:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.213
X-Kernelci-Report-Type: build
Subject: stable-rc/linux-4.9.y build: 23 builds: 0 failed, 23 passed (v4.9.213)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y build: 23 builds: 0 failed, 23 passed (v4.9.213)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.213/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.213
Git Commit: 0e96b1eb0ea5e4e8cdcdde6f0c68f89dc1d08be7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 5 unique architectures

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nuc910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
zebu_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
zebu_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---
For more info write to <info@kernelci.org>
