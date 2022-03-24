Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E654E69B2
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 21:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239738AbiCXUOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 16:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiCXUOa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 16:14:30 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C489AD137
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 13:12:58 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id h19so3820553pfv.1
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 13:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=l7h/wDvfOXcD4EloF2zDlv6C7TAUYRRmuSt5xPh4yJs=;
        b=iu9qNWvBlEaZDG6HQ4ufLD2rDzLGx/oD53sdCoMPKVrL/HYl18II3B54wQaKmEppCY
         aghLR2gOKe9Coz17/kJfdribQPm4TOy+qEukFJNU/8ZMPL8ttx1Fy9GRQg/n5GuqAJY5
         Dj19QApd2w3kqO9nNhPysrBIu4NuoUh75Lsl4Em3PHRRuxM5l3VfG5C+dQ9rsGVX2AEq
         1KzmLoYxGIremA5josPANb1tX/6O5PDhctWeAkkWVD+RhKDnTX87sLdC2oPWanIgm47r
         f3DwXppYiJrORDPh9bGQVmxttuTuL/clFgJFTyJQ/5CZIJ0h6KvnHdqkF/vnSLTW/tzu
         wYDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=l7h/wDvfOXcD4EloF2zDlv6C7TAUYRRmuSt5xPh4yJs=;
        b=wOBKeggAo3F1SlAHizkerIw7F31aJIuVHIqrXUy8w9AK1PMghMWB/jXwGTLEU7d45p
         fxNO5h24TUTyTWWrJcFIjCRfS+DcnMO2fi5HJ7bE+QXbvMHnp3uJn+wdRirmKgF4ENF4
         wKE9d+NSpu/MBsqnaEZib1z1pydQYC8ieedQYW+UXgA4fovG9NSmf4wEcuZPgNR2KXUP
         qgpArW8PoIcswvjNyiF+G+wlK0NZsy6pv48IWkzZnsHdDk1kIF6ekcO3RVANEM1fHt5H
         VOgqTRz5EAcc7l/rJgC6gs04fKklvmYQLYuG4C+6V9XsUGhFUqaFOA38X5m6yb4Cz3AK
         riVw==
X-Gm-Message-State: AOAM5336oS0CufhBR8bQ3Kf543TlpAC+O2/bWwZBQrX5iVhfhvP8T2p4
        jccioVXPVwJC1WTQ3C9mbvOJl+3VdfCtTrRuDxk=
X-Google-Smtp-Source: ABdhPJxHL/N6aZtnYmui2/Hs334nWs3Ao2bdJ0lnggq/Eq3jGSjfIOrhScaLrXFuluIh2SmckuK5Dg==
X-Received: by 2002:a05:6a00:1a42:b0:4f7:e158:152e with SMTP id h2-20020a056a001a4200b004f7e158152emr6715000pfv.50.1648152777483;
        Thu, 24 Mar 2022 13:12:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b25-20020a637159000000b00381fda49d15sm3651223pgn.39.2022.03.24.13.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 13:12:57 -0700 (PDT)
Message-ID: <623cd0c9.1c69fb81.b1f3e.ae9b@mx.google.com>
Date:   Thu, 24 Mar 2022 13:12:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.187-5-g65e0a54f32b2
Subject: stable-rc/queue/5.4 baseline: 88 runs,
 3 regressions (v5.4.187-5-g65e0a54f32b2)
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

stable-rc/queue/5.4 baseline: 88 runs, 3 regressions (v5.4.187-5-g65e0a54f3=
2b2)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.187-5-g65e0a54f32b2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.187-5-g65e0a54f32b2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      65e0a54f32b222a69f041c9f81160b319c1c7528 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/623c97a4ead837d797772534

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.187-5=
-g65e0a54f32b2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.187-5=
-g65e0a54f32b2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/623c97a4ead837d797772=
535
        failing since 98 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/623c977c237f34ea1577251c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.187-5=
-g65e0a54f32b2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.187-5=
-g65e0a54f32b2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/623c977c237f34ea15772=
51d
        failing since 98 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623c9da1ae5f057eda772517

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.187-5=
-g65e0a54f32b2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseli=
ne-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.187-5=
-g65e0a54f32b2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseli=
ne-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623c9da1ae5f057eda772539
        failing since 18 days (last pass: v5.4.182-30-g45ccd59cc16f, first =
fail: v5.4.182-53-ge31c0b084082)

    2022-03-24T16:34:17.234950  /lava-5940905/1/../bin/lava-test-case
    2022-03-24T16:34:17.243313  <8>[   33.081492] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
