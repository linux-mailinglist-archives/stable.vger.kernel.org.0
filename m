Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC86750C0FC
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 23:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiDVVRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 17:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiDVVRp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 17:17:45 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD6F38737D
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 13:13:11 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id k4so1611692plk.7
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 13:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+US04crpo5sjcU1IzeuaTDh5Cp5IDsMBpLhwPRar2Mw=;
        b=qmWrYKZPkzsIDDzcXyg5wIUEJ8UoOGwljLp1D5iygbE340iU20Chn/fGnLOcSymZee
         254qQnwQ9YcdTiYYlk0kN8Q2X05gbJ2Ko+hrhBoR6yxHkxhnOxgyM6CmRnZgmus4DpT5
         VG8Ec0GrAN171glgcJvVdd/zcjdlV5eAfHK/hAgxqPZ0QlHyswBWynscGkAP1cGCE6FE
         4FLoIWklXxMB1jKFPglHiht6rXSja/KdMqumxOfcOeZXFFqvIgdjuxACEUUO1ub7nkCV
         pbyIZwTFnhLeago0CBGWUw7G4HD7cu4wjoMhHIG6iOzE8+Y1zYCJLDtJg8rdbqkEczgd
         7epA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+US04crpo5sjcU1IzeuaTDh5Cp5IDsMBpLhwPRar2Mw=;
        b=Q0jW2EnaxtpYXJhNRyH/eLkVjdox6qQMGKYa13h5cGaOTztkdGKhnQ63ZDHRNzFLU2
         48B3NrVqJRmesUVWztptlaKxuNlDvJClsHb+kGam1PJFcyR6CX6z5Gbqe+hQeRSmvPzX
         EsA4RFh5sF1qvYmAXzlj/EG3+238WZmbaahq8Q4GcWmaFH7MQz9fDqvfJhuRG+tIrQnb
         XohBTsp6LQ3vBWQAjceHhKyuNgP7FRKBab8plFzhNWb8S49fW+lI3AD1txTB8dtB9gUb
         k5EwACX9e2+pqvOlr865MjSowYlI56dclfmrMTBx+2Cl7kSSP9/6A32pDweI64SoKxnL
         UeXQ==
X-Gm-Message-State: AOAM533+ys0xC9Ruo8uHJOkv+KBAnLbTSPRKWfAiinzJaRRqZZmt6qCp
        ymjk5sVBYqUi1FuR5zIcijdwFq622JFH13XbCug=
X-Google-Smtp-Source: ABdhPJxgU57X9MV5w1ZoLnM871175hF2GFY4UE1yFKTBxF+DBwh3QeCXiyvMv+FxlTGldHMru8+3vQ==
X-Received: by 2002:a17:902:70c1:b0:154:667f:e361 with SMTP id l1-20020a17090270c100b00154667fe361mr6327446plt.148.1650658124437;
        Fri, 22 Apr 2022 13:08:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t2-20020a17090a448200b001cd4989fee7sm6907388pjg.51.2022.04.22.13.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 13:08:44 -0700 (PDT)
Message-ID: <62630b4c.1c69fb81.6e0fc.1a45@mx.google.com>
Date:   Fri, 22 Apr 2022 13:08:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.35-13-g2b25dc3f3f2c3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 60 runs,
 1 regressions (v5.15.35-13-g2b25dc3f3f2c3)
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

stable-rc/queue/5.15 baseline: 60 runs, 1 regressions (v5.15.35-13-g2b25dc3=
f3f2c3)

Regressions Summary
-------------------

platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.35-13-g2b25dc3f3f2c3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.35-13-g2b25dc3f3f2c3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2b25dc3f3f2c35ea1d03c381e2218b6db0b680bc =



Test Regressions
---------------- =



platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/6262d6c447106fb2d8ff9492

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.35-=
13-g2b25dc3f3f2c3/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.35-=
13-g2b25dc3f3f2c3/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/626=
2d6c447106fb2d8ff94a9
        new failure (last pass: v5.15.35-13-gfcfbe4b48b2d)

    2022-04-22T16:24:25.349138  /lava-111331/1/../bin/lava-test-case
    2022-04-22T16:24:25.349457  <8>[   14.442434] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2022-04-22T16:24:25.349650  /lava-111331/1/../bin/lava-test-case
    2022-04-22T16:24:25.349832  <8>[   14.462243] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy-driver-present RESULT=3Dpass>
    2022-04-22T16:24:25.350016  /lava-111331/1/../bin/lava-test-case
    2022-04-22T16:24:25.350171  <8>[   14.483359] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy0-probed RESULT=3Dpass>
    2022-04-22T16:24:25.350317  /lava-111331/1/../bin/lava-test-case   =

 =20
