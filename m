Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB9A5028E6
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 13:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238487AbiDOLif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 07:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233670AbiDOLie (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 07:38:34 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912785DE59
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 04:36:02 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id u29so3432787pfg.7
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 04:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PQ4v7nQ9CCIpJXx30XHAnpvpNxy3obzLZfP/bXg3K9Q=;
        b=EaMUFnh+G1yzuAXiFLiwZ817d70Lu915Gnl4jCeZ0cJuHt6KlM1WClL59dcPnCYgVz
         BsmlWsv1SEHeMP6zpME2c76Jwaw2PSSiZoNjHq4jSPqMBt5EXsPhY5CBYlSpOnv3+naB
         MM3Rq/W5kqgvR4p0n2HsNB3gW6XlvW3n9d5kGw3zxzqH4WCLhhRZlmhPLQP7keV3p4a6
         X23i85H4wfrNo7tCJcpSVZLRXOOBOOxxuouVa9IZ893Hu3wSsKbrIZm/irtndy1IfF5r
         00Ln6ChFHE5sUjmuAIssNxqy0Caip3GujvLOMe8M+592a3gATNFnILIoZnP49ySLMePm
         aS1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PQ4v7nQ9CCIpJXx30XHAnpvpNxy3obzLZfP/bXg3K9Q=;
        b=424S8r+O2N7f7bvUBHyYrBpUd5/ESCtGJYaSEZYQzq4OTpVZti4OzZDz5PW989prOM
         8yGHTQ6TJ2mnIMpkqdcaDZnmO4tw+s+Vpa+KRkvoyUONx8sMSECuDe5o9HGT4b/PHTUb
         vndmbwCn1cGK4No7VShj0/ZT73EVWpUbOKMizeiLkD6Q+dFD/7LW8TogpQrvm+Sr5L/z
         HQHygndC9Ba4NXIVSrPFmNK/z7UWmOJ3TA9kqmsCz3TKmk0hVeYYW1cti71S73PNdaR2
         H+H44aWxqPjKio1pftmynqZSsWAAPL6Ga3G5Q7m6NNJ3mbv3rvI9TWSKKVoxD++06ww7
         iG6g==
X-Gm-Message-State: AOAM532pF/qDwyqOh68ONnlIF4h/gIHBo5lD93EQ/pvuJOPESjmNgWuv
        vLLDGnR/ZBMi4AxQuABDW2l+YWiUXx69bo3z
X-Google-Smtp-Source: ABdhPJzqTJNefP/D3mmhJhCAWhHISrQDY3Y++LM3f9gy4mRZ+EHhKibmXbH5zUBeFmcCYWY1eTRuWA==
X-Received: by 2002:a63:510d:0:b0:39d:3f7d:2b0d with SMTP id f13-20020a63510d000000b0039d3f7d2b0dmr6023806pgb.448.1650022561697;
        Fri, 15 Apr 2022 04:36:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p10-20020a17090a680a00b001c7bf7d32f9sm4591165pjj.55.2022.04.15.04.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 04:36:01 -0700 (PDT)
Message-ID: <625958a1.1c69fb81.5672.c908@mx.google.com>
Date:   Fri, 15 Apr 2022 04:36:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.275-263-g4e8614ce07a95
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 88 runs,
 2 regressions (v4.14.275-263-g4e8614ce07a95)
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

stable-rc/queue/4.14 baseline: 88 runs, 2 regressions (v4.14.275-263-g4e861=
4ce07a95)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
 | 1          =

meson8b-odroidc1     | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.275-263-g4e8614ce07a95/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.275-263-g4e8614ce07a95
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4e8614ce07a959940326398d1bdae9cb3f711f2e =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/625820ec52a8552ae9ae067e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-263-g4e8614ce07a95/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-263-g4e8614ce07a95/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625820ec52a8552ae9ae0=
67f
        failing since 8 days (last pass: v4.14.271-23-g28704797a540, first =
fail: v4.14.275-206-gfa920f352ff15) =

 =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson8b-odroidc1     | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/625820e276525e0de7ae0681

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-263-g4e8614ce07a95/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-263-g4e8614ce07a95/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625820e276525e0de7ae0=
682
        failing since 60 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
