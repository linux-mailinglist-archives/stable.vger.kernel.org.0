Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B624DBE87
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 06:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiCQFi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 01:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiCQFi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 01:38:26 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54CA2619BE
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 22:07:30 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id t2so5880213pfj.10
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 22:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=96vEKI0M2UBwbVptm9828eNLzq81CBrEq4mmybzqsuY=;
        b=y+cwgbHZLEYe3u89Rv9wY+JqejBc9arUPA0Bm1TiZMahiaNoSKjvcRLQNKErrWPXY1
         htYToBCcWL5JBcG3kow2VpRZFCXF1LRCzHwpAdDKvi6hvTf6kDl4lmo3+LZj3k/AZBJz
         oSORvI0/u26AlLpfBZyFF5GVq+BATVStpapL3Gwso+6Qewl8s3rzBPbgI45SdJNkKRIs
         2MzLSmvizZ9AkK40dxqMj2ORXhqLef69e1Sdpuc6amGj0iji0REZeqg8WU8nwgZ50Hun
         4e5fLcaafFsn/VD5azackyr/qcpL0cj+o+i69tVyOMcPWOmCzkCRkW6I923utoMYcdmZ
         i2uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=96vEKI0M2UBwbVptm9828eNLzq81CBrEq4mmybzqsuY=;
        b=WcGkmTlkjDVD90VFLiJwjQ3LeyNgmhH5Usx+CY6YvEqTD9d+6PGvQQEwocHZK6wyFA
         GIh642DxVZK4KlVP31o3p6UEd4y+AOoHAWwf9h0vD+llf0RU2LRsZUcFNqat7OyrrBBh
         9IlWPR67o7heBv8BkqQXkcD3iOyPzcei+nt9J0KtZLL0mjK1cyjNlQGuyImFUptOjmrj
         paSmwJf696NVTPCnpH6mUpASN/nQQpedbmftM83PYIFpQYQruPwALZLZivgzKMkFu2Xm
         vG0wpI4N6mOyc4Ne9YrM23T4Xw4aa4OeXFrr2dAaAvV6fjbPmkXb3brIjriSzt1XfKnj
         0SzA==
X-Gm-Message-State: AOAM533p6QbQFVN/PrPObJifz3gBaY4XIeeAqU7FJaALDjwMouQKw7DL
        aXGvYeNZ/3Ua7U1lmqSNWZmdYaeYBVlzt/KAJ3U=
X-Google-Smtp-Source: ABdhPJxjzcU/CZ2Hbhh+s2n7AONmopm06hfY6pWya9hmrAupLqXmjCfwzQQhQR8SWE/9q+p8zHYPPQ==
X-Received: by 2002:a05:6a00:1307:b0:4b0:b1c:6fd9 with SMTP id j7-20020a056a00130700b004b00b1c6fd9mr2663797pfu.27.1647493650180;
        Wed, 16 Mar 2022 22:07:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id pi10-20020a17090b1e4a00b001bf9749b95bsm8600376pjb.50.2022.03.16.22.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 22:07:29 -0700 (PDT)
Message-ID: <6232c211.1c69fb81.47a44.662f@mx.google.com>
Date:   Wed, 16 Mar 2022 22:07:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.185
Subject: stable-rc/linux-5.4.y baseline: 90 runs, 3 regressions (v5.4.185)
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

stable-rc/linux-5.4.y baseline: 90 runs, 3 regressions (v5.4.185)

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
el/v5.4.185/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.185
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      70f77a2cb5281ad0b08a0bbdeeba885984c399dd =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62328acc0cf00e71e3c6296f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.185=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.185=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62328acc0cf00e71e3c62=
970
        failing since 91 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62328ab7c806c3a6f1c62987

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.185=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.185=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62328ab7c806c3a6f1c62=
988
        failing since 91 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62328b0bb220013526c6297b

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.185=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-=
kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.185=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-=
kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62328b0bb220013526c629a1
        failing since 10 days (last pass: v5.4.181-51-gb77a12b8d613, first =
fail: v5.4.182-54-gf27af6bf3c32)

    2022-03-17T01:12:24.061132  /lava-5894770/1/../bin/lava-test-case
    2022-03-17T01:12:24.069624  <8>[   32.619282] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
