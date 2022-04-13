Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72AD14FF7AE
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 15:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbiDMNfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 09:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiDMNfU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 09:35:20 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0BB53A48
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 06:32:59 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id p8so2010194pfh.8
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 06:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=warlgAnT7/qjrA7tjJrVfzaAkamRbKdC9VzsWHCowRs=;
        b=PnOioBz3x+je1lK024JLlXLRQ+w8N6zzSAJZK/M7fcIPyPLORXXc9J8kBVJ0CZWURm
         JgC+xoMSWVBvZxhjg/5PP/vMTbLoQv3YWz0cvC6/vIbzc3ngTxtPcdoRllnAfICO6jmr
         7LMkfoTPhQVOCOhLDkkKKYNwEtXPXDU+Yy2OhkukTY7A+UJ4+t2kOlD/A2VYLfW//w8g
         1VO8sBxToA/fO1jW14vbcfw1z1vhrCebldR/3OmeCM8BbJDYIq17kyPUfwuAszR83+pd
         nFtyJlI/aW7zYPVkcCKHq0alWC5+518/WQTs1Omxp6qwb64NJHjSoYLukpPbR/azR6X8
         y0hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=warlgAnT7/qjrA7tjJrVfzaAkamRbKdC9VzsWHCowRs=;
        b=KWnqPjDgNsRxc5Hzqm9QXa3J5v7j9lyys5dQ51P+rXduIPId+TNRVG8zx9RoyqjVv3
         wFBQjZrXKcy+YaQNONLkdhs7JqfX9E/CqIM9xcCVWpabm5FxsgQnqUV+40NjNp0yKYdI
         G7RbAcrUY6OxXaecA6kfys2nuLq8f2sws95wZvSEeiqKfxsgSyFxHiN1wPcUAcOWUQf5
         VnY1BwZLjLxa8+iMzg+zVgVxY1J+f4t7C0uoAvcDkgU0wOaDNuJUEk9kP43/cgbIEGoY
         KZxS7KEqFl/Yt0Tokerm+KBvsmdX/WWH+O7NJCxKccBXIiDwuBtq34oKR+9yvPbBMJLB
         vbNQ==
X-Gm-Message-State: AOAM5320678BeQk2jf7fjb3X2dAk0vntujtKvDS/OlyfH6pPx2xU7yWk
        qeC1AjdRI/odxANA3q+pU/Q6NmWERtV8gJIu
X-Google-Smtp-Source: ABdhPJzVasTg4r3Bkxb35hPl3e3dSyyIjoSfX5f1KzvszqM+KUB+5kTQSFS6c/3SNkbFTrCZ2kNa+Q==
X-Received: by 2002:a63:2586:0:b0:39d:904b:3ee5 with SMTP id l128-20020a632586000000b0039d904b3ee5mr7596734pgl.455.1649856779124;
        Wed, 13 Apr 2022 06:32:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004cdccd3da08sm44736263pfl.44.2022.04.13.06.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 06:32:58 -0700 (PDT)
Message-ID: <6256d10a.1c69fb81.cf524.2ae3@mx.google.com>
Date:   Wed, 13 Apr 2022 06:32:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.237-331-gb63dff3b68a8
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 83 runs,
 3 regressions (v4.19.237-331-gb63dff3b68a8)
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

stable-rc/linux-4.19.y baseline: 83 runs, 3 regressions (v4.19.237-331-gb63=
dff3b68a8)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.237-331-gb63dff3b68a8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.237-331-gb63dff3b68a8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b63dff3b68a81f77d2316dd38557c08045a5c026 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/6256a09c0c594fdd29ae06d4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37-331-gb63dff3b68a8/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxb=
b-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37-331-gb63dff3b68a8/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxb=
b-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6256a09c0c594fdd29ae0=
6d5
        failing since 7 days (last pass: v4.19.235-23-g354b947849d2, first =
fail: v4.19.235-58-ga78343b23cae) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/6256a0d68a7c46c970ae06a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37-331-gb63dff3b68a8/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl=
-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37-331-gb63dff3b68a8/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl=
-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6256a0d68a7c46c970ae0=
6a3
        failing since 1 day (last pass: v4.19.234-30-g4401d649cac2, first f=
ail: v4.19.237) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62569f2e10aab896f0ae068b

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37-331-gb63dff3b68a8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37-331-gb63dff3b68a8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62569f2e10aab896f0ae06ad
        failing since 37 days (last pass: v4.19.232, first fail: v4.19.232-=
45-g5da8d73687e7)

    2022-04-13T09:59:52.251676  =

    2022-04-13T09:59:53.263273  /lava-6075042/1/../bin/lava-test-case
    2022-04-13T09:59:53.271554  <8>[   36.800188] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
