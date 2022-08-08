Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466C858D076
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 01:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237145AbiHHX0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 19:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244558AbiHHXZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 19:25:55 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5031B7BE
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 16:25:54 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id m2so9895970pls.4
        for <stable@vger.kernel.org>; Mon, 08 Aug 2022 16:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=AnJklLSsrcy6z8hWwD+nkBBgPcMcLLIYmV+sk9JaMlw=;
        b=YigP+sO34+3SRhLSiYuDWu0O2zvnKVBy5AAzcxfNiPkR7NXn8EKGc0iS8zqGEh0kNj
         sAYhYAkJzhLwXCMbUzpqtfE19MdjbBMxuayjQxhbD8roXlp2pOKF8ziLiAr0jwANq1ee
         T2UHPI+//S7TOyw2McWiSfv0EKpJ0z6BvaFFZAkfXqzyRtDqX194vlqW0LD+rTy3Lro6
         veTQSi69MI3hD/UmP1eCmXUyiV+8gOvalFGNFDdM5CihxprrEOfDG1b5mKcHRBeOLWn7
         SzHe0g7L3SXxLKBe7DOHPg6/IskOHmwOxVGxCSkxzE7R4Pxi3U4XmRld72/OCQYrh4wI
         9TLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=AnJklLSsrcy6z8hWwD+nkBBgPcMcLLIYmV+sk9JaMlw=;
        b=Ns3B0FnI98r+zW4CJNWELxKCLPfsp6oWzJCDK4WrzcBv2bHyeZ/FnpnXgLYRKwBTMG
         EupAtpjkb/gT7uOWLcdA59CyH3HkG6z/EpDAr9NqKF2iG8eIsidTNcOnlCvbzQIzdhOS
         ECJZw/EncrgD4lcKpqiSGUUD7lIXoJNXbkak0fRVK4g+nPp8XzMnKJjt0Yr13feMxETq
         Vri86+Xj+VeQmolER+Fab0lEHuUyqwBvUEOMBvCJP6hsMYXlCtUwYejKwVVpMoWjOzcf
         PjKdUQxhMxYtjomVyva56j0D/wp+t4tJaEqZJrWZFqBH/63DvcnO0QQsLypB6m7ffGc4
         WKrA==
X-Gm-Message-State: ACgBeo3ZIUuRvMgHDCd0GCgp7T4kq66XT92xxL1vQcWnbKOtf5TBWgjT
        K0uhPPE2tGFA55L49Z5ICn2DW3FaB7KuGNYlAgg=
X-Google-Smtp-Source: AA6agR6O1UeTaP+Viud7VPm8Mvj/MpdialB1xFcDXIDZYdJdPiN2hVpwgm+MrDKaKkinVWN0a+3GsQ==
X-Received: by 2002:a17:902:8bc5:b0:16c:f48b:d5b5 with SMTP id r5-20020a1709028bc500b0016cf48bd5b5mr21429805plo.128.1660001154206;
        Mon, 08 Aug 2022 16:25:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 2-20020a17090a0f8200b001f2e50bd789sm11311768pjz.31.2022.08.08.16.25.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 16:25:53 -0700 (PDT)
Message-ID: <62f19b81.170a0220.ca785.1874@mx.google.com>
Date:   Mon, 08 Aug 2022 16:25:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.18
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.16-33-g4030e25d8dd05
Subject: stable-rc/queue/5.18 baseline: 122 runs,
 1 regressions (v5.18.16-33-g4030e25d8dd05)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.18 baseline: 122 runs, 1 regressions (v5.18.16-33-g4030e2=
5d8dd05)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.16-33-g4030e25d8dd05/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.16-33-g4030e25d8dd05
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4030e25d8dd05872c07a1aba4089fa5f2286334c =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62f16a75d649ca74c8daf081

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.16-=
33-g4030e25d8dd05/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.16-=
33-g4030e25d8dd05/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f16a75d649ca74c8daf=
082
        failing since 33 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =20
