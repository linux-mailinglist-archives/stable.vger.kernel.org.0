Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADDB3DD117
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 09:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbhHBHWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 03:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbhHBHWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 03:22:19 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C3BC06175F
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 00:22:09 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso23375988pjf.4
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 00:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hjJXz+A7KAvLk92UcwHzOdHIct9oHGXXCICM5JITRLQ=;
        b=McSykT4TXE7gMhYBJ7ipdz0fKRzWAsMuSW+J6r3G1LzsZpZH1dD7+EXr+K5kyXX34G
         AhYaNO9OdnGzZMWVfiUmGH1uA6f6QTvE/gUzYhu7Ivon8rF9GNclruT57c1wVYEcHeDd
         aVBvcZkJYOrakA+3SrpBtIpcZUh4nOodcrMQzSGIWrcEeFkA4IxZIbY/C9LMjwMuHGP/
         MjOUI+/ozvALDg7DDKGk718pn23JlBGq1fAHmEfvx8Da6bp/32Hf4TqKSOq/RWg00fqG
         7YLYqgwuUlpx5iCp1pl/+aNXdlGI8a/2Iw/pqO8oEyl+fE447a2zYuvjo9BRKsjfafdS
         0zeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hjJXz+A7KAvLk92UcwHzOdHIct9oHGXXCICM5JITRLQ=;
        b=uaMHZb2gSmZ1g60zFuuQUMR5fHTUbCUrNOqGLgpPXFbgQzzLOjm1vVjAsZj3tfp2Or
         grngXs8wJ3Va8XcygTLbSt2RHVl8C/rITXNVOvn7EjXzRtx6+o3xqAJ28fW0OT4yUAEk
         HABD/bmtkgxcI9uba3ybhb93PpGAVCXAkYdObGjUw9bnSvWJigPFuzvnmn1H9OWR9Qqq
         LqWbLfYbk72zPhZgKh0qHpw7enHpA86fGrj2Uxl2rByM30EkY1Tv3ytJFrKqeeO/k97D
         hxhchHZVROl1fC66B0hkEI6B600J3U3Rsu65/ff025h8w7Hy8wAuCBhbKhIuBkb6Bi3w
         mh7g==
X-Gm-Message-State: AOAM533l3QrX+9oTdLaDV5nCiSyTnuFGJXBcIFA693OXzW8UuThUhlN+
        C9XvQEQT7wQR6jCp0bOM+nV/fRmYHTDkCT93
X-Google-Smtp-Source: ABdhPJzL9+897kVoInIiQvwvNzhF3Mvnky4hWoxibFSaOM2d06oygav8FrRugiZyXQBXOp6sx5sDvQ==
X-Received: by 2002:a05:6a00:1786:b029:32c:c315:7348 with SMTP id s6-20020a056a001786b029032cc3157348mr15606294pfg.42.1627888928884;
        Mon, 02 Aug 2021 00:22:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y14sm7786814pfa.166.2021.08.02.00.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 00:22:08 -0700 (PDT)
Message-ID: <61079d20.1c69fb81.36785.75ec@mx.google.com>
Date:   Mon, 02 Aug 2021 00:22:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.137-35-gf41d7703aea0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 193 runs,
 4 regressions (v5.4.137-35-gf41d7703aea0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 193 runs, 4 regressions (v5.4.137-35-gf41d770=
3aea0)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
imx6sll-evk       | arm  | lab-nxp       | gcc-8    | imx_v6_v7_defconfig |=
 1          =

rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig  |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.137-35-gf41d7703aea0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.137-35-gf41d7703aea0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f41d7703aea0714f1d0ca78cf96ebc57f71f39a6 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
imx6sll-evk       | arm  | lab-nxp       | gcc-8    | imx_v6_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/61076c4f720b3d6d2685f45f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.137-3=
5-gf41d7703aea0/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sll-evk.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.137-3=
5-gf41d7703aea0/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sll-evk.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61076c4f720b3d6d2685f=
460
        new failure (last pass: v5.4.137-35-g8b67247ad78e) =

 =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig  |=
 3          =


  Details:     https://kernelci.org/test/plan/id/61077a0f7fd966d98685f45b

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.137-3=
5-gf41d7703aea0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.137-3=
5-gf41d7703aea0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61077a0f7fd966d98685f46f
        failing since 48 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-02T04:52:11.442095  /lava-4303352/1/../bin/lava-test-case<8>[  =
 15.101153] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-08-02T04:52:11.442495  =

    2021-08-02T04:52:11.442696  /lava-4303352/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61077a0f7fd966d98685f487
        failing since 48 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-02T04:52:10.019046  /lava-4303352/1/../bin/lava-test-case<8>[  =
 13.677371] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-08-02T04:52:10.019388  =

    2021-08-02T04:52:10.019583  /lava-4303352/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61077a0f7fd966d98685f488
        failing since 48 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-02T04:52:08.981216  /lava-4303352/1/../bin/lava-test-case
    2021-08-02T04:52:08.986966  <8>[   12.657599] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
