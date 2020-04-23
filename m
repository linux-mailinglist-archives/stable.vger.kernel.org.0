Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09F81B5CA0
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 15:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgDWNd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 09:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726429AbgDWNd1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 09:33:27 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34909C08E934
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 06:33:26 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id o15so2905866pgi.1
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 06:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3+9QF1yA84OB1XtsJA4Ji4WR0ZPskbOXojMyiy3bsQk=;
        b=nPy9dyPzuQ0Pulc9pfFex1OmFiM6fI8yuKc/FEShS5rj0xzqNVjVA6FDtOu94eYcTk
         C3Nz9ZZhEDoNzLHTCwucMTEXdwmdLmdGGQJ/0WpgQ55hYEPheBTLzT5IRd8AmYL9pV/8
         /ateLnKiduJU+WMSzu6nDKL7u+4XDae+PU/Y9Xi3z8X3eErSuyBURsttsjmsvKmXrTgb
         cM37RhYBMrnyK6V5mlHNF8iHdFqaiX4mzi7lPK9858zVdZulreMHpau0p0l8Z8f+uG4l
         L9AUuSZxpky5/s1aoMkQKOBT4IQV9fqhQ6bn+3T2zHpY3tzv5qpEav5M8mf9JDpQ1APN
         CK1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3+9QF1yA84OB1XtsJA4Ji4WR0ZPskbOXojMyiy3bsQk=;
        b=jt8gWjrjXC7VzCxduu57MJIPr1SQZvL4S8SnHoB7GEFkjtBtfTUSwN/YAF6S4fMJlP
         jjSQEPbVRf0qZ6o6TGW4nFp/X2j5oBDa6kl9drmYYtbSdeO4A1FOM+psTIHgnljLrHra
         DROWQ5vnCsm+gKWxI3BCsqLE8j4hn3zh+k7Q20Xigb9CZkF5ICxpGp4sP+eNc9TEQeOG
         3z/2QZ3msCb4hejXsVR+xen8TPwfw9OTml+jHvKddOyNsWkFqBkfZe/Fe8jI8b+XjdeD
         X5H9SCUdE7VydK50GZvR1IzGf/739tAW3b4pQJdZ4bb7jehMaxZ0Z7D2ZJosAKjmOxRN
         QceQ==
X-Gm-Message-State: AGi0Pub2/utWnfXNM/6wX30NGKB23pr9f5LVC1/1hzDotxenK2yRg4+p
        uehvXTmFqcw9k7tS0mS9yKqZGHfXJSE=
X-Google-Smtp-Source: APiQypJfSXaLAnEgSIoKHVlcMvYmqesxpt720OdQPLe7Q1mqJGdSfHPRve5qSZ+UgMbHMKIjZA8JWQ==
X-Received: by 2002:a62:520f:: with SMTP id g15mr2136366pfb.127.1587648805046;
        Thu, 23 Apr 2020 06:33:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x12sm2616349pfq.209.2020.04.23.06.33.23
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 06:33:24 -0700 (PDT)
Message-ID: <5ea19924.1c69fb81.a29a1.9668@mx.google.com>
Date:   Thu, 23 Apr 2020 06:33:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.219-100-gb7353bd580c0
Subject: stable-rc/linux-4.4.y build: 23 builds: 0 failed,
 23 passed (v4.4.219-100-gb7353bd580c0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y build: 23 builds: 0 failed, 23 passed (v4.4.219-100-g=
b7353bd580c0)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.219-100-gb7353bd580c0/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.219-100-gb7353bd580c0
Git Commit: b7353bd580c08b4aef6e29998477a8c6c44e0e4b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 4 unique architectures

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ls1b_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---
For more info write to <info@kernelci.org>
