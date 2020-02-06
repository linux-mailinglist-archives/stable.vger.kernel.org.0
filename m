Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 757A7153DDB
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 05:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbgBFE1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 23:27:54 -0500
Received: from mail-wm1-f49.google.com ([209.85.128.49]:34636 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727415AbgBFE1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 23:27:53 -0500
Received: by mail-wm1-f49.google.com with SMTP id s144so150802wme.1
        for <stable@vger.kernel.org>; Wed, 05 Feb 2020 20:27:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gvfZADdk9pthId/v98ZFw1wXUyj4nWmZ5hh7alIg6Yw=;
        b=a0z+xCw/r66aS6SUH5gH51yFEIwE+d2ai3LvvmoLF5Od2hOBtAHslznVqSEwBy7Xnp
         RGeZzxIq/zfC/C9Hg3MjOk5ZQOk5yWpWJJEutoFYknkGIn45zoh62a6y7qcksaCJpEko
         gFoVvlEQjgMDm49MWAFj0vfSnVVw3RiR4ales/F1G8DQeHAzjC3fTxfPe8OAnFv8iZ4B
         tBam549OS5HXmJ72x7OWGF7MRU7vTu1DJz6U06xKg2PnVyBP5PFXpX1ygzYM4aIhPCSM
         7hOFkZjKz7XNUy8JgyKlg41fPqdoWIpjYqGqG1SzbgO+sieGh9JXVDxugCSBNea5C0f8
         thwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gvfZADdk9pthId/v98ZFw1wXUyj4nWmZ5hh7alIg6Yw=;
        b=FNoyTeiiLM51gs9fMksmwpND9uR7oT3iNFDrMLzuxxSUR6lI9/wkFWYteJawKI5AJN
         gyhDN1HPsc7kJwwNV0FNkwt46dt/rvvHmUrQwm0jpvbQQXFePJyjkGGsBN1xI5Q9kIGP
         vW4sQyBd0bB9fooXk213Vy1ImL5AZutJGpMB1QFi0xd55DIYYzLRwk6DWWv729Htf9eA
         jzFE80v/ZEknk9BBq9fql68T3Lq6jHQmVob8XNWj09WPXJGBa4exb+/Twv0eVuMuamWE
         RMAuNoSOneWexjwhnRJG/aKMrBpl8i8wl8V04+JxkF+2oRFhzakEdOwJMS1V9oWtSP0M
         usHQ==
X-Gm-Message-State: APjAAAXi69bZpp/e2p2NI9Jxdz5/1FYCeT8Th8yFWWrFni2uoory21JV
        BYye6k06sVmPB4HTiuEbq04tubCXJedhSg==
X-Google-Smtp-Source: APXvYqxWO3IasmfxuSvXpzC1QHNFPwb3RMg9v3VKHE9u1olEnOzmvbgwYieBITuf7KKHh0IARsJlFw==
X-Received: by 2002:a7b:c3c9:: with SMTP id t9mr1651069wmj.18.1580963271586;
        Wed, 05 Feb 2020 20:27:51 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k7sm2017958wmi.19.2020.02.05.20.27.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 20:27:51 -0800 (PST)
Message-ID: <5e3b95c7.1c69fb81.97430.863c@mx.google.com>
Date:   Wed, 05 Feb 2020 20:27:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.102
X-Kernelci-Report-Type: build
Subject: stable-rc/linux-4.19.y build: 25 builds: 0 failed,
 25 passed (v4.19.102)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y build: 25 builds: 0 failed, 25 passed (v4.19.102)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.102/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.102
Git Commit: b499cf4b3a901e87e1f933df04abf69b54de4457
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
ath25_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

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
em_x270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---
For more info write to <info@kernelci.org>
