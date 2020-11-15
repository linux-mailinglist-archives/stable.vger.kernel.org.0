Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446BB2B39B9
	for <lists+stable@lfdr.de>; Sun, 15 Nov 2020 22:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgKOVqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Nov 2020 16:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgKOVqT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Nov 2020 16:46:19 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6FDC0613CF
        for <stable@vger.kernel.org>; Sun, 15 Nov 2020 13:45:49 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id m9so1338656pgb.4
        for <stable@vger.kernel.org>; Sun, 15 Nov 2020 13:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sAZo84cRT6dSWT1XfYWIamWeq65sKRa9rZOIx80U7Lw=;
        b=pQZ2TUHYBWcwROoZyzZ0JU1y03D1XYRFbe4+YRZEeJ34eHVlNeQkzDlVSOKQF5QH40
         iCWE+bepxa6gVrOeTVE/8zQkPJSN51qwExyfNY2gka8m2saYZ2L639zRPx31ol2L4a9i
         NuHLTboLAgtD+0beuqtHJ/5griaSwus3vOX7VLxd1ydpCghc+fAPKB3MaugbHwRIM+HA
         ZrDOK45YGUZc8gkIcPbOi22TjbEBbyCaGPXa9NvjcEFgE5fbJJTjzMwV8hjsYo9aWbzR
         bb5J6dioZPLhF3Uid1liI5CBFdjtafVOGnFUbUCNhjUpge06NvDZ4r2yFRXq7x03X0Va
         Vk5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sAZo84cRT6dSWT1XfYWIamWeq65sKRa9rZOIx80U7Lw=;
        b=iWZL6TsWPVw/W1fJQCO0kzjQxd14sBgFmwzccr6X2W8/FIlWafqePd2ICgoNJyEluq
         PjnZEpMderqHU0t4tb5aBk1ADwE/EYvTYyVNUZW6tLghIrEwOllmDWki1X+dAgGc7fBf
         Dfkn6dwxYkGqTwRFShgnEPi/sW5PpsBMneuFyYb11pbiQl7bgu4oWZxOeSAFEk+Zt9UA
         Qmdykr4Gp+WFXYrYrBwGbp/6ZCUrw0NVOo4ZjAZ7zQOVyCjh99fBmrhWxKjlvSKPU1Ox
         BXmVUlnOWR75nnas4Lb10tENRuRKvm6fh7lMPpyiCb7MmBdNP7hkIPu9cvTGUPEeGEfF
         G6jA==
X-Gm-Message-State: AOAM5321cPy98/mdSyAtZOTg0+MtLF7mMWEpa8tMWUT45gOxT1RFcXgF
        0LFXE5yOzGpjGdPc4h2K4qscs3GzO9jmcw==
X-Google-Smtp-Source: ABdhPJyBCJzrTum+FhV9w8gb1wR+3juvgo5gJ4wbnSRq8kE/T0IhZlTrrE0mtADlwQPqFiPHh65K7A==
X-Received: by 2002:a63:194d:: with SMTP id 13mr2657389pgz.317.1605476748610;
        Sun, 15 Nov 2020 13:45:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fz5sm16554005pjb.49.2020.11.15.13.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 13:45:47 -0800 (PST)
Message-ID: <5fb1a18b.1c69fb81.8088a.4185@mx.google.com>
Date:   Sun, 15 Nov 2020 13:45:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.243-27-g7c6acf5b6a67
X-Kernelci-Report-Type: build
Subject: stable-rc/queue/4.4 build: 24 builds: 0 failed,
 24 passed (v4.4.243-27-g7c6acf5b6a67)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 build: 24 builds: 0 failed, 24 passed (v4.4.243-27-g7c6=
acf5b6a67)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F4.4=
/kernel/v4.4.243-27-g7c6acf5b6a67/

Tree: stable-rc
Branch: queue/4.4
Git Describe: v4.4.243-27-g7c6acf5b6a67
Git Commit: 7c6acf5b6a67e4155f5003f068a90c1d0183c683
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
ath79_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
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
bigsur_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---
For more info write to <info@kernelci.org>
