Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDDAB64DEE3
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 17:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiLOQol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 11:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbiLOQoj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 11:44:39 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B0637FBD
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 08:44:37 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id v3so4546173pgh.4
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 08:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=xRg3Ebhae5myH043s+IcwAhWfxfKbWldsIKY6gkLZeo=;
        b=Av9LOpVCyCtHulDtwLvTX8rwIYmC4CigSdT2P+bsNHrJ0MCHvApiOBtLEYGQ0Jb9BR
         B84EGSDh/o191ONTjZwnr+oASKWY+DQnFQzdxE3TfdqCc3T6VgViVdYfs6Av4nEw2YDr
         QHC8lJrvMQVyyVxOantR1naYuwJ51fvSO//dWNaIzpm+xnZTr6C7+iJE9CzddQ92Vg/O
         WZ98iOYbArVoVk71qgw19a8u6FhO2l42BVJUiGBgJGaDCwxQyO+GGONNJ9dFbpBez73E
         h+HcYExrhoOgcvQB6yLlfZ5Aup24kWSilMxZfH1KBbfpaNeNGaDNjSXFSTsMqh4wXLBN
         B4Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xRg3Ebhae5myH043s+IcwAhWfxfKbWldsIKY6gkLZeo=;
        b=7GGAlCCDxIkajf1V0Mny1HfEvJUC8ZBYavqdfEOnuD1/Ec2aiXMFE6l/vxwCGdQJk/
         TjDTWEAN4fo5nDjhZCfNZEU1WsTKZKzUohMxb9kP4NQH+SxmcbJyNFrKea3lc0UYqCaO
         R96tR8IYf3+JMPm3g8nzKe484dL9qx/bQfxHJbgMFcCbF0bTzyoKBthUkTptGp462CZH
         SIsBHc06lQyL+nNyzSAy4PZeU5hYsnX99At4XKNiBWLHO6KWfwkNxF8Q7/DnpdqqRw+5
         a9CeRBM+3kHPHNA+a2A2OoHTKpF/WmHWtRJxG/vtr5aClmieF9cP+KzMqAnXJ1ZzpRC7
         JHcw==
X-Gm-Message-State: ANoB5pnjXkGTysrF4NuYw6et4R2Zg6FiR9BCvrtwCuap9wOuGtFb6Xxc
        d17O4ny2mDTYNMF9sdCl8lGsAQ937brAEfXTHIqPHw==
X-Google-Smtp-Source: AA0mqf7fTfCiIxcbreeucXBaXJb6zc6PWH7FHXl52skgHM8pjzdsihDXuYjKcCDu4BWAr+krBlTvXw==
X-Received: by 2002:aa7:8690:0:b0:577:501c:c154 with SMTP id d16-20020aa78690000000b00577501cc154mr28700813pfo.6.1671122676890;
        Thu, 15 Dec 2022 08:44:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d20-20020a621d14000000b0056e8eb09d58sm1988462pfd.170.2022.12.15.08.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 08:44:36 -0800 (PST)
Message-ID: <639b4ef4.620a0220.a8119.4635@mx.google.com>
Date:   Thu, 15 Dec 2022 08:44:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.159-6-g9d8fa42d6988
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 build: 22 builds: 1 failed, 21 passed,
 1 warning (v5.10.159-6-g9d8fa42d6988)
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

stable-rc/queue/5.10 build: 22 builds: 1 failed, 21 passed, 1 warning (v5.1=
0.159-6-g9d8fa42d6988)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
0/kernel/v5.10.159-6-g9d8fa42d6988/

Tree: stable-rc
Branch: queue/5.10
Git Describe: v5.10.159-6-g9d8fa42d6988
Git Commit: 9d8fa42d6988767a0afd26fec6291e04c9dcf7ef
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 4 unique architectures

Build Failure Detected:

mips:
    ip27_defconfig: (gcc-10) FAIL

Warnings Detected:

arm64:

arm:

mips:
    decstation_r4k_defconfig (gcc-10): 1 warning

riscv:


Warnings summary:

    1    kernel/rcu/tasks.h:710:13: warning: =E2=80=98show_rcu_tasks_rude_g=
p_kthread=E2=80=99 defined but not used [-Wunused-function]

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
cu1000-neo_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
decstation_r4k_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning=
, 0 section mismatches

Warnings:
    kernel/rcu/tasks.h:710:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-10) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---
For more info write to <info@kernelci.org>
