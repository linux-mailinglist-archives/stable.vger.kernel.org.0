Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC85B4CE76E
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 23:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbiCEWY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 17:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbiCEWY0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 17:24:26 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C139D79380
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 14:23:35 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id n2so1214939plf.4
        for <stable@vger.kernel.org>; Sat, 05 Mar 2022 14:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s4ei83PipjMeoh4Bzm9ERUg2hcqiagBHTeSjtqQ1dH0=;
        b=X94tEIS16U54uCUr+Ah+7NXXew2Cz5g3XcF5ICsHBO3p40Tn2nRtSXWgZ6Uub7wB/K
         dwY4q7RiPnw96EBhM9juZq3m1KIrujk++hOmTMs7wlLoMZLcv7sXoH3W5OB2j5oZliI+
         jSTm0k5LPf9VwszraU1oVQbcHZlTeT3ckknHgDhsiQPp/f4bRzzcZcJtVpMbdjjCiVJl
         /n7Z7/hcmrO1drKr8I1qag3NTUV3j5z98N5F6qxQHMevgcAI7OpDTXHKf8zuWqD8ypzN
         GCSqONU0dXzciMttr5YUkuRaOsnyVaym88hzF5PUN84BMo8cYMWoZtXQKA8SfCPSehrJ
         XpvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s4ei83PipjMeoh4Bzm9ERUg2hcqiagBHTeSjtqQ1dH0=;
        b=RWQaoRVDlL8KZ2eLA9iVTclga1oOrEGqfk7YrwBKZwbePcf6llGzu+nlpY1LCb+t9q
         CyePtoVX7CETmnaVEFHSC86G6vtODprEM8FRONzzYEipzfBdur8yW3ci4OxS2M/qi2ZF
         nohHkOq3cKtmqNgI0CGu/Xikn6WQYjcn5CwP31/7OeNW9nZfbWpryCnrTKYza3L06QLV
         JOHzGFYGOEFlAC/wjUGlfz69BbSp1B9jFoKVjps32tbLf1yP4mzCPC6zfoZNc8kdBkil
         rJF5YHrz9vc7TvOczr7qBsEE2VRO2e1SAF4zuAwh+ucnM8c9q7d3S1oS2HwRJjMjUzXP
         BKGA==
X-Gm-Message-State: AOAM5338wc9e8T9x7Is/kj0Fzm3dARdEITZuzA6iHx7hq3o/MTZ+f9hj
        Lq6s5gerZiB7X6ElHmHBy7Ait+l8FFt17f/QJGc=
X-Google-Smtp-Source: ABdhPJzM18cSSOdHMAgdh6HBt/2gJXgjbQ//L+Wz2qnwicyn3cLaGmXwr0sg9t/vJOhX4dyfc0PfFg==
X-Received: by 2002:a17:902:d48a:b0:151:dd60:4177 with SMTP id c10-20020a170902d48a00b00151dd604177mr1073378plg.2.1646519015065;
        Sat, 05 Mar 2022 14:23:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 78-20020a621451000000b004f6e8a033b5sm1213225pfu.142.2022.03.05.14.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 14:23:34 -0800 (PST)
Message-ID: <6223e2e6.1c69fb81.397de.31e1@mx.google.com>
Date:   Sat, 05 Mar 2022 14:23:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.12-88-g574afe1b341b
Subject: stable-rc/queue/5.16 baseline: 84 runs,
 3 regressions (v5.16.12-88-g574afe1b341b)
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

stable-rc/queue/5.16 baseline: 84 runs, 3 regressions (v5.16.12-88-g574afe1=
b341b)

Regressions Summary
-------------------

platform                  | arch  | lab          | compiler | defconfig    =
   | regressions
--------------------------+-------+--------------+----------+--------------=
---+------------
kontron-pitx-imx8m        | arm64 | lab-kontron  | gcc-10   | defconfig    =
   | 1          =

r8a77950-salvator-x       | arm64 | lab-baylibre | gcc-10   | defconfig    =
   | 1          =

sun8i-h2-plus-orangepi-r1 | arm   | lab-baylibre | gcc-10   | sunxi_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.12-88-g574afe1b341b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.12-88-g574afe1b341b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      574afe1b341b76486c5a465095bd7ca7b0055613 =



Test Regressions
---------------- =



platform                  | arch  | lab          | compiler | defconfig    =
   | regressions
--------------------------+-------+--------------+----------+--------------=
---+------------
kontron-pitx-imx8m        | arm64 | lab-kontron  | gcc-10   | defconfig    =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6223abcb7dab38e407c6297f

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.12-=
88-g574afe1b341b/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.12-=
88-g574afe1b341b/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/622=
3abcb7dab38e407c62996
        new failure (last pass: v5.16.12-85-g060a81f57a12)

    2022-03-05T18:28:18.271833  /lava-95713/1/../bin/lava-test-case
    2022-03-05T18:28:18.272182  <8>[   11.354168] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2022-03-05T18:28:18.272428  /lava-95713/1/../bin/lava-test-case
    2022-03-05T18:28:18.272613  <8>[   11.374701] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy-driver-present RESULT=3Dpass>   =

 =



platform                  | arch  | lab          | compiler | defconfig    =
   | regressions
--------------------------+-------+--------------+----------+--------------=
---+------------
r8a77950-salvator-x       | arm64 | lab-baylibre | gcc-10   | defconfig    =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6223ac2be68cefc76ac62987

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.12-=
88-g574afe1b341b/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.12-=
88-g574afe1b341b/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6223ac2be68cefc76ac62=
988
        new failure (last pass: v5.16.12-85-g060a81f57a12) =

 =



platform                  | arch  | lab          | compiler | defconfig    =
   | regressions
--------------------------+-------+--------------+----------+--------------=
---+------------
sun8i-h2-plus-orangepi-r1 | arm   | lab-baylibre | gcc-10   | sunxi_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6223aaf79757692b59c62969

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.12-=
88-g574afe1b341b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-=
plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.12-=
88-g574afe1b341b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-=
plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6223aaf79757692b59c62=
96a
        new failure (last pass: v5.16.12-85-g060a81f57a12) =

 =20
