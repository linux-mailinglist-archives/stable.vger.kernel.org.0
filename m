Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882E95F2FEF
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 13:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiJCL6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 07:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiJCL6g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 07:58:36 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0BC4F645
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 04:58:35 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 83so3013563pfw.10
        for <stable@vger.kernel.org>; Mon, 03 Oct 2022 04:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=TH4cpelDdO1/Ub5fHWK8Gl6mcfMTmcYSVmTpk+JJTxA=;
        b=Ju7M04oimSRbjnle9b9Jk2R4vF6F/YswZlm0unF+5XHBiOSKfzKblte8mfzuCpY9O+
         +KUBx7305NjWHLGRICKYg5enc8YPROIhNnNSUUtRt5NO9iYhbqnQn5oyICpx25Fl9Qu4
         YhCvW+HDzIIIsaBoKiTHLUBfLhHB+CB1iqFvKKcxsLgX8cX1+1edcZCrbLE+b7pbQRM4
         Ah4UhP3NS8Q6LEVIbzYLNLzSmUvCmlzfS5ligEPjIokx1+i1VjeolyiheF3ndp119byI
         DYi+manhVKKKkTVnofmoNABViKneKMRk9pKAmy1JanAxuO4iXeAQCsfRf9PFl/RsLHbf
         ZEXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=TH4cpelDdO1/Ub5fHWK8Gl6mcfMTmcYSVmTpk+JJTxA=;
        b=xsR0SZjUIHA+irsZ9CKJ02U3lLzEGxZMANVzuPy/5t5rxRuH1mt5ETW6y27F9X8dWC
         0C8mO9j+6tozavnVtRJ+VfeLLzXI+klWocWeDW7EyLV4GvFFVEysQeiOqoh+2CTRUiSL
         BzcmKrH1HTqnrebsMlqcl5/Mt5ekX9kpe5kBEAv+09LXZTibmWRu9xXgXkkbdbJcP9kT
         ivMzsjKtcQCET+tD6g+QNCnYMoi0ifqXoNnx1BUIq49cu1c/w2X7VwOp4XkrgM/UajJu
         dTCYihsISMJPNkFZZJt6kXnV2bEa+EHinGqgT+jPSXf+7ApJjpih4D4HhOkQNjPmvLbQ
         aDYA==
X-Gm-Message-State: ACrzQf3b6cgwe6Mo7q1tjFne9lLPqDAk1M5M/1I/WFJ8XkkLgjVEV4vD
        QT2FedfGzpZC5tep3ZslOXmbV57aCSGWGnMtaXs=
X-Google-Smtp-Source: AMsMyM4r9PCXHX2XjnRadHJQPO2TTZL1EsIvRtkBNO8eAhBwajif18qZxUxxOoe4gnPcUUwo/StCVA==
X-Received: by 2002:a05:6a00:124e:b0:561:b241:f47f with SMTP id u14-20020a056a00124e00b00561b241f47fmr250255pfi.72.1664798314637;
        Mon, 03 Oct 2022 04:58:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p124-20020a62d082000000b0053617cbe2d2sm7237229pfg.168.2022.10.03.04.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 04:58:34 -0700 (PDT)
Message-ID: <633ace6a.620a0220.b4076.bfde@mx.google.com>
Date:   Mon, 03 Oct 2022 04:58:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.71-84-g6b8312581f86c
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 124 runs,
 4 regressions (v5.15.71-84-g6b8312581f86c)
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

stable-rc/linux-5.15.y baseline: 124 runs, 4 regressions (v5.15.71-84-g6b83=
12581f86c)

Regressions Summary
-------------------

platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
imx7ulp-evk | arm  | lab-nxp      | gcc-10   | imx_v6_v7_defconfig | 1     =
     =

imx7ulp-evk | arm  | lab-nxp      | gcc-10   | multi_v7_defconfig  | 1     =
     =

panda       | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1     =
     =

panda       | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.71-84-g6b8312581f86c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.71-84-g6b8312581f86c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6b8312581f86c31858502556391330b10956a92b =



Test Regressions
---------------- =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
imx7ulp-evk | arm  | lab-nxp      | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/633a99dbda3b279fe3ec4eb0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1-84-g6b8312581f86c/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp=
-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1-84-g6b8312581f86c/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp=
-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633a99dbda3b279fe3ec4=
eb1
        failing since 6 days (last pass: v5.15.70, first fail: v5.15.70-144=
-g0b09b5df445f9) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
imx7ulp-evk | arm  | lab-nxp      | gcc-10   | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/633a9e1565fee21c34ec4eb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1-84-g6b8312581f86c/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1-84-g6b8312581f86c/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633a9e1565fee21c34ec4=
eb6
        failing since 6 days (last pass: v5.15.70, first fail: v5.15.70-144=
-g0b09b5df445f9) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
panda       | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/633a9fe1647fe01edcec4f1d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1-84-g6b8312581f86c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1-84-g6b8312581f86c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633a9fe1647fe01edcec4=
f1e
        failing since 48 days (last pass: v5.15.59, first fail: v5.15.60-78=
0-ge0aee0aca52e6) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
panda       | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/633a9bbce2e1f5b1ffec4eba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1-84-g6b8312581f86c/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1-84-g6b8312581f86c/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633a9bbce2e1f5b1ffec4=
ebb
        failing since 40 days (last pass: v5.15.60-779-g8c2db2eab58f3, firs=
t fail: v5.15.62-245-g1450c8b12181) =

 =20
