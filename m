Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13F1403FDB
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 21:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235043AbhIHTgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 15:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351300AbhIHTgG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 15:36:06 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F52DC061575
        for <stable@vger.kernel.org>; Wed,  8 Sep 2021 12:34:58 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d17so1932158plr.12
        for <stable@vger.kernel.org>; Wed, 08 Sep 2021 12:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LRbgzmTYHa2YcCI3RUHEOITDZO6VZBAAQdoGx8sS3A8=;
        b=bX2YvPx7to1XDcLJYNe9qIIEcTlzvgCTt5W6ADDqOXhXhmLFRoUFZZbLjHA8KMaoNv
         yyk/zj8pZDIZeI3MyVpcbSl30y8IMYzGAlSzBfzMRXZaksoouwcBZVQfubgfcK/kNOML
         Wkrcs8wMaLIuXY1AvhL4D3jW6jwyul1pIClerFeAc9ZYRZ/QhYstlos6wxzuT1RoXRAj
         adCR2iVhfW8goVfdh3yYKqNM83/Xgd18arXKTCnZgsj7lcyDic11TAsHeGsq8jRSRytX
         pEROiwY0cZzWV2DgjmlwzA49AODYnBrvwJ2atn9YdFNQ/p2uEyHcNPpIPCQwMP4Zl2li
         JEtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LRbgzmTYHa2YcCI3RUHEOITDZO6VZBAAQdoGx8sS3A8=;
        b=AI/CiYLq5fIfXTUvVc9aLtW29DDmdrdE1xW2jrfK3DanJV+UfngK+V96U0ff4lrqkc
         H9OWZry6ZvbJsvxNwv060lIZQ0pvUfUQUQphW8zL3OaJsN0OU7xKldOWs0D5foKKhixd
         e0z+XMJ6pAW7K0R/Hz5KLh7+jT2bFsMb/PrHoJsdrCpj91GZI84GXtF6BdM7kcf+VULa
         aT82aGasS5Ke7U9K4vmduo+a2TmWcyjcOjeadjoKPuNUvSgqk3NTfVFwZyYFbVcjtxAv
         Y8erO1qZ+9/CWOyyNN/y5OGieJ3YdVPW8ibGaTkcyro9hHl0Ro0Hl1C2EKbxZr6xGVlQ
         8pPA==
X-Gm-Message-State: AOAM533KuTlfqx1+GYX5tfIf3ySzAC+TepW+E/56uvCN/aJsOjIaMCdF
        o0r82PJ9ChCDEZMmmeDEgoRnQ6NNbNq0moO5
X-Google-Smtp-Source: ABdhPJxXxmnuFzdlKVtWIxnzcOsfDsHKre6+0mdBgf8lS/+ThvgRga3qQPHMDTk46xpC/4GhYBS9Xw==
X-Received: by 2002:a17:902:7c93:b0:13a:a1e:dd2d with SMTP id y19-20020a1709027c9300b0013a0a1edd2dmr4559283pll.12.1631129697445;
        Wed, 08 Sep 2021 12:34:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l10sm3893795pgn.22.2021.09.08.12.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 12:34:57 -0700 (PDT)
Message-ID: <61391061.1c69fb81.3c6d.b82a@mx.google.com>
Date:   Wed, 08 Sep 2021 12:34:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.63-10-g45db3e3f3289
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 144 runs,
 3 regressions (v5.10.63-10-g45db3e3f3289)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 144 runs, 3 regressions (v5.10.63-10-g45db3e=
3f3289)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.63-10-g45db3e3f3289/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.63-10-g45db3e3f3289
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      45db3e3f32897f5809bbca67d79f7418a97ed83b =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6138f96933b0485190d59665

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
10-g45db3e3f3289/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
10-g45db3e3f3289/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6138f96933b0485190d59679
        failing since 85 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-08T17:56:41.655606  /lava-4477793/1/../bin/lava-test-case<8>[  =
 14.052468] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-09-08T17:56:41.656286  =

    2021-09-08T17:56:41.656873  /lava-4477793/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6138f96933b0485190d59691
        failing since 85 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-08T17:56:40.214468  /lava-4477793/1/../bin/lava-test-case
    2021-09-08T17:56:40.231461  <8>[   12.628437] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6138f96933b0485190d59692
        failing since 85 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-08T17:56:39.194650  /lava-4477793/1/../bin/lava-test-case
    2021-09-08T17:56:39.201513  <8>[   11.609174] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
