Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843EF4F5B2D
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 12:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239930AbiDFKAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 06:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239827AbiDFJ4u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 05:56:50 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B534849B94F
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 23:25:54 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id x16so1577269pfa.10
        for <stable@vger.kernel.org>; Tue, 05 Apr 2022 23:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gMTCwRhH3TpYKnR0ag8JXyDZIIZOIXlgt/oB8Yyad8Y=;
        b=Y3/5cyv9KnGsYUa2nHqAP63w33noAqDdMiXg4+SRTH+ReWyuKL3RqI85SoLjx1HFPC
         GYNSU8J4i8vgNXQW/XFVpNV9Oz5fwlaYxX3MVuL6/Qo8eEiriYxL7Cxx1WiRx/GvD5xK
         5NWfvwV8BEzzUgrO/oImdkLvkrCGr4Mk+Ivu5+qH0MRI2jORyvMKSMe9i9Pj1mvg6Apj
         TY7pWBzTQTJBw8oSjKk1sv+6aUiX/FoGNK93FJRW5XapLRlKk9xGW7vs9n8J3Lgeuseb
         RIQ4nUutthCUF5yBf2HaPZSIXYhCNKM+8AcrbfvTkDxbwdLkGKweKSnGL9htGGeAOM+l
         sMGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gMTCwRhH3TpYKnR0ag8JXyDZIIZOIXlgt/oB8Yyad8Y=;
        b=t21/6lqn83uArByenY4JlnNMccTFaLLo0g8uhJdm6HFijgOGHH0t6s/3oz+x+Ukl1y
         j/TnIa+RYgFfqjhHQm/28Lvl7TwgsvaMDgEfZyw/aNjo1tTWku9NKeMvvuLhtw9ynu60
         NNXEaIr4krQC5TzWf4l70XCbZeGbK5XfRr1OMLosZAARaCeP6UWtPMubRKtnO7U2PVYc
         wTmPlyK2hfUOOOfsOyM78JuAgDbS1fVst/6UEGD+ArnvKoVNDpFVFDRs3Gkh490F8v35
         cXEyisY6DRTbCtxP7LNpMjAxKfKvcuiJTnFPMX0VmXmZuG54HOnenHgWqQW09kjfZmIJ
         +Rfw==
X-Gm-Message-State: AOAM533+0xDlTQ7PpknCj53Ks3JCGuSu58XV8tvW94Vd7/N183Hy9Rxy
        kh4s2IBAeODlnt1c4gA3XmsmBljfWLcuX3COY7Y=
X-Google-Smtp-Source: ABdhPJybSOT2Wg+SQ/NZoTTUIX4ev4OLQdP5Hb3r0zybFPugqMt6z33O8zIHtG48arvp63AVyvOp8w==
X-Received: by 2002:a05:6a00:1341:b0:4fa:a3af:6ba3 with SMTP id k1-20020a056a00134100b004faa3af6ba3mr7214131pfu.51.1649226353980;
        Tue, 05 Apr 2022 23:25:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o30-20020a63921e000000b00398e665e830sm13967222pgd.48.2022.04.05.23.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 23:25:53 -0700 (PDT)
Message-ID: <624d3271.1c69fb81.c7797.4dd9@mx.google.com>
Date:   Tue, 05 Apr 2022 23:25:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.275-206-gfa920f352ff15
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 40 runs,
 2 regressions (v4.14.275-206-gfa920f352ff15)
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

stable-rc/queue/4.14 baseline: 40 runs, 2 regressions (v4.14.275-206-gfa920=
f352ff15)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
 | 1          =

meson8b-odroidc1     | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.275-206-gfa920f352ff15/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.275-206-gfa920f352ff15
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fa920f352ff15bc665b3b2f0e2074967efa3c97b =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/624d02bf6e6858a02eae068a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-206-gfa920f352ff15/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-206-gfa920f352ff15/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624d02bf6e6858a02eae0=
68b
        new failure (last pass: v4.14.271-23-g28704797a540) =

 =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson8b-odroidc1     | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/624d0080878ad2b1c6ae0696

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-206-gfa920f352ff15/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-206-gfa920f352ff15/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624d0080878ad2b1c6ae0=
697
        failing since 51 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
