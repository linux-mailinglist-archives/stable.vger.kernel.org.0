Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3AFF55D0CA
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243559AbiF1DtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 23:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243578AbiF1DtC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 23:49:02 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B77DE91
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 20:48:59 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id c205so10827028pfc.7
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 20:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1WqIVCCv3q1IK1CrS4BJ9gWOwBtITBARJshRdCVo3Wk=;
        b=nFFoVroiLW7X9V54gAMvFKNUQ1alyHBdk37D2yPN3NTwfkS3mPHBRWLjLyZVd+zvA1
         NxMaG6bwE6ItH7W7jNjVW/pcywapKDtJVkZ8TPVAs800/X4jqot41CRXHUx2RcrBvEXe
         y6p3HuFi6w+OR/pYjzuAMbF1yEeWmsY2M+6TCItyn8lrh4gk3DHTsjHjzn8bNjlyvvxY
         6m5xFMZix8kI5IcSWY7NPvG5nKyWjEt3gRprul5KTRkdeDbN854numPY/oSqKWXyo1TH
         sqmQHZZlgDmj7nD9nwtPHTm/58gz81EXMEtiwrkJa1qInZVCopj+MYdP3CsnJvoED51D
         e8ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1WqIVCCv3q1IK1CrS4BJ9gWOwBtITBARJshRdCVo3Wk=;
        b=Rkc+/UrIr1q3+LzegaZdIyvp1Aly5+KzpOQh/mgdJk93BPeEXTjqu9OQHlO5Qrpn/R
         txUFDxmPUi2GHQnhIL6F1JXvYT8NIKB8QkwYiygH4lq3ogGY2vXXBqhLVqLN54FlqggW
         KoemZG2X7ZfRPhnsHTFx4pSU7gD+cSjrFDlTYDKUoyFpHKuBgYLI+y4o/44V/eYjVGaY
         +J62LFxvn36Hqxyy7tpno77U+E5XRb91Ys3+mB1gOLpubYAvREnzPTe9RceSruvjfT+s
         6MqgCH+og/3W/n4qIarBobt5lS2eO+y/6AxBuejaNZiyCzMuWUBHmLtMiPcwXH6scUP8
         ogCA==
X-Gm-Message-State: AJIora8xCzy33lILIxzV/WjgNO81IHiDCByeM2ssSzSUPikpXg0ak38M
        3PI0C1tk2kC+8KCdgwYDs6xvmi4WZy2JhMoQ
X-Google-Smtp-Source: AGRyM1tBjGn8Ke/mM9w5Ypxr1xyj0+5IGvqJBOPGatO7v7k5dEc17jkvB5KrM9fi1zb38AK6A8DLiQ==
X-Received: by 2002:a63:230e:0:b0:40d:86ec:6272 with SMTP id j14-20020a63230e000000b0040d86ec6272mr15789387pgj.295.1656388139295;
        Mon, 27 Jun 2022 20:48:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p17-20020a170902c71100b001641a5d5786sm7951564plp.114.2022.06.27.20.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 20:48:58 -0700 (PDT)
Message-ID: <62ba7a2a.1c69fb81.6cd2c.b275@mx.google.com>
Date:   Mon, 27 Jun 2022 20:48:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.50-136-g2c21dc5c2cb6
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 192 runs,
 4 regressions (v5.15.50-136-g2c21dc5c2cb6)
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

stable-rc/linux-5.15.y baseline: 192 runs, 4 regressions (v5.15.50-136-g2c2=
1dc5c2cb6)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

i945gsex-qs      | i386  | lab-clabbe    | gcc-10   | i386_defconfig       =
      | 1          =

jetson-tk1       | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.50-136-g2c21dc5c2cb6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.50-136-g2c21dc5c2cb6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2c21dc5c2cb635c1b549c0f3eb0ff3d3744be11a =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62ba4273264440e195a39c2f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
0-136-g2c21dc5c2cb6/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
0-136-g2c21dc5c2cb6/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ba4273264440e195a39=
c30
        failing since 46 days (last pass: v5.15.37-259-gab77581473a3, first=
 fail: v5.15.39) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
i945gsex-qs      | i386  | lab-clabbe    | gcc-10   | i386_defconfig       =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62ba40bacf506049c4a39bdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
0-136-g2c21dc5c2cb6/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex=
-qs.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
0-136-g2c21dc5c2cb6/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex=
-qs.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ba40bacf506049c4a39=
bdd
        new failure (last pass: v5.15.48-116-gadd0aacf730e) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62ba5753ef119376d7a39c10

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
0-136-g2c21dc5c2cb6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jet=
son-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
0-136-g2c21dc5c2cb6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jet=
son-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ba5753ef119376d7a39=
c11
        new failure (last pass: v5.15.48-116-gadd0aacf730e) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62ba4241456d5b4d24a39c2f

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
0-136-g2c21dc5c2cb6/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
0-136-g2c21dc5c2cb6/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62ba4241456d5b4d24a39c55
        failing since 112 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-06-27T23:50:06.122577  /lava-6692588/1/../bin/lava-test-case   =

 =20
