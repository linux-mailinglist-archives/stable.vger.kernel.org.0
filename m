Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30063153DB2
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 04:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgBFDtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 22:49:09 -0500
Received: from mail-wr1-f52.google.com ([209.85.221.52]:39317 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727572AbgBFDtJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 22:49:09 -0500
Received: by mail-wr1-f52.google.com with SMTP id y11so5398898wrt.6
        for <stable@vger.kernel.org>; Wed, 05 Feb 2020 19:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=45dMaHObD/uOQrhTPFcR2rMW2oBjTEvOnNALv4/5Vmk=;
        b=d8NrbOU1qQEIfTMpJ+bAliz9Ii7y3PajGMsAs9kRJKD3lE7kYgkdeYtO3Tyz3RDPiZ
         yTDJPIP7IjeMod4cqgL29v0etcEEW18gVSguvSkzuT9IeZlfTH/xmXwdpp6c7tu/HmQg
         dwwD7q4ad0otOt2DkpxqwV+UBXMwVHvloO1RoxgjZ732udN6B/VtlLDlqJGbLY3S4DlZ
         EevmJcy5YJnYRa5KvHznKt3POEsprjHrlustviYqKpUaHvcnrLsUgPmNHuHoUixfNiKu
         EbldDv43IBJbcrsKqEbTXCQqZrveXfTvZlrYxewwEO6okVGk63R9U8Rc5jrYc/5ufHt/
         0Ayg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=45dMaHObD/uOQrhTPFcR2rMW2oBjTEvOnNALv4/5Vmk=;
        b=EvzRva+caAbyWGWZnYhtr/SV7MXUldTWeoKq6f7jbdbJjeuEiJioaHQ5FCSQxS1XTF
         yS8BlKCDr9Wg1GUHcZjBKDpWI5sXgY1lxUtW1B+VfHP+QR9xsTk6NuQxyGjAioPNk17a
         0YNf/cqn71zKDYVHxIcBe3nZ7kwxI7/JizdXPHCHoHlZ5kJMXzCYEYNAKno6RZohLlTA
         aDNcbTfQqsjvnH9BWW3zWJqZGapv3RYltM7RKl3kp2nRfWNPEfySuIEXNh3irOlnvz/k
         KGQ2zYvSxT1GIU1TapsECIROsPh5GjPKgK+OyN3e23P/rRsSl6k0RW/FSd5jrqfdaoyH
         8snw==
X-Gm-Message-State: APjAAAV4NvW723CSR2jkq9stX+QFhd5BhWU3x8TsAuq2ixoTkttvOOX3
        TT9w25bKMeCDXq+KT1PZdXb8pbHWHTpuVA==
X-Google-Smtp-Source: APXvYqzyLzZtxYyMHAV61rCAIQHJeu6y+lUyENEFUFHYz+b5F2Rf1kjbWTgzEmj5+/T4I9CEnCcZbQ==
X-Received: by 2002:adf:cd03:: with SMTP id w3mr1080620wrm.191.1580960944934;
        Wed, 05 Feb 2020 19:49:04 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x21sm1921003wmi.30.2020.02.05.19.49.04
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 19:49:04 -0800 (PST)
Message-ID: <5e3b8cb0.1c69fb81.3872a.8342@mx.google.com>
Date:   Wed, 05 Feb 2020 19:49:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.213
X-Kernelci-Report-Type: build
Subject: stable-rc/linux-4.4.y build: 26 builds: 0 failed, 26 passed (v4.4.213)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y build: 26 builds: 0 failed, 26 passed (v4.4.213)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.213/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.213
Git Commit: d6ccbff9be43dbb6113a6a3f107c3d066052097e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
realview-smp_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---
For more info write to <info@kernelci.org>
