Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD184D8FA3
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 23:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245668AbiCNWkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 18:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245670AbiCNWkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 18:40:12 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBA42558A
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 15:39:01 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id t5so16502441pfg.4
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 15:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aCc3ysLcupTOCvOpQE4J+uyQHCYiJCkyMbFxDUjYRzg=;
        b=F7bLNTN8CEauVzTI7e9+OATvI5yXnNHkgsPcDBJ6P/Awh0E+ZU4cxUWc3s0spwUUnX
         l7D2uVcUwhHgOJugHXx0irecUQ37C4n4lcg4shWahit86Q9D7+AEqCS+uenmoU4v5/VN
         hPDFb1In/R2V7XjANPuyjlTpuKPHuqJRt9OgTKLOorURGPkOTVEkYpf7S1n+OQj/x3wS
         DlQWqTok7LYR4tY9PiNDPzxu4dO0cu5R+DC9CL55+/Li3TYS1MxFkFE20WutTsVERf26
         Kv1JyO8PLOPdDWsS1pEgzlIwZw/Pl+FmJNQjktCFG8LTY21HNqNNj168MZtRTFKae1D+
         MzFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aCc3ysLcupTOCvOpQE4J+uyQHCYiJCkyMbFxDUjYRzg=;
        b=sJELvlyYRE/gm5GJuWJ5G1oJBNK0bZG43/HUeR7YlRkRY261s45EYDdJvHZmxa2zPR
         mYwpCk5sTM1CVr+3H1FrCRFh042Glt3H+IV/N4os99VMe85TJLXpUAvymVCt93Ovv9Ov
         Uw3fzL2qlmDFdcO8r3YeB7jVFoSyA4X/qxsVhaJgX3qnTuo3s3EPWimiLQ0bqAAJOgqX
         vj5phx4gykff2bNIumNXX25W5ZKmnJvR88KUd7L3EBWypLqcQJTuCzvbWZUs1NNZcO+u
         1qhiGw8SKZ8IXZ0jJccN6oBc7SFZpgyoUAmGED/7CX0Aw1v0+rxnQB7iGPtWWQnFc2rj
         6pOA==
X-Gm-Message-State: AOAM532Sx18wEZhEt53lc1u2HIb49khA5f1a7JZX1ZauHqwtKqPBnNmO
        Fca2jt1LzcqdpScZOgaXJXQvw+DoPnmOJHyV7ew=
X-Google-Smtp-Source: ABdhPJzDbeszMBjCD4ckg5sxq+rsR5jFbqFmYYHPv2YWgr0fJdzwYwldmhU9q6+uj5ZBFn1PG7PyNA==
X-Received: by 2002:a65:6210:0:b0:374:ba5:aacc with SMTP id d16-20020a656210000000b003740ba5aaccmr21383739pgv.8.1647297540378;
        Mon, 14 Mar 2022 15:39:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k1-20020a056a00134100b004f78df32666sm14503999pfu.198.2022.03.14.15.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 15:39:00 -0700 (PDT)
Message-ID: <622fc404.1c69fb81.f42e5.321b@mx.google.com>
Date:   Mon, 14 Mar 2022 15:39:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.184-44-gcb0af18075f0
Subject: stable-rc/linux-5.4.y baseline: 70 runs,
 3 regressions (v5.4.184-44-gcb0af18075f0)
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

stable-rc/linux-5.4.y baseline: 70 runs, 3 regressions (v5.4.184-44-gcb0af1=
8075f0)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.184-44-gcb0af18075f0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.184-44-gcb0af18075f0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cb0af18075f051a9c4e242e027f1c6d08ac573a8 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/622f8a6219471fe217c6296c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.184=
-44-gcb0af18075f0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.184=
-44-gcb0af18075f0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622f8a6219471fe217c62=
96d
        failing since 88 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/622f8a7443f329f8f4c62984

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.184=
-44-gcb0af18075f0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.184=
-44-gcb0af18075f0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622f8a7443f329f8f4c62=
985
        failing since 88 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622f8ecad84a6d7dd0c62983

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.184=
-44-gcb0af18075f0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.184=
-44-gcb0af18075f0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622f8ecad84a6d7dd0c629a9
        failing since 8 days (last pass: v5.4.181-51-gb77a12b8d613, first f=
ail: v5.4.182-54-gf27af6bf3c32)

    2022-03-14T18:51:47.748102  <8>[   32.080721] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-14T18:51:48.758621  /lava-5877551/1/../bin/lava-test-case   =

 =20
