Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1270B4EB4E5
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 22:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbiC2U4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 16:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbiC2U4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 16:56:34 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508FB4B41F
        for <stable@vger.kernel.org>; Tue, 29 Mar 2022 13:54:51 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id z128so15822626pgz.2
        for <stable@vger.kernel.org>; Tue, 29 Mar 2022 13:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rdRmbYIGowO1SdOisfsUIfStGEuLguj6KVhOFY66r1M=;
        b=PeUIdSHSfNh6qT+DgLbEuP0W26cdVrPIKj/6yYiv/QJz0nH5bfOZL03FeF5h/3L6hn
         rjFvbnJANoeStlUPOKLk6hGtPXm4KgVg0us2/vYzThVuvGBAjl1hrjsoehFcvC93CGE9
         R4PmS6EUZhlwfqe+OBUgz4y4bJrTE0MpFyegkEDHPZ10wuiXc56WdMHs2SJDAEV4tU9V
         kIFSIOifjLthawm6mAM/EuN5QrhrPC26gB9o75KWmO2zs4QrsEF0k2R13AW2jEN5His7
         1nDARMULvG44CRYbUifp/zDOv9dT68fleSvv3u2Dpca/YzbUNRUbARkPG8M6APknCqUQ
         LLHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rdRmbYIGowO1SdOisfsUIfStGEuLguj6KVhOFY66r1M=;
        b=mYiWpGq6qAMmjyyqEgUyKD4qxhXg56/unBYyFWMcpRyw3GYmQUQzHt3+p3vOhxUT4/
         YX/28apl+wUIoMnUQYcHhbU26HYSNY4Ud7apdMu0nerA99BaXBmn4bysFzJrGQTgAtk7
         Eto3vsNYlCPEa/cYyTgqLU+yWE2excq54rgLcbYg+XvB9BBY1aPtucNQTnv9ft4nir3Z
         o5ZzTTaI9wB02EYbhVI4JMv+iayl5x5/FFPFLsLl3Q5lwCnK+AKMAzAwmebmxyf2vTdA
         tuefiWf56FChImiisxjR6uWV7CqXhAjQltSLrr+qPNqgEzxU/d52A1kOJpiEgc+QGlHo
         SObQ==
X-Gm-Message-State: AOAM530BRWpkeRrSUAplSPkcDgxyM88FTN23jJk90JBEnpTcCCJcCvFt
        8qQs86v2KxMRyw/GVE96OhUUwVsOEMiXRWwkndk=
X-Google-Smtp-Source: ABdhPJwa2UaXTM1bO0au2APXOAgO5CgRdgGIi3PGjRnYayrkCf8OD5cOg0uIwqGcL1rGo4G1g68AMw==
X-Received: by 2002:a63:a549:0:b0:382:53c4:cb95 with SMTP id r9-20020a63a549000000b0038253c4cb95mr3340079pgu.98.1648587290418;
        Tue, 29 Mar 2022 13:54:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q22-20020a056a00085600b004fb308e393csm12893603pfk.178.2022.03.29.13.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 13:54:49 -0700 (PDT)
Message-ID: <62437219.1c69fb81.de44a.00c8@mx.google.com>
Date:   Tue, 29 Mar 2022 13:54:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.18-27-gc3aede4bd0e3
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.16 baseline: 121 runs,
 2 regressions (v5.16.18-27-gc3aede4bd0e3)
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

stable-rc/queue/5.16 baseline: 121 runs, 2 regressions (v5.16.18-27-gc3aede=
4bd0e3)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
kontron-pitx-imx8m | arm64 | lab-kontron   | gcc-10   | defconfig          =
        | 1          =

rk3399-gru-kevin   | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chr=
omebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.18-27-gc3aede4bd0e3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.18-27-gc3aede4bd0e3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c3aede4bd0e337ceec4822f0344d7c2d1d3f619e =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
kontron-pitx-imx8m | arm64 | lab-kontron   | gcc-10   | defconfig          =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/62433e9952691e8a71ae06a3

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.18-=
27-gc3aede4bd0e3/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.18-=
27-gc3aede4bd0e3/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/624=
33e9952691e8a71ae06b6
        new failure (last pass: v5.16.18-6-gf2dce803af00)

    2022-03-29T17:14:47.770860  /lava-104010/1/../bin/lava-test-case
    2022-03-29T17:14:47.771150  <8>[   11.301752] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>   =

 =



platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
rk3399-gru-kevin   | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chr=
omebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62434471bcf6425259ae0689

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.18-=
27-gc3aede4bd0e3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.18-=
27-gc3aede4bd0e3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62434471bcf6425259ae06ab
        failing since 21 days (last pass: v5.16.12-85-g060a81f57a12, first =
fail: v5.16.12-184-g8f38ca5a2a07)

    2022-03-29T17:39:36.947897  /lava-5971114/1/../bin/lava-test-case   =

 =20
