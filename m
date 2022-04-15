Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B13EB502FD8
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 22:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351425AbiDOUnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 16:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242926AbiDOUnu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 16:43:50 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472DAD53
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 13:41:21 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id k62so2421096pgd.2
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 13:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fMX6ukNoIG+lgD46ZPSP6NZSP7ksoJf710x+zxxCegY=;
        b=6iFybQ22E3e7juk9Kyj2M/pe4LviBw/8U198sM7V7+wO8kY1imIL5H7ptLcbCCZNi2
         6JIiDlHJnyWdx0La5dapBIRrcZ/6PfOsG0rE1dLhJSlZbf8UdslQ4/dBC7UrYZCeiD4t
         8yNlRtQ3Re79q9bLkvuVkmWkcDnTHkXm1cAILgnG1WiFCB5Flby7mLnOmPtFOIW3Ico2
         EozxMYco+55c/cJX3rWwVb/RYdFklHLlXlaaQqYUNvqzXerGouNpmCRB0UNMbvOMQMlD
         6NcwoMQzN4mnQ4z2fA7CONo5RZkGtycVDQON3w5wUdjS4sr2QPNL7HWSPp5oa2NF2QPM
         tgXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fMX6ukNoIG+lgD46ZPSP6NZSP7ksoJf710x+zxxCegY=;
        b=Sv0ER2aiSnWkNRme47oT/XFG+XIosft7a3+5ttaMIrm0ziND61KnNGisnxn5btgFi5
         V/gpR5kiyQ18Mff5CJobabjMxnujVCrXQEPIYE8JT+9i/c6s7UBO8gwSoBV+CJdBOoaI
         aL68wUIa1zw0eRChGd7arF3N6HR+aH/fFKjfR1L4a2Uq25VX2xvCVNePHspVg+BxpanX
         jq63xA1Ad9ow5Vbz4twzuUjE9gQw7AcEWln+2yCiWly/5xfhnwWp6hvAZaOVIc3GaeEf
         NQSaO827qgNWf+jMm2o0/GyyzTLl9VSaRwS43lEq83/vxkO2xEcp+Ajz2MPwZHc0l66R
         ezDg==
X-Gm-Message-State: AOAM532d+h7oXNQvipl/0uPkcMCRj+U6Zy5wNXgbPOPvYxO1WpzAVZv3
        1GsCXAMEz2Vs8yXzbT11TsJL5c6NqKUDJqfu
X-Google-Smtp-Source: ABdhPJxPlqkn9srDtaJChLvTrRdZF+xgypJmByiiZMMnyK74S1z+kUy/qlZf0pEbZx2CvzN//ZGIAA==
X-Received: by 2002:a63:ec0c:0:b0:39d:3aa6:4513 with SMTP id j12-20020a63ec0c000000b0039d3aa64513mr584584pgh.391.1650055280671;
        Fri, 15 Apr 2022 13:41:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g15-20020aa7818f000000b00505ce2e4640sm3586867pfi.100.2022.04.15.13.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 13:41:20 -0700 (PDT)
Message-ID: <6259d870.1c69fb81.8048f.9d0c@mx.google.com>
Date:   Fri, 15 Apr 2022 13:41:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.189
X-Kernelci-Report-Type: test
Subject: stable/linux-5.4.y baseline: 94 runs, 2 regressions (v5.4.189)
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

stable/linux-5.4.y baseline: 94 runs, 2 regressions (v5.4.189)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.189/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.189
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e7f5213d755bc34f366d36f08825c0b446117d96 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/6259a858103366195cae0689

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.189/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.189/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6259a858103366195cae0=
68a
        new failure (last pass: v5.4.184) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6259a6877658b318e4ae0694

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.189/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-kev=
in.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.189/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-kev=
in.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6259a6877658b318e4ae06b6
        failing since 37 days (last pass: v5.4.181, first fail: v5.4.183)

    2022-04-15T17:08:00.019404  /lava-6099839/1/../bin/lava-test-case
    2022-04-15T17:08:00.027659  <8>[   33.068553] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
