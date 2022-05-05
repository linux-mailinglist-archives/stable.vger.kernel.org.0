Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B86451B73A
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 06:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242958AbiEEEqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 00:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242826AbiEEEqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 00:46:03 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D029446664
        for <stable@vger.kernel.org>; Wed,  4 May 2022 21:42:24 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id iq10so3144772pjb.0
        for <stable@vger.kernel.org>; Wed, 04 May 2022 21:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=is+MQNyK53JAdnWqEzVZfrHi8cJtomB6VWYl1kngfpA=;
        b=XlvhjYMyqLMz/Ht+3cqask9jR6m4CkHIa/BnqtrBkvppOKSOKwMHLklc592uTQ2QfG
         5zgs6wE4GWjh9+nPWA0QPj5upgkzF+BM2vWYwn+zX+Fkgt6upMAD6XHskzxrVqWf/co4
         xVz9Otngf2bDWBXTQ+hn+E0RJ4JqbUhdL2TiGuw8gz7LXupbhBU3WI7hveQmtCGWdnqm
         Yy/sNL/RHZ2fKGPUpxHeLf2v4CUZ1OutpExCPLiVuEdNABe7vchdhrhF21nzP2tYISwy
         huybpZ7fYoabRGtpPExGRuaQ3EE8ztgCwkx3U9GjjPR8WEdF6RAw37XYQ5bwJG1EkHow
         P6CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=is+MQNyK53JAdnWqEzVZfrHi8cJtomB6VWYl1kngfpA=;
        b=19gOAnpKrPHLdNPTPYko48tGEUnl1E+reERRFdbp6AGiXXpqoskbR7yvbE7JW/csuQ
         WD4to1mVqsQcYqTFR7xxEzU6DkUnknOBUlAh43jgF7bNEBEDJByDFb3D17/IUsLytN3q
         Q3SqULLkBsnMyS69JHLiMVqgAzhYi+E+Q1sLv4eOpgJtLUmC8I+BseFZPoAjPYVFir2v
         zxTnW+c1sarQIuwq4KuaQcJIxaw4+DfGL40/HN1Vhi+AskBZgW77mBXz+WItE28Aekrz
         joQbvZVtRljst1GyRxZ9vBxoQ3eHkn8e//3B0q2drgl2n0DKKPaotWhGVrk8Fu8MMbS1
         PoMg==
X-Gm-Message-State: AOAM531iBxWGmji/8j8QOI4BV8hwnnp9rmvar9ksVLMy57DHlV17vy/L
        CFD2Gn200c8lWuAGFqH4/bxB28poor9mRipWEhU=
X-Google-Smtp-Source: ABdhPJwdMOopmvi1wLVTJXhuHx58T2Pnsj5itAVFjKJltsWjilMKxI7t5ehoR55A2o8OHBxE1jNu7w==
X-Received: by 2002:a17:90b:3ecb:b0:1dc:5401:bea with SMTP id rm11-20020a17090b3ecb00b001dc54010beamr3812399pjb.20.1651725744169;
        Wed, 04 May 2022 21:42:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s40-20020a056a0017a800b0050dc7628146sm285569pfg.32.2022.05.04.21.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 21:42:23 -0700 (PDT)
Message-ID: <627355af.1c69fb81.96547.0c84@mx.google.com>
Date:   Wed, 04 May 2022 21:42:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.113-130-g0412f4bd3360
Subject: stable-rc/linux-5.10.y baseline: 137 runs,
 4 regressions (v5.10.113-130-g0412f4bd3360)
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

stable-rc/linux-5.10.y baseline: 137 runs, 4 regressions (v5.10.113-130-g04=
12f4bd3360)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
am57xx-beagle-x15        | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 2          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.113-130-g0412f4bd3360/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.113-130-g0412f4bd3360
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0412f4bd3360abe0f87f814f6b1325813bbe9f44 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
am57xx-beagle-x15        | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62733aac4b4472ffc98f572c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
13-130-g0412f4bd3360/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-am=
57xx-beagle-x15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
13-130-g0412f4bd3360/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-am=
57xx-beagle-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62733aac4b4472ffc98f5=
72d
        new failure (last pass: v5.10.110-171-gb82c8b005aaf) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/627321d23b588676d78f5764

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
13-130-g0412f4bd3360/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-im=
x6q-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
13-130-g0412f4bd3360/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-im=
x6q-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/627321d23b58867=
6d78f576b
        new failure (last pass: v5.10.113-130-g9bf02e9ae445)
        26 lines

    2022-05-05T01:00:42.471994  cec60217] *pgd=3D1ec1141e(bad)
    2022-05-05T01:00:42.521154  kern  :emerg : Internal error: : 1 [#1] SMP=
 ARM
    2022-05-05T01:00:42.521411  kern  :emerg : Process kworker/0:4 (pid: 54=
, stack limit =3D 0x(ptrval))
    2022-05-05T01:00:42.521862  kern  :emerg : Stack: (0xc2405eb0 to<8>[   =
43.139773] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D26>
    2022-05-05T01:00:42.522112   0xc2406000)
    2022-05-05T01:00:42.522329  kern  :emerg : 5ea0<8>[   43.151098] <LAVA_=
SIGNAL_ENDRUN 0_dmesg 1902329_1.5.2.4.1>
    2022-05-05T01:00:42.522541  :                                     1e9b1=
0fe ef4f4b8c c2404000 cec60217   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/627321d23b58867=
6d78f576c
        new failure (last pass: v5.10.113-130-g9bf02e9ae445)
        4 lines

    2022-05-05T01:00:42.468762  kern  :alert : 8<--- cut here ---
    2022-05-05T01:00:42.469021  kern  :alert : Unhandled fault: alignment e=
xception (0x001) at 0xcec60217
    2022-05-05T01:00:42.469250  kern  :alert : pgd =3D (ptrval)
    2022-05-05T01:00:42.469467  kern  :alert : [<8>[   43.092922] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>   =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62732dccde2e5b4f548f571d

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
13-130-g0412f4bd3360/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
13-130-g0412f4bd3360/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62732dccde2e5b4f548f573f
        failing since 58 days (last pass: v5.10.103, first fail: v5.10.103-=
106-g79bd6348914c)

    2022-05-05T01:51:47.195385  <8>[   60.134583] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-05T01:51:48.219138  /lava-6269072/1/../bin/lava-test-case
    2022-05-05T01:51:48.229621  <8>[   61.169221] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
