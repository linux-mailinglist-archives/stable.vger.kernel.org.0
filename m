Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE5364E2CD
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 22:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbiLOVLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 16:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiLOVK7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 16:10:59 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDADF31DEA
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 13:10:57 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id w23so252626ply.12
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 13:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=R5l/H6qbPNvDlC3Ok/Fla5nkUg+4DusRTuS4qDXfpPc=;
        b=3hChuXIgeR22RkaMv8MLU+OJ8r34LXXEo0Y0GojR0phQ3ZAd4t/9zol8rgfsZZzn8d
         P/6pChXBbCSuxzXCcgZxaZMoCZz8TmlTG9/P0PrQNJ1nrb5rQnpQONcu5JZVaJeS5mg/
         VY69+G3HmTfJIvA+W+yGKwel2xX83j9m+iyGjHRKPRaKEq/vPeJOZnuqWQKrooDTnfhL
         yqaIfpivM0zbdbq5zXk5JjPeu018+6zpdVCBrYNQO7eV+FEr3sNEofCwvHiDbvZuz+/P
         It++AV6g8LMdiYSEq6rMX5094HZZVfUq16eZCe2NBvwW9kkptJ/AleCWIxcwCXEOwE/g
         g0og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R5l/H6qbPNvDlC3Ok/Fla5nkUg+4DusRTuS4qDXfpPc=;
        b=Habu9aXfPPIT3qSElO2qtqqYMapb03FFfNip10sCtLr6S1kclefA9e0dht5ABn+WVH
         +HEzvhPf94SS2qgcl+sAMBw8UqtWDMz1802YZbPJWimlzQntzeR4ZrMDK8tgcfX9KOES
         c/25l5eRGP2W3GghYcaXkm6eI4sEmvbvbYTgbRKcn8drbKaeKBdMo9nvutW22WA8UOVe
         AV7hv/hWUXX404OTatbbvxeRtE3s2JgTo8Re4/Er63Vy1QmwtFScyvtaDKqfq7visEz2
         h0WLXVd5JHxiFPNF5OBrr82kl34icfOhjbk0cFXAWjEFgfHYHxTjLTTdup0uAZzuvt3n
         vHTg==
X-Gm-Message-State: AFqh2kpPNjGSPKC23p44tmYyfEgTeIZdlPYlaSgf1l+kClBu8+GoW6/D
        jp6lVBxHO/G8+cjZ9Om7qXt510MZRN9t0mpinuwphA==
X-Google-Smtp-Source: AMrXdXv4pCh5uydN/bQ5Yix+IoWUR0DLgpZBlYHR3lwSEDtVBhycg9PZI21vvETm6M9J4LGWmHSk+g==
X-Received: by 2002:a17:90a:5584:b0:223:2aa8:7ae4 with SMTP id c4-20020a17090a558400b002232aa87ae4mr13495346pji.47.1671138657075;
        Thu, 15 Dec 2022 13:10:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b1-20020a17090a6ac100b002139459e121sm3533370pjm.27.2022.12.15.13.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 13:10:56 -0800 (PST)
Message-ID: <639b8d60.170a0220.494fd.7493@mx.google.com>
Date:   Thu, 15 Dec 2022 13:10:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.227-10-ge538d4b64ed3
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y build: 25 builds: 0 failed,
 25 passed (v5.4.227-10-ge538d4b64ed3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y build: 25 builds: 0 failed, 25 passed (v5.4.227-10-ge=
538d4b64ed3)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.227-10-ge538d4b64ed3/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.227-10-ge538d4b64ed3
Git Commit: e538d4b64ed30c6b7248a14b4e8641db4db16736
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 2 unique architectures



Section mismatches summary:

    1    WARNING: vmlinux.o(___ksymtab_gpl+vic_init_cascaded+0x0): Section =
mismatch in reference from the variable __ksymtab_vic_init_cascaded to the =
function .init.text:vic_init_cascaded()

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: vmlinux.o(___ksymtab_gpl+vic_init_cascaded+0x0): Section misma=
tch in reference from the variable __ksymtab_vic_init_cascaded to the funct=
ion .init.text:vic_init_cascaded()

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---
For more info write to <info@kernelci.org>
