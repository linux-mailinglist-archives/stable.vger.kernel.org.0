Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64713690EB3
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 17:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjBIQ5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 11:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbjBIQ5n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 11:57:43 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C58664653
        for <stable@vger.kernel.org>; Thu,  9 Feb 2023 08:57:42 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id r8so3520486pls.2
        for <stable@vger.kernel.org>; Thu, 09 Feb 2023 08:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=7PQBzHmA4OI5jHz9xnUBTTqe+RuAJ/uT3IFWHpP6Uo8=;
        b=RAWb8fr0ECiUalFrLYK0ZEhJaDo2zlBM4QUII10320mvbFzaHJ5RmkuH77TdXTM1sE
         tAqfZs8LPgwkL4tXAhEBueVOLLhUeypUSXvzSMjs8CjWy5M2tSATeSb346QhfUO/yFnv
         2izJuC6qdshm49mcdVPyw2XIBdEuQLnrUCmOHrBM79WcVCG++3mEQ6J0wJXrVy93glll
         yHFHXR7g7gQl6iKMihKwBmxDUUwDVFC/gUjoX9ohKA4QSuZBSMwHsSF34fxjO6kz7aPJ
         lI+jzBdMBhqhS8m8ReGhTWqZzcpHi8X1bMsmbt13CwiI45RO2ecSglKhiZr9vsbdSAGy
         8qwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7PQBzHmA4OI5jHz9xnUBTTqe+RuAJ/uT3IFWHpP6Uo8=;
        b=JdcHfIooxpGmejP8qrZ+VpcOF/zVqJ60A79o+OGPlqqyBxq6w/B8nY8EIi6c8Yt4EK
         JgjNfzqLhtgLw1SskHhHUMCi1Yh7OX2TIjI1wGfH/WiCIHv8r95+O3Qckfnl0wjpLqiu
         2pb6VbCkOks45hNrlaqmutHJ3phR+vmnagHr5mgBH7TeTu0aNb8R7iL2Pp/KIvVNbc19
         HK/TIVx5VH8Yi7Y4StygNv21doxA5vlY2qBreKW4tC+5+Cm/Q9fNyAfeYgfXAHk8evZ+
         4gMFXTRmyLWLPJrdKi2g9HJMf66LJJe9yTn4Oi5b2eE/hcqLH9z5/YFTFCiFdN0cXZX5
         AYKQ==
X-Gm-Message-State: AO0yUKVq9fS07kkG5ZdAk6rykpiMmYlcVieVOfnV0IexyM549bqrr46A
        sdBjc/2W+UJ4NaE+pPFCWV8OYFsnm5kK9W2EhLM=
X-Google-Smtp-Source: AK7set93inOZjyjLto4tvgk21Cjd74i8QzWInVydC0wYthpCumGx4T7K8SNZywULyErXMnVyniaF0A==
X-Received: by 2002:a05:6a20:8408:b0:bc:c663:41bd with SMTP id c8-20020a056a20840800b000bcc66341bdmr15362939pzd.4.1675961861333;
        Thu, 09 Feb 2023 08:57:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t13-20020a62ea0d000000b0057fec210d33sm1655742pfh.152.2023.02.09.08.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 08:57:40 -0800 (PST)
Message-ID: <63e52604.620a0220.403b8.3136@mx.google.com>
Date:   Thu, 09 Feb 2023 08:57:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.93
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 161 runs, 3 regressions (v5.15.93)
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

stable-rc/linux-5.15.y baseline: 161 runs, 3 regressions (v5.15.93)

Regressions Summary
-------------------

platform      | arch | lab             | compiler | defconfig          | re=
gressions
--------------+------+-----------------+----------+--------------------+---=
---------
at91sam9g20ek | arm  | lab-broonie     | gcc-10   | multi_v5_defconfig | 1 =
         =

cubietruck    | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig | 1 =
         =

imx53-qsrb    | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.93/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.93
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      85d7786c66b69d3f07cc149ac2f78d8f330c7c11 =



Test Regressions
---------------- =



platform      | arch | lab             | compiler | defconfig          | re=
gressions
--------------+------+-----------------+----------+--------------------+---=
---------
at91sam9g20ek | arm  | lab-broonie     | gcc-10   | multi_v5_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/63e4f0dd27cb0456e48c8658

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
3/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
3/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e4f0dd27cb0456e48c8=
659
        new failure (last pass: v5.15.91-142-ga0b338ae1481) =

 =



platform      | arch | lab             | compiler | defconfig          | re=
gressions
--------------+------+-----------------+----------+--------------------+---=
---------
cubietruck    | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/63e4f573b31c6af70b8c8647

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e4f573b31c6af70b8c8650
        failing since 23 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-02-09T13:30:08.802474  + set +x<8>[   10.008296] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3312931_1.5.2.4.1>
    2023-02-09T13:30:08.803205  =

    2023-02-09T13:30:08.913645  / # #
    2023-02-09T13:30:09.017438  export SHELL=3D/bin/sh
    2023-02-09T13:30:09.018513  #
    2023-02-09T13:30:09.120520  / # export SHELL=3D/bin/sh. /lava-3312931/e=
nvironment
    2023-02-09T13:30:09.121442  =

    2023-02-09T13:30:09.223750  / # . /lava-3312931/environment/lava-331293=
1/bin/lava-test-runner /lava-3312931/1
    2023-02-09T13:30:09.225564  =

    2023-02-09T13:30:09.226396  / # /lava-3312931/bin/lava-test-runner /lav=
a-3312931/1<3>[   10.433953] Bluetooth: hci0: command 0x0c03 tx timeout =

    ... (13 line(s) more)  =

 =



platform      | arch | lab             | compiler | defconfig          | re=
gressions
--------------+------+-----------------+----------+--------------------+---=
---------
imx53-qsrb    | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/63e4f51852b2341cda8c8636

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
3/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
3/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e4f51852b2341cda8c863f
        failing since 9 days (last pass: v5.15.81-122-gc5f8d4a5d3c8, first =
fail: v5.15.90-205-g5605d15db022)

    2023-02-09T13:28:34.608844  + set +x
    2023-02-09T13:28:34.609007  [    9.348854] <LAVA_SIGNAL_ENDRUN 0_dmesg =
901883_1.5.2.3.1>
    2023-02-09T13:28:34.715824  / # #
    2023-02-09T13:28:34.817610  export SHELL=3D/bin/sh
    2023-02-09T13:28:34.818204  #
    2023-02-09T13:28:34.919488  / # export SHELL=3D/bin/sh. /lava-901883/en=
vironment
    2023-02-09T13:28:34.919929  =

    2023-02-09T13:28:35.021194  / # . /lava-901883/environment/lava-901883/=
bin/lava-test-runner /lava-901883/1
    2023-02-09T13:28:35.021883  =

    2023-02-09T13:28:35.024330  / # /lava-901883/bin/lava-test-runner /lava=
-901883/1 =

    ... (12 line(s) more)  =

 =20
