Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 688E15F78DE
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 15:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiJGNXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 09:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiJGNXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 09:23:11 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3C9D8EE6
        for <stable@vger.kernel.org>; Fri,  7 Oct 2022 06:23:07 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id e129so4644857pgc.9
        for <stable@vger.kernel.org>; Fri, 07 Oct 2022 06:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=D8ZOywo7m+Xp8Ihxl6WJ1JsKuJBzdMS1jlVZv9EXGgc=;
        b=aHiPVbukbKm/6OhxT9C2+U+9jbHL9qVM6ShOjQefV9AkiHkGlaBmd1X8BL9W69TTiF
         lmQm59WVeoXonCa9F/5jvXsmIj4zh/qr7twZ9Yr9QHHyUlQ+CIdJ8jYpjuumGu+bTz7Z
         bo8S5czY+IiWgCbWhqqRnlx/ynoMCMflk39oOD55fcX+24CdMFGez8MQNG71TiO5pGwL
         k13dA6niXiNibXA2M+m5+fl1e2ld6AWpQPwmjRxOHRlwrh+63rbyd43DkVMzjqKRHrMA
         Ypvtdo5Ta8kzXbxMD1Jc1Cir0m7WpJ0cHs2k/htpoYT7X0rax3wv/0xQ14bcapW3xiiT
         YAVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D8ZOywo7m+Xp8Ihxl6WJ1JsKuJBzdMS1jlVZv9EXGgc=;
        b=wtmCvaiTj/wAr4PUcj1oN1s+mN9FELv8un0hpp2lY+X2txJ7JZfEXF/xPOKMvF6H4p
         I6XpzOAc2kacCFiPnXc9wT/igry1OefrJERfIGC8BkuPzKupcqS3XFtjSUM2XUv6criG
         b+JxFjshPCRZs8A2KhdliE2+2MNz7uYnjHlEFZNvOz6Pe1MNWf43sWBzbBfxU1hnviqa
         +2Kq6uOX7EZ3Mi6BlD57UklVXti/NQAGWJaGeNp873br+Gdmg7DDsCHHsB5qumN2nNLL
         lSGGzY6/uVSZkrTHMJycjoHmdtVrFesxZpg0R6sF9nwVdT00pJnw0FpcCM+COmmPEFRX
         R4yA==
X-Gm-Message-State: ACrzQf3iPavJxmoOODs45iINlB4b18CH2TmftQiWAkOyxRdlbLBncxGL
        IYGsF8YOcjx45k5I5XYSYgwOWxnJRxge1HXBrEg=
X-Google-Smtp-Source: AMsMyM7b1d2qXQUO/MAEMHg8GJh69LMSLdxNnF99wn0/pEvDuTGm0bzWeWjz7Qojiek7PzVOTtcyTg==
X-Received: by 2002:aa7:9212:0:b0:562:b5f6:f7d7 with SMTP id 18-20020aa79212000000b00562b5f6f7d7mr3905474pfo.70.1665148985319;
        Fri, 07 Oct 2022 06:23:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 4-20020a620604000000b005618455cbe2sm1572483pfg.135.2022.10.07.06.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 06:23:05 -0700 (PDT)
Message-ID: <63402839.620a0220.94454.2aab@mx.google.com>
Date:   Fri, 07 Oct 2022 06:23:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.147-9-ga86f57436c88
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 105 runs,
 2 regressions (v5.10.147-9-ga86f57436c88)
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

stable-rc/queue/5.10 baseline: 105 runs, 2 regressions (v5.10.147-9-ga86f57=
436c88)

Regressions Summary
-------------------

platform | arch | lab          | compiler | defconfig           | regressio=
ns
---------+------+--------------+----------+---------------------+----------=
--
panda    | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1        =
  =

panda    | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.147-9-ga86f57436c88/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.147-9-ga86f57436c88
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a86f57436c8896103d2d85c74ec94cec379a56bb =



Test Regressions
---------------- =



platform | arch | lab          | compiler | defconfig           | regressio=
ns
---------+------+--------------+----------+---------------------+----------=
--
panda    | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/633ff9144209f49573cab60b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.147=
-9-ga86f57436c88/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.147=
-9-ga86f57436c88/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633ff9144209f49573cab=
60c
        failing since 45 days (last pass: v5.10.136-539-g2b0d128e38cdb, fir=
st fail: v5.10.137-150-g8b56d7183e67) =

 =



platform | arch | lab          | compiler | defconfig           | regressio=
ns
---------+------+--------------+----------+---------------------+----------=
--
panda    | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/633ff42729bf188445cab5fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.147=
-9-ga86f57436c88/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.147=
-9-ga86f57436c88/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633ff42729bf188445cab=
5fc
        failing since 45 days (last pass: v5.10.136-539-g2b0d128e38cdb, fir=
st fail: v5.10.137-150-g8b56d7183e67) =

 =20
