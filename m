Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169C054A7A9
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 05:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348863AbiFNDvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 23:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349498AbiFNDvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 23:51:37 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC8039161
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 20:51:33 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 31so5739690pgv.11
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 20:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QLRSnLdvydnD794EmOTnObaI+vzrdherlIejBGdtDzE=;
        b=Alkz0e75KjCBD8Nc50/8C+qYPCZ3vtTprGIKQ3Oo2zBsg2ST42F5biGuewcTpKvmKW
         CgrhDJSI1/J42EAVKFh1yYCcJtfobKAxEYFMbB36ioFn8dU4BdcpBrlv8gWshqL5KGuH
         Ikh2hNz0et1j8b8nVul1yGjdBV61jiCppPvoHfOqdkTdxdLeqA4DI7ok+aQ4DR5g97zd
         VgQo1e7PiAoPvXT35HIlCdcpsv3g9kX+o0Df6wjmN6GiMx9v53njxvuMn2+enZIydcvN
         vO20jV/fk/CjIXSDgf7xZhwcuHavVGivl7ZkgaWaIQSxvJw0hj9jw6IFJVp556SZQjv7
         8x/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QLRSnLdvydnD794EmOTnObaI+vzrdherlIejBGdtDzE=;
        b=PfavctZSz9IcT8asUN1xxcMjKEvNKe1akJEJ0pSsp3+f8zQixG9rE1k1ryeFFb1hKH
         PAduXiKQjR1amd5BQJ42lc6QLUojEtTaEND0DMkANFwlKq+xcakL4yDxld8FVyvdhm7Z
         OCAYhr5MnAXwXV0eL2C72a80RH5lK6AEAb005C+tmdyuLWFelvyUabixZ9zU2laR55Ue
         g6huy1XY0nHKTN1jw06MxwznyzshBzrQD3p/KMuAYrqQg3qJgdW2YZhtiivhpwmrEUQM
         8hN1wKEjcLEXO5YO1p4U0OBEW4c9vCe/MBq93z1gjEsQ8jHlD8MHAo7Uv53RjnIrLQLA
         Ik8A==
X-Gm-Message-State: AOAM533tN44Cnbe+KpX7ndRZ9Uv2wZHAuoydjfwUd9AgLN7dFUKwHjCp
        87XnQfFiiH2wf5t4D7ey63uJMkxwalH829f4GGM=
X-Google-Smtp-Source: AGRyM1tr9xXjMBCrPdBiJy0k3J2ibm89S37nlzYS3unlEQxg6iS/JB0CLMp70nqysdIiJkOUHjS5NA==
X-Received: by 2002:a05:6a00:170b:b0:51b:cf4b:9187 with SMTP id h11-20020a056a00170b00b0051bcf4b9187mr2660046pfc.15.1655178692285;
        Mon, 13 Jun 2022 20:51:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 19-20020a170902e9d300b001677fa34a4fsm5943087plk.72.2022.06.13.20.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 20:51:31 -0700 (PDT)
Message-ID: <62a805c3.1c69fb81.19bb7.7806@mx.google.com>
Date:   Mon, 13 Jun 2022 20:51:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.13-1076-ga554a1e2ef7fa
X-Kernelci-Branch: linux-5.17.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.17.y baseline: 175 runs,
 3 regressions (v5.17.13-1076-ga554a1e2ef7fa)
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

stable-rc/linux-5.17.y baseline: 175 runs, 3 regressions (v5.17.13-1076-ga5=
54a1e2ef7fa)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
jetson-tk1              | arm   | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

kontron-pitx-imx8m      | arm64 | lab-kontron  | gcc-10   | defconfig      =
    | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig      =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.17.y/ker=
nel/v5.17.13-1076-ga554a1e2ef7fa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.17.y
  Describe: v5.17.13-1076-ga554a1e2ef7fa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a554a1e2ef7fa48cebd9cc2349804974247c0958 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
jetson-tk1              | arm   | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/62a7d070c21889d198a39be2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
3-1076-ga554a1e2ef7fa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-j=
etson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
3-1076-ga554a1e2ef7fa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-j=
etson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7d070c21889d198a39=
be3
        failing since 19 days (last pass: v5.17.10, first fail: v5.17.11) =

 =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
kontron-pitx-imx8m      | arm64 | lab-kontron  | gcc-10   | defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62a7ceb9bdadbb14aaa39c60

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
3-1076-ga554a1e2ef7fa/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-p=
itx-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
3-1076-ga554a1e2ef7fa/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-p=
itx-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7ceb9bdadbb14aaa39=
c61
        new failure (last pass: v5.17.13-1071-gfcf11988907a1) =

 =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62a7ceb4bdadbb14aaa39c54

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
3-1076-ga554a1e2ef7fa/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64=
-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
3-1076-ga554a1e2ef7fa/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64=
-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7ceb4bdadbb14aaa39=
c55
        new failure (last pass: v5.17.13-1071-gfcf11988907a1) =

 =20
