Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9F764DE87
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 17:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiLOQXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 11:23:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiLOQXM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 11:23:12 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8607389F5
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 08:22:13 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id x66so7054837pfx.3
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 08:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=bTlPoSytgLVUDOVNj7itA/eG2n5vsbzJnO3BWnxFwWo=;
        b=aTDqUsxIaJBnOGH5sr9P7nY5OhmXwGohk/XUD8HgXYLKeNAl59HrdOj66N/91oly/G
         gamFV/hjgDDD6JZ6BRgwvFUdmDu86kl8BbmIqDbjFt+yFHd8PFx12zb2MJDkrRp3cpim
         J1tYzHTFizogJ8koJgoV8gIOuezJiFaNijuLL2D0pVI538XVsAkUFT6B+vlCWNTlZyTO
         RNUXfQXa+ezPOGwCO/ucqbt8HgamBdp/qK/OQupNUy/rHJD4Q7iQVedGH2G1dOCt00WB
         M4fZJlMs3oTb/oySBcqLIsCwKg4exx+PW/n00JjU7A1nVWeLRdPj4HNdWjN+1cNOmsIR
         8PHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bTlPoSytgLVUDOVNj7itA/eG2n5vsbzJnO3BWnxFwWo=;
        b=eq+So2JR9t4GdcLr6Y6UKtJR8rYfWXg5f/+0D2OTRGVt/vX+8O9E5DXwkMWHfUY9Qi
         j4UKg7YfsrSWYSmEjYMvmdRW6hClQ3O9Rac7t7i5c2ZR47QSlzIyK+0Bv1caoCE3LxOc
         cDx/cE3gGcKkCduU54Iiui+vEcgYMOz5pU8/VNvwJzsgoMTOK4vFMcsZi/wNRXcdbjjS
         gBj0S8ZqAGEO3QMpT7i2nIavwxy5l367p2ZOpWXDDq1FZIklJpi965QE6X90p5zuPmgk
         08LCDER2ksGHaAIHI9OCJk3kH8JNEPWm3ay2x3p9oE4wQNjIZ7BxP4wKK11s4+os+zz8
         YwxQ==
X-Gm-Message-State: ANoB5pm9wD0w7OSe/hv6+2vJdG16dFibIw2LnCm8lfss5vNytKGe/OM0
        MB5eDTIaPzo9x4USfrRK9pOAIhdRqm9bImALovJVng==
X-Google-Smtp-Source: AA0mqf5W3j8bC2Vtt0pZqKcBr9rlrXnSNlbGBOrBqm/KyYmnPqlDHmamh83CYkU+DeWrxEZj+yiAEw==
X-Received: by 2002:aa7:8147:0:b0:56e:9868:52fc with SMTP id d7-20020aa78147000000b0056e986852fcmr25943986pfn.25.1671121333028;
        Thu, 15 Dec 2022 08:22:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z3-20020aa79483000000b0056d73ef41fdsm1938781pfk.75.2022.12.15.08.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 08:22:12 -0800 (PST)
Message-ID: <639b49b4.a70a0220.4512f.4597@mx.google.com>
Date:   Thu, 15 Dec 2022 08:22:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.336-3-g345bb27592b2
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 build: 12 builds: 2 failed,
 10 passed (v4.9.336-3-g345bb27592b2)
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

stable-rc/queue/4.9 build: 12 builds: 2 failed, 10 passed (v4.9.336-3-g345b=
b27592b2)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F4.9=
/kernel/v4.9.336-3-g345bb27592b2/

Tree: stable-rc
Branch: queue/4.9
Git Describe: v4.9.336-3-g345bb27592b2
Git Commit: 345bb27592b2c2020cdbb9934aed86f61b4b30fb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 3 unique architectures

Build Failures Detected:

mips:
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-10) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-10) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnin=
gs, 0 section mismatches

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---
For more info write to <info@kernelci.org>
