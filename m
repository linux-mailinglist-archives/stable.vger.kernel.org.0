Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63EC5340F6
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 18:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234688AbiEYQDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 12:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbiEYQDU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 12:03:20 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C340A88A3
        for <stable@vger.kernel.org>; Wed, 25 May 2022 09:03:19 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d22so18934211plr.9
        for <stable@vger.kernel.org>; Wed, 25 May 2022 09:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RNissQHs8KmuD8JiwFp8E9Nd5RC3MVJ39Q3ieR87izg=;
        b=g76STuKbgmla2SiBB1jD4WQ2UKVxLB8g9e0FWYpEiflkezsAqcYt2iCEflvQH5w+OS
         cOjnOOnSplcRg4fKx7JMW7FBL5isB6m8bZSG3/g5FTlsJHE1ywBL7hkegxQzJQzNovZF
         YqSLHb293BwPCwjo437Ttut4IpF34UXovNnExJYh8gIK7y77TP71+1X9oI+ofte0ITBf
         Hh1qdz5M0ZgSopn2VYPx0UvlXLx+irheCnBY/U71Atge0ySm3OVVUZQsHua4Dt2RLwSn
         PGzWa7LKZEm21XIDKYjgJmU/mENhZdezypbm8oqJWj3rrC8cL+DWrapc5d2+guoTjDM1
         5Qpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RNissQHs8KmuD8JiwFp8E9Nd5RC3MVJ39Q3ieR87izg=;
        b=XR7pLTDWDqY5YgVagsBUbIKe01IJ7WlLCxf+ykH7QTz8K3YPXCjEfEm4e7HIWD6nAw
         jA83zXuELXy/Vx+y7CZ5qnXAg8lNQuJuZl5qFzUbr151HeLET3VLBdPBFBWqSKD+zt5m
         KzGy34heIvgHafRgFJEx/UbjB/7dbz+B1Zf53i5uY4qBEIhPRlxDJdGWbMP1UzUvQVi+
         oS2eU8GJWxd59Q7/cuFSZZ0pp+N4Jqk2pmmIqT6DC7T/IKUqhU+djxCNqDLo5bf9mL/i
         uRFPSuzrqK9mP2yTwC1qGFqV9GcSBSEaBFHXSRoaeMWEU7sIKRgZLAC5XQAXKLWL645h
         n2Uw==
X-Gm-Message-State: AOAM532YdHHdg1un5vNAYs7ttHZF6m94wm55N45znTG4hxrXKH7mlxEE
        OAv9N11hPF3OjR+AwGuK4bkaMNvZ2vEXzPbvJ8Q=
X-Google-Smtp-Source: ABdhPJzDQbC40YEzjjYnDBCtE7vZvF166fu9dwoDcuv83mHhU1q/dpVMduquoKUCtwcvT5Pd4Lm9Fg==
X-Received: by 2002:a17:902:c942:b0:161:e3aa:26fd with SMTP id i2-20020a170902c94200b00161e3aa26fdmr30201982pla.103.1653494598611;
        Wed, 25 May 2022 09:03:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y15-20020a17090a6c8f00b001cd4989ff44sm2002733pjj.11.2022.05.25.09.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 09:03:18 -0700 (PDT)
Message-ID: <628e5346.1c69fb81.fa9cf.4f70@mx.google.com>
Date:   Wed, 25 May 2022 09:03:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.42
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 115 runs, 4 regressions (v5.15.42)
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

stable-rc/linux-5.15.y baseline: 115 runs, 4 regressions (v5.15.42)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

jetson-tk1       | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =

jetson-tk1       | arm   | lab-baylibre  | gcc-10   | tegra_defconfig      =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.42/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.42
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c5871dddc145ac70916dac7c3f8366aba55ed9f3 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/628e240fc1f4de6269a39bee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
2/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
2/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628e240fc1f4de6269a39=
bef
        failing since 12 days (last pass: v5.15.37-259-gab77581473a3, first=
 fail: v5.15.39) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/628e2b7c1e238f16eba39bee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628e2b7c1e238f16eba39=
bef
        failing since 1 day (last pass: v5.15.40, first fail: v5.15.41-133-=
g03faf123d8c8) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | tegra_defconfig      =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/628e2971302d0f1c1ea39bd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
2/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
2/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628e2971302d0f1c1ea39=
bd2
        failing since 1 day (last pass: v5.15.40, first fail: v5.15.41-133-=
g03faf123d8c8) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/628e2633559b2b041ea39bf1

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/628e2633559b2b041ea39c13
        failing since 78 days (last pass: v5.15.26, first fail: v5.15.26-25=
8-g7b9aacd770fa)

    2022-05-25T12:50:47.029190  <8>[   32.496035] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-25T12:50:48.051096  /lava-6466273/1/../bin/lava-test-case
    2022-05-25T12:50:48.061918  <8>[   33.530466] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
